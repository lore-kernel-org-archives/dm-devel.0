From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH for-2.6.37] block: max hardware sectors limit wrapper
Date: Fri, 17 Dec 2010 08:34:51 +0100
Message-ID: <4D0B129B.3070500@fusionio.com>
References: <20101206184346.GA13582@redhat.com> <yq1wrn92s8x.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1wrn92s8x.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, "stable@kernel.org" <stable@kernel.org>
List-Id: dm-devel.ids

On 2010-12-17 00:49, Martin K. Petersen wrote:
>>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> Implement blk_limits_max_hw_sectors() and make
> Mike> blk_queue_max_hw_sectors() a wrapper around it.
> 
> Mike> DM needs this to avoid setting queue_limits' max_hw_sectors and
> Mike> max_sectors directly.  dm_set_device_limits() now leverages
> Mike> blk_limits_max_hw_sectors() logic to establish the appropriate
> Mike> max_hw_sectors minimum (PAGE_SIZE).  Fixes issue where DM was
> Mike> incorrectly setting max_sectors rather than max_hw_sectors (which
> Mike> caused dm_merge_bvec()'s max_hw_sectors check to be ineffective).
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> Jens, please apply.

Thanks, it's in.

-- 
Jens Axboe
