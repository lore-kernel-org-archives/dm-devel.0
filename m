Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD963093A8
	for <dm-devel@lists.linux.dev>; Mon, 15 Dec 2025 20:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765830611; cv=none; b=cWxarZoVXmERF4VJUB/S5uQCTDw9BKYm9C4SV+pfkAqxPeFcwT/3mYDoVgj3t2WTITEG6J/t+dY4VQTytxt8OWLGkGqj6O+IPUK31RsP6U51eRQNrX3OyRpqg/eeyNcjdttth1FWn/sKs3pb2VKx/YMX6Ii2yetXDgb0X+W1b9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765830611; c=relaxed/simple;
	bh=7j9QRFyb4Urh27XjjNli05G98E7GbVchxfTWiRSCp4k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=MAxQR5y2koSYM1YJqa9q2TcWphSWxAiuQOlS1tEZfTs7fAHgJvmICeT44xr0fwhAyd9cM3y2tQnoc1MydWfckD2byz3EP9H91su/tJnNE1ppKGRg5/JMgpBcRs5uuErIh8eOc60ukMUxTRqYXj/iZvkyEVNivWPn4oddEl6/FTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XzbyADJF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XzbyADJF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765830606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D18uHcrnYwW3NWOpfRE3q7IQdxhirjrNryKUbIYY5lI=;
	b=XzbyADJFsIoz79YBa2EFzktX9E88ZsQcwL2cHF6V8qBCqL2wqxsuzuuctBlBb04jiaFqjv
	E10IhQKPgzEw2WGCYHlCojLanPJU4jYgCaDJWDDhKtSa49lgW5Vv6C2ECZWZZ+AwFaNhGs
	f/o5yRZRIAJ/rbcvLVpc73JHKfaDQag=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-472-iaXBhG6pMoq3lhs2ylwpRg-1; Mon,
 15 Dec 2025 15:30:02 -0500
X-MC-Unique: iaXBhG6pMoq3lhs2ylwpRg-1
X-Mimecast-MFC-AGG-ID: iaXBhG6pMoq3lhs2ylwpRg_1765830601
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD7A31955DC6;
	Mon, 15 Dec 2025 20:30:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5240B30001A2;
	Mon, 15 Dec 2025 20:30:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BFKTxBd1995905
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Dec 2025 15:29:59 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BFKTw4O1995904;
	Mon, 15 Dec 2025 15:29:58 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v3] libmpathpersist: fix code for skipping multipathd path registration
Date: Mon, 15 Dec 2025 15:29:58 -0500
Message-ID: <20251215202958.1995896-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6Yxlmun5e6J0Q4xFte6DM-YPEdi40f8LR1d-mdMvwik_1765830601
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When libmpathpersist notifies multipathd that a key has been registered,
cli_setprstatus() calls pr_register_active_paths() with a flag to let it
know that the paths are likely already registered, and it can skip
re-registering them, as long as the number of active paths matches the
number of registered keys. This shortcut can fail, causing multipathd to
not register needed paths, if either a path becomes usable and another
becomes unusable while libmpathpersist is running or if there already
were registered keys for I_T Nexus's that don't correspond to path
devices.

To make this shortcut work in cases like that, this commit adds a new
multipathd command "setprstatus map <map> pathlist <pathlist>", where
<pathlist> is a quoted, whitespace separated list of scsi path devices.
libmpathpersist will send out the list of paths it registered the key
on. pr_register_active_paths() will skip calling mpath_pr_event_handle()
for paths on that list.

In order to deal with the possiblity of a preempt occuring while
libmpathpersist was running, the code still needs to check that it has
the expected number of keys.

Fixes: f7d6cd17 ("multipathd: Fix race while registering PR key")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

Changes in v3:
- make pathlist in be a list of dev_t devices in update_prflag() and
  pr_register_active_paths()
- Add automatic cleanup for the registered_paths vector in
  cli_setprstatus_list() using cleanup_reset_vec()
- fixed formatting issues.

Changes in v2:
- added a semi-colon after the "skip" label to make clang happy.

