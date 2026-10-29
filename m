Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793296662;
	b=GWAd+vIkB292UNPjDCwMc+X9r3xfiuBrxzYW+Om9T1ex5Hu+VXwJOkGdtKxnUuIEnG8A
	 vO6B8NFFmUed0a7MccO0HkHmiv5pSKiDl1Lvf6JSrNNVBLrY/NLbXThUIZrZsKUGo3PYC
	 iXStE0bzb/RvZJSe/Tzw5GTUGxNWWnv6BAspKxxlprM8xjIy4GEi9Y0o+rIHHeD+sAH/Z
	 0MQBTSDCz3BVze7rX2PXpqC9gHJingke8TOTlk7fIqLn7vyWOO365385baH2PT8FIDhf/
	 5iENd5BodZKqdjIf2T0sVosCf4fZQaDSP2DvsPf/HPUpc178p6BXWTPNoXf8vxtv7OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793296662;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=y1m1nVWyVuWg05kl0Vni64SJYo/NMqkScuPWlcmu1ko=;
	b=OWcCmBYj5uGbOf4QsEgKu1eZIc0ulGkBCy6haEwy9UDFk0lHbaTyiVLD6okrfYF1fmKY
	 b4BruivNcQZRNNmws4VPjmUR5W/0R13JvaqIbdJ/DbxYQ5KP3Z0/AZ/n3CtQHxkgLc3FC
	 qz9A9lBOWmisFqDGF79fOuQU8Zybvoycn5E0aQ8a/8TQCYq+RGfvDEyHHfeNE852C73TM
	 aYUGiR/D8reGxnG6czJmepYi9YuRXi7uZMAHtBrBeXe4wEZMjkAmYjzVmPbFx3GdvjbHL
	 SFgFNtQkETN4F3Zde5x1WuziI6BluRInQyv8ml7PlTHkeiWG+haSi6pFbE3WBJBzfSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=AtiAzdDW;
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7AC606A324
	for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 17:57:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E7AC606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=AtiAzdDW
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-18cdcfc05ffso3342798c88.1
        for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 10:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793296661; x=1793901461; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y1m1nVWyVuWg05kl0Vni64SJYo/NMqkScuPWlcmu1ko=;
        b=AtiAzdDWFqlThqZ41T9ocPXjTc3CVAbRTnpGHW51SgLfDAtqHzFS+jYVwsq2R2WE9H
         05aJrJ2TbpWNBgcOWFNotEtQQdrVMWLEamiYz+wylip/m1D4lNj9kxTVj8L0s+iBUaat
         RGud2OU3l6ZvTVrIRjp3JcjmBuFPBcdzDLUDI0yd+hZJasFmbX1W+WshGz0hTiG/twlT
         u8cN/VGErP8s00Kes7OtzEXaHShMUtv/zrUIT6D6+HyLlygC9yMEKRX0CTSGQueObgXk
         5CJqFF6lexLIk0FMzDWscPlWps2HY6qltlg3473+QWO1WL1C/VjgUy6Kl/zpyiWPgIcQ
         80MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793296661; x=1793901461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y1m1nVWyVuWg05kl0Vni64SJYo/NMqkScuPWlcmu1ko=;
        b=W3pBDfs7o8Hv9qEdbBY+6BXhNSE66jW6qx0+eFSYPIR1mcIrIJM4qBey0kKvGLSsCm
         WGUNSVhfRSqWrx843rt6XKUQXzxjGxFFY2UUBoSlInYur56CJrMLmYLhb6H3MXQqDgTq
         eoUVKMRopOnl1BpfxdVTNN4Vu1GFz/ukE3OEruVB8Mq4Hpybd+Bp9RXhBDXrUt2ZxN4q
         VNBIusjvLQou2QbKo5Cxp7v/iM2bz6BdHF7PZthybs1IwytQLBJ5wz6cCVZtrszxPU0G
         KoBX9wWFNHlecsK9H9IJSwP0QELNk3unsojT+xsMl2r6Q8mr6Z42djH0moWPHUAvfTWP
         fPhw==
X-Gm-Message-State: AFq9FYKKNxz+jLOEKKJIngEVVmBqESYyDFZmAax2vEyN2izPd80XBgQz
	iBCjrhPTc1YX+8ligQToFqB6h2PtgLt2FDEck1QXGyQVoSRrrmh+lP6HuHBT8REgfcng+SffdXK
	rRpuw0MKSQP3LgOfhHWcbejwkbQJS+hsSzntDRi8eKEFwpD6mAsAoFy7xuqKrJOrChgTK1AXhVE
	0/6YQncJ6Kw5EFBsfIu+y1uTLTQ2qyUwm8t4PhhYnRuHJgnPI=
