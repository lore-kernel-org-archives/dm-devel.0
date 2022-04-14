Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03034C4321E
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 13:18:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-6u9MjvjSNMeiMIIS0ldOKQ-1; Thu, 14 Apr 2022 09:18:26 -0400
X-MC-Unique: 6u9MjvjSNMeiMIIS0ldOKQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A2BD86B8B2;
	Thu, 14 Apr 2022 13:18:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 580CD416147;
	Thu, 14 Apr 2022 13:18:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 15F931940345;
	Thu, 14 Apr 2022 13:18:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E4FD319451F2
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 13:18:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D374C40470C2; Thu, 14 Apr 2022 13:18:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CF7F8403D1DD
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 13:18:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B639B1014A64
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 13:18:21 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-owaegLdlOj610WNsAfOQ3Q-1; Thu, 14 Apr 2022 09:18:20 -0400
X-MC-Unique: owaegLdlOj610WNsAfOQ3Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id AEA061F74A;
 Thu, 14 Apr 2022 13:18:18 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 80DF8132C0;
 Thu, 14 Apr 2022 13:18:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id UGnYHRofWGKcQQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 14 Apr 2022 13:18:18 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 14 Apr 2022 15:18:09 +0200
Message-Id: <20220414131811.2551-6-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH 5/7] libmultipath: remove support for
 long-deprecated options
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
Content-Type: multipart/mixed; boundary="===============2808883623529297139=="

--===============2808883623529297139==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

The following options have been superseded by their equivalents without
"default_" prefix for a very long time:

 - default_selector
 - default_path_grouping_policy
 - default_uid_attribute
 - default_getuid_callout
 - default_features
 - default_path_checker

Remove them.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dict.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 0cef9a7..c380350 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1990,8 +1990,6 @@ snprint_deprecated (struct config *conf, struct strbu=
f *buff, const void * data)
 =09return 0;
 }
=20
-#define __deprecated
-
 /*
  * If you add or remove a keyword also update multipath/multipath.conf.5
  */
@@ -2074,12 +2072,6 @@ init_keywords(vector keywords)
 =09=09=09&snprint_def_enable_foreign);
 =09install_keyword("marginal_pathgroups", &def_marginal_pathgroups_handler=
, &snprint_def_marginal_pathgroups);
 =09install_keyword("recheck_wwid", &def_recheck_wwid_handler, &snprint_def=
_recheck_wwid);
-=09__deprecated install_keyword("default_selector", &def_selector_handler,=
 NULL);
-=09__deprecated install_keyword("default_path_grouping_policy", &def_pgpol=
icy_handler, NULL);
-=09__deprecated install_keyword("default_uid_attribute", &def_uid_attribut=
e_handler, NULL);
-=09__deprecated install_keyword("default_getuid_callout", &def_getuid_hand=
ler, NULL);
-=09__deprecated install_keyword("default_features", &def_features_handler,=
 NULL);
-=09__deprecated install_keyword("default_path_checker", &def_checker_name_=
handler, NULL);
=20
 =09install_keyword_root("blacklist", &blacklist_handler);
 =09install_keyword_multi("devnode", &ble_blist_devnode_handler, &snprint_b=
le_simple);
@@ -2102,16 +2094,6 @@ init_keywords(vector keywords)
 =09install_keyword("product", &ble_elist_device_product_handler, &snprint_=
bled_product);
 =09install_sublevel_end();
=20
-#if 0
-=09__deprecated install_keyword_root("devnode_blacklist", &blacklist_handl=
er);
-=09__deprecated install_keyword("devnode", &ble_devnode_handler, &snprint_=
ble_simple);
-=09__deprecated install_keyword("wwid", &ble_wwid_handler, &snprint_ble_si=
mple);
-=09__deprecated install_keyword("device", &ble_device_handler, NULL);
-=09__deprecated install_sublevel();
-=09__deprecated install_keyword("vendor", &ble_vendor_handler, &snprint_bl=
ed_vendor);
-=09__deprecated install_keyword("product", &ble_product_handler, &snprint_=
bled_product);
-=09__deprecated install_sublevel_end();
-#endif
 /*
  * If you add or remove a "device subsection" keyword also update
  * multipath/multipath.conf.5 and the TEMPLATE in libmultipath/hwtable.c
--=20
2.35.1


--===============2808883623529297139==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============2808883623529297139==--

