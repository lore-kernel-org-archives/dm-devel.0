Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4602FC41604
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A55B6207F7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A55B6207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-8hjD3TVSP8-_MUf5ERZfLQ-1; Fri, 16 Oct 2020 06:45:42 -0400
X-MC-Unique: 8hjD3TVSP8-_MUf5ERZfLQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECA9285C737;
	Fri, 16 Oct 2020 10:45:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CCB41100760B;
	Fri, 16 Oct 2020 10:45:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A31C41832FBA;
	Fri, 16 Oct 2020 10:45:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAjLFU020781 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:45:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C328A11CC237; Fri, 16 Oct 2020 10:45:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE17611CC22E
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 971B6811E76
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:21 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-434-WdtTxzKkO8upu0_gw08_Ww-1;
	Fri, 16 Oct 2020 06:45:18 -0400
X-MC-Unique: WdtTxzKkO8upu0_gw08_Ww-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id E2890B2CB;
	Fri, 16 Oct 2020 10:45:16 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:44:54 +0200
Message-Id: <20201016104501.8700-23-mwilck@suse.com>
In-Reply-To: <20201016104501.8700-1-mwilck@suse.com>
References: <20201016104501.8700-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAjLFU020781
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 22/29] multipath: fix leaks in
	check_path_valid()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

There were two leaks in check_path_valid(): if path status was
successfully determined before calling store_pathvec(), free_path()
wasn't called. Also, if an error exit occured, neither cleanup
function was called.

This patch fixes both, at the cost of using "static" for the pp and
pathvec variables.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 55 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 12 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 049a36f..9974993 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -93,7 +93,7 @@ void rcu_register_thread_memb(void) {}
 void rcu_unregister_thread_memb(void) {}
 
 static int
-filter_pathvec (vector pathvec, char * refwwid)
+filter_pathvec (vector pathvec, const char *refwwid)
 {
 	int i;
 	struct path * pp;
@@ -592,12 +592,37 @@ out:
 	return r;
 }
 
+static void cleanup_pathvec(__attribute__((unused)) int dummy, void *arg)
+{
+	vector *ppv = arg;
+
+	if (ppv && *ppv) {
+		free_pathvec(*ppv, FREE_PATHS);
+		*ppv = NULL;
+	}
+}
+
+static void cleanup_path(__attribute__((unused)) int dummy, void *arg)
+{
+	struct path **ppp = arg;
+
+	if (ppp && *ppp) {
+		free_path(*ppp);
+		*ppp = NULL;
+	}
+}
+
 static int
 check_path_valid(const char *name, struct config *conf, bool is_uevent)
 {
 	int fd, r = PATH_IS_ERROR;
-	struct path *pp = NULL;
-	vector pathvec = NULL;
+	static struct path *pp = NULL;
+	static vector pathvec = NULL;
+	const char *wwid;
+
+	/* register these as exit handlers in case we exit irregularly */
+	on_exit(cleanup_path, &pp);
+	on_exit(cleanup_pathvec, &pathvec);
 
 	pp = alloc_path();
 	if (!pp)
@@ -667,13 +692,17 @@ check_path_valid(const char *name, struct config *conf, bool is_uevent)
 	if (store_path(pathvec, pp) != 0) {
 		free_path(pp);
 		goto fail;
+	} else {
+		/* make sure path isn't freed twice */
+		wwid = pp->wwid;
+		pp = NULL;
 	}
 
 	/* For find_multipaths = SMART, if there is more than one path
 	 * matching the refwwid, then the path is valid */
 	if (path_discovery(pathvec, DI_SYSFS | DI_WWID) < 0)
 		goto fail;
-	filter_pathvec(pathvec, pp->wwid);
+	filter_pathvec(pathvec, wwid);
 	if (VECTOR_SIZE(pathvec) > 1)
 		r = PATH_IS_VALID;
 	else
@@ -681,21 +710,23 @@ check_path_valid(const char *name, struct config *conf, bool is_uevent)
 
 out:
 	r = print_cmd_valid(r, pathvec, conf);
-	free_pathvec(pathvec, FREE_PATHS);
 	/*
 	 * multipath -u must exit with status 0, otherwise udev won't
 	 * import its output.
 	 */
 	if (!is_uevent && r == PATH_IS_NOT_VALID)
-		return RTVL_FAIL;
-	return RTVL_OK;
+		r = RTVL_FAIL;
+	else
+		r = RTVL_OK;
+	goto cleanup;
 
 fail:
-	if (pathvec)
-		free_pathvec(pathvec, FREE_PATHS);
-	else
-		free_path(pp);
-	return RTVL_FAIL;
+	r = RTVL_FAIL;
+
+cleanup:
+	cleanup_path(0, &pp);
+	cleanup_pathvec(0, &pathvec);
+	return r;
 }
 
 static int
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

