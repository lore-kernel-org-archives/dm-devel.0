Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6559EC4332F
	for <dm-devel@archiver.kernel.org>; Mon,  4 Apr 2022 17:05:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-fzDiTuDnM6G1hOgyV-5qiQ-1; Mon, 04 Apr 2022 13:05:51 -0400
X-MC-Unique: fzDiTuDnM6G1hOgyV-5qiQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C40B938009F4;
	Mon,  4 Apr 2022 17:05:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AE8611454547;
	Mon,  4 Apr 2022 17:05:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B8A96194037B;
	Mon,  4 Apr 2022 17:05:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AC3BE194EB9A
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Apr 2022 17:05:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8C1FD536BBC; Mon,  4 Apr 2022 17:05:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8830C536BBD
 for <dm-devel@redhat.com>; Mon,  4 Apr 2022 17:05:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C63C280359D
 for <dm-devel@redhat.com>; Mon,  4 Apr 2022 17:05:38 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-j2dsWRhmOPaxJnFtK94rzQ-1; Mon, 04 Apr 2022 13:05:31 -0400
X-MC-Unique: j2dsWRhmOPaxJnFtK94rzQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id C3D9B1F38C;
 Mon,  4 Apr 2022 17:05:29 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 77CC112FC5;
 Mon,  4 Apr 2022 17:05:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id sM0qG1klS2LICAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 04 Apr 2022 17:05:29 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon,  4 Apr 2022 19:04:46 +0200
Message-Id: <20220404170457.16021-5-mwilck@suse.com>
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
Subject: [dm-devel] [PATCH v2 04/15] libmultipath: uevent_dispatch():
 process uevents one by one
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============6706857138309034621=="

--===============6706857138309034621==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

The main rationale for delaying uevents is that the
uevent dispatcher may have to wait for other threads to release the
vecs lock, may the vecs lock for an extended amount of time, and
even sleep occasionally. By delaying them, we have the chance
to accumulate events for the same path device ("filtering") or
WWID ("merging"), thus avoiding duplicate work if we merge these
into one.

A similar effect can be obtained in the uevent dispatcher itself
by looking for new uevents after each dispatched event, and trying
to merge the newly arrived events with those that remained
in the queue.

When uevq_work is non-empty and we append a list of new events,
we don't need to check the entire list for filterable and mergeable
uevents. uevq_work had been filtered and merged already. So we just
need to check the newly appended events. These must of course be
checked for merges with earlier events, too.

We must deal with some special cases here, like previously merged
uevents being filtered later.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/list.h   |  53 ++++++++++++++++++
 libmultipath/uevent.c | 127 +++++++++++++++++++++++++++++++-----------
 2 files changed, 146 insertions(+), 34 deletions(-)

