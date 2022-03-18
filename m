Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30A78C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 18 Mar 2022 11:29:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-fdZ9kMHDPgStwI_rYpiQ7g-1; Fri, 18 Mar 2022 07:29:23 -0400
X-MC-Unique: fdZ9kMHDPgStwI_rYpiQ7g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F4FD185A7B2;
	Fri, 18 Mar 2022 11:29:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C7152C50943;
	Fri, 18 Mar 2022 11:29:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AB580194034E;
	Fri, 18 Mar 2022 11:29:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3E6E31949763
 for <dm-devel@listman.corp.redhat.com>; Fri, 18 Mar 2022 11:29:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2A34357B2AF; Fri, 18 Mar 2022 11:29:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 25D44578D53
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 11:29:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DE093C01B85
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 11:29:17 +0000 (UTC)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-TU-sr3fTOXieTBk6LfH9pg-1; Fri, 18 Mar 2022 07:29:11 -0400
X-MC-Unique: TU-sr3fTOXieTBk6LfH9pg-1
Received: by mail-wr1-f49.google.com with SMTP id u16so10317871wru.4;
 Fri, 18 Mar 2022 04:29:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=zhJ3+Tw2rjs90pVrPjzkbml2R5PoxjaT42AVteHA4F4=;
 b=PDahbRh+VJFUk/kQxK8s+PsjRaaZ8N9ydI/94+OSWf6hxO2r+AkQQlK2qh4iHTRyia
 FUVtg4cVcOSPe8MrrNffuVwcrPfny4h64OvJ/uDC7mTo5HV8pgVZg5Cy4amqSYSWlBh4
 UC6Ldypxqvws92QquP0Ono0BK1fR7q4DlDaq6d3CwzRDDloUXMnxGdUycHPHifJrK9uA
 UntixCIKcaiMUvQ0j9s05c17dsyk/ijvq87FfY3ynxuu2VRDaouxGyMLZA5zt86Tp/91
 buwpFfUuJ7uoIPMWQUaLqgGDMZs+1C+tItyCRPAyPLv/hWywkHrlvK7wdz4AF9VJ9Yxz
 3Pkg==
X-Gm-Message-State: AOAM533r5fC/fbWvToEi+VMXAeHFE0kZIGUeTwerh4uc+PwJGG5GGEi2
 ta2zMnFSke9BK8ezcwp8UTOgW1dQANx6zA==
X-Google-Smtp-Source: ABdhPJzGJtYQoLClsmP2uoJXyJY8zHKqktfU1oIzutu5ac588ybaTCFux2Y51erMTm6SGuE7h2sCxQ==
X-Received: by 2002:adf:fb90:0:b0:203:b456:c71e with SMTP id
 a16-20020adffb90000000b00203b456c71emr7641995wrr.244.1647602949228; 
 Fri, 18 Mar 2022 04:29:09 -0700 (PDT)
Received: from [192.168.2.27] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
 by smtp.gmail.com with ESMTPSA id
 v14-20020a7bcb4e000000b0034492fa24c6sm6423788wmj.34.2022.03.18.04.29.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 18 Mar 2022 04:29:08 -0700 (PDT)
Message-ID: <c857dcf8-024e-ab8a-fd26-295ce2e0ae41@gmail.com>
Date: Fri, 18 Mar 2022 12:29:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Coiby Xu <coxu@redhat.com>, kexec@lists.infradead.org
References: <20220318103423.286410-1-coxu@redhat.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <20220318103423.286410-1-coxu@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [RFC 0/4] Support kdump with LUKS encryption by
 reusing LUKS master key
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
 Dave Young <dyoung@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 18/03/2022 11:34, Coiby Xu wrote:
