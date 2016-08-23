From: Robert LeBlanc <robert@leblancnet.us>
Subject: [PATCH] mdopen: Prevent overrunning the devname buffer when copying devnm into it for long md names.
Date: Tue, 23 Aug 2016 14:37:54 -0600
Message-ID: <20160823203754.28117-1-robert@leblancnet.us>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dm-devel@redhat.com, robert@leblancnet.us
List-Id: dm-devel.ids

Signed-Off: Robert LeBlanc<robert@leblancnet.us>
---
 mdopen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdopen.c b/mdopen.c
index f818fdf..5af344b 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -144,7 +144,7 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 	struct createinfo *ci = conf_get_create_info();
 	int parts;
 	char *cname;
-	char devname[20];
+	char devname[37];
 	char devnm[32];
 	char cbuf[400];
 	if (chosen == NULL)
-- 
2.9.3

