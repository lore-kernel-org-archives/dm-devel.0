Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC016C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 04:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649910477;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yQpDzKZtcqQnHC2K20g7T5l2pq75GFV0MqbAxgH42F0=;
	b=PV6P/zWgdzWPl4zVtVy/j/EtWOWGwjb3t2/tiRKZRY6lyu2H1fl/27KuX0z4VZ73k/xpt1
	ZobQ6qEih4JfkGFF6U8pHw0roMH7zhPHZ0POtrpy+z/IQH713jmtUldo/ly6K/Xs0YdBxD
	qKMkQZrddXcTmwNI9/EaWk25maXo/B0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-zrf9GWj5Ogaf-Q-EzyBdow-1; Thu, 14 Apr 2022 00:27:54 -0400
X-MC-Unique: zrf9GWj5Ogaf-Q-EzyBdow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F08F1C05AF6;
	Thu, 14 Apr 2022 04:27:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 89F262166B4F;
	Thu, 14 Apr 2022 04:27:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 670991940345;
	Thu, 14 Apr 2022 04:27:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DF4E41940344
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 04:27:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C0F1B2166B1B; Thu, 14 Apr 2022 04:27:50 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7652F2166B4F;
 Thu, 14 Apr 2022 04:27:47 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 23E4Rkq7025313;
 Wed, 13 Apr 2022 23:27:46 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 23E4RjLN025312;
 Wed, 13 Apr 2022 23:27:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 13 Apr 2022 23:27:37 -0500
Message-Id: <1649910461-25263-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
References: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH v2 3/7] libmultipath: add a protocol subsection
 to multipath.conf
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Some storage arrays can be accessed using multiple protocols at the same
time.  In these cases, users may want to set path attributes
differently, depending on the protocol that the path is using. To allow
this, add a protocol subsection to the overrides section in
multipath.conf, which allows select path-specific options to be set.
This commit simply adds the subsection, and handles merging matching
entries. Future patches will make use of the section.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c | 83 ++++++++++++++++++++++++++++++++++++
 libmultipath/config.h | 10 +++++
 libmultipath/dict.c   | 99 +++++++++++++++++++++++++++++++++++++++++++
 libmultipath/print.c  | 50 ++++++++++++++++++++++
 4 files changed, 242 insertions(+)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 612941b8..5fe71562 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -237,6 +237,18 @@ const char *get_mpe_wwid(const struct _vector *mptable, const char *alias)
 	return NULL;
 }
 
+static void
+free_pctable (vector pctable)
+{
+	int i;
+	struct pcentry *pce;
+
+	vector_foreach_slot(pctable, pce, i)
+		free(pce);
+
+	vector_free(pctable);
+}
+
 void
 free_hwe (struct hwentry * hwe)
 {
@@ -282,6 +294,9 @@ free_hwe (struct hwentry * hwe)
 	if (hwe->bl_product)
 		free(hwe->bl_product);
 
+	if (hwe->pctable)
+		free_pctable(hwe->pctable);
+
 	free(hwe);
 }
 
@@ -363,6 +378,15 @@ alloc_hwe (void)
 	return hwe;
 }
 
+struct pcentry *
+alloc_pce (void)
+{
+	struct pcentry *pce = (struct pcentry *)
+				calloc(1, sizeof(struct pcentry));
+	pce->type = -1;
+	return pce;
+}
+
 static char *
 set_param_str(const char * str)
 {
@@ -396,6 +420,13 @@ set_param_str(const char * str)
 	if (!dst->s && src->s) \
 		dst->s = src->s
 
+static void
+merge_pce(struct pcentry *dst, struct pcentry *src)
+{
+	merge_num(fast_io_fail);
+	merge_num(dev_loss);
+	merge_num(eh_deadline);
+}
 
 static void
 merge_hwe (struct hwentry * dst, struct hwentry * src)
@@ -602,6 +633,51 @@ out:
 	return 1;
 }
 
