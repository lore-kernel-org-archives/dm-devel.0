Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D969C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 17 Jan 2022 10:53:29 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-78PKHX4cNY-6F4uyXJ6sJA-1; Mon, 17 Jan 2022 05:53:23 -0500
X-MC-Unique: 78PKHX4cNY-6F4uyXJ6sJA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E70E6408E;
	Mon, 17 Jan 2022 10:53:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DB5127CAE1;
	Mon, 17 Jan 2022 10:53:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2917A4CA93;
	Mon, 17 Jan 2022 10:53:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20HAp4Ni008882 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 Jan 2022 05:51:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 19A9F141DED6; Mon, 17 Jan 2022 10:51:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 15270141DED5
	for <dm-devel@redhat.com>; Mon, 17 Jan 2022 10:51:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE9233C1C30A
	for <dm-devel@redhat.com>; Mon, 17 Jan 2022 10:51:03 +0000 (UTC)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com
	[209.85.208.48]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-640-loEYuyWfOKubbY3cexjQcA-1; Mon, 17 Jan 2022 05:51:02 -0500
X-MC-Unique: loEYuyWfOKubbY3cexjQcA-1
Received: by mail-ed1-f48.google.com with SMTP id c71so63809936edf.6
	for <dm-devel@redhat.com>; Mon, 17 Jan 2022 02:51:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=ydnskEgkx25SXLuClcMqb38Uq2c01Mjm+Sd/Lbos9nY=;
	b=jAYbRjK+5B5OsYD2O6Wi4izDPwymyTZpMMA05IzhekSic9XaDBSFyzr8/7Vbn9Ph7j
	MYocaEBfNjf2QETfJhubXgk8b4JI0yK5hVDlx831ADoHdyi+51pjOMnIIfr+0KXWCqzA
	kFCDa4/EWntNfEl4Kp4uo+Fpbz8sbYZx5rQcDDtqLlVJHzjAQIuTi6EhMwGXZpX35HEv
	YOmJXSr2o3PUsDy6m+QNPqIbkkanlpKlDNrikn0+UxztDpEk6DVM5gw10tJui+XJIepT
	olo5WHr58uNVWKyWCqBel1J5LczSQl2Eq13Co00/YwcMJ//NI35/rV6JLQGlR+99FWXj
	lLAA==
X-Gm-Message-State: AOAM531rQbj8cecTHaskZZoYytYXCWV5yN+DI53glkU0g0GZZgrO5ns2
	pIiOWda9lKkMxJ1Gc9o4fKCPNL5+A/c=
X-Google-Smtp-Source: ABdhPJxIH9c6uTJFzuBlphP3c/Q4+lNtauUSmil4PoCoXRfbQKDs1cZNa5K/4kBm+DgJrL+V1tsZ2A==
X-Received: by 2002:a17:906:4998:: with SMTP id
	p24mr15955917eju.131.1642416661182; 
	Mon, 17 Jan 2022 02:51:01 -0800 (PST)
Received: from [192.168.2.27] (113.151.broadband3.iol.cz. [85.70.151.113])
	by smtp.gmail.com with ESMTPSA id
	v11sm3630132ejq.175.2022.01.17.02.51.00
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 17 Jan 2022 02:51:00 -0800 (PST)
Message-ID: <0461b15e-8ace-5a84-cf9d-504e555b8cab@gmail.com>
Date: Mon, 17 Jan 2022 11:50:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Christoph Hellwig <hch@infradead.org>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
	<9ef95bbc-4eee-4c00-f199-0daa3cdd03ed@gmail.com>
	<YeUgNpFeg9LmW4Um@infradead.org>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <YeUgNpFeg9LmW4Um@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: Israel Rukshin <israelr@nvidia.com>, Max Gurtovoy <mgurtovoy@nvidia.com>,
	dm-devel <dm-devel@redhat.com>, Nitzan Carmi <nitzanc@nvidia.com>,
	Eric Biggers <ebiggers@google.com>
Subject: Re: [dm-devel] [RFC PATCH 0/1] Add inline encryption support for
 dm-crypt
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 17/01/2022 08:52, Christoph Hellwig wrote:
> On Fri, Jan 14, 2022 at 09:51:20PM +0100, Milan Broz wrote:
>> I think dm-crypt should stay as SW crypto only (using kernel crypto API,
>> so HW acceleration is done through crypto drivers there).
>>
>> A cleaner solution is to write a much simpler new dm-crypt-inline target,
>> which will implement only inline encryption.
>> (And userspace can decide which target to use.)
>> Code should be just an extension to the dm-linear target, most
>> of dm-crypt complexity is not needed here.
> 
> Why do we even need a dm target for this as well?  There should be no
> need to clone or remap bios, so I think hamdling inline crypto should be
> just a small addition to the core block layer.

Well, yes, that was my question too :-)

Maybe there is need to have some new userspace utility to configure that
but otherwise I think that for inline encryption device mapper layer
only increases complexity and reduces IO performance.

Could anyone elaborate what it the reason for such DM extension?
Compatibility with existing encryption/key management tools (like LUKS)?
Easy support in LVM? ...

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

