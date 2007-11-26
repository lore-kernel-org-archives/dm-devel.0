From: Guido Guenther <agx@sigxcpu.org>
Subject: [PATCH 1/3] kpartx: document "-g"
Date: Mon, 26 Nov 2007 16:20:16 +0100
Message-ID: <20071126152015.GA13674@bogon.ms20.nix>
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
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Signed-Off-By: Guido Guenther <agx@sigxcpu.org>

diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8
index 87b07ce..c61f312 100644
--- a/kpartx/kpartx.8
+++ b/kpartx/kpartx.8
@@ -26,6 +26,9 @@ List partition mappings that would be added -a
 .B \-p
 set device name-partition number delimiter
 .TP
+.B \-g
+force GUID partition table (GPT)
+.TP
 .B \-v
 Operate verbosely
 .SH "SEE ALSO"
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 72ca81d..6d64e30 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -95,6 +95,7 @@ usage(void) {
 	printf("\t-d del partition devmappings\n");
 	printf("\t-l list partitions devmappings that would be added by -a\n");
 	printf("\t-p set device name-partition number delimiter\n");
+	printf("\t-g force GUID partition table (GPT)\n");
 	printf("\t-v verbose\n");
 	return 1;
 }
