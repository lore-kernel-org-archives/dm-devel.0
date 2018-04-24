From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/2] multipathd: fix reservation_key check
Date: Tue, 24 Apr 2018 15:15:31 -0500
Message-ID: <1524600931-14920-2-git-send-email-bmarzins@redhat.com>
References: <1524600931-14920-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1524600931-14920-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

mpath_pr_event_handle should exit if the reservation key is zero, not
non-zero.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 841d3e9..84af946 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3136,7 +3136,7 @@ int mpath_pr_event_handle(struct path *pp)
 
 	mpp = pp->mpp;
 
-	if (get_be64(mpp->reservation_key))
+	if (!get_be64(mpp->reservation_key))
 		return -1;
 
 	pthread_attr_init(&attr);
-- 
2.7.4
