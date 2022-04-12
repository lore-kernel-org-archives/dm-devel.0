Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87685C4332F
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 02:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649728817;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=o2q/vR2p8+Om+B3WC3QLRHaUHkKIR1579Msf0SOPbLk=;
	b=BJEgBWwFB6L//reFchGh3SFUE0lYR2bFKHIsYsxH4J2FEFtEtmkOmy3zwYp8+Hz9Pu/tGN
	3alw7OiEpa+oiotIZhs5U9flLuj+VJ89UANVj84KE8Ya20LMIbzbFUTq1KgG/Qt2NfdHoQ
	wcBHRqtLngXGhROEeigEZUpXgrLJiBE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-E7LnlRQUNFyAjiJ7JpGdJg-1; Mon, 11 Apr 2022 22:00:09 -0400
X-MC-Unique: E7LnlRQUNFyAjiJ7JpGdJg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 409A53C02B67;
	Tue, 12 Apr 2022 02:00:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2A574416384;
	Tue, 12 Apr 2022 02:00:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D80F01940366;
	Tue, 12 Apr 2022 02:00:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6BB2B1940378
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 02:00:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5C0DF401E02; Tue, 12 Apr 2022 02:00:05 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 43128401DFF;
 Tue, 12 Apr 2022 02:00:05 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 23C2042K011840;
 Mon, 11 Apr 2022 21:00:04 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 23C203jj011839;
 Mon, 11 Apr 2022 21:00:03 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 11 Apr 2022 20:59:53 -0500
Message-Id: <1649728799-11790-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
References: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH 3/9] libmultipath: add a protocol subsection to
 multipath.conf
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Some storage arrays can be accessed using multiple protocols at the same
time.  In these cases, users may want to set path attributes
differently, depending on the protocol that the path is using. To allow
this, add a protocol subsection to the device subsection in
multipath.conf, which allows select path-specific options to be set.
This commit simply adds the subsection, and handles merging matching
entries, both within a hwentry, and when hwentries are merged. Future
patches will make use of the section.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c | 102 ++++++++++++++++++++++++++++++++++++++++++
 libmultipath/config.h |  10 +++++
 libmultipath/dict.c   |  99 ++++++++++++++++++++++++++++++++++++++++
 libmultipath/print.c  |  44 ++++++++++++++++++
 4 files changed, 255 insertions(+)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 612941b8..61d3c182 100644
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
@@ -396,6 +420,41 @@ set_param_str(const char * str)
 	if (!dst->s && src->s) \
 		dst->s = src->s
 
+static void
+merge_pce(struct pcentry *dst, struct pcentry *src)
+{
+	merge_num(fast_io_fail);
+	merge_num(dev_loss);
+	merge_num(eh_deadline);
+}
+
+static int
+merge_pctable(vector d_pctable, vector s_pctable)
+{
+	struct pcentry *d_pce, *s_pce;
+	int i, j, start = 0;
+
+	vector_foreach_slot_backwards(s_pctable, s_pce, i) {
+		bool found = false;
+		j = start;
+		vector_foreach_slot_after(d_pctable, d_pce, j) {
+			if (s_pce->type != d_pce->type)
+				continue;
+			found = true;
+			merge_pce(d_pce, s_pce);
+			vector_del_slot(s_pctable, i);
+			free(s_pce);
+			break;
+		}
+		if (found)
+			continue;
+		if (!vector_insert_slot(d_pctable, 0, s_pce))
+			return 1;
+		vector_del_slot(s_pctable, i);
+		start++;
+	}
+	return 0;
+}
 
 static void
 merge_hwe (struct hwentry * dst, struct hwentry * src)
@@ -445,6 +504,13 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(marginal_path_err_recheck_gap_time);
 	merge_num(marginal_path_double_failed_time);
 
+	if (src->pctable) {
+		if (!dst->pctable)
+			dst->pctable = steal_ptr(src->pctable);
+		else
+			merge_pctable(dst->pctable, src->pctable);
+	}
+
 	snprintf(id, sizeof(id), "%s/%s", dst->vendor, dst->product);
 	reconcile_features_with_options(id, &dst->features,
 					&dst->no_path_retry,
@@ -602,6 +668,41 @@ out:
 	return 1;
 }
 
