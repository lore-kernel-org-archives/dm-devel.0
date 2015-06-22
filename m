From: Tejun Heo <tj@kernel.org>
Subject: Re: WARNING: at fs/block_dev.c:5 when removing LV on removed device
Date: Mon, 22 Jun 2015 13:52:55 -0400
Message-ID: <20150622175255.GB3710@mtj.duckdns.org>
References: <20150618165713.GB19417@two.firstfloor.org>
 <20150618180408.GD2321@redhat.com>
 <20150618180804.GC19417@two.firstfloor.org>
 <20150618181619.GE2321@redhat.com>
 <20150618190815.GA6390@redhat.com>
 <20150618192821.GA4027@redhat.com>
 <20150619064721.GA1183@lst.de>
 <20150622174648.GA2965@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150622174648.GA2965@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hello,

On Mon, Jun 22, 2015 at 01:46:48PM -0400, Vivek Goyal wrote:
> Subject: fs/block_dev.c: Warn on inode writeback failure instead of WARN_ON()
> 
> If a block device is hot removed and later last reference to devices
> is put, we try to writeback the dirty inode. But device is gone and
> that writeback fails.
> 
> Currently we do a WARN_ON() which does not seem to be the right thing.
> Convert it to a ratelimited kernel warning.

Yeah, looks good to me.  Just one nit.

...
> +		if (write_inode_now(inode, true)) {
> +			char name[BDEVNAME_SIZE] = "";
> +			pr_warn_ratelimited("VFS: Dirty inode writeback failed for block device %s.\n", bdevname(bdev, name));

This wasn't reported before either but maybe we wanna report the errno
too?  Also, don't we usually break the line for parameters?

	pr_..("long format string going over 80 col...\n",
	      param0, param1, ...);

Thanks.

-- 
tejun
