From: Nikolay Borisov <kernel@kyup.com>
Subject: Cannot delete lvm thin volume
Date: Fri, 16 Oct 2015 15:24:54 +0300
Message-ID: <5620EC96.3090205@kyup.com>
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
To: zkabelac@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, SiteGround Operations <operations@siteground.com>
List-Id: dm-devel.ids

Hello I have the following thin volume, which I'd like to delete:

lvdisplay -v /dev/coregroup/c13537_2k
    Using logical volume(s) on command line.
  --- Logical volume ---
  LV Path                /dev/coregroup/c13537_2k
  LV Name                c13537_2k
  VG Name                coregroup
  LV UUID                LBPr0i-uac8-i3Co-5B3M-A6Bv-q8iv-kSRLRr
  LV Write Access        read/write
  LV Creation host, time xxxxx.net, 2015-10-14 02:02:45 -0500
  LV Pool name           corepool
  LV Status              available
  # open                 1
  LV Size                1.80 TiB
  Mapped size            42.11%
  Current LE             471808
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:6

dmsetup info coregroup-c13537_2k
Name:              coregroup-c13537_2k
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        1
Event number:      1
Major, minor:      252, 6
Number of targets: 1
UUID: LVM-M8PwSxzGcsZQTtdgzfixsr08ZAlNpAbALBPr0iuac8i3Co5B3MA6Bvq8ivkSRLRr

dmsetup status
coregroup-c13537_2k: 0 3865051136 thin 1627684864 3865042943

The version of the software is:
lvremove --version
  LVM version:     2.02.118(2)-RHEL6 (2015-09-08)
  Library version: 1.02.95-RHEL6 (2015-09-08)
  Driver version:  4.26.0

And the kernel is 3.12.47.

When I run 'lvremove -f /dev/coregroup/c13537_2k' I get the following
error: Logical volume coregroup/c13537_2k contains a filesystem in use.
I also get the same error when I try to deactivate the volume.

fuser doesn't report anything and the volume is not mounted anywhere. I
have also acquired an ftrace trace from executing lvremove but there are
multiple invocation of the dm_ioctl function and I'm not sure which one
is the relevant. So if you tell me what information in particular you
need I'd post it here.

Regards,
Nikolay
