From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 0/7] dm: avoid I/O error during suspend in no
	path situation
Date: Tue, 10 Oct 2006 17:28:12 -0400 (EDT)
Message-ID: <20061010.172812.59649173.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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

Hello,

This patch set adds 'noflush' suspend option and avoids bogus
I/O errors during suspend in the multipath target.

=======================================================================
Problem
=-=-=-=-=

Currently, all pending I/Os are flushed and returned to upper layers
during suspend.  And suspend is necesary for swapping table.
So if targets don't have valid devices when swapping table, flushed
I/Os are returnd to applications with error status.

For example, when you use a multipath device (/dev/mapper/mpath0)
mapped to a local device (/dev/sda) with queue_if_no_path setting,
if the /dev/sda is unpluged and re-pluged, the name will be changed
in current upstream kernel and multipath-tools will issue table reload.
So all queued I/Os in the multipath target will be returned with error
status.


=======================================================================
How to solve the problem
=-=-=-=-=-=-=-=-=-=-=-=-=

Since the I/Os are staying in the target drivers,
you should either:
  (1) reload table without breaking data structure of current table
  (2) have the related data in device-mapper core from the first time
  (3) request the target drivers to return them

(1) might be a possible feature in future but doesn't exist for now.
I have proposed dm_queue patch to do (2).
<https://www.redhat.com/archives/dm-devel/2006-July/msg00008.html>
(3) is less risky as it doesn't affect targets which don't have
this problem.

For (2), I've got a positive response from Alasdair but it seems
the patch still needs time to be included in his tree.
So I'm sending (3) again as a immediate fix to the problem.

To implement (3), we could add a new method to the target driver
to explicitly request to return the I/Os.
But, instead of complicating the target driver, the patch set
modifies map() and end_io() to trap the I/Os so that they are
reissued without visible and bogus I/O errors.


===================================================================
Overview of the patch set
=-=-=-=-=-=-=-=-=-=-=-=-=-=

The patch set adds a mechanism that each target driver can request
queueing the I/O to the dm core.
Target driver can request it by the following ways:
    - map() returns DM_MAPIO_REQUEUE
    - end_io() returns DM_ENDIO_REQUEUE

If requested, the dm core queues the I/O temporarily to
md->pushback (newly added by this patch).
(We can call this behavior 'pushback' here.)
After waiting for all pending I/Os being either done or queued,
md->pushback is merged to md->deferred.
I/Os in md->deferred are reissued at resume time.

The feature above requires support from target drivers.
Implementation for the multipath target driver is provided in
the patch set.

'DM_NOFLUSH_FLAG' ioctl option for suspend is added by the patch set,
and the feature above is enabled only when the option is specified.
So the changes have no effect on the existing applications, unless
they use the option explicitly.


The patch set consists of following 7 patches which should be applied
on top of 2.6.18-mm2.
-----------------------------------------------------------------------
patch 1: remove no needed spaces in clone_endio() and __map_bio().
patch 2: interface change of dm_suspend() for addition of new
         suspend option without incresing arguments.
patch 3: new return value definition of target map/end_io function.
patch 4: reflect return value symbols of the patch 3 above to targets.
patch 5: add new 'DM_NOFLUSH_FLAG' ioctl option for suspend.
patch 6: add the pushback feature to the dm core.
patch 7: add the pushback feature to the multipath target driver.
-----------------------------------------------------------------------

Please review and apply.

Thanks,
Kiyoshi Ueda
