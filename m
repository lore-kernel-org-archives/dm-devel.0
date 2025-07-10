Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228C32FCFCD
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 18:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752171073; cv=none; b=WLFtfmac1XXJANM+AakRIYqANTZXeKYPVqFGSIuo2vXdBJF/39Ukv+HMJCuQ6dxZPNa+ijG7Ag4NzBY48BMoWsi2yH/WScaOBzbEdOSt/pSGYUKwaUCciZadrUZb81NSVNhPs2vPDI3lGFEyGKiwUqYxYLsJkE2UVfpqXvoAA+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752171073; c=relaxed/simple;
	bh=lxTBaMlRPs6SABJsljAW3XLfKTBnxEBWZeAn+FhjJus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=s76gkS27fNIX/jY0aMP/ZojIF+7kWW7H91v54x3OokGgcbOhVuQ/hVHVaJW7UaL4fdyEk+gZncCOPcekJRRMTf+eyaGF2+L+fbV4twBN5aPGkuyXXyYMB7PZ4glULhouw+ctskdpX3P/fzHGPVx3L71sr9bc/CbnR+Z45Yu3XWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OuBSVyoi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OuBSVyoi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752171070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BOXRO0okhunuA5a95l3vAWlZsllUFEbyeKgBn2UtUIU=;
	b=OuBSVyoiirxGNf+IutAE+rBZo2/+CUUQGBxOEVHeKpWjrXpJoFwmFGyLca9atcSHFXnTo5
	iM29ln3I5VFes028K+ffLsP+4Fo6nYGu0dudk6hsFy7PNfBhYSWp2nNdL35oYmfTOBcwF1
	/pHxtJgSqK982LI9RSMDTz4qKQIKG48=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-252-O2LA0rzfPTesBp0TQQR1Eg-1; Thu,
 10 Jul 2025 14:11:06 -0400
X-MC-Unique: O2LA0rzfPTesBp0TQQR1Eg-1
X-Mimecast-MFC-AGG-ID: O2LA0rzfPTesBp0TQQR1Eg_1752171065
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F4181956086;
	Thu, 10 Jul 2025 18:11:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3B2E19560A3;
	Thu, 10 Jul 2025 18:11:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56AIB3JV3997843
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 14:11:03 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56AIB3lh3997842;
	Thu, 10 Jul 2025 14:11:03 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 15/15] libmpathpersist: Add safety check for preempting on key change
Date: Thu, 10 Jul 2025 14:11:00 -0400
Message-ID: <20250710181100.3997759-16-bmarzins@redhat.com>
In-Reply-To: <20250710181100.3997759-1-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FlGZY5mVUg1C7UhuYNpqiv1IW-QEQwJGldkofwVFljk_1752171065
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When a reservation key is changed from one non-zero value to another,
libmpathpersist checks if the old key is still holding the reservation,
and preempts it if it is. This was only safe if two nodes never share
the same key. If a node uses the same key as another node that is
holding the reservation, and switches keys so that it no longer matches,
it will end up preempting the reservation. This is clearly unexpected
behavior, and it can come about by a simple accident of registering a
device with the wrong key, and then immediately fixing it.

To handle this, add code to track if a device is the reservation holder
to multipathd. multipathd now has three new commands "getprhold",
"setprhold", and "unsetprhold". These commands work like the equivalent
*prstatus commands. libmpathpersist calls setprhold on RESERVE commands
and PREEMPT commands when the preempted key is holding the reservation
and unsetprhold on RELEASE commands. Also, calling unsetprflag causes
prhold to be unset as well, so CLEAR commands and REGISTER commands with
a 0x0 service action key will also unset prhold. libmpathpersist() will
also unset prhold if it notices that the device cannot be holding a
reservation in preempt_missing_path().

When a new multipath device is created, its initial prhold state is
PR_UNKNOWN until it checks the current reservation, just like with
prflag. If multipathd ever finds that a device's registration has been
preempted or cleared in update_map_pr(), it unsets prhold, just like
with prflag.

