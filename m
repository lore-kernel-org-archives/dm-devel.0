Return-Path: <SRS0=kRAg=EI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1796C388F9
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 07:58:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5367021D91
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 07:58:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5367021D91
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-SH6q9hK_Oi-DSZ5gERBWdA-1; Mon, 02 Nov 2020 02:58:11 -0500
X-MC-Unique: SH6q9hK_Oi-DSZ5gERBWdA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 771ED57083;
	Mon,  2 Nov 2020 07:58:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 082985576C;
	Mon,  2 Nov 2020 07:58:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0CBE28C7AC;
	Mon,  2 Nov 2020 07:58:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A1MQfTV029342 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 1 Nov 2020 17:26:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 22455202450E; Sun,  1 Nov 2020 22:26:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DEF0202450A
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 22:26:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF10E1021F63
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 22:26:38 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-85-DBqufFBpPK-tQybBY_Ow1A-1;
	Sun, 01 Nov 2020 17:26:36 -0500
X-MC-Unique: DBqufFBpPK-tQybBY_Ow1A-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 18EAE20B4905;
	Sun,  1 Nov 2020 14:26:35 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 18EAE20B4905
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
Date: Sun,  1 Nov 2020 14:26:19 -0800
Message-Id: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
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
X-Mailman-Approved-At: Mon, 02 Nov 2020 02:58:01 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH v5 0/7] IMA: Infrastructure for measurement of
	critical kernel data
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

There are several kernel subsystems that contain critical data which if
accidentally or maliciously altered, can compromise the integrity of the
system. Examples of such subsystems would include LSMs like SELinux, or
AppArmor; or device-mapper targets like dm-crypt, dm-verity etc. 
"critical data" in this context is kernel subsystem specific information
that is stored in kernel memory. Examples of critical data could be
kernel in-memory r/o structures, hash of the memory structures, or
data that represents a linux kernel subsystem state.

This patch set defines a new IMA hook namely CRITICAL_DATA, and a
function ima_measure_critical_data() - to measure the critical data. 
Kernel subsystems can use this functionality, to take advantage of IMA's
measuring and quoting abilities - thus ultimately enabling remote
attestation for the subsystem specific information stored in the kernel
memory.

The functionality is generic enough to measure the data of any kernel
subsystem at run-time. To ensure that only data from supported sources
are measured, the kernel subsystem needs to be added to a compile-time
list of supported sources (an "allowed list of components"). IMA
validates the source passed to ima_measure_critical_data() against this
allowed list at run-time.

System administrators may want to pick and choose which kernel
subsystem information they would want to enable for measurements,
quoting, and remote attestation. To enable that, a new IMA policy is
introduced.

This patch set also addresses the need for the kernel subsystems to
measure their data before a custom IMA policy is loaded - by providing
a builtin IMA policy.

And lastly, the use of the overall functionality is demonstrated by
measuring the kernel in-memory data for one such subsystem - SeLinux.

This series is based on the following repo/branch:

 repo: https://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/selinux.git
 branch: next
 commit 3650b228f83a ("Linux 5.10-rc1")


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

Change Log v4:
Incorporated feedback from Mimi on v3.
 - Split patch #1 into two patches to move introduction of bool
   allow_empty_opt_list into the 2nd patch.
 - Reverted return type of process_buffer_measurement() from int to void
   which got rid of patch #2 from the v3 of the series.
 - Renamed the policy "critical_kernel_data_sources" to "data_sources".
 - Updated process_buffer_measurement() to avoid code and variable
   duplication in the if(measure_buf_hash) block.
 - Changed return type of ima_measure_critical_data() from int to void.
 - Updated patch description for patch #3 and #4 as per Mimi's feedback.

Change Log v3:
Incorporated feedback from Mimi on v2.
 - Renamed the policy "data_sources" to
   "critical_kernel_data_sources".
 - Added "critical_kernel_data_sources" description in
   Documentation/ima-policy.
 - Split CRITICAL_DATA + critical_kernel_data_sources into two separate
   patches.
 - Merged hook ima_measure_critical_data() + CRITICAL_DATA into a single
   patch.
 - Added functionality to validate data sources before measurement.

Change Log v2:
 - Reverted the unnecessary indentations in existing #define.
 - Updated the description to replace the word 'enlightened' with
   'supported'.
 - Reverted the unnecessary rename of attribute size to buf_len.
 - Introduced a boolean parameter measure_buf_hash as per community
   feedback to support measuring hash of the buffer, instead of the
   buffer itself.

Lakshmi Ramasubramanian (2):
  IMA: add critical_data to the built-in policy rules
  selinux: measure state and hash of the policy using IMA

Tushar Sugandhi (5):
  IMA: generalize keyring specific measurement constructs
  IMA: update process_buffer_measurement to measure buffer hash
  IMA: add hook to measure critical data
  IMA: add policy to measure critical data
  IMA: validate supported kernel data sources before measurement

 Documentation/ABI/testing/ima_policy         |  10 +-
 include/linux/ima.h                          |   8 +
 security/integrity/ima/ima.h                 |  38 ++++-
 security/integrity/ima/ima_api.c             |   8 +-
 security/integrity/ima/ima_appraise.c        |   2 +-
 security/integrity/ima/ima_asymmetric_keys.c |   2 +-
 security/integrity/ima/ima_main.c            |  79 +++++++++-
 security/integrity/ima/ima_policy.c          | 143 ++++++++++++++---
 security/integrity/ima/ima_queue_keys.c      |   3 +-
 security/selinux/Makefile                    |   2 +
 security/selinux/hooks.c                     |   3 +
 security/selinux/include/security.h          |  11 +-
 security/selinux/measure.c                   | 157 +++++++++++++++++++
 security/selinux/selinuxfs.c                 |   9 ++
 security/selinux/ss/services.c               |  71 +++++++--
 15 files changed, 499 insertions(+), 47 deletions(-)
 create mode 100644 security/selinux/measure.c

-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

