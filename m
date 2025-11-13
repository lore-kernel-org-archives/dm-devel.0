Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CEB30E0C5
	for <dm-devel@lists.linux.dev>; Thu, 13 Nov 2025 18:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763059426; cv=none; b=uslCHNzNbXxvYduf3c/jGJ4vA2TUaqz6o+2SJebO6pGc37EUGiOUSDTMb+9Hmld9PBWbu6dFJdCVO3GXKhBJkD3O5PIn4ZBMfpbsZgP4mIlb5pIsDgtr4RPPopwgPcZPMabu4iwYOwZYsR19G+/shLexKmVMeBu324y1JO/DZpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763059426; c=relaxed/simple;
	bh=I3xSwzEUejXkoiSlV6dfN96lg7PZflgKPLGd/MyLme0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N8Zpy+o4aQBwKmAPw08zF+AgSPINQNFoxCgV9wModBcos3lPoItxWXhC2UntdtBTnfbhllY+O37pEnIGPYxmMOoZ0Q1yFPlTVpQ8+/9IYHRTXTH2NHaz6cHUC3TMXaDUl4TMfVK4ItT12LU+rU1/BrFYLP8ykM8i4sd3kmSlwBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=TKexwyRB; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="TKexwyRB"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b73669bdcd2so30625266b.2
        for <dm-devel@lists.linux.dev>; Thu, 13 Nov 2025 10:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1763059421; x=1763664221; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hPDSDdC2PWPeTV+uUoHJECZGg/OD+qpozitMDIaw4JU=;
        b=TKexwyRBXS6CeYLsdOvahlXjXhuzAxfOb+a49rKvb3Qxuey/rHDfr/B+9Q3ur5PSeC
         f/929h8N9g/RaUSSYPyb6r7D6KCXKO+5hONGJS6rDDFSpIxftog14uUCykzt7FDXa+Au
         7gzbLP+kfhhPwbz8pczqlskRnQJipg9D1qEkTc76Ujun+OfFdqeaPC8jOeKuxIH9qZ3a
         p6wLuHIgbEf8WVvNsDc7zgte2jp3uLC68S/G7ELSMv6C10qMZ0D2UVcFfNTKcbx/jwyp
         rJ3ZXA0uKP6+RYkEt01ZMRYy2DIZsQ5W77epilhnB7ill45P5WNTUtVo51RXSqjCHKgt
         +ptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763059421; x=1763664221;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hPDSDdC2PWPeTV+uUoHJECZGg/OD+qpozitMDIaw4JU=;
        b=svUEVMFVwPXqVtt8tF22OH0ETxNHO0Z17vT4+Oe3ZlIRYCoIZ1mQpnDgkBlu23OXgF
         y1BtL3VY0oWEm2oMEyvuanZTNfCnpE94NLFw96ZITRgQWMnY42u4xQFC+tvPmK5kbLtz
         yhmSDAqRQYqwaq3fS5w1icddNhHPYtcH1IuaGPSq/Ldt51yp99MVpBgWjX48PufIwUqb
         pLJH2lR1dn4GQxcYPuGpKQaFWJ2FFdyfFEaOkTKojgm7BO02dw2/+uVQaJl7BkZMWZ0w
         Cmqs2JyZ0go+xcwKSe3cHtOGXcJxij4+PE4wbfER/28RE4zkMuHKjKjU923MPkF8/Al9
         FQdQ==
X-Gm-Message-State: AOJu0YwH1Ratv+x4+fnfYNjag+99wHlAgqOVgBFYx8KRihGCg0ce08dQ
	1iNc1NGw4wQ9ZsIwcXzgoNkAiqNY1Io0wjgIbYhx+O3uButiC990FbcWVNHOoqwhBZgOO1iLMd7
	6M3+ULiEGyzo2g6g4mCENBFpa30zCvqnPN02sceXdhaDClkLlq6R1GJ1ysY5yiH0FVUDRI1V4Za
	EPGzO6HrAucaH3YSDDKsBdTVf1w+72Os8EJz8ULy5wQYfrosk=
