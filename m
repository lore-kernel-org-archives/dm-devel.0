Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E37EC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 13:18:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-1alcDjz_Prib9Q44XinRhg-1; Thu, 14 Apr 2022 09:18:26 -0400
X-MC-Unique: 1alcDjz_Prib9Q44XinRhg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C95A21C068FF;
	Thu, 14 Apr 2022 13:18:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B6D8F416147;
	Thu, 14 Apr 2022 13:18:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5A5DA194034B;
	Thu, 14 Apr 2022 13:18:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 643FD19451F2
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 13:18:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 31830C15D7E; Thu, 14 Apr 2022 13:18:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DC59C159B3
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 13:18:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FA2A811E84
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 13:18:23 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-4OwyYdWiMfKxYLOPlp9V7g-1; Thu, 14 Apr 2022 09:18:19 -0400
X-MC-Unique: 4OwyYdWiMfKxYLOPlp9V7g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id B387E21616;
 Thu, 14 Apr 2022 13:18:17 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 85429132C0;
 Thu, 14 Apr 2022 13:18:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id AEv1HhkfWGKcQQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 14 Apr 2022 13:18:17 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 14 Apr 2022 15:18:05 +0200
Message-Id: <20220414131811.2551-2-mwilck@suse.com>
In-Reply-To: <20220414131811.2551-1-mwilck@suse.com>
References: <20220414131811.2551-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 1/7] libmultipath: add
 declare_deprecated_handler() helper
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
Content-Type: multipart/mixed; boundary="===============7257206306132038948=="

--===============7257206306132038948==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

this is like declare_def_warn_handler(), but for options that we
really don't support any more.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dict.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 4f7cdb3..0be4309 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -287,6 +287,22 @@ def_ ## option ## _handler (struct config *conf, vecto=
r strvec,=09=09\
 =09return function (strvec, &conf->option, file, line_nr);=09=09\
 }
=20
+static int deprecated_handler(struct config *conf, vector strvec, const ch=
ar *file,
+=09=09=09      int line_nr);
+
+#define declare_deprecated_handler(option)=09=09=09=09\
+static int=09=09=09=09=09=09=09=09\
+def_ ## option ## _handler (struct config *conf, vector strvec,=09=09\
+=09=09=09    const char *file, int line_nr)=09=09\
+{=09=09=09=09=09=09=09=09=09\
+=09static bool warned;=09=09=09=09=09=09\
+=09if (!warned) {=09=09=09=09=09=09=09\
+=09=09condlog(1, "%s line %d: ignoring deprecated option \"" #option "\"",=
 file, line_nr); \
+=09=09warned =3D true;=09=09=09=09=09=09\
+=09}=09=09=09=09=09=09=09=09\
+=09return deprecated_handler(conf, strvec, file, line_nr);=09=09\
+}
+
 #define declare_def_range_handler(option, minval, maxval)=09=09=09\
 static int=09=09=09=09=09=09=09=09\
 def_ ## option ## _handler (struct config *conf, vector strvec,         \
--=20
2.35.1


--===============7257206306132038948==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============7257206306132038948==--

