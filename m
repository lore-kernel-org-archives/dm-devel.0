Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA7D2FF653
	for <dm-devel@lists.linux.dev>; Tue,  9 Dec 2025 17:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765302247; cv=none; b=iD63af1hsti9FNhozgV5xxaXrSMsRHupRL6vs3FC4sfqbUG8r0+bDKKVVbes2zrcFzsa6qhlhSEOzoNMozyAhQMhVEIuWh1embCiyk4GU3oG0U5zO6N67UwL+DaGYtVrDtJfknmRBt1tVu42UZNAcXlCMUc7ZLuPBxbttFjh0nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765302247; c=relaxed/simple;
	bh=6DXQizu3ZMguUxNxt6vIiBWC5qCeVPuCoDDJuNVpdf4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rzLRnpHjaQtDsX+kZ0cIgc9EguJjJ2MZ2sCuFRZwViEFVNsC336lfAnG4m6jVYaKwvBA6pVc5gXCQsmlFMpw1robV/XWSQI0AlQipHGJutNcEg7zIFSFpvKPu5KjaSBdwVKKf/nKX30vL6z1zpZfmyxIJNkxbMltloiMBYHfNfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=A+PwW/ns; arc=none smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="A+PwW/ns"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-6446c1a7a1cso238859d50.3
        for <dm-devel@lists.linux.dev>; Tue, 09 Dec 2025 09:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765302243; x=1765907043; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X++GIieghQ+Xoecll8bafjA0fwOiUqVUiq/J/1OxGHk=;
        b=A+PwW/nsy/Bw3Z9OPnOIslqbOyIJurRdoV9Rn3D21OuwbrBK88oFUgoogV7aJwKjpL
         o0XWDLt7jXO1AHcQbP5pjhfKXC2sBAJUKKyKvESqmtcMbMGnW4nakKAJwl1lgUIPMuFR
         w5rPDk2ODYXQzT81j71AdkyD2jsb+4JIlFmALGVm/FmcuXUWXi/cpt+y2HUdyDMCZQ7t
         /rGdbztd0XzqyDCLRNpUD0rXzUv2ZAwLEUoLYQIoVF4fcf8Qb8AWzvgAjhEBB48NMVBW
         P27wfrADzmoX+UWaowvSMq/GUHst/Obhmb1uhLU6c+UTUWqY7m7/MK86bRLifxlvBULe
         MjPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765302243; x=1765907043;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X++GIieghQ+Xoecll8bafjA0fwOiUqVUiq/J/1OxGHk=;
        b=g4pAyCultpLRJLaYUZzMJRyKQa2162bxhS2+nZHO5bJ3pSNKbqInEgkkmYnWGCm8ky
         EThW3gnL/oyOFAfEyxxUCZ7CDldhLdxU8zJlCme+H5u1qIvEBQe/bowpdTXluEGIAp3H
         H0gtEWHZLYykGW1ghSfAa10K38iNr0N/yS6ByCnlW1yMNkM+ewkKYIKljyzVRcc5AAv1
         80aScdIElLrsf83aEEWo8YZuL6SFMs9JcQhAqn0H2T583cm9teacECV2iaqmmYSFNrkv
         V3Ok5gFT+CfTA5H9ub7YZe6/q5NNNXpLgMGi4UnNlNYZ9TgwObhziVf29BFkByvZMLWG
         zUQA==
X-Gm-Message-State: AOJu0Yyta4rrkj3B2NBg+pnXO4TwXmhLcojfLit7lFdG1cTh+DtL3VAy
	oj8mlCjbhQeJLLGeV4/Zen+8UtsDuEYtCNoKuheKHlO3RvubAflgCV9ltqjzx0Gap1xxQKnrmjw
	lxu9T6sk/Ky9huNNEhubCPOau0ucEHk1MZujANntowzdSuQ6uX3syHAk7thOL9kJyB1xBJRGphJ
	4dZ+ikTuhe5qyRwesEz2THe90bHw4g7Ny/aKVkJMiclGWO5uo=