X-Gm-Gg: AYBFou1sF5k5GDoN8N/Ak0NTfx2IVDUXpRtP1dQBnNPySuMB5vJDiY/WK8OkaQTEBnz
	ywMCfSSczD8TRuNRAIeIqaYs1W2adW1KYbRYbEtU8AVH3mTX9aTNpKyFug9gdqULc7EsnTqUeP6
	sehYXehCRfRkhK8UA5TQWxVLh7wM4aU9ijlVYaEijwdM8axJsaRr+M0j/m1+WUmfl9LBM2ob6Fh
	CEBUFzKWNlZpuMuNpR5dSxcFrizRP2PyZGmkO2e99QfyMGekrzmbaVby3wWvMt+80TQW/trl35Y
	n7WAqibBQxjfe4+kt7/V7/i3rVH5LnBhvUxwRsHbN+GECOHHBrkAPB84XWrzrze+PDbvTRSgRWL
	tPyz325H9SF0v+lA5PFmbF1tTITF/1UyJozvu53UjpIuSVoZwp4Mw2EYThCXXHyJgI4hMlycPpj
	kkwQJ9lX7xLpUIdRRHd5p51wA4izbOJKEMecEMSOyHDq8uNgyHCoHxYoc9p4acKdM82JlWNrp3P
	1RpHcrQCnf3PhjZLtdyhfyDYPQSxQx/d/qzaybLQHgRuN7J1jKjUtQDoc7ZCxS1dHaoYjZqKmFS
	yI1OzJh3iEr7goekiN4nZfUKeB0UbX/3CAfpxU8XdWplnKpCuj5l2wrsGOPEqpucjvaC8i4/M8P
	+r2uZMc4znDMjGzf/2KNZqjx6zsw8A2iqHmRAP20YZ7BzWFaA+IlIDo9UALISiLBOuNqy0bDyiv
	sj4hKIbR8aih0+RdLhianlWYFgPdbRwXk52tR2capzw6ZY4Q==
X-Received: by 2002:a05:7022:b0c6:b0:176:a225:e364 with SMTP id a92af1059eb24-1a6cdf28c7cmr7467497c88.35.1793296660741;
        Thu, 29 Oct 2026 10:57:40 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac13ef1932sm327878c88.2.2026.10.29.10.57.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 29 Oct 2026 10:57:40 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v1 1/1] multipathd: verify udev WWIDs with the device before moving paths
Date: Thu, 29 Oct 2026 10:57:27 -0700
Message-ID: <20261029175727.25457-2-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029175727.25457-1-brian@purestorage.com>
References: <20261029175727.25457-1-brian@purestorage.com>
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

- In ev_add_path(), refuse to add a path whose WWID the device doesn't
  confirm. The path is orphaned, its WWID is cleared and it is marked
  INIT_MISSING_UDEV, so the checker retriggers udev (bounded by
  retrigger_tries) and the path is re-added from fresh data.

ev_add_path() is the common point for uevent, CLI and checker adds, so
the second check holds even when the udev data is stale by the time it
is used. If the SG_IO read fails, behavior is unchanged.

Split the SG_IO read out of check_path_wwid_change() into
get_sgio_wwid() so all three checks share it.

Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 multipathd/main.c | 57 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 52 insertions(+), 5 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 9bce4d6b..656efb6e 100644
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
@@ -1315,6 +1344,20 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 		condlog(0, "%s: failed to get path uid", pp->dev);
 		goto fail; /* leave path added to pathvec */
 	}
+	/*
+	 * The WWID normally comes from udev, possibly from an event that
+	 * was queued long before we got here. Adding a path to the map
+	 * of a different LUN corrupts data, so confirm the WWID with the
+	 * device first. On a mismatch, leave the path out and let the
+	 * checker retrigger udev to get a fresh WWID.
+	 */
+	if (can_recheck_wwid(pp) && check_path_wwid_change(pp)) {
+		condlog(0, "%s: not adding path, wwid '%s' not confirmed by device",
+			pp->dev, pp->wwid);
+		memset(pp->wwid, 0, WWID_SIZE);
+		pp->initialized = INIT_MISSING_UDEV;
+		goto fail;
+	}
 	mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
 	if (mpp && pp->size && mpp->size != pp->size) {
 		condlog(0, "%s: failed to add new path %s, device size mismatch", mpp->alias, pp->dev);
@@ -1702,6 +1745,10 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
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
-- 
2.56.0

