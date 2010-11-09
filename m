From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] block: make blkdev_get/put() handle exclusive access
Date: Tue, 9 Nov 2010 05:36:20 -0500
Message-ID: <20101109103620.GA18355@infradead.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
 <1288628129-12811-5-git-send-email-tj@kernel.org>
 <20101103161059.GA13621@infradead.org>
 <4CD9239E.2080209@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CD9239E.2080209@kernel.org>
Sender: reiserfs-devel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, linux-kernel@vger.kernel.org, petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com, neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com, chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com, joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp, reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk
List-Id: dm-devel.ids

On Tue, Nov 09, 2010 at 11:34:06AM +0100, Tejun Heo wrote:
> So, after the above points, I decided to keep @mode.  It is a bit
> awkward but the other way didn't seem too hip either.  Any better
> ideas?

Let's keep it for now and revisit it later.

> That will make the number of functions multiplied by two -
> blkdev_get_by_path_stacked() and blkdev_get_by_dev_stacked().  The
> symlinking for stacked drivers is an oddball feature which is and will
> be only used by md and dm.  So, I think it's better to keep it
> separate and oddball.

Oh well.  I still don't like it, but let keeps it simple to make
progress for now.

