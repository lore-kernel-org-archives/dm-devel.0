Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 961F4C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 22:15:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-1UM0hRh2O-qBojwTYnh5mw-1; Wed, 30 Mar 2022 18:15:34 -0400
X-MC-Unique: 1UM0hRh2O-qBojwTYnh5mw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FD08803FF2;
	Wed, 30 Mar 2022 22:15:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D8A791400C30;
	Wed, 30 Mar 2022 22:15:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6C92A1940347;
	Wed, 30 Mar 2022 22:15:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D16EE1947BBC
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 22:15:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BA3B9C08095; Wed, 30 Mar 2022 22:15:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B5DD6C08F11
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E5B93C01D99
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:29 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-ctYQZGgSNI2OyPXXLV4dfg-1; Wed, 30 Mar 2022 18:15:26 -0400
X-MC-Unique: ctYQZGgSNI2OyPXXLV4dfg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id D00E41F86D;
 Wed, 30 Mar 2022 22:15:24 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8F9F013AF3;
 Wed, 30 Mar 2022 22:15:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id gMkIIXzWRGL8JgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 30 Mar 2022 22:15:24 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 31 Mar 2022 00:15:00 +0200
Message-Id: <20220330221510.22578-5-mwilck@suse.com>
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
Subject: [dm-devel] [PATCH 04/14] libmultipath: uevent_dispatch(): process
 uevents one by one
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============3393282688034027966=="

--===============3393282688034027966==
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/list.h   | 29 +++++++++++++++++++++++++++++
 libmultipath/uevent.c | 37 ++++++++++++++++++++-----------------
 2 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/libmultipath/list.h b/libmultipath/list.h
index ced021f..ddea99f 100644
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
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index fe60ae3..602eccb 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -366,6 +366,8 @@ uevent_merge(struct uevent *later, struct list_head *tm=
pq)
 =09=09=09=09later->action, later->kernel, later->wwid);
=20
 =09=09=09list_move(&earlier->node, &later->merge_node);
+=09=09=09list_splice_init(&earlier->merge_node,
+=09=09=09=09=09 &later->merge_node);
 =09=09}
 =09}
 }
@@ -386,16 +388,15 @@ merge_uevq(struct list_head *tmpq)
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
@@ -432,33 +433,35 @@ static void cleanup_global_uevq(void *arg __attribute=
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
+=09=09merge_uevq(&uevq_work);
+=09=09service_uevq(&uevq_work);
 =09}
+=09pthread_cleanup_pop(1);
 =09condlog(3, "Terminating uev service queue");
 =09return 0;
 }
--=20
2.35.1


--===============3393282688034027966==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============3393282688034027966==--

