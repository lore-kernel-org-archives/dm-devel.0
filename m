Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91EEDC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  4 May 2022 19:52:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-Ki6C9Lb9Pl-wk_vFe105YQ-1; Wed, 04 May 2022 15:52:15 -0400
X-MC-Unique: Ki6C9Lb9Pl-wk_vFe105YQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A953A1014A64;
	Wed,  4 May 2022 19:52:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 79555156D125;
	Wed,  4 May 2022 19:52:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3A7071947046;
	Wed,  4 May 2022 19:52:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DA04B1947043
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 19:52:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BDCBD40D1B9F; Wed,  4 May 2022 19:52:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B9E4640D1B9E
 for <dm-devel@redhat.com>; Wed,  4 May 2022 19:52:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F0871C06903
 for <dm-devel@redhat.com>; Wed,  4 May 2022 19:52:10 +0000 (UTC)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com
 [209.85.208.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-M6TfnT5POZqmTK7UTCCGrQ-1; Wed, 04 May 2022 15:52:08 -0400
X-MC-Unique: M6TfnT5POZqmTK7UTCCGrQ-1
Received: by mail-lj1-f180.google.com with SMTP id t25so3015457ljd.6
 for <dm-devel@redhat.com>; Wed, 04 May 2022 12:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=Ruflxs9cgYtfpu+uYRY9OHjS7xb2bTFhKtX7f5MDGy0=;
 b=6ARAYK1PW5zw/gK8QTfaaO0fIRIWDLLs3bUfPCqc8/pliDVOwW+mTlQCp1aWgN6NwH
 8WK2GJa6sDtxtiPDgodbgu73b58YNClKKKXjbWdDZgig0OFhSsf3yokh0LsrDvw29shS
 PvgemOoCQEPWJXiymc2jz6Qp/9fdj1dJp3OjOBQ6zzqScE5EYRIbAhwuVzR6z3iFGL8k
 7JtoGAeXjYIMDTuCMaI9/0Jp1iJ3iJv910wsJmoEOnzSjRRLwhsWDLkMeCYV65B1j30l
 bfRfyVVQSQz6ivt1Mzk+SySImR6kaKoVQC4BhNW34K/a48vOYvggBcAMmAY3lKIRRfxy
 yr3w==
X-Gm-Message-State: AOAM530jO/Z7jqV2RhZUHQQvzobFmYpxCkje/eJacmo23BFOnVJt5nMG
 /nJT1DYqqWWr+c7YQ2KNLTthm1R2Yv+/Se2fZgM=
X-Google-Smtp-Source: ABdhPJyHKsEepUn+HxbgsuWK1CIPAHdMHPzcUjRW3lygBZbKXt/E6YcYv9YuM05pOYTjLI0vrhEYcA==
X-Received: by 2002:a2e:8210:0:b0:250:87c9:fb69 with SMTP id
 w16-20020a2e8210000000b0025087c9fb69mr1547151ljg.470.1651693926972; 
 Wed, 04 May 2022 12:52:06 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com.
 [209.85.208.181]) by smtp.gmail.com with ESMTPSA id
 v4-20020a197404000000b0047255d21152sm1285282lfe.129.2022.05.04.12.52.05
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 May 2022 12:52:06 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id m23so3045349ljc.0
 for <dm-devel@redhat.com>; Wed, 04 May 2022 12:52:05 -0700 (PDT)
X-Received: by 2002:a2e:8245:0:b0:24b:48b1:a1ab with SMTP id
 j5-20020a2e8245000000b0024b48b1a1abmr13338399ljh.152.1651693925440; Wed, 04
 May 2022 12:52:05 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec> <YnJI4Ru0AlUgrr9C@zx2c4.com>
 <YnJOCbLtdATzC+jn@zx2c4.com>
 <YnJQXr3igEMTqY3+@smile.fi.intel.com> <YnJSQ3jJyvhmIstD@zx2c4.com>
 <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
 <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com>
In-Reply-To: <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 May 2022 12:51:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiaj8SMSQTWAx2cUFqzRWRqBspO5YV=qA8M+QOC2vDorw@mail.gmail.com>
Message-ID: <CAHk-=wiaj8SMSQTWAx2cUFqzRWRqBspO5YV=qA8M+QOC2vDorw@mail.gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v2] hex2bin: make the function hex_to_bin
 constant-time
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
Cc: Andy Shevchenko <andy@kernel.org>, Mike Snitzer <msnitzer@redhat.com>,
 Andy Shevchenko <andriy.shevchenko@intel.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>, Milan Broz <gmazyland@gmail.com>,
 device-mapper development <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Stafford Horne <shorne@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBNYXkgNCwgMjAyMiBhdCAxMjo0MyBQTSBKYXNvbiBBLiBEb25lbmZlbGQgPEphc29u
QHp4MmM0LmNvbT4gd3JvdGU6Cj4KPiDXkC5jYyBpcyBjb3JyZWN0LiBJZiB5b3UgY2FuJ3QgbG9h
ZCBpdCwgeW91ciBicm93c2VyIG9yIHNvbWV0aGluZyBpbgo+IHlvdXIgc3RhY2sgaXMgYnJva2Vu
LgoKSXQncyBqdXN0IGdvb2dsZS1jaHJvbWUuCgpBbmQgaG9uZXN0bHksIHRoZSBsYXN0IHRoaW5n
IEkgd2FudCB0byBldmVyIHNlZSBpcyBub24tQVNDSUkgVVJMJ3MuCgpQYXJ0aWN1bGFybHkgZnJv
bSBhIHNlY3VyaXR5IHBlcnNvbi4gSXQncyBhICpIT1JSSUJMRSogaWRlYSB3aXRoCmhvbW9nbHlw
aHMsIGFuZCBwZXJzb25hbGx5IEkgdGhpbmsgYW55IGJyb3dzZXIgdGhhdCByZWZ1c2VzIHRvIGxv
b2sgaXQKdXAgd291bGQgYmUgZG9pbmcgdGhlIHJpZ2h0IHRoaW5nLgoKQnV0IEkgZG9uJ3QgdGhp
bmsgdGhhdCBpdCdzIHRoZSBicm93c2VyLCBhY3R1YWxseS4gRXZlbiAnbnNsb29rdXAnCnJlZnVz
ZXMgdG8gdG91Y2ggaXQgd2l0aAoKICAgKiogc2VydmVyIGNhbid0IGZpbmQg15AuY2M6IFNFUlZG
QUlMCgphbmQgaXQgc2VlbXMgaXQncyBsaXRlcmFsbHkgdGhlIGxvY2FsIGRucyBjYWNoaW5nIChk
bnNtYXNxPykKCj4gQ2hvb3NpbmcgYSBub24tQVNDSUkgZG9tYWluIGxpa2UgdGhhdCBjbGVhcmx5
IGEKPiBiYWQgZGVjaXNpb24gYmVjYXVzZSBwZW9wbGUgd2l0aCBicm9rZW4gc3RhY2tzIGNhbid0
IGxvYWQgaXQ/CgpOby4gSXQncyBhIGJhZCBpZGVhLiBGdWxsIHN0b3AuIERvbid0IGRvIGl0LgoK
ICAgICAgICAgICAgICAgTGludXMKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEBy
ZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWwK

