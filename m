Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7D33EB64DC
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971640;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jvTRQI3YgzXdITXET8EzUMNv+u13eOT/O03uelOO5JU=;
	b=NNOFpw8pNKWK2FS56hJOp8IZrfmhdUvvSabSSzVQyX1uwAf4m2Wx6P3Rn/8BzYpIK3WL9o
	u7UAWjuNkZjf5SgTLpQsP/fd0c4+m4N8e57z6GKX7/bdB9A+JAFxTHDC5SqG9UdnAmrTHf
	mKcF2X2/L8UmG70mQZZIzilMpHfCODE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-Uxz--AKkN6G058iMm05qMw-1; Mon, 10 Jul 2023 02:47:18 -0400
X-MC-Unique: Uxz--AKkN6G058iMm05qMw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 282BF280D20F;
	Mon, 10 Jul 2023 06:47:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1168FF66B5;
	Mon, 10 Jul 2023 06:47:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8519A19465A3;
	Mon, 10 Jul 2023 06:46:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BF4D61946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 27 Jun 2023 10:39:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9A961200B677; Tue, 27 Jun 2023 10:39:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 92F45200A3AD
 for <dm-devel@redhat.com>; Tue, 27 Jun 2023 10:39:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74EAE85A58A
 for <dm-devel@redhat.com>; Tue, 27 Jun 2023 10:39:07 +0000 (UTC)
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com
 [209.85.167.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-tV35slLiPIqNSMAAS8dguQ-1; Tue, 27 Jun 2023 06:39:02 -0400
X-MC-Unique: tV35slLiPIqNSMAAS8dguQ-1
Received: by mail-oi1-f173.google.com with SMTP id
 5614622812f47-3a1ebb79579so1025523b6e.3
 for <dm-devel@redhat.com>; Tue, 27 Jun 2023 03:39:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687862341; x=1690454341;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=rCgvLgi3BLx22tE+6LcdRjHHTXAUCqzO3DhXE5/At3c=;
 b=YLKijq0KvQL3W8Tm1bzfJLnoB7ylxXua12XflSEo1yCdqIvgofDpRdWA21El2X5qyC
 CsOg1mUZCTLkMqudyBzfCysBHr5bON7cJsSDyAbpS5Co80ksiu+Prz9qIoomvzTrVDTc
 l8IQCkpey5j7lTY7Cknnbj/ibqW+xLtULM5w+mXZOHzsZbi+QSerhFdofEoivuFGHGd8
 G1RJ7V0eGtfvdCiJVQ6ZBZuPpFN1uoEQiLRJvaTqPaBWI9bncS14Lj0+aHa/x7B3CzON
 rBUjVMSOcRnpIcu0mekFK8Zey3AK6soh/ror7IDL0KxR4XSxx8gOtuV5SUxb3+XmSxxo
 8oag==
X-Gm-Message-State: AC+VfDzp+eaSWUfF2hrq403FnZr1OytCq1fAycYupK8WJQ2Iiu+BQxYa
 Dpbsx5ZP70Xn0RKgUVp3fG/gYobsV2Nym8ZsJMg=
X-Google-Smtp-Source: ACHHUZ5H3GRoBym0b9/SiurE+jEIsHMp41/GcQAaG06YOaSsX0tGI2WlPTg+w61l4Kgc2zfz1Xr4qbgyrRqgP6044mA=
X-Received: by 2002:a05:6808:424d:b0:38e:a824:27d3 with SMTP id
 dp13-20020a056808424d00b0038ea82427d3mr30392455oib.27.1687862341491; Tue, 27
 Jun 2023 03:39:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230531125535.676098-1-hch@lst.de>
 <20230531125535.676098-9-hch@lst.de>
 <c1391658-d785-4b2f-ba7e-01e4668685d7@roeck-us.net>
 <20230626075325.GA26851@lst.de>
 <7e708dfa-4019-fe28-afbd-91ad847fada0@roeck-us.net>
In-Reply-To: <7e708dfa-4019-fe28-afbd-91ad847fada0@roeck-us.net>
From: Max Filippov <jcmvbkbc@gmail.com>
Date: Tue, 27 Jun 2023 03:38:50 -0700
Message-ID: <CAMo8BfLtEw2jdRC-pK4kYuqmgEy-0QgXDodiF+gZEMygNQQBbA@mail.gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH 08/24] init: pass root_device_name explicitly
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
Cc: Jens Axboe <axboe@kernel.dk>, Loic Poulain <loic.poulain@linaro.org>,
 Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBKdW4gMjYsIDIwMjMgYXQgODoxMOKAr0FNIEd1ZW50ZXIgUm9lY2sgPGxpbnV4QHJv
