From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 19/33] libmultipath: setup_features: log msg if
	queue_if_no_path is ignored
Date: Tue, 28 Feb 2017 17:23:15 +0100
Message-ID: <20170228162329.14517-20-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.de>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/propsel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index bba8194c..0c499339 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -288,7 +288,9 @@ out:
 			condlog(1, "%s: config error, overriding 'no_path_retry' value",
 				mp->alias);
 			mp->no_path_retry = NO_PATH_RETRY_QUEUE;
-		}
+		} else if (mp->no_path_retry != NO_PATH_RETRY_QUEUE)
+			condlog(1, "%s: config error, ignoring 'queue_if_no_path' because no_path_retry=%d",
+				mp->alias, mp->no_path_retry);
 	}
 	return 0;
 }
-- 
2.11.0
