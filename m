From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: add a bi_error field to struct bio
Date: Fri, 24 Jul 2015 10:36:45 -0600
Message-ID: <55B2699D.6010400@kernel.dk>
References: <1437398977-8492-1-git-send-email-hch@lst.de> <1437398977-8492-2-git-send-email-hch@lst.de> <55AFE643.5000704@kernel.dk> <55B01252.90004@kernel.dk> <20150724104946.GA25145@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150724104946.GA25145@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Neil Brown <neilb@suse.de>, Liu Bo <bo.li.liu@oracle.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 07/24/2015 04:49 AM, Christoph Hellwig wrote:
> On Wed, Jul 22, 2015 at 03:59:46PM -0600, Jens Axboe wrote:
>> One possible solution would be to shrink bi_flags to an unsigned int, no
>> problems fitting that in. Then we could stuff bi_error in that (new) hole,
>> and we would end up having the same size again.
>
> As long as we use set/test/clear_bt on bi_flags that won't work unfortunately.

Right, I don't think we need to do that though. If you look at the flags 
usage, it's all over the map. Some use test/set_bit, some set it just by 
OR'ing the mask. There's no reason we can't make this work without 
relying on set/test_bit, and then shrink it to an unsigned int.

-- 
Jens Axboe

