Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58F4CC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 21 Mar 2022 06:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647845704;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EiQzUmilmP/9XnRHnpOLGOuwMssuTSr3pfx3DOIlOOo=;
	b=V072bOLjeFOioEXf4/8aRnQ1lisHvvQAOHeQILR/Iw+nggyJzVk0ojgJL4KLV/7VxaTJU9
	LaNvuB3qpEp+NKn8xrHV8t3MccmPzTRG2jDSJG7Rym0n4cGYAZ5KrVjtU/CON54eIV08R6
	jzj6xW4CHMYuKeV6LwIA/EqG7CRexOI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-Bm-6bRYYMBeLEfPDjXUWSQ-1; Mon, 21 Mar 2022 02:54:57 -0400
X-MC-Unique: Bm-6bRYYMBeLEfPDjXUWSQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12B66899ECF;
	Mon, 21 Mar 2022 06:54:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EB5604010A2A;
	Mon, 21 Mar 2022 06:54:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8A2A6193F6DE;
	Mon, 21 Mar 2022 06:54:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 002D71949761
 for <dm-devel@listman.corp.redhat.com>; Fri, 18 Mar 2022 10:34:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A1ED0145455A; Fri, 18 Mar 2022 10:34:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E12C1454559
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 10:34:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8548C802A5E
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 10:34:30 +0000 (UTC)
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-52g5x9ZxOXOZIj2s8lyI2A-1; Fri, 18 Mar 2022 06:34:29 -0400
X-MC-Unique: 52g5x9ZxOXOZIj2s8lyI2A-1
Received: by mail-pj1-f71.google.com with SMTP id
 s20-20020a17090ad49400b001bf481fae01so5149109pju.1
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 03:34:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=I0SeAJoKlMFlPQaiYQbOksz1DlSlCXtZSo9ZW+YXDyc=;
 b=wB2pzYhhgRl0/C378b1s9U3E2mZpUf88tDJKJAbKBmQCLW5AugwxO4gEo33wZfVhJ4
 ni1Iiz8Wy6AbkNwS833LJZkti0PnpPUqA2xJDm1Bj6DvsaR1ilXJp/gfjAR6WUSvySrd
 EKk+ig7y7iapoSoJZMmrj2wMwZQYLfcOFFzfMyYd14J/R/VWqXTHroF5ioaqH6tYoGlz
 ApToNosv3BiOtDApZOgKDEZsWLz8WXshlcwba2XpJysj7Do6vP2yUTgmu+yOTPqZWuKu
 Xkv2tDIqeBTxh48+TjVYFayD6AvJZLp+L49Nix3dR8nZzYuwus9kbVV2K5Fs00uwc2UL
 Bwsw==
X-Gm-Message-State: AOAM533mQRQqMCIAyGLQXl9FQoj8hTZF149Bt81MMUfwse7SYhBNz9gn
 DNxsWmb9OsjJspe5JXy7ZKhrsQwz2F44lC+E8QJ9nc4Iegq7GccXVnbEuNtPh2AZQdy5zCnaxYG
 uy0/ggl0+/dQD9Bk=
X-Received: by 2002:a17:902:ab10:b0:153:b520:dbbe with SMTP id
 ik16-20020a170902ab1000b00153b520dbbemr9101383plb.55.1647599668107; 
 Fri, 18 Mar 2022 03:34:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxq2E7lA6GIq04muhHDq/uvZNiBh61dHzMtMN7l2+AjLeU44C6BHkUhd4xQqMPmuKGlo4mfig==
X-Received: by 2002:a17:902:ab10:b0:153:b520:dbbe with SMTP id
 ik16-20020a170902ab1000b00153b520dbbemr9101364plb.55.1647599667809; 
 Fri, 18 Mar 2022 03:34:27 -0700 (PDT)
