From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 09/12] orphan paths on failed add
Date: Mon, 30 Jun 2014 00:14:00 -0500
Message-ID: <1404105243-5071-10-git-send-email-bmarzins@redhat.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

When multipathd tries to add a path but fails doing the table reload, it
wasn't orphaning the path.  This can cause problems later if multipathd
tries to switch the pathgroup of this path which isn't actually part of
the multipath device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 337bfe9..3afed62 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -561,7 +561,7 @@ rescan:
 		return 0;
 	}
 	else
-		return 1;
+		goto fail;
 
 fail_map:
 	remove_map(mpp, vecs, 1);
-- 
1.8.3.1
