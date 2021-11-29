Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE46DC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 20:11:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-j5GBWwyoPMC3RUTxuhirqA-1; Mon, 29 Nov 2021 15:11:06 -0500
X-MC-Unique: j5GBWwyoPMC3RUTxuhirqA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 536631006AA1;
	Mon, 29 Nov 2021 20:11:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C43B45D64;
	Mon, 29 Nov 2021 20:11:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E4FBE4A707;
	Mon, 29 Nov 2021 20:11:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATK9n5p002008 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 15:09:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 638E1112131B; Mon, 29 Nov 2021 20:09:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F1351121319
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 20:09:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38203802814
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 20:09:41 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-49-Udwvc4GyPtGvOcvd4iDZ2g-1; Mon, 29 Nov 2021 15:09:39 -0500
X-MC-Unique: Udwvc4GyPtGvOcvd4iDZ2g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C6A771FD2F;
	Mon, 29 Nov 2021 20:09:37 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 801DA13BDA;
	Mon, 29 Nov 2021 20:09:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id ZTslHYEzpWFsHgAAMHmgww
	(envelope-from <mwilck@suse.com>); Mon, 29 Nov 2021 20:09:37 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 29 Nov 2021 21:08:49 +0100
Message-Id: <20211129200902.21817-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ATK9n5p002008
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 00/13] multipath-tools: improvements for
	pretty-printing code
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Hi Christophe, hi Ben,

this series attempts to improve the robustness of the code by making the lookup
tables used for pretty printing and wildcard handling static const arrays.
This requires getting rid of the variable "width" field in these arrays.
I could have simply split of "width" into a separate global array variable,
but as the field width are designed to change depending on the data being
printed, it makes more sense to use local variables for it and pass them to
the actual table-formatting code.

A couple of minor cleanups are done along the way.

Changes in v2:

 - 10/13: fix a compilation error with clang because of duplicate typedef
   for fieldwidth_t
 - whitespace fixes
 - 12/13: new, fix a compile error with clang-13
 - 13/13: new, fix an asan error reported by Lixiaokeng

As always, feedback welcome
Martin

Martin Wilck (13):
  libmultipath: make multipath_data etc. static
  libmultipath: move path_data etc. to print.c
  libmultipath: make pd_lookup() etc. return an index
  libmultipath: use ARRAY_SIZE for iterating over wildcard arrays
  libmultipath: drop padding code in _snprint_pathgroup()
  libmultipath: snprint_foreign_topology(): split out lockless variant
  multipathd: drop unnecessary path layout calls
  libmultipath: add a cleanup function for unsigned char *
  libmultipath: make sprint_path_marginal() static
  libmultipath: introduce width argument for pretty-printing functions
  libmultipath: change wildcard handler tables to static const
  libmultipath: fix compilation error with clang 13
  libmultipath: remove_map(): make sure orphaned paths aren't referenced

 libmultipath/foreign.c                   |  74 +++--
 libmultipath/foreign.h                   |  23 +-
 libmultipath/generic.h                   |   8 +
 libmultipath/libmultipath.version        |   5 +-
 libmultipath/print.c                     | 356 +++++++++++++----------
 libmultipath/print.h                     |  58 ++--
 libmultipath/prioritizers/weightedpath.c |   3 +-
 libmultipath/structs_vec.c               |   4 +
 libmultipath/util.c                      |   5 +
 libmultipath/util.h                      |   1 +
 multipath/main.c                         |   7 +-
 multipathd/cli_handlers.c                |  75 +++--
 12 files changed, 367 insertions(+), 252 deletions(-)

-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

