Return-Path: <SRS0=sRxI=IY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C218BC433DB
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 21:30:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 637F961A2B
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 21:30:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 637F961A2B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-oaIFnUttOkyy1YkibzX1-w-1; Fri, 26 Mar 2021 17:30:16 -0400
X-MC-Unique: oaIFnUttOkyy1YkibzX1-w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAB311034B5D;
	Fri, 26 Mar 2021 21:30:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 273D75D756;
	Fri, 26 Mar 2021 21:30:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E128C1809C84;
	Fri, 26 Mar 2021 21:30:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12QLU7Jl001660 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Mar 2021 17:30:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8045C117C2FB; Fri, 26 Mar 2021 21:30:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C3921054820
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 21:30:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87F1A80122D
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 21:30:03 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-319-N4VE2qJnPDqkAdY1hjxBRA-1;
	Fri, 26 Mar 2021 17:30:00 -0400
X-MC-Unique: N4VE2qJnPDqkAdY1hjxBRA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id BA9A1AD71;
	Fri, 26 Mar 2021 21:29:58 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 26 Mar 2021 22:29:37 +0100
Message-Id: <20210326212944.3136-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12QLU7Jl001660
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 0/7] multipath-tools: extended github CI
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Hi Christophe, hi Ben,

I've spent most of this week trying to improve the multipath-tools
CI workflows on github. I now have CI workflows for 7 different
distributions covering ~6 years of development, and 5 different
architectures, running routinely on Github. While I found only one
minor bug in multipath-tools in this process, I hope this will help
avoiding regressions on less frequently-tested distributions in the
future. Please read the commit message of the patch "github workflows: 
add containerized / multi-arch tests" for the details.

You can see this in action on https://github.com/openSUSE/multipath-tools/actions.
The patch set is included in the "tip" branch.

What we need now is more unit tests; our code coverage is still
pretty pathetic.

LOC-wise, the bulk of this patch set are libdmmp man pages. These are
almost 100% static. Including them in git allows us to get rid of perl
as a build-time requirement, which will allow me (in the future) to
reduce the size of the build container images significantly.

Regards
Martin

