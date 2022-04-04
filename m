Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EBCAC433FE
	for <dm-devel@archiver.kernel.org>; Mon,  4 Apr 2022 17:05:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-7Grcllz5NF-O4ePo2RxPlw-1; Mon, 04 Apr 2022 13:05:51 -0400
X-MC-Unique: 7Grcllz5NF-O4ePo2RxPlw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D20C2800F8C;
	Mon,  4 Apr 2022 17:05:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 584D1536BB3;
	Mon,  4 Apr 2022 17:05:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 829AA194EB95;
	Mon,  4 Apr 2022 17:05:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E2DEC19451EF
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Apr 2022 17:05:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C46BB536BB3; Mon,  4 Apr 2022 17:05:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C0F9C536BBC
 for <dm-devel@redhat.com>; Mon,  4 Apr 2022 17:05:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7B9A2803587
 for <dm-devel@redhat.com>; Mon,  4 Apr 2022 17:05:37 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-250-g74qzttbMCevdV9ED_UD9w-1; Mon, 04 Apr 2022 13:05:34 -0400
X-MC-Unique: g74qzttbMCevdV9ED_UD9w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 0F48D1F390;
 Mon,  4 Apr 2022 17:05:33 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CD34612FC5;
 Mon,  4 Apr 2022 17:05:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id eMYJMFwlS2LICAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 04 Apr 2022 17:05:32 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon,  4 Apr 2022 19:04:57 +0200
Message-Id: <20220404170457.16021-16-mwilck@suse.com>
In-Reply-To: <20220404170457.16021-1-mwilck@suse.com>
References: <20220404170457.16021-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH v2 15/15] libmultipath: avoid memory leak with
 uid_attrs
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============5134501382820336681=="

--===============5134501382820336681==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

Free all vector elements when freeing uid_attrs.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 5 +++++
 libmultipath/dict.c   | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 7346c37..bfaf041 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -656,6 +656,9 @@ static struct config *alloc_config (void)
=20
 static void _uninit_config(struct config *conf)
 {
+=09void *ptr;
+=09int i;
+
 =09if (!conf)
 =09=09conf =3D &__internal_config;
=20
@@ -668,6 +671,8 @@ static void _uninit_config(struct config *conf)
 =09if (conf->uid_attribute)
 =09=09free(conf->uid_attribute);
=20
+=09vector_foreach_slot(&conf->uid_attrs, ptr, i)
+=09=09free(ptr);
 =09vector_reset(&conf->uid_attrs);
=20
 =09if (conf->getuid)
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 26cbe78..3b99296 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -597,8 +597,13 @@ static int uid_attrs_handler(struct config *conf, vect=
or strvec,
 =09=09=09     const char *file, int line_nr)
 {
 =09char *val;
+=09void *ptr;
+=09int i;
=20
+=09vector_foreach_slot(&conf->uid_attrs, ptr, i)
+=09=09free(ptr);
 =09vector_reset(&conf->uid_attrs);
+
 =09val =3D set_value(strvec);
 =09if (!val)
 =09=09return 1;
--=20
2.35.1


--===============5134501382820336681==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============5134501382820336681==--

