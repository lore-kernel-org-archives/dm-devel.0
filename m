From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: dm-crypt: fix lost ioprio when queuing crypto bios from task
 with ioprio
Date: Sun, 18 Dec 2016 13:54:06 -0900
Message-ID: <20161218225406.eqbcn7fpg4cehjb6@kmo-pixel>
References: <alpine.LRH.2.11.1612141049250.13402@mail.ewheeler.net>
 <alpine.LRH.2.11.1612161414280.9898@mail.ewheeler.net>
 <20161217155800.GA6580@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161217155800.GA6580@redhat.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Eric Wheeler <dm-devel@lists.ewheeler.net>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Sat, Dec 17, 2016 at 10:58:00AM -0500, Mike Snitzer wrote:
> The time for 4.10 inclusion has passed.  This needs to wait until 4.11.
> 
> It also needs more review, testing and possible re-working.  Each DM
> target shouldn't have to worry about these details (though I do grant
> that dm-crypt.c:clone_init call to bio_set_prio makes sense).
> 
> A more generic solution is needed (likely in DM core).
> 
> A while ago, Vivek floated a patch that spoke to the need for iocontext
> (for the purposes of cgroups):
>  https://patchwork.kernel.org/patch/8485451/
> 
> I don't consider your patch too dissimilar.  But it just needs to be
> worked on during a development window.  On to 4.11 ;)

Mike, this current patch is a pure bugfix, and you can't fault Eric for not
wanting to do work on dm-cache too when all he's trying to do is solve a
particular real world problem. He should be able to do that without having to
dive into dm-cache code too.

Furthermore, pretty much every filesystem has private ioctls and interfaces -
this is no different.

If you dm guys want to standardize something, that's awesome - and in hindsight,
it wouldn't have been a bad idea to CC you guys on the original patches. But
please keep in mind Eric's not a full time kernel developer, and don't crap on
his work just becausue he's not working on dm-cache too.
