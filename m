From: Alasdair G Kergon <agk@redhat.com>
Subject: 2.6.11-rc3-udm1
Date: Mon, 7 Feb 2005 18:49:30 +0000
Message-ID: <20050207184930.GR10195@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/2.6.11-rc3/2.6.11-rc3-udm1.tar.bz2

Patches 1 and 2 are in upstream bitkeeper.

We still need more testing of dm-crypt and dm-raid1 (pvmove/dmraid) on
multi-TB devices.

I recommend you don't apply patch 14 here unless you specifically 
intend to test that patch with dmsetup.  Existing LVM2 and EVMS
tools needs some modification to work with it correctly, and
more patches like that will follow.  The LVM2 source
tree will branch for a while as these changes are worked on
to make snapshot creation more reliable.

I'm preparing to submit the multipath patches upstream.

Alasdair



Revision 1:
  stripe_width should be sector_t to support large devices.
  
  Signed-Off-By: Alasdair G Kergon <agk@redhat.com>
  
  [Included upstream]

Revision 2:
  Fix some bugs in device-mapper handling of 64-bit values,
  replacing dm_div_up() and dm_round_up() inlines with macros and
  removing some avoidable divisions of 64-bit numbers.
  
  The mirror region size is the granularity used to manage and monitor
  the data copying, typically 512KB, so 32 bits (of sectors) should 
  be plenty to hold this.
  
  Taken together with the two earlier patches:
    "fix TB stripe data corruption" (a missing cast) and 
    "stripe_width should be sector_t",
  I've now had 3 independent reports that this fixes device-mapper
  for devices with large stripes.
  
  Still awaiting test results for dm-crypt and dm-raid1.
  
  Signed-Off-By: Alasdair G Kergon <agk@redhat.com>
  
  [Included upstream]

Revision 3:
  Use %llu not %Lu in sscanf/printf format strings.
  
  Signed-Off-By: Alasdair G Kergon <agk@redhat.com>

Revision 4:
  Only call format_dev_t once.

Revision 5:
  Functions to record and restore bio state.

Revision 6:
  Export map info for multipath.

Revision 7:
  Multipath.

Revision 8:
  Round-robin path selector.

Revision 9:
  Hardware-handler.

Revision 10:
  EMC Hardware-handler.

Revision 11:
  Flakey.

Revision 12:
  Handle writes to a snapshot-origin device that has been extended since
  the snapshot was taken.

Revision 13:
  More snapshot metadata reading into separate function.

Revision 14:
  Move snapshot metadata loading to happen when table is created instead
  of when device is resumed.  Origin writes don't trigger exceptions until
  snapshot table becomes active (when resume() is called on snapshot).
  
  NB This patch may break some existing LVM2 and EVMS operations.

Revision 15:
  The patch adds new interfaces to bio.c that support
  the creation of local bio and bvec pools.  This is
  important for layered drivers that need to allocate
  new bio and bvec structures in response to bio's
  submitted to it from higher up.  The layered drivers
  can allocate local pools of bio structures to preclude
  deadlock under global bio pool exhaustion.
  
  The device mapper source files have been modified to
  remove duplicate bio code, and to use the new interfaces
  to create local bio pools.
  
  From: Dave Olien <dmo@osdl.org>

Revision 16:
  mm kgdb

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
