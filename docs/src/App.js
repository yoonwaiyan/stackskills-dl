import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';

import marked from 'marked';
import Article from './Article';

class App extends Component {
  state = {
    markdown: ''
  };

  componentWillMount() {
    const readmePath = require('./posts/README.md');

    fetch(readmePath)
      .then(response => {
        return response.text();
      })
      .then(text => {
        this.setState({
          markdown: marked(text)
        });
      });
  }

  render() {
    const { markdown } = this.state;

    return (
      <div className="App">
        <Article markdown={markdown} />
      </div>
    );
  }
}

export default App;
