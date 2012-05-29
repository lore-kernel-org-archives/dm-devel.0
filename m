From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v3 14/16] Gut bio_add_page()
Date: Tue, 29 May 2012 12:08:15 +1000
Message-ID: <20120529020815.GB5091@dastard>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-15-git-send-email-koverstreet@google.com>
 <20120525204651.GA24246@redhat.com>
 <20120525210944.GB14196@google.com>
 <20120525223937.GF5761@agk-dp.fab.redhat.com>
 <Pine.LNX.4.64.1205281129180.2227@file.rdu.redhat.com>
 <20120528202839.GA18537@dhcp-172-17-108-109.mtv.corp.google.com>
 <Pine.LNX.4.64.1205281659580.11763@file.rdu.redhat.com>
 <20120528213839.GB18537@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120528230208.GA20954@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120528230208.GA20954-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tytso-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Tue, May 29, 2012 at 08:02:08AM +0900, Tejun Heo wrote:
> (cc'ing Martin K. Petersen, hi!)
> 
> On Tue, May 29, 2012 at 06:38:39AM +0900, Tejun Heo wrote:
> > > With this patchset, you don't have to expose all the limits. You can 
> > > expose just a few most useful limits to avoid bio split in the cases 
> > > described above.
> > 
> > Yeah, if that actually helps, sure.  From what I read, dm is already
> > (ab)using merge_bvec_fn() like that anyway.
> 
> i thought a bit more about it and the only thing which makes sense to
> me is exposing the stripe granularity for striped devices -
> ie. something which says "if you go across this boundary, the
> performance characteristics including latency might get affected",
> which should fit nicely with the rest of topology information.
> Martin, adding that shouldn't be difficult, right?

We already have the optimal IO size/alignment field in the topology.
Doesn't this fit what you want exactly?

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
