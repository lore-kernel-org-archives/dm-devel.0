Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39485C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  2 Dec 2021 16:08:44 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-ARgsIoK5PBmYj_b1d4Zp_g-1; Thu, 02 Dec 2021 11:08:41 -0500
X-MC-Unique: ARgsIoK5PBmYj_b1d4Zp_g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9575E1006AA2;
	Thu,  2 Dec 2021 16:08:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 73D9A5F4E7;
	Thu,  2 Dec 2021 16:08:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1DC004CA93;
	Thu,  2 Dec 2021 16:08:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B2G7WZg006786 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 11:07:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D4A314047279; Thu,  2 Dec 2021 16:07:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D055E4047272
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B65A61066558
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:32 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-479-S1BvcMgYO5i3S8kHLLOTfA-1; Thu, 02 Dec 2021 11:07:30 -0500
X-MC-Unique: S1BvcMgYO5i3S8kHLLOTfA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 809B4212C6;
	Thu,  2 Dec 2021 16:07:29 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4682313E82;
	Thu,  2 Dec 2021 16:07:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id itYVD0HvqGGnEgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 02 Dec 2021 16:07:29 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  2 Dec 2021 17:06:40 +0100
Message-Id: <20211202160652.4576-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B2G7WZg006786
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 00/11] Last-minute patches for multipath-tools
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

here are some last-minute fixes that I'd like to have added to
the currently pending multipath-tools update. None of them touches
any real functionality, except the first one, which I already sent
earlier today. Patch 3,4,5 were already included in my github PR
(which I'm going to rebase to match this submission). Patch 2 supersedes
"multipath-tools: generate abi without version script" from the first
version of the Github PR. The rest is new, tidy-up work for
libmultipath.version.

Regards
Martin

Martin Wilck (11):
  multipathd.service: add dependency on systemd-udevd-kernel.socket
  multipath-tools: generate abi with dummy version script
  multipath-tools: github abi workflow: don't fail on reference branch
  multipath-tools: github workflows: rebuild containers for rolling
    distros
  multipath tools: github workflows: add coverity workflow
  multipath-tools: .mailmap: add some more entries
  libmultipath: make orphan_paths() static
  libmultipath: make update_pathvec_from_dm() static
  libmultipath: remove recv_packet_from_client()
  libmultipath.version: drop some unused symbols
  libmultipath.version: sort symbols

 .github/workflows/abi.yaml        |  2 +-
 .github/workflows/coverity.yaml   | 51 +++++++++++++++++
 .github/workflows/native.yaml     | 62 +++++++++++++++++++-
 .mailmap                          |  7 +++
 Makefile.inc                      |  1 +
 libdmmp/Makefile                  |  2 +-
 libmpathcmd/Makefile              | 13 ++++-
 libmpathpersist/Makefile          | 15 ++++-
 libmpathvalid/Makefile            | 16 +++++-
 libmultipath/Makefile             | 13 ++++-
 libmultipath/libmultipath.version | 95 ++++++++++---------------------
 libmultipath/structs_vec.c        |  4 +-
 libmultipath/structs_vec.h        |  4 --
 libmultipath/uxsock.c             |  5 --
 libmultipath/uxsock.h             |  6 --
 multipathd/multipathd.service     |  2 +
 16 files changed, 203 insertions(+), 95 deletions(-)
 create mode 100644 .github/workflows/coverity.yaml

-- 
2.34.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

