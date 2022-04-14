Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E61FC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 13:18:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-156-b0CiskZLNv-euXBjCJYZ9w-1; Thu, 14 Apr 2022 09:18:30 -0400
X-MC-Unique: b0CiskZLNv-euXBjCJYZ9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70318803CB8;
	Thu, 14 Apr 2022 13:18:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5E8D0C28109;
	Thu, 14 Apr 2022 13:18:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ECFAA1940344;
	Thu, 14 Apr 2022 13:18:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 12C5F19451F2
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 13:18:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0313C2024CDB; Thu, 14 Apr 2022 13:18:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F116E200C0EC
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 13:18:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97FA81014A66
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 13:18:23 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-t3-hccPlNHiFYLvZlCZvRA-1; Thu, 14 Apr 2022 09:18:20 -0400
X-MC-Unique: t3-hccPlNHiFYLvZlCZvRA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 792D11F749;
 Thu, 14 Apr 2022 13:18:18 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4A0C2132C0;
 Thu, 14 Apr 2022 13:18:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id CNaEEBofWGKcQQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 14 Apr 2022 13:18:18 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 14 Apr 2022 15:18:08 +0200
Message-Id: <20220414131811.2551-5-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH 4/7] libmultipath: print error message for
 pg_timeout
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============5240964217966694086=="

--===============5240964217966694086==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

pg_timeout has been deprecated for a long time. Use the same approach
as for config_dir to warn about its use.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dict.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 91a0580..0cef9a7 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -847,6 +847,7 @@ declare_def_snprint_defstr(enable_foreign, print_str,
 =09=09=09   DEFAULT_ENABLE_FOREIGN)
=20
 declare_deprecated_handler(config_dir)
+declare_deprecated_handler(pg_timeout)
=20
 #define declare_def_attr_handler(option, function)=09=09=09\
 static int=09=09=09=09=09=09=09=09\
@@ -2023,7 +2024,7 @@ init_keywords(vector keywords)
 =09install_keyword("queue_without_daemon", &def_queue_without_daemon_handl=
er, &snprint_def_queue_without_daemon);
 =09install_keyword("checker_timeout", &def_checker_timeout_handler, &snpri=
nt_def_checker_timeout);
 =09install_keyword("allow_usb_devices", &def_allow_usb_devices_handler, &s=
nprint_def_allow_usb_devices);
-=09install_keyword("pg_timeout", &deprecated_handler, &snprint_deprecated)=
;
+=09install_keyword("pg_timeout", &deprecated_pg_timeout_handler, &snprint_=
deprecated);
 =09install_keyword("flush_on_last_del", &def_flush_on_last_del_handler, &s=
nprint_def_flush_on_last_del);
 =09install_keyword("user_friendly_names", &def_user_friendly_names_handler=
, &snprint_def_user_friendly_names);
 =09install_keyword("mode", &def_mode_handler, &snprint_def_mode);
--=20
2.35.1


--===============5240964217966694086==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============5240964217966694086==--

