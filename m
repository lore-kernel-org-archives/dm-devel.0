From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Bcache v13 12/16] bcache: Bset code (lookups within a btree
 node)
Date: Thu, 24 May 2012 11:11:16 -0700
Message-ID: <20120524181116.GF27983@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <5b5998d7d09ec36377acdb5d15665d1e4e818521.1336619038.git.koverstreet@google.com>
 <20120522223932.GK14339@google.com>
 <20120523042114.GC607@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120523175544.GC18143@google.com>
 <20120523204914.GC3933@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120523204914.GC3933-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Hello, Kent.

On Wed, May 23, 2012 at 01:49:14PM -0700, Tejun Heo wrote:
> On Wed, May 23, 2012 at 10:55:44AM -0700, Tejun Heo wrote:
> > How much benefit are we gaining by doing this float thing?  Any chance
> > we can do something simpler?  As long as it's properly encapsulated,
> > it shouldn't be too bad but I keep having the suspicion that a lot of
> > complexity is added for unnecessary level of optimization.
> 
> e.g. how much performance gain does it provide compared to just using
> u64 in binary search tree combined with last search result hint for
> sequential accesses?

I've been thinking a bit more about it last night and have one more
question, so the use of floating numbers in binary search tree is to
use less memory and thus lower cacheline overhead on lookups, and the
tree is built between the min and max values of the bset so that
cluster of large keys don't get lower resolution from high exponent.

Assuming resolution of 512k - 2^19, 32bit can cover 2^41 - 2TiB.  If
having compact search tree is so important (I kinda have hard time
accepting that too tho), why not just use bin search tree of either
u32 or u64 depending on the range?  In most cases u32 will be used and
it's not like float can cover large areas well anyway.  It can
degenerate into essentially linear search depending on key
distribution (e.g. partition table read at sector 0 followed by bunch
of high partition accesses) - u64 tree will show much better bound
behavior in cases where key range becomes large.  Wouldn't that be
*far* simpler and easier to understand and maintain without much
downside?

Thanks.

-- 
tejun
