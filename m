From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/4] dm-userspace: cosmetic fixes
Date: Sat, 30 Sep 2006 19:44:31 +0900
Message-ID: <200609301044.k8UAibB8013341@r-dd.iij4u.or.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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
Cc: danms@us.ibm.com
List-Id: dm-devel.ids

kill needless whitespaces and braces, fix compiler warnings on 64-bit
platforms, etc.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/md/dm-userspace-chardev.c |   23 ++++++++++++-----------
 drivers/md/dm-userspace.c         |   21 ++++++++-------------
 2 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/md/dm-userspace-chardev.c b/drivers/md/dm-userspace-chardev.c
index c72ca77..869e359 100644
--- a/drivers/md/dm-userspace-chardev.c
+++ b/drivers/md/dm-userspace-chardev.c
@@ -126,11 +126,11 @@ struct dmu_request *pluck_next_request(s
 		req = list_entry(dev->tx_requests.next,
 				 struct dmu_request, list);
 		list_del_init(&req->list);
-		
+
 		atomic_dec(&dev->t_reqs);
 	}
 	spin_unlock_irqrestore(&dev->tx_lock, flags);
-	
+
 	if (req && ((req->type == DM_USERSPACE_MAP_BLOCK_REQ) ||
 		    (req->type == DM_USERSPACE_MAP_DONE))) {
 		spin_lock(&dev->lock);
@@ -232,7 +232,8 @@ static void flush_block(int read_err, un
 	while ((dreq = pluck_dep_req(req))) {
 		if (id > dreq->id) {
 			printk(KERN_EMERG "Flushing %llu after %llu\n",
-			       dreq->id, id);
+			       (unsigned long long) dreq->id,
+			       (unsigned long long) id);
 		}
 		id = dreq->id;
 		atomic_inc(&req->dev->f_reqs);
@@ -351,7 +352,7 @@ static void do_map_bio(struct dmu_device
 	req = find_rx_request(dev, msg->id_of_req);
 	if (!req) {
 		DMERR("Unable to complete unknown map: %llu\n",
-		      msg->id_of_req);
+		      (unsigned long long) msg->id_of_req);
 		return;
 	}
 
@@ -370,14 +371,14 @@ #else
 #endif
 }
 
-static void do_map_done(struct dmu_device *dev, uint64_t id_of_op, int fail) 
+static void do_map_done(struct dmu_device *dev, uint64_t id_of_op, int fail)
 {
 	struct dmu_request *req;
 
 	req = find_rx_request(dev, id_of_op);
 	if (!req) {
 		DMERR("Unable to complete unknown request: %llu\n",
-		      id_of_op);
+		      (unsigned long long) id_of_op);
 		return;
 	}
 
@@ -389,16 +390,17 @@ static void do_map_done(struct dmu_devic
 static void do_map_failed(struct dmu_device *dev, uint64_t id_of_op)
 {
 	struct dmu_request *req;
-	
+
 	req = find_rx_request(dev, id_of_op);
 	if (!req) {
 		DMERR("Unable to fail unknown request: %llu\n",
-		      id_of_op);
+		      (unsigned long long) id_of_op);
 		return;
 	}
 
 	DMERR("Userspace failed to map id %llu (sector %llu)",
-	      id_of_op, req->bio->bi_sector);
+	      (unsigned long long) id_of_op,
+	      (unsigned long long) req->bio->bi_sector);
 
 	bio_io_error(req->bio, req->bio->bi_size);
 
@@ -447,9 +449,8 @@ ssize_t dmu_ctl_write(struct file *file,
 		}
 	}
  out:
-	if (ret < sizeof(msg)) {
+	if (ret < sizeof(msg))
 		DMINFO("Received 0 responses from userspace");
-	}
 
 	return ret;
 }
diff --git a/drivers/md/dm-userspace.c b/drivers/md/dm-userspace.c
index ff6d6d1..3f3d2ef 100644
--- a/drivers/md/dm-userspace.c
+++ b/drivers/md/dm-userspace.c
@@ -268,7 +268,7 @@ static struct dmu_device *new_dmu_device
 	int                ret;
 
 	dev = kmalloc(sizeof(*dev), GFP_KERNEL);
-	if (dev == NULL) {
+	if (!dev) {
 		DMERR("Failed to allocate new userspace device");
 		return NULL;
 	}
@@ -337,17 +337,14 @@ static int dmu_ctr(struct dm_target *ti,
 	block_size = simple_strtoul(block_size_param, NULL, 10) / 512;
 
 	dev = find_dmu_device(device_key);
-	if (dev == NULL) {
-		dev = new_dmu_device(device_key,
-				     ti,
-				     block_size);
-		if (dev == NULL) {
+	if (!dev) {
+		dev = new_dmu_device(device_key, ti, block_size);
+		if (!dev) {
 			ti->error = "Failed to create device";
 			goto bad;
 		}
-	} else {
+	} else
 		get_dev(dev);
-	}
 
 	spin_lock(&dev->lock);
 	if (dev->block_size != block_size) {
@@ -373,13 +370,11 @@ static int dmu_ctr(struct dm_target *ti,
 	return 0;
 
  bad:
-	if (dev) {
+	if (dev)
 		spin_unlock(&dev->lock);
-	}
  out:
-	if (dev) {
+	if (dev)
 		put_dev(dev);
-	}
 
 	return -EINVAL;
 }
@@ -467,7 +462,7 @@ static int dmu_status(struct dm_target *
 	case STATUSTYPE_TABLE:
 		snprintf(result, maxlen, "%s %llu",
 			 dev->key,
-			 dev->block_size * 512);
+			 (unsigned long long) dev->block_size * 512);
 		break;
 	}
 
-- 
1.4.1
