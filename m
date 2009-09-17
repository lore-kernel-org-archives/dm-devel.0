From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: fragmented i/o with 2.6.31?
Date: Thu, 17 Sep 2009 17:02:39 +0900
Message-ID: <4AB1ED1F.1010203@ct.jp.nec.com>
References: <448b15030909160834j2b127c83jab163e1860fc9aa1@mail.gmail.com>
	<448b15030909160922o84c2d6gc8ead8226dd8777a@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <448b15030909160922o84c2d6gc8ead8226dd8777a@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Strand <dpstrand@gmail.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi David, Mike, Alasdair,

On 09/17/2009 01:22 AM +0900, David Strand wrote:
> On Wed, Sep 16, 2009 at 8:34 AM, David Strand <dpstrand@gmail.com> wrote:
>> I am issuing 512 Kbyte reads through the device mapper device node to
>> a fibre channel disk. With 2.6.30 one read command for the entire 512
>> Kbyte length is placed on the wire. With 2.6.31 this is being broken
>> up into 5 smaller read commands placed on the wire, decreasing
>> performance.
>>
>> This is especially penalizing on some disks where we have prefetch
>> turned off via the scsi mode page. Is there any easy way (through
>> configuration or sysfs) to restore the single read per i/o behavior
>> that I used to get?
>
> I should note that I am using dm-mpath, and the i/o is fragmented on
> the wire when using the device mapper device node but it is not
> fragmented when using one of the regular /dev/sd* device nodes for
> that device.

David,
Thank you for reporting this.
I found on my test machine that max_sectors is set to SAFE_MAX_SECTORS,
which limits the I/O size small.
The attached patch fixes it.  I guess the patch (and increasing
read-ahead size in /sys/block/dm-<n>/queue/read_ahead_kb) will solve
your fragmentation issue.  Please try it.


Mike, Alasdair,
I found that max_sectors and max_hw_sectors of dm device are set
in smaller values than those of underlying devices.  E.g:
    # cat /sys/block/sdj/queue/max_sectors_kb
    512
    # cat /sys/block/sdj/queue/max_hw_sectors_kb
    32767
    # echo "0 10 linear /dev/sdj 0" | dmsetup create test
    # cat /sys/block/dm-0/queue/max_sectors_kb
    127
    # cat /sys/block/dm-0/queue/max_hw_sectors_kb
    127
This prevents the I/O size of struct request from becoming enough big
size, and causes undesired request fragmentation in request-based dm.

This should be caused by the queue_limits stacking.
In dm_calculate_queue_limits(), the block-layer's small default size
is included in the merging process of target's queue_limits.
So underlying queue_limits is not propagated correctly.

I think initializing default values of all max_* in '0' is an easy fix.
Do you think my patch is acceptable?
Any other idea to fix this problem?

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: David Strand <dpstrand@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-table.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: 2.6.31/drivers/md/dm-table.c
===================================================================
--- 2.6.31.orig/drivers/md/dm-table.c
+++ 2.6.31/drivers/md/dm-table.c
@@ -992,9 +992,13 @@ int dm_calculate_queue_limits(struct dm_
 	unsigned i = 0;
 
 	blk_set_default_limits(limits);
+	limits->max_sectors = 0;
+	limits->max_hw_sectors = 0;
 
 	while (i < dm_table_get_num_targets(table)) {
 		blk_set_default_limits(&ti_limits);
+		ti_limits.max_sectors = 0;
+		ti_limits.max_hw_sectors = 0;
 
 		ti = dm_table_get_target(table, i++);
 
