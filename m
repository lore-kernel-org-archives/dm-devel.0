From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 05/12] block: Kill bi_destructor
Date: Thu, 9 Aug 2012 02:12:14 -0400
Message-ID: <20120809061214.GA9128@dhcp-172-18-216-138.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-6-git-send-email-koverstreet@google.com>
 <20120808222223.GD6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809002154.GE7262@moria.home.lan>
 <20120809060517.GB2845@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120809060517.GB2845-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On Wed, Aug 08, 2012 at 11:05:17PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 08, 2012 at 05:21:54PM -0700, Kent Overstreet wrote:
> > > What's wrong with good ol' NULL?
> > 
> > If it's NULL, we can't distinguish between bios where that field wasn't
> > set (i.e. bios that were statically allocated somewhere) from bios that
> > were allocated by bio_kmalloc().
> > 
> > It's just there to make debugging easier - if bi_cnt goes to 0 on a bio
> > where it shouldn't we'll catch it at the BUG_ON() in bio_free() instead
> > of kfreeing a bad pointer.
> 
> I fail to see how that improves anything.  slab will complain clearly
> if it gets passed in a pointer to static area.  The benefit is
> imaginery.  If there's no bioset, it's NULL.  Let's please keep things
> usual.

But if it's a pointer to heap allocated memory, but the bio was embedded
in another struct? I've seen a fair number of instances of that (md, off
the top of my head).

If you're sure that in a normal config the slab allocator is going to
complain right away and not corrupt itself, fine. But I've been bitten
way too hard by bugs that could've been caught right away by a simple
assert and instead I had to spend hours backtracking, and the block
layer is _rife_ with that kind of thing.
