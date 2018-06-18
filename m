From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 5/5] Input: evdev - Switch to bitmap API
Date: Mon, 18 Jun 2018 16:10:03 +0300
Message-ID: <20180618131003.88110-6-andriy.shevchenko@linux.intel.com>
References: <20180618131003.88110-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618131003.88110-1-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Yury Norov <ynorov@caviumnetworks.com>, linux-kernel@vger.kernel.org, mika.westerberg@linux.intel.com, Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: dm-devel.ids

Switch to bitmap API, i.e. bitmap_alloc(), bitmap_zalloc(), to show
clearly what we are allocating. Besides that it returns pointer of
bitmap type instead of opaque void *.

While here, replace memcpy() with bitmap_copy() for sake of consistency.

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/input/evdev.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index c81c79d01d93..370206f987f9 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -481,7 +481,7 @@ static int evdev_release(struct inode *inode, struct file *file)
 	evdev_detach_client(evdev, client);
 
 	for (i = 0; i < EV_CNT; ++i)
-		kfree(client->evmasks[i]);
+		bitmap_free(client->evmasks[i]);
 
 	kvfree(client);
 
@@ -925,17 +925,15 @@ static int evdev_handle_get_val(struct evdev_client *client,
 {
 	int ret;
 	unsigned long *mem;
-	size_t len;
 
-	len = BITS_TO_LONGS(maxbit) * sizeof(unsigned long);
-	mem = kmalloc(len, GFP_KERNEL);
+	mem = bitmap_alloc(maxbit, GFP_KERNEL);
 	if (!mem)
 		return -ENOMEM;
 
 	spin_lock_irq(&dev->event_lock);
 	spin_lock(&client->buffer_lock);
 
-	memcpy(mem, bits, len);
+	bitmap_copy(mem, bits, maxbit);
 
 	spin_unlock(&dev->event_lock);
 
@@ -947,7 +945,7 @@ static int evdev_handle_get_val(struct evdev_client *client,
 	if (ret < 0)
 		evdev_queue_syn_dropped(client);
 
-	kfree(mem);
+	bitmap_free(mem);
 
 	return ret;
 }
@@ -1003,13 +1001,13 @@ static int evdev_set_mask(struct evdev_client *client,
 	if (!cnt)
 		return 0;
 
-	mask = kcalloc(sizeof(unsigned long), BITS_TO_LONGS(cnt), GFP_KERNEL);
+	mask = bitmap_zalloc(cnt, GFP_KERNEL);
 	if (!mask)
 		return -ENOMEM;
 
 	error = bits_from_user(mask, cnt - 1, codes_size, codes, compat);
 	if (error < 0) {
-		kfree(mask);
+		bitmap_free(mask);
 		return error;
 	}
 
@@ -1018,7 +1016,7 @@ static int evdev_set_mask(struct evdev_client *client,
 	client->evmasks[type] = mask;
 	spin_unlock_irqrestore(&client->buffer_lock, flags);
 
-	kfree(oldmask);
+	bitmap_free(oldmask);
 
 	return 0;
 }
-- 
2.17.1
