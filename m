Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF799C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 22:15:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-f9uAXQGnN2qIfHaIAxJ5Sg-1; Wed, 30 Mar 2022 18:15:40 -0400
X-MC-Unique: f9uAXQGnN2qIfHaIAxJ5Sg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C92E0833966;
	Wed, 30 Mar 2022 22:15:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ADEC340CF915;
	Wed, 30 Mar 2022 22:15:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 64B5D19451F3;
	Wed, 30 Mar 2022 22:15:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B358219466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 22:15:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A806CC08095; Wed, 30 Mar 2022 22:15:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A3954C08096
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DFD738008BD
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:32 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-WEyJGq_3MsKeydpWl85RZg-1; Wed, 30 Mar 2022 18:15:28 -0400
X-MC-Unique: WEyJGq_3MsKeydpWl85RZg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 79209218FE;
 Wed, 30 Mar 2022 22:15:26 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2FEF013AF3;
 Wed, 30 Mar 2022 22:15:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id ICahCX7WRGL8JgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 30 Mar 2022 22:15:26 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 31 Mar 2022 00:15:05 +0200
Message-Id: <20220330221510.22578-10-mwilck@suse.com>
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
Subject: [dm-devel] [PATCH 09/14] libmultipath: uevent: use struct to pass
 parameters around
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
Content-Type: multipart/mixed; boundary="===============4580294488850768609=="

--===============4580294488850768609==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

libmultipath: uevent_dispatch(): just grab config once

Introduce struct uevent_filter_state to pass parameters around.
This simplifies the function signatures and allows for easy extension
later.

Instead of grabbing multipath config repeatedly, do it just
once per dispatcher iteration, and pass the pointer around in
struct uevent_filter_state. We shouldn't use different configs
for different paths in a single iteration, anyway.

Also, properly constify get_uid_attribute_by_attrs() and
pp->uid_attribute.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c    |   6 +--
 libmultipath/config.h    |   4 +-
 libmultipath/discovery.c |   2 +-
 libmultipath/structs.h   |   2 +-
 libmultipath/uevent.c    | 112 +++++++++++++++++----------------------
 libmultipath/uevent.h    |   3 +-
 tests/uevent.c           |   2 +-
 7 files changed, 59 insertions(+), 72 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index c595e76..7346c37 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -1018,10 +1018,10 @@ out:
 =09return 1;
 }
=20
-char *get_uid_attribute_by_attrs(struct config *conf,
-=09=09=09=09 const char *path_dev)
+const char *get_uid_attribute_by_attrs(const struct config *conf,
+=09=09=09=09       const char *path_dev)
 {
-=09vector uid_attrs =3D &conf->uid_attrs;
+=09const struct _vector *uid_attrs =3D &conf->uid_attrs;
 =09int j;
 =09char *att, *col;
=20
diff --git a/libmultipath/config.h b/libmultipath/config.h
index c73389b..5351ecd 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -314,7 +314,7 @@ void libmp_put_multipath_config(void *);
 void put_multipath_config(void *);
=20
 int parse_uid_attrs(char *uid_attrs, struct config *conf);
-char *get_uid_attribute_by_attrs(struct config *conf,
-=09=09=09=09 const char *path_dev);
+const char *get_uid_attribute_by_attrs(const struct config *conf,
+=09=09=09=09       const char *path_dev);
=20
 #endif
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index b969fba..589eca1 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2044,7 +2044,7 @@ fix_broken_nvme_wwid(struct path *pp, const char *val=
ue, size_t size)
 }
=20
 static int
