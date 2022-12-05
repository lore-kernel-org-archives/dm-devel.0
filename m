Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0851CC4332F
	for <dm-devel@archiver.kernel.org>; Mon,  5 Dec 2022 18:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670266442;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OVHt7vimYkqGfCHDLHEMEzFhOW9JWN1TPTZOARkDZnU=;
	b=KGHvJT7DBJMrkSCCGlu8c+FDYX4FGhbcomrGEEiEMmjiq/kZ3QH1D0WTTXzyhk7DhsrWX/
	jZAqaeMmDQUkqIOAO/GMs+qUoPMgf7jbjMD9/6/hTGmaw7K5LdnMyFXESoHTBvKUu1olYD
	E+KirdeemRw407SuztF48vnkdifhI9w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-2PkG5Lb0MyyAeeN9JTBm7A-1; Mon, 05 Dec 2022 13:54:01 -0500
X-MC-Unique: 2PkG5Lb0MyyAeeN9JTBm7A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B58F9380114F;
	Mon,  5 Dec 2022 18:53:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6570A2166B29;
	Mon,  5 Dec 2022 18:53:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1B0BC1946589;
	Mon,  5 Dec 2022 18:53:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1E4CB1946588
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Dec 2022 18:53:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B3EA040C6EC6; Mon,  5 Dec 2022 18:53:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AC44C40C6EC3
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 18:53:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 916D78339C6
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 18:53:57 +0000 (UTC)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-562-IRSQx57VPfuyLWNnJ8ykEQ-1; Mon, 05 Dec 2022 13:53:56 -0500
X-MC-Unique: IRSQx57VPfuyLWNnJ8ykEQ-1
Received: by mail-pj1-f53.google.com with SMTP id
 v13-20020a17090a6b0d00b00219c3be9830so4457173pjj.4
 for <dm-devel@redhat.com>; Mon, 05 Dec 2022 10:53:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=hN16r2JqgO0aUt9hEV33NLw/555dF70HALoTZ9f98ns=;
 b=410dQIcreSdftAFG0f1CkNDzOysjRag/Jgl64Hez/4BLkzVqGPWlNvrjnQ+lAM9iK7
 K29ff6e+PpYMl1LNz9PU9XH274bA+mIKRnQmznPiWqbBHKwAFzepG2Ym9PW2ehhMGxjS
 FSoBH8Nf/CEllQl6J6hCOiPo8zxtL7nGwmyizulcwkvtF+FUKAo0vYT3ysuHUhQexVzz
 CqZ661q/JJ57m87VVTOe06zQFPKp4q/7j+sRfWJxCkRShRpySbGPrNIGspzg7AXPMlab
 q2tgZbnR30eADXGWZCDdbzGK7/bczYno5W3RkASOOfpMZVGgdYaDe9bw3cjdbn/5jRH7
 77kA==
X-Gm-Message-State: ANoB5pkLVDKLM9rmtw/Ser6kVclq5aPB04PWyRN9uBdf8yTfUEkMzhdf
 7kyk3JWi0kwuMngCYxjBAhi5DA==
X-Google-Smtp-Source: AA0mqf4PO6AFHe2UJAtP+NKsy/VfRk3d594BgBjTrOZGH8U7h8+eNxk2+VLeleDwTNhV8wJgpjSYkQ==
X-Received: by 2002:a17:902:e411:b0:189:8796:7813 with SMTP id
 m17-20020a170902e41100b0018987967813mr40667373ple.110.1670266434300; 
 Mon, 05 Dec 2022 10:53:54 -0800 (PST)
Received: from ?IPV6:2600:380:4a37:5fe7:dac6:a7fe:6a6b:c11a?
 ([2600:380:4a37:5fe7:dac6:a7fe:6a6b:c11a])
 by smtp.gmail.com with ESMTPSA id
 o8-20020a170902778800b00189a7fbff33sm10880935pll.170.2022.12.05.10.53.52
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 05 Dec 2022 10:53:53 -0800 (PST)
Message-ID: <23c98c7c-3ed0-0d26-24c0-ed8a63266dcc@kernel.dk>
Date: Mon, 5 Dec 2022 11:53:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
To: Alvaro Karsz <alvaro.karsz@solid-run.com>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <fe2800f1-aaae-33e8-aaf0-83fd034162d5@kernel.dk>
 <CAJs=3_AKOMWBpvKqvX6_c=zN1cwEM7x9dzGr7na=i-5_16rdEg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJs=3_AKOMWBpvKqvX6_c=zN1cwEM7x9dzGr7na=i-5_16rdEg@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME
 feature support
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
Cc: linux-scsi@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMTIvNS8yMiAxMTozNuKAr0FNLCBBbHZhcm8gS2Fyc3ogd3JvdGU6Cj4gSGksCj4gCj4+IElz
IHRoaXMgYmFzZWQgb24gc29tZSBzcGVjPyBCZWNhdXNlIGl0IGxvb2tzIHByZXR0eSBvZGQgdG8g
bWUuIFRoZXJlCj4+IGNhbiBiZSBhIHByZXR0eSB3aWRlIHJhbmdlIG9mIHR3by90aHJlZS9ldGMg
bGV2ZWwgY2VsbHMgd2l0aCB3aWxkbHkKPj4gZGlmZmVyZW50IHJhbmdlcyBvZiBkdXJhYmlsaXR5
LiBBbmQgdGhlcmUncyByZWFsbHkgbm90IGEgbG90IG9mIHNsYwo+PiBmb3IgZ2VuZXJpYyBkZXZp
Y2VzIHRoZXNlIGRheXMsIGlmIGFueS4KPiAKPiBZZXMsIHRoaXMgaXMgYmFzZWQgb24gdGhlIHZp
cnRpbyBzcGVjCj4gaHR0cHM6Ly9kb2NzLm9hc2lzLW9wZW4ub3JnL3ZpcnRpby92aXJ0aW8vdjEu
Mi9jc2QwMS92aXJ0aW8tdjEuMi1jc2QwMS5odG1sCj4gc2VjdGlvbiAgNS4yLjYKCkFuZCB3aGVy
ZSBkaWQgdGhpcyBjb21lIGZyb20/CgotLSAKSmVucyBBeGJvZQoKCi0tCmRtLWRldmVsIG1haWxp
bmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

