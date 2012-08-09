From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 08/12] block: Introduce new bio_split()
Date: Thu, 9 Aug 2012 00:22:17 -0700
Message-ID: <20120809072217.GH2845@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-9-git-send-email-koverstreet@google.com>
 <20120808230532.GH6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809013923.GH7262@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120809013923.GH7262-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On Wed, Aug 08, 2012 at 06:39:23PM -0700, Kent Overstreet wrote:
> On Wed, Aug 08, 2012 at 04:05:32PM -0700, Tejun Heo wrote:
> > One more thing.
> > 
> > On Mon, Aug 06, 2012 at 03:08:37PM -0700, Kent Overstreet wrote:
> > > +	if (bio_integrity(bio)) {
> > > +		bio_integrity_clone(ret, bio, gfp, bs);
> > > +		bio_integrity_trim(ret, 0, bio_sectors(ret));
> > > +		bio_integrity_trim(bio, bio_sectors(ret), bio_sectors(bio));
> > 
> > Is this equivalent to bio_integrity_split() performance-wise?
> 
> Strictly speaking, no. But it has the advantage of being drastically
> simpler - and the only one only worked for single page bios so I
> would've had to come up with something new from scratch, and as
> confusing as the integrity stuff is I wouldn't trust the result.

There's already bio_integrity_split() and you're actively dropping it.

> I'm skeptical that it's going to matter in practice given how much
> iteration is done elsewhere in the course of processing a bio and given
> that this stuff isn't used with high end SSDs...

If you think the active dropping is justified, please let the change
and justification clearly stated.  You're burying the active change in
two separate patches without even mentioning it or cc'ing people who
care about bio-integrity (Martin K. Petersen).  Ummm.... this is
simply unacceptable and makes me a lot more suspicious about the
patchset.  Please be explicit about changes you make.  Peer-review
breaks down unless such trust can be maintained.

Thanks.

-- 
tejun
