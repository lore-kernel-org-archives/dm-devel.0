From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v3 14/16] Gut bio_add_page()
Date: Tue, 29 May 2012 12:07:02 +1000
Message-ID: <20120529020702.GA5091@dastard>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-15-git-send-email-koverstreet@google.com>
 <20120525204651.GA24246@redhat.com>
 <20120525210944.GB14196@google.com>
 <20120525223937.GF5761@agk-dp.fab.redhat.com>
 <Pine.LNX.4.64.1205281129180.2227@file.rdu.redhat.com>
 <20120528202839.GA18537@dhcp-172-17-108-109.mtv.corp.google.com>
 <Pine.LNX.4.64.1205281659580.11763@file.rdu.redhat.com>
 <20120528213839.GB18537@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120528213839.GB18537-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tytso-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Tue, May 29, 2012 at 06:38:39AM +0900, Tejun Heo wrote:
> On Mon, May 28, 2012 at 05:27:33PM -0400, Mikulas Patocka wrote:
> > > Isn't it more like you shouldn't be sending read requested by user and
> > > read ahead in the same bio?
> > 
> > If the user calls read with 512 bytes, you would send bio for just one 
> > sector. That's too small and you'd get worse performance because of higher 
> > command overhead. You need to send larger bios.
> 
> All modern FSes are page granular, so the granularity would be
> per-page.

Most modern filesystems support sparse files and block sizes smaller
than page size, so a single page may require multiple unmergable
bios to fill all the data in them. Hence IO granularity is
definitely not per-page even though that is the granularity of the
page cache.

> Also, RAHEAD is treated differently in terms of
> error-handling.  Do filesystems implement their own rahead
> (independent from the common logic in vfs layer) on their own?

Yes. Keep in mind there is no rule that says filesystems must use
the generic IO paths, or even the page cache for that matter.
Indeed, XFS (and I think btrfs now) do no use the page cache for
their metadata caching and IO.

So just off the top of my head, XFS has it's own readahead for
metadata constructs (btrees, directory data, etc) , and btrfs
implements it's own readpage/readpages and readahead paths (see the
btrfs compression support, for example).

And FWIW, XFS has variable sized metadata, so to complete the
circle, some metadata requires sector granularity, some filesystem
block size granularity, and some multiple page granularity.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
