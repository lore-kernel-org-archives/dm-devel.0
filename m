Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12BF4C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 22:15:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-W-Hshh8cOyGU9AX0jzHvXQ-1; Wed, 30 Mar 2022 18:15:40 -0400
X-MC-Unique: W-Hshh8cOyGU9AX0jzHvXQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 218D038008C7;
	Wed, 30 Mar 2022 22:15:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0EBF6401E39;
	Wed, 30 Mar 2022 22:15:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DF49119466DF;
	Wed, 30 Mar 2022 22:15:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2286019451F3
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 22:15:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 12F5B112131E; Wed, 30 Mar 2022 22:15:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E1EE1121314
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D074E38008A3
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:28 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-ynzI_BOsOkud2KlpAI-rUg-1; Wed, 30 Mar 2022 18:15:25 -0400
X-MC-Unique: ynzI_BOsOkud2KlpAI-rUg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id DB480218F8;
 Wed, 30 Mar 2022 22:15:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9A82513B1E;
 Wed, 30 Mar 2022 22:15:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 2OiiI3vWRGL8JgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 30 Mar 2022 22:15:23 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 31 Mar 2022 00:14:57 +0200
Message-Id: <20220330221510.22578-2-mwilck@suse.com>
In-Reply-To: <20220330221510.22578-1-mwilck@suse.com>
References: <20220330221510.22578-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH 01/14] multipathd: allow adding git rev as
 version suffix
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, tang.junhui@zte.com.cn
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============9181348639222347870=="

--===============9181348639222347870==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

Use the make variable EXTRAVERSION to hold a version suffix,
and print it on multipathd startup. By default, EXTRAVERSION is
the 7-digit git rev in the format "-g1234567" if git is available,
and empty otherwise. Build systems can pass in alternative
EXTRAVERSION strings as they prefer.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc      | 3 ++-
 multipathd/main.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index d24da43..120f671 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -13,6 +13,7 @@
 # SCSI_DH_MODULES_PRELOAD :=3D scsi_dh_alua scsi_dh_rdac
 SCSI_DH_MODULES_PRELOAD :=3D
=20
+EXTRAVERSION :=3D $(shell rev=3D$$(git rev-parse --short=3D7 HEAD 2>/dev/n=
ull); echo $${rev:+-g$$rev})
=20
 PKGCONFIG=09?=3D pkg-config
=20
@@ -126,7 +127,7 @@ WARNFLAGS=09:=3D -Werror -Wall -Wextra -Wformat=3D2 $(W=
FORMATOVERFLOW) -Werror=3Dimplici
 CPPFLAGS=09:=3D -Wp,-D_FORTIFY_SOURCE=3D2
 CFLAGS=09=09:=3D --std=3Dgnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
 =09=09   -DBIN_DIR=3D\"$(bindir)\" -DLIB_STRING=3D\"${LIB}\" -DRUN_DIR=3D\=
"${RUN}\" \
-=09=09   -MMD -MP
+=09=09   -DEXTRAVERSION=3D\"$(EXTRAVERSION)\" -MMD -MP
 BIN_CFLAGS=09=3D -fPIE -DPIE
 LIB_CFLAGS=09=3D -fPIC
 SHARED_FLAGS=09=3D -shared
diff --git a/multipathd/main.c b/multipathd/main.c
index 1406251..3a31154 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3247,7 +3247,8 @@ child (__attribute__((unused)) void *param)
=20
 =09post_config_state(DAEMON_START);
=20
-=09condlog(2, "multipathd v%d.%d.%d: start up", MULTIPATH_VERSION(VERSION_=
CODE));
+=09condlog(2, "multipathd v%d.%d.%d%s: start up",
+=09=09MULTIPATH_VERSION(VERSION_CODE), EXTRAVERSION);
 =09condlog(3, "read " DEFAULT_CONFIGFILE);
=20
 =09if (verbosity)
--=20
2.35.1


--===============9181348639222347870==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============9181348639222347870==--

