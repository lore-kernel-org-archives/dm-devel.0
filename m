Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0A93B2D18
	for <dm-devel@lists.linux.dev>; Thu, 16 Jul 2026 08:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784190089; cv=none; b=j71+84c0lPlQW/45ppyy7BzW7+4a1EhZ6kY+xSIO2Xeayp1zVea3SgA+fKjfu37FhobntEpshZBAplkVAT471IOJSkaxpGN7IO+p3vFMGiUe53eOBz5wfa5SaQ0vbyiNOCSsMt5ZpSgwfJbjhJNpOqL/Qlyih7e78WRWr14OwsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784190089; c=relaxed/simple;
	bh=5lsBjvm0hVBTO4RFhAV/PhDOVbUTjV5nYuNHiCE5ZyM=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=QrK8cBeD1Svnx9P6W9R0FSM1tEPQScx3Dd5s31NjsB/IvJD8mSQVPm3O1NPKIbYdt4XlQY3RWmREDeWsA65SbRt3yjwbeuPgQ/id5ZAvN/yF6LovzKYCJAI7wuzzC35jisvS6WC6NMMueN/eUMwBDO+zxfbRKF4mTkhQB8mUsA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=kLckn+nW; arc=none smtp.client-ip=162.62.57.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="kLckn+nW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1784190080; bh=nI6gZHqT11i3NBH/QY6h7IwEeNibJbkGa/BqTayuQnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLckn+nWLaniZkMRxuGg4QEc+MajBbdRnaqTppOOr0SFUCoNCDhVc0xorJsIB33rN
	 N69n4vANqDvV3PxxtqLf3RLhzGIb8kBzSaQPLMdqNkcFlNrZdeFJGBsHO8eYkp01Ux
	 BdHVVkdftSEJ6bBWkULyH1KL/VEvRIZOb6DtkaMs=
Received: from localhost.localdomain ([1.193.37.112])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 551B8E87; Thu, 16 Jul 2026 16:21:17 +0800
X-QQ-mid: xmsmtpt1784190077tznceebv5
Message-ID: <tencent_918E34F67972258FC8072E2DFE38C0989B05@qq.com>
X-QQ-XMAILINFO: NY/MPejODIJVI9jHw8E3hcjgg5G4jA4A3588SmBP1aOLPE/Cxe6Tr2Y1NlWbOM
	 MDBsvLk7OCKacswawQGTDHxFHhYqIiBIIAm3BwxtEao+dVNYIgkDyZnf/a4K+A/naTzhNkT3Vy92
	 /E3DL8ZYDDgXJmwnNkfPZlz0SpnlVUIMmWQz2Fr0/Yc31Ie2ThWj/j6T76VooZBBwwLV26D06Gkv
	 5FBQZFkAc1M4xeqyDCTwBz9dCPxWFNWi1p01+WHPys3dEWsvwLZIGjiAQJHUHwoJVrSHCiX08gIH
	 zJc1w01hfMd/4xfNwAAdYYmW5ECCSlI7AvEfSjAuQxLMFmDKi4gB1UXidNCVidVqSd9xBwwo6m6l
	 3SOIXeJN2HCBnAjYsr0q7zyXrSBRHAKQvIEUAM5k+Gd+E+RcgAwsny436t2uxliJE7vqHZJq7cmA
	 zFyxHVZqCcEbE+ttIshJFKyBslahvOXzsi59evOGkAiY604zBq1pGel4xP/eaV9vbwEcy4J6ABIb
	 TeRmioO0G/4XOX1xoubytRSYcDPD1znU7q1gNYPV9gIz2CySh7pdUpv55DFN7S3N++sMKe5ZhMQI
	 KAGIiHRoSeahk+qokRtuMJnnu7M+0vnYCYhPSP0AdcqSWc5GO+xhWFX7SWfpBJNWaKIneqdotYkN
	 0yPUKzgcY4CJOusbezjC7qEBUdZMUNrbt0uLLaGm4q4Rg05gTQNCl8u92ecLbKWrfGSOogdoo8U5
	 n9N4lnzWNUQHhdp7foLMDc6apJTtGhX1mcwGMOxNMO3S4rMJul54G3n4L9Q9RiAiEpuMlkXhMoOn
	 HpViKPt1ZVD9ie4Ju0Pxt0ZbMS6pYJeNnvm5owz0EYD/Rs9Bc+uygqGDq9C1CP6mWYjq4inv9cbn
	 GmAVL47BpU/75AR1Cc4nhI6bpKazaKivtYKw/O01+/yAGDbpJsCEq5Ez3OgSIaa4+OlLve8B6V0n
	 WMN2jDnJ9y4iy4t+w7zhwD6jrFo6cKS5TKO9qSB1QQOwKmp6Ei6A90Zs188CsLGStMMvR463bdbr
	 KjRr/rqb2nTJ6iHFWSA/MBhmmiNoOuU6qxD6rGI9xW0j7YiojyErwoPQq0FdgOJ94qNje+dg==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: 303146950@qq.com
To: mwilck@suse.com
Cc: 303146950@qq.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	kouwenqi@kylinos.cn
Subject: [PATCH v3] kpartx: fix crash and truncated device creation with long -p delimiter
Date: Thu, 16 Jul 2026 16:20:55 +0800
X-OQ-MSGID: <20260716082055.3993-1-303146950@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <0594c64fe12ae0ea0ecee5b032f50e6842b120ed.camel@suse.com>
References: <0594c64fe12ae0ea0ecee5b032f50e6842b120ed.camel@suse.com>
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
- Having dm_find_part() return -1 when format_partname() fails, with
  an error message printed by dm_find_part() itself, so that callers
  can test the return value directly (negative for error,
  0 for not found, positive for found)
- In the ADD/UPDATE loops (both main and container), checking the
  return value: negative means name too long (skip with error count),
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
 kpartx/devmapper.c |  5 ++---
 kpartx/kpartx.c    | 46 ++++++++++++++++++++++++++++++----------------
 2 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 45dac585..e03bcf44 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -644,9 +644,8 @@ int dm_find_part(const char *parent, const char *delim, int part,
 	char dev_t[32];
 
 	if (!format_partname(name, namesiz, parent, delim, part)) {
-		if (verbose)
-			fprintf(stderr, "partname too small\n");
-		return 0;
+		fprintf(stderr, "partition name too long for partition %d\n", part);
+		return -1;
 	}
 
 	r = dm_map_present(name, part_uuid);
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index cfd82128..020f92e3 100644
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
@@ -454,10 +454,17 @@ main(int argc, char **argv){
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
+					r++;
+					continue;
+				} else if (res == 0) {
+					op = DM_DEVICE_CREATE;
+				} else {
+					op = DM_DEVICE_RELOAD;
+				}
 
 				if (part_uuid && uuid) {
 					if (check_uuid(uuid, part_uuid, &reason) != 0) {
@@ -500,7 +507,7 @@ main(int argc, char **argv){
 			d = c;
 			while (c) {
 				for (j = 0; j < n; j++) {
-					char *part_uuid, *reason;
+					char *part_uuid = NULL, *reason;
 					int k = slices[j].container - 1;
 
 					if (slices[j].size == 0)
@@ -526,11 +533,18 @@ main(int argc, char **argv){
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
+						r++;
+						continue;
+					} else if (res == 0) {
+						op = DM_DEVICE_CREATE;
+					} else {
+						op = DM_DEVICE_RELOAD;
+					}
 
 					if (part_uuid && uuid) {
 						if (check_uuid(uuid, part_uuid, &reason) != 0) {
@@ -570,11 +584,11 @@ main(int argc, char **argv){
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

