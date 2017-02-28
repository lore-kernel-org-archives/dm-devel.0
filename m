From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 23/33] libmultipath: disassemble_map: treat minio
	like assemble_map does
Date: Tue, 28 Feb 2017 17:23:19 +0100
Message-ID: <20170228162329.14517-24-mwilck@suse.com>
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

Rather than using 0 for everything except round-robin, read back
the actual minio value from DM.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dmparser.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 4940e8cf..469e60d2 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -392,19 +392,17 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 
 			for (k = 0; k < num_paths_args; k++)
 				if (k == 0) {
+					p += get_word(p, &word);
+					def_minio = atoi(word);
+					FREE(word);
+
 					if (!strncmp(mpp->selector,
 						     "round-robin", 11)) {
-						p += get_word(p, &word);
-						def_minio = atoi(word);
 
 						if (mpp->rr_weight == RR_WEIGHT_PRIO
 						    && pp->priority > 0)
 							def_minio /= pp->priority;
 
-						FREE(word);
-					} else {
-						p += get_word(p, NULL);
-						def_minio = 0;
 					}
 
 					if (def_minio != mpp->minio)
-- 
2.11.0
