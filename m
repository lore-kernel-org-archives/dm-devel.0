From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] fs/block_dev.c: Remove WARN_ON() when inode writeback
 fails
Date: Mon, 22 Jun 2015 14:42:04 -0400
Message-ID: <20150622184204.GD3710@mtj.duckdns.org>
References: <20150622184118.GA11277@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150622184118.GA11277@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Jun 22, 2015 at 02:41:18PM -0400, Vivek Goyal wrote:
> If a block device is hot removed and later last reference to devices
> is put, we try to writeback the dirty inode. But device is gone and
> that writeback fails.
> 
> Currently we do a WARN_ON() which does not seem to be the right thing.
> Convert it to a ratelimited kernel warning.
> 
> Reported-by: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
