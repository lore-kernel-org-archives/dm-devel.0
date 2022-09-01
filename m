Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 553CAECAAD3
	for <dm-devel@archiver.kernel.org>; Thu,  1 Sep 2022 22:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662070172;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eT3aIptVnFXenVl5tCiOvR5INdbmefVYYcfTeJajGE0=;
	b=BtskPniZF8i+jY9PhHpfV4nKd6y1zkf2u7FYZN9J+uG8S7Ff4CX6G3C49WfRmWGkuwwC1H
	wh5g30VMuwTEfHxzCzUBSSi4Q1rODMiTRNl4tlGzoPudjrn+uiM3nXxaS8a/ggZgzHKSLU
	zm/QsI5HExb6cl/D2nwWiGI6uWl4gGc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-UGjdjMVTPOGr8hBafjRYiQ-1; Thu, 01 Sep 2022 18:09:29 -0400
X-MC-Unique: UGjdjMVTPOGr8hBafjRYiQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3170F18188A3;
	Thu,  1 Sep 2022 22:09:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5DE19492C3B;
	Thu,  1 Sep 2022 22:09:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 53988194035B;
	Thu,  1 Sep 2022 22:09:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A7D931946A5E
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Sep 2022 22:09:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8B18E40C1421; Thu,  1 Sep 2022 22:09:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 877EE40C141D
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 22:09:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 786BE1C051AC
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 22:09:23 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-70-NTc3IIlEOm2ruMK2JGYIxA-1; Thu,
 01 Sep 2022 18:09:21 -0400
X-MC-Unique: NTc3IIlEOm2ruMK2JGYIxA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 025CF206C2;
 Thu,  1 Sep 2022 22:09:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C588213A89;
 Thu,  1 Sep 2022 22:09:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id /Nl4Lo8tEWMuFQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 01 Sep 2022 22:09:19 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri,  2 Sep 2022 00:09:11 +0200
Message-Id: <20220901220912.4894-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH v2 00/16] multipath-tools: minor fixes and build
 improvements
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
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Hi Ben, hi Christophe,

here's a set of minor fixes for multipath-tools.

Regards
Martin

Changes v1->v2:
  16/16 caused compilation to fail. Fixed. Only resending this patch,

Martin Wilck (16):
  multipath-tools: Makefile: remove useless .PHONY targets
  multipath-tools: Makefile: fix install->all dependency
  multipath-tools: Makefile: remove dependency test -> test-progs
  multipath-tools: Makefile: run abidiff with --redundant flag
  libdmmp: Makefile: create man3dir
  tests/Makefile: use $(multipathdir)
  tests/Makefile: add library dependencies
  tests/Makefile: use symbolic links under tests/lib
  tests/Makefile: redirect program output into output file
  GitHub workflows: package shared objects in artifact
  libmultipath: replace close_fd() with cleanup_fd_ptr()
  libmultipath: cleanup_free_ptr(): avoid double free
  multipath: find_multipaths_check_timeout(): no need for pthread
    cleanup
  multipathd: fix segfault in cli_list_map_fmt()
  multipathd: fix broken pthread cleanup in
    fpin_fabric_notification_receiver()
  multipathd: Fix command completion in interactive mode

 .github/workflows/foreign.yaml    |  2 +
 Makefile                          |  8 ++--
 libdmmp/Makefile                  |  1 +
 libmpathutil/libmpathutil.version |  6 ++-
 libmpathutil/util.c               | 19 ++++++---
 libmpathutil/util.h               |  2 +-
 libmultipath/alias.c              |  4 +-
 libmultipath/foreign/nvme.c       |  4 +-
 libmultipath/sysfs.c              | 12 +++---
 libmultipath/wwids.c              |  8 ++--
 multipath/main.c                  |  8 ++--
 multipathd/callbacks.c            | 60 +++++++++++++++++++++++++++++
 multipathd/cli.c                  |  2 +
 multipathd/cli_handlers.c         | 64 ++-----------------------------
 multipathd/fpin_handlers.c        |  9 +++--
 multipathd/main.c                 |  1 -
 multipathd/multipathc.c           |  3 ++
 tests/Makefile                    | 26 ++++++-------
 18 files changed, 129 insertions(+), 110 deletions(-)
 create mode 100644 multipathd/callbacks.c

-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

