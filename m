Received: from out203-205-221-164.mail.qq.com (out203-205-221-164.mail.qq.com [203.205.221.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305DB25A359
	for <dm-devel@lists.linux.dev>; Thu, 16 Jul 2026 06:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784183992; cv=none; b=aVtJVZ9dIcM25Jc5BiteBEzqcx0zFTyB58K1jDICrMc/SpqcdTlPJEJHmyB2YDvMyQ0zw4HMSJVIc6jR+0o7FIBfxsSPqvuHNtYa0v5M0ggrtCcAWDrOZ5hVmDF3WaqwBazBPEO/n+HVRQhjW2MLc4nG18d9Nxqx92rckWzG0fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784183992; c=relaxed/simple;
	bh=KPR6cP8GAAGDTlS+yLPOMQQ/Q9Hm32FBoABTUKNbCSs=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=tWRwWodMuQX/QKfiTdegJCLUlCQUIB0O40aEIYJMU4QZokVoWHPNO7b9s/jfP/UkoxSjstQJAXc/zsyjATUIQISRYReOdX31+tkG+Y/D4z9GCfLzpFtZaFsenLHIdwpUb+ti+Qx9lSMffY/FFOdisMXhWYeLpUMHY0MVdaFJzYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=I4PM3H6G; arc=none smtp.client-ip=203.205.221.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="I4PM3H6G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1784183984; bh=GxoVUtoksR1mgOy4Msyb5oKfAgrTxS/WN8h9qrfZaeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I4PM3H6GBDbpgzrK3xEzO+WUnCvjsHiD/iX/WoKH075YjUupJD/YLaxLfO3OGwhaf
	 zysa6sTC6Fs3GKuWnTuMrLnbYicp6wBoio+yxGBYQF7x1gG4pl9+iKl/FP+HmymFN2
	 Yleth0zwObAbepAC2nQMLIEXAI7stOWaZIyVRUxE=
Received: from localhost.localdomain ([1.193.37.112])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 9EA2F40A; Thu, 16 Jul 2026 14:39:42 +0800
X-QQ-mid: xmsmtpt1784183982tdr9ih91o
Message-ID: <tencent_D3139F3D56868836E0EEE2BB029AB9EB4809@qq.com>
X-QQ-XMAILINFO: Od8VqZhFMB3NlnIC5bNGyeSK5GynzVVSkpS33uX8oJTYoDxAItu1dxBHqLvIq/
	 9wdU02vwqM35RRhxvLjdH15YqQ87QLEXBCZFRUgC03PlZB6qaRjs2whORhsUQE9M/xaTDqOzi6Od
	 Y7iktGbmz/J8FDxl3/s+9EFe2TbGc3XvLW2n6c4l+0FDx217eNlo2vbv5Q9YuOgigCvP2GSMEMuW
	 LlkIxKcfEsm96bLhw6xIXFgIfFs8dqKLRtDmjybAoSTnlbREIG/NStBlPJXJRmwp99w2M8Xoj9Jf
	 Jt58dcwWalS6524oxHZ6L4psVXGr7eqi5LkpKJtvLGuFz7YaZkOQe/k0Th8XLxUpwLbm0X4sq0Ot
	 OEscTuLwxS36coz8wssnHQMUc5df5m7tYzj3owqRlqIvCxdcG4KkBKA8N24tcNtL6PDPb5WgaqbV
	 ympu74E5nr6cp+7tCkX+fIW1+ecb9+6zrhA0Nxg6qB6k7zYKv7h61FO9TYIIErUXxPbOtFP4t0+z
	 VgBSJmLDUXBDbNY1fElIDx7JQQEWVLjew6dpRIM8OQzP+/rIC9ZSfRfFvMIWKgeEiMqunI7QFgTy
	 DZri+Kxx5SsM+pm9P2uI2MK385VsxqN0dk2QVLR5/1bCvONH3/udtOvziZZk+/MukNcb3Y0t0sR8
	 muXwr7dcnZEE9LuKQovFcIuF0b70lx3XxjjIkW5PMcLWUWgR9sBnQKJ1fxuoqNQOB8y6blow6tAb
	 mtAf7c0ouLlze8ogaEuETh++IY6RU4OaeFIsipaJlBv6JG2kF1nWadcZdFrAeN7g1f18MJaAVuUe
	 dsDCB+5syUIiBZLwA2XL5Sw+sb3/NRUnsUCULLMSZs7FjHB7ERy84/gUo5Z2GPyyl/ZJXOraz1bu
	 X1mcFsjqQjwiVcQdgOjulTmc5fFxQvcwdKYBSD5pAiSw224cVYkK2rFCfKlkEV/bNvm2Grp6bxzg
	 roErUQKlh1PQQ3jizr1e2F/YGwXDTuYiAGxI3YljIJD5F3bFWYrt7Cd0nCovvt8rUC/RtA/94HhJ
	 ibH6BljA==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: 303146950@qq.com
To: mwilck@suse.com
Cc: 303146950@qq.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	kouwenqi@kylinos.cn
Subject: [PATCH v2] kpartx: fix crash and truncated device creation with long -p delimiter
Date: Thu, 16 Jul 2026 14:39:19 +0800
X-OQ-MSGID: <20260716063919.3553-1-303146950@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <f7fbd9be3b9552031f49caf6eb86a031154052c0.camel@suse.com>
References: <f7fbd9be3b9552031f49caf6eb86a031154052c0.camel@suse.com>
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
- Having dm_find_part() return -1 when format_partname() fails, so
  that callers can test the return value directly (negative for error,
  0 for not found, positive for found)
- In the ADD/UPDATE loops (both main and container), checking the
  return value: negative means name too long (skip with error message),
  0 means not found (create), positive means found (reload)
- In the DELETE loop, only proceeding with removal when dm_find_part()
  returns positive (partition found), skipping when it returns zero
  (not found) or negative (error)
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
 kpartx/devmapper.c |  2 +-
 kpartx/kpartx.c    | 52 ++++++++++++++++++++++++++++++++--------------
 2 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 45dac585..c50d6368 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -646,7 +646,7 @@ int dm_find_part(const char *parent, const char *delim, int part,
 	if (!format_partname(name, namesiz, parent, delim, part)) {
 		if (verbose)
 			fprintf(stderr, "partname too small\n");
-		return 0;
+		return -1;
 	}
 
 	r = dm_map_present(name, part_uuid);
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index cfd82128..72f0bb70 100644
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
+				int res = dm_find_part(mapname, delim, j + 1, uuid,
+						       partname, sizeof(partname),
+						       &part_uuid, verbose);
+				if (res < 0) {
+					fprintf(stderr,
+						"partition name too long for partition %d, skipping\n",
+						j + 1);
+					r++;
+					continue;
+				} else if (res == 0) {
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
+					int res = dm_find_part(mapname, delim, j + 1, uuid,
+								partname,
+								sizeof(partname),
+								&part_uuid, verbose);
+					if (res < 0) {
+						fprintf(stderr,
+							"partition name too long for partition %d, skipping\n",
+							j + 1);
+						r++;
+						continue;
+					} else if (res == 0) {
+						op = DM_DEVICE_CREATE;
+					} else {
+						op = DM_DEVICE_RELOAD;
+					}
 
 					if (part_uuid && uuid) {
 						if (check_uuid(uuid, part_uuid, &reason) != 0) {
@@ -570,11 +590,11 @@ main(int argc, char **argv){
 			}
 
 			for (j = MAXSLICES-1; j >= 0; j--) {
-				char *part_uuid, *reason;
-				if (slices[j].size ||
-				    !dm_find_part(mapname, delim, j + 1, uuid,
-						  partname, sizeof(partname),
-						  &part_uuid, verbose))
+				char *part_uuid = NULL, *reason;
+				int res = dm_find_part(mapname, delim, j + 1, uuid,
+						      partname, sizeof(partname),
+						      &part_uuid, verbose);
+				if (slices[j].size || res <= 0)
 					continue;
 
 				if (part_uuid && uuid) {
-- 
2.43.0

