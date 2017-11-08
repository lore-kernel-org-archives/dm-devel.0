From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH] bio: have bio_kmap_irq return the size of
 mapped data (fwd)
Date: Wed, 8 Nov 2017 10:03:58 -0800
Message-ID: <20171108180358.GA6724@infradead.org>
References: <alpine.LRH.2.02.1711071641090.1339@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108094730.GA7074@infradead.org>
 <alpine.LRH.2.02.1711080733220.12294@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108150559.GB10374@infradead.org>
 <650d7a0d-f344-155a-5b53-4ce368c4aca4@kernel.dk>
 <20171108153436.GA24548@infradead.org>
 <aabd8f47-3b9f-ffb5-474e-ab0841806a39@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <aabd8f47-3b9f-ffb5-474e-ab0841806a39@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Mikulas Patocka <mpatocka@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Nov 08, 2017 at 08:36:25AM -0700, Jens Axboe wrote:
> On 11/08/2017 08:34 AM, Christoph Hellwig wrote:
> > On Wed, Nov 08, 2017 at 08:20:58AM -0700, Jens Axboe wrote:
> >> On top of that, there are no users of it at all...
> > 
> > But Mikulas wants to add one :)
> 
> I know...
> 
> > Note that __bio_kmap_atomic has the same issues, only has a single
> > users either and would be cleaner if opencoded there as it already
> > has the current bvec.  See patch below.
> 
> Kill them all with fire. The open coded version is much clearer.

Feel free to throw the patch in under either your or my name.
