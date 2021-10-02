Return-Path: <SRS0=NCco=OW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7639C433F5
	for <dm-devel@archiver.kernel.org>; Sat,  2 Oct 2021 13:51:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5DEAF61A81
	for <dm-devel@archiver.kernel.org>; Sat,  2 Oct 2021 13:51:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5DEAF61A81
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-6QbS_yUYMmSbOq8sO6ZlPg-1; Sat, 02 Oct 2021 09:50:57 -0400
X-MC-Unique: 6QbS_yUYMmSbOq8sO6ZlPg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93DAA802928;
	Sat,  2 Oct 2021 13:50:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 84F1C60936;
	Sat,  2 Oct 2021 13:50:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 81E5D4E58F;
	Sat,  2 Oct 2021 13:50:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 192Dooc6028409 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 2 Oct 2021 09:50:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 284E220B6636; Sat,  2 Oct 2021 13:50:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22C3B20B663D
	for <dm-devel@redhat.com>; Sat,  2 Oct 2021 13:50:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDE4B1066558
	for <dm-devel@redhat.com>; Sat,  2 Oct 2021 13:50:43 +0000 (UTC)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
	[209.85.221.51]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-218-I6TgtYoIM1CqEmBV4XLWjA-1; Sat, 02 Oct 2021 09:50:40 -0400
X-MC-Unique: I6TgtYoIM1CqEmBV4XLWjA-1
Received: by mail-wr1-f51.google.com with SMTP id r7so4757894wrc.10;
	Sat, 02 Oct 2021 06:50:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=XOhFOdXsjSIl4bMxCQDZQsM2f2mf1ov6bWBdxARKd+k=;
	b=xXlMbGKvAZwIZ/EM/lpGUerQjn9XcLxdOR1HpB2zJzVg8FUZky83wCDuC11xtIf4K7
	vmqdVGOkfIC1r1n0hqqEpLDkw4zz0rgzuc+eTuLHPPm0bFueqr9AmQKNQRBKluYsprKs
	xm6pnZkMlTkbcxb6+NS+33+OuaU2Jz351SLQbJh62hwzneZZEALhkyzvyamW13blm6gn
	5x3ne0zE8eISkwBuZiMqBnqoGLze4B30FhW0btXeEBkWZ9OhSi1cea6RXGZ6U/QMdfnW
	uKSWManq97Li6/uEDnE11IPRpXg1HF9G70y0OSIAX4gprX7MK2OT5XM1V7SjzGiDAK3y
	AgRw==
X-Gm-Message-State: AOAM531CfLUNBprp2jxKSwzCLgwFsTHuV1pun0YmVToSGvc+Swi/I8N5
	3nTipvmFiYppEccALmpePQ==
X-Google-Smtp-Source: ABdhPJzTnhREbkGDoWuKmwjrcbX8Nq6x4qhK5imD0UTGxmPXZp6330JeYsnf+4KW3yiv+3MF/R2ahg==
X-Received: by 2002:a05:6000:2c3:: with SMTP id
	o3mr3582900wry.76.1633182638393; 
	Sat, 02 Oct 2021 06:50:38 -0700 (PDT)
Received: from localhost (67.red-83-32-34.dynamicip.rima-tde.net.
	[83.32.34.67]) by smtp.gmail.com with ESMTPSA id
	y13sm8720065wrm.48.2021.10.02.06.50.37
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sat, 02 Oct 2021 06:50:38 -0700 (PDT)
Message-ID: <43b88340-61da-1e88-0868-9cfd3c019e37@gmail.com>
Date: Sat, 2 Oct 2021 15:50:36 +0200
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>
References: <20211001181254.24056-1-xose.vazquez@gmail.com>
	<c7566fb4-3407-7f44-4767-2742c7370a15@suse.de>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <c7566fb4-3407-7f44-4767-2742c7370a15@suse.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>, DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH RFC] multipath-tools: remove Hannes as IBM
 arrays maintainer
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTAvMi8yMSAxNTo0MywgSGFubmVzIFJlaW5lY2tlIHdyb3RlOgoKPj4gZGlmZiAtLWdpdCBh
L2xpYm11bHRpcGF0aC9od3RhYmxlLmMgYi9saWJtdWx0aXBhdGgvaHd0YWJsZS5jCj4+IGluZGV4
IDc2Mzk4MmNkLi4xMTI4MjY5OSAxMDA2NDQKPj4gLS0tIGEvbGlibXVsdGlwYXRoL2h3dGFibGUu
Ywo+PiArKysgYi9saWJtdWx0aXBhdGgvaHd0YWJsZS5jCj4+IEBAIC00ODIsOCArNDgyLDYgQEAg
c3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHsKPj4gwqDCoMKgwqDCoCB9LAo+
PiDCoMKgwqDCoMKgIC8qCj4+IMKgwqDCoMKgwqDCoCAqIElCTQo+PiAtwqDCoMKgwqAgKgo+PiAt
wqDCoMKgwqAgKiBNYWludGFpbmVyOiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KPj4g
wqDCoMKgwqDCoMKgICovCj4+IMKgwqDCoMKgwqAgewo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgLyog
UHJvRmlicmUgNDAwMFIgKi8KCj4gSG1tLiBZb3UgY291bGQndmUgYXNrZWQgbWUgLi4uCgpJdCB3
YXMgc2VudCBhcyBSRkMuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

