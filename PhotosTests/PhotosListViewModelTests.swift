//
//  PhotosListViewModelTests.swift
//  PhotosTests
//
//  Created by Elizaveta Konysheva on 24.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import XCTest
@testable import Photos

final class PhotosListViewModelTests: XCTestCase {
    var sut: PhotosList.ViewModel!
    var apiMock: APIMock!
    var imageCacheMock: ImageCacheMock!
    var photoSelected: Int!

    override func setUp() {
        apiMock = APIMock()
        imageCacheMock = ImageCacheMock()

        let handlers = PhotosList.Handlers(
            photoSelected: { self.photoSelected = $0 }
        )
        sut = PhotosList.ViewModel(
            context: PhotosList.Context(
                api: apiMock,
                imageCache: imageCacheMock),
            handlers: handlers
        )
    }

    override func tearDown() {
        photoSelected = nil
        apiMock = nil
        imageCacheMock = nil
        sut = nil
    }

    func test_afterInt_apiIsNotCalled() {
        XCTAssertEqual(apiMock.callCount, 0)
    }

    func test_afterLoadItems_apiCalled() {
        sut.loadItems()

        XCTAssertEqual(apiMock.callCount, 1)

        var photosEnpointInvoked: Bool {
            if case .getPhotos = apiMock.endpointInvoked {
                return true
            }
            return false
        }
        XCTAssertTrue(photosEnpointInvoked)
    }

    func test_whenApiReturnsSuccess_correctOutputReturned() {
        let photoMock = Photo.mock()
        apiMock.answer(with: .success( [photoMock] ))

        var receivedItemsCallback: Bool?
        var receivedErrorCallback: Bool?

        sut.output = PhotosList.Output(
            photoItems: { items in
                XCTAssertEqual(items.count, 1)
                XCTAssertEqual(items[0].id, photoMock.id)
                receivedItemsCallback = true
        }, error: { error in
            receivedErrorCallback = true
        })

        sut.loadItems()

        XCTAssertEqual(receivedItemsCallback, true)
        XCTAssertEqual(receivedErrorCallback, nil)
    }

    func test_whenApiReturnsError_correctOutputReturned() {
        apiMock.answer(with: .failure(NetworkError.noConnection))

        var receivedItemsCallback: Bool?
        var receivedErrorCallback: Bool?

        sut.output = PhotosList.Output(
            photoItems: { items in
                receivedItemsCallback = nil
        }, error: { error in
            XCTAssertEqual(error, "Your device is offline")
            receivedErrorCallback = true
        })

        sut.loadItems()

        XCTAssertEqual(receivedItemsCallback, nil)
        XCTAssertEqual(receivedErrorCallback, true)
    }

    func test_whenPhotoSelected_handlerIsCalled() {
        let photoMock = Photo.mock()
        let testModel = PhotoCellViewModel(photo: photoMock, imageCache: imageCacheMock)

        sut.photoSelected(testModel)

        XCTAssertEqual(photoSelected, testModel.id)
    }
}
