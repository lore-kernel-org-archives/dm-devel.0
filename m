Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 356B8C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  4 Apr 2022 17:05:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-HEn7Ss2LPV-CEGLP0TOd9w-1; Mon, 04 Apr 2022 13:05:48 -0400
X-MC-Unique: HEn7Ss2LPV-CEGLP0TOd9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8097383396A;
	Mon,  4 Apr 2022 17:05:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A6A9C27E85;
	Mon,  4 Apr 2022 17:05:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 094A3193F518;
	Mon,  4 Apr 2022 17:05:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6E006193F6EA
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Apr 2022 17:05:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 612FB140241F; Mon,  4 Apr 2022 17:05:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D952140262B
 for <dm-devel@redhat.com>; Mon,  4 Apr 2022 17:05:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 435A9802809
 for <dm-devel@redhat.com>; Mon,  4 Apr 2022 17:05:36 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-jEpuCEyzNoWb6Ygh08huHA-1; Mon, 04 Apr 2022 13:05:32 -0400
X-MC-Unique: jEpuCEyzNoWb6Ygh08huHA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 4AE991F385;
 Mon,  4 Apr 2022 17:05:31 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 11C7E12FC5;
 Mon,  4 Apr 2022 17:05:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id iE0UAlslS2LICAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 04 Apr 2022 17:05:31 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon,  4 Apr 2022 19:04:51 +0200
Message-Id: <20220404170457.16021-10-mwilck@suse.com>
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
Subject: [dm-devel] [PATCH v2 09/15] libmultipath: uevent: log statistics
 about filtering and merging
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
Content-Type: multipart/mixed; boundary="===============4767869043521276888=="

--===============4767869043521276888==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

also, log sleep/wakeup in uevent_dispatch().

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/uevent.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 8809f5c..a3dd752 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -67,8 +67,17 @@ struct uevent_filter_state {
 =09struct list_head uevq;
 =09struct list_head *old_tail;
 =09struct config *conf;
+=09unsigned long added;
+=09unsigned long discarded;
+=09unsigned long filtered;
+=09unsigned long merged;
 };
=20
+static void reset_filter_state(struct uevent_filter_state *st)
+{
+=09st->added =3D st->discarded =3D st->filtered =3D st->merged =3D 0;
+}
+
 int is_uevent_busy(void)
 {
 =09int empty;
@@ -311,6 +320,8 @@ static void uevent_delete_from_list(struct uevent *to_d=
elete,
 =09=09struct uevent *last =3D list_entry(to_delete->merge_node.prev,
 =09=09=09=09=09=09 typeof(*last), node);
=20
+=09=09condlog(3, "%s: deleted uevent \"%s %s\" with merged uevents",
+=09=09=09__func__, to_delete->action, to_delete->kernel);
 =09=09list_splice(&to_delete->merge_node, &(*previous)->node);
 =09=09*previous =3D last;
 =09}
@@ -340,8 +351,11 @@ static void uevent_prepare(struct uevent_filter_state =
*st)
 =09struct uevent *uev, *tmp;
=20
 =09list_for_some_entry_reverse_safe(uev, tmp, &st->uevq, st->old_tail, nod=
e) {
+
+=09=09st->added++;
 =09=09if (uevent_can_discard(uev, st->conf)) {
 =09=09=09uevent_delete_simple(uev);
+=09=09=09st->discarded++;
 =09=09=09continue;
 =09=09}
=20
@@ -367,6 +381,7 @@ uevent_filter(struct uevent *later, struct uevent_filte=
r_state *st)
 =09=09=09=09later->kernel, later->action);
=20
 =09=09=09uevent_delete_from_list(earlier, &tmp, &st->old_tail);
+=09=09=09st->filtered++;
 =09=09}
 =09}
 }
@@ -393,6 +408,7 @@ static void uevent_merge(struct uevent *later, struct u=
event_filter_state *st)
 =09=09=09list_move(&earlier->node, &later->merge_node);
 =09=09=09list_splice_init(&earlier->merge_node,
 =09=09=09=09=09 &later->merge_node);
+=09=09=09st->merged++;
 =09=09}
 =09}
 }
@@ -451,6 +467,15 @@ static void cleanup_global_uevq(void *arg __attribute_=
_((unused)))
 =09pthread_mutex_unlock(uevq_lockp);
 }
=20
+static void log_filter_state(const struct uevent_filter_state *st)
+{
+=09if (st->added =3D=3D 0 && st->filtered =3D=3D 0 && st->merged =3D=3D 0)
+=09=09return;
+
+=09condlog(3, "uevents: %lu added, %lu discarded, %lu filtered, %lu merged=
",
+=09=09st->added, st->discarded, st->filtered, st->merged);
+}
+
 /*
  * Service the uevent queue.
  */
@@ -472,8 +497,11 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *=
, void * trigger_data),
=20
 =09=09servicing_uev =3D !list_empty(&filter_state.uevq);
=20
-=09=09while (list_empty(&filter_state.uevq) && list_empty(&uevq))
+=09=09while (list_empty(&filter_state.uevq) && list_empty(&uevq)) {
+=09=09=09condlog(4, "%s: waiting for events", __func__);
 =09=09=09pthread_cond_wait(uev_condp, uevq_lockp);
+=09=09=09condlog(4, "%s: waking up", __func__);
+=09=09}
=20
 =09=09servicing_uev =3D 1;
 =09=09/*
@@ -489,11 +517,12 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent =
*, void * trigger_data),
 =09=09if (!my_uev_trigger)
 =09=09=09break;
=20
-
+=09=09reset_filter_state(&filter_state);
 =09=09pthread_cleanup_push(put_multipath_config, filter_state.conf);
 =09=09filter_state.conf =3D get_multipath_config();
 =09=09merge_uevq(&filter_state);
 =09=09pthread_cleanup_pop(1);
+=09=09log_filter_state(&filter_state);
=20
 =09=09service_uevq(&filter_state.uevq);
 =09}
--=20
2.35.1


--===============4767869043521276888==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============4767869043521276888==--