ZWNrLXVzLm5ldD4gd3JvdGU6Cj4KPiBPbiA2LzI2LzIzIDAwOjUzLCBDaHJpc3RvcGggSGVsbHdp
ZyB3cm90ZToKPiA+IE9uIEZyaSwgSnVuIDIzLCAyMDIzIGF0IDA1OjA4OjU5UE0gLTA3MDAsIEd1
ZW50ZXIgUm9lY2sgd3JvdGU6Cj4gPj4gSGksCj4gPj4KPiA+PiBPbiBXZWQsIE1heSAzMSwgMjAy
MyBhdCAwMjo1NToxOVBNICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiA+Pj4gSW5z
dGVhZCBvZiBkZWNsYXJpbmcgcm9vdF9kZXZpY2VfbmFtZSBhcyBhIGdsb2JhbCB2YXJpYWJsZSBw
YXNzIGl0IGFzIGFuCj4gPj4+IGFyZ3VtZW50IHRvIHRoZSBmdW5jdGlvbnMgdXNpbmcgaXQuCj4g
Pj4+Cj4gPj4+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+
ID4+Cj4gPj4gVGhpcyBwYXRjaCByZXN1bHRzIGluIHRoZSBmb2xsb3dpbmcgYnVpbGQgZXJyb3Ig
d2hlbiB0cnlpbmcgdG8gYnVpbGQKPiA+PiB4dGVuc2E6dGlueWNvbmZpZy4KPiA+Pgo+ID4+IFdB
Uk5JTkc6IG1vZHBvc3Q6IHZtbGludXg6IHNlY3Rpb24gbWlzbWF0Y2ggaW4gcmVmZXJlbmNlOiBz
dHJjcHkuaXNyYS4wKzB4MTQgKHNlY3Rpb246IC50ZXh0LnVubGlrZWx5KSAtPiBpbml0Y2FsbF9s
ZXZlbF9uYW1lcyAoc2VjdGlvbjogLmluaXQuZGF0YSkKPiA+PiBFUlJPUjogbW9kcG9zdDogU2Vj
dGlvbiBtaXNtYXRjaGVzIGRldGVjdGVkLgo+ID4KPiA+IEkgY2FuIHJlcHJvZHVjZSB0aGVzZSB3
aXRoIGdjYyAxMy4xIG9uIHh0ZW5zYSwgYnV0IHRoZSByZXBvcnQgbWFrZXMKPiA+IG5vIHNlbnNl
IHRvIG1lLiAgSWYgSSBkaXNhYmxlIENPTkZJR19DQ19PUFRJTUlaRV9GT1JfU0laRSBpdCBub3cg
cmVwb3J0cwo+ID4gYSBzaW1pbGFyIHdhcm5pbmcgZm9yIHB1dF9wYWdlIGludGVhZCBvZiBzdHJj
cHkgd2hpY2ggc2VlbXMganVzdCBhcwo+ID4gYXJjYW5jZS4KPiA+Cj4KPiBJIGRvbid0IHNlZSB0
aGF0IChJIHRyaWVkIDExLjMsIDExLjQsIDEyLjMsIGFuZCAxMy4xKSwgYnV0IHRoZW4gSSBhbSBu
b3Qgc3VyZQo+IGlmIHRoaXMgaXMgd29ydGggdHJhY2tpbmcgZG93bi4gSSBqdXN0IGZvcmNlIENP
TkZJR19TRUNUSU9OX01JU01BVENIX1dBUk5fT05MWT15Cj4gZm9yIHh0ZW5zYSBidWlsZHMgaW5z
dGVhZC4KCkkgYmVsaWV2ZSBpdCdzIHlldCBhbm90aGVyIG1hbmlmZXN0YXRpb24gb2YgdGhlIGZv
bGxvd2luZyBpc3N1ZToKaHR0cHM6Ly9nY2MuZ251Lm9yZy9idWd6aWxsYS9zaG93X2J1Zy5jZ2k/
aWQ9OTI5MzgKCkh1bnRpbmcgaXMgc3RpbGwgb24gbXkgdG9kbyBsaXN0LCBidXQgaXQncyBxdWl0
ZSBsb3csIHNvIEkgZ3Vlc3MKZm9yY2luZyBDT05GSUdfU0VDVElPTl9NSVNNQVRDSF9XQVJOX09O
TFk9eSBmb3IgeHRlbnNhCmlzIHRoZSByaWdodCB0aGluZyB0byBkbyBmb3Igbm93LgoKLS0gClRo
YW5rcy4KLS0gTWF4CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNv
bQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

