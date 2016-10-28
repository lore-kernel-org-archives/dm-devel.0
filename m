From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: clean up and organize
	kpartx/kpartx.8
Date: Fri, 28 Oct 2016 16:47:52 +0200
Message-ID: <20161028144752.5402-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/kpartx.8 | 117 ++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 85 insertions(+), 32 deletions(-)

diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8
index 4c55831..ba58acb 100644
--- a/kpartx/kpartx.8
+++ b/kpartx/kpartx.8
@@ -1,49 +1,93 @@
-.TH KPARTX 8 "July 2006" "" "Linux Administrator's Manual"
+.\" ----------------------------------------------------------------------------
+.\" Update the date below if you make any significant change.
+.\" Make sure there are no errors with:
+.\" groff -z -wall -b -e -t kpartx/kpartx.8
+.\"
+.\" ----------------------------------------------------------------------------
+.
+.TH KPARTX 8 2016-10-28 "Linux"
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH NAME
-kpartx \- Create device maps from partition tables
+.\" ----------------------------------------------------------------------------
+.
+kpartx \- Create device maps from partition tables.
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH SYNOPSIS
+.\" ----------------------------------------------------------------------------
+.
 .B kpartx
-.RB [\| \-a\ \c
-.BR |\ -d\ |\ -l \|]
+.RB [\| \-a | \-d | \-u | \-l \|]
+.RB [\| \-r \|]
+.RB [\| \-p \|]
+.RB [\| \-f \|]
+.RB [\| \-g \|]
+.RB [\| \-s \|]
 .RB [\| \-v \|]
-.RB wholedisk
+.B wholedisk
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH DESCRIPTION
-This tool, derived from util-linux' partx, reads partition
-tables on specified device and create device maps over partitions
-segments detected. It is called from hotplug upon device maps
-creation and deletion.
+.\" ----------------------------------------------------------------------------
+.
+This tool, derived from util-linux' partx, reads partition tables on specified
+device and create device maps over partitions segments detected. It is called
+from hotplug upon device maps creation and deletion.
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH OPTIONS
+.\" ----------------------------------------------------------------------------
+.
 .TP
 .B \-a
-Add partition mappings
-.TP
-.B \-r
-Read-only partition mappings
+Add partition mappings.
+.
 .TP
 .B \-d
-Delete partition mappings
+Delete partition mappings.
+.
 .TP
 .B \-u
-Update partition mappings
+Update partition mappings.
+.
 .TP
 .B \-l
-List partition mappings that would be added \-a
+List partition mappings that would be added \-a.
+.
+.TP
+.B \-r
+Read-only partition mappings.
+.
 .TP
 .B \-p
-set device name-partition number delimiter
+Set device name-partition number delimiter.
+.
 .TP
 .B \-f
-force creation of mappings; overrides 'no_partitions' feature
+Force creation of mappings; overrides 'no_partitions' feature.
+.
 .TP
 .B \-g
-force GUID partition table (GPT)
-.TP
-.B \-v
-Operate verbosely
+Force GUID partition table (GPT).
+.
 .TP
 .B \-s
-Sync mode. Don't return until the partitions are created
+Sync mode. Don't return until the partitions are created.
+.
+.TP
+.B \-v
+Operate verbosely.
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH EXAMPLE
+.\" ----------------------------------------------------------------------------
+.
 To mount all the partitions in a raw disk image:
 .IP
 kpartx \-av disk.img
@@ -52,22 +96,31 @@ This will output lines such as:
 .IP
 add map loop1p1 (254:4): 0 409597 linear 7:1 3
 .PP
-The
-.I loop1p1
-is the name of a device file under
-.I /dev/mapper
-which you can use to access the partition, for example to fsck it:
+The \fIloop1p1\fR is the name of a device file under \fI/dev/mapper\fR which you
+can use to access the partition, for example to fsck it:
 .IP
 fsck /dev/mapper/loop1p1
 .PP
 When you're done, you need to remove the devices:
 .IP
 kpartx \-d disk.img
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH "SEE ALSO"
+.\" ----------------------------------------------------------------------------
+.
 .BR multipath (8)
 .BR multipathd (8)
 .BR hotplug (8)
-.SH "AUTHORS"
-This man page was assembled By Patrick Caulfield
-for the Debian project. From documentation provided
-by the multipath author Christophe Varoqui, <christophe.varoqui@opensvc.com> and others.
+.
+.
+.\" ----------------------------------------------------------------------------
+.SH AUTHORS
+.\" ----------------------------------------------------------------------------
+.
+This man page was assembled By Patrick Caulfield for the Debian project.
+.PP
+\fImultipath-tools\fR was developed by Christophe Varoqui <christophe.varoqui@opensvc.com>
+and others.
+.\" EOF
-- 
2.10.1