+static void
+factorize_pctable(struct hwentry *hwe, const char *table_desc)
+{
+	struct pcentry *pce1, *pce2;
+	int i, j;
+
+	if (!hwe->pctable)
+		return;
+
+	vector_foreach_slot(hwe->pctable, pce1, i) {
+		if (pce1->type < 0) {
+			condlog(0, "protocol section from %s:%s in %s missing type",
+				hwe->vendor, hwe->product, table_desc);
+			vector_del_slot(hwe->pctable, i--);
+			free(pce1);
+			continue;
+		}
+		j = i + 1;
+		vector_foreach_slot_after(hwe->pctable, pce2, j) {
+			if (pce1->type != pce2->type)
+				continue;
+			merge_pce(pce2,pce1);
+			vector_del_slot(hwe->pctable, i--);
+			free(pce1);
+			break;
+		}
+
+	}
+
+	if (VECTOR_SIZE(hwe->pctable) == 0) {
+		vector_free(hwe->pctable);
+		hwe->pctable = NULL;
+	}
+}
+
 static void
 factorize_hwtable (vector hw, int n, const char *table_desc)
 {
@@ -618,6 +719,7 @@ restart:
 			free_hwe(hwe1);
 			continue;
 		}
+		factorize_pctable(hwe1, table_desc);
 		j = n > i + 1 ? n : i + 1;
 		vector_foreach_slot_after(hw, hwe2, j) {
 			if (hwe_strmatch(hwe2, hwe1) == 0) {
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
index 26cbe785..04d86ee3 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -417,6 +417,30 @@ snprint_mp_ ## option (struct config *conf, struct strbuf *buff,	\
 	return function(buff, mpe->option);				\
 }
 
+#define declare_pc_handler(option, function)				\
+static int								\
+pc_ ## option ## _handler (struct config *conf, vector strvec,		\
+			   const char *file, int line_nr)		\
+{									\
+	struct pcentry *pce;						\
+	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);		\
+	if (!hwe || !hwe->pctable)					\
+		return 1;						\
+	pce = VECTOR_LAST_SLOT(hwe->pctable);				\
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
@@ -1046,6 +1070,8 @@ declare_ovr_handler(fast_io_fail, set_undef_off_zero)
 declare_ovr_snprint(fast_io_fail, print_undef_off_zero)
 declare_hw_handler(fast_io_fail, set_undef_off_zero)
 declare_hw_snprint(fast_io_fail, print_undef_off_zero)
+declare_pc_handler(fast_io_fail, set_undef_off_zero)
+declare_pc_snprint(fast_io_fail, print_undef_off_zero)
 
 static int
 set_dev_loss(vector strvec, void *ptr, const char *file, int line_nr)
@@ -1083,6 +1109,8 @@ declare_ovr_handler(dev_loss, set_dev_loss)
 declare_ovr_snprint(dev_loss, print_dev_loss)
 declare_hw_handler(dev_loss, set_dev_loss)
 declare_hw_snprint(dev_loss, print_dev_loss)
+declare_pc_handler(dev_loss, set_dev_loss)
+declare_pc_snprint(dev_loss, print_dev_loss)
 
 declare_def_handler(eh_deadline, set_undef_off_zero)
 declare_def_snprint(eh_deadline, print_undef_off_zero)
@@ -1090,6 +1118,8 @@ declare_ovr_handler(eh_deadline, set_undef_off_zero)
 declare_ovr_snprint(eh_deadline, print_undef_off_zero)
 declare_hw_handler(eh_deadline, set_undef_off_zero)
 declare_hw_snprint(eh_deadline, print_undef_off_zero)
+declare_pc_handler(eh_deadline, set_undef_off_zero)
+declare_pc_snprint(eh_deadline, print_undef_off_zero)
 
 static int
 set_pgpolicy(vector strvec, void *ptr, const char *file, int line_nr)
@@ -1897,6 +1927,68 @@ declare_mp_snprint(wwid, print_str)
 declare_mp_handler(alias, set_str_noslash)
 declare_mp_snprint(alias, print_str)
 
