From: "goggin, edward" <egoggin@emc.com>
Subject: multipathd can fail to monitor paths in some corner
	cases
Date: Fri, 1 Jul 2005 17:03:02 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB3A@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Apologies in advance if this issue has been posted previously.

Any inability of multipathd to determine the multipath UID for a path which
the multipath target
driver is already using as a target device of a particular multipath mapped
device can lead to a
discrepancy in the set of paths to a block device used by the multipath
target driver in the kernel
and those paths to the block device monitored by multipathd in user space.

The case I have validated involves path failures between the last issuance
of multipath and when
multipathd is started, although there may be other similar transient errors
which could cause
similar results.  Since in these cases multipathd will not be managing all
paths to a block device,
for those paths not being managed by multipathd, kernel path state is not
being accurately
updated to reflect the actual physical path state of the paths.

While paths in the active path group will be updated to a failed state by
the kernel multipath target driver,
the state for these paths will never be updated to active as the path is
physically reconnected.  Conversely,
the path state for physically disconnected paths in the non-active path
group(s) will incorrectly be
displayed as active.  The path state for both categories of incorrectly
displayed paths will only be
updated to failed in the event someone manually restarts multipathd or runs
multipath to reconfigure
paths.  Obviously, these steps shouldn't be necessary.

The patch below fixes this problem by enabling disassemble_map() to populate
the wwid field for
a path in a mapped device's path group from the wwid field of the path's
associated mapped device
If the path's wwid field is currently not initialized.  Doing so is
necessary since (1) this field was
set to zeros during device discovery if the path was unusable at the time
the path getuid callout
was made, (2) a valid wwid field is necessary in order to match a path to
its mapped device (mpp)
structure, and (3) multipathd will not monitor a path which has no valid mpp
structure.

The diff is based on 0.4.5-pre3.

diff -u multipath-tools-0.4.5-pre3.orig/libmultipath/dmparser.c
multipath-tools-0.4.5-pre3-ed/libmultipath/dmparser.c
--- multipath-tools-0.4.5-pre3.orig/libmultipath/dmparser.c	2005-06-10
03:28:53.000000000 -0500
+++ multipath-tools-0.4.5-pre3-ed/libmultipath/dmparser.c	2005-07-01
15:19:29.250125016 -0500
@@ -261,6 +261,15 @@
 			for (k = 0; k < num_paths_args; k++)
 				p += get_word(p, NULL);
 		}
+		/*
+		 * Update wwid for paths which may not have been active at
+		 * the time the getuid callout was run.
+		 */
+		for (j = 0; j < num_paths; j++) {
+			pp = VECTOR_SLOT(pgp->paths, j);
+			if (!strlen(pp->wwid))
+				strncpy(pp->wwid, mpp->wwid, WWID_SIZE);
+		}
 	}
 	return 0;
 out1:
