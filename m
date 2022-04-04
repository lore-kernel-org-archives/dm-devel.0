Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A37CC433FE
	for <dm-devel@archiver.kernel.org>; Mon,  4 Apr 2022 17:05:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-VfUTwUIEPEWohdSVmtufqA-1; Mon, 04 Apr 2022 13:05:49 -0400
X-MC-Unique: VfUTwUIEPEWohdSVmtufqA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03958100BAA9;
	Mon,  4 Apr 2022 17:05:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E455340E80E8;
	Mon,  4 Apr 2022 17:05:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C2A80193F50E;
	Mon,  4 Apr 2022 17:05:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B87A219451EF
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Apr 2022 17:05:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9BA011454547; Mon,  4 Apr 2022 17:05:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 97D711454535
 for <dm-devel@redhat.com>; Mon,  4 Apr 2022 17:05:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D2A81C05EBE
 for <dm-devel@redhat.com>; Mon,  4 Apr 2022 17:05:34 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-279-48vuuhvmO8uuEmNvU7eUCA-1; Mon, 04 Apr 2022 13:05:33 -0400
X-MC-Unique: 48vuuhvmO8uuEmNvU7eUCA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id DB54221110;
 Mon,  4 Apr 2022 17:05:31 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A08B512FC5;
 Mon,  4 Apr 2022 17:05:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id eD8jJVslS2LICAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 04 Apr 2022 17:05:31 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon,  4 Apr 2022 19:04:53 +0200
Message-Id: <20220404170457.16021-12-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v2 11/15] libmultipath: uevent_filter(): filter
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============2438978019271560453=="

--===============2438978019271560453==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

With the new list-appending logic, it can happen that previously
merged events can now be filtered. Do it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/uevent.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index b00ae3c..6e8c443 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -375,6 +375,20 @@ uevent_filter(struct uevent *later, struct uevent_filt=
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
+=09=09=09=09=09uevent_delete_simple(mn);
+=09=09=09=09=09st->filtered++;
+=09=09=09=09}
+=09=09=09}
+=09=09}
 =09=09if (uevent_can_filter(earlier, later)) {
 =09=09=09condlog(3, "uevent: %s-%s has filtered by uevent: %s-%s",
 =09=09=09=09earlier->kernel, earlier->action,
--=20
2.35.1


--===============2438978019271560453==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============2438978019271560453==--

