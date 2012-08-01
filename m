From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RESEND PATCH] block: do not artificially constrain max_sectors
 for stacking drivers
Date: Wed, 01 Aug 2012 10:45:08 +0200
Message-ID: <5018EC94.1050405@kernel.dk>
References: <20120710191859.GB3831@redhat.com> <1343781553-17089-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343781553-17089-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, vijay.chauhan@netapp.com
List-Id: dm-devel.ids

On 08/01/2012 02:39 AM, Mike Snitzer wrote:
> blk_set_stacking_limits is intended to allow stacking drivers to build
> up the limits of the stacked device based on the underlying devices'
> limits.  But defaulting 'max_sectors' to BLK_DEF_MAX_SECTORS (1024)
> doesn't allow the stacking driver to inherit a max_sectors larger than
> 1024 -- due to blk_stack_limits' use of min_not_zero.
> 
> It is now clear that this artificial limit is getting in the way so
> change blk_set_stacking_limits's max_sectors to UINT_MAX (which allows
> stacking drivers like dm-multipath to inherit 'max_sectors' from the
> underlying paths).

Thanks Mike (and Vijay), applied for 3.6.

-- 
Jens Axboe
