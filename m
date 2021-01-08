Return-Path: <SRS0=H596=GL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49399C433E6
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 04:07:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9FA812370D
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 04:07:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9FA812370D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-VSG3qOoCN5Oqwn8Bqw4wjw-1; Thu, 07 Jan 2021 23:07:38 -0500
X-MC-Unique: VSG3qOoCN5Oqwn8Bqw4wjw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E8D8107ACE3;
	Fri,  8 Jan 2021 04:07:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 650E019C66;
	Fri,  8 Jan 2021 04:07:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 046864E58F;
	Fri,  8 Jan 2021 04:07:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10847UMr008568 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 7 Jan 2021 23:07:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BFCCA2166B29; Fri,  8 Jan 2021 04:07:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BAABC2166B28
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 04:07:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F166800962
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 04:07:28 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-526-fX7i0gnqOge3w2bdJ1zZ6w-1;
	Thu, 07 Jan 2021 23:07:24 -0500
X-MC-Unique: fX7i0gnqOge3w2bdJ1zZ6w-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 1D09E20B7192;
	Thu,  7 Jan 2021 20:07:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1D09E20B7192
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
Date: Thu,  7 Jan 2021 20:07:00 -0800
Message-Id: <20210108040708.8389-1-tusharsu@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH v10 0/8] IMA: support for measuring kernel
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

IMA measures files and buffer data such as keys, command-line arguments
passed to the kernel on kexec system call, etc.  While these measurements
are necessary for monitoring and validating the integrity of the system,
they are not sufficient.  Various data structures, policies, and states
stored in kernel memory also impact the integrity of the system.
Several kernel subsystems contain such integrity critical data -
e.g.  LSMs like SELinux, AppArmor etc.  or device-mapper targets like
dm-crypt, dm-verity, dm-integrity etc.  These kernel subsystems help
protect the integrity of a system.  Their integrity critical data is not
expected to change frequently during run-time.  Some of these structures
cannot be defined as __ro_after_init, because they are initialized later.

For a given system, various external services/infrastructure tools
(including the attestation service) interact with it - both during the
setup and during rest of the system run-time.  They share sensitive data
and/or execute critical workload on that system.  The external services
may want to verify the current run-time state of the relevant kernel
subsystems before fully trusting the system with business critical
data/workload.  For instance, verifying that SELinux is in "enforce" mode
along with the expected policy, disks are encrypted with a certain
configuration, secure boot is enabled etc.

This series provides the necessary IMA functionality for kernel
subsystems to ensure their configuration can be measured:
  - by kernel subsystems themselves,
  - in a tamper resistant way,
  - and re-measured - triggered on state/configuration change.

This patch set:
  - defines a new IMA hook ima_measure_critical_data() to measure
    integrity critical data,
  - limits the critical data being measured based on a label,
  - defines a builtin critical data measurement policy,
  - and includes an SELinux consumer of the new IMA critical data hook.

This series is based on the following repo/branch:

 repo: https://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
 branch: next-integrity
 commit 207cdd565dfc ("ima: Don't modify file descriptor mode on the fly")

Change Log v10:
Incorporated feedback from Mimi on v9 of this series.
 - Updated function description comments to simplify language and remove
   unnecessary text.
 - Changed references to variable names and policy documentation from
   "data_source" to "label".
 - Updated patch descriptions to simplify language and remove unnecessary
   text.
 - Updated function names and file name related to SELinux IMA
   measurements per feedback from Paul Moore.
 - Updated patch description for adding a built-in IMA policy for
   measuring kernel critical data.

Change Log v9:
Incorporated feedback from Tyler on v8 of this series.
 - Moved rule->data_source logic from Patch #4 to Patch #5.
 - Removed unnecessary variable event_name from selinux_event_name()
   in Patch #8.


Change Log v8:
Incorporated feedback from Tyler on v7 of this series.
 - Removed unnecessary 'else' clauses in ima_match_rule_data().
 - Fixed ima_store_template() to pass the buffer hash in case the
   buffer is large.
 - fixed function description for ima_measure_critical_data().
 - Moved some usage of CRITICAL_DATA from Patch #3 to Patch #4.
 - Moved IMA_DATA_SOURCE from Patch #4 to Patch #5.
 - Removed unnecessary pr_err() from ima_measure_critical_data()
   and selinux_event_name().
 - Fixed log formatting in selinux_measure_state() to be consistent
   with other messages in that file.

Change Log v7:
Incorporated feedback from Mimi on v6 of this series.
 - Updated cover letter and patch descriptions as per Mimi's feedback.
 - Changed references to variable names and policy documentation from
   plural "data_sources" to singular "data_source".
 - Updated SELinux patch to measure only policy, instead of policy and
   state.  The state measurement will be upstreamed through a separate
   patch.
 - Updated admin-guide/kernel-parameters.txt to document support for
   critical_data in builtin policy.

Change Log v6:
Incorporated feedback from Mimi on v5 of this series.
 - Got rid of patch 5 from the v5 of the series.(the allow list for data
   sources)
 - Updated function descriptions, changed variable names etc.
 - Moved the input param event_data_source in ima_measure_critical_data()
   to a new patch.  (patch 6/8 of this series)
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
   func=CRITICAL_DATA anymore.  If not present, all the data sources
   specified in __ima_supported_kernel_data_sources will be measured.


Lakshmi Ramasubramanian (2):
  IMA: define a builtin critical data measurement policy
  selinux: include a consumer of the new IMA critical data hook

Tushar Sugandhi (6):
  IMA: generalize keyring specific measurement constructs
  IMA: add support to measure buffer data hash
  IMA: define a hook to measure kernel integrity critical data
  IMA: add policy rule to measure critical data
  IMA: limit critical data measurement based on a label
  IMA: extend critical data hook to limit the measurement based on a
    label

 Documentation/ABI/testing/ima_policy          |   5 +-
 .../admin-guide/kernel-parameters.txt         |   5 +-
 include/linux/ima.h                           |  10 ++
 security/integrity/ima/ima.h                  |   8 +-
 security/integrity/ima/ima_api.c              |   8 +-
 security/integrity/ima/ima_appraise.c         |   2 +-
 security/integrity/ima/ima_asymmetric_keys.c  |   2 +-
 security/integrity/ima/ima_main.c             |  59 +++++++--
 security/integrity/ima/ima_policy.c           | 115 ++++++++++++++----
 security/integrity/ima/ima_queue_keys.c       |   3 +-
 security/selinux/Makefile                     |   2 +
 security/selinux/ima.c                        |  64 ++++++++++
 security/selinux/include/ima.h                |  24 ++++
 security/selinux/include/security.h           |   3 +-
 security/selinux/ss/services.c                |  64 ++++++++--
 15 files changed, 324 insertions(+), 50 deletions(-)
 create mode 100644 security/selinux/ima.c
 create mode 100644 security/selinux/include/ima.h

-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

