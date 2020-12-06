Return-Path: <SRS0=+j0W=FL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBB5C433FE
	for <dm-devel@archiver.kernel.org>; Mon,  7 Dec 2020 10:00:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 835BB2310B
	for <dm-devel@archiver.kernel.org>; Mon,  7 Dec 2020 10:00:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 835BB2310B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-Kc9yypJ1P7envkpXlKJ13Q-1; Mon, 07 Dec 2020 05:00:18 -0500
X-MC-Unique: Kc9yypJ1P7envkpXlKJ13Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2441E1934100;
	Mon,  7 Dec 2020 09:59:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 064C85C1A1;
	Mon,  7 Dec 2020 09:59:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D0A361809CA0;
	Mon,  7 Dec 2020 09:59:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B6NIrxf015102 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 6 Dec 2020 18:18:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 32FF94405B; Sun,  6 Dec 2020 23:18:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D42F44056
	for <dm-devel@redhat.com>; Sun,  6 Dec 2020 23:18:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83C42800BFF
	for <dm-devel@redhat.com>; Sun,  6 Dec 2020 23:18:49 +0000 (UTC)
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com
	[209.85.210.194]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-435-DkfscmPfNSOEM2-eRxzVhg-1; Sun, 06 Dec 2020 18:18:44 -0500
X-MC-Unique: DkfscmPfNSOEM2-eRxzVhg-1
Received: by mail-pf1-f194.google.com with SMTP id 131so7936875pfb.9;
	Sun, 06 Dec 2020 15:18:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-transfer-encoding
	:content-language;
	bh=T5Px40OBZhk7ZnsHhTXs63zRee5s/rImgDIEKj2p5AY=;
	b=GEQ+Wm48lNZfdpS4zuWn1+5oYaY/rIoLWvXjvst7AXQWrkMB4hemopijsiyLpw2OGv
	/CUaEf8XI0i7hTl7uO+WjmnMMtg1GvTHpFf7dhp+bBFIPnwWjRz9fjlanM+dh4Rr6rMr
	kt2pxGh5mkcM+CaRXoxa9/AK4PQ7cmuKoXvwOp7RD1EM/jy+c1LZSBL4ytIU8hyqI7Ep
	nIqkLiC/CaODkC3fRdkBdCZy+Qxdqnnda5AQYZLZIZDfC0K9d9FpYmyqQpiFcDtfOKEJ
	H9xvFQkKYLfM3a5pkLL7k98eYV8w0qPJgEKsIBo2grO6xOJfPs6iNorb0IncP8og3QST
	j/6A==
X-Gm-Message-State: AOAM533vWvFg9m5TvAOqNvoN8AkGbj82gq9RE8cViuOFcgeUxC9+8C/7
	YkxMGadLxJGxV20qcEkvttgAj2J89Vy+EQ==
X-Google-Smtp-Source: ABdhPJwAtRbUkXh8Jk2oGH/ofys3l4NpHjoEF3gpNY03DU+t0o8BCCqM9xNJb0IAZhmpzSwflgIYaQ==
X-Received: by 2002:a65:4544:: with SMTP id x4mr16578999pgr.183.1607296723337; 
	Sun, 06 Dec 2020 15:18:43 -0800 (PST)
Received: from [192.168.0.12] ([125.186.151.199])
	by smtp.googlemail.com with ESMTPSA id
	u205sm12164922pfc.146.2020.12.06.15.18.41
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Sun, 06 Dec 2020 15:18:42 -0800 (PST)
To: Sami Tolvanen <samitolvanen@google.com>
References: <20201203004659.95708-1-hyeongseok@gmail.com>
	<CABCJKufCS+hbXkGyO9uU3EBscfCpU1f7pi77uzR_+cjo97g=YQ@mail.gmail.com>
	<1939b1ec-b605-8a1a-8ff9-e50c36d60f66@gmail.com>
	<CABCJKueAPHNqdq=k6AhhxDR-oQdNs8+=BhmY8wGdgNcwr_-KMQ@mail.gmail.com>
