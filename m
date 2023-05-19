Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED86BC7EE2E
	for <dm-devel@archiver.kernel.org>; Fri, 19 May 2023 23:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684537347;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=41GjsS7S0Ww7B3gJbFMfsFz5eQK+od+uQgzP6Q2x1wQ=;
	b=Wu2lsORb5qGAzbtjC0m484tlS+VOUbkd1tdeyFGuG9UP5WbcJgSHp2H46MsAqSgUpMOov4
	H0ynqQklew4+MycWVDDRIw2ybEz2cPy3AIJ04iY9LobfDyPy93mhIf+uoTB2WGUUhofPWg
	m0txjbgC0Dlm+n7LRt1zWFn+O3if+Qs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-378-YPjjSTGmPF2rk5Uk7IIsEw-1; Fri, 19 May 2023 19:02:22 -0400
X-MC-Unique: YPjjSTGmPF2rk5Uk7IIsEw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82BE838035AA;
	Fri, 19 May 2023 23:02:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6C4DA4F2DE2;
	Fri, 19 May 2023 23:02:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1D11F19465B3;
	Fri, 19 May 2023 23:02:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5EDAA19465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 19 May 2023 23:02:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2D3E4140E955; Fri, 19 May 2023 23:02:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D5733140E954;
 Fri, 19 May 2023 23:02:14 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 34JN2DJc023073;
 Fri, 19 May 2023 18:02:13 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 34JN2Cqc023072;
 Fri, 19 May 2023 18:02:12 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri, 19 May 2023 18:02:07 -0500
Message-Id: <1684537332-23033-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 0/5] multipath: Add a group_by_tgp path grouping
 policy
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patchset is adds a new path grouping policy that can be used with
ALUA devices. The goal is to avoid the temporary incorrect path
groupings that can happen when paths change priorities.

There is one thing that I'm not sure of.  Is there any possiblity of a
path device changing the target port group it belongs to while it use?
If so, then we would need code to check for this and reload the device
if it occurs.

Benjamin Marzinski (5):
  libmultipath: add group_by_tpg path_grouping_policy
  libmultipath: don't copy pgpolicy string in get_pgpolicy_name
  libmultipath: add ALUA tpg path wildcard
  multipath-tools tests: add tests for group_by_tpg policy
  libmultipath: add "detect_pgpolicy" config option

 libmultipath/config.c             |   2 +
 libmultipath/config.h             |   2 +
 libmultipath/configure.c          |   1 +
 libmultipath/defaults.h           |   1 +
 libmultipath/dict.c               |  17 ++-
 libmultipath/discovery.c          |   1 +
 libmultipath/hwtable.c            |   1 +
 libmultipath/libmultipath.version |  10 +-
 libmultipath/pgpolicies.c         |  42 ++++---
 libmultipath/pgpolicies.h         |   6 +-
 libmultipath/print.c              |   9 ++
 libmultipath/prioritizers/alua.c  |   1 +
 libmultipath/propsel.c            |  50 +++++++-
 libmultipath/propsel.h            |   1 +
 libmultipath/structs.c            |   1 +
 libmultipath/structs.h            |  10 ++
 multipath/main.c                  |   1 +
 multipath/multipath.conf.5        |  16 +++
 tests/pgpolicy.c                  | 201 ++++++++++++++++++++++++++++++
 19 files changed, 338 insertions(+), 35 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

