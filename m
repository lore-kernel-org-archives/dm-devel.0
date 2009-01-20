From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [RFC] [PATCH] lvm2: mirroredlog support
Date: Tue, 20 Jan 2009 16:29:35 -0500
Message-ID: <4976423F.2070103@redhat.com>
References: <20081230001055.GA13710@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081230001055.GA13710@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: malahal@us.ibm.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

malahal@us.ibm.com wrote:
> This patch adds '--mirroredlog' option to LVM commands to create a
> mirror with mirrored log device. Rebased to the latest LVM code
> (LVM2.2.02.43). Appreciate any comments.

Hi, Malahal

This is the additional test results of mirrored log. Currently your
patch is proposed by "RFC", and these might be known issues to you,
but I hope this reports would be helpful to improve your patch.
Any comments are welcome.


0. Test environment
  - LVM2.2.02.43 with mirrored log patch
  - vg00 is composed of 8 PVs (/dev/sd[c-j])


1. SIGSEGV at converting a core log to a mirrored log

  # dmsetup status
  vg00-lv00_mimage_1: 0 24576 linear
  vg00-lv00_mimage_0: 0 24576 linear
  vg00-lv00: 0 24576 mirror 2 253:3 253:4 24/24 1 AA 1 core

  # lvconvert -m1 --mirroredlog /dev/vg00/lv00
  Segmentation fault

  # lvconvert -m2 --mirroredlog /dev/vg00/lv00
  Segmentation fault


2. Fail at conversion from 2 legs to 3 legs

  lv00 in vg00 has 2 legs (2 log legs and 2 data legs), and when it is
  converted to the structure with 3 lets, the conversion fails.

  vg00-lv00 (253:5)
   + vg00-lv00_mimage_1 (253:4)
   + vg00-lv00_mimage_0 (253:3)
   + vg00-lv00_mlog (253:2)
      + vg00-lv00_mlog_mimage_1 (253:1)
      + vg00-lv00_mlog_mimage_0 (253:0)

  # lvconvert -m2 --mirroredlog /dev/vg00/lv00
    device-mapper: reload ioctl failed: No such device or address
    Failed to lock lv00
  # dmsetup status
  vg00-lv00_mimage_2: 0 8192 linear    <-- data leg is created
  vg00-lv00_mimage_1: 0 24576 linear
  vg00-lv00_mlog_mimage_1: 0 8192 linear
  vg00-lv00_mimage_0: 0 24576 linear
  vg00-lv00_mlog_mimage_0: 0 8192 linear
  vg00-lv00_mimagetmp_2: 0 24576 error <-- temporary data log exists
  vg00-lv00_mlog: 0 8192 mirror 2 253:1 253:2 8/8 1 AA 1 core
  vg00-lv00: 0 24576 mirror 2 253:4 253:5 24/24 1 AA 3 disk 253:3 A


3. Fail at conversion from disk log to mirrored log

  # dmsetup status
  vg00-lv00_mimage_1: 0 24576 linear
  vg00-lv00_mimage_0: 0 24576 linear
  vg00-lv00_mlog: 0 8192 linear
  vg00-lv00: 0 24576 mirror 2 253:1 253:2 24/24 1 AA 3 disk 253:0 A

  # lvconvert -m1 --mirroredlog /dev/vg00/lv00
  Logical volume lv00 already has 1 mirror(s).

   => disk log should be converted to mirrored log?

  # lvconvert -m2 --mirroredlog /dev/vg00/lv00
  device-mapper: reload ioctl failed: No such device or address
  Failed to lock lv00
  # dmsetup status
  vg00-lv00_mimage_2: 0 8192 linear
  vg00-lv00_mimage_1: 0 24576 linear
  vg00-lv00_mimage_0: 0 24576 linear
  vg00-lv00_mimagetmp_2: 0 24576 error
  vg00-lv00_mlog: 0 8192 linear
  vg00-lv00: 0 24576 mirror 2 253:1 253:2 24/24 1 AA 3 disk 253:0 A

   => disk log should be converted to mirrored log with 3 legs?


Thanks,
---
Takahiro Yasui
Hitachi Computer Products (America), Inc.
