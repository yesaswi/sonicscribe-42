import pytest
from functions.process_audio.main import process_audio
from flask import Request
from werkzeug.test import EnvironBuilder


@pytest.fixture
def mock_flask_request():
    builder = EnvironBuilder(
        path='/',
        method='POST',
        data=b'{"message": "Hello world!"}',
        content_type='application/json'
    )
    env = builder.get_environ()
    return Request(env)


def test_process_audio(mock_flask_request):
    response = process_audio(mock_flask_request)
    assert response == ({"message": "Hello world!"}, 200)
