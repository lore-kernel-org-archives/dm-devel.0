From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [dm-devel] [PATCH] Fix over-zealous flush_disk when changing device size.
Date: Thu, 17 Mar 2011 13:33:38 -0400
Message-ID: <x49ipvhslcd.fsf@segfault.boston.devel.redhat.com>
References: <20110217165057.5c50e566@notabene.brown>
	<20110303143120.GA8134@infradead.org>
	<20110304111624.4be27aaf@notabene.brown>
	<1299259506.2118.24.camel@grinch>
	<20110306174755.49404c8e@notabene.brown>
	<1299471771.2228.11.camel@grinch>
	<1299516418.15258.4.camel@mulgrave.site>
	<20110308094412.1c45b277@notabene.brown>
	<1299538572.15955.90.camel@mulgrave.site>
	<20110308110453.0047307d@notabene.brown>
	<x49pqpq95b5.fsf@segfault.boston.devel.redhat.com>
	<20110317122833.30077397@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110317122833.30077397@notabene.brown> (NeilBrown's message of
	"Thu, 17 Mar 2011 12:28:33 +1100")
Sender: linux-fsdevel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

NeilBrown <neilb@suse.de> writes:

> On Wed, 16 Mar 2011 16:30:22 -0400 Jeff Moyer <jmoyer@redhat.com> wrote:
>
>> NeilBrown <neilb@suse.de> writes:
>> 
>> >> Synchronous notification of errors.  If we don't try to write everything
>> >> back immediately after the size change, we don't see dirty pages in
>> >> zapped regions until the writeout/page cache management takes it into
>> >> its head to try to clean the pages.
>> >> 
>> >
>> > So if you just want synchronous errors, I think you want:
>> >     fsync_bdev()
>> >
>> > which calls sync_filesystem() if it can find a filesystem, else
>> > sync_blockdev();  (sync_filesystem itself calls sync_blockdev too).
>> 
>> ... which deadlocks md.  ;-)  writeback_inodes_sb_nr is waiting for the
>> flusher thread to write back the dirty data.  The flusher thread is
>> stuck in md_write_start, here:
>> 
>>         wait_event(mddev->sb_wait,
>>                    !test_bit(MD_CHANGE_PENDING, &mddev->flags));
>> 
>> This is after reverting your change, and replacing the flush_disk call
>> in check_disk_size_change with a call to fsync_bdev.  I'm not familiar
>> enough with md to really suggest a way forward.  Neil?
>
> That would be quite easy to avoid.
> Just call
>    md_write_start()
> before revalidate_disk, and
>    md_write_end()
> afterwards.

That does not avoid the problem (if I understood your suggestion).  You
instead end up with the following:

INFO: task md127_raid5:2282 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
md127_raid5     D ffff88011c72d0a0  5688  2282      2 0x00000080
 ffff880118997c20 0000000000000046 ffff880100000000 0000000000000246
 0000000000014d00 ffff88011c72cb10 ffff88011c72d0a0 ffff880118997fd8
 ffff88011c72d0a8 0000000000014d00 ffff880118996010 0000000000014d00
Call Trace:
 [<ffffffff8138bbbd>] md_write_start+0xad/0x1d0
 [<ffffffff810801d0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffffa0311558>] raid5_finish_reshape+0x98/0x1e0 [raid456]
 [<ffffffff8138a933>] reap_sync_thread+0x63/0x130
 [<ffffffff8138c8b6>] md_check_recovery+0x1f6/0x6f0
 [<ffffffffa03150ab>] raid5d+0x3b/0x610 [raid456]
 [<ffffffff810804c9>] ? prepare_to_wait+0x59/0x90
 [<ffffffff81387ee9>] md_thread+0x119/0x150
 [<ffffffff810801d0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81387dd0>] ? md_thread+0x0/0x150
 [<ffffffff8107fb56>] kthread+0x96/0xa0
 [<ffffffff8100cc04>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fac0>] ? kthread+0x0/0xa0
 [<ffffffff8100cc00>] ? kernel_thread_helper+0x0/0x10

I'll leave this to you to work out when you have time.

Cheers,
Jeff
