Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12873C43467
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6B94C2084C
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B94C2084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-h_xhBKfONFu3n01AeOKyag-1; Fri, 16 Oct 2020 06:45:23 -0400
X-MC-Unique: h_xhBKfONFu3n01AeOKyag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39BBC9CC0F;
	Fri, 16 Oct 2020 10:45:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B52910016DA;
	Fri, 16 Oct 2020 10:45:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E43D61826D37;
	Fri, 16 Oct 2020 10:45:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAjHOI020652 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:45:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E52BB16C2DD; Fri, 16 Oct 2020 10:45:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DFD8D16C2DE
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B93EE805AB6
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:16 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-70-tpRAjqCpMFiNSpYEjxA_0Q-1;
	Fri, 16 Oct 2020 06:45:11 -0400
X-MC-Unique: tpRAjqCpMFiNSpYEjxA_0Q-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 1FE10AB5C;
	Fri, 16 Oct 2020 10:45:10 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:44:32 +0200
Message-Id: <20201016104501.8700-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAjHOI020652
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 00/29] libmultipath: improve cleanup on exit
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Hi Christophe, hi Ben, hi lixiaokeng,

this series was inspired by lixiaokeng's recent posting "[QUESTION] memory
leak in main (multipath)". It implements my first idea, registering
cleanup handlers with atexit(). However it turned out to be quite
complex. In particular multipathd has a lot of things to clean up.

This series is based on the previous series "multipath-tools: shutdown, 
libdevmapper races, globals" (v3).

While the bulk of the series is the cleanup handling, it also contains
some bug fixes for issues that I found while working on this.

Changes v1 -> v2:

Patches 24..29 have been added; they are logging cleanups, 24/29
and 29/29 are fixes to issues Ben had mentioned during his review.

01/29 "multipathd: uxlsnr: avoid deadlock on exit"
      Fix invalid array element reference (Ben)
07/29 "multipathd: move conf destruction into separate function"
      Don't reset logink when the log thread is stopped (Ben)
      Logging via logsink after shutting down the log thread is racy
      (no worse than before); the race will be fixed in 29/29.
14/29 "libmultipath: add libmp_dm_exit()": Fixed the skip_libmp_dm_init()
      case (Ben).
18/29 "libmultipath: fix log_thread startup and teardown"
      No need to wait before joining the log thread in log_thread_stop() (Ben)
      -> "libmultipath: fix race between log_safe and log_thread_stop()"
23/29: "multipath-tools: mpath-tools.supp: file with valgrind suppressions"
       Remove empty line at end of file (Ben)
24/29 "libmultipath: use libmp_verbosity to track verbosity"
       This fixes 13/21 "libmultipath: provide defaults for {get,put}_multipath_config"
       (from the previous patch series "multipath-tools: shutdown, libdevmapper races, globals";
       control of verbosity during config file loading)
29/29 "libmultipath: fix race between log_safe and log_thread_stop()"
      (see 18/29)

Regards
Martin

Martin Wilck (29):
  multipathd: uxlsnr: avoid deadlock on exit
  multipathd: Fix liburcu memory leak
  multipathd: move handling of io_err_stat_attr into libmultipath
  multipathd: move vecs desctruction into cleanup function
  multipathd: make some globals static
  multipathd: move threads destruction into separate function
  multipathd: move conf destruction into separate function
  multipathd: move pid destruction into separate function
  multipathd: close pidfile on exit
  multipathd: add helper for systemd notification at exit
  multipathd: child(): call cleanups in failure case, too
  multipathd: unwatch_all_dmevents: check if waiter is initialized
  multipathd: print error message if config can't be loaded
  libmultipath: add libmp_dm_exit()
  multipathd: fixup libdm deinitialization
  libmultipath: log_thread_stop(): check if logarea is initialized
  multipathd: add cleanup_child() exit handler
  libmultipath: fix log_thread startup and teardown
  multipathd: move cleanup_{prio,checkers,foreign} to libmultipath_exit
  multipath: use atexit() for cleanup handlers
  mpathpersist: use atexit() for cleanup handlers
  multipath: fix leaks in check_path_valid()
  multipath-tools: mpath-tools.supp: file with valgrind suppressions
  libmultipath: use libmp_verbosity to track verbosity
  libmultipath: introduce symbolic values for logsink
  libmultipath: simplify dlog()
  multipathd: common code for "-k" and command args
  multipathd: sanitize uxsock_listen()
  libmultipath: fix race between log_safe and log_thread_stop()

 libmpathpersist/mpath_persist.c       |   7 +-
 libmultipath/config.c                 |  14 +-
 libmultipath/config.h                 |   2 +
 libmultipath/debug.c                  |  38 +--
 libmultipath/debug.h                  |  27 +-
 libmultipath/devmapper.c              |  23 +-
 libmultipath/devmapper.h              |   1 +
 libmultipath/io_err_stat.c            |   7 +-
 libmultipath/libmultipath.version     |  31 +-
 libmultipath/log_pthread.c            | 114 +++++---
 mpathpersist/main.c                   |   5 +-
 multipath/main.c                      | 119 ++++----
 multipathd/dmevents.c                 |   2 +
 multipathd/main.c                     | 396 ++++++++++++++++----------
 multipathd/uxlsnr.c                   |  80 ++++--
 tests/alias.c                         |   1 +
 tests/blacklist.c                     |   2 +
 tests/globals.c                       |   3 +-
 tests/hwtable.c                       |   2 +-
 tests/test-log.c                      |   4 +-
 tests/test-log.h                      |   3 +-
 third-party/valgrind/mpath-tools.supp |  32 +++
 22 files changed, 585 insertions(+), 328 deletions(-)
 create mode 100644 third-party/valgrind/mpath-tools.supp

-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

