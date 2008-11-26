From: Takahiro Yasui <tyasui@redhat.com>
Subject: [RFC][PATCH 0/4] dm-log: support multi-log devices
Date: Tue, 25 Nov 2008 19:01:35 -0500
Message-ID: <492C91DF.7040507@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
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
Cc: Alasdair G Kergon <agk@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
List-Id: dm-devel.ids

Hi All,

This is my first post to this mailing list, but let me introduce
a patch set to implement multi-log devices for dm-mirror.
I appreciate your kind comments and suggestions on this patch set.


PATCH SET
=========
  1/4: dm-log: fix no io_client_destroy
  2/4: dm-log: remove unnecessary updates of io_req members
  3/4: dm-log: introduce multi-log devices
  4/4: dm-log: update interface to control multi-log devices


BACKGROUND
==========

device mapper mirroring (dm-mirror) uses "log" to keep status of
consistency among mirror devices. There are two types of log,
"core" and "disk". The former keep its data only on memory, and
the latter can keep data on a device. When system starts booting
and setup disks managed by device mapper, device mapper checks
log data if each region is in sync state among mirror devices.
And if not, it executes data replication from default-mirror device
to others.

However, once log disk breaks down, data replications are required
for a whole data disks, and if a size of data disk is huge, it
takes long time for disk replication, and it utilizes much system
resources, such as I/O bandwidth, CPU, memory. That might cause
system performance degradation until disk replication completes.

This patch introduces multi-log devices for mirror target, which
stores log data on multiple log devices, and decreases probability
of disk replication even if one log disk has broken down.


DESIGN OVERVIEW
===============

  * maximum number of log devices

    Nine devices, the same maximum number as mirror devices, can be
    used for log devices.

  * error handling during setting up a mirror device

    All log devices should be detected Linux kernel. If any disks
    are not found, a mirror construction will fail.

    Also, log headers are checked if all log devices have the same
    region numbers. New log devices are excluded from this check.
    (They are usually initialized by "0")

  * error handling during I/O operation

    An error has been detected on a log device after a mirror device
    is constructed, the device gets marked "fail". I/O operations
    are done only to valid log devices, and no I/O is issued on
    those failed devices. If all log devices fails, disk log works
    much like "core" log.

  * ioctl interface

    This patch does not affect "core" log interface, but change
    "disk" log interface. To keep backward compatibility, path names
    of log device are just listed without a number of log devices.

    <current interface>

        disk_ctr():
             log_path region_size [[no]sync]

        disk_status() - STATUSTYPE_INFO:
             nr_params disk log_path log_status:"A" or "D"

        disk_status() - STATUSTYPE_TABLE:
            disk nr_params log_path region_size [[no]sync]

    <proposed interface>

        disk_ctr():
            [log_path]{1,} region_size [[no]sync]

        disk_status() - STATUSTYPE_INFO:
            nr_params disk [log_path]{1,} [log_status:"A" or "D"]{1,}

        disk_status() - STATUSTYPE_TABLE:
            disk nr_params [log_path]{1,} region_size [[no]sync]


EXAMPLES
========

  * create mirror with one log device (the same operation as usual)

    # dmsetup create mirror --table \
      "0 2097152 mirror disk 2 253:0 1024 2 253:1 0 253:2 0"
    # dmsetup status mirror
    0 2097152 mirror 2 253:1 253:2 960/2048 1 AA 3 disk 253:0 A

  * create mirror with two log devices [NEW]

    # dmsetup create mirror --table \
      "0 2097152 mirror disk 3 253:0 253:1 1024 2 253:2 0 253:3 0"
    # dmsetup status mirror
    0 2097152 mirror 2 253:2 253:3 2048/2048 1 AA 4 disk 253:0 253:1 AA

  * create mirror with four log devices [NEW]

    # dmsetup create mirror --table \
      "0 2097152 mirror disk 5 253:0 253:1 253:2 253:3 1024 \
       2 253:4 0 253:5 0"
    # dmsetup status mirror
      0 2097152 mirror 2 253:4 253:5 316/2048 1 AA 6 disk \
      253:0 253:1 253:2 253:3 AAAA


FUTURE WORKS
============

  * Independent header and bitmap I/O

    Currently disk_header holds header and bitmap and issue I/O together.
    But header can be modified during construction and resume procedures,
    and we can remove header I/O.

  * Partial bitmap update

    bitmap size could be larger if the amount of mirror devices are huge
    or region size is small. In the current implementation, disk log handles
    bitmap as one buffer and updates a whole bitmap every time. Therefore,
    the amount of I/O issued to a log device could be larger than to mirror
    devices. Partial bitmap update can issue I/O of updated sectors.

---
Takahiro Yasui
Hitachi Computer Products (America) Inc.
