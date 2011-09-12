From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] block: remove support for bio remapping from
 ->make_request
Date: Mon, 12 Sep 2011 08:25:28 -0400
Message-ID: <20110912122528.GB12229@infradead.org>
References: <20110911145053.GA28996@infradead.org>
 <20110911145129.GA29504@infradead.org>
 <4E6DD818.80902@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E6DD818.80902@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Sep 12, 2011 at 11:59:52AM +0200, Jens Axboe wrote:
> On 2011-09-11 16:51, Christoph Hellwig wrote:
> > There is very little benefit in allowing to let a ->make_request
> > instance update the bios device and sector and loop around it in
> > __generic_make_request when we can archive the same through calling
> > generic_make_request from the driver and letting the loop in
> > generic_make_request handle it.
> 
> Agree, this looks good! Will apply for 3.2.

Are you going to fix the issue Neil pointed out beforehand?
