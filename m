Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFDD0C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 16 Dec 2021 12:56:18 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-PrLL50mfOiqzAMc6P9u1Tw-1; Thu, 16 Dec 2021 07:56:13 -0500
X-MC-Unique: PrLL50mfOiqzAMc6P9u1Tw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B3721927838;
	Thu, 16 Dec 2021 12:56:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E86ED610F6;
	Thu, 16 Dec 2021 12:56:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BAC061809CB9;
	Thu, 16 Dec 2021 12:56:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BGCtLVP020385 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Dec 2021 07:55:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DF0CEC33AE7; Thu, 16 Dec 2021 12:55:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DAB88C33AE3
	for <dm-devel@redhat.com>; Thu, 16 Dec 2021 12:55:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1FA1185A7BA
	for <dm-devel@redhat.com>; Thu, 16 Dec 2021 12:55:21 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-639-23F29ksgOpiGb72ySajnbQ-1; Thu, 16 Dec 2021 07:55:17 -0500
X-MC-Unique: 23F29ksgOpiGb72ySajnbQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B9440212BC;
	Thu, 16 Dec 2021 12:55:15 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 77ABE13E3B;
	Thu, 16 Dec 2021 12:55:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id RVo0GzM3u2FVYQAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 16 Dec 2021 12:55:15 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 16 Dec 2021 13:54:57 +0100
Message-Id: <20211216125502.15867-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1BGCtLVP020385
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 0/5] libmpathpersist: cleanup ABI and headers
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Hi Christophe, hi Ben,

when reviewing Ben's last patch set, I noticed that the change
of struct multipath would formally change the ABI of libmpathpersist,
even though the public API as defined by mpath_persist.h doesn't
reference this struct.

This set cleans this up by splitting the libmpathpersist code into a
public part, a semi-private part (used by other multipath-tools components)
and a private part (used by libmpathpersist alone). In the future,
the abi check tools will detect an ABI change in cases like this, but it'll
be easy to check whether the public or private part of the ABI is affected.

A minor version bump of the libmpathpersist version is required to reflect
the fact that symbols have been removed from the LIBMPATHPERSIST versioned
ABI.

The set also contains some other minor header file cleanups. No actual code
flow is changed, only code shuffled around.

Regards
Martin

Martin Wilck (5):
  libmpathpersist: split public and internal API
  multipathd: remove duplicate definitions from main.h
  libmpathpersist/multipathd: remove duplicate definition
  libmpathpersist: remove __STDC_FORMAT_MACROS
  libmpathpersist: cleanup mpathpr.h

 libmpathpersist/Makefile                |   2 +-
 libmpathpersist/libmpathpersist.version |  27 +-
 libmpathpersist/mpath_persist.c         | 776 +----------------------
 libmpathpersist/mpath_persist_int.c     | 792 ++++++++++++++++++++++++
 libmpathpersist/mpath_persist_int.h     |  25 +
 libmpathpersist/mpath_pr_ioctl.c        |   3 +-
 libmpathpersist/mpathpr.h               |  49 +-
 mpathpersist/main.c                     |   1 +
 multipathd/main.c                       |   5 +-
 multipathd/main.h                       |  15 +-
 10 files changed, 848 insertions(+), 847 deletions(-)
 create mode 100644 libmpathpersist/mpath_persist_int.c
 create mode 100644 libmpathpersist/mpath_persist_int.h

-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

