From: Ritesh Raj Sarraf <rrs@debian.org>
Subject: [PATCH 2/3] Minor spelling error fixes
Date: Sun,  9 Mar 2014 17:26:34 +0530
Message-ID: <1394366195-3053-2-git-send-email-rrs@debian.org>
References: <1394366195-3053-1-git-send-email-rrs@debian.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1394366195-3053-1-git-send-email-rrs@debian.org>
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

Signed-off-by: Ritesh Raj Sarraf <rrs@debian.org>
---
 multipath/multipath.conf.5 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index cf5bec0..1a904e9 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -426,7 +426,7 @@ The \fIWorld Wide Identification\fR of a device.
 Regular expression of the device nodes to be excluded.
 .TP
 .B property
-Regular expresion of the udev property to be excluded.
+Regular expression of the udev property to be excluded.
 .TP
 .B device
 Subsection for the device description. This subsection recognizes the
@@ -453,7 +453,7 @@ The following keywords are recognized:
 The \fIWorld Wide Identification\fR of a device.
 .TP
 .B property
-Regular expresion of the udev property to be whitelisted. Defaults to
+Regular expression of the udev property to be whitelisted. Defaults to
 .I (ID_WWN|ID_SCSI_VPD)
 .TP
 .B devnode
-- 
1.9.0
