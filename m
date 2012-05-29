From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 14/16] Gut bio_add_page()
Date: Mon, 28 May 2012 23:36:28 -0400
Message-ID: <20120529033628.GD10175@dhcp-172-18-216-138.mtv.corp.google.com>
References: <20120525204651.GA24246@redhat.com>
 <20120525210944.GB14196@google.com>
 <20120525223937.GF5761@agk-dp.fab.redhat.com>
 <Pine.LNX.4.64.1205281129180.2227@file.rdu.redhat.com>
 <20120528202839.GA18537@dhcp-172-17-108-109.mtv.corp.google.com>
 <Pine.LNX.4.64.1205281659580.11763@file.rdu.redhat.com>
 <20120528213839.GB18537@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120528230208.GA20954@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120529020815.GB5091@dastard>
 <20120529021558.GG20954@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120529021558.GG20954-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tytso-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Tue, May 29, 2012 at 11:15:58AM +0900, Tejun Heo wrote:
> Hello,
> 
> On Tue, May 29, 2012 at 12:08:15PM +1000, Dave Chinner wrote:
> > > i thought a bit more about it and the only thing which makes sense to
> > > me is exposing the stripe granularity for striped devices -
> > > ie. something which says "if you go across this boundary, the
> > > performance characteristics including latency might get affected",
> > > which should fit nicely with the rest of topology information.
> > > Martin, adding that shouldn't be difficult, right?
> > 
> > We already have the optimal IO size/alignment field in the topology.
> > Doesn't this fit what you want exactly?
> 
> I don't know how xfs/ext4 is currently benefiting from
> merge_bvec_fn(), so I'm unsure.  If the existing ones are enough,
> great.

Excepting readahead I don't think they are at all.

For readahead all we need is a hint - call it "atomic IO size" or
something. Assuming one of the gazillion things in queue_limits doesn't
already mean that anyways.
