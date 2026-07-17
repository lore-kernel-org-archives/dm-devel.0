Received: from out203-205-221-164.mail.qq.com (out203-205-221-164.mail.qq.com [203.205.221.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DD63783AD
	for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 03:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784259311; cv=none; b=BHXCQzhdxags18ztLCUmk7h35GId6PS5/t14S2FrAjH5DFhNxsy9DApP+ARo3KigjFMhTnK3SYb23F1oJIFFt/n4K0cQUDChqmoB93J3OiJ3VsY3iQ3jRAugT9+5H7kP1ULLis0MpToeUBvbeiH10StMlY1FG/cBvjdRU61yits=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784259311; c=relaxed/simple;
	bh=48wWhJW/3bDAP7dd7i3RZMw2XngjDaXa6cR/ehXaAlY=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=uqn91lUTgY16ObQQWPEm2ruOpK7REr+bzflxhc60sV4lYovBHEqM+WoeAl78FqE1VqyIFdOyuj7GMRVgDh7jBDN59MQPSFSdayTPxp5xA1Nl9qQLdcnzlezWOkA1s3K7TUjZW+R3WVVkMxYZfcdatUvyOV41mhwLwin6/jy9v3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=dUumAxKP; arc=none smtp.client-ip=203.205.221.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="dUumAxKP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1784259297; bh=ZgAfM2ly64GCjAF5aiI8XkTIabUp0xq5oVM42n/+2+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dUumAxKPk3i4w07wppKsB0E3C0TEbTslfv3eV4qXtbkqkUvGO8u03YaFyuZMDQs2c
	 kVCEOrrlXinkkKKL0i1jDZRtuVnLLpOlsrGhz60Eof3PyrAZbD0hmPfK8VOd1FjSyU
	 C8ADlC7I6sCP+6ij2+O2X5HdFHhS8RvEwM3kBVrY=
Received: from localhost.localdomain ([1.193.37.112])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 8B7A903F; Fri, 17 Jul 2026 11:34:55 +0800
X-QQ-mid: xmsmtpt1784259295t27j7zgdp
Message-ID: <tencent_2F027EB83F48459E115634898CE03EE35509@qq.com>
X-QQ-XMAILINFO: MqswyhUqVe0CJQT7kftHuTa2cHCpnBvfPuwVKMEEwYl4NtHwyhexDHcV40d2yn
	 BE+2CuZzj7ZJ0GM9/hAX62T7VuTttc/McsXXmLSMwg15ZsEcHusnWrnvs5rUf98wHz502thuMXrS
	 xtH0BfkpNky4STvdX7n20wd803UzZzA7wMlzK00c3chPiFjAuRcj9Bm6aX+LKuqqQr1KSXN8m0mJ
	 ldcLymfzpuQQqSh5GAuZOhp0aLpnJsdS71Kw4pmXtUWfG3+3BTWmDq621ZLLPgqUxTjMt+5lts7e
	 M+Z1X4Xi3aeWVpRh4qDXz6Zc0/73DEtqfqO4BHgz5B8+/2TMWaG6J8jgQfaz5IU4ue4+nbT2kPXf
	 2+buM9cvdqzYq77x+iqDOAZRWukdpfnglbakvpmVXTDgHS1Z9EmElnT66hq5JsBm7fXDpHPywLWp
	 E2Y5k4dI5TBKswS0Rho6y57S+xNebhEek3A9FLS+0c0y2qeVasFwM8uKdgJzRxANUOkOGVlugD/U
	 TPCd9z39gEBH2vbMYzcmbkfrcbnCoWh1dLFLHt5c+WVp2n3Br3M74CVj/O53Oc6iz/VfC9JqNta8
	 56WQbms6iINP5tqqPRb4H89QN/DgJh77KEplu5GkJzSB3msihz7p2IbhuYm4J+Q4BdtXGw2O+Hhr
	 MOjY3XBJ1KuqTO5x+zcJ3zyHefNCvlK5JLIIbKYMfVB+hcwTwcee7zqsEkc82ce01RVFy3GcNese
	 D7xazF1r5PcitucYtIWUmtrEMGUMos01KQPhH0KCuRewPL/XVTSQd4sPTGkQ3aaJw0XTL3xeXb3y
	 bmA4nSBPcVMj7Sy3q2LldAYFCt1EDw7LSZx5QfQbPsSD4T7GpBax8dTDr1IrmEXW20vaSjmXaoXE
	 dEFq2uYox4fOUu506+o7aD7B3kESdN+pLhEsAJQ98puWFSC1JnByTtzSMDiuOezvBDE9y5fNXwGu
	 HWlgg0DdPwl+SmkEfcuca4aajOVGrMVLa2MrOnf4eLG+EAQVyfkPc8PtUUWXFJO86B79TrQJWIl/
	 uNXX0gSK6cttoNCbOffpIruGm8VFVVUSUm4wDiDQ==
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: 303146950@qq.com
To: mwilck@suse.com
Cc: 303146950@qq.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	kouwenqi@kylinos.cn
Subject: [PATCH v4] kpartx: fix crash and truncated device creation with long -p delimiter
Date: Fri, 17 Jul 2026 11:34:43 +0800
X-OQ-MSGID: <20260717033443.2997-1-303146950@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <9c287af301748a1246a1383ca41109d3f94d1491.camel@suse.com>
References: <9c287af301748a1246a1383ca41109d3f94d1491.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kou Wenqi <kouwenqi@kylinos.cn>

On Thu, 2026-07-16 at 15:49 +0200, mwilck@suse.com wrote:
> Thanks again. This looks quite good. However, what about this?
>
> enum {
>       DFP_DEVICE_CREATE = DM_DEVICE_CREATE,
>       DFP_DEVICE_RELOAD = DM_DEVICE_RELOAD,
>       DFP_ERR = -1,
> };

Good idea. I've defined this enum in kpartx/devmapper.h (which now
also includes <libdevmapper.h> to make the header self-contained),
and dm_find_part() uses these enum values explicitly in all return
statements.

> Then use values of this enum as return values of dm_find_part().
> If it returns DFP_ERR, bail out; otherwise use the return value as
> "op", like this:
>
>         if ((op = dm_find_part(...)) == DFP_ERR)
>                 continue;

Done. In the ADD/UPDATE loops, the return value is assigned directly
to 'op', and DFP_ERR is handled with r++ and continue. In the DELETE
loop, I check against DFP_DEVICE_RELOAD to proceed with removal.

> If you want to be extra careful, you could add something like
> this at the beginning of dm_find_part():
>
> BUILD_BUG_ON(DM_DEVICE_CREATE < 0 || DM_DEVICE_RELOAD < 0);
>
> But I think we can trust that these values will always be positive.

I've omitted this check, as I agree that DM_DEVICE_CREATE and
DM_DEVICE_RELOAD are defined by libdevmapper as positive constants
and are unlikely to change.

Changes since v3:
  - Defined enum { DFP_DEVICE_CREATE, DFP_DEVICE_RELOAD, DFP_ERR }
    in kpartx/devmapper.h
  - dm_find_part() returns enum values explicitly in all return paths
  - Callers assign return value directly to 'op' and check for DFP_ERR
  - kpartx/devmapper.h now includes <libdevmapper.h> directly

Here is the new patch.

When the -p delimiter is long enough to make the formatted partition
name exceed PARTNAME_SIZE (128 bytes), three issues occur:

1. format_partname() fails but snprintf has already written a truncated
   name into the buffer. dm_find_part() returns 0 and the caller
   proceeds to dm_addmap() with the truncated name, creating a device
   that was never intended.

2. dm_find_part() returns early without setting *part_uuid. The
   uninitialized local variable part_uuid then gets passed to
   check_uuid() -> strchr(), causing a SIGSEGV.

3. The callers cannot distinguish between 'partition not found, create
   new' and 'name construction failed' since both return 0.

Fix by:
- Having dm_find_part() return DFP_ERR when format_partname() fails,
  with an error message printed by dm_find_part() itself
- Defining an enum to represent the return values of dm_find_part():

  enum {
      DFP_DEVICE_CREATE = DM_DEVICE_CREATE,
      DFP_DEVICE_RELOAD = DM_DEVICE_RELOAD,
      DFP_ERR = -1
  };

  This enum is placed in kpartx/devmapper.h, which now also includes
  <libdevmapper.h> directly to make the header self-contained.
  dm_find_part() uses these enum values explicitly in all return
  statements.
- In the ADD/UPDATE loops (both main and container), assigning the
  return value directly to 'op' and checking for DFP_ERR to handle
  errors
- In the DELETE loop, checking the return value against
  DFP_DEVICE_RELOAD to proceed with removal, skipping on error or
  not-found
- Initializing part_uuid to NULL in all three partition loop bodies
  (ADD/UPDATE main loop, container partition loop, DELETE loop) so
  that the 'if (part_uuid && uuid)' guard correctly skips the UUID
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
 kpartx/devmapper.c | 17 +++++++++--------
 kpartx/devmapper.h |  9 +++++++++
 kpartx/kpartx.c    | 38 ++++++++++++++++++++++----------------
 3 files changed, 40 insertions(+), 24 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 45dac585..091d2a49 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -644,18 +644,19 @@ int dm_find_part(const char *parent, const char *delim, int part,
 	char dev_t[32];
 
 	if (!format_partname(name, namesiz, parent, delim, part)) {
-		if (verbose)
-			fprintf(stderr, "partname too small\n");
-		return 0;
+		fprintf(stderr, "partition name too long for partition %d\n", part);
+		return DFP_ERR;
 	}
 
 	r = dm_map_present(name, part_uuid);
-	if (r == 1 || parent_uuid == NULL || *parent_uuid == '\0')
-		return r;
+	if (r == 1)
+		return DFP_DEVICE_RELOAD;
+	if (parent_uuid == NULL || *parent_uuid == '\0')
+		return DFP_DEVICE_CREATE;
 
 	uuid = make_prefixed_uuid(part, parent_uuid);
 	if (!uuid)
-		return 0;
+		return DFP_DEVICE_CREATE;
 
 	tmp = dm_find_uuid(uuid);
 	if (tmp == NULL)
@@ -688,14 +689,14 @@ int dm_find_part(const char *parent, const char *delim, int part,
 	if (r == 1) {
 		free(tmp);
 		*part_uuid = uuid;
-		return 1;
+		return DFP_DEVICE_RELOAD;
 	}
 	if (verbose)
 		fprintf(stderr, "renaming %s->%s failed\n", tmp, name);
 out:
 	free(uuid);
 	free(tmp);
-	return r;
+	return DFP_DEVICE_CREATE;
 }
 
 char *nondm_create_uuid(dev_t devt)
diff --git a/kpartx/devmapper.h b/kpartx/devmapper.h
index e4db8621..99bab221 100644
--- a/kpartx/devmapper.h
+++ b/kpartx/devmapper.h
@@ -1,6 +1,8 @@
 #ifndef KPARTX_DEVMAPPER_H_INCLUDED
 #define KPARTX_DEVMAPPER_H_INCLUDED
 
+#include <libdevmapper.h>
+
 #ifdef DM_SUBSYSTEM_UDEV_FLAG0
 #define MPATH_UDEV_RELOAD_FLAG DM_SUBSYSTEM_UDEV_FLAG0
 #else
@@ -18,6 +20,13 @@ dev_t dm_get_first_dep(char *devname);
 char * dm_mapuuid(const char *mapname);
 int dm_devn (const char * mapname, unsigned int *major, unsigned int *minor);
 int dm_remove_partmaps (char * mapname, char *uuid, dev_t devt, int verbose);
+
+enum {
+	DFP_DEVICE_CREATE = DM_DEVICE_CREATE,
+	DFP_DEVICE_RELOAD = DM_DEVICE_RELOAD,
+	DFP_ERR = -1
+};
+
 int dm_find_part(const char *parent, const char *delim, int part,
 		 const char *parent_uuid,
 		 char *name, size_t namesiz, char **part_uuid, int verbose);
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index cfd82128..1a12f55d 100644
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
@@ -454,10 +454,13 @@ main(int argc, char **argv){
 					exit(1);
 				}
 
-				op = (dm_find_part(mapname, delim, j + 1, uuid,
-						   partname, sizeof(partname),
-						   &part_uuid, verbose) ?
-				      DM_DEVICE_RELOAD : DM_DEVICE_CREATE);
+				op = dm_find_part(mapname, delim, j + 1, uuid,
+						  partname, sizeof(partname),
+						  &part_uuid, verbose);
+				if (op == DFP_ERR) {
+					r++;
+					continue;
+				}
 
 				if (part_uuid && uuid) {
 					if (check_uuid(uuid, part_uuid, &reason) != 0) {
@@ -500,7 +503,7 @@ main(int argc, char **argv){
 			d = c;
 			while (c) {
 				for (j = 0; j < n; j++) {
-					char *part_uuid, *reason;
+					char *part_uuid = NULL, *reason;
 					int k = slices[j].container - 1;
 
 					if (slices[j].size == 0)
@@ -526,11 +529,14 @@ main(int argc, char **argv){
 						exit(1);
 					}
 
-					op = (dm_find_part(mapname, delim, j + 1, uuid,
-							   partname,
-							   sizeof(partname),
-							   &part_uuid, verbose) ?
-					      DM_DEVICE_RELOAD : DM_DEVICE_CREATE);
+					op = dm_find_part(mapname, delim, j + 1, uuid,
+							  partname,
+							  sizeof(partname),
+							  &part_uuid, verbose);
+					if (op == DFP_ERR) {
+						r++;
+						continue;
+					}
 
 					if (part_uuid && uuid) {
 						if (check_uuid(uuid, part_uuid, &reason) != 0) {
@@ -570,11 +576,11 @@ main(int argc, char **argv){
 			}
 
 			for (j = MAXSLICES-1; j >= 0; j--) {
-				char *part_uuid, *reason;
-				if (slices[j].size ||
-				    !dm_find_part(mapname, delim, j + 1, uuid,
-						  partname, sizeof(partname),
-						  &part_uuid, verbose))
+				char *part_uuid = NULL, *reason;
+				int res = dm_find_part(mapname, delim, j + 1, uuid,
+							 partname, sizeof(partname),
+							 &part_uuid, verbose);
+				if (slices[j].size || res != DFP_DEVICE_RELOAD)
 					continue;
 
 				if (part_uuid && uuid) {
-- 
2.43.0

