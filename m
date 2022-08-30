Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A54DDECAAA1
	for <dm-devel@archiver.kernel.org>; Tue, 30 Aug 2022 19:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661887708;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=G5AKVXvVZvtGHlFBYhHHUZkJB8VtLyDAvVri4HPGMKI=;
	b=Xq59y4l4d1h8nU8YNV9aZUgJNoxXDR/CNsUG5yAqxtijoMCBIp3//+/BG4eJKPxrg/Jhgw
	gz+Vfs6GaCh8tpFZXCdWuzBUCuBQPAAAudDMsrO7AK8q6yYJfR0bViAblOAlpEQwv7b5Qu
	TA1MJCvEcDGWZhkWac93v2SL5108+hQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-38oP8sAGO92lj2fWWqh13A-1; Tue, 30 Aug 2022 15:28:25 -0400
X-MC-Unique: 38oP8sAGO92lj2fWWqh13A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E26E285A59C;
	Tue, 30 Aug 2022 19:28:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C634740E7F2B;
	Tue, 30 Aug 2022 19:28:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B0C241946A42;
	Tue, 30 Aug 2022 19:28:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 817EC1946A57
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 Aug 2022 19:28:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 762B3401473; Tue, 30 Aug 2022 19:28:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 727B4492C3B
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 19:28:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15A0629AB3FF
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 19:28:17 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-639-uGwB4OadPx-SsNixXIbDNg-1; Tue,
 30 Aug 2022 15:28:12 -0400
X-MC-Unique: uGwB4OadPx-SsNixXIbDNg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id EBD2521E7A;
 Tue, 30 Aug 2022 19:28:09 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A4EFA13B0C;
 Tue, 30 Aug 2022 19:28:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id wPkQJslkDmO5GgAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 30 Aug 2022 19:28:09 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 30 Aug 2022 21:27:01 +0200
Message-Id: <20220830192713.19778-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH v4 00/12] Split libmultipath and libmpathutil
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Following the recent discussions about the licensing conflict
between parts of libmultipath and libreadline, here comes
another series for cleaning up the situation further.

Patch 1 is a modified version of https://github.com/opensvc/multipath-tools/pull/41.
Patch 2-7 are minor cleanups in preparation of the library split.

In patch8, a part of libmultipath is split off into a new library, libmpathutil.
This new library contains no GPL-2.0-only code, and is thus shipped
under GPL-2.0-or-later license, which is compatible with libreadline.
The bulk of the multipath-specific code, including the GPL-2.0-only
files, remains in libmultipath, which is thus still shipped under
a GPL-2.0-only license.

A new command "multipathc" is created in patch 9 that is now the only part
of the code that uses libreadline functionality. This program links to
libmpathutil only. With patch 10, in interactive mode, "multipathd -k"
just exec()s this new program.

This split makes it rather obvious that the part of the multipath-tools
code that depended on libreadline is small. It is still possible to
control whether a readline library is used at all. This is done with the
READLINE make variable, which can be empty (in which case no readline
library is needed), or have the value "libreadline", or "libedit".

Patch 11 is a minor fix for older versions of libreadline.

Changes v3 -> v4 (suggested by Ben Marzinski, unless noted otherwise):
 - 01/11: don't drop add_history() call if readline library is in use
 - 01/11: remove key_generator from cli.h if unused
 - 09/11: fix a defect detected by coverity
 - 10/11: better error messages, and error out on negative timeout value
 - 12/11: added, found by coverity

Changes v2->v3:
  fix compilation errors on Alpine an CI errors.

Changes v1(RFC) -> v2:
 - added patches 03 and 11. Numbering changes accordingly
 - added SPDX header to multipathc.c
 - fix some compilation errors

Hannes Reinecke (1):
  multipathd: replace libreadline with getline()

