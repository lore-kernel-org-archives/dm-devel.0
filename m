Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 953F1C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 02:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649728816;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=snhFHRKL0CNB8DiUWuLQV292ncchE8m/2Xmy4neNKgw=;
	b=FXPkrbbnnIw/8pLovvXc5PhL8j6jon2vFeSJ317HTGS9Ca0YChAvsT7gviLIuS6SKrs3Kc
	5mDM4Y4ULD2Lx6qj5lC7j0fi3IbIegjcaXuEmg3+2xkZKt7o8yFGdpgfLx8tTPd1Xax4v7
	etGfPL3pqzUE2Anfai52Wv8O1Rq5r1M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-ObAkHDM1O1-lTomz-4DZ3Q-1; Mon, 11 Apr 2022 22:00:13 -0400
X-MC-Unique: ObAkHDM1O1-lTomz-4DZ3Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1D69180138A;
	Tue, 12 Apr 2022 02:00:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A0019401472;
	Tue, 12 Apr 2022 02:00:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7FEF51949762;
	Tue, 12 Apr 2022 02:00:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6872C1940373
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 02:00:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4BFED401E02; Tue, 12 Apr 2022 02:00:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 36083401DFF;
 Tue, 12 Apr 2022 02:00:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 23C2087h011856;
 Mon, 11 Apr 2022 21:00:09 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 23C208vR011855;
 Mon, 11 Apr 2022 21:00:08 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 11 Apr 2022 20:59:57 -0500
Message-Id: <1649728799-11790-8-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
References: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH 7/9] libmultipath: add procotol subsection to
 overrides
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

Add a procotol subsection to the overrides section, just like the one in
the device subsection. This allows users to a protocol specific
parameters to all device configurations.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c    | 76 ++++++++++++++++++++++++++++++++----------
 libmultipath/print.c   |  5 +++
 libmultipath/propsel.c | 29 ++++++++++++++--
 3 files changed, 90 insertions(+), 20 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 04d86ee3..4923b8d2 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -386,6 +386,20 @@ snprint_ovr_ ## option (struct config *conf, struct strbuf *buff,	\
 	return function (buff, conf->overrides->option);		\
 }
 
+#define declare_ovr_pc_handler(option, function)			\
+static int								\
+ovr_pc_ ## option ## _handler (struct config *conf, vector strvec,	\
+			       const char *file, int line_nr)		\
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
 #define declare_mp_handler(option, function)				\
 static int								\
 mp_ ## option ## _handler (struct config *conf, vector strvec,		\
@@ -417,10 +431,10 @@ snprint_mp_ ## option (struct config *conf, struct strbuf *buff,	\
 	return function(buff, mpe->option);				\
 }
 
-#define declare_pc_handler(option, function)				\
+#define declare_hw_pc_handler(option, function)				\
 static int								\
-pc_ ## option ## _handler (struct config *conf, vector strvec,		\
-			   const char *file, int line_nr)		\
+hw_pc_ ## option ## _handler (struct config *conf, vector strvec,	\
+			       const char *file, int line_nr)		\
 {									\
 	struct pcentry *pce;						\
 	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);		\
@@ -1070,7 +1084,8 @@ declare_ovr_handler(fast_io_fail, set_undef_off_zero)
 declare_ovr_snprint(fast_io_fail, print_undef_off_zero)
 declare_hw_handler(fast_io_fail, set_undef_off_zero)
 declare_hw_snprint(fast_io_fail, print_undef_off_zero)
-declare_pc_handler(fast_io_fail, set_undef_off_zero)
+declare_hw_pc_handler(fast_io_fail, set_undef_off_zero)
+declare_ovr_pc_handler(fast_io_fail, set_undef_off_zero)
 declare_pc_snprint(fast_io_fail, print_undef_off_zero)
 
 static int
@@ -1109,7 +1124,8 @@ declare_ovr_handler(dev_loss, set_dev_loss)
 declare_ovr_snprint(dev_loss, print_dev_loss)
 declare_hw_handler(dev_loss, set_dev_loss)
 declare_hw_snprint(dev_loss, print_dev_loss)
