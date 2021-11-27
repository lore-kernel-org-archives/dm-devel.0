Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97765C433FE
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:21:05 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-nOEQLFSKPLilEM9x8Rgtkw-1; Sat, 27 Nov 2021 10:20:59 -0500
X-MC-Unique: nOEQLFSKPLilEM9x8Rgtkw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E74E185302D;
	Sat, 27 Nov 2021 15:20:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 684D560854;
	Sat, 27 Nov 2021 15:20:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1B2784A714;
	Sat, 27 Nov 2021 15:20:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFKfhU000660 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:20:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 04D282026D2E; Sat, 27 Nov 2021 15:20:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1D7B2026D65
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:20:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1E20811E76
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:20:37 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-233-kF03dIWfOeKUXxJiT32Xrg-1; Sat, 27 Nov 2021 10:20:35 -0500
X-MC-Unique: kF03dIWfOeKUXxJiT32Xrg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 89E801FCA1;
	Sat, 27 Nov 2021 15:20:34 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4ED3813AAD;
	Sat, 27 Nov 2021 15:20:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id JH8EEcJMomFrFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:20:34 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:55 +0100
Message-Id: <20211127152006.8035-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFKfhU000660
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 00/11] multipath-tools: improvements for
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Hi Christophe, hi Ben,

this series attempts to improve the robustness of the code by making the lookup
tables used for pretty printing and wildcard hanling static const arrays.
This requires getting rid of the variable "width" field in these arrays.
I could have simply split of "width" into a separate global array variable,
but as the field width are designed to change depending on the data being
printed, it makes more sense to use local variables for it and pass them to
the actual table-formatting code.

A couple of minor cleanups are done along the way.

As always, feedback welcome
Martin

Martin Wilck (11):
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

 libmultipath/foreign.c            |  72 ++++--
 libmultipath/foreign.h            |  25 ++-
 libmultipath/libmultipath.version |   5 +-
 libmultipath/print.c              | 360 +++++++++++++++++-------------
 libmultipath/print.h              |  60 ++---
 libmultipath/util.c               |   5 +
 libmultipath/util.h               |   1 +
 multipath/main.c                  |   7 +-
 multipathd/cli_handlers.c         |  79 ++++---
 9 files changed, 360 insertions(+), 254 deletions(-)

-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

