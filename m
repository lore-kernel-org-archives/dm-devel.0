Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089B9C43457
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 11:09:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 53BD8207F7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 11:09:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53BD8207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-hBOGzqx2Ovaszzs2EaKXaw-1; Fri, 16 Oct 2020 07:09:01 -0400
X-MC-Unique: hBOGzqx2Ovaszzs2EaKXaw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D261D801FD8;
	Fri, 16 Oct 2020 11:08:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6243A73690;
	Fri, 16 Oct 2020 11:08:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9920492F4C;
	Fri, 16 Oct 2020 11:08:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GB8rpR023595 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 07:08:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3E5C016C2DE; Fri, 16 Oct 2020 11:08:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3865A9D49D
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 11:08:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C4EA858295
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 11:08:51 +0000 (UTC)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
	[209.85.128.65]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-513-FHYDDjwNOzWLVO8-v8fE7Q-1; Fri, 16 Oct 2020 07:08:46 -0400
X-MC-Unique: FHYDDjwNOzWLVO8-v8fE7Q-1
Received: by mail-wm1-f65.google.com with SMTP id a72so1972391wme.5;
	Fri, 16 Oct 2020 04:08:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=CyeE9c0ri8DZaaJLpCbNjK0I2LZVtdcSzMHiFicWZdQ=;
	b=b1gSTO83ZXqCKTQ710dsmfBLslFaZEtWbovhZEoURFlmLDDRn9QLwRksEM6XvgkWEK
	o4CdyFPknF3KAZYBGP9TNPMo4QLIWqiGR5KKrd58DqkjcoziXeD/HfM1biwhy/KkKDpu
	YERuu+qqYH24YdvH6RAMaKsR6D1eHYHLQbzDmnRM67QKPLsS/r1zI0DSUd0q40RjcHqp
	Rg0Wbk9afBMqns8tXLir9WBzT4ALwN3YrvW6JNP7fNpu0FJIePG7xgIJLu+s9LiWD7TQ
	bvVNJaJv/tqKfFlp9aMXC9iGJXXI+9nZ0Im8CincBHkwKTmQkVjBLONfXLKKXtaMJkG4
	BnUw==
X-Gm-Message-State: AOAM530oppXCQb7yKVmjwsQbGHrlncV29mRt9yMzlJsA6o1Vc9pog+U6
	xOYcuEqUne8r2SKOUfz79ZK+vE8uaNI=
X-Google-Smtp-Source: ABdhPJyfD9ox0U8gcAU/f81G3qwY/85pZvnmT/4SOWBtl2/6lDsOXRSJQZEux9BYof6GQDQf5Y8aJw==
X-Received: by 2002:a1c:6488:: with SMTP id y130mr3213167wmb.94.1602846525351; 
	Fri, 16 Oct 2020 04:08:45 -0700 (PDT)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.gmail.com with ESMTPSA id 67sm2365255wmb.31.2020.10.16.04.08.44
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 16 Oct 2020 04:08:44 -0700 (PDT)
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
	Mike Snitzer <snitzer@redhat.com>
References: <20201015150504.1319098-1-mic@digikod.net>
	<20201015165229.GA5513@redhat.com>
	<022e949e-00c4-d98a-b536-1c5f9e05c09c@digikod.net>
	<b7ba2ff9-5f5f-8c1e-dfaa-33da56d3d8de@digikod.net>
From: Milan Broz <gmazyland@gmail.com>
Message-ID: <b7ccaa01-0398-f108-a70d-c67753d9fa6d@gmail.com>
Date: Fri, 16 Oct 2020 13:08:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <b7ba2ff9-5f5f-8c1e-dfaa-33da56d3d8de@digikod.net>
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
Cc: Deven Bowers <deven.desai@linux.microsoft.com>,
	linux-kernel@vger.kernel.org,
	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
	=?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>,
	dm-devel@redhat.com, linux-integrity@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alasdair Kergon <agk@redhat.com>,
	Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>
Subject: Re: [dm-devel] [PATCH v2] dm verity: Add support for signature
 verification with 2nd keyring
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"

On 16/10/2020 10:49, Micka=C3=ABl Sala=C3=BCn wrote:
> On 16/10/2020 10:29, Micka=C3=ABl Sala=C3=BCn wrote:
>>
>> On 15/10/2020 18:52, Mike Snitzer wrote:
>>> Can you please explain why you've decided to make this a Kconfig CONFIG
>>> knob?  Why not either add: a dm-verity table argument? A dm-verity
>>> kernel module parameter? or both (to allow a particular default but the=
n
>>> per-device override)?
>>
>> The purpose of signed dm-verity images is to authenticate files, or said
>> in another way, to enable the kernel to trust disk images in a flexible
>> way (i.e. thanks to certificate's chain of trust). Being able to update
>> such chain at run time requires to use the second trusted keyring. This
>> keyring automatically includes the certificate authorities from the
>> builtin trusted keyring, which are required to dynamically populate the
>> secondary trusted keyring with certificates signed by an already trusted
>> authority. The roots of trust must then be included at build time in the
>> builtin trusted keyring.
>>
>> To be meaningful, using dm-verity signatures implies to have a
>> restricted user space, i.e. even the root user has limited power over
>> the kernel and the rest of the system. Blindly trusting data provided by
>> user space (e.g. dm-verity table argument, kernel module parameter)
>> defeat the purpose of (mandatory) authenticated images.
>>
>>>
>>> Otherwise, _all_ DM verity devices will be configured to use secondary
>>> keyring fallback.  Is that really desirable?
>>
>> That is already the current state (on purpose).
>=20
> I meant that when DM_VERITY_VERIFY_ROOTHASH_SIG is set, dm-verity
> signature becomes mandatory. This new configuration
> DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING extend this trust to the
> secondary trusted keyring, which contains certificates signed (directly
> or indirectly) by CA from the builtin trusted keyring.
>=20
> So yes, this new (optional) configuration *extends* the source of trust
> for all dm-verity devices, and yes, it is desirable. I think it should
> have been this way from the beginning (as for other authentication
> mechanisms) but it wasn't necessary at that time.

Well, I understand why you need a config option here.
And using the secondary keyring actually makes much more sense to me than
the original approach.

But please do not forget that dm-verity is sometimes used in different
contexts where such strict in-kernel certificate trust is unnecessary.
With your configure options set, you deliberately remove the possibility
to configure such devices.
I understand that it is needed for "trusted" systems, but we should be clea=
r
in the documentation.
Maybe also add note to /Documentation/admin-guide/device-mapper/verity.rst =
?
We already mention DM_VERITY_VERIFY_ROOTHASH_SIG there.

The current userspace configuration through veritysetup does not need
any patches for your patch, correct?

Thanks,
Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

