Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43B6CC7EE2D
	for <dm-devel@archiver.kernel.org>; Fri, 19 May 2023 23:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684537345;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=U8+5dgRAXlnfFn4s2XJyhTH7yCMLCHMJFNIAGMiLs3A=;
	b=atmVfDCe8XcCNAZcLyPwha8B+46hgXFjTfeIjRAcIx+U/JfTY59kofeXSLEJkvZs7qwj1o
	GCttlPf3d9vJQDl/1q7CsDeTwH1bdkTUgAE+BnmxVp6tAGQmNoc26wKteDEDiPcPiwOmaq
	2h/Wo8kyLrB7Px/zb947xpka1omAEnA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-zeF4KjSCMB-DLf26Li2CIg-1; Fri, 19 May 2023 19:02:22 -0400
X-MC-Unique: zeF4KjSCMB-DLf26Li2CIg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8344B1C041B7;
	Fri, 19 May 2023 23:02:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A244140D1B60;
	Fri, 19 May 2023 23:02:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6A3D119465B2;
	Fri, 19 May 2023 23:02:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0B07719465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 19 May 2023 23:02:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E35DD492B0B; Fri, 19 May 2023 23:02:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BAAF5492B0A;
 Fri, 19 May 2023 23:02:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 34JN2ELV023077;
 Fri, 19 May 2023 18:02:14 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 34JN2D0U023076;
 Fri, 19 May 2023 18:02:13 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri, 19 May 2023 18:02:08 -0500
Message-Id: <1684537332-23033-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684537332-23033-1-git-send-email-bmarzins@redhat.com>
References: <1684537332-23033-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH 1/5] libmultipath: add group_by_tpg
 path_grouping_policy
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When we group paths by prio and the priority changes, paths can end up
temporarily in the wrong path groups.  This usually happens when some
paths are down, so their priority can't be updated. To avoid this for
ALUA paths, group them by their target port group instead. The path
groups chosen by this policy won't always match with those chosen by
group_by_prio, since it is possible for multiple ALUA target port
groups to have the same priority.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c         |  1 +
 libmultipath/pgpolicies.c        | 19 +++++++++++++++++++
 libmultipath/pgpolicies.h        |  4 +++-
 libmultipath/prioritizers/alua.c |  1 +
 libmultipath/propsel.c           | 27 +++++++++++++++++++++++++--
 libmultipath/structs.c           |  1 +
 libmultipath/structs.h           |  3 +++
 multipath/main.c                 |  1 +
 multipath/multipath.conf.5       |  4 ++++
 9 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 6865cd92..2dcafe5d 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1051,6 +1051,7 @@ detect_alua(struct path * pp)
 		return;
 	}
 	pp->tpgs = tpgs;
+	pp->tpg_id = ret;
 }
 
 int path_get_tpgs(struct path *pp)
diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index 10b44d37..e14da8cc 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -25,6 +25,8 @@ int get_pgpolicy_id(char * str)
 		return GROUP_BY_PRIO;
 	if (0 == strncmp(str, "group_by_node_name", 18))
 		return GROUP_BY_NODE_NAME;
+	if (0 == strncmp(str, "group_by_tpg", 12))
+		return GROUP_BY_TPG;
 
 	return IOPOLICY_UNDEF;
 }
@@ -49,6 +51,9 @@ int get_pgpolicy_name(char * buff, int len, int id)
 	case GROUP_BY_NODE_NAME:
 		s = "group_by_node_name";
 		break;
+	case GROUP_BY_TPG:
+		s = "group_by_tpg";
+		break;
 	default:
 		s = "undefined";
 		break;
@@ -191,6 +196,12 @@ prios_match(struct path *pp1, struct path *pp2)
 	return (pp1->priority == pp2->priority);
 }
 
+bool
+tpg_match(struct path *pp1, struct path *pp2)
+{
+	return (pp1->tpg_id == pp2->tpg_id);
+}
+
 int group_by_match(struct multipath * mp, vector paths,
 		   bool (*path_match_fn)(struct path *, struct path *))
 {
@@ -279,6 +290,14 @@ int group_by_prio(struct multipath *mp, vector paths)
 	return group_by_match(mp, paths, prios_match);
 }
 
+/*
+ * One path group per alua target port group present in the path vector
+ */
+int group_by_tpg(struct multipath *mp, vector paths)
+{
+	return group_by_match(mp, paths, tpg_match);
+}
+
 int one_path_per_group(struct multipath *mp, vector paths)
 {
 	int i;
diff --git a/libmultipath/pgpolicies.h b/libmultipath/pgpolicies.h
index 15927610..d3ab2f35 100644
--- a/libmultipath/pgpolicies.h
+++ b/libmultipath/pgpolicies.h
@@ -16,7 +16,8 @@ enum iopolicies {
 	MULTIBUS,
 	GROUP_BY_SERIAL,
 	GROUP_BY_PRIO,
-	GROUP_BY_NODE_NAME
+	GROUP_BY_NODE_NAME,
+	GROUP_BY_TPG,
 };
 
 int get_pgpolicy_id(char *);
@@ -30,5 +31,6 @@ int one_group(struct multipath *, vector);
 int group_by_serial(struct multipath *, vector);
 int group_by_prio(struct multipath *, vector);
 int group_by_node_name(struct multipath *, vector);
+int group_by_tpg(struct multipath *, vector);
 
 #endif
diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index 0ab06e2b..4888a974 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -65,6 +65,7 @@ get_alua_info(struct path * pp, unsigned int timeout)
 			return -ALUA_PRIO_NOT_SUPPORTED;
 		return -ALUA_PRIO_RTPG_FAILED;
 	}