From: hyeongseok <hyeongseok@gmail.com>
Message-ID: <7fda3da9-e0b1-abdd-4bde-3a46405536f5@gmail.com>
Date: Mon, 7 Dec 2020 08:18:39 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
	Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CABCJKueAPHNqdq=k6AhhxDR-oQdNs8+=BhmY8wGdgNcwr_-KMQ@mail.gmail.com>
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
X-Mailman-Approved-At: Mon, 07 Dec 2020 04:59:37 -0500
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: ko-KR
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 12/5/20 8:03 AM, Sami Tolvanen wrote:
> On Thu, Dec 3, 2020 at 3:46 PM hyeongseok <hyeongseok@gmail.com> wrote:
>> On 12/4/20 2:22 AM, Sami Tolvanen wrote:
>>> Hi,
>>>
>>> On Wed, Dec 2, 2020 at 4:48 PM Hyeongseok Kim <hyeongseok@gmail.com> wrote:
>>>> If emergency system shutdown is called, like by thermal shutdown,
>>>> dm device could be alive when the block device couldn't process
>>>> I/O requests anymore. In this status, the handling of I/O errors
>>>> by new dm I/O requests or by those already in-flight can lead to
>>>> a verity corruption state, which is misjudgment.
>>>> So, skip verity work for I/O error when system is shutting down.
>>> Thank you for the patch. I agree that attempting to correct I/O errors
>>> when the system is shutting down, and thus generating more I/O that's
>>> likely going to fail, is not a good idea.
>>>
>>>> Signed-off-by: Hyeongseok Kim <hyeongseok@gmail.com>
>>>> ---
>>>>    drivers/md/dm-verity-target.c | 12 +++++++++++-
>>>>    1 file changed, 11 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
>>>> index f74982dcbea0..ba62c537798b 100644
>>>> --- a/drivers/md/dm-verity-target.c
>>>> +++ b/drivers/md/dm-verity-target.c
>>>> @@ -64,6 +64,15 @@ struct buffer_aux {
>>>>           int hash_verified;
>>>>    };
>>>>
>>>> +/*
>>>> + * While system shutdown, skip verity work for I/O error.
>>>> + */
>>>> +static inline bool verity_is_system_shutting_down(void)
>>>> +{
>>>> +       return system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF
>>>> +               || system_state == SYSTEM_RESTART;
>>>> +}
>>> Which of these states does the system get to during an emergency
>>> shutdown? Can we simplify this by changing the test to system_state >
>>> SYSTEM_RUNNING?
>> I only saw that it was SYSTEM_POWER_OFF or SYSTEM_RESTART, I wonder if
>> I/O error can occur in SYSTEM_SUSPEND state.
> OK, so think the current version is fine then.
>
>> As far as I know, this could be happen in emergency shutdown case,
>> can you explain if you have a case when I/O error can occur by
>> SYSTEM_SUSPEND?
> No, I don't have a case where that would happen.
>
>>> Otherwise, this looks good to me. However, I'm now wondering if an I/O
>>> error should ever result in verity_handle_err() being called. Without
>>> FEC, dm-verity won't call verity_handle_err() when I/O fails, but with
>>> FEC enabled, it currently does, assuming error correction fails. Any
>>> thoughts?
>> Yes, I have thought about this, and to be honest, I think verity or FEC
>> should not call verity_handle_error() in case of I/O errors.
> I tend to agree. We could simply check the original bio->bi_status in
> verity_verify_io() and if we failed to correct an I/O error, return an
> error instead of going into verity_handle_err(). Any thoughts?
>
>> But, because I couldn't know the ability of FEC, I only focused on not
>> breaking curent logics other than system shutdown && I/O errors case.
> Sure, makes sense. We can addrwess that separately.
Sounds reasonable. I hope the next improvements.
>
> Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
>
> Sami
>
Thank you for the review.

Hyeongseok

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