+static void
+validate_pctable(struct hwentry *ovr, int idx, const char *table_desc)
+{
+	struct pcentry *pce;
+
+	if (!ovr || !ovr->pctable)
+		return;
+
+	vector_foreach_slot_after(ovr->pctable, pce, idx) {
+		if (pce->type < 0) {
+			condlog(0, "protocol section in %s missing type",
+				table_desc);
+			vector_del_slot(ovr->pctable, idx--);
+			free(pce);
+		}
+	}
+
+	if (VECTOR_SIZE(ovr->pctable) == 0) {
+		vector_free(ovr->pctable);
+		ovr->pctable = NULL;
+	}
+}
+
+static void
+merge_pctable(struct hwentry *ovr)
+{
+	struct pcentry *pce1, *pce2;
+	int i, j;
+
+	if (!ovr || !ovr->pctable)
+		return;
+
+	vector_foreach_slot(ovr->pctable, pce1, i) {
+		j = i + 1;
+		vector_foreach_slot_after(ovr->pctable, pce2, j) {
+			if (pce1->type != pce2->type)
+				continue;
+			merge_pce(pce2,pce1);
+			vector_del_slot(ovr->pctable, i--);
+			free(pce1);
+			break;
+		}
+	}
+}
+
 static void
 factorize_hwtable (vector hw, int n, const char *table_desc)
 {
@@ -750,6 +826,7 @@ process_config_dir(struct config *conf, char *dir)
 	int i, n;
 	char path[LINE_MAX];
 	int old_hwtable_size;
+	int old_pctable_size = 0;
 
 	if (dir[0] != '/') {
 		condlog(1, "config_dir '%s' must be a fully qualified path",
@@ -776,11 +853,15 @@ process_config_dir(struct config *conf, char *dir)
 			continue;
 
 		old_hwtable_size = VECTOR_SIZE(conf->hwtable);
+		old_pctable_size = conf->overrides ?
+				   VECTOR_SIZE(conf->overrides->pctable) : 0;
 		snprintf(path, LINE_MAX, "%s/%s", dir, namelist[i]->d_name);
 		path[LINE_MAX-1] = '\0';
 		process_file(conf, path);
 		factorize_hwtable(conf->hwtable, old_hwtable_size,
 				  namelist[i]->d_name);
+		validate_pctable(conf->overrides, old_pctable_size,
+				 namelist[i]->d_name);
 	}
 	pthread_cleanup_pop(1);
 }
@@ -888,6 +969,7 @@ int _init_config (const char *file, struct config *conf)
 			goto out;
 		}
 		factorize_hwtable(conf->hwtable, builtin_hwtable_size, file);
+		validate_pctable(conf->overrides, 0, file);
 	}
 
 	conf->processed_main_config = 1;
@@ -988,6 +1070,7 @@ int _init_config (const char *file, struct config *conf)
 			goto out;
 	}
 
+	merge_pctable(conf->overrides);
 	merge_mptable(conf->mptable);
 	merge_blacklist(conf->blist_devnode);
 	merge_blacklist(conf->blist_property);
diff --git a/libmultipath/config.h b/libmultipath/config.h
index c73389b5..b7bca9a8 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -40,6 +40,13 @@ enum force_reload_types {
 	FORCE_RELOAD_WEAK,
 };
 
