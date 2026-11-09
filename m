Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794250574;
	b=CtroyVzPOBtfxTNfRm5PE5fzBLE9pAKbg+tNkwXsCk8gRDeXW9k6XVZ06Vx1hWbbp+vT
	 FBcLG/fusjUmatwvfpqyDuTAqb4tlTveDm+mrrGYzVZEWT6cHc3NKR8vPUDwEp48isZ+T
	 U7NsHZJ3e93l324DwEXs0566DwkURXhQrQkxZPsbIlRrmN+IVSSTk+zC8DsvVz0BvrTG7
	 BxZmQtuX4VXdx/dWb2Ebp8GzFCn0Kms/3buIIraQ6xk2Tii5BfjciXVg/t3Qf5zpDGSxt
	 WJ1mg/HNkl64lSqVblgzNgAhaI6H+PrKXhqLM6xm3T2JgvcKqGavHP8pMGkAoIsIfZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794250574;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=A1yzfwyHhoqa9+KdMn1rp/XyKMsknawK4FJ8kokRxCw=;
	b=Tc5riVR8/DB4tH9yNfcDu7GyKMhuDR3OXdvuI4J4hM2/NAyV8+N2LphZoAITYpglkExU
	 IZXt2ehieALFUoWfvodA3r/Ls5tBvktyjAZ+qvns9PiJy6Y9UUMCXaCS/5unUQf8C4/nG
	 0FyMJS+GsnKT5HCFf/gEwT4ybdo24es3XiHt3H/ZGZu9xX/zsxf0sMSZXiCTcN4v0+X+9
	 sMj1TsLdnMBPC+xrr1vze2qBxYHF50KiLrCEmbIpi9C+IQg+LjwbyPf3HN7t/HxCmP6C5
	 ZhH4PWJBsqZFlfNtZaSDyw3I34w8j4Vtxx0ZC2uEJNu/IS9syebBLV0TtvuanBVOkoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b="UJc/0+RS";
	arc=none smtp.remote-ip=74.125.82.43
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417BF606A326
	for <dm-devel@lists.linux.dev>; Mon,  9 Nov 2026 18:56:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 417BF606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=UJc/0+RS
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1a3c08d6928so2166801c88.0
        for <dm-devel@lists.linux.dev>; Mon, 09 Nov 2026 10:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1794250572; x=1794855372; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A1yzfwyHhoqa9+KdMn1rp/XyKMsknawK4FJ8kokRxCw=;
        b=UJc/0+RS1xaB3UNsDtDYTglIEPhY7BPi1zOSCuv2UYf60M0DWpGaQF7yFc630BSjeh
         6MPVCTPfGKjKppdAz8KkIJd0IM2hhDaGJq0gZTrRj8UgdhPvrZnXquIuLevMwHv0bsfG
         waAyzfzt7F0hNvERsUlk6nvz3h0+e5FQsfMcE2ptWep9qMI6MzUxKlW/f2OKSNjUkfIW
         vUBSHk4qSBlXdZHqa+NuZRemtmbSRaH68sRwsgjWHuN83z2TUlX5HfnEH9CTzWvJz7Ky
         7dGHuVLB+TfLU5CKI9RuzTCbChFKIDzRm5t4FgFEHR82CJ/0JxoTG3ZypSOW/Rx0SaC9
         iPHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794250572; x=1794855372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=A1yzfwyHhoqa9+KdMn1rp/XyKMsknawK4FJ8kokRxCw=;
        b=RJ7ZGENnBP4OqNFHBQPHJYJVNiJPPJ/8EXCMEER/+xNQnV6mzUvYmsBm1mq536o5U6
         Uu/eOFM1SqLsKxZKX4aJXDifpSrdV8n6Ax/C/1btyeXQ4nSkzXNPlAa/kmatYtPxnEPU
         b16HtjuKjcBE/1+bGlE/eGAOMowR97rz5Hmjkc4pHegVa69MH8D6dv1DLPzhA1O744UK
         ul/YCLOuIqy8alEnUkr+jKGbfwiQGF7nQjdoOpHnDZZYrAn03dAqaMEyBTtljcq8ll8J
         b9eJCmdK4CLa59oh4J0TQ03L8K0QgKlgm6PrWk/KzYVi9beMlGJe0i1ICNf+j9+7WGO+
         q5bQ==
