From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v2] dm: add topology support
Date: Fri, 12 Jun 2009 09:45:34 +0100
Message-ID: <20090612084534.GX647@agk-dp.fab.redhat.com>
References: <1244524492-2292-1-git-send-email-snitzer@redhat.com>
	<yq1ski860ok.fsf@sermon.lab.mkp.net>
	<20090610140028.GD25088@redhat.com>
	<yq1ocsw55t6.fsf@sermon.lab.mkp.net>
	<20090610211235.GF25088@redhat.com>
	<yq1k53j68wj.fsf@sermon.lab.mkp.net>
	<20090610230804.GR647@agk-dp.fab.redhat.com>
	<20090612041757.GA19697@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090612041757.GA19697@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

On Fri, Jun 12, 2009 at 12:17:57AM -0400, Mike Snitzer wrote:
> But the following still establishes each target device's limits during
> stage1 (dm_set_device_limits).  I don't see a way to avoid this given
> that we only know the table's target devices (and associated bdev and
> request_queue) through each target's ctr():
 
Also available from:
  struct list_head *dm_table_get_devices(struct dm_table *t)
(A list of struct dm_dev_internal, defined in dm.h.)

We might need to pass the offset at which the device occurs
within the table into dm_get_device() and, for now, only storing
it there first time for each device and assume userspace has taken
account of the alignment offset consistently.

> 	       	  -> blk_stack_limits(ti, bdev->q->limits)
> 		     [NOTE: changed to: ti->limits = q->limits below]
> 		     [NOTE: this copy can't be delayed, need
> 		      access to target's bdev; only available through
> 		      ctr's params]

See above.

> -	if (blk_stack_limits(&ti->limits, &q->limits, 0) < 0)
> -		DMWARN("%s: target device %s is misaligned",
> -		       dm_device_name(ti->table->md), bdevname(bdev, b));

Userspace code is responsible for avoiding these cases, but we could now
move the misalignment warnings (without failing) to dm_table_set_restrictions().

> +	 * Each target device in the table has a data area that is aligned
> +	 * (via LVM2) so the DM device's alignment_offset should be 0.

There are userspace users other than LVM2:-)
Use dm_table_get_devices() here with the offset stored earlier instead,
removing struct queue_limits from struct dm_table.

Alasdair
