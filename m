Return-Path: <SRS0=J1Yh=NE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C9A6C4320E
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 21:38:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B76FC60EE4
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 21:38:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B76FC60EE4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-LjxG3vN4NSOyL4gvKbP5CA-1; Fri, 13 Aug 2021 17:38:27 -0400
X-MC-Unique: LjxG3vN4NSOyL4gvKbP5CA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51DC31853028;
	Fri, 13 Aug 2021 21:38:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3641C60C04;
	Fri, 13 Aug 2021 21:38:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 06FEA4BB7C;
	Fri, 13 Aug 2021 21:38:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17DLcGo1015498 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 13 Aug 2021 17:38:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BF53C14E789; Fri, 13 Aug 2021 21:38:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B6CF312160F
	for <dm-devel@redhat.com>; Fri, 13 Aug 2021 21:38:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42BD18D1384
	for <dm-devel@redhat.com>; Fri, 13 Aug 2021 21:38:15 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-566-KFvNFk3hPKqUPMipWtDeDQ-1;
	Fri, 13 Aug 2021 17:38:11 -0400
X-MC-Unique: KFvNFk3hPKqUPMipWtDeDQ-1
Received: from Lenovo-Legion-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 7F42720C13EE;
	Fri, 13 Aug 2021 14:38:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7F42720C13EE
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Date: Fri, 13 Aug 2021 14:37:55 -0700
Message-Id: <20210813213801.297051-1-tusharsu@linux.microsoft.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17DLcGo1015498
X-loop: dm-devel@redhat.com
Cc: sfr@canb.auug.org.au, zohar@linux.ibm.com, nramas@linux.microsoft.com,
	public@thson.de, tusharsu@linux.microsoft.com,
	linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH 0/6] updates to device mapper target measurement
	using ima
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


There were several improvements suggested for the original device mapper
target measurement patch series [1].

Those improvement suggestions include: 
 - Prefixing hashes for the DM tables being measured in ima log with the
   hash algorithm.
 - Adding version information for DM related events being measured in the
   ima log.
 - Prefixing DM related event names with "dm_".
 - Including the verity target attribute - "root_hash_sig_key_desc"
   in the ima measurement log.

This series incorporates the above suggestions.

This series also has the following fixes:
 - Adding a one-time warning to dmesg during dm_init if
   CONFIG_IMA_DISABLE_HTABLE is set to 'n'.
 - Updating 'integrity' target to remove the duplicate measurement of
   the attribute "mode=%c".
 - Indexing various attributes in 'multipath' target, and adding
   "nr_priority_groups=%u" attribute to the measurements.
 - Fixing 'make htmldocs' warnings in dm-ima.rst.
 - Adding missing documentation for the targets - 'cache', 'integrity',
   'multipath', and 'snapshot' in dm-ima.rst.
 - Updating dm-ima.rst documentation with the grammar for various DM
   events and targets in Backus Naur form.
 - Updating dm-ima.rst documentation to be consistent with the code
   changes described above.

This series is based on top of the following git repo/branch/commit:
 Repo: https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
 Branch: dm-5.15
 Commit: commit 5a2a33884f0b ("dm crypt: Avoid percpu_counter spinlock contention in crypt_page_alloc()")


[1] https://patchwork.kernel.org/project/dm-devel/cover/20210713004904.8808-1-tusharsu@linux.microsoft.com/

Tushar Sugandhi (6):
  dm ima: prefix dm table hashes in ima log with hash algorithm
  dm ima: add version info to dm related events in ima log
  dm ima: prefix ima event name related to device mapper with dm_
  dm ima: add a warning in dm_init if duplicate ima events are not
    measured
  dm ima: update dm target attributes for ima measurements
  dm ima: update dm documentation for ima measurement support

 .../admin-guide/device-mapper/dm-ima.rst      | 827 +++++++++++++-----
 drivers/md/dm-ima.c                           |  94 +-
 drivers/md/dm-ima.h                           |  10 +
 drivers/md/dm-integrity.c                     |   1 -
 drivers/md/dm-mpath.c                         |  26 +-
 drivers/md/dm-verity-target.c                 |   2 +
 drivers/md/dm.c                               |   6 +
 7 files changed, 724 insertions(+), 242 deletions(-)

-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