X-Gm-Message-State: APuU4Z+6dCuJLrQGqTbxE0Be1pelo9siB00+MB1j194Wxy7OEk9CVAZ5
	vQ7o+I08SfFfBLQzY+1DQfcRKYuokN+1cC4gTIQdwPEkhxq9ymkP0z/l2CAizP3u67KJ9rc/d5Q
	9+I8VZeqkmSs+NIBr58J590NndJVLTipNJSeQb4V8P35YONAWutWLIjssxAIh4+Q2j+YHJlyORk
	vyj+stacJUZ5A/DJi2m/xPQK4ULfPNfyvNbZKFLnGpz5+XCkA=
X-Gm-Gg: AYBFou1NtkvTeJGyGwTh6I11FIbjH974eTmSn/wK81B2St5Uzv+gGrx5Ra/7unVJwt0
	/sCZvn2nyLO91PCmrCY9g71IxQ1S8+CCKkszx7LkysJagGWBSfo4Co0X92xOMHVLcdrECHeQ9r2
	l2p4ePbb1S0kHHVYXLi7MxLFpY52CP3Y6uyU9OfeY2PZnxig97q7N9X4lmlcMBQf+Ikjz4cmvi1
	2w/Ql35fK75d+5Ucm1ivh+p/P9I7ugFCfPFCEhY26A2TauZe2I5cEfJ0d1RVH1WjaVsAPJzaPRq
	xRIw7TzeznfnVTObTxunxKlUxg7kGHMEYxt3u1cv9Y4Gak6/unyZ1I/yp5jpCkVuZ231P11j3Pt
	5D/v2id+P/uSpGru2pjmN+gTbPHgzMHPEZ1egh7c4cuM/WQsKgfXchRm0frD+eYRkIf17JhZJXk
	8ROh9oN7lcKBYVrWyL9HqyFfpytSD+elax8EoUdHy9uoqDDn3DEIAiWqynpXJXw1D/kA24YCd24
	UX9LwxQzqWcPHKQKCPL2aaqfQclo84BLWOnpv6iABlYi42e6Cq4gNjRnj7EMHsTGhYL5kcUienu
	1rTAaWhNmEi2Fkv6gKor0uSFp4c3cOJQnNR8fbx1vUs0gVcpzZOFP64xK/fLgbMicOOTBMEXyvg
	puJl5mwTSdSVRLpwjt/erjXbdW6zWPn4CI/vx2ISjAoaUfe5BkmP4DaZAURCQt3AZKI8LANtkE5
	MGVL2MPncq0FuULqz/hUj9Y9wi
X-Received: by 2002:a05:701b:4354:b0:1b2:4b42:1870 with SMTP id a92af1059eb24-1b3b60122e6mr449980c88.31.1794250572079;
        Mon, 09 Nov 2026 10:56:12 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b11346sm952266c88.7.2026.11.09.10.56.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 10:56:11 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	mwilck@suse.com,
	christophe.varoqui@opensvc.com,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v3 1/1] multipathd: check re-added paths' WWIDs against sysfs
Date: Mon,  9 Nov 2026 10:55:55 -0800
Message-ID: <20261109185556.27139-2-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261109185556.27139-1-brian@purestorage.com>
References: <20261109185556.27139-1-brian@purestorage.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

multipathd takes a path's WWID from udev. When a change uevent reports
a different WWID, uev_update_path() removes the path from its map and
re-adds it through uev_add_path(), which places it in whatever map owns
the new WWID. If the udev value is wrong, or the uevent is stale by the
time it is processed, the path goes into the map of a different LUN and
I/O for one LUN is silently sent to another.

Before such a re-add puts the path into a map, compare its WWID with
one built from the VPD page 0x83 data the kernel caches in sysfs. If
they differ, leave the path out of the map: orphan it, clear its WWID
and mark it INIT_MISSING_UDEV, so the checker retriggers udev and the
path is re-added from fresh data. This reads no data from the device,
so it can't hang. The check only runs for paths where
can_recheck_wwid() is true, where the udev WWID and the one built from
sysfs come from the same designator selection.

