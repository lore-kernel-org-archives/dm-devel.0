Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9AD9C77B7A
	for <dm-devel@archiver.kernel.org>; Fri,  2 Jun 2023 01:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685667786;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zwi28SSpJfhsqaOrBjUsA7ryppeVVKxwpnQLnmWG+kE=;
	b=che3ubhTJqJgbAvSp/+motlr8sV9yeqWySvTPlCkt/n+HxJda1BUGuUKuvrAM5QdXI2dMo
	GBaC4fKbgNtKcyH5G2n/O+MbZFCqO++X+oQAhbPEHRXuzOBJmlf/EVF2t/yvYAHAk1fCZB
	OXDi1Gdt/9CwKgueTJey4Z6OhNs7ZWw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-A6otO149OM6ja9p_0N2IfA-1; Thu, 01 Jun 2023 21:03:02 -0400
X-MC-Unique: A6otO149OM6ja9p_0N2IfA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71505101A53A;
	Fri,  2 Jun 2023 01:03:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CEB1A40C6EC4;
	Fri,  2 Jun 2023 01:02:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 926CF1946595;
	Fri,  2 Jun 2023 01:02:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D815A194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Jun 2023 01:02:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AA7C814171BC; Fri,  2 Jun 2023 01:02:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A287214171BB
 for <dm-devel@redhat.com>; Fri,  2 Jun 2023 01:02:53 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8416C101A52C
 for <dm-devel@redhat.com>; Fri,  2 Jun 2023 01:02:53 +0000 (UTC)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com
 [209.85.218.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-4eaFK2S_OK6ImZAfHSzfXg-1; Thu, 01 Jun 2023 21:02:44 -0400
X-MC-Unique: 4eaFK2S_OK6ImZAfHSzfXg-1
Received: by mail-ej1-f43.google.com with SMTP id
 a640c23a62f3a-96f50e26b8bso225392966b.2
 for <dm-devel@redhat.com>; Thu, 01 Jun 2023 18:02:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685667763; x=1688259763;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=nvpp6zCJzkAVruqEfeRw+jwirL2eHCSWtsESmTUPR/s=;
 b=R6q04VwLw2/nLTZYtlQHjouvo3bv8WaSPxmYr1E39GbH3G4/512mbz4G4B/IXsTqGc
 dRSAtyMwfZldyMTFkeS757K6EompIT1krTMffB2FAIxyHl4ZqpghNINwCLELh/R0+Ix6
 OCGKGThGM1WNBf7a8deItwQ76IDJFBEPGb0Nf0ZU8IrIMreuKZ6k6oHmrwg4qaLHeT4H
 i14RVm0rZqWz8Vh2BW7Z5EFj5g14044IKluaaHgTTgBYtGlKOrE95YpKyrXIRavB5Vdx
 TOjD5EIdX7LYWPFatCGml5Jlntz7tgJid6bPFXzG/36AEqJP6R7A3IZfuH6lg4aMVC86
 0uTQ==
X-Gm-Message-State: AC+VfDyWDO7YwPJH/E5X4aW3XJUdZmIhz2LvDS9h8AOVJJX9gbACmq7G
 t/IFCgVJXhR9h3PaX+CZYKKfEZgvXfE3s/JTKVXkUvEJ
X-Google-Smtp-Source: ACHHUZ5lCoIChj3HhkH977Hbj5qzlMiNpu0tsOBbRdI93MYqk59BOZgd9bcdQ14S6zIAu8Uqyqm6pw==
X-Received: by 2002:a17:907:d19:b0:974:322d:da2 with SMTP id
 gn25-20020a1709070d1900b00974322d0da2mr5922170ejc.41.1685667763472; 
 Thu, 01 Jun 2023 18:02:43 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com.
 [209.85.218.52]) by smtp.gmail.com with ESMTPSA id
 d12-20020a1709063ecc00b0096f03770be2sm77610ejj.52.2023.06.01.18.02.42
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 01 Jun 2023 18:02:42 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id
 a640c23a62f3a-96fbc74fbf1so226303366b.1
 for <dm-devel@redhat.com>; Thu, 01 Jun 2023 18:02:42 -0700 (PDT)
X-Received: by 2002:a17:907:940d:b0:974:6026:a312 with SMTP id
 dk13-20020a170907940d00b009746026a312mr300827ejc.51.1685667762103; Thu, 01
 Jun 2023 18:02:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230601072829.1258286-1-hch@lst.de>
 <20230601072829.1258286-4-hch@lst.de>
