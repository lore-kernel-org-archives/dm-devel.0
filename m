From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH] dm:  dm_table_unplug_all optimization
Date: Tue, 08 Apr 2008 11:20:55 -0700
Message-ID: <20080408182055.1779.69633.stgit@desktop-andmike.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

This patch series provides a optimization to the dm_table_unplug_all
function in device mapper (dm).

A OLTP type workload on a 16core Intel box using a volume containing 48 logical
drives across 3 dual port fiber adapters showed some high oprofile values.

A high oprofile sampling value was seen in dm_table_unplug_all coming from
high contention of the q->queue_lock. Since dm_table_unplug_all will unplug all
devices in the table it can cause contention on the queue_lock with processes
trying to pull requests off the queue even on devices that are not plugged. As
dm_table_unplug_all is coded now blk_unplug will result in the queue_lock being taken for all checks of the queue_flags (blk_remove_plug).

The change lead to a ~16 percent performance improvement on a RedHat
distro kernel. It appears to be a fairly safe change as the worst case if
dm missed a queue to unplug, the queue will get unplugged when the number
of requests exceed (unplug_thresh (4) or unplug_delay (3 ms). It can also
be the case that if post getting the queue_lock and checking for the queue
to be plugged that once the lock is dropped plugging can occur.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
