Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93738C32774
	for <dm-devel@archiver.kernel.org>; Mon, 22 Aug 2022 20:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661200921;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yjZoyU/UboZf2K4+lYeYvLsBVRaFg/hTnZRCWZqQJmk=;
	b=ZW7TjId0dB4QPw17C+f2DPJhCUMMrVEC31Fwb4Kk2eTUonz/ggXL2+Lq8e7GL3XKxmdvxh
	pXSFW5FiNdBbhGVyxMqlanPYWfCAp2Ql1iUWu7TPStiRI7VVmpQ/PAw0rDiOLkUCSTMONM
	Yh0ucwvk/pCNf5SyBjr1WhButhqfsaw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-gA5aGUTGM2m0fYbVBscmFA-1; Mon, 22 Aug 2022 16:41:58 -0400
X-MC-Unique: gA5aGUTGM2m0fYbVBscmFA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABA16823F8F;
	Mon, 22 Aug 2022 20:41:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6371A40CFD0A;
	Mon, 22 Aug 2022 20:41:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8BE9C1946A60;
	Mon, 22 Aug 2022 20:41:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 52C201946A40
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 Aug 2022 20:41:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2882540C141D; Mon, 22 Aug 2022 20:41:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 24B554010D45
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 20:41:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D0F0101A58D
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 20:41:52 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-533-VQUdghfHP5e5iYlQqh1vvg-1; Mon,
 22 Aug 2022 16:41:50 -0400
X-MC-Unique: VQUdghfHP5e5iYlQqh1vvg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 6CD34202B8;
 Mon, 22 Aug 2022 20:41:48 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2D36A13523;
 Mon, 22 Aug 2022 20:41:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id fs5bCQzqA2MOAwAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 22 Aug 2022 20:41:48 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 22 Aug 2022 22:41:08 +0200
Message-Id: <20220822204119.20719-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH v2 00/11] Split libmultipath and libmpathutil
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Martin Wilck <mwilck@suse.com>
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
of the code that uses libreadline functionality, and links to libmpathutil
only. With patch 10, in interactive mode, "multipathd -k" just exec()s t
his new program.

This split makes it rather obvious that the part of the multipath-tools
code that depended on libreadline is small. It is still possible to
control whether a readline library is used at all. This is done with the
READLINE make variable, which can be empty (in which case no readline
library is needed), or have the value "libreadline", or "libedit".

Patch 11 is a minor fix for older versions of libreadline.

Changes v1(RFC) -> v2:
 - added patches 03 and 11. Numbering changes accordingly
 - added SPDX header to multipathc.c
 - fix some compilation errors

Hannes Reinecke (1):
  multipathd: replace libreadline with getline()

Martin Wilck (10):
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

 .gitignore                                   |   3 +
 Makefile                                     |   8 +-
 Makefile.inc                                 |   5 +-
 libmpathpersist/Makefile                     |   6 +-
 libmpathutil/Makefile                        |  70 +++++
 {libmultipath => libmpathutil}/debug.c       |   0
 {libmultipath => libmpathutil}/debug.h       |   0
 libmpathutil/globals.c                       |  12 +
 libmpathutil/globals.h                       |  39 +++
 libmpathutil/libmpathutil.version            | 122 +++++++++
 {libmultipath => libmpathutil}/log.c         |   0
 {libmultipath => libmpathutil}/log.h         |   0
 {libmultipath => libmpathutil}/log_pthread.c |   0
 {libmultipath => libmpathutil}/log_pthread.h |   0
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
 multipathd/main.c                            |  15 +-
 multipathd/multipathc.c                      | 271 +++++++++++++++++++
 multipathd/uxclnt.c                          | 108 +-------
 tests/Makefile                               |   8 +-
 50 files changed, 687 insertions(+), 389 deletions(-)
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

