Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D46FC25B0C
	for <dm-devel@archiver.kernel.org>; Sun,  7 Aug 2022 19:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659902029;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dyaJG4pQM15v19iJoRbXRXY5ffikANPOKpiobEni11A=;
	b=bI9RAJ/SMrZA1ZdBvyKG3ZW2MtcdMvqjGNsVxDVjEkonowWI1pXzjhOog4seE93J2Z73PU
	+y2fFdZGW9qat3rjxFCfqTTUjMQJkK4NTyrDML2MCMRSOCBYO+73KaK7iswZ7hTdA8iDFy
	DjTFqNnDwGlwH5e+7teGgZjzwTSASa0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-aC0G1KWzPgakXUewTjw8vA-1; Sun, 07 Aug 2022 15:53:46 -0400
X-MC-Unique: aC0G1KWzPgakXUewTjw8vA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3903780A0BF;
	Sun,  7 Aug 2022 19:53:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A91DCC202C5;
	Sun,  7 Aug 2022 19:53:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7974E1946A44;
	Sun,  7 Aug 2022 19:53:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 154A11946A41
 for <dm-devel@listman.corp.redhat.com>; Sun,  7 Aug 2022 19:53:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 062A42166B29; Sun,  7 Aug 2022 19:53:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 026E72166B26
 for <dm-devel@redhat.com>; Sun,  7 Aug 2022 19:53:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D76EF802D1C
 for <dm-devel@redhat.com>; Sun,  7 Aug 2022 19:53:40 +0000 (UTC)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com
 [209.85.208.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-213-6Zgs5rSoNX6_3BJnyHCJxw-1; Sun, 07 Aug 2022 15:53:38 -0400
X-MC-Unique: 6Zgs5rSoNX6_3BJnyHCJxw-1
Received: by mail-ed1-f54.google.com with SMTP id f22so9075507edc.7;
 Sun, 07 Aug 2022 12:53:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=KSNjU/g/uABeK7DgJdNs6bpwX7SttrPrrtSMzcFQBU4=;
 b=uVP60YISOf5zPYHIBG2Q/l37UHl6K2BLcfUZJk/4ehJ+marchJP7eU0ZmyXKnsNRUL
 f6kVw5WFpfsbL7s6ASwdppMmIBixS5hM1YxQEUu1D8+ye8OnANWga2uZDWxSY6aKI8hf
 XxhGtENe/dYsif3d40VZB53aq8Y7oGWWF2m2RepcmPuvS7yy6tUt1LFwyY8ihF/JPcAD
 adQ5b9NzxD9qlHRFXYgEHd5/KryTrgxpTZDwwk/HQsg0B0qqW7mdy6Pf8ufI3dKVfvGb
 9HHgYDx+xkEUAmyNupiLysSxTeSLW15M8mROmFNZH8qAh5hEImTylRfl1AJwi2mb3n9a
 dJdw==
X-Gm-Message-State: ACgBeo1fOOcKjMTCl+l4sacp6Y8aSEI8PBS0NLlFYVc461dwQzqt3O8A
 bkEDsJ3luFghxXL0afLRgiM=
X-Google-Smtp-Source: AA6agR7x9Zl9jxGqHa/qimd6JaBS49eiXMcJU+FuL/emsWO/J+uT2G5Y1LOCkzPTsmZv/38KN8YGVQ==
X-Received: by 2002:a05:6402:1e88:b0:43c:e8d4:bf27 with SMTP id
 f8-20020a0564021e8800b0043ce8d4bf27mr15616183edf.401.1659902017188; 
 Sun, 07 Aug 2022 12:53:37 -0700 (PDT)
Received: from [192.168.2.28] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
 by smtp.gmail.com with ESMTPSA id
 bf17-20020a0564021a5100b0043df042bfc6sm3566644edb.47.2022.08.07.12.53.36
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 07 Aug 2022 12:53:36 -0700 (PDT)
Message-ID: <731828af-0ef3-ba04-7115-be8f1d41e1c5@gmail.com>
Date: Sun, 7 Aug 2022 21:53:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Mike Snitzer <snitzer@kernel.org>
References: <YugiaQ1TO+vT1FQ5@redhat.com> <Yu1rOopN++GWylUi@redhat.com>
 <CAHk-=wj5w+Nga81wGmO6aYtcLrn6c_R_-gQrtnKwjzOZczko=A@mail.gmail.com>
 <Yu6zXVPLmwjqGg4V@redhat.com>
 <CAHk-=wj+ywtyBEp7pmEKxgwRE+iJBct6iih=ssGk2EWqaYL_yg@mail.gmail.com>
 <99e17678-8801-ac41-de20-a5f6f60da524@gmail.com>
 <YvAA8fI37owuSe7y@redhat.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <YvAA8fI37owuSe7y@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
Cc: linux-block@vger.kernel.org, Nathan Huckleberry <nhuck@google.com>,
 Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Sami Tolvanen <samitolvanen@google.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Mike,

there was nothing personal in my reply - sorry
if you see it this way.

Anyway, please stop ad-hominem attacks on me!

I just described what I see as a problem that prevents
us from dropping version parsing.

Technical comments, below, but really, these should go to
dm-devel only to not waste time of others.

On 07/08/2022 20:14, Mike Snitzer wrote:
>> TL;DR: it is *only* for hinting to users what is possibly wrong
>> after activation fails because there is *no* proper error reporting
>> from the device-mapper.
> 
> DM's core and target versions aren't intended to be in service of
> error reporting. You abusing them like that is a fundamental problem.

Perhaps, but there was nothing better. If I missed something,
we can definitely make the code better.

TBH, I do even think that it uses the same logic as libdevmapper library
(and perhaps it dates even before I started to maintain it).

I do not see fundamental problem here, though.

I take is as "The dm-integrity was introduced in kernel/target X",
then I do not expect it working in X-1...

>> Please don't just replace it with bitmaps.
>>
>> It will not bring any better interface while adding more magic with
>> handling compatibility, as we need to use both... see below.
> 
> (I saw your "below", it lacked a coherent explanation for why "we need
> to use both" as a rule moving forward)
> 
> When done properly it will _not_ require both. The version number would
> be incremented one final time and would serve to allow existing
> userspace to run unmodified. But from that point on the bitmap flags
> should be used and all userspace converted to use them.

I just meant that if userspace want to support older kernels,
we need to support both.

If it does not bring fixes for the problem I described, it is just
more code with no effect (for libcryptsetup).

But if you see other reasons, then of course it makes sense.

>> I cannot speak for the others, but for veritysetup (libcryptsetup),
>> the worst that can happen is that the user will get a wrong error message
>> (or just a generic message "something failed, bye").
> 
> You know how to send email to report specific problems and/or submit
> patches. But I really don't recall anything in this category being
> reported by you, certainly not recently... maybe you've just
> internalized or I somehow missed it?

I am sure I mentioned this, but years ago... what I am talking about

1) Some ti->error messages are lost, e.g. in dm-crypt,
   I think example is IV generators constructors
   if (ret < 0) {
      ti->error = "Error creating IV";
   ...
   (And yes, I should fix this myself.)


2) Targets use macros like DMERR, these generate syslog message.
    Getting these messages into userspace is problematic.

    But perhaps this is more problem for libdevmapper we use.

>> (All the crypto options are tricky, I would like to keep at least basic
>> usability and better errors like "seems tasklets are not supported,
>> retrying without tasklets flags.")
> 
> dm-verity's optional "try_verify_in_tasklet" is using tasklets as an
> implementation detail, if they cannot be used (e.g. for FEC) then why
> would fallback to normal verification using a workqueue be reported?

I am talking about situation when user explicitly requests to use tasklets
on CLI and kernel does not support it. Then there must be an error message.

I am not sure if we should automatically fallback to non-tasklets,
but we do this already in other situations (enable-discards, keyring support, ...)

> 
> Or are you referring to something you saw when using dm-crypt's
> no_{read,write}_workqueue options?
> 
> Or are you saying that both the new dm-verity try_verify_in_tasklet
> option and the dm-crypt no_{read,write}_workqueue options should
> fallback to removing those flags and try without them?
> 
> That is a level of AI I have no interest in adding or supporting.
> The user asked for something, if it isn't possible then it should
> fail.

And nobody asked for this as we are already doing this in userspace.

It was really just example to demonstrate when we use target version.

> "Please extend the DM ioctls to somehow add ti->error to the userspace
> response" is a fine feature request. Should help no matter what.
> 
> (Can look to have a phased approach to the error reporting payload,
> start with errno and error message, add more "structured" payload over
> time. Are you referring to JSON or some other format? Whatever systemd
> uses?).

Great, let's discuss this later.

> 
>> Perhaps in the syslog is more info, but usually only at debug level
>> (that is often not visible), and parsing syslog is not the option for us either.
> 
> All errors should be emitted with pr_err() using DMERR(). I've made a
> conscious effort to convert DMWARN() to DMERR() when appropriate. But
> I'll audit all the DM core code and then work through the various
> targets.
> 
> If there are incorrect log levels being used it is a bug, please
> report and/or fix.

Yes, I tried to say that syslog itself as source is problematic
(if you activate many devices in parallel; in multi-tenant environment
when you should not see logs from different users etc).

> There is no way to properly use version numbers to derive what
> actually went wrong. Could you narrow down and isolate the possible
> failure based on version in specific cases? Sure.. but it is insanely
> fragile (especially with stable@ and distro kernels).

It works pretty reliably for years with some minor exceptions that
can be ignored.

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