diff --git a/libmultipath/list.h b/libmultipath/list.h
index ced021f..248f72b 100644
--- a/libmultipath/list.h
+++ b/libmultipath/list.h
@@ -246,6 +246,35 @@ static inline void list_splice_tail_init(struct list_h=
ead *list,
 #define list_entry(ptr, type, member) \
 =09container_of(ptr, type, member)
=20
+
+/**
+ * list_pop - unlink and return the first list element
+ * @head:=09the &struct list_head pointer.
+ */
+static inline struct list_head *list_pop(struct list_head *head)
+{
+=09struct list_head *tmp;
+
+=09if (list_empty(head))
+=09=09return NULL;
+=09tmp =3D head->next;
+=09list_del_init(tmp);
+=09return tmp;
+}
+
+/**
+ * list_pop_entry - unlink and return the entry of the first list element
+ * @head:=09the &struct list_head pointer.
+ * @type:=09the type of the struct this is embedded in.
+ * @member:=09the name of the list_struct within the struct.
+ */
+#define list_pop_entry(head, type, member)=09=09\
+({=09=09=09=09=09=09=09\
+=09struct list_head *__h =3D list_pop(head);=09=09\
+=09=09=09=09=09=09=09\
+=09(__h ? container_of(__h, type, member) : NULL);=09\
+})
+
 /**
  * list_for_each=09-=09iterate over a list
  * @pos:=09the &struct list_head to use as a loop counter.
@@ -334,6 +363,30 @@ static inline void list_splice_tail_init(struct list_h=
ead *list,
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
index fe60ae3..66acd6c 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -306,17 +306,64 @@ uevent_can_merge(struct uevent *earlier, struct ueven=
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
+/*
+ * Use this function to delete events that are known not to
+ * be equal to old_tail, and have an empty merge_node list.
+ * For others, use uevent_delete_from_list().
+ */
+static void uevent_delete_simple(struct uevent *to_delete)
+{
+=09list_del_init(&to_delete->node);
+
+=09if (to_delete->udev)
+=09=09udev_device_unref(to_delete->udev);
+
+=09free(to_delete);
+}
+
 static void
-uevent_prepare(struct list_head *tmpq)
+uevent_prepare(struct list_head *tmpq, const struct list_head *stop)
 {
 =09struct uevent *uev, *tmp;
=20
-=09list_for_each_entry_reverse_safe(uev, tmp, tmpq, node) {
+=09list_for_some_entry_reverse_safe(uev, tmp, tmpq, stop, node) {
 =09=09if (uevent_can_discard(uev)) {
-=09=09=09list_del_init(&uev->node);
-=09=09=09if (uev->udev)
-=09=09=09=09udev_device_unref(uev->udev);
-=09=09=09free(uev);
+=09=09=09uevent_delete_simple(uev);
 =09=09=09continue;
 =09=09}
=20
@@ -327,7 +374,7 @@ uevent_prepare(struct list_head *tmpq)
 }
=20
 static void
-uevent_filter(struct uevent *later, struct list_head *tmpq)
+uevent_filter(struct uevent *later, struct list_head *tmpq, struct list_he=
ad **stop)
 {
 =09struct uevent *earlier, *tmp;
=20
@@ -341,16 +388,13 @@ uevent_filter(struct uevent *later, struct list_head =
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
@@ -365,37 +409,42 @@ uevent_merge(struct uevent *later, struct list_head *=
tmpq)
 =09=09=09=09earlier->action, earlier->kernel, earlier->wwid,
 =09=09=09=09later->action, later->kernel, later->wwid);
=20
+=09=09=09/* See comment in uevent_delete_from_list() */
+=09=09=09if (&earlier->node =3D=3D *stop)
+=09=09=09=09*stop =3D earlier->node.prev;
+
 =09=09=09list_move(&earlier->node, &later->merge_node);
+=09=09=09list_splice_init(&earlier->merge_node,
+=09=09=09=09=09 &later->merge_node);
 =09=09}
 =09}
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
+=09uevent_prepare(tmpq, stop);
+=09list_for_some_entry_reverse(later, tmpq, stop, node) {
+=09=09uevent_filter(later, tmpq, &stop);
 =09=09if(uevent_need_merge())
-=09=09=09uevent_merge(later, tmpq);
+=09=09=09uevent_merge(later, tmpq, &stop);
 =09}
 }
=20
 static void
 service_uevq(struct list_head *tmpq)
 {
-=09struct uevent *uev, *tmp;
+=09struct uevent *uev =3D list_pop_entry(tmpq, typeof(*uev), node);
=20
-=09list_for_each_entry_safe(uev, tmp, tmpq, node) {
-=09=09list_del_init(&uev->node);
-
-=09=09pthread_cleanup_push(cleanup_uev, uev);
-=09=09if (my_uev_trigger && my_uev_trigger(uev, my_trigger_data))
-=09=09=09condlog(0, "uevent trigger error");
-=09=09pthread_cleanup_pop(1);
-=09}
+=09if (uev =3D=3D NULL)
+=09=09return;
+=09condlog(4, "servicing uevent '%s %s'", uev->action, uev->kernel);
+=09pthread_cleanup_push(cleanup_uev, uev);
+=09if (my_uev_trigger && my_uev_trigger(uev, my_trigger_data))
+=09=09condlog(0, "uevent trigger error");
+=09pthread_cleanup_pop(1);
 }
=20
 static void uevent_cleanup(void *arg)
@@ -432,33 +481,43 @@ static void cleanup_global_uevq(void *arg __attribute=
__((unused)))
 int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_dat=
a),
 =09=09    void * trigger_data)
 {
+=09LIST_HEAD(uevq_work);
+
 =09my_uev_trigger =3D uev_trigger;
 =09my_trigger_data =3D trigger_data;
=20
 =09mlockall(MCL_CURRENT | MCL_FUTURE);
=20
+=09pthread_cleanup_push(cleanup_uevq, &uevq_work);
 =09while (1) {
-=09=09LIST_HEAD(uevq_tmp);
+=09=09struct list_head *stop;
=20
 =09=09pthread_cleanup_push(cleanup_mutex, uevq_lockp);
 =09=09pthread_mutex_lock(uevq_lockp);
-=09=09servicing_uev =3D 0;
=20
-=09=09while (list_empty(&uevq))
+=09=09servicing_uev =3D !list_empty(&uevq_work);
+
+=09=09while (list_empty(&uevq_work) && list_empty(&uevq))
 =09=09=09pthread_cond_wait(uev_condp, uevq_lockp);
=20
 =09=09servicing_uev =3D 1;
-=09=09list_splice_init(&uevq, &uevq_tmp);
+=09=09/*
+=09=09 * "stop" is the list element towards which merge_uevq()
+=09=09 * will iterate: the last element of uevq_work before
+=09=09 * appending new uevents. If uveq_is empty, uevq_work.prev
+=09=09 * equals &uevq_work, which is what we need.
+=09=09 */
+=09=09stop =3D uevq_work.prev;
+=09=09list_splice_tail_init(&uevq, &uevq_work);
 =09=09pthread_cleanup_pop(1);
=20
 =09=09if (!my_uev_trigger)
 =09=09=09break;
=20
-=09=09pthread_cleanup_push(cleanup_uevq, &uevq_tmp);
-=09=09merge_uevq(&uevq_tmp);
-=09=09service_uevq(&uevq_tmp);
-=09=09pthread_cleanup_pop(1);
+=09=09merge_uevq(&uevq_work, stop);
+=09=09service_uevq(&uevq_work);
 =09}
+=09pthread_cleanup_pop(1);
 =09condlog(3, "Terminating uev service queue");
 =09return 0;
 }
--=20
2.35.1


--===============6706857138309034621==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============6706857138309034621==--

