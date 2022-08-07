Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C7E1C19F2A
	for <dm-devel@archiver.kernel.org>; Sun,  7 Aug 2022 07:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659857875;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SjSzPvjkXKXVnPUO2njTA+zOEHS74j/3mwyS4OST1qg=;
	b=aYW5CF+OxEhC4XpMJ0nFkQvGnX1zklwLdfGK2hJ/T3sDyh48uXHOR4U+GJpeJ5Ar+Y9f5Z
	KD/SgxRf8fUvgpIJz1t158V1sY4t8QpLIDd2Vkgd+wh1x/mPyYqLdewKkRYlbreS8JJiKE
	DqCB/4frXBn9z5m2De1xy35zoQSRwyY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-PR17wT4FN2-jenwb9uGvEA-1; Sun, 07 Aug 2022 03:37:51 -0400
X-MC-Unique: PR17wT4FN2-jenwb9uGvEA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E4C9101A59C;
	Sun,  7 Aug 2022 07:37:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6E1101121314;
	Sun,  7 Aug 2022 07:37:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3C4291946A44;
	Sun,  7 Aug 2022 07:37:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 124FD1946A41
 for <dm-devel@listman.corp.redhat.com>; Sun,  7 Aug 2022 07:37:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 04B891415122; Sun,  7 Aug 2022 07:37:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 00D791415116
 for <dm-devel@redhat.com>; Sun,  7 Aug 2022 07:37:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCE0D101A596
 for <dm-devel@redhat.com>; Sun,  7 Aug 2022 07:37:44 +0000 (UTC)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com
 [209.85.218.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-pktTjwaHMPu-sKhe70rGOQ-1; Sun, 07 Aug 2022 03:37:43 -0400
X-MC-Unique: pktTjwaHMPu-sKhe70rGOQ-1
Received: by mail-ej1-f52.google.com with SMTP id uj29so11704566ejc.0;
 Sun, 07 Aug 2022 00:37:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=2tTk7KPbk5a0ODn5yTstWIPgCZZT6VooBB34NjkKZvU=;
 b=xrVlqiSZYC/MdHAEDYWDC+fs+cpzzF9u6bv5bDge8wxAm5mYje5fEEmY+WxyEmeqTG
 jaQdonMNavJjUSFuxP7r9/IEo0fdwFCXc8jYbPDj4+UDinaEhZUqGY7UEJ6wE46SmzK9
 GXzYX9skn2MeLhuXLAtmCEEqlR2ha7HBqNIMUwaOpw4g7sJ0VefSmVBPghNgUhwCHuMw
 ZIUhi4Bg/WqXhBhduk5isZ+rq/NX96KAmdJeXo2BW+CbrTlG7WH1kS3cFbZz4W5NK22i
 QxVvOs9XnGm8WClIrAv4PhCye/7T2n2ECG3jZX4wN4AUtKcT90AhwPfuKbpoTIk1netg
 rhXg==
X-Gm-Message-State: ACgBeo2IFbQPJQlvpEcbouQnXR1JDH/NyR7ZWFfEg8Y90Z+ta5SWFWXB
 K27/ksD6SzNpeqZs9k81kh0=
X-Google-Smtp-Source: AA6agR7on5CPYQbc2HorCagWm2setsQfuFUI6wus9ckKp/+QbDT092Q0Svm/NqfU3mjpB6xyImE0dQ==
X-Received: by 2002:a17:906:6a02:b0:730:9f44:2bff with SMTP id
 qw2-20020a1709066a0200b007309f442bffmr10154177ejc.209.1659857861898; 
 Sun, 07 Aug 2022 00:37:41 -0700 (PDT)
Received: from [192.168.2.27] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
 by smtp.gmail.com with ESMTPSA id
 lb22-20020a170907785600b0072f9e7ce354sm3530089ejc.139.2022.08.07.00.37.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 07 Aug 2022 00:37:41 -0700 (PDT)
Message-ID: <99e17678-8801-ac41-de20-a5f6f60da524@gmail.com>
Date: Sun, 7 Aug 2022 09:37:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Mike Snitzer <snitzer@kernel.org>
References: <YugiaQ1TO+vT1FQ5@redhat.com> <Yu1rOopN++GWylUi@redhat.com>
 <CAHk-=wj5w+Nga81wGmO6aYtcLrn6c_R_-gQrtnKwjzOZczko=A@mail.gmail.com>
 <Yu6zXVPLmwjqGg4V@redhat.com>
 <CAHk-=wj+ywtyBEp7pmEKxgwRE+iJBct6iih=ssGk2EWqaYL_yg@mail.gmail.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <CAHk-=wj+ywtyBEp7pmEKxgwRE+iJBct6iih=ssGk2EWqaYL_yg@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [git pull] Additional device mapper changes for 6.0
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
Cc: Eric Biggers <ebiggers@kernel.org>, Nathan Huckleberry <nhuck@google.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Sami Tolvanen <samitolvanen@google.com>, Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi,

Just a few notes on why we use target versions in libcryptsetup,
as I am perhaps one user of this field there.

TL;DR: it is *only* for hinting to users what is possibly wrong
after activation fails because there is *no* proper error reporting
from the device-mapper.

On 06/08/2022 20:36, Linus Torvalds wrote:
> On Sat, Aug 6, 2022 at 11:30 AM Mike Snitzer <snitzer@kernel.org> wrote:
...
>> Yes, I know you mentioned this before and I said I'd look to switch to
>> feature bitmasks. Yet here we are. Sorry about that, but I will take
>> a serious look at fixing this over the next development cycle(s).

Please don't just replace it with bitmaps.

It will not bring any better interface while adding more magic with
handling compatibility, as we need to use both... see below.

> Well, right now we're in the situation where there are certain kernels
> that say that they implement "version 1.9" of the thing, but they
> don't actually implement the "version 1.8.1" extensions.

I cannot speak for the others, but for veritysetup (libcryptsetup),
the worst that can happen is that the user will get a wrong error message
(or just a generic message "something failed, bye").
(All the crypto options are tricky, I would like to keep at least basic
usability and better errors like "seems tasklets are not supported,
retrying without tasklets flags.")

In principle, we use activation flags/options as Linus describes - try
to set it, then deal with the failure.

And *this* is the real problem that needs to be solved - there is no proper
userspace interface that says what went wrong.

The userspace sees only -EINVAL from ioctl() and a generic message.

Perhaps in the syslog is more info, but usually only at debug level
(that is often not visible), and parsing syslog is not the option for us either.

What is even more problematic is that the error string in DM target is
often set (e.g. ti->error = "Integrity profile tag size mismatch.";) but later
discarded, and it never reaches neither log nor userspace calling the failing
ioctl().

If the device-mapper can fix this, we can easily thrash the magic that
consults the target version and determines what went wrong.

Then you can forget the version and feature bitmaps and send
us a proper (ideally structured) error message in ioctl() reply.

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

