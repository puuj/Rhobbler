# Rhobbler

The dead simple tool to submit your Rhapsody listening information to Last.FM.

## About this project

This is the source code to "Version 2" of the Rhobbler site as seen at [rhobbler.com](http://rhobbler.com).

Version 2 replaced the old version as of December 2011. Version 2 is a
complete rewrite of the original system, necessitated by a completely
new Last.fm scrobbling API and the phase-out of Rhapsody's RSS listening
history feeds.

## About the code

Rhobbler is a fairly basic Rails application, currently on Rails 3.2
beta/rc and targeted towards Ruby 1.9.2.

On the client-side it is very simple, using only one controller
with the basic CRUD actions and no javascript. Templating is done with
mustache ("stache" gem) and css is precompiled with Sass / SCSS.

On the back-end it is a little more complex. The background tasks are
managed by Resque. Two main tasks are performed regularly in the
background. One fetches listening history from Rhapsody and stores the
listen data in the database. The other reads the listen data and submits
it to last.fm.

If you'd like to contribute, please fork the project and send a pull
request.

## License

(The MIT License)

Copyright (c) 2011 Erik Peterson

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of 
the Software, and to permit persons to whom the Software is furnished to do so, 
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS 
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