v1 was patch 4/4 of "multipath-tools: Yet Another PR fix"

 libmpathpersist/mpath_persist_int.c |  6 +--
 libmpathpersist/mpath_updatepr.c    | 47 ++++++++++++++++-----
 libmpathpersist/mpathpr.h           |  4 +-
 multipathd/callbacks.c              |  2 +
 multipathd/cli.c                    |  1 +
 multipathd/cli.h                    |  2 +
 multipathd/cli_handlers.c           | 35 ++++++++++++++--
 multipathd/main.c                   | 63 +++++++++++++++++++----------
 multipathd/main.h                   |  4 +-
 multipathd/multipathd.8.in          |  6 +++
 10 files changed, 129 insertions(+), 41 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 91c53419..14f7ba83 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -1001,12 +1001,12 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	case MPATH_PROUT_REG_SA:
 	case MPATH_PROUT_REG_IGN_SA:
 		if (unregistering)
-			update_prflag(mpp->alias, 0);
+			update_prflag(mpp, 0);
 		else
-			update_prflag(mpp->alias, 1);
+			update_prflag(mpp, 1);
 		break;
 	case MPATH_PROUT_CLEAR_SA:
-		update_prflag(mpp->alias, 0);
+		update_prflag(mpp, 0);
 		if (mpp->prkey_source == PRKEY_SOURCE_FILE)
 			update_prkey(mpp->alias, 0);
 		break;
diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index bd8ed2be..c925dced 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -20,8 +20,9 @@
 #include "uxsock.h"
 #include "mpathpr.h"
 #include "structs.h"
+#include "strbuf.h"
 
-static char *do_pr(char *alias, char *str)
+static char *do_pr(char *alias, const char *str)
 {
 	int fd;
 	char *reply;
@@ -51,24 +52,26 @@ static char *do_pr(char *alias, char *str)
 	return reply;
 }
 
-static int do_update_pr(char *alias, char *cmd, char *key)
+static int do_update_pr(char *alias, char *cmd, const char *data)
 {
-	char str[256];
+	STRBUF_ON_STACK(buf);
 	char *reply = NULL;
 	int ret = -1;
 
-	if (key)
-		snprintf(str, sizeof(str), "%s map %s key %s", cmd, alias, key);
+	if (data)
+		print_strbuf(&buf, "%s map %s %s %s", cmd, alias,
+			     strcmp(cmd, "setprkey") ? "pathlist" : "key", data);
 	else
-		snprintf(str, sizeof(str), "%s map %s", cmd, alias);
+		print_strbuf(&buf, "%s map %s", cmd, alias);
 
-	reply = do_pr(alias, str);
+	reply = do_pr(alias, get_strbuf_str(&buf));
 	if (reply) {
 		if (strncmp(reply, "ok", 2) == 0)
 			ret = 0;
 		else
 			ret = -1;
-		condlog(ret ? 0 : 4, "%s: message=%s reply=%s", alias, str, reply);
+		condlog(ret ? 0 : 4, "%s: message=%s reply=%s", alias,
+			get_strbuf_str(&buf), reply);
 	}
 
 	free(reply);
@@ -106,9 +109,31 @@ int get_prhold(char *mapname)
 	return do_get_pr(mapname, "getprhold");
 }
 
