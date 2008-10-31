From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] dm-stripe: pay attention to failing registration
	in dm_stripe_init()
Date: Fri, 31 Oct 2008 16:11:09 +0100
Message-ID: <1225465869.1196.60.camel@o>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

dm_stripe_init() doesn't pay attention to a failing target registration.

Heinz

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

---
diff -up linux-2.6.27.4/drivers/md/dm-stripe.c.orig1
linux-2.6.27.4/drivers/md/dm-stripe.c
--- linux-2.6.27.4/drivers/md/dm-stripe.c.orig1	2008-10-26
00:05:07.000000000 +0200
+++ linux-2.6.27.4/drivers/md/dm-stripe.c	2008-10-31 16:05:12.000000000
+0100
@@ -322,12 +322,13 @@ int __init dm_stripe_init(void)
 	r = dm_register_target(&stripe_target);
 	if (r < 0)
 		DMWARN("target registration failed");
-
-	kstriped = create_singlethread_workqueue("kstriped");
-	if (!kstriped) {
-		DMERR("failed to create workqueue kstriped");
-		dm_unregister_target(&stripe_target);
-		return -ENOMEM;
+	else {
+		kstriped = create_singlethread_workqueue("kstriped");
+		if (!kstriped) {
+			DMERR("failed to create workqueue kstriped");
+			dm_unregister_target(&stripe_target);
+			r = -ENOMEM;
+		}
 	}
 
 	return r;
