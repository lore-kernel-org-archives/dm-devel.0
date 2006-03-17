From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] RFC: Changing dm core data structure
	relationships (0/5)
Date: Thu, 16 Mar 2006 19:14:25 -0500
Message-ID: <4419FF61.9050501@ce.jp.nec.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

This is a proposal of changing dm core structure for
simplification, SMP race avoidance and guaranteed release
ordering. Patches don't affect dm targets.

I would like to hear your opinion on this.

The core motivation for these changes are followings:
  - Device open and remove can race.
    As a result, the device we opened might be freed by someone.
  - We lost control on device when it's removed.
    e.g. if the device is opened and suspended, we no longer
    really remove the device.
  - With dm-table-store-md.patch in -mm, table has reference to md.
    So we would like to guarantee that table is freed before md.
It's achived in the third patch.

Patches are created and tested based on 2.6.16-rc6-mm1 plus:
  - dm-flush-queue-eintr.patch
  - dm-tidy-mdptr.patch
  - dm-table-store-md.patch
  - dm-md-dependency-tree-in-sysfs-add_subdirs.patch                           14-Mar-2006 18:33  3.2K
  - dm-md-dependency-tree-in-sysfs-bd_claim_by_kobj.patch                      14-Mar-2006 18:33  9.5K
  - dm-md-dependency-tree-in-sysfs-dm_deptree.patch                            14-Mar-2006 18:33  2.8K
  - dm-md-dependency-tree-in-sysfs-kobject_add_dir.patch                       14-Mar-2006 18:33  1.9K
  - dm-md-dependency-tree-in-sysfs-md_deptree.patch

Thanks,
-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.

--------------------------------------------------------------------------
Description of patches

01-dm-sem.patch
  Literally replace _hash_lock with dm_sem. Make it extern.

02-put-table-after-unlock.patch
  Moving dm_table_put() which may destroy table to outside of dm_sem.
  This is for next patches which dm_sem is held is device close
  thus table destructor may otherwise deadlock.

03-hc-open-count.patch
  Moving open counter to hc. Disables removal of hc with openers.
  md->holders become purely a reference counter of md.
    * disk->private_data points to hc rather than md.
      When hc is removed, disk->private_data becomes NULL and no new open
      is possible.
    * Open count is protected by dm_sem to avoid open vs. remove race.
    * Upon hc removal, tables are released from md.
    * Table gets reference to md on creation, puts on free.
      Thus we can guarantee md is not freed before its tables are feed.
    * dm_get_md(), which maps minor to md, checks interface_ptr to avoid
      getting md being removed.

04-remove-dm-md-get.patch
    * dm_get_md() is removed. There is no user.

05-move-new-map-to-md.patch
  Moving hc->new_map to md->new_map.
    * Map loading no longer needs global dm_sem.
      Just grab md and lock map_lock.
    * Most of __find_device_hash_cell() can be replaced by find_device().

Should be applied in this order.

Concerns:
  - Is moving dm_blk_open/close to dm-ioctl.c right thing?
    Is it nice to rename dm-ioctl.c to dm-interface.c or something?
  - Does other .c files need to get hc->count?
  - dm_table_get_md() really needs dm_get()?
    We can assume md exists whenever the table exists.

--------------------------------------------------------------------
Structures:
  - mapped_device (md)
  - hash_cell (hc)
  - dm_table (table)
  - gendisk (disk)
  - request_queue (queue)
  - minor number (minor)

Relationships:
  - hc owns 1 md
  - md owns 0-2 tables, 1 disk
  - disk owns 1 queue and 1 minor number

Roles:
  - hc manages access from outside of dm (block device, ioctl).
    It has open counter. hc can be removed from list only when
    there is no opener.
  - md is a core of dm device. Access to table needs to go through md.

Locks:
  - dm_sem: hc list, gendisk->dm device binding
  - io_lock: DMF_BLOCK_IO, md->deferred, md->wait
  - map_lock: md->map, md->new_map
  - suspend_lock: DMF_SUSPENDED

Ordering:
  - Allocation/Register
       1) allocation of md, hc, disk, queue, minor can occur in any order
       2) register md to disk
       3) register disk (it eventually register minor and queue)
          <device visible from block layer>
       4) register md to hc
          <block device access enabled>
       5) register hc to hash list
          <ioctl access enabled>
       6) table allocation (load)
       7) table register (resume -> bind)
          <I/O enabled>
  - Freeing/Unregister (reordered proposal)
       [lock dm_sem]
       3) unregister hc from hash list
          <ioctl access disabled>
       4) unregister md from hc
       6) unregister md from disk
          <block device access rejected>
       [unlock dm_sem]
       1) table unregister (resume -> unbind)
          <I/O disabled>
       2) table free
       5) unregister disk
          <block device access disabled>
       7) free in any order

       (*) Moving 1) and 2) later has a benefit that we don't
           need to care for racing with new table registration.
       (*) Swapping the order of 5) and 6), because 5) eventually
           cause kobject_uevent(hotplug) which may sleep.
           It's not good thing to do in global dm_sem.
           Doing 6) makes future open to fail so it has same shutdown
           effect and faster.
