Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1651E2FCE04
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 18:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752171069; cv=none; b=M+GDL/SrlwDoiOKtLIEiSm2WnPTMyeFKhhwa8ptkYQif2lZE23DV3svieNa/HLRhTJxTiQTLDcVtLAG1msdnv0EzeSj3tqtSmQ7Znubo71MhRPa4k+vdpnjFjj5wIzLkqtgs/bAuUs1nojVbNktm8Ke9bDOJUwIWbaZ1y+f8c3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752171069; c=relaxed/simple;
	bh=2RSngt8rAaW9IKkYKQ/6LTznp7JwpbQvFv3SMBrfGwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Al8H8OPlCR7RPBeV+vqj9pnsjLcqHXqp0YC6qBAyFk3utbAGfFlvLRdJWLgEX3XcOearvF909FNpMIVOfV6CMGiwOP3VBlIXmKeVsDmGMQI3zAbfluv6G64PgvsL8mYuR2kZypTYkrvQKZzymS2Zfv3zgKxoOS2t0qFB6n5Sylg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PeuEPI2B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PeuEPI2B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752171067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kOS2Pm6gCrn4l5QLaVGqEkrQkMYFpoDHp6BSPKKZ0D4=;
	b=PeuEPI2BkfHNXzPOR0C9Fmhf+TknDWctMQrTsK+3XOC2ljGyE5C+TfLsFP93dR4YRD3xag
	18JNiZxslfMIMl5JRXLqHSms6em03dObrIKzdcn7+Kqfa7nXokc/YdfcjyiTlaY2oAckdG
	3Y798R0+cwSAkixKZURaNwBtTVAaijg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-222-2c4RSnDNMUmtsYqBdfB7fQ-1; Thu,
 10 Jul 2025 14:11:05 -0400
X-MC-Unique: 2c4RSnDNMUmtsYqBdfB7fQ-1
X-Mimecast-MFC-AGG-ID: 2c4RSnDNMUmtsYqBdfB7fQ_1752171064
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1BC61808985;
	Thu, 10 Jul 2025 18:11:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6638330001A1;
	Thu, 10 Jul 2025 18:11:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56AIB3LJ3997831
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 14:11:03 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56AIB3Cf3997830;
	Thu, 10 Jul 2025 14:11:03 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 12/15] libmapthpersist: Handle REGISTER AND IGNORE changing key corner case
Date: Thu, 10 Jul 2025 14:10:57 -0400
Message-ID: <20250710181100.3997759-13-bmarzins@redhat.com>
In-Reply-To: <20250710181100.3997759-1-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fgb_PhxfKbawzyI9CiEfJMonrLzaCTVrrPa9IhCUHUM_1752171064
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When you use REGISTER to change the reservation key of a registered
multipath device, where the path holding the reservation is down,
libmpathpersist will PREEMPT the failed path to move the reservation to
a usable path, so the reservation key will be updated. However, when you
use REGISTER AND IGNORE, you don't pass in the old key, so
libmpathpersist can't use it to check against the key holding the
reservation, which is necessary to know if it needs to PREEMPT.

Since the SCSI spec says that devices must ignore any passed-in key on
REGISTER AND IGNORE, libmpathpersist can still use it to pass in the old
key value. But unlike with REGISTER, the command won't fail if device
isn't actually registered with the old key, so libmpathpersist needs to
check that itself. To do this, it calls update_map_pr() just like
multipathd does to check that the device is registered before
registering new paths.  However, libmpathpersist doesn't track the
persistent reservation state like multipathd, so it needs to ask
multipathd if it thinks the device is registered, using the "get
prstatus map <map>" command.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 20 ++++++++++
 libmpathpersist/mpath_updatepr.c    | 59 +++++++++++++++++++++--------
 libmpathpersist/mpathpr.h           |  1 +
 3 files changed, 65 insertions(+), 15 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index ca972c2b..ee9706c6 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -640,6 +640,23 @@ fail_resume:
 	return (status == MPATH_PR_RETRYABLE_ERROR) ? MPATH_PR_OTHER : status;
 }
 
+/*
+ * for MPATH_PROUT_REG_IGN_SA, we use the ignored paramp->key to store the
+ * currently registered key.
+ */
+static void set_ignored_key(struct multipath *mpp, uint8_t *key)
+{
+	memset(key, 0, 8);
+	if (!get_be64(mpp->reservation_key))
+		return;
+	if (get_prflag(mpp->alias) == PRFLAG_UNSET)
+		return;
+	update_map_pr(mpp, NULL);
+	if (mpp->prflag != PRFLAG_SET)
+		return;
+	memcpy(key, &mpp->reservation_key, 8);
+}
+
 int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 				    int rq_servact, int rq_scope, unsigned int rq_type,
 				    struct prout_param_descriptor *paramp, int noisy)
