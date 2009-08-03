From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 1/5] multipath-tools: Fix uevent handling code
Date: Mon, 3 Aug 2009 16:59:05 -0500
Message-ID: <20090803215904.GR15326@ether.msp.redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Multipathd wasn't setting buflen when it read in a uevent message.  This was
causing buflen to be used unitialized, and would often keep multipathd from
processing uevents.  This patch correctly initializes buflen to the size of the
buffer received.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/uevent.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: multipath-tools/libmultipath/uevent.c
===================================================================
--- multipath-tools.orig/libmultipath/uevent.c
+++ multipath-tools/libmultipath/uevent.c
@@ -231,7 +231,8 @@ int uevent_listen(int (*uev_trigger)(str
 		smsg.msg_control = cred_msg;
 		smsg.msg_controllen = sizeof(cred_msg);
 
-		if (recvmsg(sock, &smsg, 0) < 0) {
+		buflen = recvmsg(sock, &smsg, 0);
+		if (buflen < 0) {
 			if (errno != EINTR)
 				condlog(0, "error receiving message");
 			continue;
@@ -286,8 +287,10 @@ int uevent_listen(int (*uev_trigger)(str
 		/* action string */
 		uev->action = buffer;
 		pos = strchr(buffer, '@');
-		if (!pos)
+		if (!pos) {
+			condlog(3, "bad action string '%s'", buffer);
 			continue;
+		}
 		pos[0] = '\0';
 
 		/* sysfs path */
