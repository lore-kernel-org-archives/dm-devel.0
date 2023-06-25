Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D5D2EB64DC
	for <dm-devel@archiver.kernel.org>; Sun, 25 Jun 2023 16:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687710827;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7hAksxD15g0WrIrjwPlNI3zkcMJ7vcfcTS2hylJnvqw=;
	b=hvTy6hTbC8KX9BTyIXqFpYOZ+eDYGLkniw6kMzQ9bn2u7nTqg6LXeh7CmPXXC7rTQvdkam
	djD6qy10wuVYUeTx1w25be987bALbAYq+ISeVgX7ugSuCNt3MjoL+TsBC/VjwAJASTo3mq
	nnEbZEZdLvqJFv1rsG59puM/zIEIT+8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-hwR-iCliMWyclTVlbZcs7g-1; Sun, 25 Jun 2023 12:33:44 -0400
X-MC-Unique: hwR-iCliMWyclTVlbZcs7g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA112380350F;
	Sun, 25 Jun 2023 16:33:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7612E4087C6F;
	Sun, 25 Jun 2023 16:33:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 39BFD1946588;
	Sun, 25 Jun 2023 16:33:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6D20B1946587
 for <dm-devel@listman.corp.redhat.com>; Sun, 25 Jun 2023 16:33:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5742B40D1A4; Sun, 25 Jun 2023 16:33:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 38E0F40BB4D
 for <dm-devel@redhat.com>; Sun, 25 Jun 2023 16:33:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1ABE788CC42
 for <dm-devel@redhat.com>; Sun, 25 Jun 2023 16:33:40 +0000 (UTC)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com
 [209.85.218.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-d2l3pGATMHquz_jn4aOJsw-1; Sun, 25 Jun 2023 12:33:36 -0400
X-MC-Unique: d2l3pGATMHquz_jn4aOJsw-1
Received: by mail-ej1-f52.google.com with SMTP id
 a640c23a62f3a-988a2715b8cso650162366b.0; 
 Sun, 25 Jun 2023 09:33:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687710815; x=1690302815;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=nScTdQvpM7AM9qvgSXkt+CMEW4pA3CqvS9Ovt74lcv0=;
 b=I/HrSs3o/epa2xd5SxKhFSnGX6wXlLRAULFcaezPw5pTT8xuOoyyp3GFpkmHk6hvZn
 Xw//5JdDASA2qCYKfyUJcsIKlenNGFwbp03+Uqi/PYakfvkT6jzgju2085EY54J9y52D
 dE7n8PKpLPlkOkADi5XQiIVR5I8AA20Ti7cT9BqJusIIq/VRA9nTBMm6L23DqwC9BcA2
 EQSPnAJJo0C59JCk3P4g+xiKnDQojCuyzFBq7lhwSkIFHM1YW4jDjCZQIquAGqpc+R3y
 C0ChNfazbfiXs97XdHtlCzsZrGg8A5XQHkKtV0fIDgMR6Mykpk716KtQHR784OrNLfe6
 Y1+w==
X-Gm-Message-State: AC+VfDzuW1esN2CyQ2TcAu/prQrVZcrJHWCIxJi5rAXFZlgZv0HFWQat
 72nVoXgP7ADAPlO43bMgRj26VCRimw0=
X-Google-Smtp-Source: ACHHUZ6PsmNGxfQW9UahY8fUKpsiMFcjiehPqgjf+rQ9sLH2KLLOdDS0OjaAjry4/vghNsU8IxbYsw==
X-Received: by 2002:a17:907:3f87:b0:977:d660:c5aa with SMTP id
 hr7-20020a1709073f8700b00977d660c5aamr24821855ejc.31.1687710815044; 
 Sun, 25 Jun 2023 09:33:35 -0700 (PDT)
Received: from [192.168.2.30] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
 by smtp.gmail.com with ESMTPSA id
 gg18-20020a170906e29200b0098d2d219649sm2264553ejb.174.2023.06.25.09.33.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 25 Jun 2023 09:33:34 -0700 (PDT)
Message-ID: <81c94a1e-b316-c195-402c-01776f3200dc@gmail.com>
Date: Sun, 25 Jun 2023 18:33:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.12.0
To: Demi Marie Obenour <demi@invisiblethingslab.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
References: <20230624230950.2272-1-demi@invisiblethingslab.com>
 <20230624230950.2272-4-demi@invisiblethingslab.com>
 <0b22e328-40e1-54d7-367c-96059a3fef7c@gmail.com> <ZJhlGCP0gTz7T3gG@itl-email>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <ZJhlGCP0gTz7T3gG@itl-email>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v2 3/4] dm ioctl: Allow userspace to suppress
 uevent generation
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
Cc: linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/25/23 18:02, Demi Marie Obenour wrote:
> On Sun, Jun 25, 2023 at 03:25:38PM +0200, Milan Broz wrote:
>> On 6/25/23 01:09, Demi Marie Obenour wrote:
>>> Userspace can use this to avoid spamming udev with events that udev
>>> should ignore.
>>
>> Well, does it also mean that udev will not create /dev/disk/by-* symlinks
>> (as response to the change udev event followed by internal udev blkid scan)?
> 
> In the use-case I have for this feature (block devices for Qubes VMs)
> the blkid scan is unwanted and there are udev rules to prevent this.
> 
>> If it is a private device, that is ok. But for a visible device I think
>> that it breaks some assumptions in userspace (presence of symlinks mentioned
>> above etc).
> 
> The devices I am considering are implementation details of a userspace
> process.  Nobody else should be opening them.  Ideally, no other
> userspace process would even know they exist, at least without mucking
> around in /proc or using ptrace.
> 
>> So, what is the exact use for this patch?
> 
> Ephemeral devices that are created, opened, marked for deferred removal,
> assigned to a Xen VM (needs another patch currently being worked on),
> and then closed.  udev has no business scanning these devices, and
> indeed for it to scan them at all would be a security vulnerability
> since their contents are under guest control.  There are udev rules to
> ignore these devices, but for udev to even process the event wastes CPU
> time and delays processing of other events that actually matter.  The
> only symlink that possibly ought to be created is /dev/disk/by-diskseq
> and I can just do that myself.
But this is not clear from the patch header. I guess you also need
to disable udev inotify on close on write, which will trigger device scan too.

BTW we use exactly this scenario in cryptsetup for years with existing flags
(DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG | DM_UDEV_DISABLE_DISK_RULES_FLAG
DM_UDEV_DISABLE_OTHER_RULES_FLAG) - just rules are ignored while uevent is still
sent.
Anyway, not sure we need another way to disable it; I just asked do you need it.

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

