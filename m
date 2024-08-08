Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11363190675
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130835; cv=none; b=Dsv97KfeXyee/2+xFkptD0UAAxnjfImG7FCqBFufcrfB/UL4ylmAujw55cOMgIdJDaXtyy0JeN9Wch8BaOA8uY3K9fZ/dO2ccMfz/DYT9Acx1c3HHCthD7eM3xnLPfK1DF92+dwhvIB4psblsKubhEjDYNqzN5eYndAuoRUeBPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130835; c=relaxed/simple;
	bh=aCnLxAZJrxFK8csJsnDeMeLisoxPEm59hZVEOuPr8bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPdVmMuPnkDjSMxiWtPnZ6H7eM6/jBlopD6+RVz41iR2wFriNpXzZx4a2GoYmdyzCoWtTLafJSnMaZHK8JKOUBIteBhl1V1voIwjtXWRvNiJv4Rluuf8GRbWWSYWUJtsgvQ6x5CCED09M52np0vRVUhrMvrx/s7TmMP9wYzNvVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eneoJjcy; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eneoJjcy"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5a10835487fso1474074a12.1
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130831; x=1723735631; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/8aM4huH9AEwE4yZ99m5usL/kiMBP+AqpRKwQr45UVg=;
        b=eneoJjcyNllpR9RyYKfgdw3IiVuV7CTU8aLw/zq1DwMlBj96r9q5NYwLnCvUuqfSYD
         uUCP+RFT1q1FR+OvYtjta/pNMMYWpOOBA9AlXUq5mLJU4RwVcMaGrwNeWOX2C5QubyyX
         rmBoEqKEaAWsWeB2sCB/rTXxMsMcMNTn1yUTW31fX/BdqMwQSdj9GBIRyAbaoekukgqH
         RY5wOuQKkYSHwzpL1RN3E5oN/++kylgdTFlB2HiG5Pb1wBsbg+K0ed2nuqJ+VcTxHQNG
         pjRqb8O0r3CxFVG8pkpgXMa14Gi/GBhMBrh1vCp4HUCHdTjxgvEIwtGU8wo9uxDKGe2U
         IIlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130831; x=1723735631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/8aM4huH9AEwE4yZ99m5usL/kiMBP+AqpRKwQr45UVg=;
        b=Encj9vmXGPPHsheZipcEG56eqp6UHHznjcaJHzzx9QSSMCMJxfzekHmbSTnA5X6eS0
         FCTED3b+yVris3DgoHCNo1FUsb0x+TrvJ4+xY48BG+pvBf19NeAifBsoH3Tpddb8imyQ
         t94H9rOJfjNZCbnS2bnJ4eXlZSbyRc2RBn2NbMW4h0exGC5mNQDFZHyOEUhWX7LlN8fQ
         Rxz8cDmqZpACKrXpGTDXrYTS5up1zhXrcPkFg7kTIrPXluPn4iXkSWgWoD49Xu6bD6Ty
         voBf/S3H4jaWgUtUnRjM65ENk9ky1odCDNlCZ78d85qnxGghY4Xul7lQzLdIbZdP6jNo
         hCtw==
X-Gm-Message-State: AOJu0Yz6KTYgZZhhpeQO34d7A3bON9aqR/7UrmsZNHC3n4FwKIt/0pzQ
	m2dD//HAn5hHrxVYKdPk2VlfNCGPejyLLUMyU1ZybxHF6yiZcvavCXuGQMASNq4=
X-Google-Smtp-Source: AGHT+IH7iTQ1l6QGddRYKcEz3KlKrGjTCH+kpDKXVB0345pq8b062mrza0VsC7LaegQYBp49St2/wg==
X-Received: by 2002:a17:907:3e20:b0:a6f:586b:6c2 with SMTP id a640c23a62f3a-a8090f02e01mr184419866b.60.1723130831139;
        Thu, 08 Aug 2024 08:27:11 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9e8676fsm746555566b.164.2024.08.08.08.27.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:27:10 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 36/41] libdmmp: rename non-static functions starting with underscore
Date: Thu,  8 Aug 2024 17:26:15 +0200
Message-ID: <20240808152620.93965-37-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libdmmp/libdmmp.c         | 10 +++++-----
 libdmmp/libdmmp_misc.c    |  4 ++--
 libdmmp/libdmmp_mp.c      | 12 ++++++------
 libdmmp/libdmmp_path.c    |  8 ++++----
 libdmmp/libdmmp_pg.c      | 16 ++++++++--------
 libdmmp/libdmmp_private.h | 24 ++++++++++++------------
 6 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
