#!/usr/bin/env node
/**
 * Simple webserver with logging. By default, serves whatever files are
 * reachable from the directory where node is running.
 */

/* Anitnode dependencies */
var fs = require('fs'),
antinode = require('./lib/antinode'),
sys = require('sys');

/* CloudTunes dependencies */
var querystring = require('url');
var spawn = require('child_process').exec;

/* CONSTANTS */
var APACHE_HOST_URL = 'emma.baileycarlson.net';
var DATA_SOURCE_EXE = 'MDAudioJSON';

/* CloudTunes preprocessor */
preprocess_request = function(req, res, process_request) {
	var query = querystring.parse(req.url, true).query;
	var strQuery = query && query['q'] ? query['q'] : "";
	if (req.url.search(/\/music.*/) == -1) {
		/* non json request, serve using antinode webserver */
		process_request(req, res);
	}
	else if (query && query['i'])
	{
		// Get path of file to serve
		var index = parseInt(query['i']);
		if (typeof(index) === "number")
		{
			console.log(index);
			var cmd = DATA_SOURCE_EXE + ' -i ' + index + ' ' + strQuery;
			console.log(cmd);
			var pathJSON = spawn(cmd, function(error, data, stderr) {
				var filepath = JSON.parse(data).path;
				console.log('Retrieving resource: ' + filepath);
				// Serve the filepath returned from external datasource
				antinode.serve_static_file(filepath, req, res);		
			});
		}
	}
	else
	{
		/* Library DataSource JSON being requested */
		console.log(strQuery);
		var audioJSON = spawn(DATA_SOURCE_EXE + ' ' + strQuery);
		console.log('spawned pid ' + audioJSON.pid);
		res.writeHead(200, {'Content-Type:': 'text/json'});
		audioJSON.stdout.on('data', function (data) {
			res.write(data);
			console.log(data);
		});  	
		audioJSON.on('exit', function(code) {
			res.end('');
			console.log('process quit: ' + audioJSON.pid);
		});
	}
	
};

fs.readFile(process.argv[2] || './settings.json', function(err, data) {
    var settings = {};
    if (err) {
        sys.puts('No settings.json found ('+err+'). Using default settings');
    } else {
        try {
            settings = JSON.parse(data.toString('utf8',0,data.length));
        } catch (e) {
            sys.puts('Error parsing settings.json: '+e);
            process.exit(1);
        }
    }
	settings.request_preprocessor = preprocess_request;
    antinode.start(settings);
});


