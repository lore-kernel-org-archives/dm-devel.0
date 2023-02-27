Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44417C64ED8
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 17:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677520518;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j7TXo041HU83SsjECEhzJMPMHnv6TIaUXQAZw4H/tY8=;
	b=H20+uCY90tNMqzdU2ZqVH3N3xn69fZFuYWb6smtE9PHCTAQSkvrfL50oV39TzvRN6mefgL
	JPz+4cGsjZJ5rciKCQm3KcH8aph5ByYlkEwINnEkvFI8qNFcvQLL6faDd2J84DB4gxTXuM
	XHipDhYXMkyghN3xbK98zf86z+BONX8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-wWf-oC2VP2-FAS0eO28lRQ-1; Mon, 27 Feb 2023 12:55:14 -0500
X-MC-Unique: wWf-oC2VP2-FAS0eO28lRQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B11821C17427;
	Mon, 27 Feb 2023 17:55:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A49CAC15BAD;
	Mon, 27 Feb 2023 17:55:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7D2141946587;
	Mon, 27 Feb 2023 17:55:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BEF031946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Feb 2023 17:55:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A1E18C15BAE; Mon, 27 Feb 2023 17:55:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A823C15BAD
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 17:55:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66383101A52E
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 17:55:09 +0000 (UTC)
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com
 [209.85.219.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-618-ROxExgKDPvK1UyZ5hav60g-1; Mon, 27 Feb 2023 12:55:07 -0500
X-MC-Unique: ROxExgKDPvK1UyZ5hav60g-1
Received: by mail-qv1-f51.google.com with SMTP id y12so5002024qvt.8
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 09:55:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=KkRehYoW83mAFQ78q5iHuBd2MqfTKkzCAoZwFhkQlGo=;
 b=HmmME+4wkusOfIQixeJfFh+pWVr98jcsapD2p9f1uL6qEPt+HmHFMMzRD1K5xVf6Nj
 o1p6N15xBuQL02VuJz9BKg82rDLI9R8Kt0qyGXLD3uJhjr9qL38rl3C8YPjnorolw6kT
 /sUXouhwl5wmXnUF63H+8dgoWui6nIW1pIGOAvdYRs0gUoHeO+Afc2Q4t3VsrQ2b+aMM
 E8lUhRkcMBpIvTTd5I2LpLXTEGKZCtc4DT3Oz/WQMh7acwXE27Lrdb82KO4JpQ/pKelL
 fQGb/hcOgPrU5lSYlCLTcEmfYq+4MM8MeIQmYJUrnzg4kPzqWR0zKtXs0+qUTuBJQFr/
 kd5g==
X-Gm-Message-State: AO0yUKXkg6Om0f8LBH4u2Zaaaq+yRUV6ApHubT6OHCcS7noOyi6iJENt
 YLedr3IDvKD8Ca0XkICsNVCmq9c=
X-Google-Smtp-Source: AK7set/QvjjCWk25qfjPVdFPPBtXzeIgQbBqUCmzOnZU1uoA9Yjc7HGrYU5bI1FvAlB1p6JOya2k5Q==
X-Received: by 2002:a05:6214:509d:b0:56c:659d:435c with SMTP id
 kk29-20020a056214509d00b0056c659d435cmr566586qvb.24.1677520506875; 
 Mon, 27 Feb 2023 09:55:06 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 t136-20020a37aa8e000000b0073b967b9b35sm5276845qke.106.2023.02.27.09.55.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Feb 2023 09:55:06 -0800 (PST)
Date: Mon, 27 Feb 2023 12:55:05 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: yangerkun <yangerkun@huaweicloud.com>
Message-ID: <Y/zueUWERryoIGA8@redhat.com>
References: <20230223031947.3717433-1-yangerkun@huaweicloud.com>
 <b7020147-2382-71f6-5237-8501562f8011@acm.org>
 <e69ec125-3636-ab20-ce63-f4b89ac55ffb@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <e69ec125-3636-ab20-ce63-f4b89ac55ffb@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] dm-crypt: fix softlockup in dmcrypt_write
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
Cc: yangerkun@huawei.com, dm-devel@redhat.com,
 Bart Van Assche <bvanassche@acm.org>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU3VuLCBGZWIgMjYgMjAyMyBhdCAgODozMVAgLTA1MDAsCnlhbmdlcmt1biA8eWFuZ2Vya3Vu
QGh1YXdlaWNsb3VkLmNvbT4gd3JvdGU6Cgo+IAo+IAo+IOWcqCAyMDIzLzIvMjYgMTA6MDEsIEJh
cnQgVmFuIEFzc2NoZSDlhpnpgZM6Cj4gPiBPbiAyLzIyLzIzIDE5OjE5LCB5YW5nZXJrdW4gd3Jv
dGU6Cj4gPiA+IEBAIC0xOTI0LDYgKzE5MjYsMTAgQEAgc3RhdGljIGludCBkbWNyeXB0X3dyaXRl
KHZvaWQgKmRhdGEpCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoCBCVUdfT04ocmJfcGFyZW50KHdy
aXRlX3RyZWUucmJfbm9kZSkpOwo+ID4gPiArwqDCoMKgwqDCoMKgwqAgaWYgKHRpbWVfaXNfYmVm
b3JlX2ppZmZpZXMoc3RhcnRfdGltZSArIEhaKSkgewo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBzY2hlZHVsZSgpOwo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdGFydF90aW1l
ID0gamlmZmllczsKPiA+ID4gK8KgwqDCoMKgwqDCoMKgIH0KPiA+IAo+ID4gV2h5IHNjaGVkdWxl
KCkgaW5zdGVhZCBvZiBjb25kX3Jlc2NoZWQoKT8KPiAKPiBjb25kX3Jlc2NoZWQgbWF5IG5vdCBy
ZWFsbHkgc2NoZWR1bGUsIHdoaWNoIG1heSB0cmlnZ2VyIHRoZSBwcm9ibGVtIHRvbywgYnV0Cj4g
aXQgc2VlbXMgYWZ0ZXIgMSBzZWNvbmQsIGl0IG1heSBuZXZlciBoYXBwZW5kPwoKSSBoYWQgdGhl
IHNhbWUgcXVlc3Rpb24gYXMgQmFydCB3aGVuIHJldmlld2luZyB5b3VyIGhvbWVncm93bgpjb25k
aXRpb25hbCBzY2hlZHVsZSgpLiAgSG9wZWZ1bGx5IHlvdSBjYW4gcmVwcm9kdWNlIHRoaXMgaXNz
dWU/ICBJZgpzbywgcGxlYXNlIHNlZSBpZiBzaW1wbHkgdXNpbmcgY29uZF9yZXNjaGVkKCkgZml4
ZXMgdGhlIGlzc3VlLgoKVGhhbmtzLApNaWtlCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsCg==

