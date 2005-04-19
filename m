From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: waiteventloop loops once more than it needs to
Date: Tue, 19 Apr 2005 17:24:52 -0500
Message-ID: <20050419222452.GF8789@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
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


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In waitevntloop(), you get the current event_nr, and then wait for an
event. After the event, the event_nr will always be at least one greater.
This means that waiteventloop will always run mark_failed_path() once more
than needed. This patch, against multipath-tools-0.4.4-pre15, fixes that.

-Ben

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="waiteventloop-fix.patch"

diff -urN multipath-tools-0.4.4-pre15/multipathd/main.c multipath-tools-waiteventloop-fix/multipathd/main.c
--- multipath-tools-0.4.4-pre15/multipathd/main.c	2005-04-19 10:04:10.000000000 -0500
+++ multipath-tools-waiteventloop-fix/multipathd/main.c	2005-04-19 15:23:05.000000000 -0500
@@ -298,7 +298,7 @@
 	dm_task_no_open_count(dmt);
 
 	dm_task_run(dmt);
-
+	waiter->event_nr++;
 	/*
 	 * upon event ...
 	 */

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--Nq2Wo0NMKNjxTN9z--
