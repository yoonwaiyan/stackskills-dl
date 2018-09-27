import React from 'react';
import './Article.css';

const Article = ({ markdown }) => (
  <section>
    <article class="article" dangerouslySetInnerHTML={{ __html: markdown }} />
  </section>
);

export default Article;
