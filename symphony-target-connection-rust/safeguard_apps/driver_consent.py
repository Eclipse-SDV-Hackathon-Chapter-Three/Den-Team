
from bottle import *
import os
import json
import time

@get('/question')
def question(): 
    html = '''
    <!DOCTYPE html>
    <html>
    <head>
    <title>Driver Consent</title>
    </head>
    <body>
        <h2>
            Driver Consent
        </h2>
        <form action="/submit" method="post">
            <div style="margin:20px">
                <input type="hidden" name="driver_consent" value="Approve Update">
                <input type="submit" value="Approve Update">
            </div>
        </form>

        <form action="/submit" method="post">
            <div style="margin:20px">
                <input type="hidden" name="driver_consent" value="Reject Update">
                <input type="submit" value="Reject Update">
            </div>
        </form>
    </body>
    </html>
    '''
    return html

@route('/submit', method='POST')
def do_submit():
    ret = request.forms.get('driver_consent')
    # Save result to JSON file
    approval_record = {
        "Timestamp": int(time.time()),
        "DriverConsent": ret
    }
    folder = "approval_consent"
    os.makedirs(folder, exist_ok=True)
    filepath = os.path.join(folder, "driver_approval.json")
    with open(filepath, "w") as f:
        json.dump(approval_record, f, indent=2)

    html = '''
    <!DOCTYPE html>
    <html>
    <head>
    <title>Driver Consent Result</title>
    </head>
    <body>
        {result}
        <p>Consent saved to approval_consent/driver_approval.json</p>
    </body>
    </html>
    '''.format(result=ret)
    return html

if __name__ == '__main__':
    run(host="0.0.0.0",port=8080,debug=True) 