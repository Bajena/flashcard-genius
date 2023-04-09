# Flashcard Genius
[![Build Status](https://travis-ci.com/Bajena/flashcard-genius.svg?branch=master)](https://travis-ci.com/Bajena/flashcard-genius)

An app for managing sets of language learning flashcards. Built using [Hanami](https://guides.hanamirb.org/) Ruby framework and [PaperCSS](https://www.getpapercss.com/) framework.

![image](https://user-images.githubusercontent.com/5732023/88967360-fdf3a600-d2ad-11ea-93c5-4cc5c11d43a0.png)

## Setup

Before you start make sure that you export following ENV variables:
- `GOOGLE_CLIENT_ID` - Google OAuth application's client ID
- `GOOGLE_CLIENT_SECRET` - Google OAuth application's secret key
- `GTM_ID` - Google Tag Manager ID

How to run tests:

```
% bundle exec rake 
```

How to run the development console:

```
% bundle exec hanami console
```

How to run the development server:

```
% bundle exec hanami server
```

How to prepare (create and migrate) DB for `development` and `test` environments:

```
% bundle exec hanami db prepare

% HANAMI_ENV=test bundle exec hanami db prepare
```


