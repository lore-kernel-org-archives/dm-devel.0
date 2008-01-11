From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: can I create static /dev/dm-XY device mappings?
Date: Fri, 11 Jan 2008 14:52:41 +0100
Message-ID: <478774A9.1010104@wpkg.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
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
List-Id: dm-devel.ids

Is it possible to create static /dev/dm-XY device mappings?

I have an encrypted disk, later partitioned, DRBD over it, and finally, 
LVM2 over it.

LVM2 gets confused, and detects physical volume with duplicate IDs 
(/dev/drbd0 and /dev/dm-2).

So far my only workaround was to filter out /dev/dm-2 in lvm.conf, but 
as /dev/dm-XY are not static, this solution is not very reliable.


This is a udev rule which creates these mappings, but I've no idea how 
to change it to make all or certain mappings static.

#
# multipath and multipath partitions nodes are created in /dev/mapper/
# this file should be installed in /etc/udev/rules.d
#

# take care of devmap partitioning
ACTION=="add", SUBSYSTEM=="block", KERNEL=="dm-*", \
         PROGRAM="/sbin/dmsetup -j %M -m %m --noopencount --noheadings 
-c -o name info", \
         RUN+="/sbin/kpartx -a /dev/mapper/%c"


Any clues?


-- 
Tomasz Chmielewski
http://wpkg.org
