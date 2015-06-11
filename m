From: Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [RFC] add a bi_error field
Date: Thu, 11 Jun 2015 17:42:50 +0800
Message-ID: <20150611094249.GF9634@localhost.localdomain>
References: <1433338959-24808-1-git-send-email-hch@lst.de>
 <20150611075921.GC9634@localhost.localdomain>
 <20150611080528.GD9634@localhost.localdomain>
 <20150611080835.GA2655@lst.de>
Reply-To: bo.li.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150611080835.GA2655@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jun 11, 2015 at 10:08:35AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 11, 2015 at 04:05:30PM +0800, Liu Bo wrote:
> > > Reviewed-by: Liu Bo <bo.li.liu@oracle.com> (btrfs part)
> > 
> > Also there're some conflicts in btrfs_end_empty_barrier():
> 
> Hi Liu,
> 
> BIO_EOPNOTSUPP has been removed in the block tree:
> 
> http://git.kernel.dk/?p=linux-block.git;a=commitdiff;h=b25de9d6da49b1a8760a89672283128aa8c78345
> 

OK, we're good now.

Thanks,

-liubo
