Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B6A9C001B0
	for <dm-devel@archiver.kernel.org>; Tue,  8 Aug 2023 06:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691477633;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dEpDo8x6jbBxiSJS+qFHY/xhTK91lmAIo7/EIQkzBDE=;
	b=D3kcb3gfY/2d2M2QMhYggnXSgojzpE7cseIlq0+8p7JODxguaSy2xeO3rF5X5IO5VTfhiR
	DpaL9+F5qg5BWQfkHuClDbe+QiqShjlB1bW3CeNfdVGe/kezu3fI/UCcorPeKeaHx7CJns
	J1ax2HKTMm/s1dAw4vsnlHGbiz6pBac=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-8q6z8LhVO82D9DkuKqw_fQ-1; Tue, 08 Aug 2023 02:53:49 -0400
X-MC-Unique: 8q6z8LhVO82D9DkuKqw_fQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D23D6104F0A9;
	Tue,  8 Aug 2023 06:53:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BF05340D283D;
	Tue,  8 Aug 2023 06:53:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AA1FE194721C;
	Tue,  8 Aug 2023 06:53:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A8E741946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Aug 2023 09:42:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DDB3C2166B26; Mon,  7 Aug 2023 09:42:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D4E512166B25
 for <dm-devel@redhat.com>; Mon,  7 Aug 2023 09:42:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A49458DC671
 for <dm-devel@redhat.com>; Mon,  7 Aug 2023 09:42:16 +0000 (UTC)
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com
 [209.85.161.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-npzud2JzMKmK-JsTTwHBcQ-1; Mon, 07 Aug 2023 05:42:14 -0400
X-MC-Unique: npzud2JzMKmK-JsTTwHBcQ-1
Received: by mail-oo1-f42.google.com with SMTP id
 006d021491bc7-56d0deeca09so655534eaf.0
 for <dm-devel@redhat.com>; Mon, 07 Aug 2023 02:42:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1691401333; x=1692006133;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=IK5JqTcazrnzFQkUb1pgAiTMlQXrShoQJmEX5JHWXhU=;
 b=Iuz8XWV5pwnMQsYUn+xIi3iEgkWZu/Ti/owQdVuX6VDjP6Ll4oURvHZTUaqu7q0bjO
 aGcVi5qvjxs988PATmxcI+NC70hchMCW5qDrcAJ8qmh0cOIYvRNt7p7hFxwIrbmTGvQb
 hgOnQ6jvqHMS+Zq417iO9x5wqYVI7szAOQ2A5cS8chzikkIYJLacQ0gitHtA/Ym8uHtC
 3TvR2S+vxnQoU1B/nuo5+xV5b16U9YC+p3zo4KP1XV1OE+XWyKTGrO1JnyuTbOGSPt+P
 xM96VxOQZSEiHO2JR2QjiWNaXIhA4Qm3pNUDxH/KfxLR1NW/7THAOdTmeTbr3cZQNrME
 jcAQ==
X-Gm-Message-State: ABy/qLYZF/MP+8L4qkZTRnDd6Sqr3CvAEWhn37kzWkkDG1s8SB6pV4Zg
 9fhUg4z+mUD7THeSmKbBdhz8lt1usoJLovBk0sQ=
X-Google-Smtp-Source: APBJJlEb7O2dGAF/f7fTBx/HAisyhbmiTj3PawRftJoMI15JdDVqSBYI20CfGwr14y35bjypNJI9KK+xc439zbfSIBc=
X-Received: by 2002:a4a:cf14:0:b0:569:a08a:d9c5 with SMTP id
 l20-20020a4acf14000000b00569a08ad9c5mr19679264oos.0.1691401333651; Mon, 07
 Aug 2023 02:42:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230807083356.19222-2-vbabka@suse.cz>
In-Reply-To: <20230807083356.19222-2-vbabka@suse.cz>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 7 Aug 2023 11:41:58 +0200
Message-ID: <CAJZ5v0g_OjHSdM_oi515KQUrFZvZH4hNgCy4xknosQC+81GYhw@mail.gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Tue, 08 Aug 2023 06:53:24 +0000
Subject: Re: [dm-devel] [PATCH for 6.5 regression] PM: hibernate: fix
 resume_store() return value when hibernation not available
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
Cc: Jens Axboe <axboe@kernel.dk>, loic.poulain@linaro.org,
 regressions@lists.linux.dev, "Rafael J . Wysocki" <rafael@kernel.org>,
 snitzer@kernel.org, gregkh@linuxfoundation.org, linux-pm@vger.kernel.org,
 joern@lazybastard.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, richard@nod.at, dm-devel@redhat.com,
 linux-mtd@lists.infradead.org, Pavel Machek <pavel@ucw.cz>,
 miquel.raynal@bootlin.com, hch@lst.de, vigneshr@ti.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBBdWcgNywgMjAyMyBhdCAxMDozNOKAr0FNIFZsYXN0aW1pbCBCYWJrYSA8dmJhYmth
QHN1c2UuY3o+IHdyb3RlOgo+Cj4gT24gYSBsYXB0b3Agd2l0aCBoaWJlcm5hdGlvbiBzZXQgdXAg
YnV0IG5vdCBhY3RpdmVseSB1c2VkLCBhbmQgd2l0aAo+IHNlY3VyZSBib290IGFuZCBsb2NrZG93
biBlbmFibGVkIGtlcm5lbCwgNi41LXJjMSBnZXRzIHN0dWNrIG9uIGJvb3Qgd2l0aAo+IHRoZSBm
b2xsb3dpbmcgcmVwZWF0ZWQgbWVzc2FnZXM6Cj4KPiAgIEEgc3RhcnQgam9iIGlzIHJ1bm5pbmcg
Zm9yIFJlc3VtZSBmcm9tIGhpYmVybmF0aW9uIHVzaW5nIGRldmljZSAvZGV2L3N5c3RlbS9zd2Fw
ICgyNHMgLyBubyBsaW1pdCkKPiAgIGxvY2tkb3duX2lzX2xvY2tlZF9kb3duOiAyNTMxMTE1NCBj
YWxsYmFja3Mgc3VwcHJlc3NlZAo+ICAgTG9ja2Rvd246IHN5c3RlbWQtaGliZXJuYTogaGliZXJu
YXRpb24gaXMgcmVzdHJpY3RlZDsgc2VlIG1hbiBrZXJuZWxfbG9ja2Rvd24uNwo+ICAgLi4uCj4K
PiBDaGVja2luZyB0aGUgcmVzdW1lIGNvZGUgbGVhZHMgdG8gY29tbWl0IGNjODljNjNlMmZlMyAo
IlBNOiBoaWJlcm5hdGU6Cj4gbW92ZSBmaW5kaW5nIHRoZSByZXN1bWUgZGV2aWNlIG91dCBvZiBz
b2Z0d2FyZV9yZXN1bWUiKSB3aGljaAo+IGluYWR2ZXJ0ZW50bHkgY2hhbmdlZCB0aGUgcmV0dXJu
IHZhbHVlIGZyb20gcmVzdW1lX3N0b3JlKCkgdG8gMCB3aGVuCj4gIWhpYmVybmF0aW9uX2F2YWls
YWJsZSgpLiBUaGlzIGFwcGFyZW50bHkgdHJhbnNsYXRlcyB0byB1c2Vyc3BhY2UKPiB3cml0ZSgp
IHJldHVybmluZyAwIGFzIGluIG51bWJlciBvZiBieXRlcyB3cml0dGVuLCBhbmQgdXNlcnNwYWNl
IGxvb3BpbmcKPiBpbmRlZmluaXRlbHkgaW4gdGhlIGF0dGVtcHQgdG8gd3JpdGUgdGhlIGludGVu
ZGVkIHZhbHVlLgo+Cj4gRml4IHRoaXMgYnkgcmV0dXJuaW5nIHRoZSBmdWxsIG51bWJlciBvZiBi
eXRlcyB0aGF0IHdlcmUgdG8gYmUgd3JpdHRlbiwKPiBhcyB0aGF0J3Mgd2hhdCB3YXMgZG9uZSBi
ZWZvcmUgdGhlIGNvbW1pdC4KPgo+IEZpeGVzOiBjYzg5YzYzZTJmZTMgKCJQTTogaGliZXJuYXRl
OiBtb3ZlIGZpbmRpbmcgdGhlIHJlc3VtZSBkZXZpY2Ugb3V0IG9mIHNvZnR3YXJlX3Jlc3VtZSIp
Cj4gU2lnbmVkLW9mZi1ieTogVmxhc3RpbWlsIEJhYmthIDx2YmFia2FAc3VzZS5jej4KPiBSZXZp
ZXdlZC1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gQWNrZWQtYnk6IEdyZWcg
S3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+Cj4gLS0tCj4gUmVzZW5k
IHdpdGggcmV2aWV3L2FjayB0YWdzIGFkZGVkIGFuZCBub3QgYnVyaWVkIGluIHRoZSB0aHJlYWQu
Cj4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzJjZmE1ZjU1LTFkNjgtOGE0Zi1k
MDQ5LTEzZjQyZTBkMTQ4NEBzdXNlLmN6Lwo+Cj4gIGtlcm5lbC9wb3dlci9oaWJlcm5hdGUuYyB8
IDIgKy0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCj4K
PiBkaWZmIC0tZ2l0IGEva2VybmVsL3Bvd2VyL2hpYmVybmF0ZS5jIGIva2VybmVsL3Bvd2VyL2hp
YmVybmF0ZS5jCj4gaW5kZXggZTFiNGJmYTkzOGRkLi4yYjRhOTQ2YTZmZjUgMTAwNjQ0Cj4gLS0t
IGEva2VybmVsL3Bvd2VyL2hpYmVybmF0ZS5jCj4gKysrIGIva2VybmVsL3Bvd2VyL2hpYmVybmF0
ZS5jCj4gQEAgLTExNjYsNyArMTE2Niw3IEBAIHN0YXRpYyBzc2l6ZV90IHJlc3VtZV9zdG9yZShz
dHJ1Y3Qga29iamVjdCAqa29iaiwgc3RydWN0IGtvYmpfYXR0cmlidXRlICphdHRyLAo+ICAgICAg
ICAgaW50IGVycm9yOwo+Cj4gICAgICAgICBpZiAoIWhpYmVybmF0aW9uX2F2YWlsYWJsZSgpKQo+
IC0gICAgICAgICAgICAgICByZXR1cm4gMDsKPiArICAgICAgICAgICAgICAgcmV0dXJuIG47Cj4K
PiAgICAgICAgIGlmIChsZW4gJiYgYnVmW2xlbi0xXSA9PSAnXG4nKQo+ICAgICAgICAgICAgICAg
ICBsZW4tLTsKPiAtLQoKQXBwbGllZCBhcyA2LjUtcmMgbWF0ZXJpYWwsIHRoYW5rcyEKCi0tCmRt
LWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

