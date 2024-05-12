import os
import logging

import flask
from flask import jsonify
from flask.typing import ResponseReturnValue
from google.cloud import storage
from pydub import AudioSegment
import functions_framework
from pydub.exceptions import CouldntDecodeError

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@functions_framework.http
def process_audio(request: flask.Request) -> ResponseReturnValue:
    try:
        # Extract necessary parameters from the request
        audio_file = request.files.get('audio')
        if audio_file is None:
            return {'error': 'Audio file not provided'}, 400

        # Construct the filename for the audio file in Cloud Storage
        audio_filename = audio_file.filename

        # Save the audio file to a temporary location
        temp_audio_path = f'/tmp/{audio_filename}'
        audio_file.save(temp_audio_path)

        # Validate the audio file format
        try:
            audio = AudioSegment.from_file(temp_audio_path)
        except CouldntDecodeError as e:
            logger.error(f"Could not decode audio file: {temp_audio_path} - {e}")
            return {'error': 'Invalid audio file format'}, 400

        # Save the audio file to Cloud Storage
        storage_client = storage.Client()
        bucket_name = os.environ.get('AUDIO_BUCKET_NAME')
        if bucket_name is None:
            logger.error("STORAGE_BUCKET environment variable not set")
            return {'error': 'Internal Server Error'}, 500

        bucket = storage_client.bucket(bucket_name)
        audio_blob = bucket.blob(audio_filename)
        audio_blob.upload_from_filename(temp_audio_path)

        # Remove the temporary audio file
        os.remove(temp_audio_path)

        return {'message': 'Audio file uploaded successfully'}, 200

    except Exception as e:
        logger.exception(f'An error occurred during audio processing - {e}')
        return {'error': 'Internal Server Error'}, 500
