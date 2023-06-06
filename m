Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC9D3C77B7A
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 20:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686082410;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Q4DZOR46g8wL+A8Y4EYISL3B2VYQTprcQftcKC3lxoM=;
	b=Za3seucFTO7uZax1XGJM3ljp9tzeNyVX5Kbh0Gp5757dj0td6wOZHZKVlTqYqRYRvL39qV
	7+Vf8owhibVkNrGG6t+oVD9dDW2tc2UjtRJ3xeuboKA+9+ufX7IivKJJFJfvsxc8AFfptC
	eEfpEQ+z24EIc/2oFVR6gcZWIceujRo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-Je8DPx9vO7mAWB3MZuVJgA-1; Tue, 06 Jun 2023 16:13:28 -0400
X-MC-Unique: Je8DPx9vO7mAWB3MZuVJgA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E180F85A5BE;
	Tue,  6 Jun 2023 20:13:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D0FEA140E954;
	Tue,  6 Jun 2023 20:13:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BF0C319465BD;
	Tue,  6 Jun 2023 20:13:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6D86319465BD
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 20:13:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5DA5440CFD48; Tue,  6 Jun 2023 20:13:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FF4940CFD46;
 Tue,  6 Jun 2023 20:13:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 356KDFrB029256;
 Tue, 6 Jun 2023 15:13:15 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 356KDFJL029255;
 Tue, 6 Jun 2023 15:13:15 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue,  6 Jun 2023 15:13:02 -0500
Message-Id: <1686082391-29210-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1686082391-29210-1-git-send-email-bmarzins@redhat.com>
References: <1686082391-29210-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH V2 02/11] libmultipath: don't copy pgpolicy
 string in get_pgpolicy_name
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

copying the value into a passed in buffer doesn't help any of the
callers of this function. It's just wasted work.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c       |  6 +-----
 libmultipath/pgpolicies.c | 27 ++++++++-------------------
 libmultipath/pgpolicies.h |  2 +-
 libmultipath/propsel.c    |  6 ++----
 4 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 2e9b45f9..dddd3cd6 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1209,14 +1209,10 @@ set_pgpolicy(vector strvec, void *ptr, const char *file, int line_nr)
 int
 print_pgpolicy(struct strbuf *buff, long pgpolicy)
 {
-	char str[POLICY_NAME_SIZE];
-
 	if (!pgpolicy)
 		return 0;
 
-	get_pgpolicy_name(str, POLICY_NAME_SIZE, pgpolicy);
-
-	return append_strbuf_quoted(buff, str);
+	return append_strbuf_quoted(buff, get_pgpolicy_name(pgpolicy));
 }
 
 declare_def_handler(pgpolicy, set_pgpolicy)
diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index e14da8cc..edc3c611 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -31,34 +31,23 @@ int get_pgpolicy_id(char * str)
 	return IOPOLICY_UNDEF;
 }
 
-int get_pgpolicy_name(char * buff, int len, int id)
+const char *get_pgpolicy_name(int id)
 {
-	char * s;
-
 	switch (id) {
 	case FAILOVER:
-		s = "failover";
-		break;
+		return "failover";
 	case MULTIBUS:
-		s = "multibus";
-		break;
+		return "multibus";
 	case GROUP_BY_SERIAL:
-		s = "group_by_serial";
-		break;
+		return "group_by_serial";
 	case GROUP_BY_PRIO:
-		s = "group_by_prio";
-		break;
+		return "group_by_prio";
 	case GROUP_BY_NODE_NAME:
-		s = "group_by_node_name";
-		break;
+		return "group_by_node_name";
 	case GROUP_BY_TPG:
-		s = "group_by_tpg";
-		break;
-	default:
-		s = "undefined";
-		break;
+		return "group_by_tpg";
 	}
-	return snprintf(buff, len, "%s", s);
+	return "undefined"; /* IOPOLICY_UNDEF */
 }
 
 
diff --git a/libmultipath/pgpolicies.h b/libmultipath/pgpolicies.h
index d3ab2f35..9e4ddda2 100644
--- a/libmultipath/pgpolicies.h
+++ b/libmultipath/pgpolicies.h
@@ -21,7 +21,7 @@ enum iopolicies {
 };
 
 int get_pgpolicy_id(char *);
-int get_pgpolicy_name (char *, int, int);
+const char *get_pgpolicy_name (int);
 int group_paths(struct multipath *, int);
 /*
  * policies
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 841fa247..d214281b 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -268,7 +268,6 @@ verify_alua_prio(struct multipath *mp)
 int select_pgpolicy(struct config *conf, struct multipath * mp)
 {
 	const char *origin;
-	char buff[POLICY_NAME_SIZE];
 	int log_prio = 3;
 
 	if (conf->pgpolicy_flag > 0) {
@@ -288,9 +287,8 @@ out:
 		log_prio = 1;
 	}
 	mp->pgpolicyfn = pgpolicies[mp->pgpolicy];
-	get_pgpolicy_name(buff, POLICY_NAME_SIZE, mp->pgpolicy);
-	condlog(log_prio, "%s: path_grouping_policy = %s %s", mp->alias, buff,
-		origin);
+	condlog(log_prio, "%s: path_grouping_policy = %s %s", mp->alias,
+		get_pgpolicy_name(mp->pgpolicy), origin);
 	return 0;
 }
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

