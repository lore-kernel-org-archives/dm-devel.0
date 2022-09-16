Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5E15ECAAA1
	for <dm-devel@archiver.kernel.org>; Fri, 16 Sep 2022 20:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663358490;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Zye7TmTLMgea98FHmD9iVhDYhYt+oEeobTqDfTzZAfk=;
	b=Nbg1XgKCXkS0btqcvAkknOkvZgTIZEzZrNVYn4T7lZganu6+Up3Omqs3VdzYcnwEo1XTmx
	fpWP08UvSqOsMIInUuLPhCbk88xpaBJZI9vtGi4LnMdD4Di4cvMt+Qw11pAS/wyWKjykAu
	KFTCfXCPm7pSNrnYwmj0c4dkdOAs2TI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-bMkKswUeMD2jL7Alaqc9_Q-1; Fri, 16 Sep 2022 16:01:27 -0400
X-MC-Unique: bMkKswUeMD2jL7Alaqc9_Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C90BF85A5A6;
	Fri, 16 Sep 2022 20:01:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5FEDE17593;
	Fri, 16 Sep 2022 20:01:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 36E81194658F;
	Fri, 16 Sep 2022 20:01:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7EA9A1946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 16 Sep 2022 20:01:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6ED64492B05; Fri, 16 Sep 2022 20:01:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 672D2492B04
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 20:01:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A55F3C0D875
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 20:01:20 +0000 (UTC)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-199--6WotmbTMOyZxZsmMkcx7g-1; Fri, 16 Sep 2022 16:01:14 -0400
X-MC-Unique: -6WotmbTMOyZxZsmMkcx7g-1
Received: by mail-pf1-f173.google.com with SMTP id u132so22220294pfc.6;
 Fri, 16 Sep 2022 13:01:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date;
 bh=aI55elBM47AbpRIfEoRwcS12RWAxkruf3PuVmLaNsIw=;
 b=X3zGBYvlbvTKYlauAC3gwQMZ0BSaMdtLiR+/qeSFDexxcdZrC7kCf4k83McA4UvKD1
 3Ylm1wQkW5x0e/6iV1AqsMBLpUF30F+EPDTTY9c0ex309/DMDvdKibBAmsKQRucmM0bF
 7AA09uqpAq4ARFbRY6PGDdHKzETiKSWvfgRpXv48d1jAiJVf+oDaPTkZwCWsFF3LvTmj
 SLrYbUHiBvZo2Ygssg1vXi7g2KawER+GmhKS5EPvXmMTrxLJnzIReDpYPRzK295xyPY8
 RQsjOhKVbVtXg43iZRhtbGtLDscMqVGZaUB3VQxAghCuQSU86gFSSER5p0PZnY08wzqB
 cQXQ==
X-Gm-Message-State: ACrzQf2iv5OSz+WspT5WQKIIgfLHUNXegWRnDsh8YwX8c2aEx4bC17rS
 Ygqd0PlZxkkKjPBByC5BOklRHO+x5Rs=
X-Google-Smtp-Source: AMsMyM7BtRpoBGm+25ZIcjQ1eDg7usENuczHgm9wgE8Sus1sUlVcptKPjg/7yVuSQ/Mc/WEtnHJpcQ==
X-Received: by 2002:a63:e452:0:b0:42c:60ce:8b78 with SMTP id
 i18-20020a63e452000000b0042c60ce8b78mr5917990pgk.453.1663358472565; 
 Fri, 16 Sep 2022 13:01:12 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:e470:c0f8:8896:5368?
 ([2620:15c:211:201:e470:c0f8:8896:5368])
 by smtp.gmail.com with ESMTPSA id
 n10-20020a170902d2ca00b00174c235e1fdsm15550309plc.199.2022.09.16.13.01.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 16 Sep 2022 13:01:11 -0700 (PDT)
Message-ID: <0be0e378-1601-678c-247a-ba24d111b934@acm.org>
Date: Fri, 16 Sep 2022 13:01:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
To: Sarthak Kukreti <sarthakkukreti@chromium.org>,
 Stefan Hajnoczi <stefanha@redhat.com>
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <YyQTM5PRT2o/GDwy@fedora>
 <CAG9=OMPHZqdDhX=M+ovdg5fa3x4-Q_1r5SWPa8pMTQw0mr5fPg@mail.gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAG9=OMPHZqdDhX=M+ovdg5fa3x4-Q_1r5SWPa8pMTQw0mr5fPg@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH RFC 0/8] Introduce provisioning primitives
 for thinly provisioned storage
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
Cc: Jens Axboe <axboe@kernel.dk>, Gwendal Grignou <gwendal@google.com>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
 Daniil Lunev <dlunev@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-ext4@vger.kernel.org, Evan Green <evgreen@google.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 9/16/22 11:48, Sarthak Kukreti wrote:
> Yes. On ChromiumOS, we regularly deal with storage devices that don't
> support WRITE_ZEROES or that need to have it disabled, via a quirk,
> due to a bug in the vendor's implementation. Using WRITE_ZEROES for
> allocation makes the allocation path quite slow for such devices (not
> to mention the effect on storage lifetime), so having a separate
> provisioning construct is very appealing. Even for devices that do
> support an efficient WRITE_ZEROES implementation but don't support
> logical provisioning per-se, I suppose that the allocation path might
> be a bit faster (the device driver's request queue would report
> 'max_provision_sectors'=0 and the request would be short circuited
> there) although I haven't benchmarked the difference.

Some background information about why ChromiumOS uses thin provisioning 
instead of a single filesystem across the entire storage device would be 
welcome. Although UFS devices support thin provisioning I am not aware 
of any use cases in Android that would benefit from UFS thin 
provisioning support.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