Martin Wilck (11):
  .gitignore: ignore generated ABI files
  libmultipath: move all reservation key functions to prkey.c
  libmultipath: always set _GNU_SOURCE
  multipath-tools: Makefile: fix dependencies for "install" target
  libmultipath checkers/prioritizers: search for includes in
    libmultipath
  libmultipath: remove weak attribute for {get,put}_multipath_config
  libmultipath: split off libmpathutil
  multipathc: add new interactive client program
  multipathd: exec multipathc in interactive mode
  multipathd: fix incompatible pointer type error with libedit
  multipathd: fix use-after-free in handle_path_wwid_change()

 .gitignore                                   |   3 +
 Makefile                                     |   8 +-
 Makefile.inc                                 |   5 +-
 libmpathpersist/Makefile                     |   6 +-
 libmpathutil/Makefile                        |  70 +++++
 {libmultipath => libmpathutil}/debug.c       |   0
 {libmultipath => libmpathutil}/debug.h       |   0
 libmpathutil/globals.c                       |  12 +
 libmpathutil/globals.h                       |  39 +++
 libmpathutil/libmpathutil.version            | 123 +++++++++
 {libmultipath => libmpathutil}/log.c         |   0
 {libmultipath => libmpathutil}/log.h         |   0
 {libmultipath => libmpathutil}/log_pthread.c |   0
 {libmultipath => libmpathutil}/log_pthread.h |   0
 {libmultipath => libmpathutil}/msort.c       |   0
 {libmultipath => libmpathutil}/msort.h       |   0
 {libmultipath => libmpathutil}/parser.c      |   0
 {libmultipath => libmpathutil}/parser.h      |   2 +-
 {libmultipath => libmpathutil}/strbuf.c      |   0
 {libmultipath => libmpathutil}/strbuf.h      |   0
 {libmultipath => libmpathutil}/time-util.c   |   0
 {libmultipath => libmpathutil}/time-util.h   |   0
 {libmultipath => libmpathutil}/util.c        |  32 ---
 {libmultipath => libmpathutil}/util.h        |   2 -
 {libmultipath => libmpathutil}/uxsock.c      |   0
 {libmultipath => libmpathutil}/uxsock.h      |   0
 {libmultipath => libmpathutil}/vector.c      |   0
 {libmultipath => libmpathutil}/vector.h      |   0
 libmpathvalid/Makefile                       |   6 +-
 libmultipath/Makefile                        |  17 +-
 libmultipath/checkers/Makefile               |   7 +-
 libmultipath/checkers/directio.c             |   4 +-
 libmultipath/checkers/emc_clariion.c         |   2 +-
 libmultipath/checkers/hp_sw.c                |   4 +-
 libmultipath/checkers/rdac.c                 |   2 +-
 libmultipath/checkers/tur.c                  |   8 +-
 libmultipath/config.c                        |   4 +-
 libmultipath/config.h                        |  14 +-
 libmultipath/dict.c                          |  16 +-
 libmultipath/dict.h                          |   2 -
 libmultipath/foreign/Makefile                |   6 +-
 libmultipath/libmultipath.version            |  41 ---
 libmultipath/prioritizers/Makefile           |   8 +-
 libmultipath/prioritizers/alua_rtpg.c        |   2 +-
 libmultipath/prkey.c                         |  49 +++-
 libmultipath/prkey.h                         |   3 +
 mpathpersist/Makefile                        |   4 +-
 multipath/Makefile                           |   6 +-
 multipathd/Makefile                          |  43 ++-
 multipathd/cli.c                             | 128 +--------
 multipathd/cli.h                             |   5 +-
 multipathd/main.c                            |  20 +-
 multipathd/multipathc.c                      | 276 +++++++++++++++++++
 multipathd/uxclnt.c                          | 108 +-------
 tests/Makefile                               |  12 +-
 55 files changed, 703 insertions(+), 396 deletions(-)
 create mode 100644 libmpathutil/Makefile
 rename {libmultipath => libmpathutil}/debug.c (100%)
 rename {libmultipath => libmpathutil}/debug.h (100%)
 create mode 100644 libmpathutil/globals.c
 create mode 100644 libmpathutil/globals.h
 create mode 100644 libmpathutil/libmpathutil.version
 rename {libmultipath => libmpathutil}/log.c (100%)
 rename {libmultipath => libmpathutil}/log.h (100%)
 rename {libmultipath => libmpathutil}/log_pthread.c (100%)
 rename {libmultipath => libmpathutil}/log_pthread.h (100%)
 rename {libmultipath => libmpathutil}/msort.c (100%)
 rename {libmultipath => libmpathutil}/msort.h (100%)
 rename {libmultipath => libmpathutil}/parser.c (100%)
 rename {libmultipath => libmpathutil}/parser.h (99%)
 rename {libmultipath => libmpathutil}/strbuf.c (100%)
 rename {libmultipath => libmpathutil}/strbuf.h (100%)
 rename {libmultipath => libmpathutil}/time-util.c (100%)
 rename {libmultipath => libmpathutil}/time-util.h (100%)
 rename {libmultipath => libmpathutil}/util.c (92%)
 rename {libmultipath => libmpathutil}/util.h (96%)
 rename {libmultipath => libmpathutil}/uxsock.c (100%)
 rename {libmultipath => libmpathutil}/uxsock.h (100%)
 rename {libmultipath => libmpathutil}/vector.c (100%)
 rename {libmultipath => libmpathutil}/vector.h (100%)
 create mode 100644 multipathd/multipathc.c

-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

