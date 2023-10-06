Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C9A6E92FC5
	for <dm-devel@archiver.kernel.org>; Fri,  6 Oct 2023 01:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696556532;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3cQWCGAG6SqZoUjIfijhQnxjdcbqAJs7waWSgEe4f3Q=;
	b=Pwhqj1dTvrPqEFu5XYzekgeyIYPk+SFoFGHi1yOTVH3Hb+/XcLf5olj8/Wp2pg39uFQr+e
	y3mimcfOuT8LQCTJkV4XKr1mhA3pNsOUExnaZKHAw0yU+rdb8SMRfxU2OmpFhvnXpTxlWV
	Mj89r3deVi/bJug7X4TBaRsJMOcDfI8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-JVlGJCHoO02bL2Hp7UWizg-1; Thu, 05 Oct 2023 21:42:09 -0400
X-MC-Unique: JVlGJCHoO02bL2Hp7UWizg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 074B38030D4;
	Fri,  6 Oct 2023 01:42:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2777540C6EA8;
	Fri,  6 Oct 2023 01:42:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CBA2C19465A2;
	Fri,  6 Oct 2023 01:42:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EE89B194658F
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Oct 2023 01:42:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 935C4442CB0; Fri,  6 Oct 2023 01:42:01 +0000 (UTC)
Received: from abb.hmeau.com (unknown [10.67.24.162])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B63A47AD4A;
 Fri,  6 Oct 2023 01:42:01 +0000 (UTC)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
 by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
 id 1qoZqh-0043of-2s; Fri, 06 Oct 2023 09:41:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation);
 Fri, 06 Oct 2023 09:41:55 +0800
Date: Fri, 6 Oct 2023 09:41:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-ID: <ZR9l446ndB4n1Xl4@gondor.apana.org.au>
References: <f1b8d8f5-2079-537e-9d0f-d58da166fe50@gmail.com>
 <ZR9dEiXhQv-wBVA2@debian.me>