+struct pcentry {
+	int type;
+	int fast_io_fail;
+	unsigned int dev_loss;
+	int eh_deadline;
+};
+
 struct hwentry {
 	char * vendor;
 	char * product;
@@ -85,6 +92,8 @@ struct hwentry {
 	int vpd_vendor_id;
 	int recheck_wwid;
 	char * bl_product;
+
+	vector pctable;
 };
 
 struct mpentry {
@@ -284,6 +293,7 @@ const char *get_mpe_wwid (const struct _vector *mptable, const char *alias);
 
 struct hwentry * alloc_hwe (void);
 struct mpentry * alloc_mpe (void);
+struct pcentry * alloc_pce (void);
 
 void free_hwe (struct hwentry * hwe);
 void free_hwtable (vector hwtable);
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 26cbe785..8e11fd70 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -417,6 +417,29 @@ snprint_mp_ ## option (struct config *conf, struct strbuf *buff,	\
 	return function(buff, mpe->option);				\
 }
 
+#define declare_pc_handler(option, function)				\
+static int								\
+pc_ ## option ## _handler (struct config *conf, vector strvec,		\
+			   const char *file, int line_nr)		\
+{									\
+	struct pcentry *pce;						\
+	if (!conf->overrides || !conf->overrides->pctable)		\
+		return 1;						\
+	pce = VECTOR_LAST_SLOT(conf->overrides->pctable);		\
+	if (!pce)							\
+		return 1;						\
+	return function (strvec, &pce->option, file, line_nr);		\
+}
+
+#define declare_pc_snprint(option, function)				\
+static int								\
+snprint_pc_ ## option (struct config *conf, struct strbuf *buff,	\
+		       const void *data)				\
+{									\
+	const struct pcentry *pce  = (const struct pcentry *)data;	\
+	return function(buff, pce->option);				\
+}
+
 static int checkint_handler(struct config *conf, vector strvec,
 			    const char *file, int line_nr)
 {
@@ -1046,6 +1069,8 @@ declare_ovr_handler(fast_io_fail, set_undef_off_zero)
 declare_ovr_snprint(fast_io_fail, print_undef_off_zero)
 declare_hw_handler(fast_io_fail, set_undef_off_zero)
 declare_hw_snprint(fast_io_fail, print_undef_off_zero)
+declare_pc_handler(fast_io_fail, set_undef_off_zero)
+declare_pc_snprint(fast_io_fail, print_undef_off_zero)
 
 static int
 set_dev_loss(vector strvec, void *ptr, const char *file, int line_nr)
@@ -1083,6 +1108,8 @@ declare_ovr_handler(dev_loss, set_dev_loss)
 declare_ovr_snprint(dev_loss, print_dev_loss)
 declare_hw_handler(dev_loss, set_dev_loss)
 declare_hw_snprint(dev_loss, print_dev_loss)
+declare_pc_handler(dev_loss, set_dev_loss)
+declare_pc_snprint(dev_loss, print_dev_loss)
 
 declare_def_handler(eh_deadline, set_undef_off_zero)
 declare_def_snprint(eh_deadline, print_undef_off_zero)
@@ -1090,6 +1117,8 @@ declare_ovr_handler(eh_deadline, set_undef_off_zero)
 declare_ovr_snprint(eh_deadline, print_undef_off_zero)
 declare_hw_handler(eh_deadline, set_undef_off_zero)
 declare_hw_snprint(eh_deadline, print_undef_off_zero)
+declare_pc_handler(eh_deadline, set_undef_off_zero)
+declare_pc_snprint(eh_deadline, print_undef_off_zero)
 
 static int
 set_pgpolicy(vector strvec, void *ptr, const char *file, int line_nr)
@@ -1897,6 +1926,69 @@ declare_mp_snprint(wwid, print_str)
 declare_mp_handler(alias, set_str_noslash)
 declare_mp_snprint(alias, print_str)
 
+
+static int
+protocol_handler(struct config *conf, vector strvec, const char *file,
+               int line_nr)
+{
+	struct pcentry *pce;
+
+	if (!conf->overrides)
+		return 1;
+
+	if (!conf->overrides->pctable &&
+	    !(conf->overrides->pctable = vector_alloc()))
+		return 1;
+
+	if (!(pce = alloc_pce()))
+		return 1;
+
+	if (!vector_alloc_slot(conf->overrides->pctable)) {
+		free(pce);
+		return 1;
+	}
+	vector_set_slot(conf->overrides->pctable, pce);
+
+	return 0;
+}
+
+static int
+set_protocol_type(vector strvec, void *ptr, const char *file, int line_nr)
+{
+	int *int_ptr = (int *)ptr;
+	char *buff;
+	int i;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+
+	for (i = 0; i <= LAST_BUS_PROTOCOL_ID; i++) {
+		if (protocol_name[i] && !strcmp(buff, protocol_name[i])) {
+			*int_ptr = i;
+			break;
+		}
+	}
+	if (i > LAST_BUS_PROTOCOL_ID)
+		condlog(1, "%s line %d, invalid value for type: \"%s\"",
+			file, line_nr, buff);
+
+	free(buff);
+	return 0;
+}
+
+static int
+print_protocol_type(struct strbuf *buff, int type)
+{
+	if (type < 0)
+		return 0;
+	return append_strbuf_quoted(buff, protocol_name[type]);
+}
+
+declare_pc_handler(type, set_protocol_type)
+declare_pc_snprint(type, print_protocol_type)
+
 /*
  * deprecated handlers
  */
@@ -2138,6 +2230,13 @@ init_keywords(vector keywords)
 	install_keyword("ghost_delay", &ovr_ghost_delay_handler, &snprint_ovr_ghost_delay);
 	install_keyword("all_tg_pt", &ovr_all_tg_pt_handler, &snprint_ovr_all_tg_pt);
 	install_keyword("recheck_wwid", &ovr_recheck_wwid_handler, &snprint_ovr_recheck_wwid);
+	install_keyword_multi("protocol", &protocol_handler, NULL);
+	install_sublevel();
+	install_keyword("type", &pc_type_handler, &snprint_pc_type);
+	install_keyword("fast_io_fail_tmo", &pc_fast_io_fail_handler, &snprint_pc_fast_io_fail);
+	install_keyword("dev_loss_tmo", &pc_dev_loss_handler, &snprint_pc_dev_loss);
+	install_keyword("eh_deadline", &pc_eh_deadline_handler, &snprint_pc_eh_deadline);
+	install_sublevel_end();
 
 	install_keyword_root("multipaths", &multipaths_handler);
 	install_keyword_multi("multipath", &multipath_handler, NULL);
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 27c2cf1a..68a793e7 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1406,6 +1406,52 @@ int snprint_multipath_topology_json (struct strbuf *buff,
 	return get_strbuf_len(buff) - initial_len;
 }
 
+static int
+snprint_pcentry (const struct config *conf, struct strbuf *buff,
+		 const struct pcentry *pce)
+{
+	int i, rc;
+	struct keyword *kw;
+	struct keyword * rootkw;
+	size_t initial_len = get_strbuf_len(buff);
+
+	rootkw = find_keyword(conf->keywords, NULL, "overrides");
+	assert(rootkw && rootkw->sub);
+	rootkw = find_keyword(conf->keywords, rootkw->sub, "protocol");
+	assert(rootkw);
+
+	if ((rc = append_strbuf_str(buff, "\tprotocol {\n")) < 0)
+		return rc;
+
+	iterate_sub_keywords(rootkw, kw, i) {
+		if ((rc = snprint_keyword(buff, "\t\t%k %v\n", kw, pce)) < 0)
+			return rc;
+	}
+
+	if ((rc = append_strbuf_str(buff, "\t}\n")) < 0)
+		return rc;
+	return get_strbuf_len(buff) - initial_len;
+}
+
+static int
+snprint_pctable (const struct config *conf, struct strbuf *buff,
+		 const struct _vector *pctable)
+{
+	int i, rc;
+	struct pcentry *pce;
+	struct keyword * rootkw;
+	size_t initial_len = get_strbuf_len(buff);
+
+	rootkw = find_keyword(conf->keywords, NULL, "overrides");
+	assert(rootkw);
+
+	vector_foreach_slot(pctable, pce, i) {
+		if ((rc = snprint_pcentry(conf, buff, pce)) < 0)
+			return rc;
+	}
+	return get_strbuf_len(buff) - initial_len;
+}
+
 static int
 snprint_hwentry (const struct config *conf,
 		 struct strbuf *buff, const struct hwentry * hwe)
@@ -1560,6 +1606,10 @@ static int snprint_overrides(const struct config *conf, struct strbuf *buff,
 		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, NULL)) < 0)
 			return rc;
 	}
+
+	if (overrides->pctable &&
+	    (rc = snprint_pctable(conf, buff, overrides->pctable)) < 0)
+		return rc;
 out:
 	if ((rc = append_strbuf_str(buff, "}\n")) < 0)
 		return rc;
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

