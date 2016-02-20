From: Pavel Machek <pavel@ucw.cz>
Subject: Re: 4.4-final: 28 bioset threads on small notebook
Date: Sat, 20 Feb 2016 21:55:19 +0100
Message-ID: <20160220205519.GA14108@amd>
References: <20151211104937.GA23165@amd>
 <20151211140841.GA22873@redhat.com>
 <20160220174035.GA16459@amd>
 <20160220184258.GA3753@amd>
 <20160220195136.GA27149@redhat.com>
 <20160220200432.GB22120@amd>
 <20160220203856.GB27149@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160220203856.GB27149@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, axboe@fb.com, hch@lst.de, kent.overstreet@gmail.com, neilb@suse.de, martin.petersen@oracle.com, dpark@posteo.net, ming.l@ssi.samsung.com, dm-devel@redhat.com, ming.lei@canonical.com, agk@redhat.com, jkosina@suse.cz, geoff@infradead.org, jim@jtan.com, pjk1939@linux.vnet.ibm.com, minchan@kernel.org, ngupta@vflare.org, oleg.drokin@intel.com, andreas.dilger@intel.com
List-Id: dm-devel.ids

Hi!

> > > You're directing this concern to the wrong person.
> > > 
> > > I already told you DM is _not_ contributing any extra "bioset" threads
> > > (ever since commit dbba42d8a).
> > 
> > Well, sorry about that. Note that l-k is on the cc list, so hopefully
> > the right person sees it too.
> > 
> > Ok, let me check... it seems that 
> > 54efd50bfd873e2dbf784e0b21a8027ba4299a3e is responsible, thus Kent
> > Overstreet <kent.overstreet@gmail.com> is to blame.
> > 
> > Um, and you acked the patch, so you are partly responsible.
> 
> You still haven't shown you even understand the patch so don't try to
> blame me for one aspect you don't like.

Well, I don't have to understand the patch to argue its wrong.

> > > But in general, these "bioset" threads are a side-effect of the
> > > late-bio-splitting support.  So is your position on it: "I don't like
> > > that feature if it comes at the expense of adding resources I can _see_
> > > for something I (naively?) view as useless"?
> > 
> > > Just seems... naive... but you could be trying to say something else
> > > entirely.
> > 
> > > Anyway, if you don't like something: understand why it is there and then
> > > try to fix it to your liking (without compromising why it was there to
> > > begin with).
> > 
> > Well, 28 kernel threads on a notebook is a bug, plain and simple. Do
> > you argue it is not?
> 
> Just implies you have 28 request_queues right?  You clearly have
> something else going on on your notebook than the average notebook
> user.

I'm not using the modules, but otherwise I'm not doing anything
special. How many request_queues should I expect? How many do you have
on your notebook?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
