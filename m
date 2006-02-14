From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: checkers segfault
Date: Mon, 13 Feb 2006 19:26:57 -0600
Message-ID: <20060214012657.GB25174@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Multipath was segfaulting on startup because of some pointer arithmatic
craziness with the checkers. The attached patch fixes it.

-Ben

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="checker.patch"

diff -urpN mp-devel-clean/libcheckers/checkers.c mp-devel-patched/libcheckers/checkers.c
--- mp-devel-clean/libcheckers/checkers.c	2006-02-13 11:53:34.000000000 -0600
+++ mp-devel-patched/libcheckers/checkers.c	2006-02-13 20:03:14.000000000 -0600
@@ -70,7 +70,7 @@ struct checker * checker_lookup (char * 
 	while (c->check) {
 		if (!strncmp(name, c->name, CHECKER_NAME_LEN))
 			return c;
-		c += sizeof(struct checker);
+		c++;
 	}
 	return NULL;
 }

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--C7zPtVaVf+AK4Oqc--