Now, before libmpathpersist preempts a reservation when changing keys
it also checks if multipathd thinks that the device is holding
the reservation. If it does not, then libmpathpersist won't preempt
the key. It will assume that another node is holding the reservation
with the same key.

I should note that this safety check only stops a node not holding the
reservation from preempting the node holding the reservation. If the
node holding the reservation changes its key, but it fails to change the
resevation key, because that path is down or gone, it will still issue
the preempt to move the reservation to a usable path, even if another
node is using the same key. This will remove the registrations for that
other node. It also will not work correctly if multipathd stops tracking
a device for some reason. It's only a best-effort safety check.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 87 ++++++++++++++++++++++++-----
 libmpathpersist/mpath_updatepr.c    | 19 ++++++-
 libmpathpersist/mpathpr.h           |  2 +
 libmultipath/structs.h              |  1 +
 multipathd/callbacks.c              |  3 +
 multipathd/cli.c                    |  4 +-
 multipathd/cli.h                    |  3 +
 multipathd/cli_handlers.c           | 48 ++++++++++++++++
 multipathd/main.c                   | 33 ++++++++++-
 9 files changed, 182 insertions(+), 18 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index ae0defc2..91f0d018 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -260,6 +260,10 @@ static int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope
  * holding the reservation on a path that couldn't get its key updated,
  * either because it is down or no longer part of the multipath device,
  * you need to preempt the reservation to a usable path with the new key
+ *
+ * Also, it's possible that the reservation was preempted, and the device
+ * is being re-registered. If it appears that is the case, clear
+ * mpp->prhold in multipathd.
  */
 void preempt_missing_path(struct multipath *mpp, uint8_t *key, uint8_t *sa_key,
 			  int noisy)
