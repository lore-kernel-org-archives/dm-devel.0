Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B279C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 22:15:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-jOmt_okTNhaJzi99L4s8sg-1; Wed, 30 Mar 2022 18:15:37 -0400
X-MC-Unique: jOmt_okTNhaJzi99L4s8sg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB9BC1C0782D;
	Wed, 30 Mar 2022 22:15:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A69E55929D7;
	Wed, 30 Mar 2022 22:15:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 61F301940347;
	Wed, 30 Mar 2022 22:15:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A7C631940355
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 22:15:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 856C5C15D75; Wed, 30 Mar 2022 22:15:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 81ACFC15D42
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68911101A54C
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:31 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-FlNXNUuQNY-RTjkHDAGmXw-1; Wed, 30 Mar 2022 18:15:29 -0400
X-MC-Unique: FlNXNUuQNY-RTjkHDAGmXw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 6A9F41F86A;
 Wed, 30 Mar 2022 22:15:27 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2A3BA13AF3;
 Wed, 30 Mar 2022 22:15:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 6C1GCH/WRGL8JgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 30 Mar 2022 22:15:27 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 31 Mar 2022 00:15:08 +0200
Message-Id: <20220330221510.22578-13-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 12/14] libmultipath: uevent_filter(): filter
 previously merged events
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
Content-Type: multipart/mixed; boundary="===============0411803433557675775=="

--===============0411803433557675775==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

With the new list-appending logic, it can happen that previously
merged events can now be filtered. Do it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/uevent.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index eb900ec..809c74c 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -305,7 +305,7 @@ static void uevent_delete_from_list(struct uevent *to_d=
elete,
 =09 * for the anchor), "old_tail" must be moved. It can happen that
 =09 * "old_tail" ends up pointing at the anchor.
 =09 */
-=09if (*old_tail =3D=3D &to_delete->node)
+=09if (old_tail && *old_tail =3D=3D &to_delete->node)
 =09=09*old_tail =3D to_delete->node.prev;
=20
 =09list_del_init(&to_delete->node);
@@ -360,6 +360,20 @@ uevent_filter(struct uevent *later, struct uevent_filt=
er_state *st)
 =09=09 * filter unnessary earlier uevents
 =09=09 * by the later uevent
 =09=09 */
+=09=09if (!list_empty(&earlier->merge_node)) {
+=09=09=09struct uevent *mn, *t;
+
+=09=09=09list_for_each_entry_reverse_safe(mn, t, &earlier->merge_node, nod=
e) {
+=09=09=09=09if (uevent_can_filter(mn, later)) {
+=09=09=09=09=09condlog(4, "uevent: \"%s %s\" (merged into \"%s %s\") filte=
red by \"%s %s\"",
+=09=09=09=09=09=09mn->action, mn->kernel,
+=09=09=09=09=09=09earlier->action, earlier->kernel,
+=09=09=09=09=09=09later->action, later->kernel);
+=09=09=09=09=09uevent_delete_from_list(mn, &t, NULL);
+=09=09=09=09=09st->filtered++;
+=09=09=09=09}
+=09=09=09}
+=09=09}
 =09=09if (uevent_can_filter(earlier, later)) {
 =09=09=09condlog(3, "uevent: %s-%s has filtered by uevent: %s-%s",
 =09=09=09=09earlier->kernel, earlier->action,
--=20
2.35.1


--===============0411803433557675775==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============0411803433557675775==--

