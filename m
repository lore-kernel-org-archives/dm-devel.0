Return-Path: <SRS0=6nCw=HB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1EEAC433E0
	for <dm-devel@archiver.kernel.org>; Sat, 30 Jan 2021 00:45:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EA46164E0C
	for <dm-devel@archiver.kernel.org>; Sat, 30 Jan 2021 00:45:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA46164E0C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-AUQfcfa1NUe-idEY70SMLQ-1; Fri, 29 Jan 2021 19:45:45 -0500
X-MC-Unique: AUQfcfa1NUe-idEY70SMLQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07170107ACE4;
	Sat, 30 Jan 2021 00:45:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 649CB5D741;
	Sat, 30 Jan 2021 00:45:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 467A518095FF;
	Sat, 30 Jan 2021 00:45:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10U0jYe7011368 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Jan 2021 19:45:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9549D114CDE; Sat, 30 Jan 2021 00:45:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FE94114CE1
	for <dm-devel@redhat.com>; Sat, 30 Jan 2021 00:45:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1682185A794
	for <dm-devel@redhat.com>; Sat, 30 Jan 2021 00:45:31 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-30-f7HvIfQhPEChPNOanqArtg-1;
	Fri, 29 Jan 2021 19:45:29 -0500
X-MC-Unique: f7HvIfQhPEChPNOanqArtg-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6CA4C20B7192;
	Fri, 29 Jan 2021 16:45:27 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6CA4C20B7192
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
Date: Fri, 29 Jan 2021 16:45:16 -0800
Message-Id: <20210130004519.25106-1-tusharsu@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH 0/3] support for duplicate measurement of
	integrity critical data
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

IMA does not measure duplicate buffer data since TPM extend is a very
expensive operation.  However, in some cases for integrity critical
data, the measurement of duplicate data is necessary to accurately
determine the current state of the system.  Eg, SELinux state changing
from 'audit', to 'enforcing', and back to 'audit' again.  In this
example, currently, IMA will not measure the last state change to
'audit'.  This limits the ability of attestation services to accurately
determine the current state of the integrity critical data on the
system.

This series addresses this gap by providing the ability to measure
duplicate entries for integrity critical data, driven by policy.

This series is based on the following repo/branch/commit:
 repo: https://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
 branch: next-integrity-testing
 commit b3f82afc1041 ("IMA: Measure kernel version in early boot") 

Tushar Sugandhi (3):
  IMA: add policy condition to measure duplicate critical data
  IMA: update functions to read allow_dup policy condition
  IMA: add support to measure duplicate buffer for critical data hook

 Documentation/ABI/testing/ima_policy  |  4 +++-
 security/integrity/ima/ima.h          |  8 +++----
 security/integrity/ima/ima_api.c      | 15 +++++++------
 security/integrity/ima/ima_appraise.c |  2 +-
 security/integrity/ima/ima_init.c     |  2 +-
 security/integrity/ima/ima_main.c     |  9 ++++----
 security/integrity/ima/ima_policy.c   | 31 ++++++++++++++++++++++++---
 security/integrity/ima/ima_queue.c    |  5 +++--
 8 files changed, 54 insertions(+), 22 deletions(-)

-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

