From: Ritesh Raj Sarraf <rrs@debian.org>
Subject: [PATCH 2/3] Minor spelling error fixes for Debian's
	lintian cleanliness
Date: Wed,  9 Jan 2013 14:02:47 +0530
Message-ID: <1357720368-17664-2-git-send-email-rrs@debian.org>
References: <1357720368-17664-1-git-send-email-rrs@debian.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357720368-17664-1-git-send-email-rrs@debian.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com
Cc: Ritesh Raj Sarraf <rrs@debian.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

fix missed-out hyphen

Signed-off-by: Ritesh Raj Sarraf <rrs@debian.org>
---
 kpartx/kpartx.8            |    9 ++++++---
 multipath/main.c           |    2 +-
 multipath/multipath.conf.5 |    8 ++++----
 multipathd/multipathd.8    |    4 ++--
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8
index 8a37d4f..0b54cfb 100644
--- a/kpartx/kpartx.8
+++ b/kpartx/kpartx.8
@@ -20,6 +20,9 @@ Add partition mappings
 .B \-r
 Readonly partition mappings
 .TP
+.B \-r
+Read-only partition mappings
+.TP
 .B \-d
 Delete partition mappings
 .TP
@@ -27,7 +30,7 @@ Delete partition mappings
 Update partition mappings
 .TP
 .B \-l
-List partition mappings that would be added -a
+List partition mappings that would be added \-a
 .TP
 .B \-p
 set device name-partition number delimiter
@@ -46,7 +49,7 @@ Sync mode. Don't return until the partitions are created
 .SH EXAMPLE
 To mount all the partitions in a raw disk image:
 .IP
-kpartx -av disk.img
+kpartx \-av disk.img
 .PP
 This will output lines such as:
 .IP
@@ -62,7 +65,7 @@ fsck /dev/mapper/loop3p1
 .PP
 When you're done, you need to remove the devices:
 .IP
-kpartx -d disk.img
+kpartx \-d disk.img
 .SH "SEE ALSO"
 .BR multipath (8)
 .BR multipathd (8)
diff --git a/multipath/main.c b/multipath/main.c
index 396c4b9..0083ef4 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -504,7 +504,7 @@ main (int argc, char *argv[])
 			usage(argv[0]);
 			exit(0);
 		case ':':
-			fprintf(stderr, "Missing option arguement\n");
+			fprintf(stderr, "Missing option argument\n");
 			usage(argv[0]);
 			exit(1);
 		case '?':
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 92fb0c1..eb96c61 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -301,7 +301,7 @@ to assign a persistent and unique alias to the multipath, in the form of mpath<n
 If set to 
 .I no
 use the WWID as the alias. In either case this be will
-be overriden by any specific aliases in the \fImultipaths\fR section.
+be overridden by any specific aliases in the \fImultipaths\fR section.
 Default is
 .I no
 .TP
@@ -314,7 +314,7 @@ deleted. Default is
 .TP
 .B max_fds
 Specify the maximum number of file descriptors that can be opened by multipath
-and multipathd.  This is equivalent to ulimit -n. A value of \fImax\fR will set
+and multipathd.  This is equivalent to ulimit \-n. A value of \fImax\fR will set
 this to the system limit from /proc/sys/fs/nr_open. If this is not set, the
 maximum number of open fds is taken from the calling process. It is usually
 1024. To be safe, this should be set to the maximum number of paths plus 32,
@@ -322,7 +322,7 @@ if that number is greated than 1024.
 .TP
 .B checker_timeout
 Specify the timeout to user for path checkers that issue scsi commands with an
-explict timeout, in seconds; default taken from
+explicit timeout, in seconds; default taken from
 .I /sys/block/sd<x>/device/timeout
 .TP
 .B fast_io_fail_tmo
@@ -405,7 +405,7 @@ The
 section is used to revert the actions of the
 .I blacklist
 section, ie to include specific device in the
-multipath topology. This allows to selectively include devices which
+multipath topology. This allows one to selectively include devices which
 would normally be excluded via the
 .I blacklist
 section.
diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index cbc40a4..ccc5f54 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -53,10 +53,10 @@ Show the status of all multipath devices that the multipathd is monitoring.
 Show some statistics of all multipath devices that the multipathd is monitoring.
 .TP
 .B list|show maps|multipaths topology
-Show the current multipath topology. Same as "multipath -ll".
+Show the current multipath topology. Same as "multipath \-ll".
 .TP
 .B list|show topology
-Show the current multipath topology. Same as "multipath -ll".
+Show the current multipath topology. Same as "multipath \-ll".
 .TP
 .B list|show map|multipath $map topology
 Show topology of a single multipath device specified by $map, e.g. 36005076303ffc56200000000000010aa.
-- 
1.7.10.4
