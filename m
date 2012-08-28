From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 6/9] block: Consolidate bio_alloc_bioset(),
 bio_kmalloc()
Date: Tue, 28 Aug 2012 15:03:32 -0700
Message-ID: <20120828220332.GA1048@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-7-git-send-email-koverstreet@google.com>
 <20120828204148.GE24608@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120828204148.GE24608-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

On Tue, Aug 28, 2012 at 01:41:48PM -0700, Tejun Heo wrote:
> Hello, Kent.
> 
> On Tue, Aug 28, 2012 at 10:37:33AM -0700, Kent Overstreet wrote:
> > v7: Re-add dropped comments, improv patch description
> 
> I don't think you did the former part.  Other than that looks good to
> me.

I folded them into the bio_alloc_bioset() comments - so all the
information that was there previously should still be there, just
centralized. That good enough for your acked-by?
