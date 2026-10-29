Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793317977;
	b=gRTRBEoHx1V3St451r8OH7p/mI1ww9mgZqurd2O9VtWreoR6q/jxoFq5IhRr6wy8n7E3
	 l2K9Df/Bo3EV38PQ6PKa6ksPtXVFMesU73JTusmhyVjw9pLDxC8vN2WqXB0nmPleaJZ1m
	 Geu/9CjAcIzj6hyoJqfsizdyBSRksdMR4iDaAopZY3GQMEbbqYvwrpiNDCzh9yC133rlU
	 9ZWjhh5UE9eIqOCfvFWA7hbdUVvdHjBvD/Iph7PFDZ7zHFXNRpDIon5WZR07Th7mIcgZG
	 pNnmzknIY4+HbCG2//jmXso6ciFVgBwZ3/KCYi0fTBzV4Wyps8Z6qpgRJQ8dWRSzy3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793317977;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vXCvKg4re/9m0Z8jpb6CekF6WGMDsjgrY0PmFy2B4lI=;
	b=Ej+Jw7NZLl2gqGpPMV64l53+E4ma2Lj99BM4El0P8TVL42fEj7EwlNArJ4zjOeMA9xHT
	 +AS7lOjZCIZ67nMU0YZIYSsneVuynxVGbShCNw5AMgqZzQ+PYndrgGZscWH1ZWrn69M5Q
	 LB0j1s74wj6oAqWrKn41wshumv01BeBWOVbLGYqfcRqvNqwF+yMLdYyyz6tS1QiQiLYj8
	 6V7ItiAgYigFKq17yRZZ6Y0bxElF7C8v0oOQwtjvfgWCdCD58q4YXAh8gGAVQ2JM827RC
	 YU2wFHqt6BhK5cTVBBrvD6S8G1PnWBTOediBInEEcQGXWd8tcXjdf8/1LZkrCxmpUEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=HJsnLBFC;
	arc=none smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EC8606A31E
	for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 23:52:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0EC8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=HJsnLBFC
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-3282db206d3so418324eec.0
        for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 16:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793317976; x=1793922776; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vXCvKg4re/9m0Z8jpb6CekF6WGMDsjgrY0PmFy2B4lI=;
        b=HJsnLBFCqOtaEyc0yyz9zx2YvBshB4Kw7+WY69HT7rxdkNmkkJizxX+JHB8pTo1L5a
         nd/fEvRV81n3xj6NF9O2JzFE8XP+DtJbJCBYbzjaGOvIL/yGXhjQy9PRtcE5WedPcz3P
         332aXKRB5qcTLsdpybLrTmpxhFRVmpnPjAb/jm/rnm+pakBJXph1wlJxmEmEFKs49UNQ
         Z45ZUF76MtmTW+MvXtXYtKzhjvoROSm1BBxe2ph0o7DkwF7/VAc2ESxmvB/yKIx3vlNx
         1uj7NmEAAdIBBrnAvTVBlzb+NVBJnZS4EllN1UkNViT6wNMj1I+tJC1IGcjSYG6/RuvH
         FHRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793317976; x=1793922776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vXCvKg4re/9m0Z8jpb6CekF6WGMDsjgrY0PmFy2B4lI=;
        b=cTICVa/6+SAQvx4ObfMD9lJ/dlznd8aoo6tseKcv9oYMmdWjCQ1PMBSGi+jDDcOdbp
         FdLWrtnsQyod6Xc1rso/U6298RcEjvX7mxxf5scxhny5D4WZebLfCO1D9MBKeIczRBeJ
         smfoPBRm4Djnio//IQ4yGgv8PBINeI5/tq7Mpb7CW+7xOBVKbqm/Ieyt7VNGoz3r3AGY
         JQQ5Re9DmY4c2XPu2SyJACdlZ6aBM7LkxIUbvywyTmwofB22GwUaETTzuEdtfO34FFt8
         PcDZjT5TY0Tq8anFHmwYVtOD2X2c0H5psBFJEEvNG/UE8R2K/5YNmts9/NalYU8/gkDv
         AsVA==
