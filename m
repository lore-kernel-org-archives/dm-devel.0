From: Andreas Beckmann <beckmann@cs.uni-frankfurt.de>
Subject: discard/trim support in device mapper?
Date: Sun, 21 Mar 2010 11:16:22 +0100
Message-ID: <4BA5F1F6.2050804@cs.uni-frankfurt.de>
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

Hi,

since 2.6.33 the ext4 file system supports emitting DISCARD/TRIM/...
commands that notify the disk about deleted blocks that may be reused by
 the disk for whatever it wants. This is especially helpful for SSDs to
reduce performance degradation due to internal fragmentation ...

What are the plans / is the status for adding DISCARD support to the
device mapper? Especially for RAID-0/RAID-1 configurations with multiple
SSDs this will be really helpful. The DISCARD requests received from the
file system layer just need to be translated/duplicated to the sector
ranges on the physical disks and than the appropriate commands for the
disks need to be generated.

If there is anything to be tested, I'm willing to help. I have a machine
with 4 SuperTalent FTM56GX25H SSDs (firmware 1916) that happily do TRIM
if they are used as single disks, but not in a 1TB RAID-0 configuration
managed via LVM.

Experiments have shown significant performance improvements (factor 4-5)
for some heavy I/O loads on single SSD (250 GB) using DISCARD, I'd like
to achieve them for a larger data set (1 TB), too.


Andreas
