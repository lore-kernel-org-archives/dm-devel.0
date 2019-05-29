From: Gen Zhang <blackgod016574@gmail.com>
Subject: [PATCH] dm-init: fix 2 incorrect use of kstrndup()
Date: Wed, 29 May 2019 09:33:20 +0800
Message-ID: <20190529013320.GA3307@zhanggen-UX430UQ>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

In drivers/md/dm-init.c, kstrndup() is incorrectly used twice.

It should be: char *kstrndup(const char *s, size_t max, gfp_t gfp);

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
---
diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index 352e803..526e261 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -140,8 +140,8 @@ static char __init *dm_parse_table_entry(struct dm_device *dev, char *str)
 		return ERR_PTR(-EINVAL);
 	}
 	/* target_args */
-	dev->target_args_array[n] = kstrndup(field[3], GFP_KERNEL,
-					     DM_MAX_STR_SIZE);
+	dev->target_args_array[n] = kstrndup(field[3], DM_MAX_STR_SIZE,
+						GFP_KERNEL);
 	if (!dev->target_args_array[n])
 		return ERR_PTR(-ENOMEM);
 
@@ -275,7 +275,7 @@ static int __init dm_init_init(void)
 		DMERR("Argument is too big. Limit is %d\n", DM_MAX_STR_SIZE);
 		return -EINVAL;
 	}
-	str = kstrndup(create, GFP_KERNEL, DM_MAX_STR_SIZE);
+	str = kstrndup(create, DM_MAX_STR_SIZE, GFP_KERNEL);
 	if (!str)
 		return -ENOMEM;
 
---
