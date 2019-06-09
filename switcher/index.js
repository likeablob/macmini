const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');
const express = require('express');
const app = express();

const shPath = './sh.d';

class Runner {
  constructor() {
    this.files = fs
      .readdirSync(shPath)
      .filter(v => /.sh$/.test(v))
      .map(v => path.join(shPath, v));
    console.log('loaded scripts:', this.files);
    this.currentTarget = null;
  }
  psleep(ms) {
    return new Promise(resolve => {
      setTimeout(resolve, ms);
    });
  }
  kill(sig = 'SIGINT') {
    try {
      process.kill(-this.currentTarget.pid, sig || 'SIGINT');
    } catch (e) {
      console.error(e);
    }
  }
  spawn(target) {
    return new Promise(resolve => {
      const child = spawn(target, {
        sid: true,
        detached: true,
      });
      const tag = `${target}:`;
      child.stdout.on('data', data => {
        console.log(tag, data.toString().trim());
      });
      child.stderr.on('data', data => {
        console.log(tag, data.toString().trim());
      });
      child.on('close', code => {
        console.log(tag, 'close');
        resolve(code);
      });
      child.on('exit', code => {
        console.log(tag, 'exit');
        this.kill();
        resolve(code);
      });
      this.currentTarget = child;
    });
  }
  async runner() {
    let counter = 0;
    while (true) {
      const target = this.files[counter++ % this.files.length];
      console.log('running', target);
      await this.spawn(target).catch(err => {
        console.error(err);
      });
    }
  }
  start() {
    this.runner();
  }
}

const runner = new Runner();
runner.start();

const onExit = () => {
  console.log('exitting');
  runner.kill();
  process.exit(0);
};

process.on('SIGTERM', onExit);
process.on('SIGINT', onExit);

app.get('/', (req, res) => {
  const sig = req.query.force ? 'SIGKILL' : null;
  runner.kill(sig);
  res.sendStatus(200);
});

const port = process.env.PORT || 5501;
app.listen(port, 'localhost', () => console.log('listening on', port));
