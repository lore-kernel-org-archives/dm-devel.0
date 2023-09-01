Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F21ECA0FF1
	for <dm-devel@archiver.kernel.org>; Fri,  1 Sep 2023 18:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693591407;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DTFONKzl8ox3PzKODswlQWaC3mLrPglGJXR4NhD3nTU=;
	b=BK3VUZT+eTBDQekSHZRNQIebxFV6w9iEtd4CSacc8caBWGmO2/Ci7OjW3eYP85bKfLbe9L
	Eam7GRvk9TWZallmjbY6rzBiVOf9WPT1THAXXYTPgmh9ybPAfknKEc40vjTknYffDqTqbR
	Scl4fd5mLj1ltG3fNSb5CKR112ighhQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-ggWtf0m8PK2o3WsS2ppqDA-1; Fri, 01 Sep 2023 14:03:24 -0400
X-MC-Unique: ggWtf0m8PK2o3WsS2ppqDA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1931B1817918;
	Fri,  1 Sep 2023 18:03:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5CA7C400E410;
	Fri,  1 Sep 2023 18:03:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 387C01946A46;
	Fri,  1 Sep 2023 18:03:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7C4C719465B7
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Sep 2023 18:03:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 188091005B8E; Fri,  1 Sep 2023 18:03:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 10C121005B8D
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E58BE3C0EAAC
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:18 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-306-4ove-Eg1PLW_ak3A4EZojw-1; Fri,
 01 Sep 2023 14:03:17 -0400
X-MC-Unique: 4ove-Eg1PLW_ak3A4EZojw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id DCFE9211CE;
 Fri,  1 Sep 2023 18:03:15 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AB4EE13582;
 Fri,  1 Sep 2023 18:03:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id Xx/eJ2Mn8mTpRQAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 01 Sep 2023 18:03:15 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri,  1 Sep 2023 20:02:13 +0200
Message-ID: <20230901180235.23980-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH 00/21] multipath-tools: user-friendly names rework
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This patch set contains a two-step rework of the user-friendly
names code. Patch 2-5 change the current code such that it (well, almost)
never attempts to use an alias that is currently in use by another
map. We already have some checks for this, but they don't cover all
possible scenarios. Patch 6-10 add some units tests for
get_user_friendly_alias(), and restructure the unit tests somewhat.

In the second part of the set, Patch 11-18 restructure the alias code such
that we don't read the bindings file every time an alias is
requested. Instead, we just use a memory cache of the current bindings, and
re-write the file only if a new binding is added.  This reduces the number of
system calls and simplifies the code.

There are some side effects, which are discussed in the commit message of
patch 18. Most importantly, multipathd will not pick up changes to the
bindings file immediately after running "multipath -a" or "multipath -w".

Patch 19 applies the changes to the unit tests that become
necessary because of the previous patches. Patch 20/21 add another
optimization for the alias_already_taken() test.

Patch 1 is a separate, independent fix.

NOTE: my main test bed is currently unavailable, therefore this set has
yet reveived less testing than usual. I consider this a v1 series and
will do more testing while the review process is going on.

Reviews and comments welcome.

Martin Wilck (21):
  libmultipath: sysfs_set_scsi_tmo: do nothing for ACT_DRY_RUN
  libmultipath: add alias_already_taken()
  libmultipath: unify use_existing_alias() and get_user_friendly_alias()
  libmultipath: never allocate an alias that's already taken
  libmultipath: lookup_binding: add comment about the algorithm
  multipath-tools test: simplify debugging for condlog mismatch
  multipath-tools tests: add tests for get_user_friendly_alias()
  multipath-tools test: consistent use of macros in alias test
  multipath-tools tests: convert mock_{failed,used}_alias to macros
  multipath-tools test: use mock_bindings_file() consistently
  libmultipath: add global variable for current bindings
  libmultipath: rename fix_bindings_file() to update_bindings_file()
  libmultipath: alias.c: move bindings related code up
  libmultipath: update_bindings_file: take filename argument
  libmultipath: update_bindings_file: use a single write()
  libmultipath: update_bindings_file: don't log temp file name
  libmultipath: alias.c: factor out read_binding()
  libmultipath: keep bindings in memory
  multipath-tools tests: fix alias tests
  libmultipath: dm_get_uuid(): return emtpy UUID for non-existing maps
  libmultipath: adapt to new semantics of dm_get_uuid()

 libmultipath/alias.c              |  794 ++++++++---------
 libmultipath/alias.h              |   10 +-
 libmultipath/configure.c          |    7 +-
 libmultipath/devmapper.c          |   10 +-
 libmultipath/discovery.c          |    3 +
 libmultipath/libmultipath.version |    1 +
 libmultipath/propsel.c            |   19 +-
 multipath/main.c                  |    2 +
 multipathd/main.c                 |    1 +
 tests/alias.c                     | 1366 ++++++++++++++++++++++-------
 tests/test-log.c                  |    4 +-
 11 files changed, 1491 insertions(+), 726 deletions(-)

-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

