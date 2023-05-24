Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 164FAC77B7A
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 23:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684970484;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FGIh0u+oaujT4womhTnqrbqV12ibKd+EVRGD0PMtC8s=;
	b=dInmLdI/l7jhFP+V7YAvtkx+mlu0Ql7D8RjQD5TfqlEbGNSPvW/zNjeouO9EaljKRm4yq1
	6fcep8OrHxdH5cng/Sh+JH+EFKJ522l1j+JFhfXoUIQUNlyMHL+jT2yGcSopAk80UZTHmI
	D9dwVWRdbJHsm/4kJ5jK6W5axfRoHOE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-0fGEp0tXM1KJo44tnxfrUA-1; Wed, 24 May 2023 19:21:21 -0400
X-MC-Unique: 0fGEp0tXM1KJo44tnxfrUA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80AA585A5BD;
	Wed, 24 May 2023 23:21:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6B71D2166B25;
	Wed, 24 May 2023 23:21:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2DBA419466DF;
	Wed, 24 May 2023 23:21:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3E55C19465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 23:21:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2FDD720296C6; Wed, 24 May 2023 23:21:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 14C5C200B401;
 Wed, 24 May 2023 23:21:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 34ONLF6F028717;
 Wed, 24 May 2023 18:21:16 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 34ONLFkA028716;
 Wed, 24 May 2023 18:21:15 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 24 May 2023 18:21:09 -0500
Message-Id: <1684970472-28669-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 2/5] multipath-tools tests: add tests to verify
 PRIO_UDEF changes
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Make sure that pathgroups that include paths with a prio_UNDEF priority
are properly sorted.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 tests/pgpolicy.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tests/pgpolicy.c b/tests/pgpolicy.c
index 85fa30ce..ccf29bc9 100644
--- a/tests/pgpolicy.c
+++ b/tests/pgpolicy.c
@@ -648,6 +648,26 @@ static void test_group_by_prio_mixed_one_marginal8(void **state)
 	verify_pathgroups(&mp8, p8, groups, group_size, group_marginal, 7);
 }
 
+static void test_group_by_prio_mixed_undef8(void **state)
+{
+	int prio[] = {7,1,3,-1,5,2,8,2};
+	int group0[] = {6};
+	int group1[] = {0};
+	int group2[] = {4};
+	int group3[] = {2};
+	int group4[] = {5,7};
+	int group5[] = {1};
+	int group6[] = {3};
+	int *groups[] = {group0, group1, group2, group3,
+			  group4, group5, group6};
+	int group_size[] = {1,1,1,1,2,1,1};
+
+	set_priority(p8, prio, 8);
+	mp8.pgpolicyfn = group_by_prio;
+	assert_int_equal(group_paths(&mp8, 0), 0);
+	verify_pathgroups(&mp8, p8, groups, group_size, NULL, 7);
+}
+
 static void test_group_by_tpg_same8(void **state)
 {
 	int paths[] = {0,1,2,3,4,5,6,7};
@@ -828,6 +848,26 @@ static void test_group_by_tpg_mixed_one_marginal8(void **state)
 	verify_pathgroups(&mp8, p8, groups, group_size, group_marginal, 7);
 }
 
+static void test_group_by_tpg_mixed_undef8(void **state)
+{
+	int prio[] = {-1,2,3,-1,5,2,8,2};
+	int tpg[] = {1,2,3,3,4,2,5,6};
+	int group0[] = {6};
+	int group1[] = {4};
+	int group2[] = {2,3};
+	int group3[] = {1,5};
+	int group4[] = {7};
+	int group5[] = {0};
+	int *groups[] = {group0, group1, group2, group3,
+			  group4, group5};
+	int group_size[] = {1,1,2,2,1,1};
+
+	set_priority(p8, prio, 8);
+	set_tpg(p8, tpg, 8);
+	mp8.pgpolicyfn = group_by_tpg;
+	assert_int_equal(group_paths(&mp8, 0), 0);
+	verify_pathgroups(&mp8, p8, groups, group_size, NULL, 6);
+}
 
 static void test_group_by_node_name_same8(void **state)
 {
@@ -1192,6 +1232,7 @@ int test_pgpolicies(void)
 		setup_test(test_group_by_prio_mixed_all_marginal, 8),
 		setup_test(test_group_by_prio_mixed_half_marginal, 8),
 		setup_test(test_group_by_prio_mixed_one_marginal, 8),
+		setup_test(test_group_by_prio_mixed_undef, 8),
 		setup_test(test_group_by_tpg_same, 8),
 		setup_test(test_group_by_tpg_different, 8),
 		setup_test(test_group_by_tpg_mixed, 8),
@@ -1203,6 +1244,7 @@ int test_pgpolicies(void)
 		setup_test(test_group_by_tpg_mixed_all_marginal, 8),
 		setup_test(test_group_by_tpg_mixed_half_marginal, 8),
 		setup_test(test_group_by_tpg_mixed_one_marginal, 8),
+		setup_test(test_group_by_tpg_mixed_undef, 8),
 		setup_test(test_group_by_node_name_same, 8),
 		setup_test(test_group_by_node_name_increasing, 8),
 		setup_test(test_group_by_node_name_3_groups, 8),
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