-get_udev_uid(struct path * pp, char *uid_attribute, struct udev_device *ud=
ev)
+get_udev_uid(struct path * pp, const char *uid_attribute, struct udev_devi=
ce *udev)
 {
 =09ssize_t len;
 =09const char *value;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index d94f93a..afd4674 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -327,7 +327,7 @@ struct path {
 =09int detect_prio;
 =09int detect_checker;
 =09int tpgs;
-=09char * uid_attribute;
+=09const char *uid_attribute;
 =09char * getuid;
 =09struct prio prio;
 =09struct checker checker;
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 51c912f..5f756ce 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -63,6 +63,12 @@ static uev_trigger *my_uev_trigger;
 static void *my_trigger_data;
 static int servicing_uev;
=20
+struct uevent_filter_state {
+=09struct list_head uevq;
+=09struct list_head *old_tail;
+=09struct config *conf;
+};
+
 int is_uevent_busy(void)
 {
 =09int empty;
@@ -158,40 +164,24 @@ int uevent_get_env_positive_int(const struct uevent *=
uev,
 }
=20
 void
-uevent_get_wwid(struct uevent *uev)
+uevent_get_wwid(struct uevent *uev, const struct config *conf)
 {
-=09char *uid_attribute;
+=09const char *uid_attribute;
 =09const char *val;
-=09struct config * conf;
=20
-=09conf =3D get_multipath_config();
-=09pthread_cleanup_push(put_multipath_config, conf);
 =09uid_attribute =3D get_uid_attribute_by_attrs(conf, uev->kernel);
-=09pthread_cleanup_pop(1);
-
 =09val =3D uevent_get_env_var(uev, uid_attribute);
 =09if (val)
 =09=09uev->wwid =3D val;
 }
=20
-static bool uevent_need_merge(void)
+static bool uevent_need_merge(const struct config *conf)
 {
-=09struct config * conf;
-=09bool need_merge =3D false;
-
-=09conf =3D get_multipath_config();
-=09if (VECTOR_SIZE(&conf->uid_attrs) > 0)
-=09=09need_merge =3D true;
-=09put_multipath_config(conf);
-
-=09return need_merge;
+=09return VECTOR_SIZE(&conf->uid_attrs) > 0;
 }
=20
-static bool uevent_can_discard(struct uevent *uev)
+static bool uevent_can_discard(struct uevent *uev, const struct config *co=
nf)
 {
-=09int invalid =3D 0;
-=09struct config * conf;
-
 =09/*
 =09 * do not filter dm devices by devnode
 =09 */
@@ -200,15 +190,10 @@ static bool uevent_can_discard(struct uevent *uev)
 =09/*
 =09 * filter paths devices by devnode
 =09 */
-=09conf =3D get_multipath_config();
-=09pthread_cleanup_push(put_multipath_config, conf);
 =09if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
 =09=09=09   uev->kernel) > 0)
-=09=09invalid =3D 1;
-=09pthread_cleanup_pop(1);
-
-=09if (invalid)
 =09=09return true;
+
 =09return false;
 }
=20
@@ -335,29 +320,28 @@ static void uevent_delete_from_list(struct uevent *to=
_delete,
 =09free(to_delete);
 }
=20
-static void
-uevent_prepare(struct list_head *tmpq, struct list_head **stop)
+static void uevent_prepare(struct uevent_filter_state *st)
 {
 =09struct uevent *uev, *tmp;
=20
-=09list_for_some_entry_reverse_safe(uev, tmp, tmpq, *stop, node) {
-=09=09if (uevent_can_discard(uev)) {
-=09=09=09uevent_delete_from_list(uev, &tmp, stop);
+=09list_for_some_entry_reverse_safe(uev, tmp, &st->uevq, st->old_tail, nod=
e) {
+=09=09if (uevent_can_discard(uev, st->conf)) {
+=09=09=09uevent_delete_from_list(uev, &tmp, &st->old_tail);
 =09=09=09continue;
 =09=09}
=20
 =09=09if (strncmp(uev->kernel, "dm-", 3) &&
-=09=09    uevent_need_merge())
-=09=09=09uevent_get_wwid(uev);
+=09=09    uevent_need_merge(st->conf))
+=09=09=09uevent_get_wwid(uev, st->conf);
 =09}
 }
=20
 static void
-uevent_filter(struct uevent *later, struct list_head *tmpq, struct list_he=
ad **stop)
+uevent_filter(struct uevent *later, struct uevent_filter_state *st)
 {
 =09struct uevent *earlier, *tmp;
=20
-=09list_for_some_entry_reverse_safe(earlier, tmp, &later->node, tmpq, node=
) {
+=09list_for_some_entry_reverse_safe(earlier, tmp, &later->node, &st->uevq,=
 node) {
 =09=09/*
 =09=09 * filter unnessary earlier uevents
 =09=09 * by the later uevent
@@ -367,17 +351,16 @@ uevent_filter(struct uevent *later, struct list_head =
*tmpq, struct list_head **s
 =09=09=09=09earlier->kernel, earlier->action,
 =09=09=09=09later->kernel, later->action);
=20
-=09=09=09uevent_delete_from_list(earlier, &tmp, stop);
+=09=09=09uevent_delete_from_list(earlier, &tmp, &st->old_tail);
 =09=09}
 =09}
 }
=20
-static void
-uevent_merge(struct uevent *later, struct list_head *tmpq, struct list_hea=
d **stop)
+static void uevent_merge(struct uevent *later, struct uevent_filter_state =
*st)
 {
 =09struct uevent *earlier, *tmp;
=20
-=09list_for_some_entry_reverse_safe(earlier, tmp, &later->node, tmpq, node=
) {
+=09list_for_some_entry_reverse_safe(earlier, tmp, &later->node, &st->uevq,=
 node) {
 =09=09if (merge_need_stop(earlier, later))
 =09=09=09break;
 =09=09/*
@@ -389,8 +372,8 @@ uevent_merge(struct uevent *later, struct list_head *tm=
pq, struct list_head **st
 =09=09=09=09later->action, later->kernel, later->wwid);
=20
 =09=09=09/* See comment in uevent_delete_from_list() */
-=09=09=09if (&earlier->node =3D=3D *stop)
-=09=09=09=09*stop =3D earlier->node.prev;
+=09=09=09if (&earlier->node =3D=3D st->old_tail)
+=09=09=09=09st->old_tail =3D earlier->node.prev;
=20
 =09=09=09list_move(&earlier->node, &later->merge_node);
 =09=09=09list_splice_init(&earlier->merge_node,
@@ -399,16 +382,15 @@ uevent_merge(struct uevent *later, struct list_head *=
tmpq, struct list_head **st
 =09}
 }
=20
-static void
-merge_uevq(struct list_head *tmpq, struct list_head *stop)
+static void merge_uevq(struct uevent_filter_state *st)
 {
 =09struct uevent *later;
=20
-=09uevent_prepare(tmpq, &stop);
-=09list_for_some_entry_reverse(later, tmpq, stop, node) {
-=09=09uevent_filter(later, tmpq, &stop);
-=09=09if(uevent_need_merge())
-=09=09=09uevent_merge(later, tmpq, &stop);
+=09uevent_prepare(st);
+=09list_for_some_entry_reverse(later, &st->uevq, st->old_tail, node) {
+=09=09uevent_filter(later, st);
+=09=09if(uevent_need_merge(st->conf))
+=09=09=09uevent_merge(later, st);
 =09}
 }
=20
@@ -460,41 +442,45 @@ static void cleanup_global_uevq(void *arg __attribute=
__((unused)))
 int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_dat=
a),
 =09=09    void * trigger_data)
 {
-=09LIST_HEAD(uevq_work);
+=09struct uevent_filter_state filter_state;
=20
+=09INIT_LIST_HEAD(&filter_state.uevq);
 =09my_uev_trigger =3D uev_trigger;
 =09my_trigger_data =3D trigger_data;
=20
 =09mlockall(MCL_CURRENT | MCL_FUTURE);
=20
-=09pthread_cleanup_push(cleanup_uevq, &uevq_work);
+=09pthread_cleanup_push(cleanup_uevq, &filter_state.uevq);
 =09while (1) {
-=09=09struct list_head *stop;
-
 =09=09pthread_cleanup_push(cleanup_mutex, uevq_lockp);
 =09=09pthread_mutex_lock(uevq_lockp);
=20
-=09=09servicing_uev =3D !list_empty(&uevq_work);
+=09=09servicing_uev =3D !list_empty(&filter_state.uevq);
=20
-=09=09while (list_empty(&uevq_work) && list_empty(&uevq))
+=09=09while (list_empty(&filter_state.uevq) && list_empty(&uevq))
 =09=09=09pthread_cond_wait(uev_condp, uevq_lockp);
=20
 =09=09servicing_uev =3D 1;
 =09=09/*
-=09=09 * "stop" is the list element towards which merge_uevq()
-=09=09 * will iterate: the last element of uevq_work before
-=09=09 * appending new uevents. If uveq_is empty, uevq_work.prev
-=09=09 * equals &uevq_work, which is what we need.
+=09=09 * "old_tail" is the list element towards which merge_uevq()
+=09=09 * will iterate: the last element of uevq before
+=09=09 * appending new uevents. If uveq  empty, uevq.prev
+=09=09 * equals &uevq, which is what we need.
 =09=09 */
-=09=09stop =3D uevq_work.prev;
-=09=09list_splice_tail_init(&uevq, &uevq_work);
+=09=09filter_state.old_tail =3D filter_state.uevq.prev;
+=09=09list_splice_tail_init(&uevq, &filter_state.uevq);
 =09=09pthread_cleanup_pop(1);
=20
 =09=09if (!my_uev_trigger)
 =09=09=09break;
=20
-=09=09merge_uevq(&uevq_work, stop);
-=09=09service_uevq(&uevq_work);
+
+=09=09pthread_cleanup_push(put_multipath_config, filter_state.conf);
+=09=09filter_state.conf =3D get_multipath_config();
+=09=09merge_uevq(&filter_state);
+=09=09pthread_cleanup_pop(1);
+
+=09=09service_uevq(&filter_state.uevq);
 =09}
 =09pthread_cleanup_pop(1);
 =09condlog(3, "Terminating uev service queue");
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index 61ca1b5..53a7ca2 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -10,6 +10,7 @@
 #define OBJECT_SIZE=09=09=09512
=20
 struct udev;
+struct config;
=20
 struct uevent {
 =09struct list_head node;
@@ -31,7 +32,7 @@ int uevent_listen(struct udev *udev);
 int uevent_dispatch(int (*store_uev)(struct uevent *, void * trigger_data)=
,
 =09=09    void * trigger_data);
 bool uevent_is_mpath(const struct uevent *uev);
-void uevent_get_wwid(struct uevent *uev);
+void uevent_get_wwid(struct uevent *uev, const struct config *conf);
=20
 int uevent_get_env_positive_int(const struct uevent *uev,
 =09=09=09=09const char *attr);
diff --git a/tests/uevent.c b/tests/uevent.c
index 7523fec..6a010ab 100644
--- a/tests/uevent.c
+++ b/tests/uevent.c
@@ -111,7 +111,7 @@ static void test_uid_attrs(void **state)
 static void test_wwid(void **state)
 {
 =09struct uevent *uev =3D *state;
-=09uevent_get_wwid(uev);
+=09uevent_get_wwid(uev, &conf);
=20
 =09assert_string_equal(uev->wwid, WWID);
 }
--=20
2.35.1


--===============4580294488850768609==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============4580294488850768609==--

