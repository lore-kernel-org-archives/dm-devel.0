Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBB1435A8D
	for <dm-devel@lists.linux.dev>; Wed, 15 Jul 2026 09:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784108206; cv=none; b=ZH2n4yGuIeBT3ddYSx+E9JNn/uFbce3FP4ezLN4QjP17lDFl6ifw6xC7c8/6wqQC2etS5K8pPXxrqHSSGLtutQbY3glefGveNr+1EovFDTIYMsf4oLDNkzX6cITnZP9EVFC7j9aajfTCPqYUBjpExNPzS/CyaGLTuWcxQdg/7Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784108206; c=relaxed/simple;
	bh=yPXHImoKBeqUm+jp33u8dLT0wV8cmIWjj3dER2nCL9o=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=jOoyml0zW9XuvDxbKhbTDK0kRLbqjuMnt3sQEToLoNRQ9QlnQR9U5uKk4r42dVbSLLx1p5M9gu73ypY2zjrUoXbfq4m4XAIkRDJvVhAqtZx0eHkQs1IvWQgwXy3hJP501Xw6e1FulxHVWHyG9nfDKn0KD2R+jzEPUzLBw0WNPAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=cYvB2+g9; arc=none smtp.client-ip=43.163.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="cYvB2+g9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1784108196; bh=IPGIiSOhkr5gIitqfC+A5c9H2t14rtgWffVpZBGTzIw=;
	h=From:To:Cc:Subject:Date;
	b=cYvB2+g98CQmD8yZKGHj0IP9oDj+crU9GYYLldfPxVgEx+3gWSGE7AkgvzbovlMKH
	 Qg9rjICr6I7BDhHWi7bFPqqufPSpiUegFLOP5MQTfkToQSbfmt9P3bu5JS8Z6lJgCn
	 q/im6DVdUdwe7nAMfVmH84pkHzK3eZl2EeoPUOgg=
Received: from localhost.localdomain ([1.193.37.112])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 92203675; Wed, 15 Jul 2026 17:36:34 +0800
X-QQ-mid: xmsmtpt1784108194tduho80xu
Message-ID: <tencent_1439656590A8038E3E7E20A0961B8C34E805@qq.com>
X-QQ-XMAILINFO: N6Ax/oucgBO+ECTfEMDc+8wMIYDuaNlX2UPo2kX9lY1FQqhtxRerEjUSaQxTvf
	 UFNmQeX6MGfENyW57jD30dfq/5zHRi3IyZ9wKEsyZUxoOFkmdIAqp0dalPfGPjnmqmu2SjMhRAk9
	 qUUcUk244qF58rElMhdtMAdWqoYbRo4XN1AslLBhh7wwK3wU68eNNxC+8JfYQpW4woB2J3Cq2V6B
	 neKoUZaFu6zoQAJ9SvzUnTCoYkq1LrTRj9INuKzAii1fHPMZ5cwLeYja5As+DykwWQYvcIxDOuus
	 wxDBc5fkPSGmsgYs+J98CS62420Zn7ztul0+WbvdDa6WZMaO7j60+gOU8VxyRzxkCuYb30UtdSXR
	 8+kGMLO2rl7NaTaMYBOBR7QooxkmoEDMseVCKLiavWhK9KvQZlY6yvkQu09D4vt1H9flJFUZqvkZ
	 8bbqWSLg3bje9juZxPJ+EYNBVtzDQP38lpomwIQF75pLuOrSoTyYUJwNp9Mhn+dkW2ZAq0dzj6uQ
	 UOG5HjAd4dYn5E4ezpf/90D2BAfyLvU8FkJFzK/e1aJDOFCjJnStyt0mX3irLMyIfP/2EsLpWsNj
	 /j9sXOJVV1bc/4jC/xfRTV8YwEaVcjL/v72yPWV9vGouunjZDJiNHmQMoeGzkREYWzkFLFAlFjTQ
	 rZdU3jj/yBNc5MYbZhk0NQZjYUqj7tbvPP/G7oQ+uBL1AdDpzQb9M3o99lCksOFci68mFMsgc9yo
	 6VGNlBOohU+3LrCkcijaWt4cF1p3eRlH/k6WCLnNLNnh1dQtRjOJL2oMz4tvJul4kLgBWjbwYw+5
	 HUYhDr+T7uxYR5cssd9KPlVhFzPUSSIR+tPIQXUtKE3mOqM09qsraTwCUXgn0OPKIHbohCbCEasy
	 4k0FWPrYhUJj9mTKpoYLpUMZpFa7uJajMDOFVAKFAQUDmFod8Gnf0fjNEDMXtP/t2rFVQshiAztF
	 HOMi4HQHri1A+VDyYRP19t8AJnSaQY6T+av8jkX6wD/m08JCLWhuYKL1tBctgEbfZwxut3PwdhZU
	 htWkcfzs+uLQosxjAgINvk5Y4taQypeFf2LXa7jA==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: 303146950@qq.com
To: dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	mwilck@suse.com,
	Kou Wenqi <kouwenqi@kylinos.cn>
Subject: [PATCH] kpartx: fix crash and truncated device creation with long -p delimiter
Date: Wed, 15 Jul 2026 17:36:21 +0800
X-OQ-MSGID: <20260715093621.2707-1-303146950@qq.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kou Wenqi <kouwenqi@kylinos.cn>

