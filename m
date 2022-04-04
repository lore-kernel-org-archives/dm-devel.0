Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01D95C4332F
	for <dm-devel@archiver.kernel.org>; Mon,  4 Apr 2022 17:05:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-VUKQvFFYMQOFKLPyDiZtcw-1; Mon, 04 Apr 2022 13:05:51 -0400
X-MC-Unique: VUKQvFFYMQOFKLPyDiZtcw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A120805F66;
	Mon,  4 Apr 2022 17:05:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8439640E80E1;
	Mon,  4 Apr 2022 17:05:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2D9AA194037A;
	Mon,  4 Apr 2022 17:05:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DE3DF193F6DD
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Apr 2022 17:05:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D26F6536BBC; Mon,  4 Apr 2022 17:05:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CE08B536BB3
 for <dm-devel@redhat.com>; Mon,  4 Apr 2022 17:05:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF9E41C05EB1
 for <dm-devel@redhat.com>; Mon,  4 Apr 2022 17:05:40 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-si6ceg5pO4abnsbwZg-sZQ-1; Mon, 04 Apr 2022 13:05:33 -0400
X-MC-Unique: si6ceg5pO4abnsbwZg-sZQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 736B01F38A;
 Mon,  4 Apr 2022 17:05:32 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 39D9B12FC5;
 Mon,  4 Apr 2022 17:05:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 6I0eDFwlS2LICAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 04 Apr 2022 17:05:32 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon,  4 Apr 2022 19:04:55 +0200
Message-Id: <20220404170457.16021-14-mwilck@suse.com>
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
Subject: [dm-devel] [PATCH v2 13/15] libmultipath: uevent: add debug
 messages for event queue
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
Content-Type: multipart/mixed; boundary="===============1786489498055392132=="

--===============1786489498055392132==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

For debugging, it's useful to be able to track the event queue
in detail. Enable this at verbosity level 4.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/uevent.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 0dccb0b..5793af9 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -51,6 +51,7 @@
 #include "config.h"
 #include "blacklist.h"
 #include "devmapper.h"
+#include "strbuf.h"
=20
 typedef int (uev_trigger)(struct uevent *, void * trigger_data);
=20
@@ -441,6 +442,40 @@ static void merge_uevq(struct uevent_filter_state *st)
 =09=09=09uevent_merge(later, st);
 }
=20
+static void print_uev(struct strbuf *buf, struct uevent *uev)
+{
+=09print_strbuf(buf, "\"%s %s\"", uev->action, uev->kernel);
+=09if (!list_empty(&uev->merge_node)) {
+=09=09struct uevent *u;
+
+=09=09append_strbuf_str(buf, "[");
+=09=09list_for_each_entry(u, &uev->merge_node, node)
+=09=09=09print_strbuf(buf, "\"%s %s \"", u->action, u->kernel);
+=09=09append_strbuf_str(buf, "]");
+=09}
+=09append_strbuf_str(buf, " ");
+}
+
+static void print_uevq(const char *msg, struct list_head *uevq)
+{
+=09struct uevent *uev;
+=09int i =3D 0;
+=09STRBUF_ON_STACK(buf);
+
+=09if (4 > MAX_VERBOSITY || 4 > libmp_verbosity)
+=09=09return;
+
+=09if (list_empty(uevq))
+=09=09append_strbuf_str(&buf, "*empty*");
+=09else
+=09=09list_for_each_entry(uev, uevq, node) {
+=09=09=09print_strbuf(&buf, "%d:", i++);
+=09=09=09print_uev(&buf, uev);
+=09=09}
+
+=09condlog(4, "uevent queue (%s): %s", msg, steal_strbuf_str(&buf));
+}
+
 static void
 service_uevq(struct list_head *tmpq)
 {
@@ -535,11 +570,13 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent =
*, void * trigger_data),
=20
 =09=09reset_filter_state(&filter_state);
 =09=09pthread_cleanup_push(put_multipath_config, filter_state.conf);
+=09=09print_uevq("append", &filter_state.uevq);
 =09=09filter_state.conf =3D get_multipath_config();
 =09=09merge_uevq(&filter_state);
 =09=09pthread_cleanup_pop(1);
 =09=09log_filter_state(&filter_state);
=20
+=09=09print_uevq("merge", &filter_state.uevq);
 =09=09service_uevq(&filter_state.uevq);
 =09}
 =09pthread_cleanup_pop(1);
--=20
2.35.1


--===============1786489498055392132==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============1786489498055392132==--