X-Gm-Gg: AY/fxX6NDNoRCrlfFj0rur0scrt/2mTKLKtocrM1HcesOP+gsGoLfYA65CBBNxGLJtY
	Rh5Cj6WlhIf7Nyr737yDqhcI2iB13WX3lIaOmstil/Mjqlw4dlOyBu0T8e8xczL5V5F4LcKsHMo
	nZSN48yDJmKzSFdhBjj+JLAyz1PQ3+6G8+fkxKaU+nfd1sLEGg1hp9v2ghWQ/KWjUVVPW4ZWQ/5
	syPRacK2fp3SW5vbn87d0DYoRFLzbBTMlcnijeGpRixHu9v7IBv/yJzzkl/EFVX5ys8tQ662LF7
	I8HLcd/zSfA7+pYsCvuV/2lEfVTBMZ+JMtJAO8qY3h+MWDEPKkrYj4qkvbW1p1DYDATXEr7wsmu
	Qq8b/b8RTS8w8Sfws4hRge90+hzoRE55OzZqlr+8mHN0a8yKHbuXiyTqeJbKifFop4xAiOfFYAA
	Mx7Hgsd3vo5TF08XHa9kUjWxaOWl5yqJWCy0pBTY09woFdgOpZT2Uw2xVCodoH2lGHAmnMZ2rvd
	4srIwNRIgt7LudL8TY3Gq6FQkx25IIn/OX6GZL/FVcy
X-Google-Smtp-Source: AGHT+IGztjmYGSS8ybqRmcx8dg+eHXnuGrHed0z/ykdk/grtABjTyrZgOTSX2mwDCRIVFMiji7jAKw==
X-Received: by 2002:a05:690e:d0e:b0:644:6422:cb2 with SMTP id 956f58d0204a3-64464220e41mr3532783d50.47.1765302242798;
        Tue, 09 Dec 2025 09:44:02 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([136.226.79.101])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6444adddb01sm5136191d50.3.2025.12.09.09.44.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Dec 2025 09:44:02 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev,
	bmarzins@redhat.com,
	mwilck@suse.com
Cc: Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v4] mulitpath-tools Add purge capability to multipath-tools
Date: Tue,  9 Dec 2025 09:43:42 -0800
Message-ID: <20251209174342.86044-1-brian@purestorage.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the Linux kernel when volumes are disconnected, they are left behind
to be re-enabled when the connection comes back. There are many cases
where this behavior is not desirable.

The goal is to have paths appear when volumes are connected. This is
handled by target initiated rescans and posting of unit attentions.
Secondarily when volumes are disconnected at the target, paths should
be removed.

This was discussed here in a kernel patch:
https://marc.info/?l=linux-scsi&m=164426722617834&w=2

It was suggested there that userspace would be more advantageous in
handling the device removal.

An option was added to multipath-tools to purge devices that are
disconnected at the target. A purge thread was implemented to handle
the device removal when the path returns sense data (0x5/0x25/0x0) from
the path checker. The option, purge_disconnected, is by default off but
can be turned on by setting it to true.

When enabled multipathd will log:
Dec  4 16:25:54 init110-14 multipathd[1024]: sdmp: purging disconnected
path
...
Dec  4 16:25:54 init110-14 multipathd[1024]: /dev/sdmp: triggered
removal

Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
---
 libmultipath/checkers.c       |   2 +
 libmultipath/checkers.h       |   2 +
 libmultipath/checkers/tur.c   |  10 ++
 libmultipath/config.c         |   2 +
 libmultipath/config.h         |   3 +
 libmultipath/configure.c      |   1 +
 libmultipath/defaults.h       |   1 +
 libmultipath/dict.c           |  14 ++
 libmultipath/discovery.c      |   3 +-
 libmultipath/io_err_stat.c    |   1 +
 libmultipath/print.c          |   2 +
 libmultipath/propsel.c        |  16 +++
 libmultipath/propsel.h        |   1 +
 libmultipath/structs.h        |   8 ++
 libmultipath/sysfs.c          |   2 +-
 multipath/multipath.conf.5.in |  22 +++
 multipathd/main.c             | 243 +++++++++++++++++++++++++++++++++-
 17 files changed, 325 insertions(+), 8 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index e2eda58d..bb6ad1ee 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -43,6 +43,7 @@ static const char *checker_state_names[PATH_MAX_STATE] = {
 	[PATH_TIMEOUT] = "timeout",
 	[PATH_REMOVED] = "removed",
 	[PATH_DELAYED] = "delayed",
+	[PATH_DISCONNECTED] = "disconnected",
 };
 
 static LIST_HEAD(checkers);
@@ -363,6 +364,7 @@ static const char *generic_msg[CHECKER_GENERIC_MSGTABLE_SIZE] = {
 	[CHECKER_MSGID_DOWN] = " reports path is down",
 	[CHECKER_MSGID_GHOST] = " reports path is ghost",
 	[CHECKER_MSGID_UNSUPPORTED] = " doesn't support this device",
+	[CHECKER_MSGID_DISCONNECTED] = " no access to this device",
 };
 
 const char *checker_message(const struct checker *c)
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index da91f499..903c3ebe 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -78,6 +78,7 @@ enum path_check_state {
 	PATH_TIMEOUT,
 	PATH_REMOVED,
 	PATH_DELAYED,
+	PATH_DISCONNECTED,
 	PATH_MAX_STATE
 };
 
