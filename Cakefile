{spawn} = require 'child_process'
os = require 'os'

cmd = (name) ->
	if os.platform() is 'win32' then name + '.cmd' else name

npm = cmd 'npm'
brunch = cmd 'brunch'
karma = cmd 'karma'

task 'install', 'Install node.js packages', ->
	spawn npm, ['install'], {cwd: '.', stdio: 'inherit'}

task 'update', 'Update node.js packages', ->
	spawn npm, ['update'], {cwd: '.', stdio: 'inherit'}
	
task 'build', 'Build brunch project', ->
	brunch = spawn brunch, ['build'], {cwd: '.', stdio: 'inherit'}

task 'watch', 'Watch brunch project', ->
	brunch = spawn brunch, ['watch', '--server'], {cwd: '.', stdio: 'inherit'}
	brunch.on 'exit', (status) -> process.exit(status)

task 'test', 'Build brunch project and run karma once', ->
	brunch = spawn brunch, ['build'], {cwd: '.', stdio: 'inherit'}
	brunch.on 'exit', (status) -> 
		if status is 0
			karma = spawn karma, ['start', '--single-run'], {cwd: '.', stdio: 'inherit'}
			karma.on 'exit', (status) ->
				process.exit(status)
		else
			process.exit status

task 'test-watch', 'Watch brunch and karma project', ->
	brunch = spawn brunch, ['watch'], {cwd: '.', stdio: 'inherit'}
	brunch.on 'exit', (status) -> process.exit(status)
	setTimeout ->
		karma = spawn karma, ['start'], {cwd: '.', stdio: 'inherit'}
		karma.on 'exit', (status) ->
			brunch.kill()
			process.exit(status)
	, 1500
