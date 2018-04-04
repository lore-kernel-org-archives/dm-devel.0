From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: device mapper ioctl handling
Date: Wed, 4 Apr 2018 10:02:28 -0400
Message-ID: <20180404140228.GB14708@redhat.com>
References: <alpine.LRH.2.02.1804040905340.19168@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1804040905340.19168@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Apr 04 2018 at  9:34am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> I was thinking about that ioctl handling - and the problem is that the 
> current code is broken too. The current code does:
> 
> 1. dm_get_live_table
> 2. call the "prepare_ioctl" method on the first target, that returns the 
>    block device where the ioctl should be forwarded
> 3. call bdgrab on the block device
> 4. call blkdev_get on the block device
> 5. call dm_put_live_table
> 6. call __blkdev_driver_ioctl to forward the ioctl to the target device
> 7. call blkdev_put
> 
> One problem: bdgrab is not paired with bdput, so it introduces a memory 
> leak? Perhaps it should be deleted.

No, bdgrab() is required prior to blkdev_get().
blkdev_get()'s error path will bdput().  Otherwise, blkdev_put() will
bdput() via __blkdev_put().

So no, this aspect of the code is correct.  Looks funny for sure (but
that is just a quirk of the block interfaces).

> The second problem: it may call ioctl on a device that is not part of a dm 
> table. Between step 5 and step 6, the table may be reloaded with a 
> different target, but it still calls the ioctl on the old device.
>
> So - we need to prevent table reload while the ioctl is in progress.

But it _was_ part of a DM table.  Hard to assert that this race on table
unload is reason for alarm.  Even if ioctl is successful, what is the
_real_ harm associated with losing that race?

I mean I agree that ideally we wouldn't issue the ioctl if the table
were unload just prior.  A deeper mutual exclussion is needed.
 
> But there is another possible problem - there is multipath flag 
> MPATHF_QUEUE_IF_NO_PATH and the ioctl may take indefinite time if the flag 
> is set and there is no active path. In this situation it would prevent 
> reloading the upper targets above the multipath target. But I think this 
> is acceptable - if the multipath device has MPATHF_QUEUE_IF_NO_PATH set, 
> bios sent to the device are queued indefinitely and these queued bios 
> would already prevent suspending the upper layer device mapper devices. 
> So, if a stuck ioctl prevents suspending the upper layer devices, it 
> doesn't make it worse.

Except that it is possible to suspend _without_ flush (and multipathd
does do that to be able to reload a multipath table that has no valid
paths and queue_if_no_path is configured).

We discussed this MPATHF_QUEUE_IF_NO_PATH case yesterday in the context
of holding the live DM table for the duration of the ioctl (via
dm_get_live_table).  The MPATHF_QUEUE_IF_NO_PATH case is particularly
problematic for this dm_get_live_table based solution:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.17&id=7e3990b5e0a2ac6f980adeb030d230b600ecdc4d

Meaning I'll need to drop that patch.

But above, you're saying that case is a problem even for the code that
is currently in upstream v4.16?

Not following, how.. given no-flush suspend + reload allows multipathd
to recover.  In addition, dm_get_bdev_for_ioctl()'s 'goto retry' will
recheck if there is a valid table (via dm_get_live_table).  SO that race
isn't a concern there.  But even without that case, the ioctl won't
prevent a reload from happening.  Unless I'm stil missing something?...

Mike
