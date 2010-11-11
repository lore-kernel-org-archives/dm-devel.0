From: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH 7/5] block: clean up blkdev_get() wrappers and their
 users
Date: Thu, 11 Nov 2010 19:19:18 +0000
Message-ID: <1289503158.2451.18.camel@dolmen>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
	 <4CDC23BB.10505@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <4CDC23BB.10505@kernel.org>
Sender: reiserfs-devel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org, petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com, neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com, chris.mason@oracle.com, shaggy@linux.vnet.ibm.com, joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp, reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk, philipp.reisner@linbit.com, snitzer@redhat.com
List-Id: dm-devel.ids

Hi,

On Thu, 2010-11-11 at 18:11 +0100, Tejun Heo wrote:
> After recent blkdev_get() modifications, open_by_devnum() and
> open_bdev_exclusive() are simple wrappers around blkdev_get().
> Replace them with blkdev_get_by_dev() and blkdev_get_by_path().
> 
> blkdev_get_by_dev() is identical to open_by_devnum().
> blkdev_get_by_path() is slightly different in that it doesn't
> automatically add %FMODE_EXCL to @mode.
> 
> All users are converted.  Most conversions are mechanical and don't
> introduce any behavior difference.  There are several exceptions.
> 
> * btrfs now sets FMODE_EXCL in btrfs_device->mode, so there's no
>   reason to OR it explicitly on blkdev_put().
> 
> * gfs2, nilfs2 and the generic mount_bdev() now set FMODE_EXCL in
>   sb->s_mode.
> 
> * With the above changes, sb->s_mode now always should contain
>   FMODE_EXCL.  WARN_ON_ONCE() added to kill_block_super() to detect
>   errors.
> 
> The new blkdev_get_*() functions are with proper docbook comments.
> While at it, add function description to blkdev_get() too.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Philipp Reisner <philipp.reisner@linbit.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Joern Engel <joern@lazybastard.org>
> Cc: Chris Mason <chris.mason@oracle.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
> Cc: reiserfs-devel@vger.kernel.org
> Cc: xfs-masters@oss.sgi.com
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Steve.