X-Gm-Message-State: AFq9FYJjeDJe/fl5djGE599W2TO/rkd7zv2v0uw0RSkMcP4f0+0muH6n
	DRc+0rIz95X7BqSvI90Skq9S/81yQlPHRZhpYQBRsbC3PZqSzlEd7JjjQ0Wc8jYtDMp7GrTVI53
	gS5d7EJYmGdUqCgSfvTA4CxBG+NpHnfhPaHHPa+aXAj0v1AaImbz/No11P20inQQDnmiHeRRhnr
	pSFAvJVi7ZfI49jmFfZmyFknRWUcirjUwA7GUZMnhfTjo53uc=
X-Gm-Gg: AYBFou0F/l6rZKwmP4pnfbw5YldGQe0h+rYvoFEiYKJ3Fg45HRDW8M08iebZrD8L7sr
	0ieodBjbEC7GN0Y8fxL3JUY9nAgeoFpNx+dBIRczW12HqTI9GCj9KEspkqeuiOyXHskXlF/z8Wu
	4KdSU16rNCcalMAJ62a9QnWKJY72pOeFEmIzpXmTuPGVBw/Rgr1q9FqNxnqNFa0qag9cluOcR1H
	qAM6oloJ3k/FdlwpUkTyyxTVrhv9mrpG9c6fQcME5GDWlGMnP5JwmT+yOxO8A8hKSTZkC86ThUO
	RCYKFG45ilNYAx/kSs24lEHov+g2dVjK3G7bK1f4uUdn9pafaSg95aFjfXRM6AZjPbGltpf6ZTE
	nnCPAXiMoTqBDQPqPCRzt00vJ4wLFMrSdRUsT1LoXTUHAWVgrgCzvrygIiAtmTBTXreJEi0FaTq
	oG27wtNRCPpA1e3XDBvkDxtPQAJ7hBVcgCBPElZahHhXJOLq3zSn/DOPhyvXBh/rb3p+eF97qPO
	+pUjA7rRNrA7c4XeHCwfoLcBea4reGeDV8VaxHuclX7wvrkfWHRPUX9Ozzb8SWkpBKiJVXcF6Hx
	YKRg/1atH2AOChkrjGrMZ3iV5cbGIxIhB5LX7w8k7kOkNSi8wC4s3fyXvtoVzYMAANpIx5WNmX2
	iAgLWe7UYBhN26CMgXuDs5nxqHO3IJW/zf+1MCvdsaC6xilmHWF8Q2mNKs2IR1mIkD6/ZAr9owj
	Der2dU8hPO6MFQ7Gjmxa6fwPFX
X-Received: by 2002:a05:7301:152f:b0:36a:12c1:3adb with SMTP id 5a478bee46e88-36a42397b33mr1063603eec.20.1793317975761;
        Thu, 29 Oct 2026 16:52:55 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a426681aesm2269132eec.1.2026.10.29.16.52.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 29 Oct 2026 16:52:55 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v2 1/1] multipathd: verify udev WWIDs with the device before moving paths
Date: Thu, 29 Oct 2026 16:52:41 -0700
Message-ID: <20261029235241.97614-2-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029235241.97614-1-brian@purestorage.com>
References: <20261029235241.97614-1-brian@purestorage.com>
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
the new WWID. Nothing checks the new value against the device itself;
recheck_wwid only covers paths coming back up in the checker and
"multipathd add path". If udev reports the wrong WWID, or the uevent is
stale by the time it is processed, the path goes into the map of a
different LUN and I/O for one LUN is silently sent to another.

Use SG_IO to read VPD page 0x83 from the device in two places, for
paths where can_recheck_wwid() is true:

- In uev_update_path(), if the device still reports the cached WWID,
  ignore the udev value and leave the path where it is.

- In ev_add_path(), when a path is being re-added because its udev
  data was missing or changed, refuse to add it if the device doesn't
  confirm its WWID. The path is orphaned, its WWID is cleared and it
  is marked INIT_MISSING_UDEV, so the checker retriggers udev (bounded
  by retrigger_tries) and the path is re-added from fresh data.

To tell re-adds from ordinary adds, turn the need_do_map argument of
uev_add_path() and ev_add_path() into enum path_add_mode, with a new
PATH_ADD_REINIT value that behaves like PATH_ADD_MAP and also requests
the WWID check. Ordinary adds are unchanged and never read the WWID
from the device.