-declare_pc_handler(dev_loss, set_dev_loss)
+declare_hw_pc_handler(dev_loss, set_dev_loss)
+declare_ovr_pc_handler(dev_loss, set_dev_loss)
 declare_pc_snprint(dev_loss, print_dev_loss)
 
 declare_def_handler(eh_deadline, set_undef_off_zero)
@@ -1118,7 +1134,8 @@ declare_ovr_handler(eh_deadline, set_undef_off_zero)
 declare_ovr_snprint(eh_deadline, print_undef_off_zero)
 declare_hw_handler(eh_deadline, set_undef_off_zero)
 declare_hw_snprint(eh_deadline, print_undef_off_zero)
-declare_pc_handler(eh_deadline, set_undef_off_zero)
+declare_hw_pc_handler(eh_deadline, set_undef_off_zero)
+declare_ovr_pc_handler(eh_deadline, set_undef_off_zero)
 declare_pc_snprint(eh_deadline, print_undef_off_zero)
 
 static int
@@ -1929,13 +1946,9 @@ declare_mp_snprint(alias, print_str)
 
 
 static int
-protocol_handler(struct config *conf, vector strvec, const char *file,
-               int line_nr)
+_protocol_handler(struct hwentry *hwe)
 {
 	struct pcentry *pce;
-	struct hwentry *hwe = VECTOR_LAST_SLOT(conf->hwtable);
-	if (!hwe)
-		return 1;
 
 	if (!hwe->pctable && !(hwe->pctable = vector_alloc()))
 		return 1;
@@ -1952,6 +1965,27 @@ protocol_handler(struct config *conf, vector strvec, const char *file,
 	return 0;
 }
 
+static int
+hw_protocol_handler(struct config *conf, vector strvec, const char *file,
+		    int line_nr)
+{
+	struct hwentry *hwe = VECTOR_LAST_SLOT(conf->hwtable);
+	if (!hwe)
+		return 1;
+
+	return _protocol_handler(hwe);
+}
+
+static int
+ovr_protocol_handler(struct config *conf, vector strvec, const char *file,
+		     int line_nr)
+{
+	if (!conf->overrides)
+		return 1;
+
+	return _protocol_handler(conf->overrides);
+}
+
 static int
 set_protocol_type(vector strvec, void *ptr, const char *file, int line_nr)
 {
@@ -1986,7 +2020,8 @@ print_protocol_type(struct strbuf *buff, int type)
 	return append_strbuf_quoted(buff, protocol_name[type]);
 }
 
-declare_pc_handler(type, set_protocol_type)
+declare_hw_pc_handler(type, set_protocol_type)
+declare_ovr_pc_handler(type, set_protocol_type)
 declare_pc_snprint(type, print_protocol_type)
 
 /*
@@ -2188,12 +2223,12 @@ init_keywords(vector keywords)
 	install_keyword("all_tg_pt", &hw_all_tg_pt_handler, &snprint_hw_all_tg_pt);
 	install_keyword("vpd_vendor", &hw_vpd_vendor_handler, &snprint_hw_vpd_vendor);
 	install_keyword("recheck_wwid", &hw_recheck_wwid_handler, &snprint_hw_recheck_wwid);
-	install_keyword_multi("protocol", &protocol_handler, NULL);
+	install_keyword_multi("protocol", &hw_protocol_handler, NULL);
 	install_sublevel();
-	install_keyword("type", &pc_type_handler, &snprint_pc_type);
-	install_keyword("fast_io_fail_tmo", &pc_fast_io_fail_handler, &snprint_pc_fast_io_fail);
-	install_keyword("dev_loss_tmo", &pc_dev_loss_handler, &snprint_pc_dev_loss);
-	install_keyword("eh_deadline", &pc_eh_deadline_handler, &snprint_pc_eh_deadline);
+	install_keyword("type", &hw_pc_type_handler, &snprint_pc_type);
+	install_keyword("fast_io_fail_tmo", &hw_pc_fast_io_fail_handler, &snprint_pc_fast_io_fail);
+	install_keyword("dev_loss_tmo", &hw_pc_dev_loss_handler, &snprint_pc_dev_loss);
+	install_keyword("eh_deadline", &hw_pc_eh_deadline_handler, &snprint_pc_eh_deadline);
 	install_sublevel_end();
 	install_sublevel_end();
 
@@ -2237,6 +2272,13 @@ init_keywords(vector keywords)
 	install_keyword("ghost_delay", &ovr_ghost_delay_handler, &snprint_ovr_ghost_delay);
 	install_keyword("all_tg_pt", &ovr_all_tg_pt_handler, &snprint_ovr_all_tg_pt);
 	install_keyword("recheck_wwid", &ovr_recheck_wwid_handler, &snprint_ovr_recheck_wwid);
+	install_keyword_multi("protocol", &ovr_protocol_handler, NULL);
+	install_sublevel();
+	install_keyword("type", &ovr_pc_type_handler, &snprint_pc_type);
+	install_keyword("fast_io_fail_tmo", &ovr_pc_fast_io_fail_handler, &snprint_pc_fast_io_fail);
+	install_keyword("dev_loss_tmo", &ovr_pc_dev_loss_handler, &snprint_pc_dev_loss);
+	install_keyword("eh_deadline", &ovr_pc_eh_deadline_handler, &snprint_pc_eh_deadline);
+	install_sublevel_end();
 
 	install_keyword_root("multipaths", &multipaths_handler);
 	install_keyword_multi("multipath", &multipath_handler, NULL);
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 093e43aa..93df0b0c 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1618,6 +1618,11 @@ static int snprint_overrides(const struct config *conf, struct strbuf *buff,
 		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, NULL)) < 0)
 			return rc;
 	}
+
+	if (overrides->pctable &&
+	    (rc = snprint_pctable(conf, buff, 1, overrides->pctable,
+				   rootkw)) < 0)
+		return rc;
 out:
 	if ((rc = append_strbuf_str(buff, "}\n")) < 0)
 		return rc;
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 762b7fcb..90a160f1 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -81,6 +81,8 @@ static const char conf_origin[] =
 	"(setting: multipath.conf defaults/devices section)";
 static const char overrides_origin[] =
 	"(setting: multipath.conf overrides section)";
+static const char overrides_pce_origin[] =
+	"(setting: multipath.conf overrides protocol section)";
 static const char cmdline_origin[] =
 	"(setting: multipath command line [-p] flag)";
 static const char autodetect_origin[] =
@@ -170,6 +172,27 @@ do {									\
 	}								\
 } while (0)
 
+#define pp_set_ovr_pce(var)						\
+do {									\
+	struct pcentry *_pce;						\
+	int _i;								\
+									\
+	if (conf->overrides) {						\
+		vector_foreach_slot(conf->overrides->pctable, _pce, _i) {	\
+			if (_pce->type == (int)bus_protocol_id(pp) && _pce->var) {	\
+				pp->var = _pce->var;			\
+				origin = overrides_pce_origin;		\
+				goto out;				\
+			}						\
+		}							\
+		if (conf->overrides->var) {				\
+			pp->var = conf->overrides->var;			\
+			origin = overrides_origin;			\
+			goto out;					\
+		}							\
+	}								\
+} while (0)
+
 int select_mode(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
@@ -798,7 +821,7 @@ int select_fast_io_fail(struct config *conf, struct path *pp)
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
-	pp_set_ovr(fast_io_fail);
+	pp_set_ovr_pce(fast_io_fail);
 	pp_set_hwe_pce(fast_io_fail);
 	pp_set_conf(fast_io_fail);
 	pp_set_default(fast_io_fail, DEFAULT_FAST_IO_FAIL);
@@ -814,7 +837,7 @@ int select_dev_loss(struct config *conf, struct path *pp)
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
-	pp_set_ovr(dev_loss);
+	pp_set_ovr_pce(dev_loss);
 	pp_set_hwe_pce(dev_loss);
 	pp_set_conf(dev_loss);
 	pp->dev_loss = DEV_LOSS_TMO_UNSET;
@@ -831,7 +854,7 @@ int select_eh_deadline(struct config *conf, struct path *pp)
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
-	pp_set_ovr(eh_deadline);
+	pp_set_ovr_pce(eh_deadline);
 	pp_set_hwe_pce(eh_deadline);
 	pp_set_conf(eh_deadline);
 	pp->eh_deadline = EH_DEADLINE_UNSET;
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

