From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 1/6] Fix for uevent devpath handling
Date: Thu, 11 Dec 2008 16:03:28 -0600
Message-ID: <20081211220328.GI1585@ether.msp.redhat.com>
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is necessary to make uevents work on fedora, since devpath appears as
something like:
'/devices/pci0000:00/0000:00:0a.0/0000:06:00.0/host11/rport-11:0-1/target11:0:1/11:0:1:0/block/sdi'

It simply strips off the everything up to the /block.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

Index: multipath-tools-081203/multipathd/main.c
===================================================================
--- multipath-tools-081203.orig/multipathd/main.c
+++ multipath-tools-081203/multipathd/main.c
@@ -603,14 +603,20 @@ uxsock_trigger (char * str, char ** repl
 static int
 uev_discard(char * devpath)
 {
+	char *tmp;
 	char a[10], b[10];
 
 	/*
 	 * keep only block devices, discard partitions
 	 */
-	if (sscanf(devpath, "/block/%10s", a) != 1 ||
-	    sscanf(devpath, "/block/%10[^/]/%10s", a, b) == 2) {
-		condlog(4, "discard event on %s", devpath);
+	tmp = strstr(devpath, "/block/");
+	if (tmp == NULL){
+		condlog(0, "no /block/ in '%s'", devpath);
+		return 1;
+	}
+	if (sscanf(tmp, "/block/%10s", a) != 1 ||
+	    sscanf(tmp, "/block/%10[^/]/%10s", a, b) == 2) {
+		condlog(0, "discard event on %s", devpath);
 		return 1;
 	}
 	return 0;