To tell re-adds from ordinary adds, turn the need_do_map argument of
uev_add_path() and ev_add_path() into enum path_add_mode, with a new
PATH_ADD_REINIT value that behaves like PATH_ADD_MAP and is passed only
for the re-add at the end of uev_update_path(). Ordinary adds are
unchanged.

Add get_sysfs_wwid() to libmultipath. It shares get_vpd_uid() and the
WWID clean-up in get_uid() with the existing sysfs fallback, so both
build the WWID the same way.

Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 libmultipath/discovery.c          | 42 ++++++++++++++++++++++---------
 libmultipath/discovery.h          |  1 +
 libmultipath/libmultipath.version |  5 ++++
 multipathd/cli_handlers.c         |  2 +-
 multipathd/main.c                 | 39 ++++++++++++++++++++--------
 multipathd/main.h                 | 12 ++++++++-
 6 files changed, 76 insertions(+), 25 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 344da19c..62286928 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2180,8 +2180,7 @@ get_udev_uid(struct path * pp, const char *uid_attribute, struct udev_device *ud
 	return len;
 }
 
-static int
-get_vpd_uid(struct path * pp)
+static int get_vpd_uid(const struct path *pp, char *wwid, int len)
 {
 	struct udev_device *parent = pp->udev;
 
@@ -2195,7 +2194,7 @@ get_vpd_uid(struct path * pp)
 	if (!parent)
 		return -EINVAL;
 
-	return get_vpd_sysfs(parent, 0x83, pp->wwid, WWID_SIZE);
+	return get_vpd_sysfs(parent, 0x83, wwid, len);
 }
 
 /* based on code from s390-tools/dasdinfo/dasdinfo.c */
@@ -2236,7 +2235,7 @@ static ssize_t uid_fallback(struct path *pp, int path_state,
 		len = dasd_get_uid(pp);
 		*origin = "sysfs";
 	} else if (pp->bus == SYSFS_BUS_SCSI) {
-		len = get_vpd_uid(pp);
+		len = get_vpd_uid(pp, pp->wwid, WWID_SIZE);
 		*origin = "sysfs";
 		if (len < 0 && path_state == PATH_UP) {
 			condlog(1, "%s: failed to get sysfs uid: %s",
@@ -2299,6 +2298,17 @@ bool can_recheck_wwid(const struct path *pp)
 	return (pp->bus == SYSFS_BUS_SCSI && has_uid_fallback(pp));
 }
 
+static void tidy_wwid(char *wwid)
+{
+	size_t i;
+
+	strchop(wwid);
+	for (i = 0; wwid[i] != '\0'; i++) {
+		if (wwid[i] == '/')
+			wwid[i] = '_';
+	}
+}
+
 int
 get_uid (struct path * pp, int path_state, struct udev_device *udev,
 	 int allow_fallback)
@@ -2307,7 +2317,6 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev,
 	ssize_t len = 0;
 	struct config *conf;
 	int used_fallback = 0;
-	size_t i;
 
 	if (!pp->uid_attribute) {
 		conf = get_multipath_config();
@@ -2347,18 +2356,27 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev,
 			pp->wwid);
 		memset(pp->wwid, 0x0, WWID_SIZE);
 		return 1;
-	} else {
-		strchop(pp->wwid);
-		for (i = 0; pp->wwid[i] != '\0'; i++) {
-			if (pp->wwid[i] == '/')
-				pp->wwid[i] = '_';
-		}
-	}
+	} else
+		tidy_wwid(pp->wwid);
 	condlog((used_fallback)? 1 : 3, "%s: uid = %s (%s)", pp->dev,
 		*pp->wwid == '\0' ? "<empty>" : pp->wwid, origin);
 	return 0;
 }
 