@@ -272,12 +276,19 @@ void preempt_missing_path(struct multipath *mpp, uint8_t *key, uint8_t *sa_key,
 	int status;
 
 	/*
-	 * If you previously didn't have a key registered or you didn't
-	 * switch to a different key, there's no need to preempt. Also, you
-	 * can't preempt if you no longer have a registered key
+	 * If you previously didn't have a key registered, you can't
+	 * be holding the reservation. Also, you can't preempt if you
+	 * no longer have a registered key
 	 */
-	if (memcmp(key, zero, 8) == 0 || memcmp(sa_key, zero, 8) == 0 ||
-	    memcmp(key, sa_key, 8) == 0)
+	if (memcmp(key, zero, 8) == 0 || memcmp(sa_key, zero, 8) == 0) {
+		update_prhold(mpp->alias, false);
+		return;
+	}
+	/*
+	 * If you didn't switch to a different key, there is no need to
+	 * preempt.
+	 */
+	if (memcmp(key, sa_key, 8) == 0)
 		return;
 
 	status = mpath_prin_activepath(mpp, MPATH_PRIN_RRES_SA, &resp, noisy);
@@ -286,13 +297,29 @@ void preempt_missing_path(struct multipath *mpp, uint8_t *key, uint8_t *sa_key,
 		return;
 	}
 	/* If there is no reservation, there's nothing to preempt */
-	if (!resp.prin_descriptor.prin_readresv.additional_length)
+	if (!resp.prin_descriptor.prin_readresv.additional_length) {
+		update_prhold(mpp->alias, false);
 		return;
+	}
 	/*
 	 * If there reservation is not held by the old key, you don't
 	 * want to preempt it
 	 */
-	if (memcmp(key, resp.prin_descriptor.prin_readresv.key, 8) != 0)
+	if (memcmp(key, resp.prin_descriptor.prin_readresv.key, 8) != 0) {
+		/*
+		 * If reseravation key doesn't match either the old or
+		 * the new key, then clear prhold.
+		 */
+		if (memcmp(sa_key, resp.prin_descriptor.prin_readresv.key, 8) != 0)
+			update_prhold(mpp->alias, false);
+		return;
+	}
+
+	/*
+	 * If multipathd doesn't think it is holding the reservation, don't
+	 * preempt it
+	 */
+	if (get_prhold(mpp->alias) != PR_SET)
 		return;
 	/* Assume this key is being held by an inaccessable path on this
 	 * node. libmpathpersist has never worked if multiple nodes share
@@ -640,19 +667,38 @@ fail_resume:
 	return (status == MPATH_PR_RETRYABLE_ERROR) ? MPATH_PR_OTHER : status;
 }
 
+static int reservation_key_matches(struct multipath *mpp, uint8_t *key,
+				   int noisy)
+{
+	struct prin_resp resp = {0};
+	int status;
+
+	status = mpath_prin_activepath(mpp, MPATH_PRIN_RRES_SA, &resp, noisy);
+	if (status != MPATH_PR_SUCCESS) {
+		condlog(0, "%s: pr in read reservation command failed.",
+			mpp->wwid);
+		return YNU_UNDEF;
+	}
+	if (!resp.prin_descriptor.prin_readresv.additional_length)
+		return YNU_NO;
+	if (memcmp(key, resp.prin_descriptor.prin_readresv.key, 8) == 0)
+		return YNU_YES;
+	return YNU_NO;
+}
+
 /*
  * for MPATH_PROUT_REG_IGN_SA, we use the ignored paramp->key to store the
- * currently registered key.
+ * currently registered key for use in preempt_missing_path(), but only if
+ * the key is holding the reservation.
  */
 static void set_ignored_key(struct multipath *mpp, uint8_t *key)
 {
 	memset(key, 0, 8);
 	if (!get_be64(mpp->reservation_key))
 		return;
-	if (get_prflag(mpp->alias) == PR_UNSET)
+	if (get_prhold(mpp->alias) == PR_UNSET)
 		return;
-	update_map_pr(mpp, NULL);
-	if (mpp->prflag != PR_SET)
+	if (reservation_key_matches(mpp, key, 0) == YNU_NO)
 		return;
 	memcpy(key, &mpp->reservation_key, 8);
 }
@@ -665,6 +711,7 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	int ret;
 	uint64_t prkey;
 	struct config *conf;
+	bool preempting_reservation = false;
 
 	ret = mpath_get_map(curmp, pathvec, fd, &mpp);
 	if (ret != MPATH_PR_SUCCESS)
@@ -715,9 +762,12 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	case MPATH_PROUT_REG_IGN_SA:
 		ret= mpath_prout_reg(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
 		break;
-	case MPATH_PROUT_RES_SA :
-	case MPATH_PROUT_PREE_SA :
-	case MPATH_PROUT_PREE_AB_SA :
+	case MPATH_PROUT_PREE_SA:
+	case MPATH_PROUT_PREE_AB_SA:
+		if (reservation_key_matches(mpp, paramp->sa_key, noisy) == YNU_YES)
+			preempting_reservation = true;
+		/* fallthrough */
+	case MPATH_PROUT_RES_SA:
 	case MPATH_PROUT_CLEAR_SA:
 		ret = mpath_prout_common(mpp, rq_servact, rq_scope, rq_type,
 					 paramp, noisy, NULL);
@@ -744,6 +794,15 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	case MPATH_PROUT_CLEAR_SA:
 		update_prflag(mpp->alias, 0);
 		update_prkey(mpp->alias, 0);
+		break;
+	case MPATH_PROUT_RES_SA:
+	case MPATH_PROUT_REL_SA:
+		update_prhold(mpp->alias, (rq_servact == MPATH_PROUT_RES_SA));
+		break;
+	case MPATH_PROUT_PREE_SA:
+	case MPATH_PROUT_PREE_AB_SA:
+		if (preempting_reservation)
+			update_prhold(mpp->alias, 1);
 	}
 	return ret;
 }
diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index c8fbe4a2..dd8dd48e 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -75,13 +75,13 @@ static int do_update_pr(char *alias, char *cmd, char *key)
 	return ret;
 }
 
