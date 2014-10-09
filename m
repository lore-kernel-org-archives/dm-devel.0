From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] block: fix alignment_offset math that assumes io_min is a power-of-2
Date: Wed, 08 Oct 2014 20:23:10 -0400
Message-ID: <yq1iojudrbl.fsf@sermon.lab.mkp.net>
References: <to=1412805952-15316-1-git-send-email-snitzer@redhat.com>
	<1412807173-15541-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1412807173-15541-1-git-send-email-snitzer@redhat.com> (Mike
	Snitzer's message of "Wed, 8 Oct 2014 18:26:13 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, dm-devel@redhat.com
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> The math in both blk_stack_limits() and
Mike> queue_limit_alignment_offset() assume that a block device's io_min
Mike> (aka minimum_io_size) is always a power-of-2.  Fix the math such
Mike> that it works for non-power-of-2 io_min.

Mike> This issue (of alignment_offset != 0) became apparent when testing
Mike> dm-thinp with a thinp blocksize that matches a RAID6 stripesize of
Mike> 1280K.  Commit fdfb4c8c1 ("dm thin: set minimum_io_size to pool's
Mike> data block size") unlocked the potential for alignment_offset != 0
Mike> due to the dm-thin-pool's io_min possibly being a non-power-of-2.

Looks good to me, Mike.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
