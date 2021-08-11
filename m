Return-Path: <SRS0=1CEe=NC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B216EC4338F
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:42:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4397760FC3
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4397760FC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-3lGQuXMFOumaKWt5wYytCg-1; Wed, 11 Aug 2021 11:42:38 -0400
X-MC-Unique: 3lGQuXMFOumaKWt5wYytCg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F239196632E;
	Wed, 11 Aug 2021 15:42:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 726295C23A;
	Wed, 11 Aug 2021 15:42:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 49B9D1819AC2;
	Wed, 11 Aug 2021 15:42:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17BFgN0S010153 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 11 Aug 2021 11:42:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 67592207ADC2; Wed, 11 Aug 2021 15:42:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 62099207ADDA
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 15:42:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 494A9866DFC
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 15:42:23 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-59-Rzj35Gt_PfiPtBCDu9FwKw-1; Wed, 11 Aug 2021 11:42:04 -0400
X-MC-Unique: Rzj35Gt_PfiPtBCDu9FwKw-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B86AC1FEDA;
	Wed, 11 Aug 2021 15:42:02 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 82C1713969;
	Wed, 11 Aug 2021 15:42:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap1.suse-dmz.suse.de with ESMTPSA id pVjnHcrvE2H/XQAAGKfGzw
	(envelope-from <mwilck@suse.com>); Wed, 11 Aug 2021 15:42:02 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 11 Aug 2021 17:41:41 +0200
Message-Id: <20210811154150.24714-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17BFgN0S010153
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 0/9] multipath-tools: use variable-size string
	buffers
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Current libmultipath contains a lot of code writing text to pre-allocated
string buffers of fixed size while trying to avoid buffer overflows
or truncation of the output string. This code is, at least in part,
hard to verify and hard to read, as buffer sizes and positions need to
be checked after every additon of text. It requires either allocating large
buffers in advance, or risking to loose data, or re-allocating buffers
and starting over again.

This patch set changes this by switching almost entirely to text buffers
that are dynamically allocated and grow automatically as text is added.

The first patch, which was the initial motivation of the set, doesn't
need growing buffers, it just overcomes the PARAMS_SIZE limitation by
copying data from libdm. However if the PARAMS_SIZE limitation was dropped
when reading from the kernel, it made sense to drop it for constructing
PARAMS, too. This motivated the implementation of the strbuf API (patch 2),
and using it in assemble_map (patch 3). The API was then consequently used
elswhere in libmultipath too, where strings are built up in pieces (patch 4,
5, 8, 9). These additional changes are huge because of large number of
affected "snprint_xyz" functions and respective function calls, but most
of the changes are mechanical and follow always the same overall idea.

Finally, patch 6 and 7 are cleanups which I found necessary while working
on print.c.

Regression testing: added a test suite for strbuf itself, made sure
all tests cases (which involve quite a bit of printf_xyz() functions) still
pass, and compared output of lots of interactive multipathd and multipath
commands before and after the change.

Note that "multipathd show config" / "multipath -t" will show some minor
differences in the output, because the current code omits quotes for some
output value fields. With this patch set, all string values are quoted.

The patch set is available also on my "tip" branch:
https://github.com/openSUSE/multipath-tools/tree/tip.

Changes wrt v1 (thanks to Ben Marzinski for all):

 - 1/9: added missing pointer dereference
 - 2/9: fixed buffer size calculation, simplified code in __append_strbuf_str()
 - 3/9: use STRBUF_ON_STACK() rather than hand-coded __attribute__
        moved free() statement before goto in ev_add_path().
 - 4/9: Fixed return value of snprint_uid_attrs()
 - 5/9: Removed extra '-'

Martin Wilck (9):
  libmultipath: variable-size parameters in dm_get_map()
  libmultipath: strbuf: simple api for growing string buffers
  libmultipath: variable-size parameters in assemble_map()
  libmultipath: use strbuf in dict.c
  libmultipath: use strbuf in print.c
  libmultipath: print.c: fail hard if keywords are not found
  libmultipath: print.h: move macros to print.c
  libmultipath: use strbuf in alias.c.
  multipathd: use strbuf in cli.c

 libmultipath/Makefile                    |    2 +-
 libmultipath/alias.c                     |   84 +-
 libmultipath/blacklist.c                 |   13 +-
 libmultipath/configure.c                 |   18 +-
 libmultipath/configure.h                 |    3 +-
 libmultipath/devmapper.c                 |   44 +-
 libmultipath/devmapper.h                 |    4 +-
 libmultipath/dict.c                      |  314 ++--
 libmultipath/dict.h                      |   19 +-
 libmultipath/discovery.c                 |   13 +-
 libmultipath/dmparser.c                  |   47 +-
 libmultipath/dmparser.h                  |    2 +-
 libmultipath/foreign.c                   |   78 +-
 libmultipath/foreign.h                   |   13 +-
 libmultipath/foreign/nvme.c              |  100 +-
 libmultipath/generic.c                   |   26 +-
 libmultipath/generic.h                   |   17 +-
 libmultipath/libmultipath.version        |   21 +-
 libmultipath/parser.c                    |   50 +-
 libmultipath/parser.h                    |   17 +-
 libmultipath/print.c                     | 1839 ++++++++++------------
 libmultipath/print.h                     |  131 +-
 libmultipath/prioritizers/weightedpath.c |   71 +-
 libmultipath/propsel.c                   |  147 +-
 libmultipath/strbuf.c                    |  207 +++
 libmultipath/strbuf.h                    |  168 ++
 libmultipath/structs.h                   |    1 -
 libmultipath/structs_vec.c               |   11 +-
 libmultipath/util.c                      |    5 +
 libmultipath/util.h                      |    1 +
 multipathd/cli.c                         |   94 +-
 multipathd/cli_handlers.c                |  349 ++--
 multipathd/main.c                        |   20 +-
 tests/Makefile                           |    3 +-
 tests/alias.c                            |   41 +-
 tests/strbuf.c                           |  412 +++++
 36 files changed, 2313 insertions(+), 2072 deletions(-)
 create mode 100644 libmultipath/strbuf.c
 create mode 100644 libmultipath/strbuf.h
 create mode 100644 tests/strbuf.c

-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

