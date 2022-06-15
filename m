Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27BBFC43334
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 17:51:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-u2wq2jbeN8mNgg6rxb_DtQ-1; Wed, 15 Jun 2022 13:51:45 -0400
X-MC-Unique: u2wq2jbeN8mNgg6rxb_DtQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57D96811E83;
	Wed, 15 Jun 2022 17:51:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8DB3740334F;
	Wed, 15 Jun 2022 17:51:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5CC111947041;
	Wed, 15 Jun 2022 17:51:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 35A9319466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 17:50:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0EABE1415107; Wed, 15 Jun 2022 17:50:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A4081415106
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 17:50:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E647C811E76
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 17:50:38 +0000 (UTC)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-HU_GgL9DO1uvcTZAEmPbAA-1; Wed, 15 Jun 2022 13:50:36 -0400
X-MC-Unique: HU_GgL9DO1uvcTZAEmPbAA-1
Received: by mail-pj1-f44.google.com with SMTP id gd1so11900499pjb.2
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:50:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=QfCF2UsmU1Pniv5Pf4uVgOiwJRRieSBYhaM8CMSmQ3U=;
 b=T8Ak99fsSI+fmAHRD6wb66cMCpfRZ/0OucSVtjbFEuGr6OYzT56N7ubRt5+MjpT61m
 nelSvSSJ2MVAfV9AVN9pft8AR7Mk5reU73hOS/THgwJyq7ZVLitWrV/uWcvVKrIACiyw
 dp9lvruNScg0vHA1aTO6Dtbb2T8FkakpsAAW0SYKg4DM9UHSBe79IhkBgQjFsvJrByLn
 M6vv7wgKn1JZAom1AfLQAXwWMCOS+WCKgUO3kWVzxmkaf6hyhsZ6yZwFvB6elQY1MVVF
 Uz+pzLSOjV1JR0fXKOUYIAZCepoPEQ4sczqlSpQbJhfMQzFgW8BoEm9ifY73j0hpO0O8
 NPkQ==
X-Gm-Message-State: AJIora/LFq9K5zJgDd0BFfmwupdJixfBOUlyBkIYRSkN7FeO34OSkQLy
 1r8+2MMBURvxK4jwYoeGQ9g=
