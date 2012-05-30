From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Bcache v13 00/16]
Date: Wed, 30 May 2012 17:29:07 +0900
Message-ID: <20120530082907.GB32121@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1336619038.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Hello, Kent.

Here are my additional impressions after trying to read a bit more
from make_request.

* Single char variable names suck.  It's difficult to tell what type
  they are, what they're used for and makes it difficult to track
  where the variable is used in the function - try to highlight the
  variable name in the editor.

  While not a strict rule, there are reasons why people tend to use
  single char variable names mostly for specific things - e.g. loop
  variables, transient integral variables or in numerical context.
  They're either localized to small scope of code so keeping track of
  them is easy and/or people are familiar with such usages.

  So, I would *much* prefer if I don't have to keep trying to track
  what the hell c, d, k, j, l mean and where they're used.

* Due to the various style issues, lack of documentation and other
  abundant idiosyncrasies in the code, at least I find the code almost
  aggravating.  It's complicated, difficult to read and full of
  unnecessary differences and smart tricks (smart is not a positive
  word here).  I don't think we want code like this in the kernel.
  Hell, I would get pretty upset if I encounter this type of code
  while trying to update some block API.

* Maybe I haven't seen enough of it but my feeling about closure
  hasn't gone up.  It likely has gone further down.  It doesn't
  actually seem to solve the pain points of async programming while
  adding ample headaches.  The usages that I followed could be easily
  served by either domain-specific async sequencer or the existing ref
  / async / whatever mechanism / convention.  If you have good example
  usage in bcache, please feel free to explain it.

So, I don't know.  If this is a driver for some super obscure device
that would fall out of use in some years and doesn't interact with /
affect the rest of the kernel, maybe we can put it in with big giant
blinking red warnings about the dragons inside, but as it currently
stands I don't think I can ack the code base and am afraid that it
would need non-trivial updates to be upstreamable.

I'm gonna stop reading and, for now

 NACKED-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
