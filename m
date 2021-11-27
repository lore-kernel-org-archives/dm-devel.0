Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 900CAC433F5
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:22:32 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-A2STG443OuebyE9FUMjwNw-1; Sat, 27 Nov 2021 10:22:28 -0500
X-MC-Unique: A2STG443OuebyE9FUMjwNw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCA89801B00;
	Sat, 27 Nov 2021 15:22:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A0A7160BF1;
	Sat, 27 Nov 2021 15:22:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7AD7A1826D06;
	Sat, 27 Nov 2021 15:22:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJj22032652 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DB52E400DFBC; Sat, 27 Nov 2021 15:19:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D68DB40CFD07
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA8A8185A7B4
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:45 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-153-yOodTj9ANNm-gqT_XovvUA-1; Sat, 27 Nov 2021 10:19:43 -0500
X-MC-Unique: yOodTj9ANNm-gqT_XovvUA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F087A212C8;
	Sat, 27 Nov 2021 15:19:41 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A464213AB0;
	Sat, 27 Nov 2021 15:19:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id MJDTJY1MomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:41 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:18:54 +0100
Message-Id: <20211127151929.7727-2-mwilck@suse.com>
In-Reply-To: <20211127151929.7727-1-mwilck@suse.com>
References: <20211127151929.7727-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJj22032652
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 01/35] libmultipath: add timespeccmp() utility
	function
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Add a small utility that will be used in later patches.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version |  5 +++++
 libmultipath/time-util.c          | 12 ++++++++++++
 libmultipath/time-util.h          |  1 +
 3 files changed, 18 insertions(+)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index eb5b5b5..c98cf7f 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -287,3 +287,8 @@ global:
 local:
 	*;
 };
+
+LIBMULTIPATH_9.1.0 {
+global:
+	timespeccmp;
+} LIBMULTIPATH_9.0.0;
diff --git a/libmultipath/time-util.c b/libmultipath/time-util.c
index 55f366c..2919300 100644
--- a/libmultipath/time-util.c
+++ b/libmultipath/time-util.c
@@ -49,3 +49,15 @@ void timespecsub(const struct timespec *a, const struct timespec *b,
 	res->tv_nsec = a->tv_nsec - b->tv_nsec;
 	normalize_timespec(res);
 }
+
+int timespeccmp(const struct timespec *a, const struct timespec *b)
+{
+	struct timespec tmp;
+
+	timespecsub(a, b, &tmp);
+	if (tmp.tv_sec > 0)
+		return 1;
+	if (tmp.tv_sec < 0)
+		return -1;
+	return tmp.tv_nsec > 0 ? 1 : (tmp.tv_nsec < 0 ? -1 : 0);
+}
diff --git a/libmultipath/time-util.h b/libmultipath/time-util.h
index b23d328..4a80ebd 100644
--- a/libmultipath/time-util.h
+++ b/libmultipath/time-util.h
@@ -10,5 +10,6 @@ void pthread_cond_init_mono(pthread_cond_t *cond);
 void normalize_timespec(struct timespec *ts);
 void timespecsub(const struct timespec *a, const struct timespec *b,
 		 struct timespec *res);
+int timespeccmp(const struct timespec *a, const struct timespec *b);
 
 #endif /* _TIME_UTIL_H_ */
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

