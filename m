Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89B6C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:05:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6331861A79
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:05:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6331861A79
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-lk4I6boqMpWHu2y7ny2JSg-1; Thu, 18 Nov 2021 18:05:06 -0500
X-MC-Unique: lk4I6boqMpWHu2y7ny2JSg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F1E187D56E;
	Thu, 18 Nov 2021 23:05:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B5EB99CC;
	Thu, 18 Nov 2021 23:05:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F119C4EA31;
	Thu, 18 Nov 2021 23:05:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMxEvJ002311 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4300C4047279; Thu, 18 Nov 2021 22:59:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E69E404727A
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11EE7185A79C
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:14 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-508-7_hb_B2nOxyCFOFFY6uhgg-1; Thu, 18 Nov 2021 17:59:12 -0500
X-MC-Unique: 7_hb_B2nOxyCFOFFY6uhgg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DE92B1FD3A;
	Thu, 18 Nov 2021 22:59:10 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 94ED713B11;
	Thu, 18 Nov 2021 22:59:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id sDpXIr7almGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:10 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:32 +0100
Message-Id: <20211118225840.19810-41-mwilck@suse.com>
In-Reply-To: <20211118225840.19810-1-mwilck@suse.com>
References: <20211118225840.19810-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMxEvJ002311
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 40/48] multipathd: remove missing paths on
	startup
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Benjamin Marzinski <bmarzins@redhat.com>

If a path device was removed from the system while multipathd was not
running, multipathd would not remove the path from the multipath table
on start-up, or on a weak reconfigure. update_pathvec_from_dm() would
return that a reload was necessary, but that information wasn't
propigated back to where it could be used to reload the device.

Multipath devices now remember if they need to be reloaded, and if so,
force_reload is set in select_action().  This means that even when
configure is called with FORCE_RELOAD_WEAK, these devices will still be
reloaded.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c   | 2 ++
 libmultipath/devmapper.c   | 2 ++
 libmultipath/structs.h     | 1 +
 libmultipath/structs_vec.c | 1 +
 4 files changed, 6 insertions(+)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index eb8ec1b..f1a890a 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -715,6 +715,8 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 
 	cmpp = find_mp_by_wwid(curmp, mpp->wwid);
 	cmpp_by_name = find_mp_by_alias(curmp, mpp->alias);
+	if (mpp->need_reload || (cmpp && cmpp->need_reload))
+		force_reload = 1;
 
 	if (!cmpp_by_name) {
 		if (cmpp) {
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index c05dc20..3e1a726 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -522,6 +522,8 @@ freeout:
 addout:
 	dm_task_destroy (dmt);
 
+	if (r)
+		mpp->need_reload = false;
 	return r;
 }
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 399540e..d0b266b 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -355,6 +355,7 @@ struct multipath {
 	int retain_hwhandler;
 	int deferred_remove;
 	bool in_recovery;
+	bool need_reload;
 	int san_path_err_threshold;
 	int san_path_err_forget_rate;
 	int san_path_err_recovery_time;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 85d97ac..e52db0c 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -237,6 +237,7 @@ bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 		free_pathgroup(pgp, KEEP_PATHS);
 		must_reload = true;
 	}
+	mpp->need_reload = mpp->need_reload || must_reload;
 	return must_reload;
 }
 
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

