Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD74CC4332F
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 22:15:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-FbmHEGT7Mcu6atR_RB92dw-1; Wed, 30 Mar 2022 18:15:34 -0400
X-MC-Unique: FbmHEGT7Mcu6atR_RB92dw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93D0780418B;
	Wed, 30 Mar 2022 22:15:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3A12140CFD07;
	Wed, 30 Mar 2022 22:15:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 81ED9194034E;
	Wed, 30 Mar 2022 22:15:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 634E119466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 22:15:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 447701400C30; Wed, 30 Mar 2022 22:15:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 404FF1410F3B
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C7E51C0782D
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:30 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-piIUMQ4WPd2oA2naYUVFCA-1; Wed, 30 Mar 2022 18:15:26 -0400
X-MC-Unique: piIUMQ4WPd2oA2naYUVFCA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 28B03218FD;
 Wed, 30 Mar 2022 22:15:25 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DD1B013AF3;
 Wed, 30 Mar 2022 22:15:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id iEUNNHzWRGL8JgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 30 Mar 2022 22:15:24 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 31 Mar 2022 00:15:01 +0200
Message-Id: <20220330221510.22578-6-mwilck@suse.com>
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
Subject: [dm-devel] [PATCH 05/14] libmultipath: uevent_dispatch(): only
 filter/merge new uevents
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============9145111521972047728=="

--===============9145111521972047728==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

When uevq_work is non-empty and we append a list of new events,
we don't need to check the entire list for filterable and mergeable
uevents. uevq_work had been filtered and merged already. So we just
need to check the newly appended events. These must of course be
checked for merges with earlier events, too.

We must deal with some special cases here, like previously merged
uevents being filtered later.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/list.h   | 24 ++++++++++++++
 libmultipath/uevent.c | 77 +++++++++++++++++++++++++++++++++----------
 2 files changed, 83 insertions(+), 18 deletions(-)

diff --git a/libmultipath/list.h b/libmultipath/list.h
index ddea99f..248f72b 100644
--- a/libmultipath/list.h
+++ b/libmultipath/list.h
@@ -363,6 +363,30 @@ static inline struct list_head *list_pop(struct list_h=
ead *head)
 =09     &pos->member !=3D (head);                                    \
 =09     pos =3D n, n =3D list_entry(n->member.prev, typeof(*n), member))
=20
+/**
+ * list_for_some_entry - iterate list from the given begin node to the giv=
en end node
+ * @pos:=09the type * to use as a loop counter.
+ * @from:=09the begin node of the iteration.
+ * @to:=09=09the end node of the iteration.
+ * @member:=09the name of the list_struct within the struct.
+ */
+#define list_for_some_entry(pos, from, to, member)                      \
+=09for (pos =3D list_entry((from)->next, typeof(*pos), member);      \
+=09     &pos->member !=3D (to);                                      \
+=09     pos =3D list_entry(pos->member.next, typeof(*pos), member))
+
+/**
+ * list_for_some_entry_reverse - iterate backwards list from the given beg=
in node to the given end node
+ * @pos:=09the type * to use as a loop counter.
+ * @from:=09the begin node of the iteration.
+ * @to:=09=09the end node of the iteration.
+ * @member:=09the name of the list_struct within the struct.
+ */
+#define list_for_some_entry_reverse(pos, from, to, member)=09=09\
+=09for (pos =3D list_entry((from)->prev, typeof(*pos), member);      \
+=09     &pos->member !=3D (to);                                      \
+=09     pos =3D list_entry(pos->member.prev, typeof(*pos), member))
+
 /**
  * list_for_some_entry_safe - iterate list from the given begin node to th=
e given end node safe against removal of list entry
  * @pos:=09the type * to use as a loop counter.
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 602eccb..2779703 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -306,17 +306,49 @@ uevent_can_merge(struct uevent *earlier, struct ueven=
t *later)
 =09return false;
 }
=20
+static void uevent_delete_from_list(struct uevent *to_delete,
+=09=09=09=09    struct uevent **previous,
+=09=09=09=09    struct list_head **old_tail)
+{
+=09/*
+=09 * "old_tail" is the list_head before the last list element to which
+=09 * the caller iterates (the list anchor if the caller iterates over
+=09 * the entire list). If this element is removed (which can't happen
+=09 * for the anchor), "old_tail" must be moved. It can happen that
+=09 * "old_tail" ends up pointing at the anchor.
+=09 */
+=09if (*old_tail =3D=3D &to_delete->node)
+=09=09*old_tail =3D to_delete->node.prev;
+
+=09list_del_init(&to_delete->node);
+
+=09/*
+=09 * The "to_delete" uevent has been merged with other uevents
+=09 * previously. Re-insert them into the list, at the point we're
+=09 * currently at. This must be done after the list_del_init() above,
+=09 * otherwise previous->next would still point to to_delete.
+=09 */
+=09if (!list_empty(&to_delete->merge_node)) {
+=09=09struct uevent *last =3D list_entry(to_delete->merge_node.prev,
+=09=09=09=09=09=09 typeof(*last), node);
+
+=09=09list_splice(&to_delete->merge_node, &(*previous)->node);
+=09=09*previous =3D last;
+=09}
+=09if (to_delete->udev)
+=09=09udev_device_unref(to_delete->udev);
+
+=09free(to_delete);
+}
+
 static void
