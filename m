From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] block: make blkdev_get/put() handle exclusive
 access
Date: Wed, 3 Nov 2010 16:06:58 +0100
Message-ID: <20101103150658.GA5627@quack.suse.cz>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
 <1288628129-12811-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1288628129-12811-5-git-send-email-tj@kernel.org>
Sender: reiserfs-devel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org, petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com, neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com, chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com, joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp, reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk
List-Id: dm-devel.ids

On Mon 01-11-10 17:15:28, Tejun Heo wrote:
> Over time, block layer has accumulated a set of APIs dealing with bdev
> open, close, claim and release.
> 
> * blkdev_get/put() are the primary open and close functions.
> 
> * bd_claim/release() deal with exclusive open.
> 
> * open/close_bdev_exclusive() are combination of open and claim and
>   the other way around, respectively.
> 
> * bd_link/unlink_disk_holder() to create and remove holder/slave
>   symlinks.
> 
> * open_by_devnum() wraps bdget() + blkdev_get().
> 
> The interface is a bit confusing and the decoupling of open and claim
> makes it impossible to properly guarantee exclusive access as
> in-kernel open + claim sequence can disturb the existing exclusive
> open even before the block layer knows the current open if for another
> exclusive access.  Reorganize the interface such that,
...
  The patch looks OK to me as far as ext3, ext4, and reiserfs are
concerned. One thing I wondered about when I looked at it - does someone
use the 'mode' argument of the blkdev_put() function (well, apart from the
exclusive flag)? Because I've looked at a few random disk ->release()
functions and none of them used it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
