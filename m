Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CBD3C7EE25
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 06:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686206948;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NwjKqruY2Yq0PGDHt2ZtZ2Hyxai3ekl0IYCG+PpNRzM=;
	b=NU0OCDCgflOFCKtIJbySbXePhiivqgsJASe6zoDBOmnr5CSl79xAWULJ4MqxC6q5AuvVgi
	uld9I+Eu0auZJ587E5yfZTYxcmQhusQBUQx6gdC1mI8vA63QGNq4O3IWULbqfLZLvpmJKh
	iHQOoKz5Ab6ebCQXH0BEQ9XUluptvh0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-zDLnZv7yNpuBLQJEhMPKyA-1; Thu, 08 Jun 2023 02:49:07 -0400
X-MC-Unique: zDLnZv7yNpuBLQJEhMPKyA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C2591C09A47;
	Thu,  8 Jun 2023 06:49:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 093EA140EBB8;
	Thu,  8 Jun 2023 06:49:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F18FE19452CC;
	Thu,  8 Jun 2023 06:48:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6918419465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 09:45:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5655A40D1B68; Wed,  7 Jun 2023 09:45:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F58740D1B66
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 09:45:53 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D863811E88
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 09:45:53 +0000 (UTC)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com
 [209.85.208.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-nb3H95eQMMyFadPrfWGh5g-1; Wed, 07 Jun 2023 05:45:51 -0400
X-MC-Unique: nb3H95eQMMyFadPrfWGh5g-1
Received: by mail-ed1-f51.google.com with SMTP id
 4fb4d7f45d1cf-51494659d49so1135235a12.3
 for <dm-devel@redhat.com>; Wed, 07 Jun 2023 02:45:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686131150; x=1688723150;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=79vzDiF+tHrnH1dRnmQpod9DfGlW5ryqo0lz5n79FPI=;
 b=JFtdp55u8Qa6C39yUYz+U+MgME5+lWmXC0Wp/+0OFXo0PENOwq+trmG8raZhRwgD42
 DJxG7+jS7JShw2mIWlO/+uW2X2/BJN1hrkC/ix3KTrvcRXjIu0lAm6ULWeVJmhukXZRN
 vUu1w0I+hJwM93SIuuIQ3DAZ4mS5z1O86KIor9DQ5ZDceycKSxCtO/5WNB+AN/FIz8Zd
 2cAgEXH4CrgHmfgcPdnRH0GrSVS3Wgl8q0TCynoq6B9x12pquSr3ZYn5XaC2aeZAobpM
 t7uOqg8ObZ9CFL9FCfm3uXHF7S2n5/ettcf6F1NEDldDbk0XAKdJS7yhUatQCtzZ0YrK
 DE7A==
X-Gm-Message-State: AC+VfDyT4TKkEqrIPeofIwEVwO0T+NR1RULF/XxDVkwqcx3i996PkW7V
 30REpGY2Wysu42t9PVoiq0iShhzSW8TgNKYoDBvpyA==
X-Google-Smtp-Source: ACHHUZ6S5zCcoB3bV8vZmXpO8sNjvRC4rvkXRPMqlcDG+MUEcxQoM5+7tlD1+Znnck9OUJnJex1d7ZYhdubt6xLn55E=
X-Received: by 2002:aa7:c3c3:0:b0:516:3261:17d with SMTP id
 l3-20020aa7c3c3000000b005163261017dmr3783303edr.20.1686131149770; Wed, 07 Jun
 2023 02:45:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-29-hch@lst.de>
In-Reply-To: <20230606073950.225178-29-hch@lst.de>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Wed, 7 Jun 2023 11:45:39 +0200
Message-ID: <CAMGffEk2LB0CDqR6DJczhejkkyK1Q5Ybu-wJ_fr99O0fXa-pew@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Thu, 08 Jun 2023 06:48:45 +0000
Subject: Re: [dm-devel] [PATCH 28/31] block: replace fmode_t with a
 block-specific type for block open flags
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
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org,
 Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>,
 dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org,
 Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org,
 linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
 linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: ionos.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBKdW4gNiwgMjAyMyBhdCA5OjQx4oCvQU0gQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBs
c3QuZGU+IHdyb3RlOgo+Cj4gVGhlIG9ubHkgb3ZlcmxhcCBiZXR3ZWVuIHRoZSBibG9jayBvcGVu
IGZsYWdzIG1hcHBlZCBpbnRvIHRoZSBmbW9kZV90IGFuZAo+IG90aGVyIHVzZXMgb2YgZm1vZGVf
dCBhcmUgRk1PREVfUkVBRCBhbmQgRk1PREVfV1JJVEUuICBEZWZpbmUgYSBuZXcKPiBibGtfbW9k
ZV90IGluc3RlYWQgZm9yIHVzZSBpbiBibGtkZXZfZ2V0X2J5XyosIC0+b3BlbiBhbmQgLT5pb2N0
bCBhbmQKPiBzdG9wIGFidXNpbmcgZm1vZGVfdC4KPgo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9w
aCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IC0tLQo+ICBhcmNoL3VtL2RyaXZlcnMvdWJkX2tlcm4u
YyAgICAgICAgICB8ICA4ICsrKy0tLQo+ICBhcmNoL3h0ZW5zYS9wbGF0Zm9ybXMvaXNzL3NpbWRp
c2suYyB8ICAyICstCj4gIGJsb2NrL2JkZXYuYyAgICAgICAgICAgICAgICAgICAgICAgIHwgMzIg
KysrKysrKysrKystLS0tLS0tLS0tLQo+ICBibG9jay9ibGstem9uZWQuYyAgICAgICAgICAgICAg
ICAgICB8ICA4ICsrKy0tLQo+ICBibG9jay9ibGsuaCAgICAgICAgICAgICAgICAgICAgICAgICB8
IDExICsrKystLS0tCj4gIGJsb2NrL2ZvcHMuYyAgICAgICAgICAgICAgICAgICAgICAgIHwgMjYg
KysrKysrKysrKysrKy0tLS0tCj4gIGJsb2NrL2dlbmhkLmMgICAgICAgICAgICAgICAgICAgICAg
IHwgIDggKysrLS0tCj4gIGJsb2NrL2lvY3RsLmMgICAgICAgICAgICAgICAgICAgICAgIHwgNDIg
KysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0KPiAgZHJpdmVycy9ibG9jay9hbWlmbG9wLmMg
ICAgICAgICAgICAgfCAxMiArKysrLS0tLS0KPiAgZHJpdmVycy9ibG9jay9hb2UvYW9lYmxrLmMg
ICAgICAgICAgfCAgNCArLS0KPiAgZHJpdmVycy9ibG9jay9hdGFmbG9wLmMgICAgICAgICAgICAg
fCAyNSArKysrKysrKystLS0tLS0tLQo+ICBkcml2ZXJzL2Jsb2NrL2RyYmQvZHJiZF9tYWluLmMg
ICAgICB8ICA3ICsrLS0tCj4gIGRyaXZlcnMvYmxvY2svZHJiZC9kcmJkX25sLmMgICAgICAgIHwg
IDIgKy0KPiAgZHJpdmVycy9ibG9jay9mbG9wcHkuYyAgICAgICAgICAgICAgfCAyOCArKysrKysr
KystLS0tLS0tLS0tCj4gIGRyaXZlcnMvYmxvY2svbG9vcC5jICAgICAgICAgICAgICAgIHwgMjIg
KysrKysrKy0tLS0tLS0tCj4gIGRyaXZlcnMvYmxvY2svbXRpcDMyeHgvbXRpcDMyeHguYyAgIHwg
IDQgKy0tCj4gIGRyaXZlcnMvYmxvY2svbmJkLmMgICAgICAgICAgICAgICAgIHwgIDQgKy0tCj4g
IGRyaXZlcnMvYmxvY2svcGt0Y2R2ZC5jICAgICAgICAgICAgIHwgMTcgKysrKysrLS0tLS0tCj4g
IGRyaXZlcnMvYmxvY2svcmJkLmMgICAgICAgICAgICAgICAgIHwgIDIgKy0KPiAgZHJpdmVycy9i
bG9jay9ybmJkL3JuYmQtY2x0LmMgICAgICAgfCAgNCArLS0KPiAgZHJpdmVycy9ibG9jay9ybmJk
L3JuYmQtc3J2LmMgICAgICAgfCAgNCArLS0KQWNrZWQtYnk6IEphY2sgV2FuZyA8amlucHUud2Fu
Z0Bpb25vcy5jb20+ICMgZm9yIHJuYmQuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsCg==