> With kdump enabled, when kernel crashes, the system could boot into the
> kdump kernel and dump the memory image i.e. /proc/vmcore to a specified
> target. Currently, when dumping vmcore to a LUKS encrypted device, there
> are two problems,
>   - for some machines, the user may don't have a chance enter the password
>     to decrypt the device after kernel crashes and kdump initrd is loaded
>   - LUKS2 by default use the memory-hard Argon2 key derivation function
>     which is quite memory-consuming compared to the limited memory reserved
>     for kdump. Take Fedora example, by default, only 256M is reserved for
>     systems having memory between 4G-64G. With LUKS enabled, ~1300M needs
>     to be reserved for kdump.
>   
> Besides the users (at least for Fedora) usually expect kdump to work out
> of the box i.e. no manual password input is needed. And it doesn't make
> sense to derivate the master key again in kdump kernel which seems to be
> redundant work.
> 
> Based on Milan's feedback [1] on Kairui's ideas to support kdump with
> LUKS encryption, this patch set addresses the above issues by

Hi,

I think you are creating another attack vector here, storing the encryption
key to yet another place... but I already mentioned that in the referenced mail.

Why is it not done through keyring and forcing kdump to retain key there
(under the same keyring key name as dm-crypt used)?
Kernel dm-crypt supports this already; LUKS2 uses keyring by default too.
That's all you need, or not? Why do you need to add another "kdump:" thing?
IOW why kdump cannot copy the key to keyring under the name dm-crypt
has in the mapping table and let dm-crypt activate the device almost without
code changes?

Anyway, please fix the naming before this patchset can be read or reviewed!

LUKS is user-space key management only (on-disk metadata); the kernel has
no idea how the key is derived or what LUKS is - dm-crypt only knows the key
(either through keyring or directly in the mapping table).

Polluting kernel namespace with "luks" names variables is wrong - dm-crypt
is used in many other mappings (plain, bitlocker, veracrypt, ...)
Just use the dm-crypt key, do not reference LUKS at all.

Milan



>   1) first saving the LUKS master key to kexec when opening the encrypted
>      device
>   2) then saving the master key to the reserved memory for kdump when
>      loading kdump kernel image.
> 
> So the LUKS master key never leaves the kernel space and once the key has
> been saved to the reserved memory for kdump, it would be wiped
> immediately. If there is no security concern with this approach or any
> other concern, I will drop the following assumptions made for this RFC
> version in v1,
>   - only x86 is supported
>   - there is only one LUKS device for the system
> 
> to extend the support to other architectures including POWER, ARM and
> s390x and address the case of multiple LUKS devices. Any feedback will be
> appreciated, thanks!
> 
> For a proof of concept, I've patched cryptsetup [2] in a quick-and-dirty
> way to support a new option "--kdump-kernel-master-key"
> and hacked systemd [3]. It works for Fedora 34.
> 
> [1] https://yhbt.net/lore/all/e5abd089-3398-fdb4-7991-0019be434b79@gmail.com/
> [2] https://gitlab.com/coxu/cryptsetup/-/commit/ee54bb15445da0bc3f9155a7227a9799da4dac20
> [3] https://github.com/coiby/systemd/tree/reuse_kdump_master_key
> 
> Coiby Xu (4):
>    kexec, dm-crypt: receive LUKS master key from dm-crypt and pass it to
>      kdump
>    kdump, x86: pass the LUKS master key to kdump kernel using a kernel
>      command line parameter luksmasterkey
>    crash_dump: retrieve LUKS master key in kdump kernel
>    dm-crypt: reuse LUKS master key in kdump kernel
> 
>   arch/x86/include/asm/crash.h      |  1 +
>   arch/x86/kernel/crash.c           | 42 ++++++++++++++++++-
>   arch/x86/kernel/kexec-bzimage64.c |  7 ++++
>   drivers/md/dm-crypt.c             | 26 +++++++++---
>   include/linux/crash_dump.h        |  4 ++
>   include/linux/kexec.h             |  7 ++++
>   kernel/crash_dump.c               | 69 +++++++++++++++++++++++++++++++
>   kernel/kexec_core.c               | 66 +++++++++++++++++++++++++++++
>   8 files changed, 215 insertions(+), 7 deletions(-)
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