Martin Wilck (7):
  multipath-tools Makefiles: make pkg-config configurable
  multipath-tools Makefiles: allow building test programs only
  github workflows: add containerized / multi-arch tests
  libdmmp: allow building without perl
  multipath-tools Makefile: build before install
  fixup "multipath-tools tests: check if /sys/dev/block is non-empty"
  libmultipath: fix warning with clang 3.5

 .github/workflows/build-and-unittest.yaml     |  4 +-
 .github/workflows/foreign.yaml                | 65 +++++++++++++++++++
 .github/workflows/native.yaml                 | 31 +++++++++
 Makefile                                      |  9 ++-
 Makefile.inc                                  |  6 +-
 libdmmp/Makefile                              | 41 +++++-------
 libdmmp/docs/man/dmmp_context_free.3          | 15 +++++
 libdmmp/docs/man/dmmp_context_log_func_set.3  | 21 ++++++
 .../docs/man/dmmp_context_log_priority_get.3  | 23 +++++++
 .../docs/man/dmmp_context_log_priority_set.3  | 29 +++++++++
 libdmmp/docs/man/dmmp_context_new.3           | 19 ++++++
 libdmmp/docs/man/dmmp_context_timeout_get.3   | 15 +++++
 libdmmp/docs/man/dmmp_context_timeout_set.3   | 19 ++++++
 libdmmp/docs/man/dmmp_context_userdata_get.3  | 15 +++++
 libdmmp/docs/man/dmmp_context_userdata_set.3  | 18 +++++
 libdmmp/docs/man/dmmp_flush_mpath.3           | 36 ++++++++++
 libdmmp/docs/man/dmmp_last_error_msg.3        | 16 +++++
 libdmmp/docs/man/dmmp_log_priority_str.3      | 24 +++++++
 libdmmp/docs/man/dmmp_mpath_array_free.3      | 18 +++++
 libdmmp/docs/man/dmmp_mpath_array_get.3       | 36 ++++++++++
 libdmmp/docs/man/dmmp_mpath_kdev_name_get.3   | 17 +++++
 libdmmp/docs/man/dmmp_mpath_name_get.3        | 18 +++++
 libdmmp/docs/man/dmmp_mpath_wwid_get.3        | 13 ++++
 libdmmp/docs/man/dmmp_path_array_get.3        | 25 +++++++
 libdmmp/docs/man/dmmp_path_blk_name_get.3     | 17 +++++
 libdmmp/docs/man/dmmp_path_group_array_get.3  | 27 ++++++++
 libdmmp/docs/man/dmmp_path_group_id_get.3     | 18 +++++
 .../docs/man/dmmp_path_group_priority_get.3   | 16 +++++
 .../docs/man/dmmp_path_group_selector_get.3   | 16 +++++
 libdmmp/docs/man/dmmp_path_group_status_get.3 | 23 +++++++
 libdmmp/docs/man/dmmp_path_group_status_str.3 | 26 ++++++++
 libdmmp/docs/man/dmmp_path_status_get.3       | 54 +++++++++++++++
 libdmmp/docs/man/dmmp_path_status_str.3       | 34 ++++++++++
 libdmmp/docs/man/dmmp_reconfig.3              | 27 ++++++++
 libdmmp/docs/man/dmmp_strerror.3              | 33 ++++++++++
 libdmmp/docs/{ => man}/libdmmp.h.3            |  0
 libmultipath/io_err_stat.c                    |  2 +-
 tests/Makefile                                |  1 +
 tests/devt.c                                  |  2 +-
 39 files changed, 797 insertions(+), 32 deletions(-)
 create mode 100644 .github/workflows/foreign.yaml
 create mode 100644 .github/workflows/native.yaml
 create mode 100644 libdmmp/docs/man/dmmp_context_free.3
 create mode 100644 libdmmp/docs/man/dmmp_context_log_func_set.3
 create mode 100644 libdmmp/docs/man/dmmp_context_log_priority_get.3
 create mode 100644 libdmmp/docs/man/dmmp_context_log_priority_set.3
 create mode 100644 libdmmp/docs/man/dmmp_context_new.3
 create mode 100644 libdmmp/docs/man/dmmp_context_timeout_get.3
 create mode 100644 libdmmp/docs/man/dmmp_context_timeout_set.3
 create mode 100644 libdmmp/docs/man/dmmp_context_userdata_get.3
 create mode 100644 libdmmp/docs/man/dmmp_context_userdata_set.3
 create mode 100644 libdmmp/docs/man/dmmp_flush_mpath.3
 create mode 100644 libdmmp/docs/man/dmmp_last_error_msg.3
 create mode 100644 libdmmp/docs/man/dmmp_log_priority_str.3
 create mode 100644 libdmmp/docs/man/dmmp_mpath_array_free.3
 create mode 100644 libdmmp/docs/man/dmmp_mpath_array_get.3
 create mode 100644 libdmmp/docs/man/dmmp_mpath_kdev_name_get.3
 create mode 100644 libdmmp/docs/man/dmmp_mpath_name_get.3
 create mode 100644 libdmmp/docs/man/dmmp_mpath_wwid_get.3
 create mode 100644 libdmmp/docs/man/dmmp_path_array_get.3
 create mode 100644 libdmmp/docs/man/dmmp_path_blk_name_get.3
 create mode 100644 libdmmp/docs/man/dmmp_path_group_array_get.3
 create mode 100644 libdmmp/docs/man/dmmp_path_group_id_get.3
 create mode 100644 libdmmp/docs/man/dmmp_path_group_priority_get.3
 create mode 100644 libdmmp/docs/man/dmmp_path_group_selector_get.3
 create mode 100644 libdmmp/docs/man/dmmp_path_group_status_get.3
 create mode 100644 libdmmp/docs/man/dmmp_path_group_status_str.3
 create mode 100644 libdmmp/docs/man/dmmp_path_status_get.3
 create mode 100644 libdmmp/docs/man/dmmp_path_status_str.3
 create mode 100644 libdmmp/docs/man/dmmp_reconfig.3
 create mode 100644 libdmmp/docs/man/dmmp_strerror.3
 rename libdmmp/docs/{ => man}/libdmmp.h.3 (100%)

-- 
2.30.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

