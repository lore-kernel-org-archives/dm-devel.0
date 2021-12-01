Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 251DCC4332F
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 12:37:35 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-kSrgQRLGMk64h-1jD-9BGg-1; Wed, 01 Dec 2021 07:37:31 -0500
X-MC-Unique: kSrgQRLGMk64h-1jD-9BGg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53C801006AA1;
	Wed,  1 Dec 2021 12:37:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3598B5F4E1;
	Wed,  1 Dec 2021 12:37:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 117AF4CA93;
	Wed,  1 Dec 2021 12:37:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1CbAGa008672 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 07:37:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 492CF141DEC4; Wed,  1 Dec 2021 12:37:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4521A1402400
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29C8C185A7B4
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:10 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-522-jYhuftDxPROTo_CVpq2Vng-1; Wed, 01 Dec 2021 07:37:06 -0500
X-MC-Unique: jYhuftDxPROTo_CVpq2Vng-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BE9481FD58;
	Wed,  1 Dec 2021 12:37:04 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 82F3013FF5;
	Wed,  1 Dec 2021 12:37:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id P8YYHnBsp2GGKAAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 01 Dec 2021 12:37:04 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  1 Dec 2021 13:36:29 +0100
Message-Id: <20211201123650.16240-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B1CbAGa008672
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 00/21] multipath-tools: coverity fixes
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Hi Christophe, hi Ben,

I have started a new attempt to fix defects reported by coverity.
With this set (on top of the previously posted one), and a number
of false positive classifications, I have been able to bring the
defect count all the way down to zero.

Most of these patches fix defects reported by coverity. Some
fix other things that occured to me while working on this.

Changes v1 -> v2 (Ben Marzinski)

 - all: rebased to current "queue" branch
 - 05/21: If a broken designator is encountered in VPD 83, don't
     error out but try to go on as long as the designator is within
     limits of the VPD page
 - 06/21: adapt tests to the changes in 05/21, add some more
     (note: dropped Ben's "Reviewed-by:" on this one)
 - 08/21: reworked to take Ben's remarks into account

I didn't change 07/21 (see previous discussion).

Regards,
Martin

Martin Wilck (21):
  multipath tools: github workflows: add coverity workflow
  multipathd (coverity): check atexit() return value
  multipathd (coverity): terminate uxlsnr when polls allocation fails
  libmultipath: strbuf: add __get_strbuf_buf()
  libmultipath (coverity): improve input checking in parse_vpd_pg83
  multipath-tools: add tests for broken VPD page 83
  libmultipath: use strbuf in parse_vpd_pg83()
  libmultipath (coverity): fix tainted values in alua_rtpg.c
  multipath, multipathd: exit if bindings file is broken
  libmultipath (coverity): silence unchecked return value warning
  multipath: remove pointless code from getopt processing
  libmultipath (coverity): set umask before mkstemp
  multipathd (coverity): simplify set_oom_adj()
  kpartx: open /dev/loop-control only once
  kpartx: use opened loop device immediately
  kpartx: find_unused_loop_device(): add newlines
  multipathd (coverity): daemonize(): use dup2
  libmultipath (coverity): avoid sleeping in dm_mapname()
  libmultipath (coverity): Revert "setup_map: wait for pending path
    checkers to finish"
  libmultipath (coverity): check return values in dm_get_multipath()
  libmultipath: update_pathvec_from_dm: don't force DI_WWID

 .github/workflows/coverity.yaml       |  51 ++++++
 kpartx/kpartx.c                       |   4 +-
 kpartx/lopart.c                       | 100 +++++------
 kpartx/lopart.h                       |   3 +-
 libmultipath/alias.c                  |   4 +
 libmultipath/configure.c              |  63 +------
 libmultipath/devmapper.c              |  23 +--
 libmultipath/discovery.c              | 245 ++++++++++++++------------
 libmultipath/prioritizers/alua_rtpg.c |  13 +-
 libmultipath/prioritizers/alua_spc3.h |  43 ++++-
 libmultipath/propsel.c                |   2 +-
 libmultipath/strbuf.c                 |   5 +
 libmultipath/strbuf.h                 |  14 ++
 libmultipath/structs_vec.c            |   7 +-
 multipath/main.c                      |  13 +-
 multipathd/main.c                     |  91 +++++-----
 multipathd/uxlsnr.c                   |   1 +
 tests/vpd.c                           | 144 ++++++++++++++-
 18 files changed, 500 insertions(+), 326 deletions(-)
 create mode 100644 .github/workflows/coverity.yaml

-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

