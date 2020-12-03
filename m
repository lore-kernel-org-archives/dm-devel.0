Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9634BC4167B
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 09:27:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0367922838
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 09:27:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0367922838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-rmZMi88sPOa-OirQugtcGQ-1; Fri, 04 Dec 2020 04:27:47 -0500
X-MC-Unique: rmZMi88sPOa-OirQugtcGQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA8FC107ACFE;
	Fri,  4 Dec 2020 09:27:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF40C1349A;
	Fri,  4 Dec 2020 09:27:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8691B5002E;
	Fri,  4 Dec 2020 09:27:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3NkvjN019065 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 18:46:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 890D3F11F3; Thu,  3 Dec 2020 23:46:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 82079F11F7
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 23:46:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 595AA800296
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 23:46:55 +0000 (UTC)
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com
	[209.85.215.194]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-64-WYMospvnNziS_5rcOgQ3iw-1; Thu, 03 Dec 2020 18:46:53 -0500
X-MC-Unique: WYMospvnNziS_5rcOgQ3iw-1
Received: by mail-pg1-f194.google.com with SMTP id e23so2375725pgk.12;
	Thu, 03 Dec 2020 15:46:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-transfer-encoding
	:content-language;
	bh=KfrfTn3DxHS1XxGJUGod2mjcoLRyxS0/sfri+AryIIA=;
	b=auXabeNyLnHXpMc6BHKxZKazHMND/hW74sfshx3J/tyTgGVzR6JOpbP/0+Wxl0eI7J
	V33SI7ot0J4sYjkS8AfcYg8e7agBAXZASLHdy7U/OND0jMHii1V6w2Lw8m9SFU63XzQW
	jZrVt2VuhvfPSzJlvX9IaJ6Oo+IBX5aTkaB/iAHX/N1zz0IhuxEbEW4q4j6gjWZeiko3
	/LEx0/CzFOGY1Ck1INQE6VWz7hLOiD0TX36Dy+qPTEbzRDbZo9oldhCyWrCjNhlJfqDz
	5KDYuTDuHmDoY5Zss0HO4RQ6tZAqQTveVBQNSiiJN2no7dSHmkVMDUKn/92JiRsuRxhA
	7hyA==
X-Gm-Message-State: AOAM530DI3xRQtOnkDBY0byvryWh7d5QiEXJQsBre4Y15kKtcJS2Y1dN
	TfjbYoUxPvqlCmD25jIAd9PDCtB7y07K4szf
X-Google-Smtp-Source: ABdhPJwfuW0Hafp7qRAdZ05Swl/oLl2myOjqSvzHm7K0GFgYXHYSOvYoIAUytDazkVGD2qpsOKEtgQ==
X-Received: by 2002:a62:5b05:0:b029:197:fafb:50f3 with SMTP id
	p5-20020a625b050000b0290197fafb50f3mr1327520pfb.76.1607039211483;
	Thu, 03 Dec 2020 15:46:51 -0800 (PST)
Received: from [192.168.0.12] ([125.186.151.199])
	by smtp.googlemail.com with ESMTPSA id
	e6sm321314pjr.34.2020.12.03.15.46.44
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Thu, 03 Dec 2020 15:46:50 -0800 (PST)
To: Sami Tolvanen <samitolvanen@google.com>
References: <20201203004659.95708-1-hyeongseok@gmail.com>
	<CABCJKufCS+hbXkGyO9uU3EBscfCpU1f7pi77uzR_+cjo97g=YQ@mail.gmail.com>
From: hyeongseok <hyeongseok@gmail.com>
Message-ID: <1939b1ec-b605-8a1a-8ff9-e50c36d60f66@gmail.com>
Date: Fri, 4 Dec 2020 08:46:39 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
	Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CABCJKufCS+hbXkGyO9uU3EBscfCpU1f7pi77uzR_+cjo97g=YQ@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 04 Dec 2020 04:27:20 -0500
Cc: device-mapper development <dm-devel@redhat.com>,
	=?UTF-8?B?6rmA7ZiV7ISd?= <hyeongseok.kim@lge.com>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm verity: skip verity work on I/O errors
 when system is shutting down
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: ko-KR
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 12/4/20 2:22 AM, Sami Tolvanen wrote:
> Hi,
>
> On Wed, Dec 2, 2020 at 4:48 PM Hyeongseok Kim <hyeongseok@gmail.com> wrote:
>> If emergency system shutdown is called, like by thermal shutdown,
>> dm device could be alive when the block device couldn't process
>> I/O requests anymore. In this status, the handling of I/O errors
>> by new dm I/O requests or by those already in-flight can lead to
>> a verity corruption state, which is misjudgment.
>> So, skip verity work for I/O error when system is shutting down.
> Thank you for the patch. I agree that attempting to correct I/O errors
> when the system is shutting down, and thus generating more I/O that's
> likely going to fail, is not a good idea.
>
>> Signed-off-by: Hyeongseok Kim <hyeongseok@gmail.com>
>> ---
>>   drivers/md/dm-verity-target.c | 12 +++++++++++-
>>   1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
>> index f74982dcbea0..ba62c537798b 100644
>> --- a/drivers/md/dm-verity-target.c
>> +++ b/drivers/md/dm-verity-target.c
>> @@ -64,6 +64,15 @@ struct buffer_aux {
>>          int hash_verified;
>>   };
>>
>> +/*
>> + * While system shutdown, skip verity work for I/O error.
>> + */
>> +static inline bool verity_is_system_shutting_down(void)
>> +{
>> +       return system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF
>> +               || system_state == SYSTEM_RESTART;
>> +}
> Which of these states does the system get to during an emergency
> shutdown? Can we simplify this by changing the test to system_state >
> SYSTEM_RUNNING?

I only saw that it was SYSTEM_POWER_OFF or SYSTEM_RESTART, I wonder if 
I/O error can occur in SYSTEM_SUSPEND state.
As far as I know, this could be happen in emergency shutdown case,
can you explain if you have a case when I/O error can occur by 
SYSTEM_SUSPEND?

>> +
>>   /*
>>    * Initialize struct buffer_aux for a freshly created buffer.
>>    */
>> @@ -564,7 +573,8 @@ static void verity_end_io(struct bio *bio)
>>   {
>>          struct dm_verity_io *io = bio->bi_private;
>>
>> -       if (bio->bi_status && !verity_fec_is_enabled(io->v)) {
>> +       if (bio->bi_status &&
>> +               (!verity_fec_is_enabled(io->v) || verity_is_system_shutting_down())) {
>>                  verity_finish_io(io, bio->bi_status);
>>                  return;
>>          }
> Otherwise, this looks good to me. However, I'm now wondering if an I/O
> error should ever result in verity_handle_err() being called. Without
> FEC, dm-verity won't call verity_handle_err() when I/O fails, but with
> FEC enabled, it currently does, assuming error correction fails. Any
> thoughts?

Yes, I have thought about this, and to be honest, I think verity or FEC 
should not call verity_handle_error() in case of I/O errors.
But, because I couldn't know the ability of FEC, I only focused on not 
breaking curent logics other than system shutdown && I/O errors case.

>
> Sami
>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

