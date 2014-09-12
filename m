From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 4/6] Fix missing frees and null terminations
Date: Fri, 12 Sep 2014 12:44:50 -0500
Message-ID: <1410543892-29826-5-git-send-email-bmarzins@redhat.com>
References: <1410543892-29826-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1410543892-29826-1-git-send-email-bmarzins@redhat.com>
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

There were a number of error code paths where multipath wasn't correctly
freeing memory.  Also, readlink doesn't null terminate strings, so
multipath needs to make sure that they get terminated.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/devmapper.c                       | 3 ++-
 libmultipath/alias.c                     | 1 +
 libmultipath/blacklist.c                 | 7 +++++++
 libmultipath/prioritizers/iet.c          | 2 ++
 libmultipath/prioritizers/weightedpath.c | 5 ++++-
 libmultipath/util.c                      | 2 +-
 6 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 7879a09..a3272d4 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -132,8 +132,9 @@ dm_addmap (int task, const char *name, const char *target,
 		goto addout;
 	r = dm_task_run (dmt);
 
-	addout:
+addout:
 	dm_task_destroy (dmt);
+	free(prefixed_uuid);
 
 	return r;
 }
diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index f2859b0..7d12a0c 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -328,6 +328,7 @@ get_user_friendly_alias(char *wwid, char *file, char *prefix,
 	if (fflush(f) != 0) {
 		condlog(0, "cannot fflush bindings file stream : %s",
 			strerror(errno));
+		free(alias);
 		fclose(f);
 		return NULL;
 	}
diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 651bd7e..3f9e80b 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -80,6 +80,8 @@ set_ble_device (vector blist, char * vendor, char * product, int origin)
 		if (regcomp(&ble->vendor_reg, vendor,
 			    REG_EXTENDED|REG_NOSUB)) {
 			FREE(vendor);
+			if (product)
+				FREE(product);
 			return 1;
 		}
 		ble->vendor = vendor;
@@ -88,6 +90,10 @@ set_ble_device (vector blist, char * vendor, char * product, int origin)
 		if (regcomp(&ble->product_reg, product,
 			    REG_EXTENDED|REG_NOSUB)) {
 			FREE(product);
+			if (vendor) {
+				ble->vendor = NULL;
+				FREE(vendor);
+			}
 			return 1;
 		}
 		ble->product = product;
@@ -202,6 +208,7 @@ setup_default_blist (struct config * conf)
 					   STRDUP(hwe->bl_product),
 					   ORIGIN_DEFAULT)) {
 				FREE(ble);
+				vector_del_slot(conf->blist_device, VECTOR_SIZE(conf->blist_device) - 1);
 				return 1;
 			}
 		}
diff --git a/libmultipath/prioritizers/iet.c b/libmultipath/prioritizers/iet.c
index 94406df..0bcc48b 100644
--- a/libmultipath/prioritizers/iet.c
+++ b/libmultipath/prioritizers/iet.c
@@ -109,6 +109,7 @@ int iet_prio(const char *dev, char * args)
 			ssize_t nchars = readlink(path, buffer, sizeof(buffer)-1);
 			if (nchars != -1) {
 				char *device;
+				buffer[nchars] = '\0';
 				device = find_regex(buffer,"(sd[a-z]+)");
 				// if device parsed is the right one
 				if (device!=NULL && strncmp(device, dev, strlen(device)) == 0) {
@@ -118,6 +119,7 @@ int iet_prio(const char *dev, char * args)
 					if (ip!=NULL && strncmp(ip, preferredip, strlen(ip)) == 0) {
 						// high prio
 						free(ip);
+						free(device);
 						closedir(dir_p);
 						return 20;
 					}
diff --git a/libmultipath/prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c
index 54c9039..13bc52f 100644
--- a/libmultipath/prioritizers/weightedpath.c
+++ b/libmultipath/prioritizers/weightedpath.c
@@ -61,8 +61,10 @@ int prio_path_weight(struct path *pp, char *prio_args)
 	regex = get_next_string(&temp, split_char);
 
 	/* Return default priority if the argument is not parseable */
-	if (!regex)
+	if (!regex) {
+		FREE(arg);
 		return priority;
+	}
 
 	if (!strcmp(regex, HBTL)) {
 		sprintf(path, "%d:%d:%d:%d", pp->sg_id.host_no,
@@ -72,6 +74,7 @@ int prio_path_weight(struct path *pp, char *prio_args)
 	} else {
 		condlog(0, "%s: %s - Invalid arguments", pp->dev,
 			pp->prio.name);
+		FREE(arg);
 		return priority;
 	}
 
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 06a6311..b8487ac 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -165,7 +165,7 @@ devt2devname (char *devname, int devname_len, char *devt)
 		sprintf(block_path,"/sys/dev/block/%u:%u", major, minor);
 		if (lstat(block_path, &statbuf) == 0) {
 			if (S_ISLNK(statbuf.st_mode) &&
-			    readlink(block_path, dev, FILE_NAME_SIZE) > 0) {
+			    readlink(block_path, dev, FILE_NAME_SIZE-1) > 0) {
 				char *p = strrchr(dev, '/');
 
 				if (!p) {
-- 
1.8.3.1
