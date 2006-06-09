From: Alasdair G Kergon <agk@redhat.com>
Subject: Next set of device-mapper patches
Date: Fri, 9 Jun 2006 22:22:34 +0100
Message-ID: <20060609212234.GF7606@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

I'm preparing the next set of minor patches to go upstream and would
appreciate comments and testing.  They're built on top of the patches
currently in -mm.


dm-support-ioctls-on-mapped-devices.patch
    Mechanics to support ioctls on certain devices.

dm-linear-support-ioctls.patch
    ioctl support for the linear target

dm-mpath-support-ioctls.patch
    ioctl support for the multipath target

dm-export-blkdev_driver_ioctl.patch
    Export another function to avoid calling some code twice.

dm-mirror-log-sector-size-fix.patch
dm-mirror-log-refactor-context.patch
    Make mirror log work regardless of hard sector size.

dm-table-split_args-handle-no-input.patch
    Trivial extension to table_split_args.

dm-consolidate-creation-functions.patch
    Merge dm_create and dm_create_with_minor.

dm-exports.patch
    Make various dm functions available to modules officially.

dm-create-error-table.patch
    Add a library function for modules to use.

dm-prevent-removal-if-open.patch
    Reinstate earlier dm behaviour so open devices can't be removed.


These patches are all at:
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
based on 2.6.17-rc6.  (Apply in the order shown in the series file,
or use 'quilt' directly.)


If there are any further small patches I've missed (and aren't yet in the
editing directory) please remind me of them!  Once these are out of the
way, I'll get onto meatier things like adding netlink & the enhancements to
snapshot, multipath & raid*.

Alasdair
--
agk@redhat.com