When the -p delimiter is long enough to make the formatted partition
name exceed PARTNAME_SIZE (128 bytes), three issues occur:

1. format_partname() fails but snprintf has already written a truncated
   name into the buffer. dm_find_part() returns 0 and the caller
   proceeds to dm_addmap() with the truncated name, creating a device
   that was never intended.

2. dm_find_part() returns early without setting *part_uuid. The
   uninitialized local variable part_uuid then gets passed to
   check_uuid() -> strchr(), causing a SIGSEGV.

3. The callers cannot distinguish between "partition not found, create
   new" and "name construction failed" since both return 0.

Fix by:
- Clearing the name buffer in format_partname() on overflow, so that
  callers can detect the failure by checking partname[0]
- In the ADD/UPDATE loops, after dm_find_part() returns 0, checking
  whether partname is empty and skipping the partition with an error
  message instead of proceeding with dm_addmap()
- Initializing part_uuid to NULL in all three partition loop bodies
  (ADD/UPDATE main loop, container partition loop, DELETE loop) so
  that the "if (part_uuid && uuid)" guard correctly skips the UUID
  check when dm_find_part() returns early

Reproduce steps:

  # Create test image
  dd if=/dev/zero of=/tmp/vhlg-test.img bs=1M count=10
  parted /tmp/vhlg-test.img mklabel msdos
  parted /tmp/vhlg-test.img mkpart primary ext4 1MiB 5MiB

  # Reproduce
  kpartx -a -p $(python3 -c "print('A'*200)") /tmp/vhlg-test.img

  # Cleanup
  kpartx -d /tmp/vhlg-test.img
  rm -f /tmp/vhlg-test.img

Signed-off-by: Kou Wenqi <kouwenqi@kylinos.cn>
---
 kpartx/devmapper.c |  4 +++-
 kpartx/kpartx.c    | 44 ++++++++++++++++++++++++++++++++------------
 2 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 45dac585..9eb6eeca 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -113,8 +113,10 @@ strip_slash (char * device)
 static int format_partname(char *buf, size_t bufsiz,
 			   const char *mapname, const char *delim, int part)
 {
-	if (safe_snprintf(buf, bufsiz, "%s%s%d", mapname, delim, part))
+	if (safe_snprintf(buf, bufsiz, "%s%s%d", mapname, delim, part)) {
+		buf[0] = '\0';
 		return 0;
+	}
 	strip_slash(buf);
 	return 1;
 }
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index cfd82128..5972a251 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -437,7 +437,7 @@ main(int argc, char **argv){
 		case UPDATE:
 			/* ADD and UPDATE share the same code that adds new partitions. */
 			for (j = 0, c = 0; j < n; j++) {
-				char *part_uuid, *reason;
+				char *part_uuid = NULL, *reason;
 
 				if (slices[j].size == 0)
 					continue;
@@ -454,10 +454,20 @@ main(int argc, char **argv){
 					exit(1);
 				}
 
-				op = (dm_find_part(mapname, delim, j + 1, uuid,
-						   partname, sizeof(partname),
-						   &part_uuid, verbose) ?
-				      DM_DEVICE_RELOAD : DM_DEVICE_CREATE);
+				if (!dm_find_part(mapname, delim, j + 1, uuid,
+							partname, sizeof(partname),
+							&part_uuid, verbose)) {
+					if (partname[0] == '\0') {
+						fprintf(stderr,
+							"partition name too long for partition %d, skipping\n",
+							j + 1);
+						r++;
+						continue;
+					}
+					op = DM_DEVICE_CREATE;
+				} else {
+					op = DM_DEVICE_RELOAD;
+				}
 
 				if (part_uuid && uuid) {
 					if (check_uuid(uuid, part_uuid, &reason) != 0) {
@@ -500,7 +510,7 @@ main(int argc, char **argv){
 			d = c;
 			while (c) {
 				for (j = 0; j < n; j++) {
-					char *part_uuid, *reason;
+					char *part_uuid = NULL, *reason;
 					int k = slices[j].container - 1;
 
 					if (slices[j].size == 0)
@@ -526,11 +536,21 @@ main(int argc, char **argv){
 						exit(1);
 					}
 
-					op = (dm_find_part(mapname, delim, j + 1, uuid,
-							   partname,
-							   sizeof(partname),
-							   &part_uuid, verbose) ?
-					      DM_DEVICE_RELOAD : DM_DEVICE_CREATE);
+					if (!dm_find_part(mapname, delim, j + 1, uuid,
+								partname,
+								sizeof(partname),
+								&part_uuid, verbose)) {
+						if (partname[0] == '\0') {
+							fprintf(stderr,
+								"partition name too long for partition %d, skipping\n",
+								j + 1);
+							r++;
+							continue;
+						}
+						op = DM_DEVICE_CREATE;
+					} else {
+						op = DM_DEVICE_RELOAD;
+					}
 
 					if (part_uuid && uuid) {
 						if (check_uuid(uuid, part_uuid, &reason) != 0) {
@@ -570,7 +590,7 @@ main(int argc, char **argv){
 			}
 
 			for (j = MAXSLICES-1; j >= 0; j--) {
-				char *part_uuid, *reason;
+				char *part_uuid = NULL, *reason;
 				if (slices[j].size ||
 				    !dm_find_part(mapname, delim, j + 1, uuid,
 						  partname, sizeof(partname),
-- 
2.43.0

