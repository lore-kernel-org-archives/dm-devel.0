Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF211EB64D0
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jun 2023 14:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686665860;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=I9HC/SUzpeFhsSIPJyy7CHWpFPltaD+LIsZyri/Ywx0=;
	b=H7NfgCMXSXwrCAUb4BC+DwbQJ6tm0bvtcLSFdsEgV+fR+cuSb/LCo1KPhcggWxxlFQ3jlh
	2qfqHV4VaXeyKGk9HI+iyVjmbAhbIvNHoHm5KfVCx3AsyXlms56SUFoVmgcTsIRxe5OvJE
	fP5f6mcuu4QXvylagnh1xQV/8tMOsr8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-YhyAsywvPOGV7G8ztraSlw-1; Tue, 13 Jun 2023 10:17:14 -0400
X-MC-Unique: YhyAsywvPOGV7G8ztraSlw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24F6F80610C;
	Tue, 13 Jun 2023 14:14:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E7A04400DEFC;
	Tue, 13 Jun 2023 14:14:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B4A031946A44;
	Tue, 13 Jun 2023 14:14:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5C973194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Jun 2023 14:14:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EC16440C6F5C; Tue, 13 Jun 2023 14:14:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E550440C6F5D
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 14:14:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDB1D8060C2
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 14:14:37 +0000 (UTC)
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-kGS-eHAVPASYVnUuq0hkmg-1; Tue, 13 Jun 2023 10:14:36 -0400
X-MC-Unique: kGS-eHAVPASYVnUuq0hkmg-1
Received: by mail-pl1-f197.google.com with SMTP id
 d9443c01a7336-1b3bf6374b3so14790175ad.1
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 07:14:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686665674; x=1689257674;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
 :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
 :cc:subject:date:message-id:reply-to;
 bh=DpkNnyJl/r+l38jd7G4jK6EOYDsTz3j87kgRPwWTAIk=;
 b=DMBZRsAhzY/2oOnJqASWej168wqeyPWt22ozBjZK6juHq+Mb/stl0QABUmU2vcnnot
 m7UJkqOHwHwjlqLoo2TKyjBe7g+EPCAb1KZkYCGJnra0D0rBIM5ULjDwM4fS4dEAHB8W
 DU428Puwh21t6yfEsMI9IvL08ANtx0AI1Oz4GfjuRR5k7k549pY5Lxw3F6uRuzaztzNz
 67qH6eNgnE/dniLh7+t1xS+FMl916pOEX1ys27v6vtXq2KICyQ11Pny/2cXLLq8m7Ueh
 +bWTRr10ScP5PL+bz6ZMCX0N3qaOrvjDvgCeo2ePW6GZkMEUMMMUM5PR/uLCp7ursX3A
 Uu8A==
X-Gm-Message-State: AC+VfDzjBF7+G0KGKwNDxBaAIzLQku95Jt9XEx2gviUqOpZDKr+bJ2U6
 ayy/0p40xKwDhVWRiv2KXVkGKJm6+Fb2kj8qGLskyZZepxnjO+RY4pyxEbc/cvjES3t2gu/A5vs
 eV42nDfxFbn0Qgf0=
X-Received: by 2002:a17:902:db05:b0:1ac:750e:33ef with SMTP id
 m5-20020a170902db0500b001ac750e33efmr10683891plx.3.1686665673981; 
 Tue, 13 Jun 2023 07:14:33 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7hphU5oNXY+vLyEtzb2/VXAwyFdv/W1ERGfScbT2ryMWNZzP9j95BDoUSr4GRG7HdpNpBDJA==
X-Received: by 2002:a17:902:db05:b0:1ac:750e:33ef with SMTP id
 m5-20020a170902db0500b001ac750e33efmr10683869plx.3.1686665673684; 
 Tue, 13 Jun 2023 07:14:33 -0700 (PDT)
Received: from [10.72.13.126] ([43.228.180.230])
 by smtp.gmail.com with ESMTPSA id
 q23-20020a170902b11700b001b008b3dee2sm4805118plr.287.2023.06.13.07.14.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 13 Jun 2023 07:14:33 -0700 (PDT)
Message-ID: <3917c8cf-dff7-e922-1d64-7ca1d7f03030@redhat.com>
Date: Tue, 13 Jun 2023 22:14:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
To: Yu Kuai <yukuai1@huaweicloud.com>
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-3-yukuai1@huaweicloud.com>
 <b780ccfd-66b1-fdd1-b33e-aa680fbd86f1@redhat.com>
 <1aaf9150-bbd3-87a8-8d54-8b5d63ab5ed3@huaweicloud.com>
 <CALTww2-ta1NUJxcT3Dq5KP7iunnVx24X7RKj1OKYTYwEPeDNrg@mail.gmail.com>
 <68b215a4-b4bb-7c94-6ad4-84ea859af742@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <68b215a4-b4bb-7c94-6ad4-84ea859af742@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH -next v2 2/6] md: refactor action_store() for
 'idle' and 'frozen'
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org,
 dm-devel@redhat.com, guoqing.jiang@linux.dev,
 "yukuai \(C\)" <yukuai3@huawei.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CuWcqCAyMDIzLzYvMTMg5LiL5Y2IODo0NCwgWXUgS3VhaSDlhpnpgZM6Cj4gSGksCj4KPiDlnKgg
