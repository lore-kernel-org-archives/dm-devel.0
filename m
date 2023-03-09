Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7DD7C64EC4
	for <dm-devel@archiver.kernel.org>; Thu,  9 Mar 2023 22:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678399939;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=x09TZecKZ37ioNtKG37KM4E6ssQT95j2o/iEsb886bk=;
	b=BhK9lqSTsM+n6h73ShtcHk9YFw663eO58fgVpW0aPsOz3ss+GgYEfVORVH4MqkK0Y4fytx
	+RXH8rU9tb5e6mVzzoHATuFmfzx/QeRyw3cOVq1mHbSC1OVAT2W5bFaUb4PHsCcKwQURsv
	mOmvbSQQ2M1w5p3VDRbQe9oh6yOcUyg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-ttukE4rWPs6m9M5rGog-ng-1; Thu, 09 Mar 2023 17:12:16 -0500
X-MC-Unique: ttukE4rWPs6m9M5rGog-ng-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1ADA29AB3F8;
	Thu,  9 Mar 2023 22:12:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8D1FB112132D;
	Thu,  9 Mar 2023 22:12:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4C32719465BC;
	Thu,  9 Mar 2023 22:12:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 465FD1946597
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Mar 2023 22:12:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4DE70140EBF4; Thu,  9 Mar 2023 22:12:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4656A1400B19
 for <dm-devel@redhat.com>; Thu,  9 Mar 2023 22:12:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AFDF85A5B1
 for <dm-devel@redhat.com>; Thu,  9 Mar 2023 22:12:05 +0000 (UTC)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-NKbTmfSQM1iK0Kw5z2CxFg-1; Thu, 09 Mar 2023 17:12:01 -0500
X-MC-Unique: NKbTmfSQM1iK0Kw5z2CxFg-1
Received: by mail-pg1-f178.google.com with SMTP id s18so1988411pgq.1
 for <dm-devel@redhat.com>; Thu, 09 Mar 2023 14:12:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678399919;
 h=to:references:message-id:content-transfer-encoding:cc:date
 :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=XOJo7gjc8Jpgy8I9PAF61QK85o+4Ab2zwWzwD4TUsyk=;
 b=k0OeICiKA+EkZExJpjHJCI+8x9fRaPzVVFyn4bmTGz3fZSUx8BoUiTcgLjrt2PvBvP
 yJul1Hf3El/FwVMN9R3olwTVj1vApHU1vYmlNcamxU1jiKee6G8bavX0WFe2evg4z7Bk
 7SC2+Nf0yI1aq0ThARFpYNqCrtnQf/joLf9b1B4pFCQv63dLt8dZ/q/JcPu6NsPZPdgr
 vBFFgOz8KIabQ81WLl4QG4FEM4XEpQtLWQN5LVTKfMXi2EKF0IUxiBNmiSdIYkDMIdT7
 7hAn1AO/vnypsoPNRXeGnG32b5ZO1bIVF3al1V66I7miUfiRraUBIL+H1G+Hn/D/nVyj
 81Nw==
X-Gm-Message-State: AO0yUKUS1IuTqFI+DUfnHvSs1jE4OA4p1g/zWNhyVgL9tQzj8SKTdtn5
 D0bekDtrfW6a4MwTfyvk9qHlCw+Mg6a4r2RKhCw=
X-Google-Smtp-Source: AK7set+Y/vTt6FEAcE7K7FFul4sTe1dEALWdQ84e9MDxnguL+1xTaM/vkbBKygnW5oULlKbBovGw2Q==
X-Received: by 2002:a62:65c1:0:b0:5cd:d766:8a2b with SMTP id
 z184-20020a6265c1000000b005cdd7668a2bmr21114758pfb.6.1678399919248; 
 Thu, 09 Mar 2023 14:11:59 -0800 (PST)
Received: from smtpclient.apple ([2600:1700:6970:bea0:dcda:e506:6dd9:9c4])
 by smtp.gmail.com with ESMTPSA id
 j14-20020a62e90e000000b005a8173829d5sm75507pfh.66.2023.03.09.14.11.58
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Thu, 09 Mar 2023 14:11:58 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
From: Brian Bunker <brian@purestorage.com>
In-Reply-To: <8569f8c6c9d16ecaf255056dd91cb46b5a813add.camel@suse.com>
Date: Thu, 9 Mar 2023 14:11:47 -0800
Message-Id: <88E8FF76-774E-4204-B0D9-F17B0BFBA2D7@purestorage.com>
References: <CAHZQxyJH1etLR5gHuWk4c6-ieioqA4GrJ173B60bnTppke58dw@mail.gmail.com>
 <4bc4be79c2d00cc959932ec935179a46be4b2fbc.camel@suse.com>
 <5A7BD289-0205-42FF-84CD-7C218511A280@purestorage.com>
 <fb99dac64dd41a6a44b3c7ce065608b45ff467c4.camel@suse.com>
 <C9BF0F84-BA7F-432C-A9A7-DC77DFE856CA@purestorage.com>
 <82cf76fe2b1949337064127eac3ca17c1082d0a7.camel@suse.com>
 <20230306190413.GL17327@octiron.msp.redhat.com>
 <eab31c43c11e5acfc750ee1d5e21df4e92641c31.camel@suse.com>
 <C4BBD0E1-F806-4EE8-8C4A-0EEA3E0C433A@purestorage.com>
 <555883fb00fa0769ef37a96e99095b2778ee8467.camel@suse.com>
 <A1AAA90F-3F7E-4C37-B23B-178022361884@purestorage.com>
 <8569f8c6c9d16ecaf255056dd91cb46b5a813add.camel@suse.com>
