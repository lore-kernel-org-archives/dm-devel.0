Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 227E9C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  4 Apr 2022 17:05:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-7gQ5aM-bMi2wNdQFazdNtg-1; Mon, 04 Apr 2022 13:05:49 -0400
X-MC-Unique: 7gQ5aM-bMi2wNdQFazdNtg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E97FD100BAB9;
	Mon,  4 Apr 2022 17:05:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D5AA0C27E85;
	Mon,  4 Apr 2022 17:05:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A77031940366;
	Mon,  4 Apr 2022 17:05:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E9D8A194037C
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Apr 2022 17:05:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CA509140262B; Mon,  4 Apr 2022 17:05:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C6811140241F
 for <dm-devel@redhat.com>; Mon,  4 Apr 2022 17:05:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD5F63800A04
 for <dm-devel@redhat.com>; Mon,  4 Apr 2022 17:05:39 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-213-fa5Jl_GVOXeemZhYP2KtHw-1; Mon, 04 Apr 2022 13:05:31 -0400
X-MC-Unique: fa5Jl_GVOXeemZhYP2KtHw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 1770D210F4;
 Mon,  4 Apr 2022 17:05:30 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D190012FC5;
 Mon,  4 Apr 2022 17:05:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id ME8EMVklS2LICAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 04 Apr 2022 17:05:29 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon,  4 Apr 2022 19:04:47 +0200
Message-Id: <20220404170457.16021-6-mwilck@suse.com>
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
Subject: [dm-devel] [PATCH v2 05/15] multipathd: reconfigure: disallow
 changing uid_attrs
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
Content-Type: multipart/mixed; boundary="===============2556705616257491679=="

--===============2556705616257491679==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

uevent merging by WWID relies on the uid_attrs config option. As we
drop struct config between calls to uevent_merge(), we must be sure
that the WWID is not changed in reconfigure().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/multipath.conf.5 |  2 ++
 multipathd/main.c          | 59 ++++++++++++++++++++++++++++++++------
 2 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 605b46e..a9cd776 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -264,6 +264,8 @@ If this option is configured and matches the device
 node name of a device, it overrides any other configured  methods for
 determining the WWID for this device.
 .PP
+This option cannot be changed during runtime with the multipathd \fBreconf=
igure\fR command.
+.PP
 The default is: \fB<unset>\fR. To enable uevent merging, set it e.g. to
 \(dqsd:ID_SERIAL dasd:ID_UID nvme:ID_WWN\(dq.
 .RE
diff --git a/multipathd/main.c b/multipathd/main.c
index 13b1948..6808ad1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2835,11 +2835,58 @@ void rcu_free_config(struct rcu_head *head)
 =09free_config(conf);
 }
=20
+static bool reconfigure_check_uid_attrs(const struct _vector *old_attrs,
+=09=09=09=09=09const struct _vector *new_attrs)
+{
+=09int i;
+=09char *old;
+
+=09if (VECTOR_SIZE(old_attrs) !=3D VECTOR_SIZE(new_attrs))
+=09=09return true;
+
+=09vector_foreach_slot(old_attrs, old, i) {
+=09=09char *new =3D VECTOR_SLOT(new_attrs, i);
+
+=09=09if (strcmp(old, new))
+=09=09=09return true;
+=09}
+
+=09return false;
+}
+
+static void reconfigure_check(struct config *old, struct config *new)
+{
+=09int old_marginal_pathgroups;
+
+=09old_marginal_pathgroups =3D old->marginal_pathgroups;
+=09if ((old_marginal_pathgroups =3D=3D MARGINAL_PATHGROUP_FPIN) !=3D
+=09    (new->marginal_pathgroups =3D=3D MARGINAL_PATHGROUP_FPIN)) {
+=09=09condlog(1, "multipathd must be restarted to turn %s fpin marginal pa=
ths",
+=09=09=09(old_marginal_pathgroups =3D=3D MARGINAL_PATHGROUP_FPIN)?
+=09=09=09"off" : "on");
+=09=09new->marginal_pathgroups =3D old_marginal_pathgroups;
+=09}
+
+=09if (reconfigure_check_uid_attrs(&old->uid_attrs, &new->uid_attrs)) {
+=09=09int i;
+=09=09void *ptr;
+
+=09=09condlog(1, "multipathd must be restarted to change uid_attrs, keepin=
g old values");
+=09=09vector_foreach_slot(&new->uid_attrs, ptr, i)
+=09=09=09free(ptr);
+=09=09vector_reset(&new->uid_attrs);
+=09=09new->uid_attrs =3D old->uid_attrs;
+
+=09=09/* avoid uid_attrs being freed in rcu_free_config() */
+=09=09old->uid_attrs.allocated =3D 0;
+=09=09old->uid_attrs.slot =3D NULL;
+=09}
+}
+
 static int
 reconfigure (struct vectors *vecs, enum force_reload_types reload_type)
 {
 =09struct config * old, *conf;
-=09int old_marginal_pathgroups;
=20
 =09conf =3D load_config(DEFAULT_CONFIGFILE);
 =09if (!conf)
@@ -2870,14 +2917,8 @@ reconfigure (struct vectors *vecs, enum force_reload=
_types reload_type)
 =09uxsock_timeout =3D conf->uxsock_timeout;
=20
 =09old =3D rcu_dereference(multipath_conf);
-=09old_marginal_pathgroups =3D old->marginal_pathgroups;
-=09if ((old_marginal_pathgroups =3D=3D MARGINAL_PATHGROUP_FPIN) !=3D
-=09    (conf->marginal_pathgroups =3D=3D MARGINAL_PATHGROUP_FPIN)) {
-=09=09condlog(1, "multipathd must be restarted to turn %s fpin marginal pa=
ths",
-=09=09=09(old_marginal_pathgroups =3D=3D MARGINAL_PATHGROUP_FPIN)?
-=09=09=09"off" : "on");
-=09=09conf->marginal_pathgroups =3D old_marginal_pathgroups;
-=09}
+=09reconfigure_check(old, conf);
+
 =09conf->sequence_nr =3D old->sequence_nr + 1;
 =09rcu_assign_pointer(multipath_conf, conf);
 =09call_rcu(&old->rcu, rcu_free_config);
--=20
2.35.1


--===============2556705616257491679==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============2556705616257491679==--

