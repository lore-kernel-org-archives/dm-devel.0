From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] bio: have bio_kmap_irq return the size of mapped data
 (fwd)
Date: Wed, 8 Nov 2017 01:47:30 -0800
Message-ID: <20171108094730.GA7074@infradead.org>
References: <alpine.LRH.2.02.1711071641090.1339@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1711071641090.1339@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Nov 07, 2017 at 04:45:17PM -0500, Mikulas Patocka wrote:
> Hi
> 
> I need the function bio_kmap_irq in the driver that I am developing, but 
> it doesn't return the size of the mapped data. I've made this patch to fix 
> it.

To be honest I think we should just remove bio_kmap_irq.  It is currently
unused and assumes there is only a single bvec to map.

I think you're much better off using a proper bvec iterator in your
caller and then call bvec_kmap_irq/bvec_kunmap_irq manually.
