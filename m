From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Bcache v13 12/16] bcache: Bset code (lookups within a btree
 node)
Date: Wed, 23 May 2012 13:49:14 -0700
Message-ID: <20120523204914.GC3933@htj.dyndns.org>
References: <cover.1336619038.git.koverstreet@google.com>
 <5b5998d7d09ec36377acdb5d15665d1e4e818521.1336619038.git.koverstreet@google.com>
 <20120522223932.GK14339@google.com>
 <20120523042114.GC607@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120523175544.GC18143@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120523175544.GC18143-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Wed, May 23, 2012 at 10:55:44AM -0700, Tejun Heo wrote:
> How much benefit are we gaining by doing this float thing?  Any chance
> we can do something simpler?  As long as it's properly encapsulated,
> it shouldn't be too bad but I keep having the suspicion that a lot of
> complexity is added for unnecessary level of optimization.

e.g. how much performance gain does it provide compared to just using
u64 in binary search tree combined with last search result hint for
sequential accesses?

Thanks.

-- 
tejun
