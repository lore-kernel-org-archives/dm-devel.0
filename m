From: Philipp Reisner <philipp.reisner@linbit.com>
Subject: Re: [Drbd-dev] [PATCHSET] block: clean up bdev claim/release handling
Date: Wed, 3 Nov 2010 16:53:08 +0100
Message-ID: <201011031653.09159.philipp.reisner@linbit.com>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1288628129-12811-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: drbd-dev@lists.linbit.com
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org, petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, aelder@sgi.com, dm-devel@redhat.com, neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com, chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com, joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp, reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk
List-Id: dm-devel.ids

Am Montag, 1. November 2010, um 17:15:24 schrieb Tejun Heo:
> bdev exclusive access handling is somewhat clumsy.  The primary
> interface is bd_claim() and bd_release() but there also are
> open_bdev_exclusive(), close_bdev_exclusive() and bd_claim_by_disk()
> and bd_release_from_disk().
[...]
>  drivers/block/drbd/drbd_int.h   |    2
>  drivers/block/drbd/drbd_main.c  |    7
>  drivers/block/drbd/drbd_nl.c    |  103 ++-----
[...]

Hi Tejun,

  Acked-by: Philipp Reisner <philipp.reisner@linbit.com>

...for the DRBD part of the patch.

Best,
 Phil
