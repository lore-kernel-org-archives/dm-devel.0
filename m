Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19349C433E7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:43:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5D72D207F7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:43:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D72D207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-Sf0NO2qPP52A-ojAk3CmJA-1; Fri, 16 Oct 2020 06:43:17 -0400
X-MC-Unique: Sf0NO2qPP52A-ojAk3CmJA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4616464150;
	Fri, 16 Oct 2020 10:43:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D56627667A;
	Fri, 16 Oct 2020 10:43:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2FE9C92F4F;
	Fri, 16 Oct 2020 10:43:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAhAJv019906 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:43:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 63D7011DBD59; Fri, 16 Oct 2020 10:43:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 604AF11CC237
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9774182360B
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:07 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-528-Z7jHvyN_N7WAbJUrUmHYyQ-1;
	Fri, 16 Oct 2020 06:43:05 -0400
X-MC-Unique: Z7jHvyN_N7WAbJUrUmHYyQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id C8D8BB2AA;
	Fri, 16 Oct 2020 10:43:03 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:42:27 +0200
Message-Id: <20201016104239.8217-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAhAJv019906
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 00/12] multipath-tools: add linker version
	scripts
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

Patch 1-5 are small fixes, the first two resent from an earlier
submission. Patch 6ff. add version scripts for the linker to
libmultipath, libmpathpersist, and libmpathcmd.
(new in v2: versions start at 1.0.0 for all 3 libraries).

Is it useful to do this for libmultipath? We have always said that this is
not a public, stable ABI. However, I still believe it has merits. First of
all, it's a description of the ABI we use. It turns out that it cuts the
size of the exported symbol list of libmultipath roughly in half, which is
better than I'd expected. It leads to ld.so-time failure rather than weird
crashes in the unlikely case that non-matching binaries are used
together. It allows packaging scripts to check compatibility of binaries
and libraries without resorting to version and release. It will help us
stabilize the ABI, albeit only in the long run. Finally, it's a step
towards modernizing our code base in general.

To avoid misunderstanding, my intention is not to provide a stable or even
backward-compatible ABI in libmultipath.so.0. We're still allowed to make
changes to globally visible data structures like "struct config", and to
remove symbols from the ABI, like no serious shared library would do.
We just need to bump the ABI version when we do so.

Changes v1->v2:

08/12: "libmultipath: create separate .so for unit tests"
       fix test_clean rule (Ben)
9/12-11/12: Changed library versions from 0.8.4 to 1.0.0 as discussed with Ben,
       kept Reviewed-by: trailer
12/12 "libmpathpersist: initialize mpp->hwe in get_mpvec()"
      Fix for the issue mentioned by Ben in his review for 02/12
      "libmultipath: copy mpp->hwe from pp->hwe"

Regards
Martin

Martin Wilck (12):
  libmultipath: find_mpe(): don't match with empty WWID
  libmultipath: copy mpp->hwe from pp->hwe
  libmultipath: dm_map_present_by_uuid(): fix dm_task_create() call
  libdmmp tests: fix compilation
  libmultipath: prio: constify some function parameters
  libmultipath: checkers/prio: allow non-lazy .so loading
  multipath-tools Makefiles: separate rules for .so and man pages
  libmultipath: create separate .so for unit tests
  libmultipath: add linker version script
  libmpathpersist: add linker version script
  libmpathcmd: add linker version script
  libmpathpersist: initialize mpp->hwe in get_mpvec()

 libdmmp/test/libdmmp_speed_test.c       |   2 +-
 libdmmp/test/libdmmp_test.c             |   2 +-
 libmpathcmd/Makefile                    |  14 +-
 libmpathcmd/libmpathcmd.version         |  25 +++
 libmpathpersist/Makefile                |  16 +-
 libmpathpersist/libmpathpersist.version |  32 +++
 libmpathpersist/mpath_persist.c         |   6 +-
 libmultipath/Makefile                   |  22 ++-
 libmultipath/checkers.c                 |  17 ++
 libmultipath/config.c                   |   2 +-
 libmultipath/configure.c                |   7 +
 libmultipath/devmapper.c                |   2 +-
 libmultipath/libmultipath.version       | 248 ++++++++++++++++++++++++
 libmultipath/prio.c                     |  26 ++-
 libmultipath/prio.h                     |   4 +-
 libmultipath/propsel.c                  |   4 +-
 libmultipath/structs.c                  |  15 ++
 libmultipath/structs.h                  |   1 +
 libmultipath/structs_vec.c              |  54 +++---
 multipathd/main.c                       |  10 -
 tests/Makefile                          |  10 +-
 21 files changed, 445 insertions(+), 74 deletions(-)
 create mode 100644 libmpathcmd/libmpathcmd.version
 create mode 100644 libmpathpersist/libmpathpersist.version
 create mode 100644 libmultipath/libmultipath.version

-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

