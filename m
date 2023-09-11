Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B61ABEEB57E
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450369;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=//vyh9JedWJ1IdQeALqWIHqE7vC/3EraHL6wUf59+wo=;
	b=JQSRa3XwAggC4ULmUTW+jDIcrF9KvIHSQaW8co1JiQ8tA0APhvcsPSKmiIy1tfJfmMwyv2
	WSrfQ6dzq7/4aDrTC4B0CKotJqaFfckmbFS+LPUyNlrAzN1TJV4yPIHAj5Vz6LD9KIB/4Z
	i/40a3h/InuUD5AjKkYFcrKPsfUzqKE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-v2pXlZDvMUi54ubs7nnXXg-1; Mon, 11 Sep 2023 12:39:25 -0400
X-MC-Unique: v2pXlZDvMUi54ubs7nnXXg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D960C1C05EA6;
	Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 86C934402E;
	Mon, 11 Sep 2023 16:39:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 311F119465A2;
	Mon, 11 Sep 2023 16:39:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5D5ED1946597
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EFF1740C2009; Mon, 11 Sep 2023 16:39:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E85EF40C2064
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:17 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9A82945E63
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:17 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-225-TrFbKOq4PVWHdT20bRQbwg-1; Mon,
 11 Sep 2023 12:39:15 -0400
X-MC-Unique: TrFbKOq4PVWHdT20bRQbwg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 8B00521847;
 Mon, 11 Sep 2023 16:39:14 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5574C139CC;
 Mon, 11 Sep 2023 16:39:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 1x8aE7JC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:14 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:09 +0200
Message-ID: <20230911163846.27197-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v2 00/37] multipath-tools: user-friendly names
 rework
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This patch set contains a two-step rework of the user-friendly
names code. Patch 2-5 change the current code such that it (well, almost)
never attempts to use an alias that is currently in use by another
map. We already have some checks for this, but they don't cover all
possible scenarios. Patch 6-10 add some units tests for
get_user_friendly_alias(), and restructure the unit tests somewhat.

In the second part of the set, Patch 11-18 restructure the alias code such
that we don't read the bindings file every time an alias is
requested. Instead, we just use a memory cache of the current bindings, and
re-write the file only if a new binding is added.  This reduces the number of
system calls and simplifies the code.

Patch 19 applies the changes to the unit tests that become
necessary because of the previous patches. Patch 20/21 add another
optimization for the alias_already_taken() test.

Patch 22-23 introduce a solution for the problem discussed in the review
of v1 of this patch set, the partial ordering of aliases in memory.
By sorting first be string length, and then alphabetically, we obtain
a total "numeric" ordering for every given alias prefix. This ordering
allows simplifying the search for "gaps" in the list of aliases, which
is done in patch 24-26.

As discussed in the opening letter of the v1 patch series, the patch
series has the effect that the bindings file is not re-read every time
a new binding is attempted. Patch 28 and 29 introduce a notification
mechanism for multipathd which causes the bindings to be re-read
when the bindings file has been updated.

Patch 30-36 are a series of minor fixes for the build system and the
documentation. Most imporantly, the man pages will now show the correct
paths for various built-in defaults.

Finally, patch 37 (which is deliberately kept separate and at the end of the
series, in order to allow downstream integrators to skip it) eventually
deprecates the runtime configuration options for bindings_file, wwids_file,
and prkeys_file.

Patch 1 is a separate, independent fix.

NOTE: my main test bed is currently unavailable, therefore this set has
yet reveived less testing than usual. I have tested this to the extent
I currently can, but further testing will be highly appreciated.

Reviews and comments welcome.

# Changes wrt v1 - v2:

* Patch 03: skipped superfluous test for the case where a map already
  has an alias (Ben Marzinski)
* Patch 07: removed invalid tests for the case where the already assigned
  alias of a given map is assigned to a different wwid (Ben Marzinski)
* Patch 09/10: moved some macro-usage fixes from 10 to 09
* Patch 18:
  - skipped superfluous tests like in patch 03 (Ben Marzinski)
  - fix bug in get_user_friendly_wwid() (Ben Marzinski)
* Added patch 22 ff. (see above).

