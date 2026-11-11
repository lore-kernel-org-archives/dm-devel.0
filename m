Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794421016;
	b=VroSg0eG10DrVGBw2XXV8o9yZpfCOCFOU6Cgef+d2qsvrK53W5ndJvRW9tkYT3lMVzcZ
	 de79dDNlIcWHtiA4JngkxmYwgjH7kZTux7Qp54rEA8zso3o89mH1+NLaqSR/OVNrPcOyD
	 83fLH18MGpXXqtGOA94iovDdrnf/ryAEvAM/cWZvkcK5MMP3SW77fhNFGpK7pJfHdK4oK
	 fbIi9a2nNS3/UfmTcWVuUEgBLAQwJhNfQJG/omtMS5yHDHKJ3BDy4EEZJdUzS9nXj6rYz
	 UM+NXgYvcY0gne922hHNS/J2St6yn8AAB6hN9EFS+NMZ2aw4YeDmQJxujhzbGfOFoSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794421016;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JhGy8kMh4Qvk8VgFheCL0OW/ts/Le+ExmKJJKm5PpIc=;
	b=pMqjAp6DEeCf0XOqHnHOEH8axapGspf8QsJGkBl8j/KcKdsn9iZ1oSr1tlSg2zchU3Ij
	 9yxQ7CeDh7L2NQoOPYqLEKI7FpEin+5W6A12xWIK+30ObYBP/Krc24u7SCQKCgjsgxfrx
	 0R46gZM4Gwpw1NU8cNmbFY+bH20AKbTNQpioWT6WHRfU39AKfdl+ZcPC+9VirSTbZDPu9
	 Fr9pS1ZQQcCiSQLeuWXNnowKdFSJv5jxDKwR5HH5aHeZnhBh5YNMstmrOkSJoU3QwZY0I
	 ufwe0bM65i/W+UZmmaRWlcYPdm5gmDa7d56tzRgYay5JppMIxy3V2/9pMJo2Bi06w1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=fQfOElsH;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A8D606A886
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 18:16:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97A8D606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=fQfOElsH
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso1900625eec.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 10:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1794421015; x=1795025815; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JhGy8kMh4Qvk8VgFheCL0OW/ts/Le+ExmKJJKm5PpIc=;
        b=fQfOElsHToyxxPHx5ySSoMKlL31eOv9MMUif4OCqX7QFk2qD5tZda9y5SvGpwl6cBW
         +XmDsx3ZDwomEaQM8Yr2I1yfaFbE4oMFen3ekeyACotxv/Ngk7ZoX7d+T6NTIDPy85f/
         6CxjbzLhUkBxz+YGvBsBc5mbpoYri7mrm7iUrW+D/cyMeHqF0u4LXJUPYoKXp3b2yAGs
         IACDGcuFUKxsOfr0nLskPClOfuUZgyUZ46nSHDbDlEjVm9E7AIRM8eo1+GEhw9fuXOUc
         3Eu2UzbuYD2w53gtFjnaMPceGgGOIcbMzZvpKJEMvHMZoI7U7QIsNolzX3uEfGgGM/8P
         ClJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794421015; x=1795025815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JhGy8kMh4Qvk8VgFheCL0OW/ts/Le+ExmKJJKm5PpIc=;
        b=w7qRmspNoYWo7UYgQJ9wwZNqzzGA2lY7eO7UzmZ588U+Qi1/DnDTtT97MrPhom7HeD
         QYzz8LpCDloe3cHzPfvvDLeLmo56q2L6haztY+/5saLIVSIernHu5hhcRGwND9dTTw1g
         vKN1RJ0E4XkI8LA35Kq/zl4/iXRW8iLbCUo62M00YZ7En1mV19kBCI+ztQqucedMPZhv
         sPAIrstAperiVIRuKoMfsuaP6qVrF2mnkLDBJGC3Y+g8I5rfRZ+k+HDObT6FjMzNo13v
         YzaLzyraaKJtB5BVR22aGTvjtvWuAqU261s8R5DUgFDjeGEdlfqcMWpRHJDxmfeVVelQ
         1r7g==
X-Forwarded-Encrypted: i=1; AL+hErFdYwuWj5AX6eUJQNsZG6nGLeO04oBiGek2BoS/zDTfNosrIod9nkDQTHgm8Sl/C+nybHqMSiFqjw==@lists.linux.dev
X-Gm-Message-State: APuU4Z+bRtckMi7Pq8rXYkTX8pyiueetFxqwhRpxkPeHdXN1Dg40QlfP
	CsxwIwsXlgK/KRjTXACRCBi533it4arcpxbVOj6BDHtB5iNMRdQLWCiQgkDxPF+E3Jluxa2XCDr
	WpZpDDQQ=
X-Gm-Gg: AYBFou1wxhSIbNIiiMR4N7P46KlTLrNX5FaHsIFP5QHi/GlgTOETpDVJ3E5z2JY0B1h
	H7tHTvxP3v82BY2E26WPMxTXeHhIAl1bOwk50UBoq8U8UYFmZ9QQzcQPcreT3y/yncBEoKAxHWc
	IrGI25hhRSujO/gYTAV9gtpM7uBKfdUmTEyW6SoFN0b0KDwVzhGfUSwjABkGeatMzyPyPae1LpI
	7PtqYxpMRR1fNoVbUgG4+/XhmDhDC/bKLEekmeIIEQdyS/FpFyVKM2hTNgB61Hwg8PAF6ABAEv2
	9Va9krpOMYGckx2vPWWTZ3G+6Jv3Bxp1MN7NXrR1n17qvFqNZb0ItKCPQhE9lQQaXneEDAiJ1uz
	hReZYn6tCUNB0+zlKg5k83Gt2bWz7dcWlHGsAjsAJnLc7Un5ByfDVjHLz2ZVqAUc3fRSXkjZYJ1
	D2RF287snAV7RRhB5xXK8/IN8CUBd163TxFRGRPlrUVpL4DZ/vcEVMZSw+QnzMiYyB02dx1eK9Z
	473zy/os7yaw5zJwvFxvKz6tVMUw3jeeaj0xm5JL8y+AyBk85sGmmTucHDaQxWxRi5TrEwdNlg4
	KVvkvpgzOm/Eh/ODRdD8fZhOfp+4LiSoeRPtMoPv1TpQIRrxQItsu1CJnIMoTeMC47HkzI047Nh
	x8sm54txMnyJWC5esRhrCNJ82XeucVVel1mxhkVKJc+Jrf7VCGwwhjwmw0trTTEHMC6Kd4fBgJB
	1NN4NAckUbUKeNm0MyfH0=
X-Received: by 2002:a05:7300:d704:b0:377:7f17:98ce with SMTP id 5a478bee46e88-3777f17999dmr1473835eec.21.1794421014474;
        Wed, 11 Nov 2026 10:16:54 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-375212ec002sm20565706eec.26.2026.11.11.10.16.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 10:16:54 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v4 1/1] multipathd: recheck WWIDs of re-added paths with the device
Date: Wed, 11 Nov 2026 10:16:42 -0800
Message-ID: <20261111181642.51912-2-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261111181642.51912-1-brian@purestorage.com>
References: <20261111181642.51912-1-brian@purestorage.com>
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
the new WWID. The removal can block for seconds while the map is
suspended, so by the time the path is re-added, the WWID in the uevent
may no longer be what the device reports. If it is wrong, the path goes
into the map of a different LUN and I/O for one LUN is silently sent to
another.

If recheck_wwid is set, confirm the WWID with the device over SG_IO
before such a re-add puts the path into a map, as recheck_wwid already
does when a failed path comes back. If the device doesn't confirm it,
leave the path out of the map: orphan it, clear its WWID and mark it
INIT_MISSING_UDEV, so the checker retriggers udev and the path is
re-added from fresh data.

To tell re-adds from ordinary adds, turn the need_do_map argument of
uev_add_path() and ev_add_path() into enum path_add_mode, with a new
PATH_ADD_REINIT value that behaves like PATH_ADD_MAP and is passed only
for the re-add at the end of uev_update_path(). Ordinary adds are
unchanged.

