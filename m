Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0689EC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 22:15:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-299-6ZKZ7_x0Mxa_NC4MIRmRJw-1; Wed, 30 Mar 2022 18:15:36 -0400
X-MC-Unique: 6ZKZ7_x0Mxa_NC4MIRmRJw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 357731C07846;
	Wed, 30 Mar 2022 22:15:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 20AC72166B4D;
	Wed, 30 Mar 2022 22:15:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A15331947BBC;
	Wed, 30 Mar 2022 22:15:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0B18319466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 22:15:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E3BE62026D6A; Wed, 30 Mar 2022 22:15:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DF3252026D6B
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DFA038008AF
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:28 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-N_t8MkjXO8GP7qBPcbVvfw-1; Wed, 30 Mar 2022 18:15:26 -0400
X-MC-Unique: N_t8MkjXO8GP7qBPcbVvfw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 76D891F86E;
 Wed, 30 Mar 2022 22:15:25 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 372A213AF3;
 Wed, 30 Mar 2022 22:15:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 8BNGC33WRGL8JgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 30 Mar 2022 22:15:25 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 31 Mar 2022 00:15:02 +0200
Message-Id: <20220330221510.22578-7-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH 06/14] multipathd: reconfigure: disallow changing
 uid_attrs
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============4735785370397585856=="

--===============4735785370397585856==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

uevent merging by WWID relies on the uid_attrs config option. As we
drop struct config between calls to uevent_merge(), we must be sure
that the WWID is not changed in reconfigure().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/multipath.conf.5 |  2 ++
 multipathd/main.c          | 53 +++++++++++++++++++++++++++++++-------
 2 files changed, 46 insertions(+), 9 deletions(-)

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
index 13b1948..f514b32 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2835,11 +2835,52 @@ void rcu_free_config(struct rcu_head *head)
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
+=09=09struct _vector v =3D new->uid_attrs;
+
+=09=09condlog(1, "multipathd must be restarted to change uid_attrs, keepin=
g old values");
+=09=09new->uid_attrs =3D old->uid_attrs;
+=09=09vector_reset(&v);
+=09=09old->uid_attrs =3D v;
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
@@ -2870,14 +2911,8 @@ reconfigure (struct vectors *vecs, enum force_reload=
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


--===============4735785370397585856==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============4735785370397585856==--