@@ -113,6 +114,7 @@ enum {
 	CHECKER_MSGID_DOWN,
 	CHECKER_MSGID_GHOST,
 	CHECKER_MSGID_UNSUPPORTED,
+	CHECKER_MSGID_DISCONNECTED,
 	CHECKER_GENERIC_MSGTABLE_SIZE,
 	CHECKER_FIRST_MSGID = 100,	/* lowest msgid for checkers */
 	CHECKER_MSGTABLE_SIZE = 100,	/* max msg table size for checkers */
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 0010acf8..1bb9a992 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -199,6 +199,16 @@ retry:
 				return PATH_PENDING;
 			}
 		}
+		else if (key == 0x5) {
+			/* Illegal request */
+			if (asc == 0x25 && ascq == 0x00) {
+				/*
+				 * LOGICAL UNIT NOT SUPPORTED
+				 */
+				*msgid = CHECKER_MSGID_DISCONNECTED;
+				return PATH_DISCONNECTED;
+			}
+		}
 		*msgid = CHECKER_MSGID_DOWN;
 		return PATH_DOWN;
 	}
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 8b424d18..2c66a788 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -470,6 +470,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(marginal_path_err_rate_threshold);
 	merge_num(marginal_path_err_recheck_gap_time);
 	merge_num(marginal_path_double_failed_time);