X-Gm-Gg: ASbGnct+D95dXuMapl90+dw+W1L5ZvzSoYWG1BuD7+4hlMwjuDdrr5B4De4NxzO+OOe
	dusZwvceeJJ1wQTRf+UERCCBq24x8CQN5f4LAFc8IT0VYXSZ7ErR5UAci51id/n/1uDZxbUw205
	VqT6nmUN6WMfh6GF4D0ZLe0G6W5EUUd7uUQJB6PC1FJk90Peh0NhxFUKOWmpQ3sGB/F69zz2/KF
	2O4ldGdLRUaSYmkJDHl5WXx5xsNPE/KkOwopoRNxTDuPXowYrXVq4NIx5iscIz4vGP8uSTs5LMN
	uokTxVSwCo++iICG33jvY2Imfr7/GOjlCViZLU6lBhP9vYP4+/ec0AmvNVjz++Ki01vXJXIShqs
	u7o8STpB5AjRQPSqJoaVRmIQuFw5XE63i1SElrb+PMD+ahXPA05Pa8f3Xydh6Cj6vsdRZ7YRjmj
	CYj0BL+f6HknVw4neH/N7lKhqy/v64zEZhhHIUFh+IID4iWrPww4oVfTGvsJU/lsUzbBkE6AJph
	HcSCki0XbbM6TIQrQPxImU0lxSXD3PW
X-Google-Smtp-Source: AGHT+IE09JPAqHwuPqckWeIh2R5rZH0PxaJARO9L+bRbhb42am6Q0MbGYQTUsmBab3vK+rOLAdl9NA==
X-Received: by 2002:a17:907:9496:b0:b72:588:2976 with SMTP id a640c23a62f3a-b7367c02102mr24322766b.60.1763059421315;
        Thu, 13 Nov 2025 10:43:41 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([165.225.243.4])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fad4487sm221300766b.22.2025.11.13.10.43.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 13 Nov 2025 10:43:40 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH] Add purge capability to multipath-tools
Date: Thu, 13 Nov 2025 10:43:17 -0800
Message-ID: <20251113184317.55038-1-brian@purestorage.com>
X-Mailer: git-send-email 2.51.0
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
Nov 11 18:43:24 init539-33 multipathd[52046]: sdc: mark (disconnected)
path for purge
...
Nov 13 09:54:17 init539-33 multipathd[69140]: purged 8 paths, 0 failed,
0 pending in 0.125017 secs

Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
---
 libmultipath/checkers.c       |   2 +
 libmultipath/checkers.h       |   2 +
 libmultipath/checkers/tur.c   |  12 ++
 libmultipath/config.c         |   2 +
 libmultipath/config.h         |   3 +
 libmultipath/configure.c      |   1 +
 libmultipath/defaults.h       |   1 +
 libmultipath/dict.c           |  14 +++
 libmultipath/io_err_stat.c    |   1 +
 libmultipath/print.c          |   2 +
 libmultipath/propsel.c        |  16 +++
 libmultipath/propsel.h        |   1 +
 libmultipath/structs.h        |   9 ++
 multipath/multipath.conf.5.in |  21 ++++
 multipathd/main.c             | 229 +++++++++++++++++++++++++++++++++-
 15 files changed, 310 insertions(+), 6 deletions(-)

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
index 0010acf8..1bf2ca97 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -34,6 +34,7 @@ enum {
 	MSG_TUR_TIMEOUT,
 	MSG_TUR_FAILED,
 	MSG_TUR_TRANSITIONING,
+	MSG_TUR_DISCONNECTED,
 };
 
 #define IDX_(x) (MSG_ ## x - CHECKER_FIRST_MSGID)
@@ -42,6 +43,7 @@ const char *libcheck_msgtable[] = {
 	[IDX_(TUR_TIMEOUT)] = " timed out",
 	[IDX_(TUR_FAILED)] = " failed to initialize",
 	[IDX_(TUR_TRANSITIONING)] = " reports path is transitioning",
+	[IDX_(TUR_DISCONNECTED)] = " no access to this device",
 	NULL,
 };
 
@@ -199,6 +201,16 @@ retry:
 				return PATH_PENDING;
 			}
 		}
