Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3F34C77B7A
	for <dm-devel@archiver.kernel.org>; Thu, 25 May 2023 06:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684996974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=n2OaL+eWk7ALkTBKARHBCFCXjN2ocbIqxg+3Rm4tdrs=;
	b=AMaJ7Vz+HMGPXynll5HBOsRsovHMDGxyclYXW7d9rOe6Rd8rCJJosrHrXPL2JAVtH/znPE
	WKhx6v8TriEjfSF/UY/6PlBJAsuCwn+tU0vuHGXm07x+I6MtSa090A2b8qus8WWX7uoqxp
	81plIVA8Ds7+6EfJW7AwmUYYmJiA1zs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-bS9cWZq-MsCcAZBqGhzv0A-1; Thu, 25 May 2023 02:42:50 -0400
X-MC-Unique: bS9cWZq-MsCcAZBqGhzv0A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0C8E3C0C894;
	Thu, 25 May 2023 06:42:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6412E40CFD00;
	Thu, 25 May 2023 06:42:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 28AD319465A4;
	Thu, 25 May 2023 06:42:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8D3FC19465A0
 for <dm-devel@listman.corp.redhat.com>; Thu, 25 May 2023 06:42:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6EF2940CFD01; Thu, 25 May 2023 06:42:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6757840CFD00
 for <dm-devel@redhat.com>; Thu, 25 May 2023 06:42:44 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C401185A78F
 for <dm-devel@redhat.com>; Thu, 25 May 2023 06:42:44 +0000 (UTC)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-DsPg985IOVyK_CwAEqgGSA-1; Thu, 25 May 2023 02:42:42 -0400
X-MC-Unique: DsPg985IOVyK_CwAEqgGSA-1
Received: by mail-pj1-f43.google.com with SMTP id
 98e67ed59e1d1-25372604818so802401a91.2
 for <dm-devel@redhat.com>; Wed, 24 May 2023 23:42:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684996961; x=1687588961;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=RP9FD88UkFVMHShTHtEKtDxspdlacPg7hzEI1lBXYXo=;
 b=HEhcL/GsOnUbZ2sHw3+JP9CXw2F4V3z0APj7HiOfTWSuP5AD55UZPul+efys3/p72R
 hVzK3oU4FJvNFDVTkhYDEHC7TS1GoPjl77XhzNMnssz3D4qSruHvSbMjzWY7dXDDRtpm
 nhjsap0Zfu4VvGHdcTnewlggfqXv5YC6qxUjJtH/QslI1egDfq/rV+HKST+cPQA8L1QS
 jCwfNPm7wYi6eRwIDje8lFvRRiR/txTJpJ9ExSmxniPuu5n+yn10eaADpR9aIm0c03N+
 MbJQYjVP1WAz6uFkpkK2You6tqCfUsMBaJ8GIJ6Pw9GvMJs+IP/tvTjT707CqvkBACj2
 LD3A==
X-Gm-Message-State: AC+VfDyvVYbC1PJHjcD2z0JVLmMF7wYQzm5B9/m1O06KTgiBkVlkOVJw
 S2turLHa5KaMzut5ZjfthHScW4JANZ26X6PRr2KIIg==
X-Google-Smtp-Source: ACHHUZ4Fhrsl0+4imuJWNgdZFCCVBsdlgplnfxSwnr/0TiSEycnFHQqFp3Ctt0QArNetg8P4LM6f7gBY5sX69753HJ8=
X-Received: by 2002:a17:90a:f2ce:b0:24d:ee34:57b6 with SMTP id
 gt14-20020a17090af2ce00b0024dee3457b6mr582694pjb.41.1684996961014; Wed, 24
 May 2023 23:42:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230523075857.76520-1-duoming@zju.edu.cn>
 <ZGz9k3jnVqiO20a2@redhat.com>
 <89fc5b.4de4d.18850c1b97f.Coremail.duoming@zju.edu.cn>
