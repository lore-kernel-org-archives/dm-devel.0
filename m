From: Pierre Beck <debian-bugs@pierre-beck.de>
Subject: dm-cache policy mq: promotion very picky?
Date: Mon, 13 May 2013 23:23:04 +0200
Message-ID: <519159B7.3030205@pierre-beck.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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

Hi,

experimenting with dm-cache, I came across the following issue:

Having a rather large SSD available, I wanted to promote sequential I/O 
just like random I/O. Recurring sequential I/O is just as bad in a 
multi-user scenario, especially with unpromoted random I/O mixed in. So 
my dmsetup line looks like this:

# dmsetup create hybridStorage --table "0 7771064048 cache 
/dev/disk/by-id/xxx-part4 /dev/disk/by-id/yyy-part3 /dev/md/zzz 512 1 
writethrough mq 4 sequential_threshold 4294967295 random_threshold 0";

(I would appreciate a parameter to just turn random I/O detection off, btw.)

On top of "hybridStorage" an ext4 with external journal. Then, I repeat:

# echo 1 > /proc/sys/vm/drop_caches; pv smallwrite.0 > /dev/null

And watch a dstat with all relevant partitions. The 70 MB file 
"smallwrite.0" is always being read from HDD and never gets promoted. 
Only a few blocks got promoted at some point in the past.

# echo 1 > /proc/sys/vm/drop_caches; ioping -R smallwrite.0

This doesn't promote blocks, either, although it is random I/O.

# echo 1 > /proc/sys/vm/drop_caches; ioping -s 1m -R smallwrite.0

This does promote a few blocks every iteration.

# dd if=/dev/zero of=testfile bs=4096 count=100000; sync

This file was promoted halfway. Again, just piping it with pv doesn't 
promote any blocks. Piping with "cat" does promote a few blocks every 
iteration.

All in all, dm-cache policy mq seems to be very hesitant (way too 
hesitant for my taste) promoting blocks, even with sequential I/O allowed.

Maybe I'm misunderstanding how the heuristics work - what makes mq pick 
a block for promotion?

Regards,

Pierre Beck