In-Reply-To: <20230601072829.1258286-4-hch@lst.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Jun 2023 21:02:25 -0400
X-Gmail-Original-Message-ID: <CAHk-=wj3TrM-NWUcFUivefNwzbfGdfcgDGfGP12m6WBfH9JpWg@mail.gmail.com>
Message-ID: <CAHk-=wj3TrM-NWUcFUivefNwzbfGdfcgDGfGP12m6WBfH9JpWg@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 3/3] block: fail writes to read-only devices
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux-foundation.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBKdW4gMSwgMjAyMyBhdCAzOjI44oCvQU0gQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBs
c3QuZGU+IHdyb3RlOgo+Cj4gTm90ZSB0aGF0IHRoZSBsYXN0IGF0dGVtcHQgdG8gZG8gdGhpcyBn
b3QgcmV2ZXJ0ZWQgYnkgTGludXMgaW4gY29tbWl0Cj4gYTMyZTIzNmViOTNlICgiUGFydGlhbGx5
IHJldmVydCAiYmxvY2s6IGZhaWwgb3BfaXNfd3JpdGUoKSByZXF1ZXN0cyB0bwo+IHJlYWQtb25s
eSBwYXJ0aXRpb25zIikgYmVjYXVzZSBkZXZpY2UgbWFwcGVyIHJlbHlpZWQgb24gbm90IGVuZm9y
Y2luZwo+IHRoZSByZWFkLW9ubHkgc3RhdGUgd2hlbiB1c2VkIHRvZ2V0aGVyIHdpdGggb2xkZXIg
bHZtLXRvb2xzLgoKSSdtIGNlcnRhaW5seSBoYXBweSB0byB0cnkgYWdhaW4sIGJ1dCBJIGhhdmUg
bXkgZG91YnRzIHdoZXRoZXIgdGhpcyB3aWxsIHdvcmsuCgpOb3RlIHRoYXQgdGhlIHByb2JsZW0g
Y2FzZSBpcyBmb3IgYSBkZXZpY2UgdGhhdCAqdXNlZCogdG8gYmUgd3JpdGFibGUsCmJ1dCBiZWNh
bWUgcmVhZC1vbmx5IGxhdGVyLCBhbmQgdGhlcmUncyBhbiBleGlzdGluZyB3cml0ZXIgdGhhdCBu
ZWVkcwp0aGF0IHdyaXRhYmlsaXR5LgoKVGhlIGx2bSBmaXggd2FzIG5vdCB0byBzdG9wIHdyaXRp
bmcsIGJ1dCB0byBzaW1wbHkgbm90IG1hcmsgaXQKcmVhZC1vbmx5IHRvbyBlYXJseS4KClNvIEkg
ZG8gdGhpbmsgdGhhdCB0aGUgcHJvYmxlbSBoZXJlIGlzIHB1cmVseSBpbiB0aGUgYmxvY2sgbGF5
ZXIuCgpUaGUgbG9naWMgd3J0ICJiZGV2X3JlYWRfb25seSgpIiBpcyBub3QgbmVjZXNzYXJpbHkg
YSAicmlnaHQgbm93IGl0J3MKcmVhZC1vbmx5IiwgYnV0IG1vcmUgb2YgYSB0aGluZyB0aGF0IHNo
b3VsZCBiZSBjaGVja2VkIHB1cmVseSB3aGVuIHRoZQpkZXZpY2UgaXMgb3BlbmVkLiBXaGljaCBp
cyBwcmV0dHkgbXVjaCBleGFjdGx5IHdoYXQgd2UgZG8uCgpTbyBob25lc3RseSwgdGhhdCB3aG9s
ZSB0ZXN0IGZvcgoKKyAgICAgICBpZiAob3BfaXNfd3JpdGUoYmlvX29wKGJpbykpICYmIGJpb19z
ZWN0b3JzKGJpbykgJiYKKyAgICAgICAgICAgYmRldl9yZWFkX29ubHkoYmRldikpIHsKCm1heSBs
b29rICJvYnZpb3VzbHkgY29ycmVjdCIsIGJ1dCBpdCdzIGFsc28gZXF1YWxseSB2YWxpZCB0byB2
aWV3IGl0CmFzICJvYnZpb3VzbHkgZ2FyYmFnZSIsIHNpbXBseSBiZWNhdXNlIHRoZSB0ZXN0IGlz
IGJlaW5nIGRvbmUgYXQgdGhlCndyb25nIHBvaW50LgoKVGhlIHNhbWUgd2F5IHlvdSBjYW4gd3Jp
dGUgdG8gYSBmaWxlIHRoYXQgd2FzIG9wZW5lZCBmb3Igd3JpdGluZywgYnV0CmhhcyB0aGVuIGJl
Y29tZSByZWFkLW9ubHkgYWZ0ZXJ3YXJkcywgd3JpdGluZyB0byBhIGRldmljZSB3aXRoIGEgYmRl
dgp0aGF0IHdhcyB3cml0YWJsZSB3aGVuIHlvdSAqc3RhcnRlZCogd3JpdGluZyBpcyBub3QgYXQg
YWxsIG5lY2Vzc2FyaWx5Cndyb25nLgoKU28gcGxlYXNlIGF0IGxlYXN0IGNvbnNpZGVyIHRoZSBw
b3NzaWJpbGl0eSB0aGF0IHRoYXQgdGVzdCAtIHdoaWxlIGl0Cmxvb2tzIG9idmlvdXMgLSBpcyBz
aW1wbHkgYnVnZ3kuCgogICAgICAgICAgICAgICAgTGludXMKCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWwK

