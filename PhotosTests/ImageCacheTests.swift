//
//  ImageCacheTests.swift
//  PhotosTests
//
//  Created by Elizaveta Konysheva on 24.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import XCTest
@testable import Photos

final class ImageCacheTests: XCTestCase {
    var sut: ImageCacheImpl!
    var imageLoaderMock: ImageLoaderMock!
    var imageStoreMock: ImageStoreMock!

    let testImage = UIImage(systemName: "rectangle")!

    override func setUp() {
        imageLoaderMock = ImageLoaderMock()
        imageStoreMock = ImageStoreMock()

        sut = ImageCacheImpl(
            imageStore: imageStoreMock,
            imageLoader: imageLoaderMock
        )
    }

    func test_whenImageInCache_loaderNotCalled() {
        let testUrl = URL(string: "https://via.placeholder.com/150/771796")!
        imageStoreMock.store = [testUrl as NSURL: testImage]

        var imageReturned = false

        sut.load(url: testUrl) { [weak self] image in
            guard let self = self else { return }
            imageReturned = true
            XCTAssertEqual(image, self.testImage)
        }

        XCTAssertEqual(imageStoreMock.getImageCalledCount, 1)
        XCTAssertEqual(imageStoreMock.setImageCalledCount, 0)
        XCTAssertEqual(imageLoaderMock.callCount, 0)
        XCTAssertTrue(imageReturned)
    }

    func test_whenImageNotInCache_loaderCalled() {
        let testUrl = URL(string: "https://via.placeholder.com/150/771796")!
        imageLoaderMock.answer = .success(testImage)

        var imageReturned = false

        sut.load(url: testUrl) { [weak self] image in
            guard let self = self else { return }
            imageReturned = true
            XCTAssertEqual(image, self.testImage)
        }

        XCTAssertEqual(imageLoaderMock.callCount, 1)
        XCTAssertEqual(imageLoaderMock.loadUrl, testUrl)
        XCTAssertTrue(imageReturned)
        XCTAssertEqual(imageStoreMock.setImageCalledCount, 1)
        XCTAssertEqual(imageStoreMock.store[testUrl as NSURL], testImage)
    }

    func test_whenMultipleCompletions_loaderCalledOnlyOnce() {
        let testUrl = URL(string: "https://via.placeholder.com/150/771796")!
        imageLoaderMock.answer = .success(testImage)

        var firstCompletionSucceed = false
        sut.load(url: testUrl) { _ in
            firstCompletionSucceed = true
        }

        var secondCompletionSucceed = false
        sut.load(url: testUrl) { _ in
            secondCompletionSucceed = true
        }

        XCTAssertEqual(imageLoaderMock.callCount, 1)
        XCTAssertTrue(firstCompletionSucceed)
        XCTAssertTrue(secondCompletionSucceed)
    }
}
