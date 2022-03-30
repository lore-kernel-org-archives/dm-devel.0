Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC139C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 22:15:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-Erz_B2vHODu7dvRQFDGo6A-1; Wed, 30 Mar 2022 18:15:37 -0400
X-MC-Unique: Erz_B2vHODu7dvRQFDGo6A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D88D100BAB6;
	Wed, 30 Mar 2022 22:15:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1BAD25929CA;
	Wed, 30 Mar 2022 22:15:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ABF681940340;
	Wed, 30 Mar 2022 22:15:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 39E8B1940347
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 22:15:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2A1AA1400B1C; Wed, 30 Mar 2022 22:15:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 263A31410F3B
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F1E7803D7C
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:33 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-6v_MZ8N8Nkmny-ra05iNmg-1; Wed, 30 Mar 2022 18:15:29 -0400
X-MC-Unique: 6v_MZ8N8Nkmny-ra05iNmg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id B8DFA21901;
 Wed, 30 Mar 2022 22:15:27 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 77BFE13AF3;
 Wed, 30 Mar 2022 22:15:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id ONUsG3/WRGL8JgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 30 Mar 2022 22:15:27 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 31 Mar 2022 00:15:09 +0200
Message-Id: <20220330221510.22578-14-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH 13/14] libmultipath: uevent: improve log messages
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
Content-Type: multipart/mixed; boundary="===============7247257346440773388=="

--===============7247257346440773388==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

Use common format "\add sdl\", and log this detail only at
verbosity 4.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/uevent.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 809c74c..a5c2f3c 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -375,9 +375,9 @@ uevent_filter(struct uevent *later, struct uevent_filte=
r_state *st)
 =09=09=09}
 =09=09}
 =09=09if (uevent_can_filter(earlier, later)) {
-=09=09=09condlog(3, "uevent: %s-%s has filtered by uevent: %s-%s",
-=09=09=09=09earlier->kernel, earlier->action,
-=09=09=09=09later->kernel, later->action);
+=09=09=09condlog(4, "uevent: \"%s %s\" filtered by \"%s %s\"",
+=09=09=09=09earlier->action, earlier->kernel,
+=09=09=09=09later->action, later->kernel);
=20
 =09=09=09uevent_delete_from_list(earlier, &tmp, &st->old_tail);
 =09=09=09st->filtered++;
@@ -396,8 +396,8 @@ static void uevent_merge(struct uevent *later, struct u=
event_filter_state *st)
 =09=09 * merge earlier uevents to the later uevent
 =09=09 */
 =09=09if (uevent_can_merge(earlier, later)) {
-=09=09=09condlog(3, "merged uevent: %s-%s-%s with uevent: %s-%s-%s",
-=09=09=09=09earlier->action, earlier->kernel, earlier->wwid,
+=09=09=09condlog(4, "uevent: \"%s %s\" merged with \"%s %s\" for WWID %s",
+=09=09=09=09earlier->action, earlier->kernel,
 =09=09=09=09later->action, later->kernel, later->wwid);
=20
 =09=09=09/* See comment in uevent_delete_from_list() */
--=20
2.35.1


--===============7247257346440773388==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============7247257346440773388==--

