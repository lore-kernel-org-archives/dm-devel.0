From: Takahiro Yasui <tyasui@redhat.com>
Subject: [RFC] Redundant LVM mirror log
Date: Thu, 16 Jul 2009 15:55:31 -0400
Message-ID: <4A5F85B3.1080906@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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
To: agk@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

I would like to solve an issue that LVM mirror can use only one
mirror log. I hope this post would start good discussion and go
forward to solve it.


ISSUES
======

Current implementation allows LVM mirror to use only one log disk.
A log disk keeps a bitmap and a each bit in the bitmaps shows the
status (in-sync or out-of-sync) of a region among mirror legs.
When a mirror is activated, log disk is checked and the data in the
out-of-sync region is copied from primary mirror device to others.

However, once a log disk gets broken, and the data in the log disk
can not be read, data replications for a whole disk are required
when the mirror is activated since LVM mirror (dm-mirror) can not
decide which regions are in-sync.

If mirror disk size is huge, it takes long time for disk replication,
and it utilizes much system resources, such as I/O bandwidth, CPU,
memory. That would cause system performance degradation until disk
replication completes. A log disk failure at boot is highly possible,
and the whole disk replication should be avoided.


PROPOSED APPROACH
=================

We have discussed two approaches to configure more than one log
disk so far.

  - dm-log: support multi-log devices
    https://www.redhat.com/archives/dm-devel/2008-November/msg00113.html

  - lvm2: mirroredlog support (posted by malahal)
    https://www.redhat.com/archives/dm-devel/2008-December/msg00095.html

The first approach, multi-log, is a kernel side approach and can
do quick disk blockage inside the kernel, while mirroredlog uses
current mirroring feature and constructs a log disk as a mirrored
disk.

I think that the mirroredlog approach is a quick and easy way to
achieve redundant mirror log. I would like to proceed the mirroredlog
approach so that it is merged into upstream.

I appreciate your comments.

Thanks,
---
Takahiro Yasui
Hitachi Computer Products (America) Inc.
