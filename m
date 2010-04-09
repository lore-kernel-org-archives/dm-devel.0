From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH] multipath_tools: minor rdac message fix and code
	cleanup
Date: Fri, 9 Apr 2010 14:30:40 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF48A434FB0@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch fixes a rdac minor message issue. rdac message is not passed in one of the path down cases. This patch fixes this problem. Also I have re-arranged the code for better readability.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
Reviewed-by: Vijay Chauhan <Vijay.Chauhan@lsi.com>

---
--- multipath-tools/libmultipath/checkers/rdac.c.orig	2010-04-08 13:14:52.000000000 -0500
+++ multipath-tools/libmultipath/checkers/rdac.c	2010-04-09 13:57:36.000000000 -0500
@@ -101,24 +101,32 @@ extern int
 libcheck_check (struct checker * c)
 {
 	struct volume_access_inq inq;
+	int ret;
 
 	memset(&inq, 0, sizeof(struct volume_access_inq));
 	if (0 != do_inq(c->fd, 0xC9, &inq, sizeof(struct volume_access_inq))) {
-		MSG(c, MSG_RDAC_DOWN);
-		return PATH_DOWN;
-	} else {
-		if ((inq.PQ_PDT & 0x20) || (inq.PQ_PDT & 0x7f)) {
-			/* LUN not connected*/
-			return PATH_DOWN;
-		}
+		ret = PATH_DOWN;
+		goto done;
+	} else if ((inq.PQ_PDT & 0x20) || (inq.PQ_PDT & 0x7f)) {
+		/* LUN not connected*/
+		ret = PATH_DOWN;
+		goto done;
 	}
 
-	if (inq.avtcvp & 0x1) {
+	ret = ((inq.avtcvp & 0x1) ? PATH_UP : PATH_GHOST);
+
+done:
+	switch (ret) {
+	case PATH_DOWN:
+		MSG(c, MSG_RDAC_DOWN);
+		break;
+	case PATH_UP:
 		MSG(c, MSG_RDAC_UP);
-		return PATH_UP;
-	}
-	else {
+		break;
+	case PATH_GHOST:
 		MSG(c, MSG_RDAC_GHOST);
-		return PATH_GHOST;
+		break;
 	}
+
+	return ret;
 }