+	merge_num(purge_disconnected);
 
 	snprintf(id, sizeof(id), "%s/%s", dst->vendor, dst->product);
 	reconcile_features_with_options(id, &dst->features,
@@ -517,6 +518,7 @@ merge_mpe(struct mpentry *dst, struct mpentry *src)
 	merge_num(skip_kpartx);
 	merge_num(max_sectors_kb);
 	merge_num(ghost_delay);
+	merge_num(purge_disconnected);
 	merge_num(uid);
 	merge_num(gid);
 	merge_num(mode);
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 5b4ebf8c..618fa572 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -88,6 +88,7 @@ struct hwentry {
 	int marginal_path_err_rate_threshold;
 	int marginal_path_err_recheck_gap_time;
 	int marginal_path_double_failed_time;
+	int purge_disconnected;
 	int skip_kpartx;
 	int max_sectors_kb;
 	int ghost_delay;
@@ -130,6 +131,7 @@ struct mpentry {
 	int marginal_path_err_rate_threshold;
 	int marginal_path_err_recheck_gap_time;
 	int marginal_path_double_failed_time;
+	int purge_disconnected;
 	int skip_kpartx;
 	int max_sectors_kb;
 	int ghost_delay;
@@ -188,6 +190,7 @@ struct config {
 	int marginal_path_err_rate_threshold;
 	int marginal_path_err_recheck_gap_time;
 	int marginal_path_double_failed_time;
+	int purge_disconnected;
 	int uxsock_timeout;
 	int strict_timing;
 	int retrigger_tries;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index baa13573..e4431d2f 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -355,6 +355,7 @@ int setup_map(struct multipath *mpp, char **params, struct vectors *vecs)
 	select_max_sectors_kb(conf, mpp);
 	select_ghost_delay(conf, mpp);
 	select_flush_on_last_del(conf, mpp);
+	select_purge_disconnected(conf, mpp);
 
 	sysfs_set_scsi_tmo(conf, mpp);
 	marginal_pathgroups = conf->marginal_pathgroups;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 134b690a..d80dd7d4 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -58,6 +58,7 @@
 #define DEFAULT_ALL_TG_PT ALL_TG_PT_OFF
 #define DEFAULT_RECHECK_WWID RECHECK_WWID_OFF
 #define DEFAULT_AUTO_RESIZE AUTO_RESIZE_NEVER
+#define DEFAULT_PURGE_DISCONNECTED PURGE_DISCONNECTED_OFF
 /* Enable no foreign libraries by default */
 #define DEFAULT_ENABLE_FOREIGN "NONE"
 
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index a06a6138..504b28b5 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -941,6 +941,16 @@ declare_hw_snprint(skip_kpartx, print_yes_no_undef)
 declare_mp_handler(skip_kpartx, set_yes_no_undef)
 declare_mp_snprint(skip_kpartx, print_yes_no_undef)
 
+declare_def_handler(purge_disconnected, set_yes_no_undef)
+declare_def_snprint_defint(purge_disconnected, print_yes_no_undef,
+	DEFAULT_PURGE_DISCONNECTED)
+declare_ovr_handler(purge_disconnected, set_yes_no_undef)
+declare_ovr_snprint(purge_disconnected, print_yes_no_undef)
+declare_hw_handler(purge_disconnected, set_yes_no_undef)
+declare_hw_snprint(purge_disconnected, print_yes_no_undef)
+declare_mp_handler(purge_disconnected, set_yes_no_undef)
+declare_mp_snprint(purge_disconnected, print_yes_no_undef)
+
 declare_def_range_handler(remove_retries, 0, INT_MAX)
 declare_def_snprint(remove_retries, print_int)
 
@@ -2227,6 +2237,7 @@ init_keywords(vector keywords)
 	install_keyword("retrigger_delay", &def_retrigger_delay_handler, &snprint_def_retrigger_delay);
 	install_keyword("missing_uev_wait_timeout", &def_uev_wait_timeout_handler, &snprint_def_uev_wait_timeout);
 	install_keyword("skip_kpartx", &def_skip_kpartx_handler, &snprint_def_skip_kpartx);
+	install_keyword("purge_disconnected", &def_purge_disconnected_handler, &snprint_def_purge_disconnected);
 	install_keyword("disable_changed_wwids", &deprecated_disable_changed_wwids_handler, &snprint_deprecated);
 	install_keyword("remove_retries", &def_remove_retries_handler, &snprint_def_remove_retries);
 	install_keyword("max_sectors_kb", &def_max_sectors_kb_handler, &snprint_def_max_sectors_kb);
@@ -2310,6 +2321,7 @@ init_keywords(vector keywords)
 	install_keyword("marginal_path_err_recheck_gap_time", &hw_marginal_path_err_recheck_gap_time_handler, &snprint_hw_marginal_path_err_recheck_gap_time);
 	install_keyword("marginal_path_double_failed_time", &hw_marginal_path_double_failed_time_handler, &snprint_hw_marginal_path_double_failed_time);
 	install_keyword("skip_kpartx", &hw_skip_kpartx_handler, &snprint_hw_skip_kpartx);
+	install_keyword("purge_disconnected", &hw_purge_disconnected_handler, &snprint_hw_purge_disconnected);
 	install_keyword("max_sectors_kb", &hw_max_sectors_kb_handler, &snprint_hw_max_sectors_kb);
 	install_keyword("ghost_delay", &hw_ghost_delay_handler, &snprint_hw_ghost_delay);
 	install_keyword("all_tg_pt", &hw_all_tg_pt_handler, &snprint_hw_all_tg_pt);
@@ -2355,6 +2367,7 @@ init_keywords(vector keywords)
 	install_keyword("marginal_path_double_failed_time", &ovr_marginal_path_double_failed_time_handler, &snprint_ovr_marginal_path_double_failed_time);
 
 	install_keyword("skip_kpartx", &ovr_skip_kpartx_handler, &snprint_ovr_skip_kpartx);
+	install_keyword("purge_disconnected", &ovr_purge_disconnected_handler, &snprint_ovr_purge_disconnected);
 	install_keyword("max_sectors_kb", &ovr_max_sectors_kb_handler, &snprint_ovr_max_sectors_kb);
 	install_keyword("ghost_delay", &ovr_ghost_delay_handler, &snprint_ovr_ghost_delay);
 	install_keyword("all_tg_pt", &ovr_all_tg_pt_handler, &snprint_ovr_all_tg_pt);
@@ -2400,6 +2413,7 @@ init_keywords(vector keywords)
 	install_keyword("marginal_path_err_recheck_gap_time", &mp_marginal_path_err_recheck_gap_time_handler, &snprint_mp_marginal_path_err_recheck_gap_time);
 	install_keyword("marginal_path_double_failed_time", &mp_marginal_path_double_failed_time_handler, &snprint_mp_marginal_path_double_failed_time);
 	install_keyword("skip_kpartx", &mp_skip_kpartx_handler, &snprint_mp_skip_kpartx);
+	install_keyword("purge_disconnected", &mp_purge_disconnected_handler, &snprint_mp_purge_disconnected);
 	install_keyword("max_sectors_kb", &mp_max_sectors_kb_handler, &snprint_mp_max_sectors_kb);
 	install_keyword("ghost_delay", &mp_ghost_delay_handler, &snprint_mp_ghost_delay);
 	install_sublevel_end();
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 31db8758..46274f3f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2482,7 +2482,8 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 			    pp->state == PATH_UNCHECKED ||
 			    pp->state == PATH_WILD)
 				pp->chkrstate = pp->state = newstate;
-			if (pp->state == PATH_TIMEOUT)
+			if (pp->state == PATH_TIMEOUT ||
+			    pp->state == PATH_DISCONNECTED)
 				pp->state = PATH_DOWN;
 			if (pp->state == PATH_UP && !pp->size) {
 				condlog(3, "%s: device size is 0, "
diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 64054c18..acb087b7 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -397,6 +397,7 @@ static void account_async_io_state(struct io_err_stat_path *pp, int rc)
 	switch (rc) {
 	case PATH_DOWN:
 	case PATH_TIMEOUT:
+	case PATH_DISCONNECTED:
 		pp->io_err_nr++;
 		break;
 	case PATH_UNCHECKED:
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 0d44a5a9..8b09b174 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -541,6 +541,8 @@ snprint_chk_state (struct strbuf *buff, const struct path * pp)
 		return append_strbuf_str(buff, "i/o timeout");
 	case PATH_DELAYED:
 		return append_strbuf_str(buff, "delayed");
+	case PATH_DISCONNECTED:
+		return append_strbuf_str(buff, "disconnected");
 	default:
 		return append_strbuf_str(buff, "undef");
 	}
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 4c0fbcf3..9a17f1ed 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -1371,6 +1371,22 @@ out:
 	return 0;
 }
 
+int select_purge_disconnected (struct config *conf, struct multipath * mp)
+{
+	const char *origin;
+
+	mp_set_mpe(purge_disconnected);
+	mp_set_ovr(purge_disconnected);
+	mp_set_hwe(purge_disconnected);
+	mp_set_conf(purge_disconnected);
+	mp_set_default(purge_disconnected, DEFAULT_PURGE_DISCONNECTED);
+out:
+	condlog(3, "%s: purge_disconnected = %s %s", mp->alias,
+		(mp->purge_disconnected == PURGE_DISCONNECTED_ON)? "yes" : "no",
+		origin);
+	return 0;
+}
+
 int select_max_sectors_kb(struct config *conf, struct multipath * mp)
 {
 	const char *origin;
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 55930050..c6c937c3 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -39,6 +39,7 @@ int select_marginal_path_err_rate_threshold(struct config *conf, struct multipat
 int select_marginal_path_err_recheck_gap_time(struct config *conf, struct multipath *mp);
 int select_marginal_path_double_failed_time(struct config *conf, struct multipath *mp);
 int select_ghost_delay(struct config *conf, struct multipath * mp);
+int select_purge_disconnected (struct config *conf, struct multipath * mp);
 void reconcile_features_with_options(const char *id, char **features,
 				     int* no_path_retry,
 				     int *retain_hwhandler);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 9247e74f..2ccdf945 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -186,6 +186,12 @@ enum auto_resize_state {
 	AUTO_RESIZE_GROW_SHRINK,
 };
 
+enum purge_disconnected_states {
+	PURGE_DISCONNECTED_UNDEF = YNU_UNDEF,
+	PURGE_DISCONNECTED_OFF = YNU_NO,
+	PURGE_DISCONNECTED_ON = YNU_YES,
+};
+
 #define PROTOCOL_UNSET -1
 
 enum scsi_protocol {
@@ -382,6 +388,7 @@ struct path {
 	int dmstate;
 	int chkrstate;
 	int oldstate;
+	bool purge_path;
 	int failcount;
 	int priority;
 	int pgindex;
@@ -483,6 +490,7 @@ struct multipath {
 	int ghost_delay;
 	int ghost_delay_tick;
 	int queue_mode;
+	int purge_disconnected;
 	unsigned int sync_tick;
 	int checker_count;
 	enum prio_update_type prio_update;
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index af27d107..538800d8 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -134,7 +134,7 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 	size = write(fd, value, value_len);
 	if (size < 0) {
 		size = -errno;
-		condlog(3, "%s: write to %s failed: %s", __func__, 
+		condlog(3, "%s: write to %s failed: %s", __func__,
 			devpath, strerror(errno));
 	} else if (size < (ssize_t)value_len)
 		condlog(3, "%s: underflow writing %zu bytes to %s. Wrote %zd bytes",
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 3c9ae097..84cd1a0a 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -1306,6 +1306,22 @@ The default is: \fBno\fR
 .
 .
 .TP
+.B purge_disconnected
+If set to
+.I yes
+, multipathd will automatically remove devices that are in a disconnected state.
+A path is considered disconnected when the TUR (Test Unit Ready) path checker
+receives the SCSI sense code "LOGICAL UNIT NOT SUPPORTED" (sense key 0x5,
+ASC/ASCQ 0x25/0x00). This typically indicates that the LUN has been unmapped
+or is no longer presented by the storage array. This option helps clean up
+stale device entries that would otherwise remain in the system.
+.RS
+.TP
+The default is: \fBno\fR
+.RE
+.
+.
+.TP
 .B disable_changed_wwids
 (Deprecated) This option is not supported anymore, and will be ignored.
 .RE
@@ -1602,6 +1618,8 @@ section:
 .TP
 .B skip_kpartx
 .TP
+.B purge_disconnected
+.TP
 .B max_sectors_kb
 .TP
 .B ghost_delay
@@ -1797,6 +1815,8 @@ section:
 .TP
 .B skip_kpartx
 .TP
+.B purge_disconnected
+.TP
 .B max_sectors_kb
 .TP
 .B ghost_delay
@@ -1881,6 +1901,8 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .TP
 .B skip_kpartx
 .TP
+.B purge_disconnected
+.TP
 .B max_sectors_kb
 .TP
 .B ghost_delay
diff --git a/multipathd/main.c b/multipathd/main.c
index d11a8576..ce5040e0 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -137,11 +137,14 @@ static enum force_reload_types reconfigure_pending = FORCE_RELOAD_NONE;
 pid_t daemon_pid;
 static pthread_mutex_t config_lock = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t config_cond;
-static pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr, dmevent_thr,
-	fpin_thr, fpin_consumer_thr;
-static bool check_thr_started, uevent_thr_started, uxlsnr_thr_started,
-	uevq_thr_started, dmevent_thr_started, fpin_thr_started,
-	fpin_consumer_thr_started;
+static pthread_mutex_t purge_mutex = PTHREAD_MUTEX_INITIALIZER;
+static pthread_cond_t purge_cond = PTHREAD_COND_INITIALIZER;
+int devices_to_purge = 0;
+static pthread_t check_thr, purge_thr, uevent_thr, uxlsnr_thr, uevq_thr,
+	dmevent_thr, fpin_thr, fpin_consumer_thr;
+static bool check_thr_started, purge_thr_started, uevent_thr_started,
+	uxlsnr_thr_started, uevq_thr_started, dmevent_thr_started,
+	fpin_thr_started, fpin_consumer_thr_started;
 static int pid_fd = -1;
 
 static inline enum daemon_status get_running_state(bool *pending_reconfig)
@@ -1089,6 +1092,99 @@ check_path_wwid_change(struct path *pp)
 	return false;
 }
 
+/*
+ * Information needed to delete a path via sysfs, copied while holding the lock
+ * so that the actual sysfs write can be done without holding vecs->lock.
+ *
+ * The duplicated fd prevents the kernel from reusing the device name/H:C:T:L
+ * even if the device is removed and a new one appears.
+ */
+struct purge_path_info {
+	struct udev_device *udev;  /* Reference to udev device (refcounted) */
+	int fd;                    /* Duplicated fd to prevent device reuse */
+};
+
+/*
+ * Attempt to delete a path by writing to the SCSI device's sysfs delete attribute.
+ * This triggers kernel-level device removal. The actual cleanup of the path structure
+ * from pathvec happens later when a uevent arrives (handled by uev_remove_path).
+ *
+ * This function does NOT require vecs->lock to be held, as it operates on copied data.
+ * This function may block while writing to sysfs, which is why it's called without
+ * holding any locks.
+ */
+static void
+delete_path_sysfs(struct purge_path_info *info)
+{
+	struct udev_device *ud;
+	const char *devname;
+
+	if (!info->udev)
+		return;
+
+	devname = udev_device_get_devnode(info->udev);
+	ud = udev_device_get_parent_with_subsystem_devtype(info->udev,
+		"scsi", "scsi_device");
+
+	if (!ud) {
+		condlog(3, "%s: no SCSI parent device found", devname);
+		return;
+	}
+
+	if (sysfs_attr_set_value(ud, "delete", "1", strlen("1")) < 0)
+		condlog(3, "%s: failed to delete", devname);
+	else
+		condlog(2, "%s: triggered removal", devname);
+}
+
+/*
+ * Prepare purge info for a path while holding vecs->lock.
+ * Takes a reference on the udev device and duplicates the fd if available.
+ * The duplicated fd prevents the kernel from reusing the device, but if
+ * we can't get one (device already disconnected), we proceed anyway since
+ * reuse is unlikely in that case.
+ * Returns true if info was successfully prepared, false otherwise.
+ */
+static bool
+prepare_purge_path_info(struct path *pp, struct purge_path_info *info)
+{
+	if (!pp->udev || !pp->mpp)
+		return false;
+
+	info->udev = udev_device_ref(pp->udev);
+	if (!info->udev)
+		return false;
+
+	/* Try to dup the fd if available, but don't fail if we can't */
+	if (pp->fd >= 0) {
+		info->fd = dup(pp->fd);
+		if (info->fd < 0)
+			condlog(4, "%s: failed to dup fd: %s (proceeding anyway)",
+				pp->dev, strerror(errno));
+	}
+
+	return true;
+}
+
+/*
+ * Clean up purge info after use.
+ * This must be usable as a pthread cleanup handler.
+ */
+static void
+cleanup_purge_path_info(void *arg)
+{
+	struct purge_path_info *info = arg;
+
+	if (info->fd >= 0) {
+		close(info->fd);
+		info->fd = -1;
+	}
+	if (info->udev) {
+		udev_device_unref(info->udev);
+		info->udev = NULL;
+	}
+}
+
 /*
  * uev_add_path can call uev_update_path, and uev_update_path can call
  * uev_add_path
@@ -2031,6 +2127,8 @@ reinstate_path (struct path * pp)
 		condlog(0, "%s: reinstate failed", pp->dev_t);
 	else {
 		condlog(2, "%s: reinstated", pp->dev_t);
+		if (pp->purge_path)
+			pp->purge_path = false;
 		update_queue_mode_add_path(pp->mpp);
 	}
 }
@@ -2474,6 +2572,20 @@ get_new_state(struct path *pp)
 	if (newstate == PATH_REMOVED)
 		newstate = PATH_DOWN;
 
+	/*
+	 * For PATH_DISOCONNECTED mark the path as OK to purge if that is
+	 * enabled. Whether or not purge is enabled mark the path as down.
+	 */
+	if (newstate == PATH_DISCONNECTED) {
+		if (pp->mpp->purge_disconnected == PURGE_DISCONNECTED_ON &&
+		    !pp->purge_path) {
+			condlog(2, "%s: mark (%s) path for purge",
+				pp->dev, checker_state_name(newstate));
+			pp->purge_path = true;
+		}
+		newstate = PATH_DOWN;
+	}
+
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
 		condlog(2, "%s: unusable path (%s) - checker failed",
 			pp->dev, checker_state_name(newstate));
@@ -3022,6 +3134,21 @@ update_paths(struct vectors *vecs, int *num_paths_p, time_t start_secs)
 	return CHECKER_FINISHED;
 }
 
+/*
+ * Check if there are paths marked for purging.
+ */
+static bool
+has_paths_to_purge(struct vectors *vecs)
+{
+	int i;
+	struct path *pp;
+
+	vector_foreach_slot(vecs->pathvec, pp, i)
+		if (pp->purge_path)
+			return true;
+	return false;
+}
+
 static void enable_pathgroups(struct multipath *mpp)
 {
 	struct pathgroup *pgp;
@@ -3125,6 +3252,7 @@ checkerloop (void *ap)
 		int num_paths = 0, strict_timing;
 		unsigned int ticks = 0;
 		enum checker_state checker_state = CHECKER_STARTING;
+		bool devs_to_purge = false;
 
 		if (set_config_state(DAEMON_RUNNING) != DAEMON_RUNNING)
 			/* daemon shutdown */
@@ -3168,8 +3296,10 @@ checkerloop (void *ap)
 			if (checker_state == CHECKER_UPDATING_PATHS)
 				checker_state = update_paths(vecs, &num_paths,
 							     start_time.tv_sec);
-			if (checker_state == CHECKER_FINISHED)
+			if (checker_state == CHECKER_FINISHED) {
+				devs_to_purge = has_paths_to_purge(vecs);
 				checker_finished(vecs, ticks);
+			}
 			lock_cleanup_pop(vecs->lock);
 		}
 
@@ -3192,6 +3322,13 @@ checkerloop (void *ap)
 					(long)diff_time.tv_sec);
 		}
 
+		if (devs_to_purge) {
+			pthread_mutex_lock(&purge_mutex);
+			devices_to_purge = 1;
+			pthread_cond_signal(&purge_cond);
+			pthread_mutex_unlock(&purge_mutex);
+		}
+
 		if (foreign_tick == 0) {
 			conf = get_multipath_config();
 			foreign_tick = conf->max_checkint;
@@ -3229,6 +3366,91 @@ checkerloop (void *ap)
 	return NULL;
 }
 
+/*
+ * Purge thread: removes disconnected paths by writing to sysfs.
+ *
+ * This thread is signaled by the checker thread when paths marked with
+ * purge_path=true are detected. It attempts to delete these paths by
+ * writing "1" to their SCSI device's sysfs "delete" attribute.
+ *
+ * The actual cleanup of path structures from pathvec happens asynchronously
+ * when the kernel sends a remove uevent (handled by uev_remove_path).
+ *
+ * To avoid holding vecs->lock for extended periods and starving other threads,
+ * this function processes one path at a time: lock -> find one path -> clear flag ->
+ * unlock -> delete -> repeat. If no paths need purging, it waits for a signal.
+ */
+static void *
+purgeloop (void *ap)
+{
+	struct vectors *vecs;
+	unsigned int i;
+	struct path *pp;
+	vecs = (struct vectors *)ap;
+
+	pthread_cleanup_push(rcu_unregister, NULL);
+	rcu_register_thread();
+	mlockall(MCL_CURRENT | MCL_FUTURE);
+
+	while (1) {
+		struct purge_path_info purge_info = { .udev = NULL, .fd = -1 };
+		bool found = false;
+
+		/*
+		 * Lock and search for one path that needs purging.
+		 * Copy the necessary info while holding the lock, then
+		 * release the lock before doing any blocking sysfs operations.
+		 */
+		pthread_cleanup_push(cleanup_lock, &vecs->lock);
+		lock(&vecs->lock);
+		pthread_testcancel();
+
+		vector_foreach_slot (vecs->pathvec, pp, i) {
+			if (!pp->purge_path)
+				continue;
+
+			/* Found a path to purge */
+			if (prepare_purge_path_info(pp, &purge_info)) {
+				pp->purge_path = false;
+				found = true;
+				condlog(2, "%s: purging disconnected path", pp->dev);
+			} else {
+				condlog(3, "%s: failed to prepare purge info", pp->dev);
+			}
+			break;
+		}
+
+		lock_cleanup_pop(vecs->lock);
+
+		/*
+		 * Now we've released the lock. Do the sysfs operation
+		 * without holding vecs->lock. This may block.
+		 * Use pthread_cleanup_push to ensure purge_info is cleaned up
+		 * even if the thread is cancelled.
+		 */
+		pthread_cleanup_push(cleanup_purge_path_info, &purge_info);
+		if (found)
+			delete_path_sysfs(&purge_info);
+		pthread_cleanup_pop(1);
+
+		/*
+		 * If we didn't find a path to purge, wait for signal.
+		 */
+		if (!found) {
+			pthread_mutex_lock(&purge_mutex);
+			while (!devices_to_purge) {
+				condlog(4, "purgeloop waiting for work");
+				pthread_cond_wait(&purge_cond, &purge_mutex);
+			}
+			devices_to_purge = 0;
+			pthread_mutex_unlock(&purge_mutex);
+		}
+	}
+
+	pthread_cleanup_pop(1);
+	return NULL;
+}
+
 static int
 configure (struct vectors * vecs, enum force_reload_types reload_type)
 {
@@ -3669,6 +3891,8 @@ static void cleanup_threads(void)
 
 	if (check_thr_started)
 		pthread_cancel(check_thr);
+	if (purge_thr_started)
+		pthread_cancel(purge_thr);
 	if (uevent_thr_started)
 		pthread_cancel(uevent_thr);
 	if (uxlsnr_thr_started)
@@ -3685,6 +3909,8 @@ static void cleanup_threads(void)
 
 	if (check_thr_started)
 		pthread_join(check_thr, NULL);
+	if (purge_thr_started)
+		pthread_join(purge_thr, NULL);
 	if (uevent_thr_started)
 		pthread_join(uevent_thr, NULL);
 	if (uxlsnr_thr_started)
@@ -3937,6 +4163,11 @@ child (__attribute__((unused)) void *param)
 		goto failed;
 	} else
 		check_thr_started = true;
+	if ((rc = pthread_create(&purge_thr, &misc_attr, purgeloop, vecs))) {
+		condlog(0,"failed to create purge loop thread: %d", rc);
+		goto failed;
+	} else
+		purge_thr_started = true;
 	if ((rc = pthread_create(&uevq_thr, &misc_attr, uevqloop, vecs))) {
 		condlog(0, "failed to create uevent dispatcher: %d", rc);
 		goto failed;
-- 
2.52.0

