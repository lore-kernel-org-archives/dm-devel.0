From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] Clarify commit message in select_max_sectors_kb()
Date: Tue, 20 Jun 2017 20:28:48 +0200
Message-ID: <20170620182848.8439-1-mwilck@suse.com>
References: <4dcb7f57-ec1e-90e9-1f6a-7c8572578d1d@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4dcb7f57-ec1e-90e9-1f6a-7c8572578d1d@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Do you like it better this way?
---
 libmultipath/propsel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index f11052f2..6d628052 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -798,8 +798,9 @@ int select_max_sectors_kb(struct config *conf, struct multipath * mp)
 	mp_set_conf(max_sectors_kb);
 	mp_set_default(max_sectors_kb, DEFAULT_MAX_SECTORS_KB);
 	/*
-	 * In the default case, we will not modify max_sectors_kb.
-	 * Don't print a log message to avoid user confusion.
+	 * In the default case, we will not modify max_sectors_kb in sysfs
+	 * (see sysfs_set_max_sectors_kb()).
+	 * Don't print a log message here to avoid user confusion.
 	 */
 	return 0;
 out:
-- 
2.13.1
