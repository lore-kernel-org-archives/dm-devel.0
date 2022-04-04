Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E62BC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  4 Apr 2022 17:05:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-wppX4ySpPmmxTpgAu9vxlg-1; Mon, 04 Apr 2022 13:05:40 -0400
X-MC-Unique: wppX4ySpPmmxTpgAu9vxlg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42C95811E7A;
	Mon,  4 Apr 2022 17:05:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ADE4EC27DBE;
	Mon,  4 Apr 2022 17:05:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 200081940366;
	Mon,  4 Apr 2022 17:05:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F00151940366
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Apr 2022 17:05:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8FE3F1454547; Mon,  4 Apr 2022 17:05:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C5591454535
 for <dm-devel@redhat.com>; Mon,  4 Apr 2022 17:05:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7548A1C05EBD
 for <dm-devel@redhat.com>; Mon,  4 Apr 2022 17:05:33 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-yZ1xQ5VRPeyCznlBZJvHSA-1; Mon, 04 Apr 2022 13:05:29 -0400
X-MC-Unique: yZ1xQ5VRPeyCznlBZJvHSA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 86EDD1F37E;
 Mon,  4 Apr 2022 17:05:28 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4CA0012FC5;
 Mon,  4 Apr 2022 17:05:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id deqEEFglS2LICAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 04 Apr 2022 17:05:28 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon,  4 Apr 2022 19:04:42 +0200
Message-Id: <20220404170457.16021-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v2 00/15] Rework uevent filtering and merging
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============6753176059458155296=="

--===============6753176059458155296==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

Hi Ben, hi Christophe,

the bulk of this patch set (3-7) is a rework of the uevent filtering and
merging logic introduced in commit ee8888f ("multipath-tools: improve=20
processing efficiency for addition and deletion of multipath devices"),
by Tang Junhui.

The rationale is explained in detail in the commit message in patch 08/14.
TL;DR: The previous approach delayed uevent handling, possibly a lot, which
is often undesirable. The new logic passes events to the dispatcher
immediately, but if they queue up (because the dispatcher can't keep
up with the rate at which events arrive, or is blocked e.g. by the
path checker), the dispatcher will apply filtering and merging
between servicing individual events. This worked well in my own testing,
but I'd appreciate if ZTE could give it a shot in their special test
environment. Unfortunately, Tang Junhui isn't reachable at ZTE any more.

Patch 8-13 add some more improvements to the uevent handling code, and
improve logging. The first 2 patches are unrelated fixes.

Changes v1->v2:

 04: merged patch 04 and 05 of v1 series into 04. Numbering changes accordi=
ngly.
     (Benjamin Marzinski)
 04: added function for uevent node deletion in simple cases (no tail delet=
ion,
     no merge_node) (Benjamin Marzinski)
 05 (was 06 in v1): avoid memory leak
 14: new, found by coverity when testing the patched code.
 15: new, from discussion about 05 (Benjamin Marzinski)

Martin Wilck (15):
  multipathd: allow adding git rev as version suffix
  multipathd: don't switch to DAEMON_IDLE during startup
  uevent_dispatch(): use while in wait loop
  libmultipath: uevent_dispatch(): process uevents one by one
  multipathd: reconfigure: disallow changing uid_attrs
  libmultipath: microoptimize uevent filtering and merging
  libmultipath: uevent_listen(): don't delay uevents
  libmultipath: uevent: use struct to pass parameters around
  libmultipath: uevent: log statistics about filtering and merging
  libmultipath: merge_uevq(): filter first, then merge
  libmultipath: uevent_filter(): filter previously merged events
  libmultipath: uevent: improve log messages
  libmultipath: uevent: add debug messages for event queue
  libmultipath: apply_format(): prevent buffer overflow
  libmultipath: avoid memory leak with uid_attrs

 Makefile.inc               |   3 +-
 libmultipath/callout.c     |   2 +-
 libmultipath/config.c      |  11 +-
 libmultipath/config.h      |   4 +-
 libmultipath/dict.c        |   5 +
 libmultipath/discovery.c   |   2 +-
 libmultipath/list.h        |  53 +++++
 libmultipath/structs.h     |   2 +-
 libmultipath/uevent.c      | 422 ++++++++++++++++++++++---------------
 libmultipath/uevent.h      |   3 +-
 multipath/multipath.conf.5 |   2 +
 multipathd/main.c          |  65 ++++--
 tests/uevent.c             |   2 +-
 13 files changed, 386 insertions(+), 190 deletions(-)

--=20
2.35.1


--===============6753176059458155296==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============6753176059458155296==--

