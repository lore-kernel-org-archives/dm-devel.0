From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [RFC] [PATCH] lvm2: mirroredlog support
Date: Mon, 19 Jan 2009 17:56:36 -0500
Message-ID: <49750524.3030007@redhat.com>
References: <20081230001055.GA13710@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
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
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Hi,

I'm interested in the mirrored log approach which Malahal posted,
and now I'm looking into it. However, I found one problem with it.

When one of log disk is broken and is not recognized, there is a case
disk that replication is executed. Let me explain with the following
simple case, which is the mirror volume, vg00-lv00 is composed of two
data disks and one mirrored log which is composed of two log disks.

  vg00-lv00 (253:5)
    +vg00-lv00_mimage_1 (253:4)
    +vg00-lv00_mimage_0 (253:3)
    +vg00-lv00_mlog (253:2)
       +vg00-lv00_mlog_mimage_1 (253:1)
       +vg00-lv00_mlog_mimage_0 (253:0)

In this structure, if vg00-lv00_mlog_mimage_0 has problem and is not
accessed successfully, vg00-lv00_mlog is detected as a failed device
when vg00-lv00 is activated. The status of log device in vg00-lv00 is
displayed as "D". In addition, a whole data in vg00-lv00_mimage0 is
copied to vg00-lv00_mimage_1.

  # vgchange -ay vg00 -P
    Partial mode. Incomplete volume groups will be activated read-only.
    Couldn't find device with uuid 'aLl1CE-69hT-Mghu-UvqX-aBpA-twhk-jXO5Ut'.
    Couldn't find device with uuid 'aLl1CE-69hT-Mghu-UvqX-aBpA-twhk-jXO5Ut'.
    Couldn't find device with uuid 'aLl1CE-69hT-Mghu-UvqX-aBpA-twhk-jXO5Ut'.
    Couldn't find device with uuid 'aLl1CE-69hT-Mghu-UvqX-aBpA-twhk-jXO5Ut'.
    1 logical volume(s) in volume group "vg00" now active

  # dmsetup status
  vg00-lv00_mimage_1: 0 24576 linear 
  vg00-lv00_mlog_mimage_1: 0 8192 linear 
  vg00-lv00_mimage_0: 0 24576 linear 
  vg00-lv00_mlog_mimage_0: 0 8192 linear 
  vg00-lv00_mlog_mimage_0-missing_0_0: 0 8192 error 
  vg00-lv00_mlog: 0 8192 mirror 2 253:1 253:2 0/8 1 DA 1 core
  vg00-lv00: 0 24576 mirror 2 253:4 253:5 24/24 1 AA 3 disk 253:3 D

On the other hand, when vg00-lv00_mlog_mimage_0 is in a good condition
but vg00-lv00_mlog_mimage_1 has a issue, vg00-lv00_mlog is recognized
as an active device, and the status of log device in vg00-lv00 is
displayed as "A". This is an expected result.

  # /sbin/dmsetup status
  vg00-lv00_mimage_1: 0 24576 linear 
  vg00-lv00_mlog_mimage_1: 0 8192 linear 
  vg00-lv00_mimage_0: 0 24576 linear 
  vg00-lv00_mlog_mimage_0: 0 8192 linear 
  vg00-lv00_mlog: 0 8192 mirror 2 253:0 253:2 0/8 1 AD 1 core
  vg00-lv00: 0 24576 mirror 2 253:4 253:5 24/24 1 AA 3 disk 253:3 A
  vg00-lv00_mlog_mimage_1-missing_0_0: 0 8192 error 


* Analysis of this problem

A mirrored log is a type of "core" log and log devices need to be
synchronized when a mirrored log is activated. But when the first log
device is not recognized, "READ" I/O returns -EIO in disk_resume()
because log disk is not in-sync status and a default log can not be
switched to the other log disk working well.


Avoiding disk replication even if a log device got trouble is one of
the requirements. Is there any solution to avoid this problem by the
mirrored log approach?

I appreciate any comments on this problem.

Thanks,
---
Takahiro Yasui
Hitachi Computer Products (America) Inc.
