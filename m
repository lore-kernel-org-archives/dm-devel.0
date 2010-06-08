From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 0/3] dm: separate device deletion from dm_put()
Date: Tue, 08 Jun 2010 19:21:20 +0900
Message-ID: <4C0E19A0.1040804@ct.jp.nec.com>
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
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair,

This is an updated patch-set to fix bugs in device removal corner-cases,
replacing the previous version found in:
  https://patchwork.kernel.org/patch/83995/

Please review and take this patch-set instead.
This patch-set can be applied on top of 2.6.35-rc1 + your NEXT_PATCHES.

The patch-set contains 3 patches:
The 3rd patch is basically same as the one I posted before.
The 1st patch is a new patch fixing possible NULL pointer dereference.
The 2nd patch fixes a deadlock, which is introduced by the 3rd patch.

The deadlock is AB-BA deadlock between dm_hash_remove_all(), which waits
for md->holders to be 0 with _hash_lock held, and other ioctls which waits
for _hash_lock with md->holders held (e.g. table_status(), table_load()):
  CPU0                            CPU1
  ------------------------------------------------------------------
  dm_hash_remove_all()
    down_write(_hash_lock)
                                  table_status()
                                    md = find_device()
                                           dm_get(md)
                                    dm_get_live_or_inactive_table()
                                      dm_get_inactive_table()
                                        down_write(_hash_lock)
    dm_destroy(md)
      while (md->holders)
        msleep(1)

To fix this deadlock problem, this patch-set changes dm_hash_remove_all()
to release _hash_lock when removing a mapped_device, then, take _hash_lock
and start over again.

Summary of the patch-set:
  1/3: dm: prevent access to md being deleted
  2/3: dm: release _hash_lock when removing device in remove_all
  3/3: dm: separate device deletion from dm_put()

 drivers/md/dm-ioctl.c |   61 ++++++++++++++++++++++++++++----------------------
 drivers/md/dm.c       |   60 ++++++++++++++++++++++++++++++++++++-------------
 drivers/md/dm.h       |    5 ++++
 3 files changed, 84 insertions(+), 42 deletions(-)

Thanks,
Kiyoshi Ueda
