Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA75AC77B60
	for <dm-devel@archiver.kernel.org>; Wed, 26 Apr 2023 10:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682505089;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KZsbPIlSBFhy5jfUXCG2OrA+p6M6yrXbQYK2IUZO1kg=;
	b=VLzU3wCoBkZzZ/QlR0nigYa2jXLe4ILNhTPYLOBhlisO71kxXZOGRWeKQWkpLDU3RyLkgc
	D8sOz7gTumN/uVt0Y1l+CC5AobCjAPhy/HVo0kj035oVhTGlEdkq5f8IifSfYJaTBa85EB
	V9Dk901kDiwHdYy/CK1HMcZSeqrSDnY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-suY6ChE7Pd6IwS2m-zMyWA-1; Wed, 26 Apr 2023 06:31:26 -0400
X-MC-Unique: suY6ChE7Pd6IwS2m-zMyWA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E749811E7B;
	Wed, 26 Apr 2023 10:31:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 283C02027043;
	Wed, 26 Apr 2023 10:31:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1763C19466DF;
	Wed, 26 Apr 2023 10:31:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 11A4B1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 24 Apr 2023 08:26:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E574B2166B2A; Mon, 24 Apr 2023 08:26:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DDB542166B29
 for <dm-devel@redhat.com>; Mon, 24 Apr 2023 08:26:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2A558996E3
 for <dm-devel@redhat.com>; Mon, 24 Apr 2023 08:26:37 +0000 (UTC)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com
 [209.85.128.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-eNFHsxnDMeGTtct-CgfRbw-1; Mon, 24 Apr 2023 04:26:33 -0400
X-MC-Unique: eNFHsxnDMeGTtct-CgfRbw-1
Received: by mail-wm1-f46.google.com with SMTP id
 5b1f17b1804b1-3f173af665fso25695525e9.3
 for <dm-devel@redhat.com>; Mon, 24 Apr 2023 01:26:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1682324792; x=1684916792;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=3pxlWKD7dnb+hgIonOTuPgqaiGVvQd+hXe0K6IdPi2M=;
 b=JXCo/4gNQxNo2XoGzTIN1foYmpLfw/Z7mqI6MH+YzWeDN5Ad3WfqSoNwRrSBFgRPRE
 LkLzfjvlUXfa+wUyt0y8QQgFOwh8QIC4DmDhFboO+MzlkQG2w38X0cZU9/DqssSkcxak
 Z81h3QnmeBqOS9N8DJfsCLdB9oozJOV3uxDiwF536AQLd2nX+Nqt9IagpUUPYuMLo7Vr
 jpuH5AHu8ya7bu4Wqp4CeEUo4U84xT3pxjcqo3aNqJd6HgVgrVcT4P4cA7ECmdebq3rN
 CyRw4ekqLKB7KyN47DeOZuAKUyL08MORZz2PMH9yqNIVne9L8SapIVGzKOF/cdFx5wJI
 MzcQ==
X-Gm-Message-State: AAQBX9ficw48kZeL+DQdLDAIoQiVPC4JNT/fQn4rhXHL69iDhQ5vwXvi
 cqKV2h/f0ejLCaRnVZmrhPosUg==
X-Google-Smtp-Source: AKy350byXoD5GzDBK8BfQEyK98TvcOHuQxalfYGEuCyUBUv+0C+wGb7Sf32jhfdSzffUY8tfHfxXdw==
X-Received: by 2002:a05:600c:259:b0:3f1:662a:93d0 with SMTP id
 25-20020a05600c025900b003f1662a93d0mr7829493wmj.15.1682324791970; 
 Mon, 24 Apr 2023 01:26:31 -0700 (PDT)
Received: from [192.168.178.55] (h082218028181.host.wavenet.at.
 [82.218.28.181]) by smtp.gmail.com with ESMTPSA id
 l20-20020a05600c16d400b003f19bca8f03sm4904838wmn.43.2023.04.24.01.26.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 24 Apr 2023 01:26:31 -0700 (PDT)
Message-ID: <42c89d18-b68f-a7d0-921a-6f45b54da356@linbit.com>
Date: Mon, 24 Apr 2023 10:26:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To: Luis Chamberlain <mcgrof@kernel.org>, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 hch@infradead.org, djwong@kernel.org, minchan@kernel.org,
 senozhatsky@chromium.org
References: <20230421195807.2804512-1-mcgrof@kernel.org>
 <20230421195807.2804512-3-mcgrof@kernel.org>
From: =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= <christoph.boehmwalder@linbit.com>
In-Reply-To: <20230421195807.2804512-3-mcgrof@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Wed, 26 Apr 2023 10:31:22 +0000
Subject: Re: [dm-devel] [PATCH 2/5] drbd: use PAGE_SECTORS_SHIFT and
 PAGE_SECTORS
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
Cc: p.raghav@samsung.com, linux-xfs@vger.kernel.org, da.gomez@samsung.com,
 patches@lists.linux.dev, willy@infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org, kbusch@kernel.org, drbd-dev@lists.linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linbit.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

QW0gMjEuMDQuMjMgdW0gMjE6NTggc2NocmllYiBMdWlzIENoYW1iZXJsYWluOgo+IFJlcGxhY2Ug
Y29tbW9uIGNvbnN0YW50cyB3aXRoIGdlbmVyaWMgdmVyc2lvbnMuCj4gVGhpcyBwcm9kdWNlcyBu
byBmdW5jdGlvbmFsIGNoYW5nZXMuCj4gCj4gU2lnbmVkLW9mZi1ieTogTHVpcyBDaGFtYmVybGFp
biA8bWNncm9mQGtlcm5lbC5vcmc+Cj4gLS0tCj4gIGRyaXZlcnMvYmxvY2svZHJiZC9kcmJkX2Jp
dG1hcC5jIHwgNCArKy0tCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVs
ZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmxvY2svZHJiZC9kcmJkX2JpdG1h
cC5jIGIvZHJpdmVycy9ibG9jay9kcmJkL2RyYmRfYml0bWFwLmMKPiBpbmRleCA2YWM4YzU0YjQ0
YzcuLmI1NTZlNjYzNGYxMyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL2Jsb2NrL2RyYmQvZHJiZF9i
aXRtYXAuYwo+ICsrKyBiL2RyaXZlcnMvYmxvY2svZHJiZC9kcmJkX2JpdG1hcC5jCj4gQEAgLTEw
MDAsNyArMTAwMCw3IEBAIHN0YXRpYyB2b2lkIGJtX3BhZ2VfaW9fYXN5bmMoc3RydWN0IGRyYmRf
Ym1fYWlvX2N0eCAqY3R4LCBpbnQgcGFnZV9ucikgX19tdXN0X2hvCj4gIAl1bnNpZ25lZCBpbnQg
bGVuOwo+ICAKPiAgCWZpcnN0X2JtX3NlY3QgPSBkZXZpY2UtPmxkZXYtPm1kLm1kX29mZnNldCAr
IGRldmljZS0+bGRldi0+bWQuYm1fb2Zmc2V0Owo+IC0Jb25fZGlza19zZWN0b3IgPSBmaXJzdF9i
bV9zZWN0ICsgKCgoc2VjdG9yX3QpcGFnZV9ucikgPDwgKFBBR0VfU0hJRlQtU0VDVE9SX1NISUZU
KSk7Cj4gKwlvbl9kaXNrX3NlY3RvciA9IGZpcnN0X2JtX3NlY3QgKyAoKChzZWN0b3JfdClwYWdl
X25yKSA8PCBQQUdFX1NFQ1RPUlNfU0hJRlQpOwo+ICAKPiAgCS8qIHRoaXMgbWlnaHQgaGFwcGVu
IHdpdGggdmVyeSBzbWFsbAo+ICAJICogZmxleGlibGUgZXh0ZXJuYWwgbWV0YSBkYXRhIGRldmlj
ZSwKPiBAQCAtMTAwOCw3ICsxMDA4LDcgQEAgc3RhdGljIHZvaWQgYm1fcGFnZV9pb19hc3luYyhz
dHJ1Y3QgZHJiZF9ibV9haW9fY3R4ICpjdHgsIGludCBwYWdlX25yKSBfX211c3RfaG8KPiAgCWxh
c3RfYm1fc2VjdCA9IGRyYmRfbWRfbGFzdF9iaXRtYXBfc2VjdG9yKGRldmljZS0+bGRldik7Cj4g
IAlpZiAoZmlyc3RfYm1fc2VjdCA8PSBvbl9kaXNrX3NlY3RvciAmJiBsYXN0X2JtX3NlY3QgPj0g
b25fZGlza19zZWN0b3IpIHsKPiAgCQlzZWN0b3JfdCBsZW5fc2VjdCA9IGxhc3RfYm1fc2VjdCAt
IG9uX2Rpc2tfc2VjdG9yICsgMTsKPiAtCQlpZiAobGVuX3NlY3QgPCBQQUdFX1NJWkUvU0VDVE9S
X1NJWkUpCj4gKwkJaWYgKGxlbl9zZWN0IDwgUEFHRV9TRUNUT1JTKQo+ICAJCQlsZW4gPSAodW5z
aWduZWQgaW50KWxlbl9zZWN0KlNFQ1RPUl9TSVpFOwo+ICAJCWVsc2UKPiAgCQkJbGVuID0gUEFH
RV9TSVpFOwoKQWNrZWQtYnk6IENocmlzdG9waCBCw7ZobXdhbGRlciA8Y2hyaXN0b3BoLmJvZWht
d2FsZGVyQGxpbmJpdC5jb20+CgotLSAKQ2hyaXN0b3BoIELDtmhtd2FsZGVyCkxJTkJJVCB8IEtl
ZXBpbmcgdGhlIERpZ2l0YWwgV29ybGQgUnVubmluZwpEUkJEIEhBIOKAlCAgRGlzYXN0ZXIgUmVj
b3Zlcnkg4oCUIFNvZnR3YXJlIGRlZmluZWQgU3RvcmFnZQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbAo=

