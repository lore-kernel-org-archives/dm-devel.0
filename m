Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22DFFC433FE
	for <dm-devel@archiver.kernel.org>; Mon,  7 Nov 2022 08:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667810412;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=79rLiB0Cues7XZruW8eNQMZGK/U1uxwjABfssy4+VY8=;
	b=bvu5oCjN59aDm5HTeUIOWeejb0j1pj1XV7S+ZybppX0+1MhatHbPwho6j4QvResTZvdc0N
	qMff/G4fWEVs/lK+xg8ynCO7aIGuyl1CsFAQvX9QABKvFCNTuYhK8ziCefffWeoYfUbVPp
	mNvkTcblSM5lscabidvsJSDI91MGbxM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-FM3gu-IGMD6d4NM4LfopQg-1; Mon, 07 Nov 2022 03:40:11 -0500
X-MC-Unique: FM3gu-IGMD6d4NM4LfopQg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5B7F3817A6E;
	Mon,  7 Nov 2022 08:40:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AFC4B2166B29;
	Mon,  7 Nov 2022 08:40:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 132D719465B7;
	Mon,  7 Nov 2022 08:40:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7DCD11946587
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 11:30:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 775EF112132C; Fri,  4 Nov 2022 11:30:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FD4D1121325
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 11:30:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50BFB101A52A
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 11:30:12 +0000 (UTC)
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-368-jLlnPZ74N16mnSJsR9M0cg-1; Fri, 04 Nov 2022 07:30:11 -0400
X-MC-Unique: jLlnPZ74N16mnSJsR9M0cg-1
Received: by mail-pl1-f197.google.com with SMTP id
 i8-20020a170902c94800b0018712ccd6bbso3391800pla.1
 for <dm-devel@redhat.com>; Fri, 04 Nov 2022 04:30:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=X2vF9wu9D9A9HBRSXFDC1P9Ez4nhQcXyZNLm0dcpRMo=;
 b=pml4A9x1JvoFTd9LU2D6HcLRHZ1pzrppPFc41eZLX0BF33PNcLfgHBGCNecpJR9ndD
 5tjYM6+4M0PtIvLsKs+RC4TkszAIbVoZIzvP4jBGryfGZ/OojAkeLD9NsXrWGvwv69wb
 w9fWWtsTwrRF9p3NEyqpay9mzprX/dKyRIXNVplimC2fVms3maK353VGPy9y6j23sP7I
 NQqy6EAzk4sMjBejLzO2sjud7oo4UKD6d6VYbYM24se67LLi9e8Z14wQstPUMMu+PSu/
 vYyHiVJ9c3JHdnP2+lauH5r5mnKyKK0FVExQxDWJ9uMBBJ1MthpYTWfhS9iSmubFcU6d
 08Mw==
X-Gm-Message-State: ACrzQf0ySH4YoFx0KTsu6cKv7dFW+BX41Tfxj6SYtWh/PJlYnzrajOIW
 ENyq3PM47xVG6qYtZrpB9D03JeKY8qqKDtPB7nJuEH4jDfjf1TKF7uOuKS3mknm7G0lPty2qEaz
 v3NmK5Nfk9ze41Mo=
X-Received: by 2002:a05:6a00:84b:b0:56d:3cf5:1031 with SMTP id
 q11-20020a056a00084b00b0056d3cf51031mr30151532pfk.75.1667561410122; 
 Fri, 04 Nov 2022 04:30:10 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6ZmqK77wd2hCvap39otYWhRGk7HSG6DR3nAEU2Jv3tyaB6tseG9Ymp8fTHcgu2gG1DjEWLsQ==
X-Received: by 2002:a05:6a00:84b:b0:56d:3cf5:1031 with SMTP id
 q11-20020a056a00084b00b0056d3cf51031mr30151497pfk.75.1667561409825; 
 Fri, 04 Nov 2022 04:30:09 -0700 (PDT)
Received: from localhost ([209.132.188.80]) by smtp.gmail.com with ESMTPSA id
 p189-20020a625bc6000000b0056abff42a8bsm2503420pfb.69.2022.11.04.04.30.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Nov 2022 04:30:08 -0700 (PDT)
From: Coiby Xu <coxu@redhat.com>
To: kexec@lists.infradead.org
Date: Fri,  4 Nov 2022 19:29:55 +0800
Message-Id: <20221104113000.487098-1-coxu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 07 Nov 2022 08:40:06 +0000
Subject: [dm-devel] [RFC v2 0/5] Support kdump with LUKS encryption by
 reusing LUKS volume key
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
Cc: Baoquan He <bhe@redhat.com>, dm-devel@redhat.com,
 Pingfan Liu <kernelfans@gmail.com>, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>, Jan Pazdziora <jpazdziora@redhat.com>,
 Thomas Staudt <tstaudt@de.ibm.com>, Dave Young <dyoung@redhat.com>,
 Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

