Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F888C433E7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 61FE3207F7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61FE3207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-IjpGX4qBNa2_vJPWsPywcA-1; Fri, 16 Oct 2020 06:44:09 -0400
X-MC-Unique: IjpGX4qBNa2_vJPWsPywcA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0EA9803F46;
	Fri, 16 Oct 2020 10:43:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D69A476673;
	Fri, 16 Oct 2020 10:43:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ADA8758116;
	Fri, 16 Oct 2020 10:43:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAhq4H020157 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:43:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D707816C2DA; Fri, 16 Oct 2020 10:43:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D07DA16C2DD
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE92F182360B
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:50 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-133-QOkJc8XWP22Vm3vVVb-lng-1;
	Fri, 16 Oct 2020 06:43:46 -0400
X-MC-Unique: QOkJc8XWP22Vm3vVVb-lng-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 7F7E5AB5C;
	Fri, 16 Oct 2020 10:43:44 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:43:08 +0200
Message-Id: <20201016104329.8337-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAhq4H020157
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 00/21] multipath-tools: shutdown,
	libdevmapper races, globals
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

this series contains a number of patches I've wanted to do for some
time. It's based on my "upstream-queue" tree
(https://github.com/openSUSE/multipath-tools/tree/upstream-queue),
plus my previously submitted "multipath-tools:add linker version scripts"
(v2) series. The reason is that this series contains a number of ABI
changes, and is thus suitable for demonstrating how to work with
the libmultipath linker version scripts.

Patch 1-8 are related to multipathd shutdown and systemd notifcation.
Patch 1 and 8 have been part of my earlier series "multipath-tools: 
Fix remaining shutdown delay issues" from Jan, 2019. But this is so
long ago that I didn't mark this as a v2. I have tried to address
Ben's issues with #1 (size_mismatch_seen leak, and premature sd_notify)
(https://www.redhat.com/archives/dm-devel/2019-January/msg00097.html).
#8 is just resent, after the recent discussion
(https://www.redhat.com/archives/dm-devel/2020-August/msg00342.html).
Ben's remark about sd_notify() drove me to reexamine that feature,
and actually improve a little by informing systemd of shutdown and
reconfigure operations.

Patch 9-11 are an attempt to fix races in libdevmapper, as discussed
a while ago in the "fix fd leak when iscsi device logs in" thread
(https://www.redhat.com/archives/dm-devel/2020-July/msg00321.html and
references).

Patch 12ff. add definitions of the symbol get_multipath_config(),
put_multipath_config(), udev, and logsink to libmultipath. This way
callers won't have to bother with defining these global symbols any
more in the future (but they still can).

Changes v1 -> v2:

 - rebased on "version script" series. Some patches which modify the
   ABI (10, 11, 13, 14, 17) have the respective hunks added.
 - 10/21: Added fix for the hwtable unit test. added comments.
   avoid logging a version that couldn't be determined.
 - 11/21: renamed libmp_task_run -> libmp_dm_task_run
 - 13/21: get_multipath_config(): return NULL if not initialized
   zero out configuration in _uninit_config() (Ben)
 - 17/21: Changed initialization as discussed with Ben. Added documentation
   in config.h.
 - 19/21: This one is new, as suggested by Ben
 - 20/21: This was 19 before, simplified now as the real changes are
   in libmpathpersist.
 - 21/21: New, also remove the globals in multipathd.

Changes v2 -> v3:

 - 10/21 "libmultipath: devmapper: refactor libdm version determination"
       fixed commit message, as suggested by Ben
 - 11/21 "libmultipath: protect racy libdevmapper calls with a mutex"
       add fix for dmevent unit test (Ben)
 - 13/21 "libmultipath: provide defaults for {get,put}_multipath_config"
       Ben noted that applications can't control the log level while loading
       the multipath configuration. This will be fixed in additional patches
       which have been added to the follow-up series.
 - 17/21 "libmultipath: add udev and logsink symbols":
       removed _libmultipath_init() again, as suggested by Ben.

Regards
Martin

Martin Wilck (21):
  multipathd: allow shutdown during configure()
  multipathd: avoid sending "READY=1" to systemd on early shutdown
  multipathd: send "STOPPING=1" to systemd on shutdown
  multipathd: send "RELOADING=1" to systemd on DAEMON_CONFIGURE state
  multipathd: use volatile qualifier for running_state
  multipathd: generalize and fix wait_for_state_change_if()
  multipathd: set_config_state(): avoid code duplication
  multipathd: cancel threads early during shutdown
  multipath-tools: don't call dm_lib_release() any more
  libmultipath: devmapper: refactor libdm version determination
  libmultipath: protect racy libdevmapper calls with a mutex
  libmultipath: constify file argument in config parser
  libmultipath: provide defaults for {get,put}_multipath_config
  libmpathpersist: allow using libmultipath {get,put}_multipath_config
  multipath: use {get_put}_multipath_config from libmultipath
  mpathpersist: use {get,put}_multipath_config() from libmultipath
  libmultipath: add udev and logsink symbols
  multipath: remove logsink and udev
  libmpathpersist: call libmultipath_{init,exit}()
  mpathpersist: remove logsink and udev
  multipathd: remove logsink and udev

 kpartx/kpartx.c                         |   1 -
 libmpathpersist/libmpathpersist.version |   6 +
 libmpathpersist/mpath_persist.c         |  50 ++++-
 libmpathpersist/mpath_persist.h         |  31 ++++
 libmultipath/config.c                   | 119 ++++++++++--
 libmultipath/config.h                   |  70 ++++++-
 libmultipath/configure.c                |   6 +
 libmultipath/debug.c                    |   2 +
 libmultipath/devmapper.c                | 233 ++++++++++++++++--------
 libmultipath/devmapper.h                |  13 +-
 libmultipath/discovery.c                |   3 +
 libmultipath/libmultipath.version       |  29 ++-
 libmultipath/parser.c                   |   9 +-
 libmultipath/parser.h                   |   2 +-
 libmultipath/propsel.c                  |  10 +-
 libmultipath/util.c                     |  10 +
 libmultipath/util.h                     |   2 +
 mpathpersist/main.c                     |  22 +--
 multipath/main.c                        |  28 +--
 multipathd/cli_handlers.c               |   2 -
 multipathd/dmevents.c                   |   4 +-
 multipathd/main.c                       | 126 ++++++-------
 multipathd/waiter.c                     |   2 +-
 tests/Makefile                          |   3 +-
 tests/dmevents.c                        |  12 ++
 tests/hwtable.c                         |   3 -
 tests/test-lib.c                        |  13 ++
 27 files changed, 579 insertions(+), 232 deletions(-)

-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