+		else if (key == 0x5) {
+			/* Illegal request */
+			if (asc == 0x25 && ascq == 0x00) {
+				/*
+				 * LOGICAL UNIT NOT SUPPORTED
+				 */
+				*msgid = MSG_TUR_DISCONNECTED;
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
index 9247e74f..bca01f41 100644
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
@@ -382,6 +388,8 @@ struct path {
 	int dmstate;
 	int chkrstate;
 	int oldstate;
+	bool purge_path;
+	int purge_retries;  /* number of purge attempts for this path */
 	int failcount;
 	int priority;
 	int pgindex;
@@ -483,6 +491,7 @@ struct multipath {
 	int ghost_delay;
 	int ghost_delay_tick;
 	int queue_mode;
+	int purge_disconnected;
 	unsigned int sync_tick;
 	int checker_count;
 	enum prio_update_type prio_update;
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 3c9ae097..1f806da8 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -1306,6 +1306,21 @@ The default is: \fBno\fR
 .
 .
 .TP
+.B purge_disconnected
+If set to
+.I yes
+, multipathd will automatically remove paths that are in the disconnected state
+by writing to the SCSI device's sysfs delete attribute. This triggers kernel-level
+device removal. Paths are retried multiple times before being forcibly cleaned up
+if the kernel removal fails. This option is useful for cleaning up stale paths
+from storage arrays that have been disconnected or removed.
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
@@ -1602,6 +1617,8 @@ section:
 .TP
 .B skip_kpartx
 .TP
+.B purge_disconnected
+.TP
 .B max_sectors_kb
 .TP
 .B ghost_delay
@@ -1797,6 +1814,8 @@ section:
 .TP
 .B skip_kpartx
 .TP
+.B purge_disconnected
+.TP
 .B max_sectors_kb
 .TP
 .B ghost_delay
@@ -1881,6 +1900,8 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .TP
 .B skip_kpartx
 .TP
+.B purge_disconnected
+.TP
 .B max_sectors_kb
 .TP
 .B ghost_delay
diff --git a/multipathd/main.c b/multipathd/main.c
index d11a8576..a07021c4 100644
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
@@ -1089,6 +1092,34 @@ check_path_wwid_change(struct path *pp)
 	return false;
 }
 
+/*
+ * Attempt to delete a path by writing to the SCSI device's sysfs delete attribute.
+ * This triggers kernel-level device removal. The actual cleanup of the path structure
+ * from pathvec happens later when a uevent arrives (handled by uev_remove_path).
+ *
+ * Returns:
+ *   true  - sysfs write succeeded, uevent expected
+ *   false - sysfs write failed or device not found
+ */
+static bool
+delete_path(struct path * pp)
+{
+	struct udev_device *ud = udev_device_get_parent_with_subsystem_devtype(pp->udev,
+		"scsi", "scsi_device");
+
+	if (ud) {
+		if (sysfs_attr_set_value(ud, "delete", "1", strlen("1")) < 0) {
+			condlog(1, "failed to remove path %s from %s",
+				pp->dev_t, pp->mpp->alias);
+			return false;
+		}
+		condlog(2, "removed path %s from %s", pp->dev_t, pp->mpp->alias);
+		pp->purge_path = false;
+		return true;
+	}
+	return false;
+}
+
 /*
  * uev_add_path can call uev_update_path, and uev_update_path can call
  * uev_add_path
@@ -2031,6 +2062,10 @@ reinstate_path (struct path * pp)
 		condlog(0, "%s: reinstate failed", pp->dev_t);
 	else {
 		condlog(2, "%s: reinstated", pp->dev_t);
+		if (pp->purge_path) {
+			pp->purge_path = false;
+			pp->purge_retries = 0;
+		}
 		update_queue_mode_add_path(pp->mpp);
 	}
 }
@@ -2474,6 +2509,20 @@ get_new_state(struct path *pp)
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
@@ -3022,6 +3071,25 @@ update_paths(struct vectors *vecs, int *num_paths_p, time_t start_secs)
 	return CHECKER_FINISHED;
 }
 
+/*
+ * Check if there are newly marked paths to purge.
+ * Only returns true for paths with purge_path=true and purge_retries=0,
+ * which indicates they were just marked for purging and haven't been
+ * attempted yet. This prevents signaling the purge thread unnecessarily
+ * for paths that are already being retried.
+ */
+static bool
+has_paths_to_purge(struct vectors *vecs)
+{
+	int i;
+	struct path *pp;
+
+	vector_foreach_slot(vecs->pathvec, pp, i)
+		if (pp->purge_path && pp->purge_retries == 0)
+			return true;
+	return false;
+}
+
 static void enable_pathgroups(struct multipath *mpp)
 {
 	struct pathgroup *pgp;
@@ -3125,6 +3193,7 @@ checkerloop (void *ap)
 		int num_paths = 0, strict_timing;
 		unsigned int ticks = 0;
 		enum checker_state checker_state = CHECKER_STARTING;
+		bool devs_to_purge = false;
 
 		if (set_config_state(DAEMON_RUNNING) != DAEMON_RUNNING)
 			/* daemon shutdown */
@@ -3168,8 +3237,10 @@ checkerloop (void *ap)
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
 
@@ -3192,6 +3263,13 @@ checkerloop (void *ap)
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
@@ -3229,6 +3307,136 @@ checkerloop (void *ap)
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
+ * If the uevent doesn't arrive or the sysfs write fails, paths will be
+ * retried on subsequent purge cycles with a timeout mechanism.
+ */
+#define PURGE_TIMEOUT_CYCLES 10  /* ~50 seconds at 5 second check intervals */
+
+static void *
+purgeloop (void *ap)
+{
+	struct vectors *vecs;
+	struct timespec diff_time, end_time, start_time;
+	unsigned int i;
+	struct path *pp;
+	vecs = (struct vectors *)ap;
+
+	pthread_cleanup_push(rcu_unregister, NULL);
+	rcu_register_thread();
+	mlockall(MCL_CURRENT | MCL_FUTURE);
+
+	while (1) {
+		int devices_purged = 0;
+		int devices_failed = 0;
+		int devices_pending = 0;
+
+		pthread_mutex_lock(&purge_mutex);
+		while (!devices_to_purge) {
+			condlog(3, "waiting on devices to purge");
+			pthread_cond_wait(&purge_cond, &purge_mutex);
+		}
+		/* Reset flag before releasing mutex to avoid race condition */
+		devices_to_purge = 0;
+		pthread_mutex_unlock(&purge_mutex);
+
+		condlog(3, "devices available for purge");
+		get_monotonic_time(&start_time);
+		pthread_cleanup_push(cleanup_lock, &vecs->lock);
+		lock(&vecs->lock);
+		pthread_testcancel();
+
+		/*
+		 * Iterate through all paths and attempt to purge those marked.
+		 * Use purge_retries as a timeout counter for failed purge attempts.
+		 */
+		vector_foreach_slot (vecs->pathvec, pp, i) {
+			if (!pp->purge_path)
+				continue;
+
+			/* Increment timeout counter for this purge attempt */
+			pp->purge_retries++;
+
+			if (delete_path(pp)) {
+				/* Success: sysfs write succeeded, uevent expected */
+				devices_purged++;
+				pp->purge_retries = 0;
+			} else if (pp->purge_retries >= PURGE_TIMEOUT_CYCLES) {
+				/*
+				 * Timeout: path couldn't be deleted after multiple attempts.
+				 * This can happen if:
+				 * - The device is no longer a SCSI device
+				 * - The sysfs interface is unavailable
+				 * - The device was already removed but no uevent arrived
+				 *
+				 * Force cleanup by removing from pathvec and freeing.
+				 */
+				condlog(1, "%s: purge timeout after %d attempts, forcing cleanup",
+					pp->dev, pp->purge_retries);
+				vector_del_slot(vecs->pathvec, i);
+				i--;  /* Adjust iterator after deletion */
+				free_path(pp);
+				devices_failed++;
+			} else {
+				/* Retry on next purge cycle */
+				devices_pending++;
+			}
+		}
+
+		lock_cleanup_pop(vecs->lock);
+
+		diff_time.tv_nsec = 0;
+		if (start_time.tv_sec) {
+			get_monotonic_time(&end_time);
+			timespecsub(&end_time, &start_time, &diff_time);
+			if (devices_purged > 0 || devices_failed > 0) {
+				condlog(2, "purged %d path%s, %d failed, %d pending in %ld.%06lu secs",
+					devices_purged, devices_purged > 1 ? "s" : "",
+					devices_failed, devices_pending,
+					(long)diff_time.tv_sec,
+					diff_time.tv_nsec / 1000);
+			}
+		}
+
+		/*
+		 * If there are still paths pending purge, sleep for the checker
+		 * cycle interval before retrying. This prevents spinning and
+		 * ensures the ~5 second retry interval mentioned in PURGE_TIMEOUT_CYCLES.
+		 * We sleep outside the mutex to allow the checker thread to signal
+		 * us if new paths are marked for purge.
+		 */
+		if (devices_pending > 0) {
+			struct timespec wait_time;
+			struct config *conf;
+
+			conf = get_multipath_config();
+			wait_time.tv_sec = conf->checkint;
+			wait_time.tv_nsec = 0;
+			put_multipath_config(conf);
+
+			condlog(3, "sleeping %ld seconds before purge retry",
+				(long)wait_time.tv_sec);
+			nanosleep(&wait_time, NULL);
+
+			/* Signal ourselves to process the pending paths */
+			pthread_mutex_lock(&purge_mutex);
+			devices_to_purge = 1;
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
@@ -3669,6 +3877,8 @@ static void cleanup_threads(void)
 
 	if (check_thr_started)
 		pthread_cancel(check_thr);
+	if (purge_thr_started)
+		pthread_cancel(purge_thr);
 	if (uevent_thr_started)
 		pthread_cancel(uevent_thr);
 	if (uxlsnr_thr_started)
@@ -3685,6 +3895,8 @@ static void cleanup_threads(void)
 
 	if (check_thr_started)
 		pthread_join(check_thr, NULL);
+	if (purge_thr_started)
+		pthread_join(purge_thr, NULL);
 	if (uevent_thr_started)
 		pthread_join(uevent_thr, NULL);
 	if (uxlsnr_thr_started)
@@ -3937,6 +4149,11 @@ child (__attribute__((unused)) void *param)
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
2.51.0

