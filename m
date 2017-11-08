From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 3/6] multipath: there is no "none" path state
Date: Tue,  7 Nov 2017 18:15:13 -0600
Message-ID: <1510100116-6206-4-git-send-email-bmarzins@redhat.com>
References: <1510100116-6206-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1510100116-6206-1-git-send-email-bmarzins@redhat.com>
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

There is a "none" path checker, but not a "none" path state.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index cd6d6a3..94d8486 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -19,7 +19,6 @@ char *checker_state_names[] = {
 	"timeout",
 	"removed",
 	"delayed",
-	"none",
 };
 
 static LIST_HEAD(checkers);
-- 
2.7.4
