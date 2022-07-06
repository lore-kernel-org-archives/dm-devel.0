Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCE3CC43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657118346;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oWAl4y4c7LWHVU6KxWjdeqUaYzTMVmmpMp5zlCu9/S4=;
	b=N6s7lLVZSvMDcJbk09gXxrEhleos86x5YL/txHUntsWKJqygdZIl5d2kTJ+9y/3aVs7u9p
	Q0jm3vrLoo5RrDRtjdf2uNRQ6jmX8YHhW3/3TC1kN8rLIaJPR/YabRSWtrNpsk4BWht8lr
	w/Dc+N1OFQ06dCMYpNbH2z/zhb3PJkQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-ra_ehBjcOJmoUZtAhqVXuA-1; Wed, 06 Jul 2022 10:38:57 -0400
X-MC-Unique: ra_ehBjcOJmoUZtAhqVXuA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD3659693A3;
	Wed,  6 Jul 2022 14:38:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9703540315A;
	Wed,  6 Jul 2022 14:38:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6CA211947065;
	Wed,  6 Jul 2022 14:38:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3EE7B194706A
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 14:38:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 121CF2166B2B; Wed,  6 Jul 2022 14:38:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DDDC2166B29
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E718A3C0F375
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:52 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-G3sKpKh8NQqcn7Xy48CMGQ-1; Wed, 06 Jul 2022 10:38:45 -0400
X-MC-Unique: G3sKpKh8NQqcn7Xy48CMGQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id A04811F747;
 Wed,  6 Jul 2022 14:38:37 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 67D70134CF;
 Wed,  6 Jul 2022 14:38:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id k7zOF22exWKbSgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 06 Jul 2022 14:38:37 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  6 Jul 2022 16:38:08 +0200
Message-Id: <20220706143822.30182-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH 00/14] multipath: fixes for sysfs accessors
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

This set fixes some strangeness in our sysfs accessors which I
found while looking at
https://github.com/opensvc/multipath-tools/issues/35#issuecomment-1175901745.
(The patches don't fix this issue, which seems to be related to
Debian's initramfs setup).

Most importantly, sysfs_attr_get_value() and sysfs_attr_set_value()
would return 0 if the number of bytes read/written was different from
the expected value, which is non-standard and unexpected. This
series changes the return value semantics of these functions:

 - in sysfs_attr_get_value(), if a read buffer is too small to hold
   the string read plus a terminating 0 byte, the return value
   equals the buffer size.
 - in sysfs_bin_attr_get_value(), no 0 bytes are appended. It's not
   an error if the read buffer is completely filled, and no warning
   is printed in this case.
 - sysfs_attr_set_value() always returns the number of bytes written
   unless an error occured in open() or write().

Tests for the new semantics are added. Moreover, the sysfs.c code
is slightly refactored to avoid code duplication.

Martin Wilck (14):
  libmultipath: alua: remove get_sysfs_pg83()
  libmultipath: remove sysfs_get_binary()
  libmultipath: sysfs_bin_attr_get_value(): no error if buffer is filled
  libmultipath: common code path for sysfs_attr_get_value()
  libmultipath: sanitize error checking in sysfs accessors
  libmultipath: get rid of PATH_SIZE
  libmultipath: sysfs_attr_get_value(): don't return 0 if buffer too
    small
  libmultipath: sysfs_attr_set_value(): don't return 0 on partial write
  libmultipath: sysfs: cleanup file descriptors on pthread_cancel()
  libmultipath, multipathd: log failure setting sysfs attributes
  multipath tests: expect_condlog: skip depending on verbosity
  multipath tests: __wrap_dlog: print log message
  multipath tests: add sysfs test
  libmultipath.version: bump version for sysfs accessors

 libmultipath/configure.c              |  30 +-
 libmultipath/discovery.c              | 120 +++----
 libmultipath/libmultipath.version     |   8 +-
 libmultipath/prioritizers/alua_rtpg.c |  57 +--
 libmultipath/propsel.c                |   6 +-
 libmultipath/structs.h                |   3 -
 libmultipath/sysfs.c                  | 191 ++++------
 libmultipath/sysfs.h                  |  23 ++
 libmultipath/util.c                   |   8 +-
 multipathd/cli_handlers.c             |   2 +-
 multipathd/fpin_handlers.c            |  11 +-
 multipathd/main.c                     |  40 ++-
 tests/Makefile                        |   5 +-
 tests/sysfs.c                         | 494 ++++++++++++++++++++++++++
 tests/test-lib.c                      |   1 -
 tests/test-log.c                      |   5 +
 16 files changed, 751 insertions(+), 253 deletions(-)
 create mode 100644 tests/sysfs.c

-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

