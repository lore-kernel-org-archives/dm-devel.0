Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB85C77B7A
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 20:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686082403;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bDJXlIpZajHzRgEvBiYdx4GmMlcZbWE1ywyOKIeJH2A=;
	b=XKPz7ZdpBQEx8niNsYfHNvgIRhUYPKELpWCUhbgMXQXPqWvDypImVbr+Ppq9JmXf8bRYUd
	CAWmywcv20LXyfRijunENpOygpgSX2nIEZGwpK/a2e7NOqYTtU8lDgJwwnqXuDnQkAGmv6
	KsaT97CyTlCMlxF3V4LJabbv9GOUqHo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-H40_2CtPMrSepkJcJEJjRw-1; Tue, 06 Jun 2023 16:13:20 -0400
X-MC-Unique: H40_2CtPMrSepkJcJEJjRw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C7CA101AA68;
	Tue,  6 Jun 2023 20:13:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1183740D1B66;
	Tue,  6 Jun 2023 20:13:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CE5FD19465BC;
	Tue,  6 Jun 2023 20:13:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 069EC19465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 20:13:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D394A40D1B68; Tue,  6 Jun 2023 20:13:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BA49640D1B66;
 Tue,  6 Jun 2023 20:13:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 356KDCRp029248;
 Tue, 6 Jun 2023 15:13:12 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 356KDB8Y029247;
 Tue, 6 Jun 2023 15:13:11 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue,  6 Jun 2023 15:13:00 -0500
Message-Id: <1686082391-29210-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH V2 00/11] multipath: Add a group_by_tgp pgpolicy
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

This patchset is a combination of my previous two patchsets

[PATCH 0/5] multipath: Add a group_by_tgp path grouping policy
[PATCH 0/5] priority and pathgroup switching changes

The first part adds a new path grouping policy that can be used with
ALUA devices. The goal is to avoid the temporary incorrect path
groupings that can happen when paths change priorities.

The second part is changes that mostly effect how multipathd handles
switching or reordering pathgroups for devices where group_by_prio isn't
set.

Differences from V1 (from changes suggested by Martin Wilck):
[05/11]: make detect_pgpolicy set group_by_prio instead of group_by_tpg
[06/11]: New patch. Add detect_pgpolicy_use_tpg to pick group_by_tpg
         instead of group_by_prio
[09/11]: Large rewrite of my "multipathd: refresh all priorities if one
         has changed" patch based on discussions with Martin
[10/11]: This just moves path_groups_in_order() to multiapthd, and adds
         a comment explaining why it works different from
         select_path_group().

Benjamin Marzinski (11):
  libmultipath: add group_by_tpg path_grouping_policy
  libmultipath: don't copy pgpolicy string in get_pgpolicy_name
  libmultipath: add ALUA tpg path wildcard
  multipath-tools tests: add tests for group_by_tpg policy
  libmultipath: add "detect_pgpolicy" config option
  libmultipath: add "detect_pgpolicy_use_tpg" config option
  libmultipath: don't count PRIO_UNDEF paths for pathgroup priority
  multipath-tools tests: add tests to verify PRIO_UDEF changes
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
 libmultipath/prioritizers/alua.c  |   1 +
 libmultipath/propsel.c            |  69 ++++++++-
 libmultipath/propsel.h            |   2 +
 libmultipath/structs.c            |   1 +
 libmultipath/structs.h            |  17 +++
 libmultipath/switchgroup.c        |  12 +-
 multipath/main.c                  |   1 +
 multipath/multipath.conf.5        |  29 ++++
 multipathd/cli_handlers.c         |   8 +-
 multipathd/fpin_handlers.c        |   4 +-
 multipathd/main.c                 | 174 +++++++++++----------
 multipathd/main.h                 |   3 +-
 tests/pgpolicy.c                  | 243 ++++++++++++++++++++++++++++++
 24 files changed, 547 insertions(+), 127 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

