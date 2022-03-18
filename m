Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C15EC4332F
	for <dm-devel@archiver.kernel.org>; Mon, 21 Mar 2022 06:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647845698;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NU1wZhf4rXEQPQZ1GbhgLBTxpYuROZYevI9stSy0Rf4=;
	b=Hq9lWMfc8nshYr8f+t58/VwZBjt9BfNopg63zHd6vUEJeVvWbq7WxFxNhaBQdUNmER6Wyc
	cLT+wBuOL8jizOoYv1IhPJ0vc5mqFaQNI6ySicgq5c2Doe8UyOw2Wkqa1FOAo3cjVoOJqa
	Oh9vL/OtkGWiWAO3ut1wDZhEEcBU5iE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-PKsDIXY_PRmDs7WTU04ZFg-1; Mon, 21 Mar 2022 02:54:55 -0400
X-MC-Unique: PKsDIXY_PRmDs7WTU04ZFg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B1DF803792;
	Mon, 21 Mar 2022 06:54:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3965B492C14;
	Mon, 21 Mar 2022 06:54:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3549C193F6E4;
	Mon, 21 Mar 2022 06:54:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5F1BB194034E
 for <dm-devel@listman.corp.redhat.com>; Fri, 18 Mar 2022 12:22:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4AB1A57ECD5; Fri, 18 Mar 2022 12:22:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4747A57ECD2
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 12:22:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F929811E7A
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 12:22:28 +0000 (UTC)
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-I-wkt981PtWwf8Hgn6AdIQ-1; Fri, 18 Mar 2022 08:22:26 -0400
X-MC-Unique: I-wkt981PtWwf8Hgn6AdIQ-1
Received: by mail-pf1-f199.google.com with SMTP id
 s3-20020aa78bc3000000b004fa59ef2a34so2281556pfd.19
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 05:22:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=F/7MqHqnA/d3fd2dn1g8Wn6RSOs3VYhwPed/PsU780U=;
 b=SKGVG8XaBX13FcpF7mYhAKJVdvTCP2DH4k2W7x/thrNa5DkTJVbgczGVdvM5i6fUd6
 ANzre6yY2CvJEioKB4ztbeHM0LvnKFiuuiEgh6bZcIfMg9re2QcGpbhTZnlmgLgpCqBu
 x/gCb9HakxvQmW7z8v40kS+TGZY5NETlNOypChj4w7jgcCX08nDKAhvPq4quuriuJJQR
 j/dyUkbiTf+E2g8k+F8r45MWy1bVzeAttB2/Ojz8hR+5uP3BrNEIex3Aq2pZBNsZMuhk
 zb5//wjB0curFIKmgGf/O2mITTLKij+M5piq2ahTgDn7ZYKGh5eUFjJNz7To9EEU+9oQ
 6kmA==
X-Gm-Message-State: AOAM532uXAGXigT/DQuDyLTOvTQJM7jIvv1Ke2bi85yiDSRMDn3OmhMf
 JhXMysHnzFUd8/6N5oVu3lFiF5UznJbOmhvJwLWCDL5wx9Yslli278vHj+swh7NQSQgAkfqZiTb
 aHWTS/Bt0vuAHLMY=
X-Received: by 2002:a63:ab47:0:b0:375:5d05:9f79 with SMTP id
 k7-20020a63ab47000000b003755d059f79mr7741647pgp.192.1647606145724; 
 Fri, 18 Mar 2022 05:22:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3eshlaWJ8wd1uKp/z4Oud7qyQICGN8fQBVPH5X047r2w3jQXu3EAWGU+6TaSYzKdGlaizKA==
X-Received: by 2002:a63:ab47:0:b0:375:5d05:9f79 with SMTP id
 k7-20020a63ab47000000b003755d059f79mr7741630pgp.192.1647606145389; 
 Fri, 18 Mar 2022 05:22:25 -0700 (PDT)
Received: from localhost ([2a09:bac0:22::825:2bb2])
 by smtp.gmail.com with ESMTPSA id
 c14-20020a056a00248e00b004f77e0fbfc0sm9743322pfv.185.2022.03.18.05.22.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 18 Mar 2022 05:22:24 -0700 (PDT)
Date: Fri, 18 Mar 2022 20:21:10 +0800
From: Coiby Xu <coxu@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
Message-ID: <20220318122110.7qjrnrduwytjle3w@Rk>
References: <20220318103423.286410-1-coxu@redhat.com>
 <c857dcf8-024e-ab8a-fd26-295ce2e0ae41@gmail.com>
MIME-Version: 1.0
In-Reply-To: <c857dcf8-024e-ab8a-fd26-295ce2e0ae41@gmail.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Mon, 21 Mar 2022 06:54:49 +0000
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
 kexec@lists.infradead.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>, Thomas Staudt <tstaudt@de.ibm.com>,
 Dave Young <dyoung@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Milan,

