From: Takahiro Yasui <tyasui@redhat.com>
Subject: [RFC][PATCH 0/4] dm-raid1: fix deadlock at suspend
 after suspend was interrupted (v2)
Date: Tue, 23 Feb 2010 13:45:00 -0500
Message-ID: <4B84222C.9030102@redhat.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lvm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: k-ueda@ct.jp.nec.com, LVM2 development <lvm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

This is an update patch set to fix deadlock on suspending of mirror device.
Based on the Ueda-san's suggestion, I updated the patch set so that a target's
resume handler is used instead of introducing new handler (cancel_presuspend).


ISSUE
=====

Suspend procedure on a dm-mirror device could cause deadlock on recovery_count
semaphore.

When mirror_presuspend is called, recovery_count semaphore is acquired in
dm_rh_stop_recovery() to stop recovery routine, but when an signal is caught
in dm_wait_for_completion() or an error occurred in in dm_suspend(),
the suspend process is interrupted without releasing recovery_count semaphore
of a mirror device. This means that another suspend is executed, and then
the suspend process gets stuck at dm_rh_stop_recovery().

When suspend procedure is interrupted, the device should work properly since
the status of the device is not "suspended."


SOLUTION
========

Restore the target's state change by calling a target's specific resume handler
when its suspend procedure was interrupted after its presuspend handler completed.


PATCH SET
=========
    1/4: dm: restore presuspend status
    2/4: dm-log: update resume method for interruption of presuspend
    3/4: dm-crypt: update resume method for interruption of presuspend
    4/4: cmirror: update resume method for interruption of presuspend

    NOTE: The cmirror patch (4/4) hasn't been tested yet.


I appreciate your comments.

Thanks,
Taka

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
