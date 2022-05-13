Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3813C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 13 May 2022 18:26:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-r2g0yFKmN0ClXBS-6LfwAA-1; Fri, 13 May 2022 14:26:55 -0400
X-MC-Unique: r2g0yFKmN0ClXBS-6LfwAA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 081E4101AA42;
	Fri, 13 May 2022 18:26:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 90B6742D4E4;
	Fri, 13 May 2022 18:26:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4D4C1193222E;
	Fri, 13 May 2022 18:26:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6F830194975B
 for <dm-devel@listman.corp.redhat.com>; Fri, 13 May 2022 18:26:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 47FB614C3B2B; Fri, 13 May 2022 18:26:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4475F14C3B20
 for <dm-devel@redhat.com>; Fri, 13 May 2022 18:26:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D0CA1C0512E
 for <dm-devel@redhat.com>; Fri, 13 May 2022 18:26:50 +0000 (UTC)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-PGPe30wHPDiOEWDtZhjZUQ-1; Fri, 13 May 2022 14:26:48 -0400
X-MC-Unique: PGPe30wHPDiOEWDtZhjZUQ-1
Received: by mail-pj1-f53.google.com with SMTP id
 cu23-20020a17090afa9700b001d98d8e53b7so8610497pjb.0
 for <dm-devel@redhat.com>; Fri, 13 May 2022 11:26:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
 :references:message-id:mime-version:content-transfer-encoding;
 bh=DWr88KXO8yOHtjVU6pqQ0YSnL6a33gTkT/ttelbBfAE=;
 b=npwjWoC7Smt38KCw6u4LdK1XEqZV7mGCtzx4wa6HFWF8qSzoa+nwyIb+GKg35Mo6pV
 VJwGCeRfGc4GgBKgNczlcstTCuVoWuTxqp/NKCeNVPg+Dk4ZuoPCEjbEdadJge7Qb1Cd
 iP3Ufk7WJxANvPnwdIRsbi/QM630pUCjk763WEtiNAEaCqkWzi+vCvc4mnmk23U+RR61
 sSMs68dOttQ+ZJLNkj9sQ6BX0WeRezZ9HX8OrXUqbSpTEqqYUo5UpXJdHeMSPSqTYkTK
 TYm4enkeIVDrp6vWxltt3fDBj3DLK+JLE6z6Ug8IiDEsgg+bLR2POEY4Zic2sDAticeC
 ortQ==
X-Gm-Message-State: AOAM531x8Sp11jwyzv4cJZXCokMfYl1fwf/JUPVC1052BLTlFb3UG5wc
 fACLqxTamhWSmKS6iHNd9l/2NA==
X-Google-Smtp-Source: ABdhPJzw+kzrYWctB0MM/hgYN5NeQJBlpaBicGatEKSdKPEQfZwTCnjWNjioRBrl/vmRGrxHaK9SGw==
X-Received: by 2002:a17:902:ecca:b0:15e:8971:4540 with SMTP id
 a10-20020a170902ecca00b0015e89714540mr5596247plh.43.1652466407389; 
 Fri, 13 May 2022 11:26:47 -0700 (PDT)
Received: from ?IPv6:::1? ([2607:fb90:3304:3e0:87ad:1d43:6a6e:afdd])
 by smtp.gmail.com with ESMTPSA id
 e16-20020a17090301d000b0015f2d549b46sm2150754plh.237.2022.05.13.11.26.46
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 13 May 2022 11:26:47 -0700 (PDT)
Date: Fri, 13 May 2022 11:26:44 -0700
From: Kees Cook <keescook@chromium.org>
To: Mike Snitzer <snitzer@redhat.com>, Matthias Kaehlcke <mka@chromium.org>
User-Agent: K-9 Mail for Android
In-Reply-To: <Yn6IDNgG+/ySOdmy@redhat.com>
References: <20220504195419.1143099-1-mka@chromium.org>
 <20220504125404.v3.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
 <Yn6IDNgG+/ySOdmy@redhat.com>
