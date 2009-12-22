From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm: Fix alignment stacking on partitioned devices
Date: Tue, 22 Dec 2009 12:41:31 -0500
Message-ID: <yq1my1a52k4.fsf@sermon.lab.mkp.net>
References: <yq1aaxg7n84.fsf@sermon.lab.mkp.net>
	<20091218173322.GA4163@redhat.com>
	<yq14onk5iaa.fsf@sermon.lab.mkp.net>
	<20091221195204.GA28703@redhat.com>
	<yq1r5qn4orc.fsf@sermon.lab.mkp.net>
	<20091222143240.GA9154@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091222143240.GA9154@redhat.com> (Mike Snitzer's message of
	"Tue, 22 Dec 2009 09:32:40 -0500")
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
Cc: device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike,

Mike> OK, so is MD somehow getting things wrong?  (You originally said
Mike> that with the new stacking function MD resulted in an error but DM
Mike> did not).

MD is passing in absolute offsets and got the right result in both
cases.


Mike> "start" isn't a relative offset.  

It's relative to the beginning of the partition (block_device), not
relative to the beginning of the disk (request_queue).

My beef here is that DM created a device like this:

[root@10 ~]# pvs -o +pe_start
  PV         VG   Fmt  Attr PSize   PFree   1st PE 
  /dev/sde1  foo  lvm2 a-   508.00M 256.00M 192.00K
  /dev/sde2  foo  lvm2 a-   512.00M 260.00M 192.00K
[root@10 ~]# dmsetup table
foo-bar: 0 1032192 striped 2 32 8:66 384 8:65 384

/dev/sde  has an alignment_offset of 3584
/dev/sde1 has an alignment_offset of 0
/dev/sde2 has an alignment_offset of 1024

dm_set_device_limits() calls blk_stack_limits() with a byte offset of
196608 for both sde1 and sde2.  And that offset is checked for alignment
with the queue's limits which has an alignment_offset of 3584.

The two PVs are misaligned but that information is lost because you use
blk_stack_limits() with partition-relative offsets.  My patch was an
attempt to fix that.

Test case:

# modprobe scsi_debug dev_size_mb=1024 num_parts=2 lowest_aligned=7 physblk_exp=3
# pvcreate /dev/sde1
# pvcreate /dev/sde2
# vgcreate foo /dev/sde1 /dev/sde2
# lvcreate -I 16 -i 2 -L 500M -n bar foo

-- 
Martin K. Petersen	Oracle Linux Engineering
