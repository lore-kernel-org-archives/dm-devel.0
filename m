From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 5/5] multipathd: fix "show maps json" crash
Date: Thu,  1 Jun 2017 22:09:12 -0500
Message-ID: <1496372952-27110-6-git-send-email-bmarzins@redhat.com>
References: <1496372952-27110-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1496372952-27110-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If there are no multipath devices, show_maps_json sets the maximum size
of the reply buffer to 0. Having a size of 0 causes the calls to calloc
and realloc to behave in ways that the code isn't designed to handle,
leading to a double-free crash. Instead, show_maps_json should just
use the INITIAL_REPLY_LEN if there are no multipath devices.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 04c7386..7b0d00c 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -162,10 +162,12 @@ show_maps_json (char ** r, int * len, struct vectors * vecs)
 	struct multipath * mpp;
 	char * c;
 	char * reply;
-	unsigned int maxlen = INITIAL_REPLY_LEN *
-			PRINT_JSON_MULTIPLIER * VECTOR_SIZE(vecs->mpvec);
+	unsigned int maxlen = INITIAL_REPLY_LEN;
 	int again = 1;
 
+	if (VECTOR_SIZE(vecs->mpvec) > 0)
+		maxlen *= PRINT_JSON_MULTIPLIER * VECTOR_SIZE(vecs->mpvec);
+
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
 		if (update_multipath(vecs, mpp->alias, 0)) {
 			return 1;
-- 
2.7.4
