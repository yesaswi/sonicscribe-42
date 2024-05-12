import flask
import functions_framework


@functions_framework.http
def process_audio(request: flask.Request) -> flask.typing.ResponseReturnValue:
    data = request.json
    return data, 200