To: Martin Wilck <mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH] [PATCH] libmultipath: return 'ghost' state
 when port is in transition
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


> On Mar 9, 2023, at 1:50 PM, Martin Wilck <mwilck@suse.com> wrote:
> 
> Brian,
> 
> On Thu, 2023-03-09 at 13:40 -0800, Brian Bunker wrote:
>> 
>> Martin,
>> 
>> Sorry I bounce between kernel versions a lot since most of the
>> problems which find their way to us are released Linux versions
>> whose kernels are quite a bit older than upstream.I got a chance
>> to try the proposed solutions. The PATH_GHOST above does what
>> I am looking for which is not to have the path checker fail the path.
>> 
>> This also works as your earlier comments suggest. This does seem
>> clearer as to what is happening on the path:
>> 
> 
> I apologize for being slow, but I don't quite understand this response.
> Have you tested Ben's patch set? Does it work for you? Is the patch
> below meant to be applied on top of Ben's work?
> 
> Martin
Martin,

This is just a patch I made instead of the original patch to verify
using PATH_PENDING would work in our case, and it does. It has
no relationship to anything Ben was doing.

Thanks,
Brian
> 
>> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
>> index fdb91e17..50f0773e 100644
>> --- a/libmultipath/checkers.c
>> +++ b/libmultipath/checkers.c
>> @@ -343,6 +343,7 @@ static const char
>> *generic_msg[CHECKER_GENERIC_MSGTABLE_SIZE] = {
>>         [CHECKER_MSGID_UP] = " reports path is up",
>>         [CHECKER_MSGID_DOWN] = " reports path is down",
>>         [CHECKER_MSGID_GHOST] = " reports path is ghost",
>> +       [CHECKER_MSGID_PENDING] = " reports path is transitioning",
>>         [CHECKER_MSGID_UNSUPPORTED] = " doesn't support this device",
>>  };
>> 
>> diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
>> index ea1e8af6..4fbad621 100644
>> --- a/libmultipath/checkers.h
>> +++ b/libmultipath/checkers.h
>> @@ -111,6 +111,7 @@ enum {
>>         CHECKER_MSGID_UP,
>>         CHECKER_MSGID_DOWN,
>>         CHECKER_MSGID_GHOST,
>> +       CHECKER_MSGID_PENDING,
>>         CHECKER_MSGID_UNSUPPORTED,
>>         CHECKER_GENERIC_MSGTABLE_SIZE,
>>         CHECKER_FIRST_MSGID = 100,      /* lowest msgid for checkers
>> */
>> 
>> diff --git a/libmultipath/checkers/tur.c
>> b/libmultipath/checkers/tur.c
>> index 551dc4f0..e1742c2b 100644
>> --- a/libmultipath/checkers/tur.c
>> +++ b/libmultipath/checkers/tur.c
>> @@ -179,7 +179,7 @@ retry:
>>                 else if (key == 0x2) {
>>                         /* Not Ready */
>>                         /* Note: Other ALUA states are either UP or
>> DOWN */
>> -                       if( asc == 0x04 && ascq == 0x0b){
>> +                       if (asc == 0x04 && ascq == 0x0b) {
>>                                 /*
>>                                  * LOGICAL UNIT NOT ACCESSIBLE,
>>                                  * TARGET PORT IN STANDBY STATE
>> @@ -187,6 +187,14 @@ retry:
>>                                 *msgid = CHECKER_MSGID_GHOST;
>>                                 return PATH_GHOST;
>>                         }
>> +                       if (asc == 0x04 && ascq == 0x0a) {
>> +                               /*
>> +                                * LOGICAL UNIT NOT ACCESSIBLE,
>> +                                * TARGET PORT IN TRANSITION STATE
>> +                                */
>> +                               *msgid = CHECKER_MSGID_PENDING;
>> +                               return PATH_PENDING;
>> +                       }
>>                 }
>>                 *msgid = CHECKER_MSGID_DOWN;
>>                 return PATH_DOWN;
>> 
>> This change also keeps the path from being failed by the checker.
>> It seems to go into and out of transitioning from other states.
>> 
>> Thanks,
>> Brian 
>>> 
>>>>> 
>>>>> The default transitioning timeout is 60s, and in my experience,
>>>>> even if
>>>>> the hardware overrides it, it's rarely more than a few minutes.
>>>>> After
>>>>> that, the kernel will set the state to STANDBY.
>>>> Yes. The case of a target keeping a path in the transitioning
>>>> state
>>>> Indefinitely is handled by the device handler.
>>>>> 
>>>>> Unless we're both overlooking something, I agree with you that
>>>>> PATH_PENDING is the right thing to do for TRANSITIONING. When a
>>>>> device
>>>>> is in transition between states, we _want_ to check it often to
>>>>> make
>>>>> sure we notice when the target state is reached.
>>>>> 
>>>>> We must then be careful not to overload PATH_PENDING with too
>>>>> many
>>>>> different meanings. But I don't see this as a big issue
>>>>> currently.
>>>>> 
>>>>> Regards
>>>>> Martin
>>>>> 
>>>>>> Thoughts?
>>>>>> 
>>>>>> -Ben
>>>>>> 
>>>>>>> 
>>>>>>> Regards
>>>>>>> Martin
>> 
>> 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

