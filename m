Return-Path: <SRS0=NZHG=FV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E35C4361B
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:01:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 00D8E2389E
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:01:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00D8E2389E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-t4H5YOb7OuSakjBv-gt4mA-1; Thu, 17 Dec 2020 06:01:06 -0500
X-MC-Unique: t4H5YOb7OuSakjBv-gt4mA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33B00107ACF9;
	Thu, 17 Dec 2020 11:01:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 13C5771D52;
	Thu, 17 Dec 2020 11:01:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ACC501809CA1;
	Thu, 17 Dec 2020 11:01:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BHB0dVm030235 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Dec 2020 06:00:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B0D74D7E12; Thu, 17 Dec 2020 11:00:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A5E93D7E0C
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 11:00:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CB5D805B05
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 11:00:36 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-228-BjTUgmpRNVKlfWXWubtebw-1;
	Thu, 17 Dec 2020 06:00:34 -0500
X-MC-Unique: BjTUgmpRNVKlfWXWubtebw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id B345EAC7B;
	Thu, 17 Dec 2020 11:00:32 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 17 Dec 2020 12:00:11 +0100
Message-Id: <20201217110018.3347-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BHB0dVm030235
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 0/7] Various multipath-tools patches
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Hi Christophe, hi Ben,

here are a few patches that have accumulated while I hadn't
fixed my previous series "libmultipath: improve cleanup on exit"

The first two are actually related to the log_thread work I did
in that series, but they're additional fixes on top and I didn't
want to delay that series further by adding additional, possibly
controversial stuff.

No 3 is the 2nd attempt to allow unloading of checker DSOs, hopefully
fixing the issues Ben saw with the first one.

No 4 is probably the most important one. It fixes the same issue
that 2b25a9e and cb10d38 targeted, but the previous fixes still
didn't cover all corner cases. This one does, I believe.

No 5 tackles a new failure mode we recently discovered - multipathd
may block trying to access the root FS while this is in queuing mode.
This patch removes one very frequent access pattern.
This is work in progress; there are other file system accesses
from multipathd which might block.

Obviously the wwids, prkeys, and bindings files' contents 
need to be cached. I haven't made up my mind how to handle writing
changes back. Would be sufficient to write back when multipathd exits,
possibly with an external program (e.g. "ExecStartPost")? Or should
we try to write back directly at runtime, using separate threads to
avoid blocking of the main thread? "reconfigure" is another issue,
but perhaps less problematic - if the root FS is blocked, users
couldn't edit /etc/multipath.conf anyway. One might consider moving
everything to tmpfs or even running in a tmpfs-backed chroot, but
it still would beg the question how to make certain changes permanent,
like wwids and bindings.

6 and 7 fix oversights in my library versioning series. The
plugins didn't have symbol versions set on the symbols they referenced,
making the versioning at least partly non-functional.

Regards
Martin

Martin Wilck (7):
  libmultipath: move logq_lock handling to log.c
  libmultipath: protect logarea with logq_lock
  libmultipath: prevent DSO unloading with astray checker threads
  libmultipath: force map reload if udev incomplete
  multipath-tools: avoid access to /etc/localtime
  multipath-tools: make sure plugin DSOs use symbol versions
  libmultipath.version: add missing symbol

 Makefile                           |  1 +
 Makefile.inc                       |  2 +-
 libmpathpersist/Makefile           |  8 ++--
 libmultipath/checkers.c            | 68 +++++++++++++++++++++++++++---
 libmultipath/checkers.h            | 25 +++++++++++
 libmultipath/checkers/Makefile     |  7 ++-
 libmultipath/checkers/tur.c        | 12 +++---
 libmultipath/configure.c           | 45 +++++++++++++-------
 libmultipath/debug.c               | 14 +++---
 libmultipath/devmapper.c           | 12 +++---
 libmultipath/foreign/Makefile      |  4 +-
 libmultipath/libmultipath.version  | 10 +++++
 libmultipath/log.c                 | 59 ++++++++++++++++++++++----
 libmultipath/log.h                 |  1 -
 libmultipath/log_pthread.c         |  9 ----
 libmultipath/prioritizers/Makefile |  7 ++-
 multipathd/main.c                  |  3 --
 17 files changed, 211 insertions(+), 76 deletions(-)

-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