index 47f5b53..8b9686a 100644
--- a/libdmmp/libdmmp.c
+++ b/libdmmp/libdmmp.c
@@ -86,9 +86,9 @@ _dmmp_getter_func_gen(dmmp_last_error_msg, struct dmmp_context, ctx,
 		      last_err_msg, const char *);
 
 _dmmp_array_free_func_gen(dmmp_mpath_array_free, struct dmmp_mpath,
-			  _dmmp_mpath_free);
+			  dmmp_mpath_free);
 
-void _dmmp_log(struct dmmp_context *ctx, int priority, const char *file,
+void dmmp_log(struct dmmp_context *ctx, int priority, const char *file,
 	       int line, const char *func_name, const char *format, ...)
 {
 	va_list args;
@@ -113,7 +113,7 @@ struct dmmp_context *dmmp_context_new(void)
 	if (ctx == NULL)
 		return NULL;
 
-	ctx->log_func = _dmmp_log_stderr;
+	ctx->log_func = dmmp_log_stderr;
 	ctx->log_priority = DMMP_LOG_PRIORITY_DEFAULT;
 	ctx->userdata = NULL;
 	ctx->tmo = DEFAULT_UXSOCK_TIMEOUT;
@@ -250,10 +250,10 @@ int dmmp_mpath_array_get(struct dmmp_context *ctx,
 			goto out;
 		}
 
-		dmmp_mp = _dmmp_mpath_new();
+		dmmp_mp = dmmp_mpath_new();
 		_dmmp_alloc_null_check(ctx, dmmp_mp, rc, out);
 		(*dmmp_mps)[i] = dmmp_mp;
-		_good(_dmmp_mpath_update(ctx, dmmp_mp, j_obj_map), rc, out);
+		_good(dmmp_mpath_update(ctx, dmmp_mp, j_obj_map), rc, out);
 	}
 
 out:
diff --git a/libdmmp/libdmmp_misc.c b/libdmmp/libdmmp_misc.c
index 51c71cd..92bbf8d 100644
--- a/libdmmp/libdmmp_misc.c
+++ b/libdmmp/libdmmp_misc.c
@@ -31,7 +31,7 @@
 #include "libdmmp_private.h"
 
 #define DMMP_LOG_STRERR_ALIGN_WIDTH	80
-/* ^ Only used in _dmmp_log_stderr() for pretty log output.
+/* ^ Only used in dmmp_log_stderr() for pretty log output.
  *   When provided log message is less than 80 bytes, fill it with space, then
  *   print code file name, function name, line after the 80th bytes.
  */
@@ -62,7 +62,7 @@ static const struct _num_str_conv _DMMP_PRI_CONV[] = {
 };
 _dmmp_str_func_gen(dmmp_log_priority_str, int, priority, _DMMP_PRI_CONV);
 
-void _dmmp_log_stderr(struct dmmp_context *ctx, int priority,
+void dmmp_log_stderr(struct dmmp_context *ctx, int priority,
 		      const char *file, int line, const char *func_name,
 		      const char *format, va_list args)
 {
diff --git a/libdmmp/libdmmp_mp.c b/libdmmp/libdmmp_mp.c
index bc48d0e..1be8ba1 100644
--- a/libdmmp/libdmmp_mp.c
+++ b/libdmmp/libdmmp_mp.c
@@ -44,7 +44,7 @@ _dmmp_getter_func_gen(dmmp_mpath_wwid_get, struct dmmp_mpath, dmmp_mp,
 _dmmp_getter_func_gen(dmmp_mpath_kdev_name_get, struct dmmp_mpath, dmmp_mp,
 		      kdev_name, const char *);
 
-struct dmmp_mpath *_dmmp_mpath_new(void)
+struct dmmp_mpath *dmmp_mpath_new(void)
 {
 	struct dmmp_mpath *dmmp_mp = NULL;
 
@@ -59,7 +59,7 @@ struct dmmp_mpath *_dmmp_mpath_new(void)
 	return dmmp_mp;
 }
 
-int _dmmp_mpath_update(struct dmmp_context *ctx, struct dmmp_mpath *dmmp_mp,
+int dmmp_mpath_update(struct dmmp_context *ctx, struct dmmp_mpath *dmmp_mp,
 		       json_object *j_obj_map)
 {
 	int rc = DMMP_OK;
@@ -113,10 +113,10 @@ int _dmmp_mpath_update(struct dmmp_context *ctx, struct dmmp_mpath *dmmp_mp,
 		dmmp_mp->dmmp_pgs[i] = NULL;
 
 	for (i = 0; i < dmmp_mp->dmmp_pg_count; ++i) {
-		dmmp_pg = _dmmp_path_group_new();
+		dmmp_pg = dmmp_path_group_new();
 		_dmmp_alloc_null_check(ctx, dmmp_pg, rc, out);
 		dmmp_mp->dmmp_pgs[i] = dmmp_pg;
-		_good(_dmmp_path_group_update(ctx, dmmp_pg,
+		_good(dmmp_path_group_update(ctx, dmmp_pg,
 					      array_list_get_idx(ar_pgs, i)),
 		      rc, out);
 	}
@@ -126,11 +126,11 @@ int _dmmp_mpath_update(struct dmmp_context *ctx, struct dmmp_mpath *dmmp_mp,
 
 out:
 	if (rc != DMMP_OK)
-		_dmmp_mpath_free(dmmp_mp);
+		dmmp_mpath_free(dmmp_mp);
 	return rc;
 }
 
-void _dmmp_mpath_free(struct dmmp_mpath *dmmp_mp)
+void dmmp_mpath_free(struct dmmp_mpath *dmmp_mp)
 {
 	if (dmmp_mp == NULL)
 		return ;
diff --git a/libdmmp/libdmmp_path.c b/libdmmp/libdmmp_path.c
index 0650f8d..96a96f4 100644
--- a/libdmmp/libdmmp_path.c
+++ b/libdmmp/libdmmp_path.c
@@ -59,7 +59,7 @@ _dmmp_getter_func_gen(dmmp_path_blk_name_get, struct dmmp_path, dmmp_p,
 _dmmp_getter_func_gen(dmmp_path_status_get, struct dmmp_path, dmmp_p,
 		      status, uint32_t);
 
-struct dmmp_path *_dmmp_path_new(void)
+struct dmmp_path *dmmp_path_new(void)
 {
 	struct dmmp_path *dmmp_p = NULL;
 
@@ -72,7 +72,7 @@ struct dmmp_path *_dmmp_path_new(void)
 	return dmmp_p;
 }
 
-int _dmmp_path_update(struct dmmp_context *ctx, struct dmmp_path *dmmp_p,
+int dmmp_path_update(struct dmmp_context *ctx, struct dmmp_path *dmmp_p,
 		      json_object *j_obj_p)
 {
 	int rc = DMMP_OK;
@@ -102,11 +102,11 @@ int _dmmp_path_update(struct dmmp_context *ctx, struct dmmp_path *dmmp_p,
 
 out:
 	if (rc != DMMP_OK)
-		_dmmp_path_free(dmmp_p);
+		dmmp_path_free(dmmp_p);
 	return rc;
 }
 
-void _dmmp_path_free(struct dmmp_path *dmmp_p)
+void dmmp_path_free(struct dmmp_path *dmmp_p)
 {
 	if (dmmp_p == NULL)
 		return;
diff --git a/libdmmp/libdmmp_pg.c b/libdmmp/libdmmp_pg.c
index 42e87fe..68f1917 100644
--- a/libdmmp/libdmmp_pg.c
+++ b/libdmmp/libdmmp_pg.c
@@ -67,10 +67,10 @@ _dmmp_getter_func_gen(dmmp_path_group_priority_get, struct dmmp_path_group,
 _dmmp_getter_func_gen(dmmp_path_group_selector_get, struct dmmp_path_group,
 		      dmmp_pg, selector, const char *);
 _dmmp_array_free_func_gen(_dmmp_path_group_array_free, struct dmmp_path_group,
-			  _dmmp_path_group_free);
+			  dmmp_path_group_free);
 
 
-struct dmmp_path_group *_dmmp_path_group_new(void)
+struct dmmp_path_group *dmmp_path_group_new(void)
 {
 	struct dmmp_path_group *dmmp_pg = NULL;
 
@@ -87,7 +87,7 @@ struct dmmp_path_group *_dmmp_path_group_new(void)
 	}
 	return dmmp_pg;
 }
-int _dmmp_path_group_update(struct dmmp_context *ctx,
+int dmmp_path_group_update(struct dmmp_context *ctx,
 			    struct dmmp_path_group *dmmp_pg,
 			    json_object *j_obj_pg)
 {
@@ -157,10 +157,10 @@ int _dmmp_path_group_update(struct dmmp_context *ctx,
 		dmmp_pg->dmmp_ps[i] = NULL;
 
 	for (i = 0; i < dmmp_pg->dmmp_p_count; ++i) {
-		dmmp_p = _dmmp_path_new();
+		dmmp_p = dmmp_path_new();
 		_dmmp_alloc_null_check(ctx, dmmp_p, rc, out);
 		dmmp_pg->dmmp_ps[i] = dmmp_p;
-		_good(_dmmp_path_update(ctx, dmmp_p,
+		_good(dmmp_path_update(ctx, dmmp_p,
 					array_list_get_idx(ar_ps, i)),
 		      rc, out);
 	}
@@ -173,11 +173,11 @@ int _dmmp_path_group_update(struct dmmp_context *ctx,
 
 out:
 	if (rc != DMMP_OK)
-		_dmmp_path_group_free(dmmp_pg);
+		dmmp_path_group_free(dmmp_pg);
 	return rc;
 }
 
-void _dmmp_path_group_free(struct dmmp_path_group *dmmp_pg)
+void dmmp_path_group_free(struct dmmp_path_group *dmmp_pg)
 {
 	uint32_t i = 0;
 
@@ -188,7 +188,7 @@ void _dmmp_path_group_free(struct dmmp_path_group *dmmp_pg)
 
 	if (dmmp_pg->dmmp_ps != NULL) {
 		for (i = 0; i < dmmp_pg->dmmp_p_count; ++i) {
-			_dmmp_path_free(dmmp_pg->dmmp_ps[i]);
+			dmmp_path_free(dmmp_pg->dmmp_ps[i]);
 		}
 		free(dmmp_pg->dmmp_ps);
 	}
diff --git a/libdmmp/libdmmp_private.h b/libdmmp/libdmmp_private.h
index 0c497b3..d154146 100644
--- a/libdmmp/libdmmp_private.h
+++ b/libdmmp/libdmmp_private.h
@@ -110,33 +110,33 @@ do { \
 DMMP_DLL_LOCAL int _dmmp_ipc_exec(struct dmmp_context *ctx, const char *cmd,
 				  char **output);
 
-DMMP_DLL_LOCAL struct dmmp_mpath *_dmmp_mpath_new(void);
-DMMP_DLL_LOCAL struct dmmp_path_group *_dmmp_path_group_new(void);
-DMMP_DLL_LOCAL struct dmmp_path *_dmmp_path_new(void);
+DMMP_DLL_LOCAL struct dmmp_mpath *dmmp_mpath_new(void);
+DMMP_DLL_LOCAL struct dmmp_path_group *dmmp_path_group_new(void);
+DMMP_DLL_LOCAL struct dmmp_path *dmmp_path_new(void);
 
-DMMP_DLL_LOCAL int _dmmp_mpath_update(struct dmmp_context *ctx,
+DMMP_DLL_LOCAL int dmmp_mpath_update(struct dmmp_context *ctx,
 				      struct dmmp_mpath *dmmp_mp,
 				      json_object *j_obj_map);
-DMMP_DLL_LOCAL int _dmmp_path_group_update(struct dmmp_context *ctx,
+DMMP_DLL_LOCAL int dmmp_path_group_update(struct dmmp_context *ctx,
 					   struct dmmp_path_group *dmmp_pg,
 					   json_object *j_obj_pg);
-DMMP_DLL_LOCAL int _dmmp_path_update(struct dmmp_context *ctx,
+DMMP_DLL_LOCAL int dmmp_path_update(struct dmmp_context *ctx,
 				     struct dmmp_path *dmmp_p,
 				     json_object *j_obj_p);
 
-DMMP_DLL_LOCAL void _dmmp_mpath_free(struct dmmp_mpath *dmmp_mp);
-DMMP_DLL_LOCAL void _dmmp_path_group_free(struct dmmp_path_group *dmmp_pg);
+DMMP_DLL_LOCAL void dmmp_mpath_free(struct dmmp_mpath *dmmp_mp);
+DMMP_DLL_LOCAL void dmmp_path_group_free(struct dmmp_path_group *dmmp_pg);
 DMMP_DLL_LOCAL void _dmmp_path_group_array_free
 	(struct dmmp_path_group **dmmp_pgs, uint32_t dmmp_pg_count);
-DMMP_DLL_LOCAL void _dmmp_path_free(struct dmmp_path *dmmp_p);
-DMMP_DLL_LOCAL void _dmmp_log(struct dmmp_context *ctx, int priority,
+DMMP_DLL_LOCAL void dmmp_path_free(struct dmmp_path *dmmp_p);
+DMMP_DLL_LOCAL void dmmp_log(struct dmmp_context *ctx, int priority,
 			      const char *file, int line,
 			      const char *func_name,
 			      const char *format, ...)
 	__attribute__((format(printf, 6, 7)));
 DMMP_DLL_LOCAL void _dmmp_log_err_str(struct dmmp_context *ctx, int rc);
 
-DMMP_DLL_LOCAL void _dmmp_log_stderr(struct dmmp_context *ctx, int priority,
+DMMP_DLL_LOCAL void dmmp_log_stderr(struct dmmp_context *ctx, int priority,
 				     const char *file, int line,
 				     const char *func_name, const char *format,
 				     va_list args)
@@ -146,7 +146,7 @@ DMMP_DLL_LOCAL void _dmmp_log_stderr(struct dmmp_context *ctx, int priority,
 #define _dmmp_log_cond(ctx, prio, arg...) \
 	do { \
 		if (dmmp_context_log_priority_get(ctx) >= prio) \
-			_dmmp_log(ctx, prio, __FILE__, __LINE__, __FUNCTION__, \
+			dmmp_log(ctx, prio, __FILE__, __LINE__, __FUNCTION__, \
 				  ## arg); \
 	} while (0)
 
-- 
2.46.0