+	pp->tpg_id = tpg;
 	condlog(3, "%s: reported target port group is %i", pp->dev, tpg);
 	rc = get_asymmetric_access_state(pp, tpg, timeout);
 	if (rc < 0) {
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index a25cc921..841fa247 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -35,7 +35,8 @@ pgpolicyfn *pgpolicies[] = {
 	one_group,
 	group_by_serial,
 	group_by_prio,
-	group_by_node_name
+	group_by_node_name,
+	group_by_tpg,
 };
 
 #define do_set(var, src, dest, msg)					\
@@ -249,10 +250,26 @@ out:
 	return 0;
 }
 
+static bool
+verify_alua_prio(struct multipath *mp)
+{
+	int i;
+	struct path *pp;
+
+	vector_foreach_slot(mp->paths, pp, i) {
+		const char *name = prio_name(&pp->prio);
+		if (strncmp(name, PRIO_ALUA, PRIO_NAME_LEN) &&
+		    strncmp(name, PRIO_SYSFS, PRIO_NAME_LEN))
+			 return false;
+	}
+	return true;
+}
+
 int select_pgpolicy(struct config *conf, struct multipath * mp)
 {
 	const char *origin;
 	char buff[POLICY_NAME_SIZE];
+	int log_prio = 3;
 
 	if (conf->pgpolicy_flag > 0) {
 		mp->pgpolicy = conf->pgpolicy_flag;
@@ -265,9 +282,15 @@ int select_pgpolicy(struct config *conf, struct multipath * mp)
 	mp_set_conf(pgpolicy);
 	mp_set_default(pgpolicy, DEFAULT_PGPOLICY);
 out:
+	if (mp->pgpolicy == GROUP_BY_TPG && !verify_alua_prio(mp)) {
+		mp->pgpolicy = DEFAULT_PGPOLICY;
+		origin = "(setting: emergency fallback - not all paths use alua prio)";
+		log_prio = 1;
+	}
 	mp->pgpolicyfn = pgpolicies[mp->pgpolicy];
 	get_pgpolicy_name(buff, POLICY_NAME_SIZE, mp->pgpolicy);
-	condlog(3, "%s: path_grouping_policy = %s %s", mp->alias, buff, origin);
+	condlog(log_prio, "%s: path_grouping_policy = %s %s", mp->alias, buff,
+		origin);
 	return 0;
 }
 
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 87e84d5d..39504dca 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -125,6 +125,7 @@ alloc_path (void)
 		pp->sg_id.proto_id = PROTOCOL_UNSET;
 		pp->fd = -1;
 		pp->tpgs = TPGS_UNDEF;
+		pp->tpg_id = GROUP_ID_UNDEF;
 		pp->priority = PRIO_UNDEF;
 		pp->checkint = CHECKINT_UNDEF;
 		checker_clear(&pp->checker);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index a1208751..0eea19b4 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -317,6 +317,8 @@ struct hd_geometry {
 };
 #endif
 
+#define GROUP_ID_UNDEF -1
+
 struct path {
 	char dev[FILE_NAME_SIZE];
 	char dev_t[BLK_DEV_SIZE];
@@ -372,6 +374,7 @@ struct path {
 	/* configlet pointers */
 	vector hwe;
 	struct gen_path generic_path;
+	int tpg_id;
 };
 
 typedef int (pgpolicyfn) (struct multipath *, vector);
diff --git a/multipath/main.c b/multipath/main.c
index 90f940f1..b78f3162 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -157,6 +157,7 @@ usage (char * progname)
 		"          . group_by_serial     one priority group per serial\n"
 		"          . group_by_prio       one priority group per priority lvl\n"
 		"          . group_by_node_name  one priority group per target node\n"
+		"          . group_by_tpg        one priority group per ALUA target port group\n"
 		"  -v lvl  verbosity level:\n"
 		"          . 0 no output\n"
 		"          . 1 print created devmap names only\n"
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index b4dccd1b..b65a543d 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -233,6 +233,10 @@ per-multipath option in the configuration file.
 One priority group per target node name. Target node names are fetched
 in \fI/sys/class/fc_transport/target*/node_name\fR.
 .TP
+.I group_by_tpg
+One priority group per ALUA target port group. In order to use this policy,
+all paths in the multipath device must have \fIprio\fR set to \fBalua\fR.
+.TP
 The default is: \fBfailover\fR
 .RE
 .
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