+/*
+ * Get the WWID of a SCSI path from the VPD page 0x83 data the kernel
+ * caches in sysfs, built the same way as get_uid() does when it falls
+ * back to sysfs. This does no I/O on the device. It only matches the
+ * udev WWID if can_recheck_wwid(pp) is true.
+ */
+bool get_sysfs_wwid(const struct path *pp, char *wwid)
+{
+	if (pp->bus != SYSFS_BUS_SCSI || get_vpd_uid(pp, wwid, WWID_SIZE) <= 0)
+		return false;
+	tidy_wwid(wwid);
+	return true;
+}
+
 int pathinfo(struct path *pp, struct config *conf, int mask)
 {
 	int path_state;
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 2ef1d94b..e433a6dd 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -56,6 +56,7 @@ ssize_t sysfs_get_inquiry(struct udev_device *udev,
 int sysfs_get_asymmetric_access_state(struct path *pp,
 				      char *buff, int buflen);
 bool can_recheck_wwid(const struct path *pp);
+bool get_sysfs_wwid(const struct path *pp, char *wwid);
 int get_uid(struct path * pp, int path_state, struct udev_device *udev,
 	    int allow_fallback);
 bool is_vpd_page_supported(int fd, int pg);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index f631f453..4f8e1fd5 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -246,3 +246,8 @@ local:
 	*;
 };
 
+LIBMULTIPATH_34.1.0 {
+global:
+	get_sysfs_wwid;
+} LIBMULTIPATH_34.0.0;
+
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index f5a13c46..9b4a04c2 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -673,7 +673,7 @@ cli_add_path (void *v, struct strbuf *reply, void *data)
 			return 1;
 		}
 	}
-	return ev_add_path(pp, vecs, 1);
+	return ev_add_path(pp, vecs, PATH_ADD_MAP);
 blacklisted:
 	append_strbuf_str(reply, "blacklisted\n");
 	condlog(2, "%s: path blacklisted", param);
diff --git a/multipathd/main.c b/multipathd/main.c
index 9bce4d6b..45ba6aff 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1128,7 +1128,7 @@ check_path_wwid_change(struct path *pp)
 static int uev_update_path (struct uevent *uev, struct vectors * vecs);
 
 static int
-uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
+uev_add_path(struct uevent *uev, struct vectors *vecs, enum path_add_mode mode)
 {
 	struct path *pp;
 	int ret = 0, i;
@@ -1180,7 +1180,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 				     DI_ALL | DI_BLACKLIST);
 			pthread_cleanup_pop(1);
 			if (r == PATHINFO_OK && !prev_mpp)
