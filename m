Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2967AC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  5 May 2022 07:13:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-LPVUNtlrN8CrF7IOphEcfQ-1; Thu, 05 May 2022 03:13:21 -0400
X-MC-Unique: LPVUNtlrN8CrF7IOphEcfQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21F233C0D196;
	Thu,  5 May 2022 07:13:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0746747500A;
	Thu,  5 May 2022 07:13:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 96F8C1940342;
	Thu,  5 May 2022 07:13:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C23481947043
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 20:12:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9909854EAEA; Wed,  4 May 2022 20:12:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 945E654E892
 for <dm-devel@redhat.com>; Wed,  4 May 2022 20:12:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C47719711CC
 for <dm-devel@redhat.com>; Wed,  4 May 2022 20:12:22 +0000 (UTC)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com
 [209.85.214.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-0cy2EE7DM--Z2951V1dLlA-1; Wed, 04 May 2022 16:12:19 -0400
X-MC-Unique: 0cy2EE7DM--Z2951V1dLlA-1
Received: by mail-pl1-f169.google.com with SMTP id p6so1905254plr.12;
 Wed, 04 May 2022 13:12:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=qRWAIQw/IQGnxhtZ+qeDmVqe+g63JTPwUddID9hVwPc=;
 b=szVaXEY27Kg5aGBXDMsbM5U+1jzFuxRsCdiqUEFD9dkwX+OCwerEnQpsP5aejTBI4u
 GolUcYzaVaogK+FflhvZLuUtiC6vlMd03eou2OSHZ0EKDynQO5IURua6cA8pfIYHT5p0
 q2FQZ7m9bUz72lka731bx0JCosvekE04LNRgwc/syw4+2xcOTFCkeL1RuYlGX6nCWhl9
 3qSjfkFAv3Cs2BAvNOL1oEqR8tle8tNPDiEuxdPbPRf5GrgrsTZDOcKMeGvTWAY561HC
 3J9cqXHc97dvjpFsfPlUjcoFnlh3/N+lBQgruM5vtVrNpF08dV5dFwHLh2KWzNKmHfGu
 1MQQ==
X-Gm-Message-State: AOAM5303PwRKCloBFzpYeqbtvjjLXc42na7meoM56AJ6BGpxyKEu4hGz
 LAtsyiM+MzY716IE0Mw46oE=
X-Google-Smtp-Source: ABdhPJw0eygHe7YDsvldepG8YCfg1Ft4sqoT4+TIh/1Abp3rkY+dD00P8oCCOu/eRtbyjmdTUMzUug==
X-Received: by 2002:a17:902:ec8c:b0:15e:a371:ad7d with SMTP id
 x12-20020a170902ec8c00b0015ea371ad7dmr16837828plg.12.1651695137514; 
 Wed, 04 May 2022 13:12:17 -0700 (PDT)
Received: from localhost ([2409:10:24a0:4700:e8ad:216a:2a9d:6d0c])
 by smtp.gmail.com with ESMTPSA id
 kz2-20020a17090b210200b001cd4989febasm3668308pjb.6.2022.05.04.13.12.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 04 May 2022 13:12:16 -0700 (PDT)
Date: Thu, 5 May 2022 05:12:15 +0900
From: Stafford Horne <shorne@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YnLeH7kBImX5XLNn@antec>
References: <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec> <YnJI4Ru0AlUgrr9C@zx2c4.com>
 <YnJOCbLtdATzC+jn@zx2c4.com> <YnJQXr3igEMTqY3+@smile.fi.intel.com>
 <YnJSQ3jJyvhmIstD@zx2c4.com>
 <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
 <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com>
 <CAHk-=wiaj8SMSQTWAx2cUFqzRWRqBspO5YV=qA8M+QOC2vDorw@mail.gmail.com>
 <CAHk-=witNAEG7rRsbxD0-4mxhtijRT8fwSc3QCi5HN1sR=0YcA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHk-=witNAEG7rRsbxD0-4mxhtijRT8fwSc3QCi5HN1sR=0YcA@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Thu, 05 May 2022 07:13:10 +0000
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
Cc: Andy Shevchenko <andy@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Mike Snitzer <msnitzer@redhat.com>,
 Andy Shevchenko <andriy.shevchenko@intel.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>, Milan Broz <gmazyland@gmail.com>,
 device-mapper development <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBNYXkgMDQsIDIwMjIgYXQgMDE6MDA6MzZQTSAtMDcwMCwgTGludXMgVG9ydmFsZHMg
d3JvdGU6Cj4gT24gV2VkLCBNYXkgNCwgMjAyMiBhdCAxMjo1MSBQTSBMaW51cyBUb3J2YWxkcwo+
IDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZz4gd3JvdGU6Cj4gPgo+ID4gQnV0IEkgZG9u
J3QgdGhpbmsgdGhhdCBpdCdzIHRoZSBicm93c2VyLCBhY3R1YWxseS4gRXZlbiAnbnNsb29rdXAn
Cj4gPiByZWZ1c2VzIHRvIHRvdWNoIGl0IHdpdGgKPiA+Cj4gPiAgICAqKiBzZXJ2ZXIgY2FuJ3Qg
ZmluZCDXkC5jYzogU0VSVkZBSUwKPiA+Cj4gPiBhbmQgaXQgc2VlbXMgaXQncyBsaXRlcmFsbHkg
dGhlIGxvY2FsIGRucyBjYWNoaW5nIChkbnNtYXNxPykKPiAKPiBMb29rcyBsaWtlIEZlZG9yYSBi
dWlsZHMgZG5zbWFzcSB3aXRoICduby1pMThuJywgYWx0aG91Z2ggImRuc21hc3EgLXYiCj4gYWxz
byBzaG93cyAiSUROMiIsIHNvIHdobyBrbm93cy4uIE1heWJlIGl0J3Mgc29tZSBkZWZhdWx0IGNv
bmZpZyBpc3N1ZQo+IHJhdGhlciB0aGFuIHRoZSBidWlsZCBjb25maWd1cmF0aW9uLgo+IAo+ICAg
ICAgICAgICAgICAgICAgIExpbnVzCgpXaGljaCB2ZXJzaW9uIG9mIEZlZG9yYT8gSSB1c2UgYSBw
cmV0dHkgdmFuaWxsYSBGZWRvcmEgMzQgaW5zdGFsbCBhbmQgaXQgc2VlbXMgdG8KYmUgd29ya2lu
ZyBvayBmb3IgbWUuCgogICAgc2hvcm5lQGFudGVjICQgZGlnICtzaG9ydCDXkC5jYwogICAgMTQ3
Ljc1Ljc5LjIxMwogICAgc2hvcm5lQGFudGVjICQgbnNsb29rdXAg15AuY2MKICAgIFNlcnZlcjog
ICAgICAgICAxMjcuMC4wLjUzCiAgICBBZGRyZXNzOiAgICAgICAgMTI3LjAuMC41MyM1MwoKICAg
IE5vbi1hdXRob3JpdGF0aXZlIGFuc3dlcjoKICAgIE5hbWU6ICAg15AuY2MKICAgIEFkZHJlc3M6
IDE0Ny43NS43OS4yMTMKICAgIE5hbWU6ICAg15AuY2MKICAgIEFkZHJlc3M6IDI2MDQ6MTM4MDox
OjRkMDA6OjUKCiAgICBzaG9ybmVAYW50ZWMgJCAvbGliNjQvbGQtbGludXgteDg2LTY0LnNvLjIg
LS12ZXJzaW9uCiAgICBsZC5zbyAoR05VIGxpYmMpIHJlbGVhc2UgcmVsZWFzZSB2ZXJzaW9uIDIu
MzMuCiAgICBDb3B5cmlnaHQgKEMpIDIwMjEgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uLCBJbmMu
CiAgICBUaGlzIGlzIGZyZWUgc29mdHdhcmU7IHNlZSB0aGUgc291cmNlIGZvciBjb3B5aW5nIGNv
bmRpdGlvbnMuCiAgICBUaGVyZSBpcyBOTyB3YXJyYW50eTsgbm90IGV2ZW4gZm9yIE1FUkNIQU5U
QUJJTElUWSBvciBGSVRORVNTIEZPUiBBCiAgICBQQVJUSUNVTEFSIFBVUlBPU0UuCgogICAgc2hv
cm5lQGFudGVjICQgY2F0IC9ldGMvcmVkaGF0LXJlbGVhc2UKICAgIEZlZG9yYSByZWxlYXNlIDM0
IChUaGlydHkgRm91cikKCi1TdGFmZm9yZAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRl
dmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbAo=

