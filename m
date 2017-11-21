From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 00/13] block: assorted cleanup for bio      splitting and
 cloning.
Date: Tue, 21 Nov 2017 07:43:12 -0500
Message-ID: <20171121124311.GA17243@redhat.com>
References: <149776047907.23258.8058071140236879834.stgit@noble>
 <20170618184143.GA10920@kernel.dk>
 <87poe13rmm.fsf@notabene.neil.brown.name>
 <CAMM=eLf9Vu-z1ZEsGtRoSkhpaaQXAdr8TsUYUCSmAjqrqo=W-w@mail.gmail.com>
 <87a7zg31vx.fsf@notabene.neil.brown.name>
 <20171121013533.GA14520@redhat.com>
 <20171121121049.GA17014@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171121121049.GA17014@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 21 2017 at  7:10am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Nov 20 2017 at  8:35pm -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Mon, Nov 20 2017 at  7:34pm -0500,
> > NeilBrown <neilb@suse.com> wrote:
> > 
> > > Please see
> > >    https://www.redhat.com/archives/dm-devel/2017-August/msg00310.html
> 
> I'll very likely pick these up for 4.16 shortly.  But hope to work
> through complete removal of DM's use of BIOSET_NEED_RESCUER for 4.16 as
> well.
> 
> > > and
> > >    https://www.redhat.com/archives/dm-devel/2017-August/msg00315.html
> 
> This one [1] needs a lot of review and testing.  Particularly against this
> test case that Mikulas created to reproduce the snapshot deadlock (same
> deadlock that motivated commit dbba42d8):
> https://www.redhat.com/archives/dm-devel/2017-January/msg00064.html
...
> Short of that, how would you like to proceed?
> 
> > > That would then just leave bcache....  I find it a bit of a challenge to
> > > reason about the code in bcache, but if we can remove
> > > BIOSET_NEED_RESCUER from dm, that will be an extra incentive for me to learn :-)
> > 
> > I'm all for properly removing BIOSET_NEED_RESCUER from DM.
> 
> Should we work to make [1] (above) sure it fixes Mikulas' test case?
> 
> I'll set in on reviewing and playing with [1] now.

Decided it a better use of my time to review and then hopefully use the
block-core's bio splitting infrastructure in DM.  Been meaning to do
that for quite a while anyway.  This mail from you just made it all the
more clear that needs doing:
https://www.redhat.com/archives/dm-devel/2017-September/msg00098.html

So I will start here on this patch you proposed:
https://www.redhat.com/archives/dm-devel/2017-September/msg00091.html
(of note, this patch slipped through the cracks because I was recovering
from injury when it originally came through).

Once DM is using q->bio_split I'll come back to this patch (aka
"[1]") as a starting point for the follow-on work to remove DM's use of
BIOSET_NEED_RESCUER:
https://www.redhat.com/archives/dm-devel/2017-August/msg00315.html

Mike