X-Google-Smtp-Source: AGRyM1tuUWVOE9TzgSzU74eaIcQ/ZeNW5GN0XVRmVm0PRdEBUdPkL2L0CmPF+4r9OP3XWrBQYluWYQ==
X-Received: by 2002:a17:90b:3654:b0:1ea:4540:d32 with SMTP id
 nh20-20020a17090b365400b001ea45400d32mr11452858pjb.92.1655315435252; 
 Wed, 15 Jun 2022 10:50:35 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c?
 ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
 by smtp.gmail.com with ESMTPSA id
 h13-20020a17090a3d0d00b001ea5d9ae7d9sm2067433pjc.40.2022.06.15.10.50.33
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 15 Jun 2022 10:50:34 -0700 (PDT)
Message-ID: <50eeff2e-45c5-5eb2-c41d-3e0092a84483@roeck-us.net>
Date: Wed, 15 Jun 2022 10:50:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
To: Mike Snitzer <snitzer@kernel.org>
References: <20220603173816.944766454@linuxfoundation.org>
 <20220610042200.2561917-1-ovt@google.com> <YqLTV+5Q72/jBeOG@kroah.com>
 <YqNfBMOR9SE2TuCm@redhat.com> <Yqb/sT205Lrhl6Bv@kroah.com>
 <20220615143642.GA2386944@roeck-us.net> <Yqn64AMwoIzQXwXM@redhat.com>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <Yqn64AMwoIzQXwXM@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 5.4 26/34] dm verity: set DM_TARGET_IMMUTABLE
 feature flag
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
Cc: keescook@chromium.org, sarthakkukreti@google.com,
 Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Oleksandr Tymoshenko <ovt@google.com>, dm-devel@redhat.com,
 regressions@lists.linux.dev
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/15/22 08:29, Mike Snitzer wrote:
> On Wed, Jun 15 2022 at 10:36P -0400,
> Guenter Roeck <linux@roeck-us.net> wrote:
> 
>> On Mon, Jun 13, 2022 at 11:13:21AM +0200, Greg KH wrote:
>>> On Fri, Jun 10, 2022 at 11:11:00AM -0400, Mike Snitzer wrote:
>>>> On Fri, Jun 10 2022 at  1:15P -0400,
>>>> Greg KH <gregkh@linuxfoundation.org> wrote:
>>>>
>>>>> On Fri, Jun 10, 2022 at 04:22:00AM +0000, Oleksandr Tymoshenko wrote:
>>>>>> I believe this commit introduced a regression in dm verity on systems
>>>>>> where data device is an NVME one. Loading table fails with the
>>>>>> following diagnostics:
>>>>>>
>>>>>> device-mapper: table: table load rejected: including non-request-stackable devices
>>>>>>
>>>>>> The same kernel works with the same data drive on the SCSI interface.
>>>>>> NVME-backed dm verity works with just this commit reverted.
>>>>>>
>>>>>> I believe the presence of the immutable partition is used as an indicator
>>>>>> of special case NVME configuration and if the data device's name starts
>>>>>> with "nvme" the code tries to switch the target type to
>>>>>> DM_TYPE_NVME_BIO_BASED (drivers/md/dm-table.c lines 1003-1010).
>>>>>>
>>>>>> The special NVME optimization case was removed in
>>>>>> 5.10 by commit 9c37de297f6590937f95a28bec1b7ac68a38618f, so only 5.4 is
>>>>>> affected.
>>>>>>
>>>>>
>>>>> Why wouldn't 4.9, 4.14, and 4.19 also be affected here?  Should I also
>>>>> just queue up 9c37de297f65 ("dm: remove special-casing of bio-based
>>>>> immutable singleton target on NVMe") to those older kernels?  If so,
>>>>> have you tested this and verified that it worked?
>>>>
>>>> Sorry for the unforeseen stable@ troubles here!
>>>>
>>>> In general we'd be fine to apply commit 9c37de297f65 but to do it
>>>> properly would require also making sure commits that remove
>>>> "DM_TYPE_NVME_BIO_BASED", like 8d47e65948dd ("dm mpath: remove
>>>> unnecessary NVMe branching in favor of scsi_dh checks") are applied --
>>>> basically any lingering references to DM_TYPE_NVME_BIO_BASED need to
>>>> be removed.
>>>>
>>>> The commit header for 8d47e65948dd documents what
>>>> DM_TYPE_NVME_BIO_BASED was used for.. it was dm-mpath specific and
>>>> "nvme" mode really never got used by any userspace that I'm aware of.
>>>>
>>>> Sadly I currently don't have the time to do this backport for all N
>>>> stable kernels... :(
>>>>
>>>> But if that backport gets out of control: A simpler, albeit stable@
>>>> unicorn, way to resolve this is to simply revert 9c37de297f65 and make
>>
>> 9c37de297f65 can not be reverted in 5.4 and older because it isn't there,
>> and trying to apply it results in conflicts which at least I can not
>> resolve.
>>
>>>> it so that DM-mpath and DM core just used bio-based if "nvme" is
>>>> requested by dm-mpath, so also in drivers/md/dm-mpath.c e.g.:
>>>>
>>>> @@ -1091,8 +1088,6 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
>>>>
>>>>                          if (!strcasecmp(queue_mode_name, "bio"))
>>>>                                  m->queue_mode = DM_TYPE_BIO_BASED;
>>>> 			else if (!strcasecmp(queue_mode_name, "nvme"))
>>>> -                               m->queue_mode = DM_TYPE_NVME_BIO_BASED;
>>>> +                               m->queue_mode = DM_TYPE_BIO_BASED;
>>>>                          else if (!strcasecmp(queue_mode_name, "rq"))
>>>>                                  m->queue_mode = DM_TYPE_REQUEST_BASED;
>>>>                          else if (!strcasecmp(queue_mode_name, "mq"))
>>>>
>>>> Mike
>>>>
>>>
>>> Ok, please submit a working patch for the kernels that need it so that
>>> we can review and apply it to solve this regression.
>>>
>>
>> So, effectively, v5.4.y and older are broken right now for use cases
>> with dm on NVME drives.
>>
>> Given that the regression does affect older branches, and given that we
>> have to revert this patch to avoid regressions in ChromeOS, would it be
>> possible to revert it from v5.4.y and older until a fix is found ?
> 
> I obviously would prefer to not have this false-start.
> 
The false start has already happened since we had to revert the patch
from chromeos-5.4 and older branches.

Guenter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

