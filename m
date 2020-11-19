Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1771C6379D
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:22:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 13A64222BA
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:22:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13A64222BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-GlFnw2__OaWGFpo1DrC6lA-1; Fri, 20 Nov 2020 04:22:53 -0500
X-MC-Unique: GlFnw2__OaWGFpo1DrC6lA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECA581842145;
	Fri, 20 Nov 2020 09:22:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CEBEC5C1D5;
	Fri, 20 Nov 2020 09:22:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 82B164BB7B;
	Fri, 20 Nov 2020 09:22:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJNQQIJ016041 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 18:26:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9B3E92026D47; Thu, 19 Nov 2020 23:26:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 96D742026D48
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 23:26:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BC44800B3A
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 23:26:24 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-585-jdXqLg0dPhyPh_F4wlUHBg-1;
	Thu, 19 Nov 2020 18:26:22 -0500
X-MC-Unique: jdXqLg0dPhyPh_F4wlUHBg-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 16CDC20B717A;
	Thu, 19 Nov 2020 15:26:20 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 16CDC20B717A
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
Date: Thu, 19 Nov 2020 15:26:03 -0800
Message-Id: <20201119232611.30114-1-tusharsu@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 20 Nov 2020 04:22:46 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH v6 0/8] IMA: support for measuring kernel
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Kernel integrity critical data can be defined as the in-memory kernel
data which if accidentally or maliciously altered, can compromise the
integrity of the system.

There are several kernel subsystems that contain integrity critical
data - e.g. LSMs like SELinux, or AppArmor; or device-mapper targets
like dm-crypt, dm-verity etc. Examples of critical data could be kernel
in-memory r/o structures, hash of the memory structures, or data that
represents a linux kernel subsystem state.

This patch set defines a new IMA hook namely ima_measure_critical_data()
to measure the critical data. Kernel subsystems can use this
functionality, to take advantage of IMA's measuring and quoting 
abilities - thus ultimately enabling remote attestation for the
subsystem specific information stored in the kernel memory.

The functionality is generic enough to measure the data, from the kernel
subsystems, that is required to protect the integrity of the kernel at
runtime.

System administrators may want to limit the critical data being
measured, quoted, and attested. To enable that, a new IMA policy
condition is defined.

This patch set also addresses the need for measuring kernel critical
data early, before a custom IMA policy is loaded - by providing a
builtin IMA policy.

And lastly, the series provides the first consumer of the new IMA hook -
namely SeLinux.

This series is based on the following repo/branch:

 repo: https://github.com/torvalds/linux
 branch: master
 commit 09162bc32c88 ("Linux 5.10-rc4")

This series also has a dependency on the following patch
https://patchwork.kernel.org/patch/11901423/

Change Log v6:
Incorporated feedback from Mimi on v5 of this series.
 - Got rid of patch 5 from the v5 of the series.(the allow list for data
   sources)
 - Updated function descriptions, changed variable names etc.
 - Moved the input param event_data_source in ima_measure_critical_data()
   to a new patch. (patch 6/8 of this series)
 - Split patch 4 from v5 of the series into two patches (patch 4/8 and 
   patch 5/8)
 - Updated cover letter and patch descriptions as per feedback.

Change Log v5:
(1) Incorporated feedback from Stephen on the last SeLinux patch.
 SeLinux Patch: https://patchwork.kernel.org/patch/11801585/
 - Freed memory in the reverse order of allocation in 
   selinux_measure_state().
 - Used scnprintf() instead of snprintf() to create the string for
   selinux state.
 - Allocated event name passed to ima_measure_critical_data() before
   gathering selinux state and policy information for measuring.

(2) Incorporated feedback from Mimi on v4 of this series.
 V4 of this Series: https://patchwork.kernel.org/project/linux-integrity/list/?series=354437

 - Removed patch "[v4,2/6] IMA: conditionally allow empty rule data"
 - Reversed the order of following patches.
      [v4,4/6] IMA: add policy to measure critical data from kernel components
      [v4,5/6] IMA: add hook to measure critical data from kernel components
   and renamed them to remove "from kernel components"
 - Added a new patch to this series - 
       IMA: add critical_data to built-in policy rules

 - Added the next version of SeLinux patch (mentioned above) to this
   series 
       selinux: measure state and hash of the policy using IMA

 - Updated cover-letter description to give broader perspective of the
   feature, rearranging paragraphs, removing unnecessary info, clarifying
   terms etc.
 - Got rid of opt_list param from ima_match_rule_data().
 - Updated the documentation to remove sources that don't yet exist.
 - detailed IMA hook description added to ima_measure_critical_data(),
   as well as elaborating terms event_name, event_data_source. 
 - "data_sources:=" is not a mandatory policy option for 
   func=CRITICAL_DATA anymore. If not present, all the data sources
   specified in __ima_supported_kernel_data_sources will be measured.

Lakshmi Ramasubramanian (2):
  IMA: add a built-in policy rule for critical data measurement
  selinux: measure state and hash of the policy using IMA

Tushar Sugandhi (6):
  IMA: generalize keyring specific measurement constructs
  IMA: add support to measure buffer data hash
  IMA: define a hook to measure kernel integrity critical data
  IMA: add policy rule to measure critical data
  IMA: extend policy to add data sources as a critical data measurement
    constraint
  IMA: add support to critical data hook to limit data sources for
    measurement

 Documentation/ABI/testing/ima_policy         |  10 +-
 include/linux/ima.h                          |   8 +
 security/integrity/ima/ima.h                 |   8 +-
 security/integrity/ima/ima_api.c             |   8 +-
 security/integrity/ima/ima_appraise.c        |   2 +-
 security/integrity/ima/ima_asymmetric_keys.c |   2 +-
 security/integrity/ima/ima_main.c            |  81 +++++++++-
 security/integrity/ima/ima_policy.c          | 123 ++++++++++++---
 security/integrity/ima/ima_queue_keys.c      |   3 +-
 security/selinux/Makefile                    |   2 +
 security/selinux/hooks.c                     |   3 +
 security/selinux/include/security.h          |  11 +-
 security/selinux/measure.c                   | 157 +++++++++++++++++++
 security/selinux/selinuxfs.c                 |   8 +
 security/selinux/ss/services.c               |  71 +++++++--
 15 files changed, 448 insertions(+), 49 deletions(-)
 create mode 100644 security/selinux/measure.c

-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

