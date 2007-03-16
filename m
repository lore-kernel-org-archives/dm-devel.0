From: Jim Meyering <jim@meyering.net>
Subject: tiny patch: avoid an unnecessary test
Date: Fri, 16 Mar 2007 09:28:43 +0100
Message-ID: <87fy85bnic.fsf@rho.meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
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

Not a big deal (barely worth mentioning), but it might save
someone else a little time wondering "why".

2007-03-11  Jim Meyering  <jim@meyering.net>

	Remove unnecessary test.
	* dmeventd/dmeventd.c (_alloc_dso_data): Don't test known-non-NULL
	memset return value.

2007-03-11  Jim Meyering  <jim@meyering.net>
Index: dmeventd/dmeventd.c
===================================================================
RCS file: /cvs/dm/device-mapper/dmeventd/dmeventd.c,v
retrieving revision 1.46
diff -u -p -r1.46 dmeventd.c
--- dmeventd/dmeventd.c	2 Feb 2007 17:08:51 -0000	1.46
+++ dmeventd/dmeventd.c	12 Mar 2007 14:39:35 -0000
@@ -258,8 +258,8 @@ static struct dso_data *_alloc_dso_data(
 	if (!ret)
 		return NULL;

-	if (!memset(ret, 0, sizeof(*ret)) ||
-	    !(ret->dso_name = dm_strdup(data->dso_name))) {
+	memset(ret, 0, sizeof(*ret));
+	if (!(ret->dso_name = dm_strdup(data->dso_name))) {
 		dm_free(ret);
 		return NULL;
 	}