If the SG_IO read fails, behavior is unchanged.

Split the SG_IO read out of check_path_wwid_change() into
get_sgio_wwid() so all the checks share it.

Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 multipathd/cli_handlers.c |  2 +-
 multipathd/main.c         | 79 +++++++++++++++++++++++++++++++--------
 multipathd/main.h         | 12 +++++-
 3 files changed, 76 insertions(+), 17 deletions(-)

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
index 9bce4d6b..57a3dd9e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1086,14 +1086,16 @@ handle_path_wwid_change(struct path *pp, struct vectors *vecs)
 	return removed;
 }
 
-bool
-check_path_wwid_change(struct path *pp)
+/*
+ * Read the WWID directly from the device with SG_IO, bypassing udev
+ * and sysfs. Returns true and fills in wwid on success.
+ */
+static bool get_sgio_wwid(struct path *pp, char *wwid)
 {
-	char wwid[WWID_SIZE];
-	int len = 0;
+	int len;
 	size_t i;
 
-	if (!strlen(pp->wwid))
+	if (pp->fd < 0)
 		return false;
 
 	/* Get the real fresh device wwid by sgio. sysfs still has old
@@ -1111,6 +1113,15 @@ check_path_wwid_change(struct path *pp)
 		/* no-op */
 	wwid[i] = '\0';
 	condlog(4, "%s: Got wwid %s by sgio", pp->dev, wwid);
+	return true;
+}
+
+bool check_path_wwid_change(struct path *pp)
+{
+	char wwid[WWID_SIZE];
+
+	if (!strlen(pp->wwid) || !get_sgio_wwid(pp, wwid))
+		return false;
 
 	if (strncmp(wwid, pp->wwid, WWID_SIZE)) {
 		condlog(0, "%s: wwid '%s' doesn't match wwid '%s' from device",
@@ -1121,6 +1132,24 @@ check_path_wwid_change(struct path *pp)
 	return false;
 }
 
+/*
+ * udev reported a new WWID for a path. Returns true if the device
+ * itself still reports old_wwid, in which case the udev value must
+ * not be trusted.
+ */
+static bool device_kept_wwid(struct path *pp, const char *old_wwid)
+{
+	char wwid[WWID_SIZE];
+
+	if (!can_recheck_wwid(pp) || !get_sgio_wwid(pp, wwid) ||
+	    strncmp(wwid, old_wwid, WWID_SIZE))
+		return false;
+
+	condlog(0, "%s: ignoring wwid '%s' from udev, device still reports '%s'",
+		pp->dev, pp->wwid, wwid);
+	return true;
+}
+
 /*
  * uev_add_path can call uev_update_path, and uev_update_path can call
  * uev_add_path
@@ -1128,7 +1157,8 @@ check_path_wwid_change(struct path *pp)
 static int uev_update_path (struct uevent *uev, struct vectors * vecs);
 
 static int
-uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
+uev_add_path (struct uevent *uev, struct vectors * vecs,
+	      enum path_add_mode mode)
 {
 	struct path *pp;
 	int ret = 0, i;
@@ -1180,7 +1210,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 				     DI_ALL | DI_BLACKLIST);
 			pthread_cleanup_pop(1);
 			if (r == PATHINFO_OK && !prev_mpp)
-				ret = ev_add_path(pp, vecs, need_do_map);
+				ret = ev_add_path(pp, vecs, mode);
 			else if (r == PATHINFO_OK &&
 				 !strncmp(pp->wwid, prev_mpp->wwid, WWID_SIZE)) {
 				/*
@@ -1255,7 +1285,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 		conf = get_multipath_config();
 		pp->checkint = conf->checkint;
 		put_multipath_config(conf);
-		ret = ev_add_path(pp, vecs, need_do_map);
+		ret = ev_add_path(pp, vecs, mode);
 	} else {
 		condlog(0, "%s: failed to store path info, "
 			"dropping event",
@@ -1298,7 +1328,7 @@ sysfs_get_ro (struct path *pp)
  * 1: error
  */
 int
-ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
+ev_add_path (struct path * pp, struct vectors * vecs, enum path_add_mode mode)
 {
 	struct multipath * mpp;
 	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
@@ -1315,6 +1345,21 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 		condlog(0, "%s: failed to get path uid", pp->dev);
 		goto fail; /* leave path added to pathvec */
 	}
+	/*
+	 * This path is being re-added because its udev data was missing or
+	 * changed. The uevent may have been queued long before we got here,
+	 * and adding a path to the map of a different LUN corrupts data, so
+	 * confirm the WWID with the device first. On a mismatch, leave the
+	 * path out and let the checker retrigger udev to get a fresh WWID.
+	 */
+	if (mode == PATH_ADD_REINIT && can_recheck_wwid(pp) &&
+	    check_path_wwid_change(pp)) {
+		condlog(0, "%s: not adding path, wwid '%s' not confirmed by device",
+			pp->dev, pp->wwid);
+		memset(pp->wwid, 0, WWID_SIZE);
+		pp->initialized = INIT_MISSING_UDEV;
+		goto fail;
+	}
 	mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
 	if (mpp && pp->size && mpp->size != pp->size) {
 		condlog(0, "%s: failed to add new path %s, device size mismatch", mpp->alias, pp->dev);
@@ -1375,7 +1420,7 @@ rescan:
 	if (ro == 1)
 		mpp->force_readonly = 1;
 
-	if (!need_do_map)
+	if (mode == PATH_ADD_NO_MAP)
 		return 0;
 
 	if (!dm_map_present(mpp->alias)) {
@@ -1702,6 +1747,10 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			strcpy(pp->wwid, wwid);
 		else if (strlen(wwid) &&
 			 strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
+			if (device_kept_wwid(pp, wwid)) {
+				strcpy(pp->wwid, wwid);
+				goto out;
+			}
 			condlog(0, "%s: path wwid changed from '%s' to '%s'",
 				uev->kernel, wwid, pp->wwid);
 			ev_remove_path(pp, vecs, 1);
@@ -1789,7 +1838,7 @@ out:
 	}
 	/* pp->initialized must not be INIT_PARTIAL if needs_reinit is set */
 	if (needs_reinit)
-		retval = uev_add_path(uev, vecs, 1);
+		retval = uev_add_path(uev, vecs, PATH_ADD_REINIT);
 	return retval;
 }
 
@@ -1905,13 +1954,13 @@ uev_trigger (struct uevent * uev, void * trigger_data)
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
@@ -3015,7 +3064,7 @@ update_uninitialized_path(struct vectors * vecs, struct path * pp)
 		pthread_cleanup_pop(1);
 		/* INIT_OK implies ret == PATHINFO_OK */
 		if (pp->initialized == INIT_OK) {
-			ev_add_path(pp, vecs, 1);
+			ev_add_path(pp, vecs, PATH_ADD_MAP);
 			pp->tick = 1;
 		} else if (ret == PATHINFO_SKIPPED) {
 			int i;
@@ -3036,7 +3085,7 @@ update_uninitialized_path(struct vectors * vecs, struct path * pp)
 					CHECK_PATH_REMOVED :
 					CHECK_PATH_SKIPPED;
 		}
-		ev_add_path(pp, vecs, 1);
+		ev_add_path(pp, vecs, PATH_ADD_MAP);
 		pp->tick = 1;
 	}
 	return CHECK_PATH_CHECKED;
diff --git a/multipathd/main.h b/multipathd/main.h
index b66208ec..34a12ad7 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -36,7 +36,17 @@ enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
 					    unsigned long ms);
 void schedule_reconfigure(enum force_reload_types requested_type);
 int need_to_delay_reconfig (struct vectors *);
-int ev_add_path (struct path *, struct vectors *, int);
+/*
+ * PATH_ADD_REINIT is PATH_ADD_MAP for a path that is being re-added
+ * because its udev data was missing or changed. Its WWID is verified
+ * with the device before the path is put into a map.
+ */
+enum path_add_mode {
+	PATH_ADD_NO_MAP,
+	PATH_ADD_MAP,
+	PATH_ADD_REINIT,
+};
+int ev_add_path (struct path *, struct vectors *, enum path_add_mode);
 int ev_remove_path (struct path *, struct vectors *, int);
 int ev_add_map (char *, const char *, struct vectors *);
 int flush_map(struct multipath *, struct vectors *);
-- 
2.56.0

