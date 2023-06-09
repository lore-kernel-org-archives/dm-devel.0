Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC091C7EE25
	for <dm-devel@archiver.kernel.org>; Mon, 12 Jun 2023 06:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686552352;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=H7NTOuX5wEg8zpSdn8OQfhheQed4XNrK7dodRiJOzew=;
	b=N9HnGbw+s87goCosjMJxj1w/Lbptpg6lh8g5OTTrmaCuGp2ZWoj4Zg3CUMEFdxGdAZpT9X
	OoOxpDt882h2daTcEQT8WB2ylhynFfONR7TN6WAFLYTp9b2Jz+bA5y3TkOD5qz/1BkBs0O
	ggnrprciFzMh5swKRgPskLQNCbNcjCw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-lm8oqBQJOh-zaZdWZDbc-w-1; Mon, 12 Jun 2023 02:45:49 -0400
X-MC-Unique: lm8oqBQJOh-zaZdWZDbc-w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 615D0811E7C;
	Mon, 12 Jun 2023 06:45:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 81F9A1121315;
	Mon, 12 Jun 2023 06:45:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 210961946A46;
	Mon, 12 Jun 2023 06:45:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5236C194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 18:13:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2CECE515540; Fri,  9 Jun 2023 18:13:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 24BF2492B00
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 18:13:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F31E83C0253A
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 18:13:40 +0000 (UTC)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com
 [209.85.218.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-smhdSgOwOFGoiIJRjwQvPA-1; Fri, 09 Jun 2023 14:13:39 -0400
X-MC-Unique: smhdSgOwOFGoiIJRjwQvPA-1
Received: by mail-ej1-f54.google.com with SMTP id
 a640c23a62f3a-977c8baa86fso55322066b.0
 for <dm-devel@redhat.com>; Fri, 09 Jun 2023 11:13:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686334418; x=1688926418;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=f2Xux0G0tFdJlDzvQzZhcAqUXfykTqTn9g16hyE21ys=;
 b=cS3CuXoKzG1GsRznvMQq6+126VM+EoxrM7BZSW8yPs+VOX6hrhznC9+BWJABolKKwq
 TRkMOFBsMrihc3HAJ9+3rKcwcy+yY1M4YjoX0pjaRZoIstpQmAkzQ7+VFBEI9OWCMGSk
 gxSLzl/D3Pigv56iyTt1cSsh+EIOCNVo2cWSGjB73CNB4ltxRKQUI6cXWVDH+FWHcf4P
 QHNQwl9nB4HbI+GgDJyK+Jnyo7aBi3qb9wSE/7ONKgu9ynoR9SAGlOaxxOrKyFniF9Yb
 YgJ3OGFyg7zkGPnDH/aWs0b960+uFlfJ5lU7+j6EwLclOn1oT4Y6aM7dHbKPZp13ifc/
 vnCg==
X-Gm-Message-State: AC+VfDzqCqIzokmc7PGfgdUluJzf1T1UZQ/6F+tYlNY2iwn8V3e9WMZa
 Cd/djFMdorC8wauREsoy1xodiEewvqBktIpwQk0=
X-Google-Smtp-Source: ACHHUZ7r7lbBrTdxRkyp2bTqJCFBDA6+Ddf+RviatN0r97z5LUsaxAu6Q2CxPlvVkZ/6P5sUxBvleBvx6ETeZa4XK48=
X-Received: by 2002:a17:906:1049:b0:974:56cb:9dfc with SMTP id
 j9-20020a170906104900b0097456cb9dfcmr1993996ejj.1.1686334417837; Fri, 09 Jun
 2023 11:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230608110258.189493-1-hch@lst.de>
 <20230608110258.189493-12-hch@lst.de>
In-Reply-To: <20230608110258.189493-12-hch@lst.de>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 9 Jun 2023 20:13:23 +0200
Message-ID: <CAJZ5v0h61q6=JxjeUjjMz5k05HuRGWVKp_rK+9N8rug58kU_VQ@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Mon, 12 Jun 2023 06:45:41 +0000
Subject: Re: [dm-devel] [PATCH 11/30] swsusp: don't pass a stack address to
 blkdev_get_by_path
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
 Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 linux-pm@vger.kernel.org, linux-um@lists.infradead.org,
 Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBKdW4gOCwgMjAyMyBhdCAxOjAz4oCvUE0gQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBs
c3QuZGU+IHdyb3RlOgo+Cj4gaG9sZGVyIGlzIGp1c3QgYW4gb24tc3RhY2sgcG9pbnRlciB0aGF0
IGNhbiBlYXNpbHkgYmUgcmV1c2VkIGJ5IG90aGVyIGNhbGxzLAo+IHJlcGxhY2UgaXQgd2l0aCBh
IHN0YXRpYyB2YXJpYWJsZSB0aGF0IGRvZXNuJ3QgY2hhbmdlLgo+Cj4gU2lnbmVkLW9mZi1ieTog
Q2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWlu
ZWNrZSA8aGFyZUBzdXNlLmRlPgoKQWNrZWQtYnk6IFJhZmFlbCBKLiBXeXNvY2tpIDxyYWZhZWxA
a2VybmVsLm9yZz4KCj4gLS0tCj4gIGtlcm5lbC9wb3dlci9zd2FwLmMgfCA1ICsrKy0tCj4gIDEg
ZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4KPiBkaWZmIC0t
Z2l0IGEva2VybmVsL3Bvd2VyL3N3YXAuYyBiL2tlcm5lbC9wb3dlci9zd2FwLmMKPiBpbmRleCA4
MWFlYzNiMmM2MDUxMC4uYjAzZmYxYTMzYzdmNjggMTAwNjQ0Cj4gLS0tIGEva2VybmVsL3Bvd2Vy
L3N3YXAuYwo+ICsrKyBiL2tlcm5lbC9wb3dlci9zd2FwLmMKPiBAQCAtMTUxMCw2ICsxNTEwLDgg
QEAgaW50IHN3c3VzcF9yZWFkKHVuc2lnbmVkIGludCAqZmxhZ3NfcCkKPiAgICAgICAgIHJldHVy
biBlcnJvcjsKPiAgfQo+Cj4gK3N0YXRpYyB2b2lkICpzd3N1c3BfaG9sZGVyOwo+ICsKPiAgLyoq
Cj4gICAqICAgICAgc3dzdXNwX2NoZWNrIC0gQ2hlY2sgZm9yIHN3c3VzcCBzaWduYXR1cmUgaW4g
dGhlIHJlc3VtZSBkZXZpY2UKPiAgICovCj4gQEAgLTE1MTcsMTQgKzE1MTksMTMgQEAgaW50IHN3
c3VzcF9yZWFkKHVuc2lnbmVkIGludCAqZmxhZ3NfcCkKPiAgaW50IHN3c3VzcF9jaGVjayhib29s
IHNuYXBzaG90X3Rlc3QpCj4gIHsKPiAgICAgICAgIGludCBlcnJvcjsKPiAtICAgICAgIHZvaWQg
KmhvbGRlcjsKPiAgICAgICAgIGZtb2RlX3QgbW9kZSA9IEZNT0RFX1JFQUQ7Cj4KPiAgICAgICAg
IGlmIChzbmFwc2hvdF90ZXN0KQo+ICAgICAgICAgICAgICAgICBtb2RlIHw9IEZNT0RFX0VYQ0w7
Cj4KPiAgICAgICAgIGhpYl9yZXN1bWVfYmRldiA9IGJsa2Rldl9nZXRfYnlfZGV2KHN3c3VzcF9y
ZXN1bWVfZGV2aWNlLAo+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgbW9kZSwgJmhvbGRlciwgTlVMTCk7Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBtb2RlLCAmc3dzdXNwX2hvbGRlciwgTlVMTCk7Cj4gICAgICAgICBpZiAo
IUlTX0VSUihoaWJfcmVzdW1lX2JkZXYpKSB7Cj4gICAgICAgICAgICAgICAgIHNldF9ibG9ja3Np
emUoaGliX3Jlc3VtZV9iZGV2LCBQQUdFX1NJWkUpOwo+ICAgICAgICAgICAgICAgICBjbGVhcl9w
YWdlKHN3c3VzcF9oZWFkZXIpOwo+IC0tCj4gMi4zOS4yCj4KCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWwK

