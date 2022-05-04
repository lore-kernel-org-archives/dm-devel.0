Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E3E3C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  4 May 2022 18:00:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-gz3lcyN9OzC0R-76RvtIZw-1; Wed, 04 May 2022 14:00:27 -0400
X-MC-Unique: gz3lcyN9OzC0R-76RvtIZw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9953C8038E3;
	Wed,  4 May 2022 18:00:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 478F840CF8EA;
	Wed,  4 May 2022 18:00:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1445B1947046;
	Wed,  4 May 2022 18:00:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C0C261947043
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 18:00:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A05D34010A13; Wed,  4 May 2022 18:00:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C01E400D277
 for <dm-devel@redhat.com>; Wed,  4 May 2022 18:00:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CBB43C977C6
 for <dm-devel@redhat.com>; Wed,  4 May 2022 18:00:22 +0000 (UTC)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com
 [209.85.208.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-HHXVVbLoNGqWX8malyrHhg-1; Wed, 04 May 2022 14:00:20 -0400
X-MC-Unique: HHXVVbLoNGqWX8malyrHhg-1
Received: by mail-lj1-f181.google.com with SMTP id l19so2641880ljb.7
 for <dm-devel@redhat.com>; Wed, 04 May 2022 11:00:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=X7nnFcBo5MIhDYQNnEavKTW+QBw/a5S/8r1dgvWPgx4=;
 b=qjiv1Tzvk2doP4zbtxKe7744AA3atdmOfmINe2dFo/YGY/DIcGdxU+ydqNf9QH+/vi
 cBPx9d78j5Zpkytr5abCMerzCGVuB4DSmllKZZyztHNWu1heBv4QgNxKluoDJGN4v5Ma
 v4jsaRtmbrMbyQhB+K/QtOsKZYnyLclYF4BAtxUgmML+2NyyzXWRDQBVUd+hjSesuKih
 PLmidYlDSB/p9UOpqp4+/9kJabRuDfEhjQqrFQnYhSqf23+DHo3tchtTFF8allsj4koC
 qcxbY3/4o3LxJe4gr7UImH2C1Ezm5vZyAbuUWu3/Zm6jYvVlISO6n+ugLp1++HObpFk3
 6GkQ==
X-Gm-Message-State: AOAM533nz/uNRgJvZCQQQTvNP7P2HN2xmBy6nbfYXE0QQKuBjQLlq96q
 upA7lDmqRST0OfMi8Ar5Ff5eZ8jilypsYdVV
X-Google-Smtp-Source: ABdhPJwQv5jfFBeLeNmQLW1sSEC25X5PV3WhjVPysD/ynw6anVRnY6D0O1/KOqRVQKLTKpuL4n0slw==
X-Received: by 2002:a2e:bf1d:0:b0:247:dea7:f657 with SMTP id
 c29-20020a2ebf1d000000b00247dea7f657mr13022205ljr.454.1651687218319; 
 Wed, 04 May 2022 11:00:18 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com.
 [209.85.167.52]) by smtp.gmail.com with ESMTPSA id
 z22-20020ac25df6000000b0047255d21166sm1264738lfq.149.2022.05.04.11.00.17
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 May 2022 11:00:18 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id t25so3668017lfg.7
 for <dm-devel@redhat.com>; Wed, 04 May 2022 11:00:17 -0700 (PDT)
X-Received: by 2002:a05:6512:3c93:b0:44b:4ba:c334 with SMTP id
 h19-20020a0565123c9300b0044b04bac334mr15264136lfv.27.1651687217327; Wed, 04
 May 2022 11:00:17 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec> <YnJI4Ru0AlUgrr9C@zx2c4.com>
 <YnJOCbLtdATzC+jn@zx2c4.com>
 <YnJQXr3igEMTqY3+@smile.fi.intel.com> <YnJSQ3jJyvhmIstD@zx2c4.com>
In-Reply-To: <YnJSQ3jJyvhmIstD@zx2c4.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 May 2022 11:00:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
Message-ID: <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBNYXkgNCwgMjAyMiBhdCAzOjE1IEFNIEphc29uIEEuIERvbmVuZmVsZCA8SmFzb25A
engyYzQuY29tPiB3cm90ZToKPgo+ID4gQWxpZ25tZW50PyBDb21waWxlciBidWc/IEhXIGlzc3Vl
Pwo+Cj4gUHJvYmFibHkgb25lIG9mIHRob3NlLCB5ZWEuIFJlbW92aW5nIHRoZSBpbnN0cnVjdGlv
biBhZGRyZXNzZXMsIHRoZSBvbmx5Cj4gZGlmZmVyZW5jZSBiZXR3ZWVuIHRoZSB0d28gY29tcGls
ZXMgaXM6IGh0dHBzOi8veG4tLTRkYi5jYy9Scm44dXNhWC9kaWZmI2xpbmUtNDQwCgpXZWxsLCB0
aGF0IGFkZHJlc3MgZG9lc24ndCB3b3JrIGZvciBtZSBhdCBhbGwuIEl0IHR1cm5zIGludG8g15Au
Y2MuCgpJJ2QgbG92ZSB0byBzZWUgdGhlIGNvbXBpbGVyIHByb2JsZW0sIHNpbmNlIEkgZmluZCB0
aG9zZSBmYXNjaW5hdGluZwoobWFpbmx5IGJlY2F1c2UgdGhleSBzY2FyZSB0aGUgaGVsbCBvdXQg
b2YgbWUpLCBidXQgdGhvc2Ugd2ViCmFkZHJlc3NlcyB5b3UgdXNlIGFyZSBub3Qgd29ya2luZyBm
b3IgbWUuCgpJdCBtb3N0IGRlZmluaXRlbHkgbG9va3MgbGlrZSBhbiBPcGVuUklTQyBjb21waWxl
ciBidWcgLSB0aGF0IGNvZGUKZG9lc24ndCBsb29rIGxpa2UgaXQgZG9lcyBhbnl0aGluZyByZW1v
dGVseSB1bmRlZmluZWQgKGFuZCB3aXRoIHRoZQoidW5zaWduZWQgY2hhciIsIG5vdGhpbmcgaW1w
bGVtZW50YXRpb24tZGVmaW5lZCBlaXRoZXIpLgoKICAgICAgICAgICAgIExpbnVzCgotLQpkbS1k
ZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