+
+static int
+protocol_handler(struct config *conf, vector strvec, const char *file,
+               int line_nr)
+{
+	struct pcentry *pce;
+	struct hwentry *hwe = VECTOR_LAST_SLOT(conf->hwtable);
+	if (!hwe)
+		return 1;
+
+	if (!hwe->pctable && !(hwe->pctable = vector_alloc()))
+		return 1;
+
+	if (!(pce = alloc_pce()))
+		return 1;
+
+	if (!vector_alloc_slot(hwe->pctable)) {
+		free(pce);
+		return 1;
+	}
+	vector_set_slot(hwe->pctable, pce);
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
@@ -2096,6 +2188,13 @@ init_keywords(vector keywords)
 	install_keyword("all_tg_pt", &hw_all_tg_pt_handler, &snprint_hw_all_tg_pt);
 	install_keyword("vpd_vendor", &hw_vpd_vendor_handler, &snprint_hw_vpd_vendor);
 	install_keyword("recheck_wwid", &hw_recheck_wwid_handler, &snprint_hw_recheck_wwid);
+	install_keyword_multi("protocol", &protocol_handler, NULL);
+	install_sublevel();
+	install_keyword("type", &pc_type_handler, &snprint_pc_type);
+	install_keyword("fast_io_fail_tmo", &pc_fast_io_fail_handler, &snprint_pc_fast_io_fail);
+	install_keyword("dev_loss_tmo", &pc_dev_loss_handler, &snprint_pc_dev_loss);
+	install_keyword("eh_deadline", &pc_eh_deadline_handler, &snprint_pc_eh_deadline);
+	install_sublevel_end();
 	install_sublevel_end();
 
 	install_keyword_root("overrides", &overrides_handler);
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 27c2cf1a..46d231ed 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1406,6 +1406,45 @@ int snprint_multipath_topology_json (struct strbuf *buff,
 	return get_strbuf_len(buff) - initial_len;
 }
 
+static int
+snprint_pcentry (struct strbuf *buff, const struct pcentry *pce,
+		 const struct keyword *rootkw)
+{
+	int i, rc;
+	struct keyword *kw;
+	size_t initial_len = get_strbuf_len(buff);
+
+	if ((rc = append_strbuf_str(buff, "\t\tprotocol {\n")) < 0)
+		return rc;
+
+	iterate_sub_keywords(rootkw, kw, i) {
+		if ((rc = snprint_keyword(buff, "\t\t\t%k %v\n", kw, pce)) < 0)
+			return rc;
+	}
+
+	if ((rc = append_strbuf_str(buff, "\t\t}\n")) < 0)
+		return rc;
+	return get_strbuf_len(buff) - initial_len;
+}
+
+static int
+snprint_pctable (const struct config *conf, struct strbuf *buff,
+		 const struct _vector *pctable, const struct keyword *rootkw)
+{
+	int i, rc;
+	struct pcentry *pce;
+	size_t initial_len = get_strbuf_len(buff);
+
+	rootkw = find_keyword(conf->keywords, rootkw->sub, "protocol");
+	assert(rootkw);
+
+	vector_foreach_slot(pctable, pce, i) {
+		if ((rc = snprint_pcentry(buff, pce, rootkw)) < 0)
+			return rc;
+	}
+	return get_strbuf_len(buff) - initial_len;
+}
+
 static int
 snprint_hwentry (const struct config *conf,
 		 struct strbuf *buff, const struct hwentry * hwe)
@@ -1427,6 +1466,11 @@ snprint_hwentry (const struct config *conf,
 		if ((rc = snprint_keyword(buff, "\t\t%k %v\n", kw, hwe)) < 0)
 			return rc;
 	}
+
+	if (hwe->pctable &&
+	    (rc = snprint_pctable(conf, buff, hwe->pctable, rootkw)) < 0)
+		return rc;
+
 	if ((rc = append_strbuf_str(buff, "\t}\n")) < 0)
 		return rc;
 	return get_strbuf_len(buff) - initial_len;
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