-int update_prflag(char *mapname, int set) {
-	return do_update_pr(mapname, (set)? "setprstatus" : "unsetprstatus",
-			    NULL);
+int update_prflag(struct multipath *mpp, int set)
+{
+	STRBUF_ON_STACK(buf);
+	int i, j;
+	bool first = true;
+	struct pathgroup *pgp = NULL;
+	struct path *pp = NULL;
+
+	if (!set)
+		return do_update_pr(mpp->alias, "unsetprstatus", NULL);
+
+	append_strbuf_str(&buf, "\"");
+	vector_foreach_slot (mpp->pg, pgp, j) {
+		vector_foreach_slot (pgp->paths, pp, i) {
+			if (pp->state == PATH_UP || pp->state == PATH_GHOST) {
+				if (first) {
+					append_strbuf_str(&buf, pp->dev);
+					first = false;
+				} else
+					print_strbuf(&buf, " %s", pp->dev_t);
+			}
+		}
+	}
+	append_strbuf_str(&buf, "\"");
+	return do_update_pr(mpp->alias, "setprstatus", get_strbuf_str(&buf));
 }
 
 int update_prhold(char *mapname, bool set)
diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h
index 99d6b82f..adbfc865 100644
--- a/libmpathpersist/mpathpr.h
+++ b/libmpathpersist/mpathpr.h
@@ -1,12 +1,14 @@
 #ifndef MPATHPR_H_INCLUDED
 #define MPATHPR_H_INCLUDED
 
+#include "structs.h"
+
 /*
  * This header file contains symbols that are only used by
  * libmpathpersist internally.
  */
 
-int update_prflag(char *mapname, int set);
+int update_prflag(struct multipath *mpp, int set);
 int update_prkey_flags(char *mapname, uint64_t prkey, uint8_t sa_flags);
 int get_prflag(char *mapname);
 int get_prhold(char *mapname);
diff --git a/multipathd/callbacks.c b/multipathd/callbacks.c
index b6b57f45..2027c3a6 100644
--- a/multipathd/callbacks.c
+++ b/multipathd/callbacks.c
@@ -59,6 +59,8 @@ void init_handler_callbacks(void)
 	set_unlocked_handler_callback(VRB_SHUTDOWN, HANDLER(cli_shutdown));
 	set_handler_callback(VRB_GETPRSTATUS | Q1_MAP, HANDLER(cli_getprstatus));
 	set_handler_callback(VRB_SETPRSTATUS | Q1_MAP, HANDLER(cli_setprstatus));
+	set_handler_callback(VRB_SETPRSTATUS | Q1_MAP | Q2_PATHLIST,
+			     HANDLER(cli_setprstatus_list));
 	set_handler_callback(VRB_UNSETPRSTATUS | Q1_MAP, HANDLER(cli_unsetprstatus));
 	set_handler_callback(VRB_FORCEQ | Q1_DAEMON, HANDLER(cli_force_no_daemon_q));
 	set_handler_callback(VRB_RESTOREQ | Q1_DAEMON, HANDLER(cli_restore_no_daemon_q));
diff --git a/multipathd/cli.c b/multipathd/cli.c
index d0e6cebc..0d679c86 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -227,6 +227,7 @@ load_keys (void)
 	r += add_key(keys, "getprhold", VRB_GETPRHOLD, 0);
 	r += add_key(keys, "setprhold", VRB_SETPRHOLD, 0);
 	r += add_key(keys, "unsetprhold", VRB_UNSETPRHOLD, 0);
+	r += add_key(keys, "pathlist", KEY_PATHLIST, 1);
 
 	if (r) {
 		free_keys(keys);
diff --git a/multipathd/cli.h b/multipathd/cli.h
index 5a943a45..3e607389 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -62,6 +62,7 @@ enum {
 	KEY_LOCAL		= 81,
 	KEY_GROUP		= 82,
 	KEY_KEY			= 83,
+	KEY_PATHLIST		= 84,
 };
 
 /*
@@ -94,6 +95,7 @@ enum {
 	Q2_LOCAL		= KEY_LOCAL << 16,
 	Q2_GROUP		= KEY_GROUP << 16,
 	Q2_KEY			= KEY_KEY << 16,
+	Q2_PATHLIST		= KEY_PATHLIST << 16,
 
 	/* byte 3: qualifier 3 */
 	Q3_FMT			= KEY_FMT << 24,
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 2812d01e..53be68df 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -31,6 +31,7 @@
 #include "foreign.h"
 #include "strbuf.h"
 #include "cli_handlers.h"
+#include <ctype.h>
 
 static struct path *
 find_path_by_str(const struct vector_s *pathvec, const char *str,
@@ -1276,8 +1277,8 @@ cli_getprstatus (void * v, struct strbuf *reply, void * data)
 	return 0;
 }
 
-static int
-cli_setprstatus(void * v, struct strbuf *reply, void * data)
+static int do_setprstatus(void *v, struct strbuf *reply, void *data,
+			  const struct vector_s *registered_paths)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -1291,7 +1292,7 @@ cli_setprstatus(void * v, struct strbuf *reply, void * data)
 
 	if (mpp->prflag != PR_SET) {
 		set_pr(mpp);
-		pr_register_active_paths(mpp, true);
+		pr_register_active_paths(mpp, registered_paths);
 		if (mpp->prflag == PR_SET)
 			condlog(2, "%s: prflag set", param);
 		else
@@ -1302,6 +1303,34 @@ cli_setprstatus(void * v, struct strbuf *reply, void * data)
 	return 0;
 }
 
+static int cli_setprstatus(void *v, struct strbuf *reply, void *data)
+{
+	return do_setprstatus(v, reply, data, NULL);
+}
+
+static int cli_setprstatus_list(void *v, struct strbuf *reply, void *data)
+{
+	int r;
+	struct vector_s registered_paths_vec = {.allocated = 0};
+	vector registered_paths
+		__attribute__((cleanup(cleanup_reset_vec))) = &registered_paths_vec;
+	char *ptr = get_keyparam(v, KEY_PATHLIST);
+
+	while (isspace(*ptr))
+		ptr++;
+	while (*ptr) {
+		if (!vector_alloc_slot(registered_paths))
+			return -ENOMEM;
+		vector_set_slot(registered_paths, ptr);
+		while (*ptr && !isspace(*ptr))
+			ptr++;
+		while (isspace(*ptr))
+			*ptr++ = '\0';
+	}
+	r = do_setprstatus(v, reply, data, registered_paths);
+	return r;
+}
+
 static int
 cli_unsetprstatus(void * v, struct strbuf *reply, void * data)
 {
diff --git a/multipathd/main.c b/multipathd/main.c
index a7650639..a5568cb0 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -630,28 +630,48 @@ flush_map_nopaths(struct multipath *mpp, struct vectors *vecs) {
 	return true;
 }
 
-void pr_register_active_paths(struct multipath *mpp, bool check_nr_active)
+/*
+ * If reg_paths in non-NULL, it is a vector of paths that libmpathpersist
+ * registered. If the number of registered keys is smaller than the number
+ * of registered paths, then likely a preempt that occurred while
+ * libmpathpersist was registering the key. As long as there are still some
+ * registered keys, treat the preempt as happening first, and make sure to
+ * register keys on all the paths. If the number of registered keys is at
+ * least as large as the number of registered paths, then no preempt happened,
+ * and multipathd does not need to re-register the paths that libmpathpersist
+ * handled
+ */
+void pr_register_active_paths(struct multipath *mpp, const struct vector_s *reg_paths)
 {
-	unsigned int i, j, nr_keys = 0;
-	unsigned int nr_active = 0;
+	unsigned int i, j, k, nr_keys = 0;
+	unsigned int wanted_nr = VECTOR_SIZE(reg_paths);
 	struct path *pp;
 	struct pathgroup *pgp;
-
-	if (check_nr_active) {
-		nr_active = count_active_paths(mpp);
-		if (!nr_active)
-			return;
-	}
+	char *pathname;
 
 	vector_foreach_slot (mpp->pg, pgp, i) {
 		vector_foreach_slot (pgp->paths, pp, j) {
 			if (mpp->prflag == PR_UNSET)
 				return;
-			if (pp->state == PATH_UP || pp->state == PATH_GHOST) {
-				nr_keys = mpath_pr_event_handle(pp, nr_keys, nr_active);
-				if (check_nr_active && nr_keys == nr_active)
-					return;
+			if (pp->state != PATH_UP && pp->state != PATH_GHOST)
+				continue;
+			if (wanted_nr && nr_keys) {
+				vector_foreach_slot (reg_paths, pathname, k) {
+					if (strcmp(pp->dev_t, pathname) == 0) {
+						goto skip;
+					}
+				}
 			}
+			nr_keys = mpath_pr_event_handle(pp, nr_keys, wanted_nr);
+			if (nr_keys && nr_keys < wanted_nr) {
+				/*
+				 * Incorrect number of registered keys. Need
+				 * to register all devices
+				 */
+				wanted_nr = 0;
+			}
+skip:
+			; /* a statement must follow a label on pre C23 clang */
 		}
 	}
 }
@@ -682,8 +702,7 @@ handle_orphaned_offline_paths(vector offline_paths)
 			pp->add_when_online = true;
 }
 
-static void
-cleanup_reset_vec(struct vector_s **v)
+void cleanup_reset_vec(struct vector_s **v)
 {
 	vector_reset(*v);
 }
@@ -739,7 +758,7 @@ fail:
 
 	sync_map_state(mpp, false);
 
-	pr_register_active_paths(mpp, false);
+	pr_register_active_paths(mpp, NULL);
 
 	if (VECTOR_SIZE(offline_paths) != 0)
 		handle_orphaned_offline_paths(offline_paths);
@@ -1413,7 +1432,7 @@ rescan:
 
 	if (retries >= 0) {
 		if ((mpp->prflag == PR_SET && prflag != PR_SET) || start_waiter)
-			pr_register_active_paths(mpp, false);
+			pr_register_active_paths(mpp, NULL);
 		condlog(2, "%s [%s]: path added to devmap %s",
 			pp->dev, pp->dev_t, mpp->alias);
 		return 0;
@@ -2658,7 +2677,7 @@ update_path_state (struct vectors * vecs, struct path * pp)
 				"reservation registration", pp->dev);
 			mpath_pr_event_handle(pp, 0, 0);
 			if (pp->mpp->prflag == PR_SET && prflag != PR_SET)
-				pr_register_active_paths(pp->mpp, false);
+				pr_register_active_paths(pp->mpp, NULL);
 		}
 
 		/*
@@ -3319,7 +3338,7 @@ configure (struct vectors * vecs, enum force_reload_types reload_type)
 	vector_foreach_slot(mpvec, mpp, i){
 		if (remember_wwid(mpp->wwid) == 1)
 			trigger_paths_udev_change(mpp, true);
-		pr_register_active_paths(mpp, false);
+		pr_register_active_paths(mpp, NULL);
 	}
 
 	/*
@@ -4370,8 +4389,8 @@ static int update_map_pr(struct multipath *mpp, struct path *pp, unsigned int *n
  *
  * nr_keys_wanted: Only used if nr_keys_needed is 0, so we don't know how
  * many keys we currently have. If nr_keys_wanted in non-zero and the
- * number of keys found by the initial call to update_map_pr() matches it,
- * exit early, since we have all the keys we are expecting.
+ * number of keys found by the initial call to update_map_pr() is at least
+ * as large as it, exit early, since we have all the keys we are expecting.
  *
  * The function returns the number of keys that are registered or 0 if
  * it's unknown.
@@ -4394,7 +4413,7 @@ mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_needed,
 		nr_keys_needed = 1;
 		if (update_map_pr(mpp, pp, &nr_keys_needed) != MPATH_PR_SUCCESS)
 			return 0;
-		if (nr_keys_wanted && nr_keys_wanted == nr_keys_needed)
+		if (nr_keys_wanted && nr_keys_wanted <= nr_keys_needed)
 			return nr_keys_needed;
 	}
 
diff --git a/multipathd/main.h b/multipathd/main.h
index 6d60ee81..b66208ec 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -54,5 +54,7 @@ int resize_map(struct multipath *mpp, unsigned long long size,
 	       struct vectors *vecs);
 void set_pr(struct multipath *mpp);
 void unset_pr(struct multipath *mpp);
-void pr_register_active_paths(struct multipath *mpp, bool check_active_nr);
+void pr_register_active_paths(struct multipath *mpp,
+			      const struct vector_s *registered_paths);
+void cleanup_reset_vec(struct vector_s **v);
 #endif /* MAIN_H_INCLUDED */
diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index 7ffb8d4c..38a243e3 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -348,6 +348,12 @@ Restores configured queue_without_daemon mode.
 Enable persistent reservation management on $map.
 .
 .TP
+.B setprstatus map|multipath $map pathlist $pathlist
+Enable persistent reservation management on $map, and notify multipathd of
+the paths that have been registered, so it doesn't attempt to re-register
+them.
+.
+.TP
 .B unsetprstatus map|multipath $map
 Disable persistent reservation management on $map.
 .
-- 
2.50.1

