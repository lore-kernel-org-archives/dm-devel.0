Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 936B7C43219
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 22:15:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-NFc_XG_jNiq6NYaZ4IdrRg-1; Wed, 30 Mar 2022 18:15:41 -0400
X-MC-Unique: NFc_XG_jNiq6NYaZ4IdrRg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0338380051D;
	Wed, 30 Mar 2022 22:15:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BFEDF5929CA;
	Wed, 30 Mar 2022 22:15:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AADFF19451F3;
	Wed, 30 Mar 2022 22:15:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 95DEB1947BBE
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 22:15:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8680D2166B14; Wed, 30 Mar 2022 22:15:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 80D312166B5D
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A960610115F6
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:28 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-SFNhXwjkMx2QN2myIP_Gkw-1; Wed, 30 Mar 2022 18:15:27 -0400
X-MC-Unique: SFNhXwjkMx2QN2myIP_Gkw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id C87C61F86F;
 Wed, 30 Mar 2022 22:15:25 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8513C13AF3;
 Wed, 30 Mar 2022 22:15:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id KApfHn3WRGL8JgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 30 Mar 2022 22:15:25 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 31 Mar 2022 00:15:03 +0200
Message-Id: <20220330221510.22578-8-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH 07/14] libmultipath: microoptimize uevent
 filtering and merging
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============3094553296602123435=="

--===============3094553296602123435==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

Simplify and microoptimize the filtering and merging tests.
E.g. do the WWID comparison last.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/uevent.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 2779703..0de9c6b 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -220,6 +220,10 @@ static bool
 uevent_can_filter(struct uevent *earlier, struct uevent *later)
 {
=20
+=09if (!strncmp(later->kernel, "dm-", 3) ||
+=09    strcmp(earlier->kernel, later->kernel))
+=09=09return false;
+
 =09/*
 =09 * filter earlier uvents if path has removed later. Eg:
 =09 * "add path1 |chang path1 |add path2 |remove path1"
@@ -227,11 +231,8 @@ uevent_can_filter(struct uevent *earlier, struct ueven=
t *later)
 =09 * "add path2 |remove path1"
 =09 * uevents "add path1" and "chang path1" are filtered out
 =09 */
-=09if (!strcmp(earlier->kernel, later->kernel) &&
-=09=09!strcmp(later->action, "remove") &&
-=09=09strncmp(later->kernel, "dm-", 3)) {
+=09if (!strcmp(later->action, "remove"))
 =09=09return true;
-=09}
=20
 =09/*
 =09 * filter change uvents if add uevents exist. Eg:
@@ -240,12 +241,9 @@ uevent_can_filter(struct uevent *earlier, struct ueven=
t *later)
 =09 * "add path1 |add path2"
 =09 * uevent "chang path1" is filtered out
 =09 */
-=09if (!strcmp(earlier->kernel, later->kernel) &&
-=09=09!strcmp(earlier->action, "change") &&
-=09=09!strcmp(later->action, "add") &&
-=09=09strncmp(later->kernel, "dm-", 3)) {
+=09if (!strcmp(earlier->action, "change") &&
+=09    !strcmp(later->action, "add"))
 =09=09return true;
-=09}
=20
 =09return false;
 }
@@ -278,10 +276,10 @@ merge_need_stop(struct uevent *earlier, struct uevent=
 *later)
 =09 * with the same wwid and different action
 =09 * it would be better to stop merging.
 =09 */
-=09if (!strcmp(earlier->wwid, later->wwid) &&
-=09    strcmp(earlier->action, later->action) &&
+=09if (strcmp(earlier->action, later->action) &&
 =09    strcmp(earlier->action, "change") &&
-=09    strcmp(later->action, "change"))
+=09    strcmp(later->action, "change") &&
+=09    !strcmp(earlier->wwid, later->wwid))
 =09=09return true;
=20
 =09return false;
@@ -296,12 +294,12 @@ uevent_can_merge(struct uevent *earlier, struct ueven=
t *later)
 =09 * and actions are addition or deletion
 =09 */
 =09if (earlier->wwid && later->wwid &&
-=09    !strcmp(earlier->wwid, later->wwid) &&
+=09    strncmp(earlier->kernel, "dm-", 3) &&
 =09    !strcmp(earlier->action, later->action) &&
-=09    strncmp(earlier->action, "change", 6) &&
-=09    strncmp(earlier->kernel, "dm-", 3)) {
+=09    (!strcmp(earlier->action, "add") ||
+=09     !strcmp(earlier->action, "remove")) &&
+=09    !strcmp(earlier->wwid, later->wwid))
 =09=09return true;
-=09}
=20
 =09return false;
 }
--=20
2.35.1


--===============3094553296602123435==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============3094553296602123435==--

