Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF228C43457
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5A8CA2084C
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A8CA2084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-d8LdBa4WOsWHsuFnkkXeLQ-1; Fri, 16 Oct 2020 06:45:40 -0400
X-MC-Unique: d8LdBa4WOsWHsuFnkkXeLQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 225DC1084D88;
	Fri, 16 Oct 2020 10:45:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 05C8B1002C00;
	Fri, 16 Oct 2020 10:45:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D04DC1832FB7;
	Fri, 16 Oct 2020 10:45:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAjKZN020751 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:45:20 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A0F0612D8B8; Fri, 16 Oct 2020 10:45:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BFD216C2E1
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75A62101A56A
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:20 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-182-V0vsaKKENbu9HtlAtLgKwQ-1;
	Fri, 16 Oct 2020 06:45:17 -0400
X-MC-Unique: V0vsaKKENbu9HtlAtLgKwQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 179E0B2B3;
	Fri, 16 Oct 2020 10:45:16 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:44:52 +0200
Message-Id: <20201016104501.8700-21-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAjKZN020751
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 20/29] multipath: use atexit() for cleanup
	handlers
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

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 9ae46ed..049a36f 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -452,13 +452,21 @@ static bool released_to_systemd(void)
 	return ret;
 }
 
+static void cleanup_vecs(__attribute__((unused)) int dummy, void *arg)
+{
+	struct vectors *vecs = arg;
+
+	free_multipathvec(vecs->mpvec, KEEP_PATHS);
+	free_pathvec(vecs->pathvec, FREE_PATHS);
+}
+
 static int
 configure (struct config *conf, enum mpath_cmds cmd,
 	   enum devtypes dev_type, char *devpath)
 {
 	vector curmp = NULL;
 	vector pathvec = NULL;
-	struct vectors vecs;
+	static struct vectors vecs;
 	int r = RTVL_FAIL, rc;
 	int di_flag = 0;
 	char * refwwid = NULL;
@@ -469,6 +477,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	 */
 	curmp = vector_alloc();
 	pathvec = vector_alloc();
+	on_exit(cleanup_vecs, &vecs);
 
 	if (!curmp || !pathvec) {
 		condlog(0, "can not allocate memory");
@@ -580,9 +589,6 @@ out:
 	if (refwwid)
 		FREE(refwwid);
 
-	free_multipathvec(curmp, KEEP_PATHS);
-	free_pathvec(pathvec, FREE_PATHS);
-
 	return r;
 }
 
@@ -808,9 +814,13 @@ main (int argc, char *argv[])
 	bool enable_foreign = false;
 
 	libmultipath_init();
+	if (atexit(dm_lib_exit) || atexit(libmultipath_exit))
+		condlog(1, "failed to register cleanup handler for libmultipath: %m");
 	logsink = 0;
 	if (init_config(DEFAULT_CONFIGFILE))
 		exit(RTVL_FAIL);
+	if (atexit(uninit_config))
+		condlog(1, "failed to register cleanup handler for config: %m");
 	conf = get_multipath_config();
 	conf->retrigger_tries = 0;
 	conf->force_sync = 1;
@@ -887,7 +897,7 @@ main (int argc, char *argv[])
 			break;
 		case 't':
 			r = dump_config(conf, NULL, NULL) ? RTVL_FAIL : RTVL_OK;
-			goto out_free_config;
+			goto out;
 		case 'T':
 			cmd = CMD_DUMP_CONFIG;
 			break;
@@ -1048,26 +1058,13 @@ main (int argc, char *argv[])
 		condlog(3, "restart multipath configuration process");
 
 out:
-	dm_lib_exit();
-
-	cleanup_foreign();
-	cleanup_prio();
-	cleanup_checkers();
+	put_multipath_config(conf);
+	if (dev)
+		FREE(dev);
 
 	if (dev_type == DEV_UEVENT)
 		closelog();
 
-out_free_config:
-	/*
-	 * Freeing config must be done after dm_lib_exit(), because
-	 * the logging function (dm_write_log()), which is called there,
-	 * references the config.
-	 */
-	put_multipath_config(conf);
-	uninit_config();
-	libmultipath_exit();
-	if (dev)
-		FREE(dev);
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
 #endif
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