In-Reply-To: <89fc5b.4de4d.18850c1b97f.Coremail.duoming@zju.edu.cn>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Thu, 25 May 2023 07:42:29 +0100
Message-ID: <CALrw=nGt6c824fYnArXDbxmOux=61vJR=s6S5ZU2rZY=NhzRbw@mail.gmail.com>
To: duoming@zju.edu.cn
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] dm crypt: fix sleep-in-atomic-context bug in
 kcryptd_crypt_tasklet
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: cloudflare.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SEksCgpPbiBUaHUsIE1heSAyNSwgMjAyMyBhdCAzOjM04oCvQU0gPGR1b21pbmdAemp1LmVkdS5j
bj4gd3JvdGU6Cj4KPiBIZWxsbywKPgo+IE9uIFR1ZSwgMjMgTWF5IDIwMjMgMTM6NTM6MjMgLTA0
MDAgTWlrZSBTbml0emVyIHdyb3RlOgo+Cj4gPiA+IEluIG9yZGVyIHRvIGltcHJvdmUgdGhlIElP
IHBlcmZvcm1hbmNlIG9mIHRoZSBkbS1jcnlwdAo+ID4gPiBpbXBsZW1lbnRhdGlvbiwgdGhlIGNv
bW1pdCAzOWQ0MmZhOTZiYTEgKCJkbSBjcnlwdDoKPiA+ID4gYWRkIGZsYWdzIHRvIG9wdGlvbmFs
bHkgYnlwYXNzIGtjcnlwdGQgd29ya3F1ZXVlcyIpCj4gPiA+IGFkZHMgdGFza2xldCB0byBkbyB0
aGUgY3J5cHRvIG9wZXJhdGlvbnMuCj4gPiA+Cj4gPiA+IFRoZSB0YXNrbGV0IGNhbGxiYWNrIGZ1
bmN0aW9uIGtjcnlwdGRfY3J5cHRfdGFza2xldCgpCj4gPiA+IGNhbGxzIGtjcnlwdGRfY3J5cHQo
KSB3aGljaCBpcyBhbiBvcmlnaW5hbCB3b3JrcXVldWUKPiA+ID4gY2FsbGJhY2sgZnVuY3Rpb24g
dGhhdCBtYXkgc2xlZXAuIEFzIGEgcmVzdWx0LCB0aGUKPiA+ID4gc2xlZXAtaW4tYXRvbWljLWNv
bnRleHQgYnVnIG1heSBoYXBwZW4uIFRoZSBwcm9jZXNzCj4gPiA+IGlzIHNob3duIGJlbG93Lgo+
ID4gPgo+ID4gPiAgICAoYXRvbWljIGNvbnRleHQpCgpEaWQgeW91IGFjdHVhbGx5IGVuY291bnRl
ciB0aGlzIGluIHByYWN0aWNlPyBJIGtub3cgaXQgaXMgcG9zc2libGUKZnJvbSB0aGUgZG0tY3J5
cHQgY29kZSBwZXJzcGVjdGl2ZSwgYnV0IGR1cmluZyBteSBpbml0aWFsIHRlc3RpbmcgSQpjb3Vs
ZCBuZXZlciB0cmlnZ2VyIGEgc2V0dXAgd2hlbiB0aGUgd3JpdGUgcGF0aCB3YXMgaGFwcGVuaW5n
IGluCmF0b21pYyBjb250ZXh0Cgo+ID4gPiBrY3J5cHRkX2NyeXB0X3Rhc2tsZXQoKQo+ID4gPiAg
IGtjcnlwdGRfY3J5cHQoKQo+ID4gPiAgICAga2NyeXB0ZF9jcnlwdF93cml0ZV9jb252ZXJ0KCkK
PiA+ID4gICAgICAgd2FpdF9mb3JfY29tcGxldGlvbigpIC8vbWF5IHNsZWVwCj4gPiA+Cj4gPiA+
IFRoZSB3YWl0X2Zvcl9jb21wbGV0aW9uKCkgaXMgYSBmdW5jdGlvbiB0aGF0IG1heSBzbGVlcC4K
PiA+ID4gSW4gb3JkZXIgdG8gbWl0aWdhdGUgdGhlIGJ1ZywgdGhpcyBwYXRjaCBjaGFuZ2VzCj4g
PiA+IHdhaXRfZm9yX2NvbXBsZXRpb24oKSB0byB0cnlfd2FpdF9mb3JfY29tcGxldGlvbigpLgo+
ID4gPgo+ID4gPiBGaXhlczogMzlkNDJmYTk2YmExICgiZG0gY3J5cHQ6IGFkZCBmbGFncyB0byBv
cHRpb25hbGx5IGJ5cGFzcyBrY3J5cHRkIHdvcmtxdWV1ZXMiKQo+ID4gPiBTaWduZWQtb2ZmLWJ5
OiBEdW9taW5nIFpob3UgPGR1b21pbmdAemp1LmVkdS5jbj4KPiA+ID4gLS0tCj4gPiA+ICBkcml2
ZXJzL21kL2RtLWNyeXB0LmMgfCAzICsrLQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbigtKQo+ID4gPgo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9t
ZC9kbS1jcnlwdC5jIGIvZHJpdmVycy9tZC9kbS1jcnlwdC5jCj4gPiA+IGluZGV4IDhiNDdiOTEz
ZWU4Li41ZTJiMjQ2M2Q4NyAxMDA2NDQKPiA+ID4gLS0tIGEvZHJpdmVycy9tZC9kbS1jcnlwdC5j
Cj4gPiA+ICsrKyBiL2RyaXZlcnMvbWQvZG0tY3J5cHQuYwo+ID4gPiBAQCAtMjA4NSw3ICsyMDg1
LDggQEAgc3RhdGljIHZvaWQga2NyeXB0ZF9jcnlwdF93cml0ZV9jb252ZXJ0KHN0cnVjdCBkbV9j
cnlwdF9pbyAqaW8pCj4gPiA+ICAgICBjcnlwdF9maW5pc2hlZCA9IGF0b21pY19kZWNfYW5kX3Rl
c3QoJmN0eC0+Y2NfcGVuZGluZyk7Cj4gPiA+ICAgICBpZiAoIWNyeXB0X2ZpbmlzaGVkICYmIGtj
cnlwdGRfY3J5cHRfd3JpdGVfaW5saW5lKGNjLCBjdHgpKSB7Cj4gPiA+ICAgICAgICAgICAgIC8q
IFdhaXQgZm9yIGNvbXBsZXRpb24gc2lnbmFsZWQgYnkga2NyeXB0ZF9hc3luY19kb25lKCkgKi8K
PiA+ID4gLSAgICAgICAgICAgd2FpdF9mb3JfY29tcGxldGlvbigmY3R4LT5yZXN0YXJ0KTsKPiA+
ID4gKyAgICAgICAgICAgd2hpbGUgKCF0cnlfd2FpdF9mb3JfY29tcGxldGlvbigmY3R4LT5yZXN0
YXJ0KSkKPiA+ID4gKyAgICAgICAgICAgICAgICAgICA7CgpXZSBjYW4ndCBqdXN0IGJ1c3ktbG9v
cCBoZXJlLiBUaGlzIGVmZmVjdGl2ZWx5IGNyZWF0ZXMgYSBzcGluLWxvY2suCkFuZCBwcm9iYWJs
eSBvbiBhIHNpbmdsZSBDUFUgc3lzdGVtIGl0IHdvdWxkIGhhbmcgZXZlcnl0aGluZywgYmVjYXVz
ZQp0aGUgY29kZSB3b3VsZCBiZSBzdHVjayBoZXJlIGFuZCB3b3VsZCBuZXZlciBnaXZlIHRoZSBj
aGFuY2UgdG8gb3RoZXIKY29kZSB0byBzaWduYWwgY29tcGxldGlvbi4gWW91IG1pZ2h0IG5lZWQg
dG8gZG8gc29tZXRoaW5nIHNpbWlsYXIgdG8KaG93IGNyeXB0X2NvbnZlcnQgaGFuZGxlcyB0aGlz
IGZvciAiRUJVU1kiIGNhc2UuCgo+ID4gPiAgICAgICAgICAgICBjcnlwdF9maW5pc2hlZCA9IDE7
Cj4gPiA+ICAgICB9Cj4gPiA+Cj4gPiA+IC0tCj4gPiA+IDIuMTcuMQo+ID4gPgo+ID4KPiA+IENj
J2luZyBJZ25hdCBmb3IgY2xvc2VyIHJldmlldy4KPiA+Cj4gPiBCdXQgd2Fzbid0IHRoaXMgYWxy
ZWFkeSBhZGRyZXNzZWQgd2l0aCB0aGlzIGNvbW1pdD86Cj4gPiA4YWJlYzM2ZDEyNzQgZG0gY3J5
cHQ6IGRvIG5vdCB3YWl0IGZvciBiYWNrbG9nZ2VkIGNyeXB0byByZXF1ZXN0IGNvbXBsZXRpb24g
aW4gc29mdGlycQo+ID4KPiA+IE1pa2UKPgo+IFRoYW5rIHlvdSBmb3IgeW91ciByZXZpZXcsIEkg
dGhpbmsgdGhlIGNvbW1pdCA4YWJlYzM2ZDEyNzQgKCJkbSBjcnlwdDoKPiBkbyBub3Qgd2FpdCBm
b3IgYmFja2xvZ2dlZCBjcnlwdG8gcmVxdWVzdCBjb21wbGV0aW9uIGluIHNvZnRpcnEiKSBjb3Vs
ZAo+IG5vdCBzb2x2ZSB0aGlzIHByb2JsZW0uCj4KPiBXaGVuIGNyeXB0X2NvbnZlcnQoKSByZXR1
cm5zIEJMS19TVFNfUFJPVEVDVElPTiBvciBCTEtfU1RTX0lPRVJSLCBtZWFud2hpbGUsCj4gdGhl
cmUgaXMgcmVxdWVzdCB0aGF0IGlzIHF1ZXVlZCBhbmQgd2FpdCBrY3J5cHRkX2FzeW5jX2RvbmUo
KSB0byBwcm9jZXNzLgo+IFRoZSB3b3JrcXVldWUgY2FsbGJhY2sgZnVuY3Rpb24ga2NyeXB0ZF9j
cnlwdF9yZWFkX2NvbnRpbnVlKCkgd2lsbCBub3QgYmUgY2FsbGVkLgo+IFRoZSB2YXJpYWJsZSBj
cnlwdF9maW5pc2hlZCBlcXVhbHMgdG8gemVybywgaXQgd2lsbCBjYWxsIHdhaXRfZm9yX2NvbXBs
ZXRpb24oKQo+IHRoYXQgbWF5IHNsZWVwLiBUaGUgcmVsZXZhbnQgY29kZXMgYXJlIHNob3duIGJl
bG93Ogo+Cj4gc3RhdGljIGJsa19zdGF0dXNfdCBjcnlwdF9jb252ZXJ0KC4uLikKPiB7Cj4gLi4u
Cj4gICAgICAgICAgICAgICAgIC8qCj4gICAgICAgICAgICAgICAgICAqIFRoZSByZXF1ZXN0IGlz
IHF1ZXVlZCBhbmQgcHJvY2Vzc2VkIGFzeW5jaHJvbm91c2x5LAo+ICAgICAgICAgICAgICAgICAg
KiBjb21wbGV0aW9uIGZ1bmN0aW9uIGtjcnlwdGRfYXN5bmNfZG9uZSgpIHdpbGwgYmUgY2FsbGVk
Lgo+ICAgICAgICAgICAgICAgICAgKi8KPiAgICAgICAgICAgICAgICAgY2FzZSAtRUlOUFJPR1JF
U1M6Cj4gICAgICAgICAgICAgICAgICAgICAgICAgY3R4LT5yLnJlcSA9IE5VTEw7Cj4gICAgICAg
ICAgICAgICAgICAgICAgICAgY3R4LT5jY19zZWN0b3IgKz0gc2VjdG9yX3N0ZXA7Cj4gICAgICAg
ICAgICAgICAgICAgICAgICAgdGFnX29mZnNldCsrOwo+ICAgICAgICAgICAgICAgICAgICAgICAg
IGNvbnRpbnVlOwo+IC4uLgo+ICAgICAgICAgICAgICAgICAvKgo+ICAgICAgICAgICAgICAgICAg
KiBUaGVyZSB3YXMgYSBkYXRhIGludGVncml0eSBlcnJvci4KPiAgICAgICAgICAgICAgICAgICov
Cj4gICAgICAgICAgICAgICAgIGNhc2UgLUVCQURNU0c6Cj4gICAgICAgICAgICAgICAgICAgICAg
ICAgYXRvbWljX2RlYygmY3R4LT5jY19wZW5kaW5nKTsKPiAgICAgICAgICAgICAgICAgICAgICAg
ICByZXR1cm4gQkxLX1NUU19QUk9URUNUSU9OOwo+ICAgICAgICAgICAgICAgICAvKgo+ICAgICAg
ICAgICAgICAgICAgKiBUaGVyZSB3YXMgYW4gZXJyb3Igd2hpbGUgcHJvY2Vzc2luZyB0aGUgcmVx
dWVzdC4KPiAgICAgICAgICAgICAgICAgICovCj4gICAgICAgICAgICAgICAgIGRlZmF1bHQ6Cj4g
ICAgICAgICAgICAgICAgICAgICAgICAgYXRvbWljX2RlYygmY3R4LT5jY19wZW5kaW5nKTsKPiAg
ICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gQkxLX1NUU19JT0VSUjsKPiAgICAgICAgICAg
ICAgICAgfQo+IC4uLgo+IH0KPgo+IHN0YXRpYyB2b2lkIGtjcnlwdGRfY3J5cHRfd3JpdGVfY29u
dmVydCguLi4pCj4gewo+IC4uLgo+ICAgICAgICAgciA9IGNyeXB0X2NvbnZlcnQoKTsgLy9yZXR1
cm4gQkxLX1NUU19QUk9URUNUSU9OIG9yIEJMS19TVFNfSU9FUlIKPiAuLi4KPiAgICAgICAgIGlm
IChyID09IEJMS19TVFNfREVWX1JFU09VUkNFKSB7IC8vdGhpcyBjb25kaXRpb24gaXMgbm90IHNh
dGlzZmllZCwgdGhlIHdvcmtxdWV1ZSB3aWxsIG5vdCBiZSBjYWxsZWQuCgpTaG91bGQgd2UganVz
dCBoYW5kbGUgQkxLX1NUU19QUk9URUNUSU9OIGFuZCBCTEtfU1RTX0lPRVJSIHNpbWlsYXJseQp0
byBCTEtfU1RTX0RFVl9SRVNPVVJDRT8KCj4gICAgICAgICAgICAgICAgIElOSVRfV09SSygmaW8t
PndvcmssIGtjcnlwdGRfY3J5cHRfd3JpdGVfY29udGludWUpOwo+ICAgICAgICAgICAgICAgICBx
dWV1ZV93b3JrKGNjLT5jcnlwdF9xdWV1ZSwgJmlvLT53b3JrKTsKPiAgICAgICAgICAgICAgICAg
cmV0dXJuOwo+ICAgICAgICAgfQo+IC4uLgo+ICAgICAgICAgLy8gY3J5cHRfZmluaXNoZWQgaXMg
emVybywgYmVjYXVzZSB0aGVyZSBpcyByZXF1ZXN0IHRoYXQgaXMgcXVldWVkIGFuZCB3YWl0IGtj
cnlwdGRfYXN5bmNfZG9uZSgpIHRvIHByb2Nlc3MuCj4gICAgICAgICBjcnlwdF9maW5pc2hlZCA9
IGF0b21pY19kZWNfYW5kX3Rlc3QoJmN0eC0+Y2NfcGVuZGluZyk7Cj4gICAgICAgICBpZiAoIWNy
eXB0X2ZpbmlzaGVkICYmIGtjcnlwdGRfY3J5cHRfd3JpdGVfaW5saW5lKGNjLCBjdHgpKSB7Cj4g
ICAgICAgICAgICAgICAgIC8qIFdhaXQgZm9yIGNvbXBsZXRpb24gc2lnbmFsZWQgYnkga2NyeXB0
ZF9hc3luY19kb25lKCkgKi8KPiAgICAgICAgICAgICAgICAgd2FpdF9mb3JfY29tcGxldGlvbigm
Y3R4LT5yZXN0YXJ0KTsgIC8vbWF5IHNsZWVwIQo+ICAgICAgICAgICAgICAgICAuLi4KPiAgICAg
ICAgIH0KPiAuLi4KPiB9Cj4KPiBCZXN0IHJlZ2FyZHMsCj4gRHVvbWluZyBaaG91Cj4KPgo+Cj4K
CklnbmF0CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

