From: Ritesh Raj Sarraf <rrs@debian.org>
Subject: [PATCH] Add kpartx example to manpage
Date: Wed, 17 Aug 2011 23:10:37 +0530
Message-ID: <1313602837-24744-1-git-send-email-rrs@debian.org>
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
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: Ritesh Raj Sarraf <rrs@debian.org>, Ritesh Raj Sarraf <rrs@researchut.com>
List-Id: dm-devel.ids

From: Ritesh Raj Sarraf <rrs@researchut.com>

Thanks: Lars Wirzenius
Closes: 637538

Signed-off-by: Ritesh Raj Sarraf <rrs@debian.org>
---
 kpartx/kpartx.8 |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8
index 5d73d31..795a2e0 100644
--- a/kpartx/kpartx.8
+++ b/kpartx/kpartx.8
@@ -34,6 +34,26 @@ force GUID partition table (GPT)
 .TP
 .B \-v
 Operate verbosely
+.SH EXAMPLE
+To mount all the partitions in a raw disk image:
+.IP
+kpartx -av disk.img
+.PP
+This will output lines such as:
+.IP
+loop3p1 : 0 20964762 /dev/loop3 63
+.PP
+The 
+.I loop3p1
+is the name of a device file under 
+.I /dev/mapper
+which you can use to access the partition, for example to fsck it:
+.IP
+fsck /dev/mapper/loop3p1
+.PP
+When you're done, you need to remove the devices:
+.IP
+kpartx -d disk.img
 .SH "SEE ALSO"
 .BR multipath (8)
 .BR multipathd (8)
-- 
1.7.5.4
