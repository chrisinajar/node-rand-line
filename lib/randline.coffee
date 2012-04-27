 #
 # Copyright 2012
 # 
 # Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 # 
 # The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 #

fs = require 'fs'
flow = require 'jar-flow'

class RandLine
	constructor: (filename)->
		@filename = filename
		@semaphore = 0

	line: (cb)->
		self = @
		if (self.semaphore > 1000)
			return process.nextTick ->
				self.line(cb)
		self.semaphore++
		flow.exec ->
				fs.stat self.filename, @
			, (err, stats)->
				if err
					return cb(err)
				
				chunk_range = stats.size - 1024
				options = {}
				if chunk_range > 0
					options.start = Math.round(Math.random()*chunk_range)
					options.end = options.start + 1024
				
				stream = fs.createReadStream self.filename, options
				finalString = ''
				stream.on 'data', (d)->
					ar = d.toString().split(/\r?\n/)
					ar.splice(0, 1)
					ar.splice(ar.length-1, 1)
					
					stream.destroy()
					self.semaphore--
					
					cb?(ar[Math.round(Math.random()*(ar.length-1))])


module.exports = RandLine
