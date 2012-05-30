From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] dm:simple_strtoul() cleanup.
Date: Wed, 30 May 2012 16:23:29 +0800
Message-ID: <201205301623260006539@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk <agk@redhat.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Change them to use kstrtoul/kstrtou8/kstrtouint instead of obsolete simple_strtoul().

Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/dm-crypt.c           |    5 +----
 drivers/md/dm-exception-store.c |    6 ++----
 drivers/md/dm-stripe.c          |    7 ++-----
 3 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3f06df5..e2b3240 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1241,7 +1241,6 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 static int crypt_decode_key(u8 *key, char *hex, unsigned int size)
 {
 	char buffer[3];
-	char *endp;
 	unsigned int i;
 
 	buffer[2] = '\0';
@@ -1250,9 +1249,7 @@ static int crypt_decode_key(u8 *key, char *hex, unsigned int size)
 		buffer[0] = *hex++;
 		buffer[1] = *hex++;
 
-		key[i] = (u8)simple_strtoul(buffer, &endp, 16);
-
-		if (endp != &buffer[2])
+		if (kstrtou8(buffer, 16, &key[i]))
 			return -EINVAL;
 	}
 
diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index aa70f7d..cf583bc 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -143,11 +143,9 @@ static int set_chunk_size(struct dm_exception_store *store,
 			  const char *chunk_size_arg, char **error)
 {
 	unsigned long chunk_size_ulong;
-	char *value;
 
-	chunk_size_ulong = simple_strtoul(chunk_size_arg, &value, 10);
-	if (*chunk_size_arg == '\0' || *value != '\0' ||
-	    chunk_size_ulong > UINT_MAX) {
+	if (kstrtoul(chunk_size_arg, 10, &chunk_size_ulong) ||
+			chunk_size_ulong > UINT_MAX) {
 		*error = "Invalid chunk size";
 		return -EINVAL;
 	}
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 35c94ff..183db5d 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -99,7 +99,6 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	sector_t width;
 	uint32_t stripes;
 	uint32_t chunk_size;
-	char *end;
 	int r;
 	unsigned int i;
 
@@ -108,14 +107,12 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return -EINVAL;
 	}
 
-	stripes = simple_strtoul(argv[0], &end, 10);
-	if (!stripes || *end) {
+	if (kstrtouint(argv[0], 10, &stripes) || !stripes) {
 		ti->error = "Invalid stripe count";
 		return -EINVAL;
 	}
 
-	chunk_size = simple_strtoul(argv[1], &end, 10);
-	if (*end) {
+	if (kstrtouint(argv[1], 10, &chunk_size)) {
 		ti->error = "Invalid chunk_size";
 		return -EINVAL;
 	}
-- 
1.7.5.4

 				
--------------
majianpeng
2012-05-30
