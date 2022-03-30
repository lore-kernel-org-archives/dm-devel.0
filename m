Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 773D3C43217
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 22:15:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-_D6JhVPKMxaNfPkzWhrf_A-1; Wed, 30 Mar 2022 18:15:35 -0400
X-MC-Unique: _D6JhVPKMxaNfPkzWhrf_A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 905871C07844;
	Wed, 30 Mar 2022 22:15:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2A3BF1400B1C;
	Wed, 30 Mar 2022 22:15:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B930619451F3;
	Wed, 30 Mar 2022 22:15:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1E58319466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 22:15:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DA6E040CF8F8; Wed, 30 Mar 2022 22:15:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D63BE40CF8E4
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD795811E75
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:26 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-yTMzUY42NvmGOkIxuW63uA-1; Wed, 30 Mar 2022 18:15:25 -0400
X-MC-Unique: yTMzUY42NvmGOkIxuW63uA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 988A9210E3;
 Wed, 30 Mar 2022 22:15:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4C96A13AF3;
 Wed, 30 Mar 2022 22:15:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 62ufEHvWRGL8JgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 30 Mar 2022 22:15:23 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 31 Mar 2022 00:14:56 +0200
Message-Id: <20220330221510.22578-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH 00/14] Rework uevent filtering and merging
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, tang.junhui@zte.com.cn
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============2119261226117719653=="

--===============2119261226117719653==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

Hi Ben, hi Christophe, hi Tang Junhui,

the bulk of this patch set (3-8) is a rework of the uevent filtering and
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
environment.

Patch 9-14 add some more improvements to the uevent handling code, and
improve logging. The first 2 patches are unrelated fixes.

Comments welcome,

Martin

Martin Wilck (14):
  multipathd: allow adding git rev as version suffix
  multipathd: don't switch to DAEMON_IDLE during startup
  uevent_dispatch(): use while in wait loop
  libmultipath: uevent_dispatch(): process uevents one by one
  libmultipath: uevent_dispatch(): only filter/merge new uevents
  multipathd: reconfigure: disallow changing uid_attrs
  libmultipath: microoptimize uevent filtering and merging
  libmultipath: uevent_listen(): don't delay uevents
  libmultipath: uevent: use struct to pass parameters around
  libmultipath: uevent: log statistics about filtering and merging
  libmultipath: merge_uevq(): filter first, then merge
  libmultipath: uevent_filter(): filter previously merged events
  libmultipath: uevent: improve log messages
  libmultipath: uevent: add debug messages for event queue

 Makefile.inc               |   3 +-
 libmultipath/config.c      |   6 +-
 libmultipath/config.h      |   4 +-
 libmultipath/discovery.c   |   2 +-
 libmultipath/list.h        |  53 +++++
 libmultipath/structs.h     |   2 +-
 libmultipath/uevent.c      | 407 ++++++++++++++++++++++---------------
 libmultipath/uevent.h      |   3 +-
 multipath/multipath.conf.5 |   2 +
 multipathd/main.c          |  59 ++++--
 tests/uevent.c             |   2 +-
 11 files changed, 354 insertions(+), 189 deletions(-)

--=20
2.35.1


--===============2119261226117719653==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============2119261226117719653==--