RFC v2
 - libcryptsetup interacts with the kernel via sysfs instead of "hacking"
   dm-crypt 
   - to save a kdump copy of the LUKS volume key in 1st kernel
   - to add a logon key using the copy for libcryptsetup in kdump kernel [Milan]
   - to avoid the incorrect usage of LUKS master key in dm-crypt [Milan]
 - save the kdump copy of LUKS volume key randomly [Jan]
 - mark the kdump copy inaccessible [Pingfan]
 - Miscellaneous
   - explain when operations related to the LUKS volume key happen [Jan]
   - s/master key/volume key/g
   - use crash_ instead of kexec_ as function prefix
   - fix commit subject prefixes e.g. "x86, kdump" to x86/crash

With kdump enabled, when the 1st kernel crashes, the system could boot
into the kdump/crash kernel and dump the memory image i.e. /proc/vmcore
to a specified target. Currently, when dumping vmcore to a LUKS
encrypted device, there are two problems,

 - for some machines, a system administrator may not have a chance to
   enter the password to decrypt the device in kdump initramfs after the
   1st kernel crashes 

 - LUKS2 by default use the memory-hard Argon2 key derivation function
   which is quite memory-consuming compared to the limited memory reserved
   for kdump. Take Fedora example, by default, only 256M is reserved for
   systems having memory between 4G-64G. With LUKS enabled, ~1300M needs
   to be reserved for kdump. Note if the memory reserved for kdump can't
   be used by 1st kernel i.e. an user sees ~1300M memory missing in the
   1st kernel. 
 
Besides users (at least for Fedora) usually expect kdump to work out of
the box i.e. no manual password input is needed. And it doesn't make
sense to derivate the key again in kdump kernel which seems to be
redundant work.

Based on Milan's feedback [1] on Kairui's ideas to support kdump with
LUKS encryption, this patch set addresses the above issues by reusing
the LUKS volume key in kdump kernel and here is the life cycle of this
kdump copy of LUKS volume key,

 1. After the 1st kernel loads the initramfs during boot, systemd
    asks for a passphrase from the user and uses it to de-crypt the LUKS
    volume key

 2. After the 1st kernel saving the volume key as a logon key,
    libcrytpsetup notifies the kernel to read this logon key and store a
    temporary copy by writing the key description to
    /sys/kernel/crash_luks_volume_key

 3. After switching to the real root fs, kdump.serivce is started and it 
    loads the kdump kernel using the kexec_file_load syscall

 4. The kexec_file_load syscall saves the temporary copy of the volume
    key to kdump reserved memory and wipe the copy.

 5. When the 1st kernel crashes and kdump kernel is booted,
    libcryptsetup asks the kdump kernel to add a logon key using
    the volume key stored in kdump reserved memory by writing the key
    description to /sys/kernel/crash_luks_volume_key

 6. The system gets rebooted to the 1st kernel after dumping vmcore to
    the LUKS encrypted device is finished

Note the kdump copy of LUKS volume key never leaves the kernel space and
is saved in the memory area exclusively reserved for kdump where even
the 1st kernel has no direct access. 

Milan's major concern [2] on previous version is "storing the encryption
key to yet another place are creating another attack vector". To further
secure this copy, two additional protections are added,
 - save the copy randomly in kdump reserved memory as suggested by Jan
 - clear the _PAGE_PRESENT flag of the page that stores the copy as
   suggested by Pingfan

If there is no further security concern with this approach or any other
concern, I will drop the following assumptions,
  - only x86 is supported
  - there is only one LUKS device for the system

to extend the support to other architectures including POWER, ARM and
s390x and address the case of multiple LUKS devices. Any feedback will be 
appreciated, thanks!

For a proof of concept, I've patched cryptsetup [3] in a quick-and-dirty
way to support a new option "--kdump-kernel-master-key"
and hacked systemd [4]. It works for Fedora 35.

[1] https://yhbt.net/lore/all/e5abd089-3398-fdb4-7991-0019be434b79@gmail.com/
[2] https://lwn.net/ml/linux-kernel/c857dcf8-024e-ab8a-fd26-295ce2e0ae41@gmail.com/
[3] https://gitlab.com/coxu/cryptsetup/-/commit/750a46d933fac82e0c994b5c41de40a0b8cac647
[4] https://github.com/coiby/systemd/tree/reuse_kdump_master_key

Coiby Xu (5):
  kexec_file: allow to place kexec_buf randomly
  crash_dump: save the LUKS volume key temporarily
  x86/crash: pass the LUKS volume key to kdump kernel
  x86/crash: make the page that stores the LUKS volume key inaccessible
  crash_dump: retrieve LUKS volume key in kdump kernel

 arch/x86/include/asm/crash.h       |   1 +
 arch/x86/kernel/crash.c            |  47 ++++++-
 arch/x86/kernel/kexec-bzimage64.c  |   7 +
 arch/x86/kernel/machine_kexec_64.c |  16 +++
 include/linux/crash_core.h         |   2 +
 include/linux/crash_dump.h         |   2 +
 include/linux/kexec.h              |   6 +
 kernel/crash_dump.c                | 200 +++++++++++++++++++++++++++++
 kernel/kexec_file.c                |  15 +++
 kernel/ksysfs.c                    |  19 +++
 10 files changed, 314 insertions(+), 1 deletion(-)

-- 
2.37.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