-int get_prflag(char *mapname)
+static int do_get_pr(char *mapname, const char *cmd)
 {
 	char str[256];
 	char *reply;
 	int prflag;
 
-	snprintf(str, sizeof(str), "getprstatus map %s", mapname);
+	snprintf(str, sizeof(str), "%s map %s", cmd, mapname);
 	reply = do_pr(mapname, str);
 	if (!reply)
 		prflag = PR_UNKNOWN;
@@ -96,11 +96,26 @@ int get_prflag(char *mapname)
 	return prflag;
 }
 
+int get_prflag(char *mapname)
+{
+	return do_get_pr(mapname, "getprstatus");
+}
+
+int get_prhold(char *mapname)
+{
+	return do_get_pr(mapname, "getprhold");
+}
+
 int update_prflag(char *mapname, int set) {
 	return do_update_pr(mapname, (set)? "setprstatus" : "unsetprstatus",
 			    NULL);
 }
 
+int update_prhold(char *mapname, bool set)
+{
+	return do_update_pr(mapname, (set) ? "setprhold" : "unsetprhold", NULL);
+}
+
 int update_prkey_flags(char *mapname, uint64_t prkey, uint8_t sa_flags) {
 	char str[256];
 
diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h
index 912957e5..99d6b82f 100644
--- a/libmpathpersist/mpathpr.h
+++ b/libmpathpersist/mpathpr.h
@@ -9,6 +9,8 @@
 int update_prflag(char *mapname, int set);
 int update_prkey_flags(char *mapname, uint64_t prkey, uint8_t sa_flags);
 int get_prflag(char *mapname);
+int get_prhold(char *mapname);
+int update_prhold(char *mapname, bool set);
 #define update_prkey(mapname, prkey) update_prkey_flags(mapname, prkey, 0)
 
 #endif
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 6c427d6f..97093675 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -522,6 +522,7 @@ struct multipath {
 	struct be64 reservation_key;
 	uint8_t sa_flags;
 	int prflag;
+	int prhold;
 	int all_tg_pt;
 	struct gen_multipath generic_mp;
 	bool fpin_must_reload;
diff --git a/multipathd/callbacks.c b/multipathd/callbacks.c
index fb87b280..b6b57f45 100644
--- a/multipathd/callbacks.c
+++ b/multipathd/callbacks.c
@@ -69,4 +69,7 @@ void init_handler_callbacks(void)
 	set_handler_callback(VRB_UNSETMARGINAL | Q1_PATH, HANDLER(cli_unset_marginal));
 	set_handler_callback(VRB_UNSETMARGINAL | Q1_MAP,
 			     HANDLER(cli_unset_all_marginal));
+	set_handler_callback(VRB_GETPRHOLD | Q1_MAP, HANDLER(cli_getprhold));
+	set_handler_callback(VRB_SETPRHOLD | Q1_MAP, HANDLER(cli_setprhold));
+	set_handler_callback(VRB_UNSETPRHOLD | Q1_MAP, HANDLER(cli_unsetprhold));
 }
diff --git a/multipathd/cli.c b/multipathd/cli.c
index 34588290..d0e6cebc 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -224,7 +224,9 @@ load_keys (void)
 	r += add_key(keys, "setmarginal", VRB_SETMARGINAL, 0);
 	r += add_key(keys, "unsetmarginal", VRB_UNSETMARGINAL, 0);
 	r += add_key(keys, "all", KEY_ALL, 0);
-
+	r += add_key(keys, "getprhold", VRB_GETPRHOLD, 0);
+	r += add_key(keys, "setprhold", VRB_SETPRHOLD, 0);
+	r += add_key(keys, "unsetprhold", VRB_UNSETPRHOLD, 0);
 
 	if (r) {
 		free_keys(keys);
diff --git a/multipathd/cli.h b/multipathd/cli.h
index 9fa50145..5a943a45 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -38,6 +38,9 @@ enum {
 	VRB_UNSETMARGINAL	= 23,
 	VRB_SHUTDOWN		= 24,
 	VRB_QUIT		= 25,
+	VRB_GETPRHOLD		= 26,
+	VRB_SETPRHOLD		= 27,
+	VRB_UNSETPRHOLD		= 28,
 
 	/* Qualifiers, values must be different from verbs */
 	KEY_PATH		= 65,
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index a92b07ce..34910c9b 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1314,6 +1314,10 @@ cli_unsetprstatus(void * v, struct strbuf *reply, void * data)
 		mpp->prflag = PR_UNSET;
 		condlog(2, "%s: prflag unset", param);
 	}
+	if (mpp->prhold != PR_UNSET) {
+		mpp->prhold = PR_UNSET;
+		condlog(2, "%s: prhold unset (by clearing prflag)", param);
+	}
 
 	return 0;
 }
@@ -1401,6 +1405,50 @@ cli_setprkey(void * v, struct strbuf *reply, void * data)
 	return ret;
 }
 