Received: from localhost ([240e:3a1:2e5:800:f995:6136:f760:a3d0])
 by smtp.gmail.com with ESMTPSA id
 s6-20020a056a0008c600b004f667b8a6b6sm9773079pfu.193.2022.03.18.03.34.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 18 Mar 2022 03:34:27 -0700 (PDT)
From: Coiby Xu <coxu@redhat.com>
To: kexec@lists.infradead.org
Date: Fri, 18 Mar 2022 18:34:19 +0800
Message-Id: <20220318103423.286410-1-coxu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Mon, 21 Mar 2022 06:54:49 +0000
Subject: [dm-devel] [RFC 0/4] Support kdump with LUKS encryption by reusing
 LUKS master key
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
Cc: Mike Snitzer <snitzer@redhat.com>, Baoquan He <bhe@redhat.com>,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>, Thomas Staudt <tstaudt@de.ibm.com>,
 Dave Young <dyoung@redhat.com>, Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

With kdump enabled, when kernel crashes, the system could boot into the
kdump kernel and dump the memory image i.e. /proc/vmcore to a specified
target. Currently, when dumping vmcore to a LUKS encrypted device, there
are two problems,
 - for some machines, the user may don't have a chance enter the password
   to decrypt the device after kernel crashes and kdump initrd is loaded
 - LUKS2 by default use the memory-hard Argon2 key derivation function
   which is quite memory-consuming compared to the limited memory reserved
   for kdump. Take Fedora example, by default, only 256M is reserved for
   systems having memory between 4G-64G. With LUKS enabled, ~1300M needs
   to be reserved for kdump.
 
Besides the users (at least for Fedora) usually expect kdump to work out
of the box i.e. no manual password input is needed. And it doesn't make
sense to derivate the master key again in kdump kernel which seems to be
redundant work.

Based on Milan's feedback [1] on Kairui's ideas to support kdump with
LUKS encryption, this patch set addresses the above issues by
 1) first saving the LUKS master key to kexec when opening the encrypted
    device 
 2) then saving the master key to the reserved memory for kdump when 
    loading kdump kernel image.

So the LUKS master key never leaves the kernel space and once the key has
been saved to the reserved memory for kdump, it would be wiped 
immediately. If there is no security concern with this approach or any
other concern, I will drop the following assumptions made for this RFC
version in v1,
 - only x86 is supported
 - there is only one LUKS device for the system

to extend the support to other architectures including POWER, ARM and
s390x and address the case of multiple LUKS devices. Any feedback will be 
appreciated, thanks!

For a proof of concept, I've patched cryptsetup [2] in a quick-and-dirty
way to support a new option "--kdump-kernel-master-key"
and hacked systemd [3]. It works for Fedora 34.

[1] https://yhbt.net/lore/all/e5abd089-3398-fdb4-7991-0019be434b79@gmail.com/
[2] https://gitlab.com/coxu/cryptsetup/-/commit/ee54bb15445da0bc3f9155a7227a9799da4dac20
[3] https://github.com/coiby/systemd/tree/reuse_kdump_master_key

Coiby Xu (4):
  kexec, dm-crypt: receive LUKS master key from dm-crypt and pass it to
    kdump
  kdump, x86: pass the LUKS master key to kdump kernel using a kernel
    command line parameter luksmasterkey
  crash_dump: retrieve LUKS master key in kdump kernel
  dm-crypt: reuse LUKS master key in kdump kernel

 arch/x86/include/asm/crash.h      |  1 +
 arch/x86/kernel/crash.c           | 42 ++++++++++++++++++-
 arch/x86/kernel/kexec-bzimage64.c |  7 ++++
 drivers/md/dm-crypt.c             | 26 +++++++++---
 include/linux/crash_dump.h        |  4 ++
 include/linux/kexec.h             |  7 ++++
 kernel/crash_dump.c               | 69 +++++++++++++++++++++++++++++++
 kernel/kexec_core.c               | 66 +++++++++++++++++++++++++++++
 8 files changed, 215 insertions(+), 7 deletions(-)

-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