MjAyMy8wNi8xMyAyMDoyNSwgWGlhbyBOaSDlhpnpgZM6Cj4+IE9uIFR1ZSwgSnVuIDEzLCAyMDIz
IGF0IDg6MDDigK9QTSBZdSBLdWFpIDx5dWt1YWkxQGh1YXdlaWNsb3VkLmNvbT4gd3JvdGU6Cj4+
Pgo+Pj4gSGksCj4+Pgo+Pj4g5ZyoIDIwMjMvMDYvMTMgMTY6MDIsIFhpYW8gTmkg5YaZ6YGTOgo+
Pj4+Cj4+Pj4g5ZyoIDIwMjMvNS8yOSDkuIvljYg5OjIwLCBZdSBLdWFpIOWGmemBkzoKPj4+Pj4g
RnJvbTogWXUgS3VhaSA8eXVrdWFpM0BodWF3ZWkuY29tPgo+Pj4+Pgo+Pj4+PiBQcmVwYXJlIHRv
IGhhbmRsZSAnaWRsZScgYW5kICdmcm96ZW4nIGRpZmZlcmVudGx5IHRvIGZpeCBhIGRlYWRsb2Nr
LAo+Pj4+PiB0aGVyZQo+Pj4+PiBhcmUgbm8gZnVuY3Rpb25hbCBjaGFuZ2VzIGV4Y2VwdCB0aGF0
IE1EX1JFQ09WRVJZX1JVTk5JTkcgaXMgY2hlY2tlZAo+Pj4+PiBhZ2FpbiBhZnRlciAncmVjb25m
aWdfbXV0ZXgnIGlzIGhlbGQuCj4+Pj4KPj4+Pgo+Pj4+IENhbiB5b3UgZXhwbGFpbiBtb3JlIGFi
b3V0IHdoeSBpdCBuZWVkcyB0byBjaGVjayBNRF9SRUNPVkVSWV9SVU5OSU5HCj4+Pj4gYWdhaW4g
aGVyZT8KPj4+Cj4+PiBBcyBJIGV4cGxhaW4gaW4gdGhlIGZvbGxvd2luZyBjb21tZW50Ogo+Pgo+
PiBIaQo+Pgo+PiBXaG8gY2FuIGNsZWFyIHRoZSBmbGFnIGJlZm9yZSB0aGUgbG9jayBpcyBoZWxk
Pwo+Cj4gQmFzaWNhbGx5IGV2ZXJ5IHdoZXJlIHRoYXQgY2FuIGNsZWFyIHRoZSBmbGFnLi4uCj4K
PiAvLyBUaGlzIGNvbnRleHTCoMKgwqDCoCAvLyBPdGhlciBjb250ZXh0Cj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBtdXRleF9sb2NrCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAuLi4KPiB0ZXN0
X2JpdCAtPiBwYXNzCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjbGVhcl9iaXQKPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIG11dGV4X3VubG9jawo+IG11dGV4X2xvY2sKPiB0ZXN0X2JpdCAtPiBj
aGVjayBhZ2Fpbgo+Cj4gVGhhbmtzLAo+IEt1YWkKCkF0IGZpcnN0LCBJIHdhbnRlZCB0byBmaWd1
cmUgb3V0IGEgc3BlY2lmaWMgY2FzZS4gTm93IEkgaGF2ZSB0aGUgYW5zd2VyLiAKTWF5YmUgdGhl
cmUgYXJlIHR3byBwZW9wbGUgdGhhdCB3YW50IHRvIHN0b3AKCnRoZSBzeW5jIGFjdGlvbiBhdCB0
aGUgc2FtZSB0aW1lLiBTbyB0aGlzIGlzIHRoZSBjYXNlIHRoYXQgY2FuIGJlIApjaGVja2VkIGJ5
IHRoZSBjb2Rlcy4KClJlZ2FyZHMKClhpYW8KCj4+Cj4+IFJlZ2FyZHMKPj4gWGlhbwo+Pj4+PiAr
wqDCoMKgIC8qCj4+Pj4+ICvCoMKgwqDCoCAqIENoZWNrIGFnYWluIGluIGNhc2UgTURfUkVDT1ZF
UllfUlVOTklORyBpcyBjbGVhcmVkIGJlZm9yZSAKPj4+Pj4gbG9jayBpcwo+Pj4+PiArwqDCoMKg
wqAgKiBoZWxkLgo+Pj4+PiArwqDCoMKgwqAgKi8KPj4+Pj4gK8KgwqDCoCBpZiAoIXRlc3RfYml0
KE1EX1JFQ09WRVJZX1JVTk5JTkcsICZtZGRldi0+cmVjb3ZlcnkpKSB7Cj4+Pj4+ICvCoMKgwqDC
oMKgwqDCoCBtZGRldl91bmxvY2sobWRkZXYpOwo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJu
Owo+Pj4+PiArwqDCoMKgIH0KPj4+Cj4+PiBUaGFua3MsCj4+PiBLdWFpCj4+Pgo+Pgo+PiAuCj4+
Cj4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

