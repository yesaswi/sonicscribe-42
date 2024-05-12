# import pytest
# from functions.process_audio.main import process_audio
# from flask import Flask, request
# from werkzeug.datastructures import FileStorage
#
#
# @pytest.fixture
# def app():
#     app = Flask(__name__)
#     app.config['TESTING'] = True
#     return app
#
#
# @pytest.fixture
# def mock_request(app):
#     with app.test_request_context(method='POST', data={'audio': FileStorage(filename='jfk.wav',
#                                                                             content_type='audio/wav',
#                                                                             stream=open('tests/unit/jfk.wav', 'rb'))}):
#         yield request
#
#
# def test_process_audio(mock_request, mocker):
#     mocker.patch('functions.process_audio.main.storage.Client')
#     mocker.patch('functions.process_audio.main.os.environ.get', return_value='test-bucket')
#
#     response = process_audio(mock_request)
#     assert response[1] == 200
#     assert response[0]['message'] == 'Audio file uploaded successfully'
