From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: 2.6.11-rc3-udm1
Date: Tue, 8 Feb 2005 08:21:00 -0600
Message-ID: <200502080821.00728.kevcorry@us.ibm.com>
References: <20050207184930.GR10195@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050207184930.GR10195@agk.surrey.redhat.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Monday 07 February 2005 12:49 pm, Alasdair G Kergon wrote:
> ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/2.6.11-rc3/2.6.11-r
>c3-udm1.tar.bz2
>
> I recommend you don't apply patch 14 here unless you specifically
> intend to test that patch with dmsetup.  Existing LVM2 and EVMS
> tools needs some modification to work with it correctly, and
> more patches like that will follow.  The LVM2 source
> tree will branch for a while as these changes are worked on
> to make snapshot creation more reliable.
>
> Revision 14:
>   Move snapshot metadata loading to happen when table is created instead
>   of when device is resumed.  Origin writes don't trigger exceptions
> until snapshot table becomes active (when resume() is called on
> snapshot).
>
>   NB This patch may break some existing LVM2 and EVMS operations.

We should bump the snapshot version number to 1.0.2 or 1.1.0 so the tools 
can detect whether this change has been applied. Likewise, the 
dm-multipath version should be bumped to 1.0.4 or 1.1.0 since the table 
format has changed from the old dm-multipath.

Here's a patch for both files that increments the patchlevel-versions. Feel 
free to change these to increment the minor-versions instead if you think 
that's more appropriate.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://evms.sourceforge.net/



--- diff/drivers/md/dm-mpath.c 2005-02-08 08:18:47.570070088 -0600
+++ source/drivers/md/dm-mpath.c 2005-02-08 08:18:45.461390656 -0600
@@ -1221,7 +1221,7 @@
  *---------------------------------------------------------------*/
 static struct target_type multipath_target = {
  .name = "multipath",
- .version = {1, 0, 3},
+ .version = {1, 0, 4},
  .module = THIS_MODULE,
  .ctr = multipath_ctr,
  .dtr = multipath_dtr,
--- diff/drivers/md/dm-snap.c 2005-02-08 08:18:47.570070088 -0600
+++ source/drivers/md/dm-snap.c 2005-02-08 08:18:45.461390656 -0600
@@ -1111,7 +1111,7 @@
 
 static struct target_type snapshot_target = {
  .name    = "snapshot",
- .version = {1, 0, 1},
+ .version = {1, 0, 2},
  .module  = THIS_MODULE,
  .ctr     = snapshot_ctr,
  .dtr     = snapshot_dtr,

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