@@ -660,6 +677,9 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	select_skip_kpartx(conf, mpp);
 	put_multipath_config(conf);
 
+	if (rq_servact == MPATH_PROUT_REG_IGN_SA)
+		set_ignored_key(mpp, paramp->key);
+
 	memcpy(&prkey, paramp->sa_key, 8);
 	if (mpp->prkey_source == PRKEY_SOURCE_FILE && prkey &&
 	    (rq_servact == MPATH_PROUT_REG_IGN_SA ||
diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index 36bd777e..7cf82f50 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -19,14 +19,12 @@
 #include "config.h"
 #include "uxsock.h"
 #include "mpathpr.h"
+#include "structs.h"
 
-
-static int do_update_pr(char *alias, char *cmd, char *key)
+static char *do_pr(char *alias, char *str)
 {
 	int fd;
-	char str[256];
 	char *reply;
-	int ret = 0;
 	int timeout;
 	struct config *conf;
 
@@ -37,24 +35,35 @@ static int do_update_pr(char *alias, char *cmd, char *key)
 	fd = mpath_connect();
 	if (fd == -1) {
 		condlog (0, "ux socket connect error");
-		return -1;
+		return NULL;
 	}
 
-	if (key)
-		snprintf(str,sizeof(str),"%s map %s key %s", cmd, alias, key);
-	else
-		snprintf(str,sizeof(str),"%s map %s", cmd, alias);
 	condlog (2, "%s: pr message=%s", alias, str);
 	if (send_packet(fd, str) != 0) {
 		condlog(2, "%s: message=%s send error=%d", alias, str, errno);
 		mpath_disconnect(fd);
-		return -1;
+		return NULL;
 	}
-	ret = recv_packet(fd, &reply, timeout);
-	if (ret < 0) {
+	if (recv_packet(fd, &reply, timeout) < 0)
 		condlog(2, "%s: message=%s recv error=%d", alias, str, errno);
-		ret = -1;
-	} else {
+
+	mpath_disconnect(fd);
+	return reply;
+}
+
+static int do_update_pr(char *alias, char *cmd, char *key)
+{
+	char str[256];
+	char *reply = NULL;
+	int ret = -1;
+
+	if (key)
+		snprintf(str, sizeof(str), "%s map %s key %s", cmd, alias, key);
+	else
+		snprintf(str, sizeof(str), "%s map %s", cmd, alias);
+
+	reply = do_pr(alias, str);
+	if (reply) {
 		condlog (2, "%s: message=%s reply=%s", alias, str, reply);
 		if (reply && strncmp(reply,"ok", 2) == 0)
 			ret = 0;
@@ -63,10 +72,30 @@ static int do_update_pr(char *alias, char *cmd, char *key)
 	}
 
 	free(reply);
-	mpath_disconnect(fd);
 	return ret;
 }
 
+int get_prflag(char *mapname)
+{
+	char str[256];
+	char *reply;
+	int prflag;
+
+	snprintf(str, sizeof(str), "getprstatus map %s", mapname);
+	reply = do_pr(mapname, str);
+	if (!reply)
+		prflag = PRFLAG_UNKNOWN;
+	else if (strncmp(reply, "unset", 5) == 0)
+		prflag = PRFLAG_UNSET;
+	else if (strncmp(reply, "set", 3) == 0)
+		prflag = PRFLAG_SET;
+	else
+		prflag = PRFLAG_UNKNOWN;
+
+	free(reply);
+	return prflag;
+}
+
 int update_prflag(char *mapname, int set) {
 	return do_update_pr(mapname, (set)? "setprstatus" : "unsetprstatus",
 			    NULL);
diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h
index cc1a5673..912957e5 100644
--- a/libmpathpersist/mpathpr.h
+++ b/libmpathpersist/mpathpr.h
@@ -8,6 +8,7 @@
 
 int update_prflag(char *mapname, int set);
 int update_prkey_flags(char *mapname, uint64_t prkey, uint8_t sa_flags);
+int get_prflag(char *mapname);
 #define update_prkey(mapname, prkey) update_prkey_flags(mapname, prkey, 0)
 
 #endif
-- 
2.48.1

