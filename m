Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F26FC43334
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jul 2022 08:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657700487;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DqwDA5m9kUKp13XBam3AnHoM2Skpt9PjTVjlCkoCAE0=;
	b=ch/iyhpbQ4qUKOzGz3zpRRuUIiwwpKfKySVF74AaZqa7P3RV40sFi6UDFXqyvOAvrByRDD
	EDREo2jwgQr3O9o/AvCLSrENI7tv2jtTe+PVXJJAZ8CbTZBQfR3m2nyENemd2EnrIuu9pi
	CEo/3q+93J4KCpyB7DDbPa0/KuaUHVs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-gxRZ_NtyPl2Pl4zkC67N2A-1; Wed, 13 Jul 2022 04:21:24 -0400
X-MC-Unique: gxRZ_NtyPl2Pl4zkC67N2A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 607968037B3;
	Wed, 13 Jul 2022 08:21:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E577F40315B;
	Wed, 13 Jul 2022 08:21:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A6E1E194705F;
	Wed, 13 Jul 2022 08:21:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C85A2194704C
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Jul 2022 08:21:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BD3261121319; Wed, 13 Jul 2022 08:21:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B8BAC1121314
 for <dm-devel@redhat.com>; Wed, 13 Jul 2022 08:21:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C8BB8032F2
 for <dm-devel@redhat.com>; Wed, 13 Jul 2022 08:21:18 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-EiYfCoG_NdOFl72ccP6I1Q-1; Wed, 13 Jul 2022 04:21:16 -0400
X-MC-Unique: EiYfCoG_NdOFl72ccP6I1Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 537771FDF2;
 Wed, 13 Jul 2022 08:21:15 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 247E713754;
 Wed, 13 Jul 2022 08:21:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id /cQ4B3uAzmKYNAAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 13 Jul 2022 08:21:15 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 13 Jul 2022 10:20:42 +0200
Message-Id: <20220713082043.22561-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH v2 00/14] multipath: fixes for sysfs accessors
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

Changes v1 -> v2:
   08/14: fixes suggested by Benjamin Marzinski

I am not resending the entire series; see
https://github.com/openSUSE/multipath-tools/commits/tip
 
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
 libmultipath/discovery.c              | 124 +++----
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
 16 files changed, 753 insertions(+), 255 deletions(-)
 create mode 100644 tests/sysfs.c

-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

