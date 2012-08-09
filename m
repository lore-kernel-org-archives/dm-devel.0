From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH v5 08/12] block: Introduce new bio_split()
Date: Thu, 9 Aug 2012 03:33:34 -0400
Message-ID: <20120809073334.GD9128@dhcp-172-18-216-138.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-9-git-send-email-koverstreet@google.com>
 <20120808230532.GH6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809013923.GH7262@moria.home.lan>
 <20120809072217.GH2845@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120809072217.GH2845@dhcp-172-17-108-109.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net, martin.petersen@oracle.com
List-Id: dm-devel.ids

On Thu, Aug 09, 2012 at 12:22:17AM -0700, Tejun Heo wrote:
> On Wed, Aug 08, 2012 at 06:39:23PM -0700, Kent Overstreet wrote:
> > On Wed, Aug 08, 2012 at 04:05:32PM -0700, Tejun Heo wrote:
> > > One more thing.
> > > 
> > > On Mon, Aug 06, 2012 at 03:08:37PM -0700, Kent Overstreet wrote:
> > > > +	if (bio_integrity(bio)) {
> > > > +		bio_integrity_clone(ret, bio, gfp, bs);
> > > > +		bio_integrity_trim(ret, 0, bio_sectors(ret));
> > > > +		bio_integrity_trim(bio, bio_sectors(ret), bio_sectors(bio));
> > > 
> > > Is this equivalent to bio_integrity_split() performance-wise?
> > 
> > Strictly speaking, no. But it has the advantage of being drastically
> > simpler - and the only one only worked for single page bios so I
> > would've had to come up with something new from scratch, and as
> > confusing as the integrity stuff is I wouldn't trust the result.
> 
> There's already bio_integrity_split() and you're actively dropping it.

Because it only works for single page bios, AFAICT. I'd have to start
from scratch.

> > I'm skeptical that it's going to matter in practice given how much
> > iteration is done elsewhere in the course of processing a bio and given
> > that this stuff isn't used with high end SSDs...
> 
> If you think the active dropping is justified, please let the change
> and justification clearly stated.  You're burying the active change in
> two separate patches without even mentioning it or cc'ing people who
> care about bio-integrity (Martin K. Petersen). 

Not intentionally, he isn't in MAINTAINERS so get_maintainers.pl missed
it and it slipped by while I was looking for people to CC. Added him.