MIME-Version: 1.0
In-Reply-To: <ZR9dEiXhQv-wBVA2@debian.me>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH] dm crypt: Fix reqsize in crypt_iv_eboiv_gen
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
Cc: Linux Regressions <regressions@lists.linux.dev>,
 Tatu =?iso-8859-1?Q?Heikkil=E4?= <tatu.heikkila@gmail.com>,
 Mike Snitzer <snitzer@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Device Mapper <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gondor.apana.org.au
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBPY3QgMDYsIDIwMjMgYXQgMDg6MDQ6MThBTSArMDcwMCwgQmFnYXMgU2FuamF5YSB3
cm90ZToKPgo+ID4gR2l0IGJpc2VjdCBsZWFkIG1lIHRvOgo+ID4gIyBmaXJzdCBiYWQgY29tbWl0
OiBbZTMwMjMwOTRkZmZiNDE1NDAzMzBmYjBjNzRjZDNhMDE5Y2Q1MjVjMl0gZG0gY3J5cHQ6Cj4g
PiBBdm9pZCB1c2luZyBNQVhfQ0lQSEVSX0JMT0NLU0laRQo+ID4gCj4gPiBJZiBJIGdpdCByZXZl
cnQgZTMwMjMwOTRkZmZiNDE1NDAzMzBmYjBjNzRjZDNhMDE5Y2Q1MjVjMiBvbiBjdXJyZW50IExp
bnVzJwo+ID4gZ2l0IG1hc3RlciwgdGhlIGlzc3VlIGdvZXMgYXdheS4gU28gSSdtIHBlcnNvbmFs
bHkgbm90IGFsbCB0aGF0IGFmZmVjdGVkCj4gPiBhbnltb3JlIChpZiBJJ20gcmVhZHkgdG8gY29t
cGlsZSBteSBrZXJuZWxzIGZyb20gbm93IG9uKSwgYW5kIEkgdW5kZXJzdGFuZAo+ID4gdGhhdCB5
b3UgaGF2ZSBubyBjbGVhciB3YXkgdG8gcmVwcm9kdWNlIHRoaXMgYXMgaXQgc2VlbXMgc3Ryb25n
bHkgYm91bmQgdG8KPiA+IGhhcmR3YXJlLCBidXQgc2VlbXMgbGlrZSB0aGlzIGNvdWxkIHBvaW50
IHRvIGEgcG90ZW50aWFsbHkgc2VyaW91cyBzZWN1cml0eQo+ID4gaXNzdWUgc2luY2UgaXQgaW52
b2x2ZXMgYm90aCBjcnlwdG8gYW5kIHVuZGVmaW5lZCBiZWhhdmlvdXIuCgpUaGFua3MgZm9yIHRo
ZSByZXBvcnQuICBTb3JyeSB0aGlzIGlzIGluZGVlZCBteSBmYXVsdC4gIFRoZSBhbGxvY2F0ZWQK
YnVmZmVyIGlzIHRvbyBzbWFsbCBhcyBpdCdzIG1pc3NpbmcgdGhlIHNpemUgZm9yIHRoZSByZXF1
ZXN0IG9iamVjdAppdHNlbGYuCgpNaWtlLCB3b3VsZCB5b3UgYmUgT0sgd2l0aCBtZSBwaWNraW5n
IHRoaXMgZml4IHVwIGFuZCBwdXNoaW5nIGl0IHRvCkxpbnVzPwoKQ2hlZXJzLAoKLS0tODwtLS0K
QSBza2NpcGhlcl9yZXF1ZXN0IG9iamVjdCBpcyBtYWRlIHVwIG9mIHN0cnVjdCBza2NpcGhlcl9y
ZXF1ZXN0CmZvbGxvd2VkIGJ5IGEgdmFyaWFibGUtc2l6ZWQgdHJhaWxlci4gIFRoZSBhbGxvY2F0
aW9uIG9mIHRoZQpza2NpcGhlcl9yZXF1ZXN0IGFuZCBJViBpbiBjcnlwdF9pdl9lYm9pdl9nZW4g
aXMgbWlzc2luZyB0aGUKbWVtb3J5IGZvciBzdHJ1Y3Qgc2tjaXBoZXJfcmVxdWVzdC4gIEZpeCBp
dCBieSBhZGRpbmcgaXQgdG8KcmVxc2l6ZS4KCkZpeGVzOiBlMzAyMzA5NGRmZmIgKCJkbSBjcnlw
dDogQXZvaWQgdXNpbmcgTUFYX0NJUEhFUl9CTE9DS1NJWkUiKQpSZXBvcnRlZC1ieTogVGF0dSBI
ZWlra2ls77+9IDx0YXR1LmhlaWtraWxhQGdtYWlsLmNvbT4KU2lnbmVkLW9mZi1ieTogSGVyYmVy
dCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1PgoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bWQvZG0tY3J5cHQuYyBiL2RyaXZlcnMvbWQvZG0tY3J5cHQuYwppbmRleCBmMjY2MmMyMWE2ZGYu
LjUzMTVmZDI2MWMyMyAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9kbS1jcnlwdC5jCisrKyBiL2Ry
aXZlcnMvbWQvZG0tY3J5cHQuYwpAQCAtNzUzLDcgKzc1Myw4IEBAIHN0YXRpYyBpbnQgY3J5cHRf
aXZfZWJvaXZfZ2VuKHN0cnVjdCBjcnlwdF9jb25maWcgKmNjLCB1OCAqaXYsCiAJaW50IGVycjsK
IAl1OCAqYnVmOwogCi0JcmVxc2l6ZSA9IEFMSUdOKGNyeXB0b19za2NpcGhlcl9yZXFzaXplKHRm
bSksIF9fYWxpZ25vZl9fKF9fbGU2NCkpOworCXJlcXNpemUgPSBzaXplb2YoKnJlcSkgKyBjcnlw
dG9fc2tjaXBoZXJfcmVxc2l6ZSh0Zm0pOworCXJlcXNpemUgPSBBTElHTihyZXFzaXplLCBfX2Fs
aWdub2ZfXyhfX2xlNjQpKTsKIAogCXJlcSA9IGttYWxsb2MocmVxc2l6ZSArIGNjLT5pdl9zaXpl
LCBHRlBfTk9JTyk7CiAJaWYgKCFyZXEpCi0tIApFbWFpbDogSGVyYmVydCBYdSA8aGVyYmVydEBn
b25kb3IuYXBhbmEub3JnLmF1PgpIb21lIFBhZ2U6IGh0dHA6Ly9nb25kb3IuYXBhbmEub3JnLmF1
L35oZXJiZXJ0LwpQR1AgS2V5OiBodHRwOi8vZ29uZG9yLmFwYW5hLm9yZy5hdS9+aGVyYmVydC9w
dWJrZXkudHh0Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0
dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

