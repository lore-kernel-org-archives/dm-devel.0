From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 10/20] multipath -C: decrease log level
Date: Sat, 13 Jan 2018 22:19:28 +0100
Message-ID: <20180113211938.31552-11-mwilck@suse.com>
References: <20180113211938.31552-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180113211938.31552-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Avoid that the positive case ("usable paths found") spams the
syslog on systems with many LUNs.
---
 multipath/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/multipath/main.c b/multipath/main.c
index 25162a0e9a7c..52bf1658bbca 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -325,7 +325,8 @@ static int check_usable_paths(struct config *conf,
 		}
 	}
 found:
-	condlog(2, "%s:%s usable paths found", devpath, r == 0 ? "" : " no");
+	condlog(r == 0 ? 3 : 2, "%s:%s usable paths found",
+		devpath, r == 0 ? "" : " no");
 free:
 	FREE(mapname);
 	free_multipath(mpp, FREE_PATHS);
-- 
2.15.1
