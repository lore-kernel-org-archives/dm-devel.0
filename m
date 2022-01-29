Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33A1EC433F5
	for <dm-devel@archiver.kernel.org>; Sat, 29 Jan 2022 20:06:08 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-2yELa-AgNBa5wfCJGdeEjQ-1; Sat, 29 Jan 2022 15:06:04 -0500
X-MC-Unique: 2yELa-AgNBa5wfCJGdeEjQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAF4E814243;
	Sat, 29 Jan 2022 20:05:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DDCA57BE;
	Sat, 29 Jan 2022 20:05:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B08E34BB7C;
	Sat, 29 Jan 2022 20:05:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20TK5rc1004130 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 29 Jan 2022 15:05:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 78305C07F5C; Sat, 29 Jan 2022 20:05:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 73B6FC202C9
	for <dm-devel@redhat.com>; Sat, 29 Jan 2022 20:05:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AEEB1C01B82
	for <dm-devel@redhat.com>; Sat, 29 Jan 2022 20:05:53 +0000 (UTC)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com
	[209.85.208.51]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-22-G49OiCjEMa6r4mvL5JhwPg-1; Sat, 29 Jan 2022 15:05:47 -0500
X-MC-Unique: G49OiCjEMa6r4mvL5JhwPg-1
Received: by mail-ed1-f51.google.com with SMTP id l5so17722781edv.3;
	Sat, 29 Jan 2022 12:05:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=QD0MvXY/DLRTJKWozYIRmMRsoALg4L1cDrKiXVhNloY=;
	b=d62ZDuRBpiPAkw8sro9inrNKzHf3/WYMqClIuoYB/D7p+8JcOzA7TPDh0hHyfyW9gj
	xfna7PjlDznPhcpsu0v1kq6estz5jODSiHFf+aiqENt07c8gZV//EGdp/sVwPs5eMfEt
	XU9KYzTUe4NnUTJjY6wI9QssMWMolXp6/SZbqr/WSVBSQz4CEbkhcKYtiYl6rZ8K2gsh
	nBeJ8VBnJOPZUOBjF52CG+6pmtFc8f2I0rc+68IjJXTTMoFmON105j39EEmB4sZA9LQr
	VzYqvma5CDPT8c0sPHVADE7TX/JnwPv5FJqfL6B+FyYzIMENZkYsM8F9HXa1wXYDyR9B
	ToVA==
X-Gm-Message-State: AOAM533c1PYO+CLSryWXakNPn2fSaAxZmSAjf7Ad0OnjExlnI5tzYQ15
	G+b1uXdUq3o4qN47rhtDyaZgDnJ+D4tHRXhe
X-Google-Smtp-Source: ABdhPJzRgoDxt8jnwu8Hhnjx43blvvlF+EIAyq5RCMNym8p7ingaWYTAc15jPhf211lgMIUo/h6iZw==
X-Received: by 2002:a05:6402:5203:: with SMTP id
	s3mr13801704edd.389.1643486745202; 
	Sat, 29 Jan 2022 12:05:45 -0800 (PST)
Received: from [192.168.0.99] ([83.148.32.207])
	by smtp.gmail.com with ESMTPSA id
	lf16sm11327409ejc.25.2022.01.29.12.05.44
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sat, 29 Jan 2022 12:05:44 -0800 (PST)
Message-ID: <1b20e88f-2714-3c61-73a6-2f34f6a34edc@gmail.com>
Date: Sat, 29 Jan 2022 21:05:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Firefox/91.0 Thunderbird/91.4.0
To: Martin Wilck <mwilck@suse.com>, Zdenek Kabelac <zkabelac@redhat.com>,
	David Teigland <teigland@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>
References: <20220128134229.1783-1-mwilck@suse.com>
	<10ad6fc0-6c24-c98b-4a02-2140883af72d@gmail.com>
	<a1f472a89e9825f90a4104bea535086f0cde6b93.camel@suse.com>
	<d0d0d8f39257bcddf480524f01faae1f15ac2c42.camel@suse.com>
	<e85bd660-0c50-df5d-35de-2fd5b16cc47f@gmail.com>
	<0a55dd1393df2c125f8cb443daaeb7d1b7162bcc.camel@suse.com>
	<aba2f6dd-f4cf-6af4-e2b6-965f5de06cd8@redhat.com>
	<92de9eff521e2702e364f7aa3cce6927d9d9c03c.camel@suse.com>
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <92de9eff521e2702e364f7aa3cce6927d9d9c03c.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Heming Zhao <heming.zhao@suse.com>,
	Franck Bui <fbui@suse.de>, lvm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] udev: create symlinks and watch even in
	suspended state
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Dne 29. 01. 22 v 0:21 Martin Wilck napsal(a):
> On Fri, 2022-01-28 at 22:06 +0100, Zdenek Kabelac wrote:
>> Dne 28. 01. 22 v 19:46 Martin Wilck napsal(a):
>>> On Fri, 2022-01-28 at 18:47 +0100, Zdenek Kabelac wrote:
>>>> Dne 28. 01. 22 v 17:02 Martin Wilck napsal(a):
>>>>> On Fri, 2022-01-28 at 16:57 +0100, Martin Wilck wrote:
> Well it is at the point we need to know exactly which device in which
>> state
>> causes you problem. Then we need to see what is wrong in the whole
>> process.
> 
> This is how multipathd loads the multipath map before the error occurs:
> 
> [  127.352614] localhost multipathd[1059]: 3600a098000aad1e300000b4b5a275d45: reload [0 134217728 multipath 3 pg_init_retries 50 queue_if_no_path 1 alua 2 1 service-time 0 1 1 8:80 1 service-time 0 2 1 8:16 1 8:144 1]

> 
>> All I'm saying here is - that the proposed patch is not fixing bug -
>> but
>> rather masking/minimizing window for error.
> 
> AFAICS my patch eliminates the window for this error entirely.


Ok now I see that there is already skip for DM_SUSPENDED
and you patch likely only tries to preserve some existing state of links.

I'll need to get in touch with Peter here.

I guess the idea behind was to avoid read of device that will be resumed and 
will automatically get a new event - and suspened device itself cannot change 
- but that fact it's been loosing existing state was missed - I'm wondering 
why this was not seen as problem before.


Regars

Zdene

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

