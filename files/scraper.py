#!/bin/python
# -*- coding: utf-8 -*-
# Nicka Chkhikvishvili - 2019
import sys
import os
reload(sys)
sys.setdefaultencoding('utf8')
import re
from bs4 import BeautifulSoup
import tempfile
from BaseHTTPServer import BaseHTTPRequestHandler,HTTPServer
PORT_NUMBER = 8080


# This class will handles any incoming request from
# the browser
class myHandler(BaseHTTPRequestHandler):

    # Handler for the GET requests
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        # Send the html message
        try:
            file_name, filename = tempfile.mkstemp()
            os.system(
                "/usr/bin/google-chrome --no-sandbox  --headless --disable-gpu --dump-dom 'https://www.cryptocompare.com/' >"+filename+" 2>&1")
            fil = open(filename)
            html = fil.read()
            bs = BeautifulSoup(html, "html.parser")
            table = bs.find("table", {"class": "table table-coins table-hover table-homepage mt"})
            rows = table.findAll('tr')
            price_regex = re.compile('current-price-value.*')
            for row in rows:
                span = [s.next_element.strip() for s in row.findAll("span", {"class": "mobile-name ng-binding"})]
                div = row.findAll("div", {"class": price_regex})
                div = [x.next_element.strip() for x in div]
                span = [str(x.encode('ascii')) for x in span]
                div = [str(x.encode('ascii')) for x in div]
                for x in span:
                    div[0] = div[0].translate(None, '$,')
                    self.wfile.write( "# HELP " + x.lower() +" " + x.lower() + "\n# TYPE" + " " + x.lower() + " gauge\n")
                    self.wfile.write( x.lower().strip() + " " + div[0].strip() + "\n")
        except:
            pass
        finally:
            fil.close()
            os.remove(filename)
        return


try:
    # Create a web server and define the handler to manage the
    # incoming request
    server = HTTPServer(('', PORT_NUMBER), myHandler)
    print 'Started httpserver on port ', PORT_NUMBER

    # Wait forever for incoming htto requests
    server.serve_forever()

except KeyboardInterrupt:
    print '^C received, shutting down the web server'
    server.socket.close()



