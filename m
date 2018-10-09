From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v4 13/19] multipath: fix max array size in
	print_cmd_valid
Date: Tue,  9 Oct 2018 18:03:10 -0500
Message-ID: <1539126196-28926-14-git-send-email-bmarzins@redhat.com>
References: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

The code is attempting to verify that 0 <= k < 3
However, sizeof(val) is 12, assuming 4 byte integers. The check needs to
take integer size into account. Found by coverity.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/main.c b/multipath/main.c
index fc5bf16..d5aad95 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -482,7 +482,7 @@ static int print_cmd_valid(int k, const vector pathvec,
 	struct timespec until;
 	struct path *pp;
 
-	if (k < 0 || k >= sizeof(vals))
+	if (k < 0 || k >= (sizeof(vals) / sizeof(int)))
 		return 1;
 
 	if (k == 2) {
-- 
2.7.4
