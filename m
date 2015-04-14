From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/3] dm-crypt: Adds support for wiping key when doing
 suspend/hibernation
Date: Tue, 14 Apr 2015 08:50:16 +0200
Message-ID: <20150414065016.GB20597@amd>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <20150406130045.GA18583@redhat.com>
 <201504061529.57299@pali>
 <20150409131208.GA9504@redhat.com>
 <20150409132836.GD12339@atrey.karlin.mff.cuni.cz>
 <20150409140842.GA9779@redhat.com>
 <20150409141633.GJ12339@atrey.karlin.mff.cuni.cz>
 <20150409142658.GA9839@redhat.com>
 <20150409143827.GK12339@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150409143827.GK12339@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

Hi!

> > > > > So proper way is to wipe luks crypto keys *after* userspace processes
> > > > > are freezed.
> > > > 
> > > > I know you believe that I'm just not accepting that at face value.
> > > 
> > > If disks are synced before any DM suspend operation then we have higher
> > > chance of preventing data corruption.
> > 
> > disks are already synced as part of the DM suspend operation!
> > 
> 
> Yes, but part of hibernate operation is also sync call.

Yes. Maybe that was a mistake.

> > > I still think that correct order is only:
> > > 
> > > * freeze processes (which doing continous I/O)
> > > * fs & disk sync
> > > * DM suspend
> > > * wipe crypto keys
> > > * enter hibernate
> > 
> > I just don't think that extreme is _required_ to have a hibernate/resume
> > that incorporates dm-crypt key wiping.
> 
> Ok, and what other developers think?

If someone can fix freezer to work with LUKS stopped, that would be a 
good thing. Can you do it, Mike? Then we can look if it works well
enough for Pali.

But that might be too hard / impossible. And at that point, I think
Pali's patch is right thing to do.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
