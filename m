From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 10/24] multipathd: decrease log level of
	checker timing
Date: Mon, 10 Dec 2018 10:49:45 +0100
Message-ID: <20181210094959.11338-11-mwilck@suse.com>
References: <20181210094959.11338-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181210094959.11338-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

These messages, printed for every checker invocation, were helpful
in the past but they don't make much sense under normal operations.
The same information can be derived from journal time stamps on
recent Linux distributions.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 85055993..4d7c2598 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2262,7 +2262,7 @@ checkerloop (void *ap)
 			if (num_paths) {
 				unsigned int max_checkint;
 
-				condlog(3, "checked %d path%s in %lu.%06lu secs",
+				condlog(4, "checked %d path%s in %lu.%06lu secs",
 					num_paths, num_paths > 1 ? "s" : "",
 					diff_time.tv_sec,
 					diff_time.tv_nsec / 1000);
-- 
2.19.2