-				ret = ev_add_path(pp, vecs, need_do_map);
+				ret = ev_add_path(pp, vecs, mode);
 			else if (r == PATHINFO_OK &&
 				 !strncmp(pp->wwid, prev_mpp->wwid, WWID_SIZE)) {
 				/*
@@ -1255,7 +1255,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 		conf = get_multipath_config();
 		pp->checkint = conf->checkint;
 		put_multipath_config(conf);
-		ret = ev_add_path(pp, vecs, need_do_map);
+		ret = ev_add_path(pp, vecs, mode);
 	} else {
 		condlog(0, "%s: failed to store path info, "
 			"dropping event",
@@ -1297,10 +1297,10 @@ sysfs_get_ro (struct path *pp)
  * 0: added
  * 1: error
  */
-int
-ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
+int ev_add_path(struct path *pp, struct vectors *vecs, enum path_add_mode mode)
 {
 	struct multipath * mpp;
+	char sysfs_wwid[WWID_SIZE];
 	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
 	int retries = 3;
 	int start_waiter = 0;
@@ -1315,6 +1315,23 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 		condlog(0, "%s: failed to get path uid", pp->dev);
 		goto fail; /* leave path added to pathvec */
 	}
+	/*
+	 * This path is being re-added because its udev data was missing or
+	 * changed. The uevent may have been queued long before we got here,
+	 * and adding a path to the map of a different LUN corrupts data, so
+	 * check the WWID against the VPD data the kernel has cached in
+	 * sysfs. On a mismatch, leave the path out and let the checker
+	 * retrigger udev to get a fresh WWID.
+	 */
+	if (mode == PATH_ADD_REINIT && can_recheck_wwid(pp) &&
+	    get_sysfs_wwid(pp, sysfs_wwid) &&
+	    strncmp(sysfs_wwid, pp->wwid, WWID_SIZE)) {
+		condlog(0, "%s: not adding path, wwid '%s' from udev doesn't match '%s' from sysfs",
+			pp->dev, pp->wwid, sysfs_wwid);
+		memset(pp->wwid, 0, WWID_SIZE);
+		pp->initialized = INIT_MISSING_UDEV;
+		goto fail;
+	}
 	mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
 	if (mpp && pp->size && mpp->size != pp->size) {
 		condlog(0, "%s: failed to add new path %s, device size mismatch", mpp->alias, pp->dev);
@@ -1375,7 +1392,7 @@ rescan:
 	if (ro == 1)
 		mpp->force_readonly = 1;
 
-	if (!need_do_map)
+	if (mode == PATH_ADD_NO_MAP)
 		return 0;
 
 	if (!dm_map_present(mpp->alias)) {
@@ -1789,7 +1806,7 @@ out:
 	}
 	/* pp->initialized must not be INIT_PARTIAL if needs_reinit is set */
 	if (needs_reinit)
-		retval = uev_add_path(uev, vecs, 1);
+		retval = uev_add_path(uev, vecs, PATH_ADD_REINIT);
 	return retval;
 }
 
@@ -1905,13 +1922,13 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	 */
 	list_for_each_entry_safe(merge_uev, tmp, &uev->merge_node, node) {
 		if (!strncmp(merge_uev->action, "add", 3))
-			r += uev_add_path(merge_uev, vecs, 0);
+			r += uev_add_path(merge_uev, vecs, PATH_ADD_NO_MAP);
 		if (!strncmp(merge_uev->action, "remove", 6))
 			r += uev_remove_path(merge_uev, vecs, 0);
 	}
 
 	if (!strncmp(uev->action, "add", 3))
-		r += uev_add_path(uev, vecs, 1);
+		r += uev_add_path(uev, vecs, PATH_ADD_MAP);
 	if (!strncmp(uev->action, "remove", 6))
 		r += uev_remove_path(uev, vecs, 1);
 	if (!strncmp(uev->action, "change", 6))
@@ -3015,7 +3032,7 @@ update_uninitialized_path(struct vectors * vecs, struct path * pp)
 		pthread_cleanup_pop(1);
 		/* INIT_OK implies ret == PATHINFO_OK */
 		if (pp->initialized == INIT_OK) {
-			ev_add_path(pp, vecs, 1);
+			ev_add_path(pp, vecs, PATH_ADD_MAP);
 			pp->tick = 1;
 		} else if (ret == PATHINFO_SKIPPED) {
 			int i;
@@ -3036,7 +3053,7 @@ update_uninitialized_path(struct vectors * vecs, struct path * pp)
 					CHECK_PATH_REMOVED :
 					CHECK_PATH_SKIPPED;
 		}
-		ev_add_path(pp, vecs, 1);
+		ev_add_path(pp, vecs, PATH_ADD_MAP);
 		pp->tick = 1;
 	}
 	return CHECK_PATH_CHECKED;
diff --git a/multipathd/main.h b/multipathd/main.h
index b66208ec..d3826a89 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -36,7 +36,17 @@ enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
 					    unsigned long ms);
 void schedule_reconfigure(enum force_reload_types requested_type);
 int need_to_delay_reconfig (struct vectors *);
-int ev_add_path (struct path *, struct vectors *, int);
+/*
+ * PATH_ADD_REINIT is PATH_ADD_MAP for a path that is being re-added
+ * because its udev data was missing or changed. Its WWID is checked
+ * against sysfs before the path is put into a map.
+ */
+enum path_add_mode {
+	PATH_ADD_NO_MAP,
+	PATH_ADD_MAP,
+	PATH_ADD_REINIT,
+};
+int ev_add_path(struct path *, struct vectors *, enum path_add_mode);
 int ev_remove_path (struct path *, struct vectors *, int);
 int ev_add_map (char *, const char *, struct vectors *);
 int flush_map(struct multipath *, struct vectors *);
-- 
2.56.0

