From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] block/dm: add REQ_NOWAIT support for bio-based
Date: Fri, 25 Sep 2020 08:20:18 -0600
Message-ID: <1a406078-7652-f8eb-e29c-bc4851b23dde@kernel.dk>
References: <20200923200652.11082-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200923200652.11082-1-snitzer@redhat.com>
Content-Language: en-US
To: Mike Snitzer <snitzer@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, hch@lst.de, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 9/23/20 2:06 PM, Mike Snitzer wrote:
> Hi,
> 
> I got guilted into this by this Twitter exchange:
> https://twitter.com/axboe/status/1308778488011337728
> 
> Started with this patchset from June and revised it:
> https://patchwork.kernel.org/project/dm-devel/list/?series=297693
> (dropped MD patch while doing so_.
> 
> Tested these changes with this test Jens provided:
> 
> [mikes-test-job]
> filename=/dev/dm-0
> rw=randread
> buffered=1
> ioengine=io_uring
> iodepth=16
> norandommap
> 
> Jens, please feel free to pickup both patches, I don't have any
> conflicting DM changes for 5.10.

Thanks Mike! Applied.

-- 
Jens Axboe
