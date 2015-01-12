From: Jens Axboe <axboe@kernel.dk>
Subject: Re: blk-mq request allocation stalls
Date: Mon, 12 Jan 2015 09:59:44 -0700
Message-ID: <54B3FD80.7040200@kernel.dk>
References: <54B04E94.3010403@kernel.dk> <20150109222543.GA1190@redhat.com>
	<54B071DC.9000307@kernel.dk> <20150110014811.GA2384@redhat.com>
	<54B08779.2080705@kernel.dk> <20150110031057.GA2823@redhat.com>
	<54B3DE54.7090909@sandisk.com> <54B3EB4A.9090404@kernel.dk>
	<54B3F255.5080802@sandisk.com> <54B3F78D.2020704@kernel.dk>
	<20150112165822.GA21120@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150112165822.GA21120@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Keith Busch <keith.busch@intel.com>, Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On 01/12/2015 09:58 AM, Mike Snitzer wrote:
> On Mon, Jan 12 2015 at 11:34am -0500,
> Jens Axboe <axboe@kernel.dk> wrote:
>
>> On 01/12/2015 09:12 AM, Bart Van Assche wrote:
>>> On 01/12/15 16:42, Jens Axboe wrote:
>>>> On 01/12/2015 07:46 AM, Bart Van Assche wrote:
>>>>> bt_get: __bt_get() returned -1
>>>>> queue_num=2, nr_tags=62, reserved_tags=0, bits_per_word=3
>>>>> nr_free=62, nr_reserved=0, may_queue=0
>>>>> active_queues=8
>>>>
>>>> Can you add dumping of hctx->nr_active when this fails? You case is that
>>>> the may_queue logic says no-can-do, so it smells like the nr_active
>>>> accounting is wonky since you have supposedly no allocated tags, yet it
>>>> clearly thinks that you do.
>>>
>>> Hello Jens,
>>>
>>> The requested output is as follows:
>>>
>>> bt_get: __bt_get() returned -1
>>> queue_num=0, nr_tags=62, reserved_tags=0, bits_per_word=3
>>> nr_free=62, nr_reserved=0, hctx->tags->active_queues=7,
>>> hctx->nr_active=9, hctx_may_queue()=0
>>> active_queues=7
>>
>> So that does look a bit off, we have (supposedly) 9 active requests,
>> but nothing allocated. When the mkfs is done and things are idle,
>> can you try and cat the 'active' file in the mq directory? I want to
>> see if it drops to zero or stays elevated.
>
> Could this be something flawed in the iSCSI blk-mq implementation?  I
> haven't ever been able to replicate this problem with virtio-blk.

It's related to a shared tag map, which only happens on scsi-mq. Other 
devices generally don't share tag maps.

-- 
Jens Axboe
