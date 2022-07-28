Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30D4FC04A68
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 13:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659015030;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Y4PSpkh8cJxhUngIzkfWkkut0SMA4Cbtc6htDxM4TX8=;
	b=f75gTTkcFfCqjad7kx7rs94CHEttfPZ+XFICmWa6w+JNnHYwzgW1WIEgBYZR1rZ71kiYsr
	9tn71CVAJfsgJjlC2KxWUSfFelTDPyQ7KCBS6hh4n6A7gTFMat97TZThFHyFVIMvmiEZbN
	zCweYW32mtYt9TVUKNnVpefM4zzB/V8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-YPCU6jPnMGCMmzxg9Zjlng-1; Thu, 28 Jul 2022 09:30:28 -0400
X-MC-Unique: YPCU6jPnMGCMmzxg9Zjlng-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00F6E1C1976E;
	Thu, 28 Jul 2022 13:30:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DE7FFC28100;
	Thu, 28 Jul 2022 13:30:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A907A1945DA7;
	Thu, 28 Jul 2022 13:30:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 06B0C1945DA7
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 13:30:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D37FE40CFD0A; Thu, 28 Jul 2022 13:30:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CF50B40CF8EB
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 13:30:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B7681C19764
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 13:30:22 +0000 (UTC)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-OY32mCp3Nw6Lu0jutnBktg-1; Thu, 28 Jul 2022 09:30:20 -0400
X-MC-Unique: OY32mCp3Nw6Lu0jutnBktg-1
Received: by mail-pg1-f178.google.com with SMTP id e132so1552128pgc.5
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 06:30:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=RdplHWE21v7uW0csMEy8w+746Uk8pAL1Z4Zo/u66MRc=;
 b=y6t72RfVxF6xC0HFk9wOBXLbeAemFnYhaBspihOapFrFfAU9JGeSqdBva1EaO/duTm
 fr/DtwKuksetG8lZOrfgm54fTBsvatolIV+eyVAy/sJmrK8gCG40sfGJXUqauHiUxO0/
 d8cL0icFs7sBOo9/1M2YIzvXpkSHkWsQCqeAb1DZ4LrF61ECbKwZr/Ug7SO8GSWzLXWf
 61B/+IsFzBPBuGMueTrnwgBh37AdAz0wQ0/Dx2rtSRmFrDNIsGbCR2v3rhG7kXICAAZA
 q2wbbaLWF9w/rJqXc6MyV+m4hG9ojFOQ9tydGsshmjS58MUqOqJpsB2Q9Q7TuWaNaiBj
 z+2w==
X-Gm-Message-State: AJIora9aDfxFZT4QwPcMQfAQjvprbit73CrAoZboxzsxI2l/IRXgQjYx
 4lyvBd/KjZrXA2icIfyV2eY=
X-Google-Smtp-Source: AGRyM1sEeS4b6mgBviJJaeM6ot/oR6bsjRTH3rUY3cbgsPHiPvABhB/Is7CL9HzuiOI0PM2NkdpFeg==
X-Received: by 2002:a63:1a56:0:b0:41b:3ef0:4eb1 with SMTP id
 a22-20020a631a56000000b0041b3ef04eb1mr8174445pgm.207.1659015019399; 
 Thu, 28 Jul 2022 06:30:19 -0700 (PDT)
Received: from [192.168.3.217] ([98.51.102.78])
 by smtp.gmail.com with ESMTPSA id
 b2-20020a170903228200b0016a7d9e6548sm1273348plh.262.2022.07.28.06.30.17
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 28 Jul 2022 06:30:18 -0700 (PDT)
Message-ID: <6ac6c0b3-ca3a-27da-0b8f-b4c39671bdab@acm.org>
Date: Thu, 28 Jul 2022 06:30:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, damien.lemoal@opensource.wdc.com,
 hch@lst.de, axboe@kernel.dk, snitzer@kernel.org, Johannes.Thumshirn@wdc.com
References: <CGME20220727162246eucas1p1a758799f13d36ba99d30bf92cc5e2754@eucas1p1.samsung.com>
 <20220727162245.209794-1-p.raghav@samsung.com>
 <51255650-ddc2-4f3d-52e5-14007b9ff538@acm.org>
 <e0606903-c007-43f1-538f-b70ee607be0a@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e0606903-c007-43f1-538f-b70ee607be0a@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v8 00/11] support non power of 2 zoned device
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
Cc: pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNy8yOC8yMiAwNDo1NywgUGFua2FqIFJhZ2hhdiB3cm90ZToKPiBIaSBCYXJ0LAo+IAo+IE9u
IDIwMjItMDctMjggMDE6MTksIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToKPj4gT24gNy8yNy8yMiAw
OToyMiwgUGFua2FqIFJhZ2hhdiB3cm90ZToKPj4+IFRoaXMgc2VyaWVzIGFkZHMgc3VwcG9ydCB0
byBucG8yIHpvbmVkIGRldmljZXMgaW4gdGhlIGJsb2NrIGFuZCBudm1lCj4+PiBsYXllciBhbmQg
YSBuZXcgKipkbSB0YXJnZXQqKiBpcyBhZGRlZDogZG0tcG8yei10YXJnZXQuIFRoaXMgbmV3Cj4+
PiB0YXJnZXQgd2lsbCBiZSBpbml0aWFsbHkgdXNlZCBmb3IgZmlsZXN5c3RlbXMgc3VjaCBhcyBi
dHJmcyBhbmQKPj4+IGYyZnMgdGhhdCBkb2VzIG5vdCBoYXZlIG5hdGl2ZSBucG8yIHpvbmUgc3Vw
cG9ydC4KPj4KPj4gU2hvdWxkIGFueSBTQ1NJIGNoYW5nZXMgYmUgaW5jbHVkZWQgaW4gdGhpcyBw
YXRjaCBzZXJpZXM/IEZyb20gc2RfemJjLmM6Cj4+Cj4+ICDCoMKgwqDCoGlmICghaXNfcG93ZXJf
b2ZfMih6b25lX2Jsb2NrcykpIHsKPj4gIMKgwqDCoMKgwqDCoMKgIHNkX3ByaW50ayhLRVJOX0VS
Uiwgc2RrcCwKPj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJab25lIHNpemUgJWxsdSBp
cyBub3QgYSBwb3dlciBvZiB0d28uXG4iLAo+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
em9uZV9ibG9ja3MpOwo+PiAgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4+ICDCoMKg
wqDCoH0KPj4KPiBJIHdvdWxkIGtlZXAgdGhlc2UgY2hhbmdlcyBvdXQgb2YgdGhlIGN1cnJlbnQg
cGF0Y2ggc2VyaWVzIGJlY2F1c2UgaXQKPiB3aWxsIGFsc28gaW5jcmVhc2UgdGhlIHRlc3Qgc2Nv
cGUuIEkgdGhpbmsgb25jZSB0aGUgYmxvY2sgbGF5ZXIKPiBjb25zdHJhaW50IGlzIHJlbW92ZWQg
YXMgYSBwYXJ0IG9mIHRoaXMgc2VyaWVzLCB3ZSBjYW4gd29yayBvbiB0aGUgU0NTSQo+IGNoYW5n
ZXMgaW4gdGhlIG5leHQgY3ljbGUuCgpUaGF0J3MgZmluZSB3aXRoIG1lLgoKVGhhbmtzLAoKQmFy
dC4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