+static int do_prhold(struct vectors *vecs, char *param, int prhold)
+{
+	struct multipath *mpp = find_mp_by_str(vecs->mpvec, param);
+
+	if (!mpp)
+		return -ENODEV;
+
+	if (mpp->prhold != prhold) {
+		mpp->prhold = prhold;
+		condlog(2, "%s: prhold %s", param, pr_str[prhold]);
+	}
+
+	return 0;
+}
+
+static int cli_setprhold(void *v, struct strbuf *reply, void *data)
+{
+	return do_prhold((struct vectors *)data, get_keyparam(v, KEY_MAP),
+			 PR_SET);
+}
+
+static int cli_unsetprhold(void *v, struct strbuf *reply, void *data)
+{
+	return do_prhold((struct vectors *)data, get_keyparam(v, KEY_MAP),
+			 PR_UNSET);
+}
+
+static int cli_getprhold(void *v, struct strbuf *reply, void *data)
+{
+	struct multipath *mpp;
+	struct vectors *vecs = (struct vectors *)data;
+	char *param = get_keyparam(v, KEY_MAP);
+
+	param = convert_dev(param, 0);
+
+	mpp = find_mp_by_str(vecs->mpvec, param);
+	if (!mpp)
+		return -ENODEV;
+
+	append_strbuf_str(reply, pr_str[mpp->prhold]);
+	condlog(3, "%s: reply = %s", param, get_strbuf_str(reply));
+	return 0;
+}
+
 static int cli_set_marginal(void * v, struct strbuf *reply, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
diff --git a/multipathd/main.c b/multipathd/main.c
index 582af880..d22425f6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -4222,6 +4222,32 @@ main (int argc, char *argv[])
 		return (child(NULL));
 }
 
+static void check_prhold(struct multipath *mpp, struct path *pp)
+{
+	struct prin_resp resp = {0};
+	int status;
+
+	if (mpp->prflag == PR_UNSET) {
+		mpp->prhold = PR_UNSET;
+		return;
+	}
+	if (mpp->prflag != PR_SET || mpp->prhold != PR_UNKNOWN)
+		return;
+
+	status = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RRES_SA, &resp, 0);
+	if (status != MPATH_PR_SUCCESS) {
+		condlog (0, "%s: pr in read reservation command failed: %d",
+			 mpp->wwid, status);
+		return;
+	}
+	mpp->prhold = PR_UNSET;
+	if (!resp.prin_descriptor.prin_readresv.additional_length)
+		return;
+
+	if (memcmp(&mpp->reservation_key, resp.prin_descriptor.prin_readresv.key, 8) == 0)
+		mpp->prhold = PR_SET;
+}
+
 static void mpath_pr_event_handle(struct path *pp)
 {
 	struct multipath *mpp = pp->mpp;
@@ -4233,8 +4259,13 @@ static void mpath_pr_event_handle(struct path *pp)
 		return;
 	}
 
-	if (update_map_pr(mpp, pp) != MPATH_PR_SUCCESS)
+	if (update_map_pr(mpp, pp) != MPATH_PR_SUCCESS) {
+		if (mpp->prflag == PR_UNSET)
+			mpp->prhold = PR_UNSET;
 		return;
+	}
+
+	check_prhold(mpp, pp);
 
 	if (mpp->prflag != PR_SET)
 		return;
-- 
2.48.1

