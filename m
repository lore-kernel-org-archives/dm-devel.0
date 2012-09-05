From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 4/9] pktcdvd: Switch to bio_kmalloc()
Date: Wed, 5 Sep 2012 12:44:27 -0700
Message-ID: <20120905194427.GF25236@google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-5-git-send-email-koverstreet@google.com>
 <20120828203247.GC24608@dhcp-172-17-108-109.mtv.corp.google.com>
 <alpine.LRH.2.00.1209041104020.26301@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1209041104020.26301-1ReQVI26iDCaZKY3DrU6dA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Peter Osterlund <petero2-zq6IREYz3ykAvxtiuMwx3w@public.gmane.org>
List-Id: dm-devel.ids

On Tue, Sep 04, 2012 at 11:05:06AM +0200, Jiri Kosina wrote:
> On Tue, 28 Aug 2012, Tejun Heo wrote:
> 
> > > This is prep work for killing bi_destructor - previously, pktcdvd had
> > > its own pkt_bio_alloc which was basically duplication bio_kmalloc(),
> > > necessitating its own bi_destructor implementation.
> > 
> > How was this tested?
> 
> I have now tested it and it works properly. You can add
> 
> 	Signed-off-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> 
> once you will be pushing the patchset through (I will be pushing 
> MAINTAINERS update through my tree to Jens separately).

Thanks! I'll make sure and add you to the cc next time - I'll have
another patch or two for pktcdvd coming soon as I clean up the next
patch series.
