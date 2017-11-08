From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] bio: have bio_kmap_irq return the size of mapped data
 (fwd)
Date: Wed, 8 Nov 2017 07:05:59 -0800
Message-ID: <20171108150559.GB10374@infradead.org>
References: <alpine.LRH.2.02.1711071641090.1339@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108094730.GA7074@infradead.org>
 <alpine.LRH.2.02.1711080733220.12294@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1711080733220.12294@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Nov 08, 2017 at 07:38:44AM -0500, Mikulas Patocka wrote:
> > To be honest I think we should just remove bio_kmap_irq.  It is currently
> > unused and assumes there is only a single bvec to map.
> 
> It could be removed from include/linux/bio.h and moved to my driver. But 
> if we leave it in bio.h, it could be used by others as well.
> 
> bio_kmap_irq can iterate over the whole bio if we use bio_advance on the 
> bio.

The bio_kmap_irq name implies it maps the whole bio, but it only maps
the current segment.  Now if there were plenty of users and it was
non-trivial we could say we should fix the name and documentation.
But given how trivial it is I'd rather have you open code it to clearly
document what you are doing.
