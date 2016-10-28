From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] [PATCH 1/4] brd: handle misaligned discard
Date: Fri, 28 Oct 2016 08:55:26 -0700
Message-ID: <f3257790-19a5-8512-df37-78e5fd8a8973@sandisk.com>
References: <alpine.LRH.2.02.1610211406290.9197@file01.intranet.prod.int.rdu2.redhat.com>
 <20161021200022.GA12580@redhat.com>
 <alpine.LRH.2.02.1610211616450.31606@file01.intranet.prod.int.rdu2.redhat.com>
 <20161024155756.GA48306@redhat.com> <20161025130712.GA12717@infradead.org>
 <20161025143719.GA51266@redhat.com>
 <710b07a3-9091-6935-37c4-ea1dcedcab4f@kernel.dk>
 <alpine.LRH.2.02.1610261624100.12287@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1610261625580.12287@file01.intranet.prod.int.rdu2.redhat.com>
 <338b76f0-40d1-904f-66e0-f6455c5287e7@sandisk.com>
 <alpine.LRH.2.02.1610261733190.25893@file01.intranet.prod.int.rdu2.redhat.com>
 <9ee4e796-2a85-3b81-ebaa-90ed50f8bf66@sandisk.com>
 <alpine.LRH.2.02.1610280731410.22676@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1610280731410.22676@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On 10/28/2016 04:39 AM, Mikulas Patocka wrote:
> On Wed, 26 Oct 2016, Bart Van Assche wrote:
>> On 10/26/2016 02:46 PM, Mikulas Patocka wrote:
>>> I think the proper thing would be to move "discard_zeroes_data" flag into
>>> the bio itself - there would be REQ_OP_DISCARD and REQ_OP_DISCARD_ZERO -
>>> and if the device doesn't support REQ_OP_DISCARD_ZERO, it rejects the bio
>>> and the caller is supposed to do zeroing manually.
>>
>> Sorry but I don't like this proposal. I think that a much better solution
>> would be to pause I/O before making any changes to the discard_zeroes_data
>> flag.
>
> The device mapper pauses all bios when it switches the table - but the bio
> was submitted with assumption that it goes to a device withe
> "discard_zeroes_data" set, then the bio is paused, device mapper table is
> switched, the bio is unpaused, and now it can go to a device without
> "discard_zeroes_data".

Hello Mikulas,

Sorry if I wasn't clear enough. What I meant is to wait until all 
outstanding requests have finished before modifying the 
discard_zeroes_data flag - the kind of operation that is performed by 
e.g. blk_mq_freeze_queue(). Modifying the discard_zeroes_data flag after 
a bio has been submitted and before it has completed could lead to 
several classes of subtle bugs. Functions like __blkdev_issue_discard() 
assume that the value of the discard_zeroes_data flag does not change 
after this function has been called and before the submitted requests 
completed.

Bart.