On Fri, Mar 18, 2022 at 12:29:06PM +0100, Milan Broz wrote:
>On 18/03/2022 11:34, Coiby Xu wrote:
>>With kdump enabled, when kernel crashes, the system could boot into the
>>kdump kernel and dump the memory image i.e. /proc/vmcore to a specified
>>target. Currently, when dumping vmcore to a LUKS encrypted device, there
>>are two problems,
>>  - for some machines, the user may don't have a chance enter the password
>>    to decrypt the device after kernel crashes and kdump initrd is loaded
>>  - LUKS2 by default use the memory-hard Argon2 key derivation function
>>    which is quite memory-consuming compared to the limited memory reserved
>>    for kdump. Take Fedora example, by default, only 256M is reserved for
>>    systems having memory between 4G-64G. With LUKS enabled, ~1300M needs
>>    to be reserved for kdump.
>>Besides the users (at least for Fedora) usually expect kdump to work out
>>of the box i.e. no manual password input is needed. And it doesn't make
>>sense to derivate the master key again in kdump kernel which seems to be
>>redundant work.
>>
>>Based on Milan's feedback [1] on Kairui's ideas to support kdump with
>>LUKS encryption, this patch set addresses the above issues by
>
>Hi,
>
>I think you are creating another attack vector here, storing the encryption
>key to yet another place... but I already mentioned that in the referenced mail.

Thanks for the quick response! I thought the take-home message of the
referenced is we shouldn't leave the master key in the user space. Sorry 
I seem to still misunderstand what's mentioned in the referenced mail. But
take AES as an example, my reasoning is as follows:
   the expanded key has already been stored in "struct crypto_aes_ctx".
   If a hacker can somehow access the master key stored in the memory
   reserved exclusively for kdump, it means he/she can also access the
   expanded key stored in struct crypto_aes_ctx. So  not creating
   another attack vector?

>
>Why is it not done through keyring and forcing kdump to retain key there
>(under the same keyring key name as dm-crypt used)?
>Kernel dm-crypt supports this already; LUKS2 uses keyring by default too.
>That's all you need, or not? Why do you need to add another "kdump:" thing?
>IOW why kdump cannot copy the key to keyring under the name dm-crypt
>has in the mapping table and let dm-crypt activate the device almost without
>code changes?

Sorry, I haven't explained how kdump works. Once the 1st kernel crashes and
the system boots into the kdump kernel, the kdump kernel only have direct
access to the memory exclusively reserved for it i.e. the kdump kernel
loses the direct access to the keyring constructed in the 1st kernel. In
theory, the kdump kernel could do some "hacking" to find out the key
stored in the memory directly managed by the 1st kernel but I imagine
this would be difficult task (imagine I present the memory dump of my
computer to you and ask you to rebuild all the relevant kernel data
structures and find the key). Besides, it's not reliable to read the
memory directly managed by the first kernel for example the memory could
be corrupt. So we have to pass the master key from the 1st kernel to the kdump
kernel.

Btw, if we store the key in the kernel keyring, doesn't it mean storing the
"encryption key to another place" and thus creating "another attach vector"?

>
>Anyway, please fix the naming before this patchset can be read or reviewed!
>
>LUKS is user-space key management only (on-disk metadata); the kernel has
>no idea how the key is derived or what LUKS is - dm-crypt only knows the key
>(either through keyring or directly in the mapping table).
>
>Polluting kernel namespace with "luks" names variables is wrong - dm-crypt
>is used in many other mappings (plain, bitlocker, veracrypt, ...)
>Just use the dm-crypt key, do not reference LUKS at all.

Thanks for pointing out my mistake of misusing the word LUKS! I'll fix this
error once we settle down what's the correct approach to reuse master
key for the kdump kernel.

>
>Milan
>
>
>
>>  1) first saving the LUKS master key to kexec when opening the encrypted
>>     device
>>  2) then saving the master key to the reserved memory for kdump when
>>     loading kdump kernel image.
>>
>>So the LUKS master key never leaves the kernel space and once the key has
>>been saved to the reserved memory for kdump, it would be wiped
>>immediately. If there is no security concern with this approach or any
>>other concern, I will drop the following assumptions made for this RFC
>>version in v1,
>>  - only x86 is supported
>>  - there is only one LUKS device for the system
>>
>>to extend the support to other architectures including POWER, ARM and
>>s390x and address the case of multiple LUKS devices. Any feedback will be
>>appreciated, thanks!
>>
>>For a proof of concept, I've patched cryptsetup [2] in a quick-and-dirty
>>way to support a new option "--kdump-kernel-master-key"
>>and hacked systemd [3]. It works for Fedora 34.
>>
>>[1] https://yhbt.net/lore/all/e5abd089-3398-fdb4-7991-0019be434b79@gmail.com/
>>[2] https://gitlab.com/coxu/cryptsetup/-/commit/ee54bb15445da0bc3f9155a7227a9799da4dac20
>>[3] https://github.com/coiby/systemd/tree/reuse_kdump_master_key
>>
>>Coiby Xu (4):
>>   kexec, dm-crypt: receive LUKS master key from dm-crypt and pass it to
>>     kdump
>>   kdump, x86: pass the LUKS master key to kdump kernel using a kernel
>>     command line parameter luksmasterkey
>>   crash_dump: retrieve LUKS master key in kdump kernel
>>   dm-crypt: reuse LUKS master key in kdump kernel
>>
>>  arch/x86/include/asm/crash.h      |  1 +
>>  arch/x86/kernel/crash.c           | 42 ++++++++++++++++++-
>>  arch/x86/kernel/kexec-bzimage64.c |  7 ++++
>>  drivers/md/dm-crypt.c             | 26 +++++++++---
>>  include/linux/crash_dump.h        |  4 ++
>>  include/linux/kexec.h             |  7 ++++
>>  kernel/crash_dump.c               | 69 +++++++++++++++++++++++++++++++
>>  kernel/kexec_core.c               | 66 +++++++++++++++++++++++++++++
>>  8 files changed, 215 insertions(+), 7 deletions(-)
>>
>

-- 
Best regards,
Coiby

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

