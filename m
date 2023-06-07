Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE9AEC77B7A
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 20:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686170883;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2YMZ6F+MLN7pAl6OIsWyxfZgVPyK9NnERKiNfMi0014=;
	b=WHVFJtI/CRShWQn8vEWib3+VEpOz8peOE088DBMHs2ip+QDUm92+Swb9ANwt8FHSqbwMhr
	nNQktWIk+gC5ON1ebyGUPwgLQryxf5q3rbE2AkQhq8URHa+O3qSABJwat8xgHZ7mRihfuG
	uAV6f3skEe3j5AvOSS9uit7O9OYxCgY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-pIhTYxI3Me6s3mOLQf7jmQ-1; Wed, 07 Jun 2023 16:48:02 -0400
X-MC-Unique: pIhTYxI3Me6s3mOLQf7jmQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E30CB296A606;
	Wed,  7 Jun 2023 20:47:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 937599E93;
	Wed,  7 Jun 2023 20:47:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 549C619452C3;
	Wed,  7 Jun 2023 20:47:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3D79819465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 20:47:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2039C9E8B; Wed,  7 Jun 2023 20:47:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 032079E8D;
 Wed,  7 Jun 2023 20:47:56 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 357KlsNM005793;
 Wed, 7 Jun 2023 15:47:54 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 357KlrsR005792;
 Wed, 7 Jun 2023 15:47:53 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  7 Jun 2023 15:47:42 -0500
Message-Id: <1686170873-5754-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH V3 00/11] multipath: Add a group_by_tgp pgpolicy
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The first part adds a new path grouping policy that can be used with
ALUA devices. The goal is to avoid the temporary incorrect path
groupings that can happen when paths change priorities.

The second part is changes that mostly effect how multipathd handles
switching or reordering pathgroups for devices where group_by_prio isn't
set.

Differences from V2 (based on suggestions from Martin Wilck):
[01/11]: set loglevel in get_alua_info based on whether or not we're
         changing pp->tpg_id
[06/11]: fixed default detect_pgpolicy_use_tpg in template
[08/11]: fixed typo in patch header
[10/11]: fixed logic in path_groups_in_order()

Benjamin Marzinski (11):
  libmultipath: add group_by_tpg path_grouping_policy
  libmultipath: don't copy pgpolicy string in get_pgpolicy_name
  libmultipath: add ALUA tpg path wildcard
  multipath-tools tests: add tests for group_by_tpg policy
  libmultipath: add "detect_pgpolicy" config option
  libmultipath: add "detect_pgpolicy_use_tpg" config option
  libmultipath: don't count PRIO_UNDEF paths for pathgroup priority
  multipath-tools tests: add tests to verify PRIO_UNDEF changes
  multipathd: only refresh priorities in update_prio()
  multipathd: reload map if the path groups are out of order
  multipathd: don't assume mpp->paths will exist in
    need_switch_pathgroup

 libmultipath/config.c             |   4 +
 libmultipath/config.h             |   4 +
 libmultipath/configure.c          |   2 +
 libmultipath/defaults.h           |   2 +
 libmultipath/dict.c               |  28 +++-
 libmultipath/discovery.c          |   1 +
 libmultipath/hwtable.c            |   2 +
 libmultipath/libmultipath.version |  10 +-
 libmultipath/pgpolicies.c         |  42 +++---
 libmultipath/pgpolicies.h         |   6 +-
 libmultipath/print.c              |   9 ++
 libmultipath/prioritizers/alua.c  |   6 +-
 libmultipath/propsel.c            |  69 ++++++++-
 libmultipath/propsel.h            |   2 +
 libmultipath/structs.c            |   1 +
 libmultipath/structs.h            |  17 +++
 libmultipath/switchgroup.c        |  12 +-
 multipath/main.c                  |   1 +
 multipath/multipath.conf.5        |  29 ++++
 multipathd/cli_handlers.c         |   8 +-
 multipathd/fpin_handlers.c        |   4 +-
 multipathd/main.c                 | 175 +++++++++++----------
 multipathd/main.h                 |   3 +-
 tests/pgpolicy.c                  | 243 ++++++++++++++++++++++++++++++
 24 files changed, 552 insertions(+), 128 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

