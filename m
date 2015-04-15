From: Lidong Zhong <lzhong@suse.com>
Subject: [PATCH] dm-raid1: change default mirror when it's not in
	sync
Date: Wed, 15 Apr 2015 18:50:40 +0800
Message-ID: <1429095040-12658-4-git-send-email-lzhong@suse.com>
References: <1429095040-12658-1-git-send-email-lzhong@suse.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1429095040-12658-1-git-send-email-lzhong@suse.com>
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
Cc: heinzm@redhat.com
List-Id: dm-devel.ids

Change the default mirror to a valid leg even when it's not in sync,
otherwise the mirror set will recover from a non-integrated mirror

Signed-off-by: Lidong Zhong <lzhong@suse.com>
---
 drivers/md/dm-raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 95ec822..db0ccb9 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -231,7 +231,7 @@ static void fail_mirror(struct mirror *m, enum dm_raid1_error error_type)
 	if (m != get_default_mirror(ms))
 		goto out;
 
-	if (!ms->in_sync) {
+	if (!ms->in_sync && !keep_log(ms)) {
 		/*
 		 * Better to issue requests to same failing device
 		 * than to risk returning corrupt data.
-- 
1.8.1.4
