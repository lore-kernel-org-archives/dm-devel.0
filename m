Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68DB7C3DA42
	for <dm-devel@archiver.kernel.org>; Wed, 19 Jul 2023 07:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689750200;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tYbmcSAtC9WjUkAMX8dYVgps00/Xw3Xxp/eE2dAGfzA=;
	b=Jj1cc9hgOY0QDdTADPS4Z41zR2NdxUCv6QXZ1/n+qdLanNkzDkB7KgVQCBN5gCUYLpFHFQ
	tG3LxfpqIm8XcQRh8rNy3/viZ5PI87H3AEkI/jvmk7eQsio3Rio8cB5UHr4ivQjC10ceQ3
	c5nmHSM3DhBfLaetnGNSxwa3M+yCB+s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-U3CDakEwOOq15qPhXBXX9g-1; Wed, 19 Jul 2023 03:03:16 -0400
X-MC-Unique: U3CDakEwOOq15qPhXBXX9g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0B4F936D23;
	Wed, 19 Jul 2023 07:03:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 29CAF2166B26;
	Wed, 19 Jul 2023 07:03:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DAA2E19465BC;
	Wed, 19 Jul 2023 07:03:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 64124194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Jul 2023 12:56:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 42683492B02; Tue, 18 Jul 2023 12:56:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 39D22492B01
 for <dm-devel@redhat.com>; Tue, 18 Jul 2023 12:56:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 198E0800B35
 for <dm-devel@redhat.com>; Tue, 18 Jul 2023 12:56:38 +0000 (UTC)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com
 [209.85.128.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-T0mcRn0qM2SslcLqRCKUJw-1; Tue, 18 Jul 2023 08:56:36 -0400
X-MC-Unique: T0mcRn0qM2SslcLqRCKUJw-1
Received: by mail-yw1-f182.google.com with SMTP id
 00721157ae682-57045429f76so55019497b3.0
 for <dm-devel@redhat.com>; Tue, 18 Jul 2023 05:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1689684995; x=1692276995;
 h=cc:to:subject:message-id:date:from:references:in-reply-to
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=a+0X0iJnqmGwLeZZKHvvTwxTTecPY5lyxNZQeh8dZFg=;
 b=dRobQ/ljR9xIXsCrnLCDFXD39yD6R0D05Wsfg4PIjkSNYKbobqvfjxgWBwQhmnG5Tq
 3/A+c00OzFtReSV5xDecKfwi/9KV2Tz3M/l319ovlfalSB8G9V2ROlSO5A67z4kdhsqZ
 O1PsL/gwKu5mB+L2YSB9ESwC7wrPtydU8goedb0vDLLN7K9Qyev5CzEgEEhWiWSoO6oa
 dMZ2jplbP55Wo6/aPzyX+bdlBqku9le0wOm8trCdx6w51WzWCpO80O+3eNv8hoNg2kDd
 hdy+TAll7Ea+QAy3eD8Odsl4QcTgL1DaSFvh1+vHDn91Q05kFTufLWMahx53Ek95rw7V
 N5rw==
X-Gm-Message-State: ABy/qLZOFEebreOorq+ijIacE6k0KvKluBFbVfLZvAnndT4EF0oBpFG2
 3sqWhNs052GpVbqXTKKwtfom4cvTsSI5Q/GiPEE=
X-Google-Smtp-Source: APBJJlGBp+5JYQ8bOuozx4yrJygeTAY50dwDQ7E9NrZdK+2yi1qtbmKH5Xu3Zq/ewQusx/ZrAy3f/VB59CoVOidMQKU=
X-Received: by 2002:a0d:c804:0:b0:577:3561:8a81 with SMTP id
 k4-20020a0dc804000000b0057735618a81mr15404153ywd.22.1689684995262; Tue, 18
 Jul 2023 05:56:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7108:7886:b0:31a:16:342c with HTTP; Tue, 18 Jul 2023
 05:56:34 -0700 (PDT)
In-Reply-To: <20230718053017.GB6042@tomerius.de>
References: <20230717075035.GA9549@tomerius.de>
 <CAG4Y6eTU=WsTaSowjkKT-snuvZwqWqnH3cdgGoCkToH02qEkgg@mail.gmail.com>
 <20230718053017.GB6042@tomerius.de>
From: "Alan C. Assis" <acassis@gmail.com>
Date: Tue, 18 Jul 2023 09:56:34 -0300
Message-ID: <CAG4Y6eQX8wE6ErByZmWFN+a_ekR09q8NzP+jJyEey4Ficqdosg@mail.gmail.com>
To: Kai Tomerius <kai@tomerius.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Wed, 19 Jul 2023 07:03:10 +0000
Subject: Re: [dm-devel] File system robustness
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
Cc: dm-devel@redhat.com, Ext4 Developers List <linux-ext4@vger.kernel.org>,
 linux-embedded@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Kai,

I never used that, but please take a look at F2FS too.

BR,

Alan

On 7/18/23, Kai Tomerius <kai@tomerius.de> wrote:
> Hi Alan,
>
> thx a lot.
>
> I should have mentioned that I'll have a large NAND flash, so ext4
> might still be the file system of choice. The other ones you mentioned
> are interesting to consider, but seem to be more fitting for a smaller
> NOR flash.
>
> Regards
> Kai
>
>
>
> On Mon, Jul 17, 2023 at 10:50:50AM -0300, Alan C. Assis wrote:
>> Hi Kai,
>>
>> On 7/17/23, Kai Tomerius <kai@tomerius.de> wrote:
>> > Hi,
>> >
>> > let's suppose an embedded system with a read-only squashfs root file
>> > system, and a writable ext4 data partition with data=journal.
>> > Furthermore, the data partition shall be protected with dm-integrity.
>> >
>> > Normally, I'd umount the data partition while shutting down the
>> > system. There might be cases though where power is cut. In such a
>> > case, there'll be ext4 recoveries, which is ok.
>> >
>> > How robust would such a setup be? Are there chances that the ext4
>> > requires a fsck? What might happen if fsck is not run, ever? Is there
>> > a chance that the data partition can't be mounted at all? How often
>> > might that happen?
>> >
>>
>> Please take a look at this document:
>>
>> https://elinux.org/images/0/02/Filesystem_Considerations_for_Embedded_Devices.pdf
>>
>> In general EXT4 is fine, but it has some limitation, more info here:
>> https://opensource.com/article/18/4/ext4-filesystem
>>
>> I think Linux users suffer from the same problem we have with NuttX (a
>> Linux-like RTOS): which FS to use?
>>
>> So for deep embedded systems running NuttX I follow this logic:
>>
>> I need better performance and wear leveling, but I don't need to worry
>> about power loss: I choose SmartFS
>>
>> I need good performance, wear leveling and some power loss protection:
>> SPIFFS
>>
>> I need good performance, wear leveling and good protection for
>> frequent power loss: LittleFS
>>
>> In a NuttShell: There is no FS that 100% meets all user needs, select
>> the FS that meets your core needs and do lots of field testing to
>> confirm it works as expected.
>>
>> BR,
>>
>> Alan
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