Document the new case under recheck_wwid in multipath.conf(5).

Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 multipath/multipath.conf.5.in |  8 +++++---
 multipathd/cli_handlers.c     |  2 +-
 multipathd/main.c             | 37 ++++++++++++++++++++++++-----------
 multipathd/main.h             | 13 +++++++++++-
 4 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index a577dfc8..8f358808 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -1382,9 +1382,11 @@ The default is: \fB\(dqNONE\(dq\fR
 If set to \fIyes\fR, when a failed path is restored, its wwid is rechecked. If
 the wwid has changed, the path is removed from the current multipath device,
 and re-added as a new path. Multipathd will also recheck a path's wwid if it is
-manually re-added. This option only works for SCSI devices that are configured
-to use the default uid_attribute, \fIID_SERIAL\fR, or sysfs for getting their
-wwid.
+manually re-added, and before re-adding a path whose wwid udev reported as
+changed. If the device doesn't confirm the new wwid, the path is left out of
+the multipath device and udev is asked to report its wwid again. This option
+only works for SCSI devices that are configured to use the default
+uid_attribute, \fIID_SERIAL\fR, or sysfs for getting their wwid.
 .RS
 .TP
 The default is: \fBno\fR
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
index 9bce4d6b..fdf5503b 100644
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
@@ -1297,8 +1297,7 @@ sysfs_get_ro (struct path *pp)
  * 0: added
  * 1: error
  */
-int
-ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
+int ev_add_path(struct path *pp, struct vectors *vecs, enum path_add_mode mode)
 {
 	struct multipath * mpp;
 	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
@@ -1315,6 +1314,22 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 		condlog(0, "%s: failed to get path uid", pp->dev);
 		goto fail; /* leave path added to pathvec */
 	}
+	/*
+	 * This path is being re-added because its udev data was missing or
+	 * changed. The uevent may have been queued long before we got here,
+	 * and adding a path to the map of a different LUN corrupts data. If
+	 * recheck_wwid is set, confirm the WWID with the device first. On a
+	 * mismatch, leave the path out and let the checker retrigger udev
+	 * to get a fresh WWID.
+	 */
+	if (mode == PATH_ADD_REINIT && pp->recheck_wwid == RECHECK_WWID_ON &&
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
@@ -1375,7 +1390,7 @@ rescan:
 	if (ro == 1)
 		mpp->force_readonly = 1;
 
-	if (!need_do_map)
+	if (mode == PATH_ADD_NO_MAP)
 		return 0;
 
 	if (!dm_map_present(mpp->alias)) {
@@ -1789,7 +1804,7 @@ out:
 	}
 	/* pp->initialized must not be INIT_PARTIAL if needs_reinit is set */
 	if (needs_reinit)
-		retval = uev_add_path(uev, vecs, 1);
+		retval = uev_add_path(uev, vecs, PATH_ADD_REINIT);
 	return retval;
 }
 
@@ -1905,13 +1920,13 @@ uev_trigger (struct uevent * uev, void * trigger_data)
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
@@ -3015,7 +3030,7 @@ update_uninitialized_path(struct vectors * vecs, struct path * pp)
 		pthread_cleanup_pop(1);
 		/* INIT_OK implies ret == PATHINFO_OK */
 		if (pp->initialized == INIT_OK) {
-			ev_add_path(pp, vecs, 1);
+			ev_add_path(pp, vecs, PATH_ADD_MAP);
 			pp->tick = 1;
 		} else if (ret == PATHINFO_SKIPPED) {
 			int i;
@@ -3036,7 +3051,7 @@ update_uninitialized_path(struct vectors * vecs, struct path * pp)
 					CHECK_PATH_REMOVED :
 					CHECK_PATH_SKIPPED;
 		}
-		ev_add_path(pp, vecs, 1);
+		ev_add_path(pp, vecs, PATH_ADD_MAP);
 		pp->tick = 1;
 	}
 	return CHECK_PATH_CHECKED;
diff --git a/multipathd/main.h b/multipathd/main.h
index b66208ec..2eaf5183 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -36,7 +36,18 @@ enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
 					    unsigned long ms);
 void schedule_reconfigure(enum force_reload_types requested_type);
 int need_to_delay_reconfig (struct vectors *);
-int ev_add_path (struct path *, struct vectors *, int);
+/*
+ * PATH_ADD_REINIT is PATH_ADD_MAP for a path that is being re-added
+ * because its udev data was missing or changed. If recheck_wwid is
+ * set, its WWID is confirmed with the device before the path is put
+ * into a map.
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

