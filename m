From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] bio: have bio_kmap_irq return the size of mapped data
 (fwd)
Date: Wed, 8 Nov 2017 07:38:44 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1711080733220.12294@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1711071641090.1339@file01.intranet.prod.int.rdu2.redhat.com> <20171108094730.GA7074@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171108094730.GA7074@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids



On Wed, 8 Nov 2017, Christoph Hellwig wrote:

> On Tue, Nov 07, 2017 at 04:45:17PM -0500, Mikulas Patocka wrote:
> > Hi
> > 
> > I need the function bio_kmap_irq in the driver that I am developing, but 
> > it doesn't return the size of the mapped data. I've made this patch to fix 
> > it.
> 
> To be honest I think we should just remove bio_kmap_irq.  It is currently
> unused and assumes there is only a single bvec to map.

It could be removed from include/linux/bio.h and moved to my driver. But 
if we leave it in bio.h, it could be used by others as well.

bio_kmap_irq can iterate over the whole bio if we use bio_advance on the 
bio.

> I think you're much better off using a proper bvec iterator in your
> caller and then call bvec_kmap_irq/bvec_kunmap_irq manually.

Mikulas
