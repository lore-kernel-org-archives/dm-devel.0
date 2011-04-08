From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 1/2] multipath-tools: report PATH_UP for both
 path groups in rdac if io-shipping is enabled
Date: Fri, 8 Apr 2011 13:04:45 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FFAC96AE@cosmail01.lsi.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@lsi.com>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>
List-Id: dm-devel.ids

This patch reports PATH_UP for both the path groups if the RDAC storage is configured with i/o shipping.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
Reviewed-by: Yanling Qi <yanling.qi@lsi.com> 
Reviewed-by: Somasundaram Krishnasamy <Somasundaram.Krishnasamy@lsi.com>

---
--- multipath-tools/libmultipath/checkers/rdac.c.orig	2011-04-01 16:45:38.000000000 -0500
+++ multipath-tools/libmultipath/checkers/rdac.c	2011-04-01 16:58:43.000000000 -0500
@@ -218,7 +218,11 @@ libcheck_check (struct checker * c)
 		goto done;
 	}
 
-	ret = ((inq.avtcvp & 0x1) ? PATH_UP : PATH_GHOST);
+	/* If owner set or ioship mode is enabled return PATH_UP always */
+	if ((inq.avtcvp & 0x1) || ((inq.avtcvp >> 5) & 0x1))
+		ret = PATH_UP;
+	else
+		ret = PATH_GHOST;
 
 done:
 	switch (ret) {
