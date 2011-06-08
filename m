From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 7] DM RAID:  documentation updates
Date: Wed, 08 Jun 2011 17:13:13 -0500
Message-ID: <1307571193.18638.2.camel@f14.redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Updates to the dm-raid.txt documentation.

Add a little more information for some of the parameters of a dm-raid CTR table
and add a little more clarity to how parameters are printed when 'dmsetup table'
is issued.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/Documentation/device-mapper/dm-raid.txt
===================================================================
--- linux-2.6.orig/Documentation/device-mapper/dm-raid.txt
+++ linux-2.6/Documentation/device-mapper/dm-raid.txt
@@ -22,10 +22,15 @@ planned for the future.)  The list of re
 is the same for all the current raid types.  The required parameters are
 positional, while the optional parameters are given as key/value pairs.
 The possible parameters are as follows:
- <chunk_size>           Chunk size in sectors.
+ <chunk_size>           Chunk size in sectors.  This parameter is often called
+ 			"stripe size".  It is the only required parameter and
+			must be the first parameter.
  [[no]sync]             Force/Prevent RAID initialization
  [rebuild <idx>]        Rebuild the drive indicated by the index
- [daemon_sleep <ms>]    Time between bitmap daemon work to clear bits
+ [daemon_sleep <ms>]    Time between bitmap daemon work to clear bits.  A longer
+ 	       		time means less bitmap I/O, but potentially longer resync
+			time after a failure due to a less frequent clearing of
+			the bitmap.
  [min_recovery_rate <kB/sec/disk>]      Throttle RAID initialization
  [max_recovery_rate <kB/sec/disk>]      Throttle RAID initialization
  [max_write_behind <sectors>]           See '-write-behind=' (man mdadm)
@@ -55,9 +60,12 @@ Examples:
         raid4 4 2048 min_recovery_rate 20 sync\
         5 - 8:17 - 8:33 - 8:49 - 8:65 - 8:81
 
-Performing a 'dmsetup table' should display the CTR table used to
-construct the mapping (with possible reordering of optional
-parameters).
+Performing a 'dmsetup table' will display the CTR table used to construct the
+mapping.  The optional parameters will always be printed in the order listed
+above.  "sync" or "nosync" will always be printed before the other arguments,
+for example.  If the user passes in optional arguments in a different order,
+the results of 'dmsetup table' will differ from the CTR table used to construct
+the mapping.
 
 Performing a 'dmsetup status' will yield information on the state and
 health of the array.  The output is as follows:
