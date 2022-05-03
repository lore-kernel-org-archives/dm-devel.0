Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BA28C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  3 May 2022 22:54:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-H7jRq8RzMGauzijwzbq8-g-1; Tue, 03 May 2022 18:54:51 -0400
X-MC-Unique: H7jRq8RzMGauzijwzbq8-g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5108D38C5C43;
	Tue,  3 May 2022 22:54:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B9028463E16;
	Tue,  3 May 2022 22:54:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3A8BD1947040;
	Tue,  3 May 2022 22:54:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0799C19466DF
 for <dm-devel@listman.corp.redhat.com>; Tue,  3 May 2022 22:54:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D82E840CFD32; Tue,  3 May 2022 22:54:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D3DD340CFD19
 for <dm-devel@redhat.com>; Tue,  3 May 2022 22:54:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB3151014A6D
 for <dm-devel@redhat.com>; Tue,  3 May 2022 22:54:46 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-ccklmTGPOCmwC7YBR7yV5g-1; Tue, 03 May 2022 18:07:32 -0400
X-MC-Unique: ccklmTGPOCmwC7YBR7yV5g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 08C38210C2;
 Tue,  3 May 2022 22:07:16 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CE2B413ABE;
 Tue,  3 May 2022 22:07:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 35ylMJOncWLfFgAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 03 May 2022 22:07:15 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  4 May 2022 00:06:39 +0200
Message-Id: <20220503220646.16925-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH 0/7] multipath-tools: fix unit test breakage
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Hi Christophe, hi Ben,

The previous patches 

af15832 multipath-tools: make multipath_dir a compiled-in option
1fc7c4d multipath-tools: make config_dir a compiled-in option
21b3d6b multipath-tools: stop supporting getuid_callout

have caused breakage in the unit tests. Not so much because they'd
actually break the tests, but because they broke the compilation and
the search paths for the configuration files (for the former two commits)
and because the hwtable test relied on being able to the retrieve
the now removed "getuid_callout" property from config files.

Fix it. As always, comments welcome.

Regards
Martin

Martin Wilck (7):
  multipath-tools: enable local configdir and plugindir for unit tests
  tests/mpathvalid: fix check for DEFAULT_CONFIG_FILE
  multipath-tools tests: hwtable: adapt after removal of getuid
  tests/hwtable: fix test_regex_2_strings_hwe_dir
  libmultipath: fix valgrind_test
  tests/Makefile: make TESTDIR configurable
  github workflows: foreign.yaml: fix config dir in run environment

 .github/workflows/foreign.yaml |   7 +-
 libmultipath/Makefile          |  24 ++++--
 libmultipath/config.c          |   3 +
 tests/Makefile                 |  12 ++-
 tests/hwtable.c                | 151 ++++++++++++++++-----------------
 tests/mpathvalid.c             |   2 +-
 tests/test-lib.c               |  89 ++++++++++++++-----
 tests/test-lib.h               |   2 +-
 8 files changed, 180 insertions(+), 110 deletions(-)

-- 
2.36.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