-uevent_prepare(struct list_head *tmpq)
+uevent_prepare(struct list_head *tmpq, struct list_head **stop)
 {
 =09struct uevent *uev, *tmp;
=20
-=09list_for_each_entry_reverse_safe(uev, tmp, tmpq, node) {
+=09list_for_some_entry_reverse_safe(uev, tmp, tmpq, *stop, node) {
 =09=09if (uevent_can_discard(uev)) {
-=09=09=09list_del_init(&uev->node);
-=09=09=09if (uev->udev)
-=09=09=09=09udev_device_unref(uev->udev);
-=09=09=09free(uev);
+=09=09=09uevent_delete_from_list(uev, &tmp, stop);
 =09=09=09continue;
 =09=09}
=20
@@ -327,7 +359,7 @@ uevent_prepare(struct list_head *tmpq)
 }
=20
 static void
-uevent_filter(struct uevent *later, struct list_head *tmpq)
+uevent_filter(struct uevent *later, struct list_head *tmpq, struct list_he=
ad **stop)
 {
 =09struct uevent *earlier, *tmp;
=20
@@ -341,16 +373,13 @@ uevent_filter(struct uevent *later, struct list_head =
*tmpq)
 =09=09=09=09earlier->kernel, earlier->action,
 =09=09=09=09later->kernel, later->action);
=20
-=09=09=09list_del_init(&earlier->node);
-=09=09=09if (earlier->udev)
-=09=09=09=09udev_device_unref(earlier->udev);
-=09=09=09free(earlier);
+=09=09=09uevent_delete_from_list(earlier, &tmp, stop);
 =09=09}
 =09}
 }
=20
 static void
-uevent_merge(struct uevent *later, struct list_head *tmpq)
+uevent_merge(struct uevent *later, struct list_head *tmpq, struct list_hea=
d **stop)
 {
 =09struct uevent *earlier, *tmp;
=20
@@ -365,6 +394,10 @@ uevent_merge(struct uevent *later, struct list_head *t=
mpq)
 =09=09=09=09earlier->action, earlier->kernel, earlier->wwid,
 =09=09=09=09later->action, later->kernel, later->wwid);
=20
+=09=09=09/* See comment in uevent_delete_from_list() */
+=09=09=09if (&earlier->node =3D=3D *stop)
+=09=09=09=09*stop =3D earlier->node.prev;
+
 =09=09=09list_move(&earlier->node, &later->merge_node);
 =09=09=09list_splice_init(&earlier->merge_node,
 =09=09=09=09=09 &later->merge_node);
@@ -373,15 +406,15 @@ uevent_merge(struct uevent *later, struct list_head *=
tmpq)
 }
=20
 static void
-merge_uevq(struct list_head *tmpq)
+merge_uevq(struct list_head *tmpq, struct list_head *stop)
 {
 =09struct uevent *later;
=20
-=09uevent_prepare(tmpq);
-=09list_for_each_entry_reverse(later, tmpq, node) {
-=09=09uevent_filter(later, tmpq);
+=09uevent_prepare(tmpq, &stop);
+=09list_for_some_entry_reverse(later, tmpq, stop, node) {
+=09=09uevent_filter(later, tmpq, &stop);
 =09=09if(uevent_need_merge())
-=09=09=09uevent_merge(later, tmpq);
+=09=09=09uevent_merge(later, tmpq, &stop);
 =09}
 }
=20
@@ -442,6 +475,7 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *,=
 void * trigger_data),
=20
 =09pthread_cleanup_push(cleanup_uevq, &uevq_work);
 =09while (1) {
+=09=09struct list_head *stop;
=20
 =09=09pthread_cleanup_push(cleanup_mutex, uevq_lockp);
 =09=09pthread_mutex_lock(uevq_lockp);
@@ -452,13 +486,20 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent =
*, void * trigger_data),
 =09=09=09pthread_cond_wait(uev_condp, uevq_lockp);
=20
 =09=09servicing_uev =3D 1;
+=09=09/*
+=09=09 * "stop" is the list element towards which merge_uevq()
+=09=09 * will iterate: the last element of uevq_work before
+=09=09 * appending new uevents. If uveq_is empty, uevq_work.prev
+=09=09 * equals &uevq_work, which is what we need.
+=09=09 */
+=09=09stop =3D uevq_work.prev;
 =09=09list_splice_tail_init(&uevq, &uevq_work);
 =09=09pthread_cleanup_pop(1);
=20
 =09=09if (!my_uev_trigger)
 =09=09=09break;
=20
-=09=09merge_uevq(&uevq_work);
+=09=09merge_uevq(&uevq_work, stop);
 =09=09service_uevq(&uevq_work);
 =09}
 =09pthread_cleanup_pop(1);
--=20
2.35.1


--===============9145111521972047728==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============9145111521972047728==--