Message-ID: <56E309F0-C641-4E1C-9C7F-52198C43731E@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v3 2/3] LoadPin: Enable loading from trusted
 dm-verity devices
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
Cc: linux-security-module@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On May 13, 2022 9:32:12 AM PDT, Mike Snitzer <snitzer@redhat.com> wrote:
>On Wed, May 04 2022 at  3:54P -0400,
>Matthias Kaehlcke <mka@chromium.org> wrote:
>
>> Extend LoadPin to allow loading of kernel files from trusted dm-verity [1]
>> devices.
>> 
>> This change adds the concept of trusted verity devices to LoadPin. LoadPin
>> maintains a list of root digests of verity devices it considers trusted.
>> Userspace can populate this list through an ioctl on the new LoadPin
>> securityfs entry 'dm-verity'. The ioctl receives a file descriptor of
>> a file with verity digests as parameter. Verity reads the digests from
>> this file after confirming that the file is located on the pinned root.
>> The list of trusted digests can only be set up once, which is typically
>> done at boot time.
>> 
>> When a kernel file is read LoadPin first checks (as usual) whether the file
>> is located on the pinned root, if so the file can be loaded. Otherwise, if
>> the verity extension is enabled, LoadPin determines whether the file is
>> located on a verity backed device and whether the root digest of that
>> device is in the list of trusted digests. The file can be loaded if the
>> verity device has a trusted root digest.
>> 
>> Background:
>> 
>> As of now LoadPin restricts loading of kernel files to a single pinned
>> filesystem, typically the rootfs. This works for many systems, however it
>> can result in a bloated rootfs (and OTA updates) on platforms where
>> multiple boards with different hardware configurations use the same rootfs
>> image. Especially when 'optional' files are large it may be preferable to
>> download/install them only when they are actually needed by a given board.
>> Chrome OS uses Downloadable Content (DLC) [2] to deploy certain 'packages'
>> at runtime. As an example a DLC package could contain firmware for a
>> peripheral that is not present on all boards. DLCs use dm-verity to verify
>> the integrity of the DLC content.
>> 
>> [1] https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/verity.html
>> [2] https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/docs/developer.md
>> 
>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
>> ---
>> 
>> Changes in v3:
>> - added securityfs for LoadPin (currently only populated when
>>   CONFIG_SECURITY_LOADPIN_VERITY=y)
>> - added uapi include for LoadPin
>> - changed the interface for setting up the list of trusted
>>   digests from sysctl to ioctl on securityfs entry
>> - added stub for loadpin_is_fs_trusted() to be used
>>   CONFIG_SECURITY_LOADPIN_VERITY is not select
>> - depend on CONFIG_SECURITYFS instead of CONFIG_SYSTCL
>> - updated Kconfig help
>> - minor changes in read_trusted_verity_root_digests()
>> - updated commit message
>> 
>> Changes in v2:
>> - userspace now passes the path of the file with the verity digests
>>   via systcl, instead of the digests themselves
>> - renamed sysctl file to 'trusted_verity_root_digests_path'
>> - have CONFIG_SECURITY_LOADPIN_VERITY depend on CONFIG_SYSCTL
>> - updated Kconfig doc
>> - updated commit message
>> 
>>  include/uapi/linux/loadpin.h |  19 ++++
>>  security/loadpin/Kconfig     |  16 +++
>>  security/loadpin/loadpin.c   | 184 ++++++++++++++++++++++++++++++++++-
>>  3 files changed, 218 insertions(+), 1 deletion(-)
>>  create mode 100644 include/uapi/linux/loadpin.h
>
>I would certainly need some Reviewed-by:s from security and/or loadpin
>experts if I were to pick this patch up.

Alternatively, since it's mostly touching loadpin, I can carry it in my tree, as long as you've Acked the dm bits. :)

>Did you see the issues the kernel test robot emailed about?
>
>You'd do well to fix those issues up when submitting another revision
>of this patchset.

Agreed.


-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

