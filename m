From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-statistics: update documentation
Date: Mon, 15 Jun 2015 18:04:55 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1506151804030.2188@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi

This is the documentation update for statistics, as suggested by Alasdair.

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

Update documentation so that program id must not be a number.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 Documentation/device-mapper/statistics.txt |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-dm/Documentation/device-mapper/statistics.txt
===================================================================
--- linux-dm.orig/Documentation/device-mapper/statistics.txt	2015-06-15 23:40:37.000000000 +0200
+++ linux-dm/Documentation/device-mapper/statistics.txt	2015-06-16 00:03:13.000000000 +0200
@@ -85,6 +85,9 @@ Messages
 	  created and ignore those created by others.
 	  The kernel returns this string back in the output of
 	  @stats_list message, but it doesn't use it for anything else.
+	  If we omit the number of optional arguments, program id must not
+	  be a number, otherwise it would be interpreted as the number of
+	  optional arguments.
 
 	<aux_data>
 	  An optional parameter.  A word that provides auxiliary data
