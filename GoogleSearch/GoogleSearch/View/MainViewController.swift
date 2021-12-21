//
//  ViewController.swift
//  GoogleSearch
//
//  Created by Egor Mikhalevich on 17.12.21.
//

import UIKit
import Speech
import AVKit

class MainViewController: UIViewController {
    private let stackView = UIStackView(axis: .vertical)

    private let searchBar = UISearchBar()
    private let searchButton = UIButton(title: "Google Search")
    private let progressIndicator = UIProgressView()

    private let resultList = UITableView()

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    private let network = NetworkManager.shared
    private let searchService = SearchService()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension MainViewController {
    @objc func searchButtonTapped() {
        updateButton()
    }

    func showProgressIndicator() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.progressIndicator.alpha = 1
            self?.progressIndicator.isHidden.toggle()
        }
    }

    func hideProgressIndicator() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.progressIndicator.alpha = 0
            self?.progressIndicator.isHidden.toggle()
        }
    }

    func updateButton() {
        guard let text = searchBar.text, !text.isEmpty else { return }
        searchBar.endEditing(true)
        if searchService.isActive {
            searchService.isActive.toggle()
            network.cancelTask()
            searchButton.backgroundColor = .systemBlue
            searchButton.setTitle(Text.search, for: .normal)
            searchService.results?.removeAll()
            resultList.reloadData()
        } else {
            searchService.isActive.toggle()
            searchButton.backgroundColor = .systemRed
            searchButton.setTitle(Text.stop, for: .normal)
            searchService.getResults(with: text)
            resultList.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let results = searchService.results else { return 0}
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let results = searchService.results else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseId, for: indexPath) as! Cell
        cell.configure(with: results[indexPath.row])
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScroll(y: scrollView.contentOffset.y)
    }

}

//MARK: - MainDelegate
extension MainViewController: MainDelegate {
    func fetchFinished() {
        searchService.isActive.toggle()
        searchButton.backgroundColor = .systemBlue
        searchButton.setTitle(Text.search, for: .normal)
        searchBar.placeholder = nil
    }
    
    func didChangeProgress(progress: Progress) {
        progressIndicator.observedProgress = progress
    }

    func showProgress() {
        showProgressIndicator()
    }

    func hideProgress() {
        hideProgressIndicator()
        resultList.reloadData()
    }

    func showError(text: String) {
        showAlert(message: text)
    }

    func scrollViewDidScroll(y: CGFloat) {
        if y != 0 {
            searchBar.endEditing(true)
        }
    }
}

//MARK: - Configure
private extension MainViewController {
    func configure() {
        setView()
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchBar.delegate = self
        searchService.delegate = self
        configureTable()
        configureSpeech()
    }

    func configureTable() {
        resultList.register(Cell.self, forCellReuseIdentifier: Cell.reuseId)
        resultList.dataSource = self
        resultList.delegate = self
        resultList.showsVerticalScrollIndicator.toggle()
        resultList.contentInset = .init(top: 10, left: 0, bottom: 50, right: 0)
    }

    func setView() {
        view.backgroundColor = .white

        // - ProgressIndicator
        progressIndicator.alpha = 0
        progressIndicator.setProgress(0, animated: true)

        // - SearchBar
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = nil
        let micImage = UIImage(systemName: "mic.fill")
        searchBar.setImage(micImage, for: .bookmark, state: .normal)

        // - StackView
        stackView.embedIn(view, top: 40, left: 10, right: 10)
        stackView.addArrangedSubviews(
            progressIndicator,
            searchBar,
            searchButton,
            resultList
        )
    }

    func configureSpeech() {
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in

            var isBtnShowed = false

            switch authStatus {
            case .authorized:
                isBtnShowed = true
            case .denied:
                isBtnShowed = false
                print("User denied access to speech recognition")
            case .restricted:
                isBtnShowed = false
                print("Speech recognition restricted on this device")
            case .notDetermined:
                isBtnShowed = false
                print("Speech recognition not yet authorized")
            @unknown default:
                print("Voice error")
            }
            OperationQueue.main.addOperation() {
                self.searchBar.showsBookmarkButton = isBtnShowed
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateButton()
        searchBar.endEditing(true)
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.searchBar.showsBookmarkButton = false
        } else {
            self.startRecording()
        }
    }
}

//MARK: - SFSpeechRecognizerDelegate
extension MainViewController: SFSpeechRecognizerDelegate {

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.searchBar.showsBookmarkButton.toggle()
        } else {
            self.searchBar.showsBookmarkButton.toggle()
        }
    }
}

// MARK: - Voice
private extension MainViewController {

    func startRecording() {

        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }

        recognitionRequest.shouldReportPartialResults = true

        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in

            var isFinal = false

            if result != nil {

                self.searchBar.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }

            if error != nil || isFinal {

                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                self.searchBar.showsBookmarkButton = true
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        self.audioEngine.prepare()

        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }

        self.searchBar.placeholder = Text.placeholder
    }
}

