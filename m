From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/3] Implement generic freeze feature
Date: Fri, 22 Aug 2008 01:09:58 -0600
Message-ID: <20080822070958.GU3392@webber.adilger.int>
References: <20080818212819t-sato@mail.jp.nec.com>
 <20080821125841.a04a706f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ext4-owner@vger.kernel.org>
In-reply-to: <20080821125841.a04a706f.akpm@linux-foundation.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Aug 21, 2008  12:58 -0700, Andrew Morton wrote:
> >  #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
> > +#define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
> > +#define FITHAW		_IOWR('X', 120, int)	/* Thaw */
> 
> FIFREEZE is 119, but a few lines above we have
> 
> #define BLKDISCARD _IO(0x12,119)
>
> Should we be using 120 and 121 here?

No, because 'X' != 0x12...  The 'X' is used because this ioctl is compatible
with the XFS implementation of this feature.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

