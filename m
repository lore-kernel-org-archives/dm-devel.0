From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: How can need dm use limits.max_hw_sectors from the bdev?
Date: Sat, 16 Jan 2016 22:34:25 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1601162216380.22808@mail.ewheeler.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello all,

I'm writing a trivial dm target and hitting errors like this:
   io too big device loop0 (2048 > 255)

which looks like the problem described here:
	https://bugzilla.kernel.org/show_bug.cgi?id=9401#c3

and is is consistent:
	cat /sys/block/loop0/queue/max_hw_sectors_kb 
	127
	# cat /sys/block/dm-4/queue/max_hw_sectors_kb 
	2147483647

By tracing from sysfs it looks like I need to do something like this when 
called from the target constructor (dm_ctr_fn target_type.ctr) function:

    target->table->md->queue->limits.max_hw_sectors =
        priv->dm_dev_bdev->bdev->bd_queue->limits.max_hw_sectors;

but I cannot because `struct md` and `struct mapped_device` are opaque
which makes me think there is a better (correct) way to do this.  Is there a way
to change my target device's max_hw_sectors value to 127?

Is there some other generic solution?

Would late bio splitting solve this?

-Eric