Martin Wilck (37):
  libmultipath: sysfs_set_scsi_tmo: do nothing for ACT_DRY_RUN
  libmultipath: add alias_already_taken()
  libmultipath: unify use_existing_alias() and get_user_friendly_alias()
  libmultipath: never allocate an alias that's already taken
  libmultipath: lookup_binding: add comment about the algorithm
  multipath-tools test: simplify debugging for condlog mismatch
  multipath-tools tests: add tests for get_user_friendly_alias()
  multipath-tools test: consistent use of macros in alias test
  multipath-tools tests: convert mock_{failed,used}_alias to macros
  multipath-tools test: use mock_bindings_file() consistently
  libmultipath: add global variable for current bindings
  libmultipath: rename fix_bindings_file() to update_bindings_file()
  libmultipath: alias.c: move bindings related code up
  libmultipath: update_bindings_file: take filename argument
  libmultipath: update_bindings_file: use a single write()
  libmultipath: update_bindings_file: don't log temp file name
  libmultipath: alias.c: factor out read_binding()
  libmultipath: keep bindings in memory
  multipath-tools tests: fix alias tests
  libmultipath: dm_get_uuid(): return emtpy UUID for non-existing maps
  libmultipath: adapt to new semantics of dm_get_uuid()
  libmultipath: sort aliases by length and strcmp
  multipath-tools tests: fix alias test after sort order change
  libmultipath: simplify get_free_id() assuming total ordering
  multipath-tools tests: adapt alias tests for total ordering
  multipath-tools tests: add test for ordering of bindings
  multipathd: watch bindings file with inotify + timestamp
  multipath-tools tests: mock pthread_mutex_{lock,unlock}
  multipath-tools Makefile: sanitize paths for configuration files
  multipath-tools: add compile time configuration for "/etc/multipath"
  multipath-tools man pages: generate with correct paths
  libdmmp/Makefile: fix bug in install section
  multipath-tools: README.md: improve documentation for compile-time
    options
  libmultipath: print built-in values for deprecated options
  multipath: add a missing newline
  multipath-tools: allow prefixes with and w/o trailing slash
  libmultipath: deprecate bindings_file, wwids_file, prkeys_file

 .gitignore                                    |    4 +
 Makefile.inc                                  |   43 +-
 README.md                                     |   38 +-
 libdmmp/Makefile                              |    2 +-
 libmultipath/alias.c                          | 1042 +++++++-----
 libmultipath/alias.h                          |   14 +-
 libmultipath/config.c                         |   18 -
 libmultipath/config.h                         |    3 -
 libmultipath/configure.c                      |    7 +-
 libmultipath/defaults.h                       |    7 +-
 libmultipath/devmapper.c                      |   10 +-
 libmultipath/dict.c                           |   55 +-
 libmultipath/discovery.c                      |    3 +
 libmultipath/libmultipath.version             |    4 +-
 libmultipath/prkey.c                          |    7 +-
 libmultipath/prkey.h                          |    7 +-
 libmultipath/propsel.c                        |   20 +-
 libmultipath/wwids.c                          |   18 +-
 mpathpersist/Makefile                         |    5 +-
 .../{mpathpersist.8 => mpathpersist.8.in}     |    2 +-
 multipath/Makefile                            |   13 +-
 multipath/main.c                              |    6 +-
 multipath/{multipath.8 => multipath.8.in}     |   10 +-
 .../{multipath.conf.5 => multipath.conf.5.in} |   44 +-
 multipathd/Makefile                           |    9 +-
 multipathd/main.c                             |    1 +
 multipathd/{multipathd.8 => multipathd.8.in}  |    8 +-
 multipathd/uxlsnr.c                           |   29 +-
 tests/Makefile                                |    1 +
 tests/alias.c                                 | 1491 +++++++++++++----
 tests/test-log.c                              |    4 +-
 31 files changed, 1961 insertions(+), 964 deletions(-)
 rename mpathpersist/{mpathpersist.8 => mpathpersist.8.in} (99%)
 rename multipath/{multipath.8 => multipath.8.in} (97%)
 rename multipath/{multipath.conf.5 => multipath.conf.5.in} (98%)
 rename multipathd/{multipathd.8 => multipathd.8.in} (97%)

-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

