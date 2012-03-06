From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Subject: [PATCH]multipath-tools: Implementation for hex output
 (-H) for mpathpersist
Date: Tue, 6 Mar 2012 15:10:15 +0000
Message-ID: <F200AD42A082BC4088B232D13A916A8901C8CD@SACEXCMBX02-PRD.hq.netapp.com>
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
To: "christophe.varoqui@free.fr" <christophe.varoqui@free.fr>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Adding missing implementation for hex output(-H).

Signed-off-by: Vijay Chauhan <vijay.chauhan@netapp.com>

---
diff -uprN multipath-tools.orig/mpathpersist/main.c multipath-tools/mpathpersist/main.c
--- multipath-tools.orig/mpathpersist/main.c	2012-03-04 02:16:55.000000000 -0500
+++ multipath-tools/mpathpersist/main.c	2012-03-05 01:23:07.000000000 -0500
@@ -260,7 +260,7 @@ int main (int argc, char * argv[])
 	}
 
 	/* set verbosity */
-	noisy = (loglevel >= 3) ? 1: 0;
+	noisy = (loglevel >= 3) ? 1 : hex;
 	verbose	= (loglevel >= 3)? 3: loglevel;
 
 	if ((prout_flag + prin_flag) == 0)
--
