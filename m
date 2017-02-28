From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 22/33] libmultipath: disassemble_map: skip
	no_path_retry check
Date: Tue, 28 Feb 2017 17:23:18 +0100
Message-ID: <20170228162329.14517-23-mwilck@suse.com>
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

mpp->no_path_retry is already checked in setup_feature() itself,
no need to do it here as well. This allows using setup_feature()
for other features except queue_if_no_path.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dmparser.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 274eb947..4940e8cf 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -183,10 +183,7 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 			FREE(word);
 			return 1;
 		}
-		if ((mpp->no_path_retry == NO_PATH_RETRY_UNDEF) ||
-			(mpp->no_path_retry == NO_PATH_RETRY_FAIL) ||
-			(mpp->no_path_retry == NO_PATH_RETRY_QUEUE))
-			setup_feature(mpp, word);
+		setup_feature(mpp, word);
 
 		FREE(word);
 	}
-- 
2.11.0
