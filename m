From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/42] Fixup pathgroup allocation in
	disassemble_map()
Date: Tue,  8 Jan 2013 14:53:41 +0100
Message-ID: <1357653259-62650-4-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The check for empty path groups in disassemble_map() is not quite
correct; we might end up removing the pathgroup vector even though
there are some entries in it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/dmparser.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index b3c52fc..a45854d 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -232,13 +232,16 @@ disassemble_map (vector pathvec, char * params, struct multipath * mpp)
 	num_pg = atoi(word);
 	FREE(word);
 
-	if (num_pg > 0 && !mpp->pg) {
-		mpp->pg = vector_alloc();
-
-		if (!mpp->pg)
-			return 1;
-	} else
+	if (num_pg > 0) {
+		if (!mpp->pg) {
+			mpp->pg = vector_alloc();
+			if (!mpp->pg)
+				return 1;
+		}
+	} else {
+		free_pgvec(mpp->pg, KEEP_PATHS);
 		mpp->pg = NULL;
+	}
 
 	/*
 	 * first pg to try
-- 
1.7.4.2
