---
layout: post
title: Some background
published: true
author: dave
---

Here at Jetpac, there's always some sort of interesting engineering challenge on our plate. When we first started out, we were faced with trying to present users with only the great travel related photos from their friends on Facebook. This is a lot tougher than it sounds since the majority of photos posted to Facebook don't end up being all that great. Since we were a small team (only Chris and Pete at the time), this lead us to kick off a Kaggle competition to help build our foundation for a machine learning algorithm to give all the photos we see a quality score based on travel-ness.

After that we tackled a lot of the same problems that many startups face, scaling. We see an incredibly large amount of data pass through our servers (this is where Pete gets a little giddy over just how much data we have) and we need a way to handle the traffic and the photo data without the user being slowed down or really being aware of how much photo processing we were doing in order to give them the experience they were expecting.

One of my personal favourite engineering challenges has dealt with the way that the user interacts with their data. We are an iOS application but not a native application. We run an objective-c wrapper that just displays a series of HTML5 pages that are all powered by <a href="http://backbonejs.org/" target="_blank">BackboneJS</a> and Ruby. This means that we have to make sure that the app is responsive enough so that the user can carry on swiping and scrolling and touching like they would naturally do on an iPad. Given the amount of information we're trying to present to the user and the way we know our users interact and want to interact has meant a lot of tweaking and testing.

Currently we're in the process of trying to explorer all the various ways we can connect our users with their friends to help them make better travel decisions. Have they had any friends visit the country/city/hotel/venue as the one they're thinking about going to? Did they like it? What's it actually like? Would you go again? All the things that you would normally ask your friends when discussing travel. That's what we're trying to answer.

Welcome to the Jetpac Engineering Team blog. Where have your friends been and you haven't?