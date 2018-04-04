From: Mikulas Patocka <mpatocka@redhat.com>
Subject: device mapper ioctl handling
Date: Wed, 4 Apr 2018 09:34:43 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1804040905340.19168@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I was thinking about that ioctl handling - and the problem is that the 
current code is broken too. The current code does:

1. dm_get_live_table
2. call the "prepare_ioctl" method on the first target, that returns the 
   block device where the ioctl should be forwarded
3. call bdgrab on the block device
4. call blkdev_get on the block device
5. call dm_put_live_table
6. call __blkdev_driver_ioctl to forward the ioctl to the target device
7. call blkdev_put

One problem: bdgrab is not paired with bdput, so it introduces a memory 
leak? Perhaps it should be deleted.

The second problem: it may call ioctl on a device that is not part of a dm 
table. Between step 5 and step 6, the table may be reloaded with a 
different target, but it still calls the ioctl on the old device.

So - we need to prevent table reload while the ioctl is in progress.

But there is another possible problem - there is multipath flag 
MPATHF_QUEUE_IF_NO_PATH and the ioctl may take indefinite time if the flag 
is set and there is no active path. In this situation it would prevent 
reloading the upper targets above the multipath target. But I think this 
is acceptable - if the multipath device has MPATHF_QUEUE_IF_NO_PATH set, 
bios sent to the device are queued indefinitely and these queued bios 
would already prevent suspending the upper layer device mapper devices. 
So, if a stuck ioctl prevents suspending the upper layer devices, it 
doesn't make it worse.

Mikulas
