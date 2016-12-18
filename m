From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: fix lost ioprio when queuing crypto bios from task
 with ioprio
Date: Sun, 18 Dec 2016 18:17:55 -0500
Message-ID: <20161218231755.GA14929@redhat.com>
References: <alpine.LRH.2.11.1612141049250.13402@mail.ewheeler.net>
 <alpine.LRH.2.11.1612161414280.9898@mail.ewheeler.net>
 <20161217155800.GA6580@redhat.com>
 <20161218225406.eqbcn7fpg4cehjb6@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161218225406.eqbcn7fpg4cehjb6@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Eric Wheeler <dm-devel@lists.ewheeler.net>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Sun, Dec 18 2016 at  5:54pm -0500,
Kent Overstreet <kent.overstreet@gmail.com> wrote:

> On Sat, Dec 17, 2016 at 10:58:00AM -0500, Mike Snitzer wrote:
> > The time for 4.10 inclusion has passed.  This needs to wait until 4.11.
> > 
> > It also needs more review, testing and possible re-working.  Each DM
> > target shouldn't have to worry about these details (though I do grant
> > that dm-crypt.c:clone_init call to bio_set_prio makes sense).
> > 
> > A more generic solution is needed (likely in DM core).
> > 
> > A while ago, Vivek floated a patch that spoke to the need for iocontext
> > (for the purposes of cgroups):
> >  https://patchwork.kernel.org/patch/8485451/
> > 
> > I don't consider your patch too dissimilar.  But it just needs to be
> > worked on during a development window.  On to 4.11 ;)
> 
> Mike, this current patch is a pure bugfix,

Spinning it as a pure bugfix is a reach (as Eric's header documents the
patch, the case is weak for cc'ing stable).  Reality is the change is
needed to enable a new bcache feature.  I'm not going to rush
feature-enabling change that arrived in the last minute.

> and you can't fault Eric for not
> wanting to do work on dm-cache too when all he's trying to do is solve a
> particular real world problem. He should be able to do that without having to
> dive into dm-cache code too.
> 
> Furthermore, pretty much every filesystem has private ioctls and interfaces -
> this is no different.

You're completely misreading my having raised dm-cache.  I was poinitng
out that Eric's patch to enable a new bcache feature ontop of dm-crypt
was too late.  Had Eric known of this limitation sooner or thought to
engage me or the rest of dm-devel then DM could've been fixed with
precision during the 4.10 development window.

I wasn't saying Eric should've worked on dm-cache.  But had he raised
this bcache feature to my attention, in the context of missing ioprio
and why dm-cache would/could use it in the future too, then it'd have
been all the better.  Simple as that.  I was trying to be helpful.  Not
trying to be a PITA in any way.

> If you dm guys want to standardize something, that's awesome - and in hindsight,
> it wouldn't have been a bad idea to CC you guys on the original patches. But
> please keep in mind Eric's not a full time kernel developer, and don't crap on
> his work just becausue he's not working on dm-cache too.

You don't get to make this something it isn't.  I didn't crap on
anything.  This line of development will be pursued in Januaray when I
get back from holiday break.  If there is a stable@vger.kernel.org
worthy change that comes from that development then so be it.

Could be that the change(s) will land during 4.10-rc but I cannot put
time to it until after January 2.
