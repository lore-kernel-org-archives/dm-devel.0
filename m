From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: dm-crypt: fix lost ioprio when queuing crypto bios from task
 with ioprio
Date: Sun, 18 Dec 2016 14:23:40 -0900
Message-ID: <20161218232340.r4rfnodd5gnxu7x6@kmo-pixel>
References: <alpine.LRH.2.11.1612141049250.13402@mail.ewheeler.net>
 <alpine.LRH.2.11.1612161414280.9898@mail.ewheeler.net>
 <20161217155800.GA6580@redhat.com>
 <20161218225406.eqbcn7fpg4cehjb6@kmo-pixel>
 <20161218231755.GA14929@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161218231755.GA14929@redhat.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Eric Wheeler <dm-devel@lists.ewheeler.net>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Sun, Dec 18, 2016 at 06:17:55PM -0500, Mike Snitzer wrote:
> Spinning it as a pure bugfix is a reach (as Eric's header documents the
> patch, the case is weak for cc'ing stable).  Reality is the change is
> needed to enable a new bcache feature.  I'm not going to rush
> feature-enabling change that arrived in the last minute.

I do agree that it can wait for 4.11 and isn't a candidate for stable, I
should've said that earlier.

> 
> > and you can't fault Eric for not
> > wanting to do work on dm-cache too when all he's trying to do is solve a
> > particular real world problem. He should be able to do that without having to
> > dive into dm-cache code too.
> > 
> > Furthermore, pretty much every filesystem has private ioctls and interfaces -
> > this is no different.
> 
> You're completely misreading my having raised dm-cache.  I was poinitng
> out that Eric's patch to enable a new bcache feature ontop of dm-crypt
> was too late.  Had Eric known of this limitation sooner or thought to
> engage me or the rest of dm-devel then DM could've been fixed with
> precision during the 4.10 development window.
> 
> I wasn't saying Eric should've worked on dm-cache.  But had he raised
> this bcache feature to my attention, in the context of missing ioprio
> and why dm-cache would/could use it in the future too, then it'd have
> been all the better.  Simple as that.  I was trying to be helpful.  Not
> trying to be a PITA in any way.

I took your email to mean that the original patches shouldn't have gone in
without involving dm-cache. If that wasn't what you meant, let's just chalk this
up to a miscommunication.
