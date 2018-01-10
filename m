From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [for-4.16 PATCH v2 2/3] block: cope with gendisk's 'queue' being
 added later
Date: Wed, 10 Jan 2018 15:55:43 +0800
Message-ID: <CACVXFVPGesRgLCShzLkXYw+fbefPMLEEqc05Xa_w3qiXqrDFvA@mail.gmail.com>
References: <20180110024104.34885-1-snitzer@redhat.com> <20180110024104.34885-3-snitzer@redhat.com>
 <CACVXFVPWEsfv+xEWiAL5nT1p9FazgMcH1U7h7zCA_CSQqrEMiw@mail.gmail.com> <20180110042113.GA20494@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180110042113.GA20494@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <Bart.VanAssche@wdc.com>, linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Wed, Jan 10, 2018 at 12:21 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Tue, Jan 09 2018 at 10:46pm -0500,
> Ming Lei <tom.leiming@gmail.com> wrote:
>
>> Hi Mike,
>>
>> On Wed, Jan 10, 2018 at 10:41 AM, Mike Snitzer <snitzer@redhat.com> wrote:
>> > Since I can remember DM has forced the block layer to allow the
>> > allocation and initialization of the request_queue to be distinct
>> > operations.  Reason for this was block/genhd.c:add_disk() has required
>> > that the request_queue (and associated bdi) be tied to the gendisk
>> > before add_disk() is called -- because add_disk() also deals with
>> > exposing the request_queue via blk_register_queue().
>> >
>> > DM's dynamic creation of arbitrary device types (and associated
>> > request_queue types) requires the DM device's gendisk be available so
>> > that DM table loads can establish a master/slave relationship with
>> > subordinate devices that are referenced by loaded DM tables -- using
>> > bd_link_disk_holder().  But until these DM tables, and their associated
>> > subordinate devices, are known DM cannot know what type of request_queue
>> > it needs -- nor what its queue_limits should be.
>>
>> Maybe DM is the only kind of this case, but it is easy to cause
>> trouble by adding disk before setting up queue.
>>
>> In theory, once disk is added, it becomes visible for external world, and
>> IO starts to come and sysfs operations come too, then block has to deal
>> with these cases.
>
> Hi,
>
> Yes, I had concerns about this.  But that theory is for a fully formed
> disk (one that has a request_queue attached to disk->queue).  So far my
> testing of these changes with DM (using various testsuites) hasn't
> encountered _any_ problems.
>
> But please try to break it... ;)
> I have the changes in a git branch here:
> https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=block-4.16
>
>> Another related issue is that blk-mq debugfs can't work yet for dm-mpath.
>
> Not sure how that is a related issue to this thread.
> But can you expand on that?  I'm not familiar with "blk-mq debugfs".
> Any pointer to code that activates it?  Could be that my changes make it
> work now...

Hi,

blk_mq_debugfs_register() is called in blk_register_queue() from add_disk(),
and blk_mq_debugfs_register() need queue's information to setup mq debugfs
stuff.

But your patch does fix this issue, cool!

>
>> So I am just wondering if it is possible to follow the usual way to add disk
>> after setting up queue for DM? If it is possible, it may avoid lots of trouble
>> for us.
>
> As I explained in the header (quoted above actually) it is _not_
> possible.  It is the gendisk that enables the device stack to be
> constructed (at least how DM's stacking is currently implemented with
> bd_link_disk_holder() and taking references on devices found in a DM
> device's table).  And from that gendisk I can then walk the devices to
> establish the request_queue as needed, its stacked limits, etc.
>
> The approach I've taken in these patches is the closest I've gotten to
> make DM _much_ more sane about how its request_queue is established.
> But its still off the beaten path due to needing "block: cope with
> gendisk's 'queue' being added later".

OK, thanks for your explanation.

After taking close look at your patches, I think this approach is clean.
But there are still corner cases which need to be addressed:

1) in the following disk attributes, queue is referenced, so we have
to add check in their show/store operations since the attributes
are shown up just after disk is added.

     disk_alignment_offset_show
     disk_discard_alignment_show
     part_timeout_show/part_timeout_store

2) same issue on /proc/diskstats: see diskstats_show()

3) in IO path, looks we already checked disk->queue in
generic_make_request_checks(), so it should be fine, and you set
disk->queue after the queue is fully initialized in the 3rd patch.

Thanks,
Ming Lei
