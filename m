Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECDACC6FD1D
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 22:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680215412;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=o5axBU44uIIRfmoA2aQ9ycWSgz6l3OMJBoZoWtNR5Hc=;
	b=UAGAf2QbQAe/uEKXVhe25QHhziveI9srYgXxrKs0OxNx8rNbHOIvTQ/l0qya2ZHHK+Xwu5
	QDJsLH5aG6rDoE69t4w2y0gSE8qFZJZqrUvKAvIiLG3Llznl8FJXda3D8N2JkUR26E0TD6
	PoKfQjCuo3A3dTt7t9m+V4TOHvjKses=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-_ktPsqg-MjOHImeDorz4oA-1; Thu, 30 Mar 2023 18:30:08 -0400
X-MC-Unique: _ktPsqg-MjOHImeDorz4oA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFC091008131;
	Thu, 30 Mar 2023 22:30:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A09E4492B00;
	Thu, 30 Mar 2023 22:30:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6385F194658F;
	Thu, 30 Mar 2023 22:30:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1DAE11946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 30 Mar 2023 22:30:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F13412166B34; Thu, 30 Mar 2023 22:30:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E9D2B2166B33
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 22:30:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B39F8101A550
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 22:30:04 +0000 (UTC)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-unDzl0WUMI29pSoUlyS_iQ-1; Thu, 30 Mar 2023 18:29:59 -0400
X-MC-Unique: unDzl0WUMI29pSoUlyS_iQ-1
Received: by mail-pj1-f50.google.com with SMTP id
 h12-20020a17090aea8c00b0023d1311fab3so21367999pjz.1; 
 Thu, 30 Mar 2023 15:29:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1680215398;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=x7V03//xrMoj2maIfgC2qsiNLnzTtZRlKFOvF+x+bJg=;
 b=Q5YsJXbHZKVhy46sO8FzjGmG+sDHDnfyLUCfNcPMvnqmNoOW0iwDLAb4y0q2tbiP5Z
 14AZfA6SdrVGwBESsW9ZJixh8DNAIQWGeu3cvMVpPVT7nBtm5iw+H8oCWg/Axi5x8Oqi
 ePWsoKq7pjH0FqV2XiGu58sOMCOmQYZ+DozQ3/xThwhlq8WOZPgfXRROJ1j+nOvVevu0
 sIgESk2LLboWWth5E3EKUMFAuMg8TS8YqQ834A/n/LDywK1Dc8DupREkrZkWqbRuzYjt
 HeMJT5TUm9WGmbb6OSTYhF3ViUFnnD+b4Hglqi61Vidsy10GizPhpqr+juSRiOj3GDKC
 CK8g==
X-Gm-Message-State: AAQBX9eLjevjwuODn8GpFz67V/j9B3DF9LJ6c5eC3A0fx0Q1AmNmZvTr
 zVDtwSG8ZfTNur8q6cI9cH10JDFQdQBVtGLEioA=
X-Google-Smtp-Source: AKy350ZrPyR1hRVTBuZnQUpMEn54ihWHCa7XbNjYLmiSy4XxnRAJ80dimqjvvbOmN9ocOuC+cire+hzLe0DMBMrzkWw=
X-Received: by 2002:a17:90a:fb57:b0:23d:30c2:c5b7 with SMTP id
 iq23-20020a17090afb5700b0023d30c2c5b7mr2603971pjb.3.1680215397861; Thu, 30
 Mar 2023 15:29:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1680108414.git.johannes.thumshirn@wdc.com>
 <beea645603eccbb045ad9bb777e05a085b91808a.1680108414.git.johannes.thumshirn@wdc.com>
 <3a0f0c92-63cb-3624-c2fe-049a76d1a64a@opensource.wdc.com>
 <CAHbLzkoRdTTbnfz3RyLQAeNJBOEVNGL2WLgRSE2eQ4nR8sRe2g@mail.gmail.com>
 <b19696d3-54bb-d997-5e56-aa5fd58b469f@opensource.wdc.com>
In-Reply-To: <b19696d3-54bb-d997-5e56-aa5fd58b469f@opensource.wdc.com>
From: Yang Shi <shy828301@gmail.com>
Date: Thu, 30 Mar 2023 15:29:46 -0700
Message-ID: <CAHbLzkrEXVDf4TYLw_MPrFNybWQHWXKX=zP5GhxHQFdpVPWhEg@mail.gmail.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 18/19] dm-crypt: check if adding pages to
 clone bio fails
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Song Liu <song@kernel.org>, Dave Kleikamp <shaggy@kernel.org>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Mike Snitzer <snitzer@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org, dm-devel@redhat.com, David Sterba <dsterba@suse.com>,
 linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-btrfs@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBNYXIgMjksIDIwMjMgYXQgNToyNOKAr1BNIERhbWllbiBMZSBNb2FsCjxkYW1pZW4u
bGVtb2FsQG9wZW5zb3VyY2Uud2RjLmNvbT4gd3JvdGU6Cj4KPiBPbiAzLzMwLzIzIDA5OjE3LCBZ
YW5nIFNoaSB3cm90ZToKPiA+IE9uIFdlZCwgTWFyIDI5LCAyMDIzIGF0IDQ6NDnigK9QTSBEYW1p
ZW4gTGUgTW9hbAo+ID4gPGRhbWllbi5sZW1vYWxAb3BlbnNvdXJjZS53ZGMuY29tPiB3cm90ZToK
PiA+Pgo+ID4+IE9uIDMvMzAvMjMgMDI6MDYsIEpvaGFubmVzIFRodW1zaGlybiB3cm90ZToKPiA+
Pj4gQ2hlY2sgaWYgYWRkaW5nIHBhZ2VzIHRvIGNsb25lIGJpbyBmYWlscyBhbmQgaWYgYmFpbCBv
dXQuCj4gPj4KPiA+PiBOb3BlLiBUaGUgY29kZSByZXRyaWVzIHdpdGggZGlyZWN0IHJlY2xhaW0g
dW50aWwgaXQgc3VjY2VlZHMuIFdoaWNoIGlzIHZlcnkKPiA+PiBzdXNwaWNpb3VzLi4uCj4gPgo+
ID4gSXQgaXMgbm90IHJlbGF0ZWQgdG8gYmlvX2FkZF9wYWdlKCkgZmFpbHVyZS4gSXQgaXMgdXNl
ZCB0byBhdm9pZCBhCj4gPiByYWNlIGNvbmRpdGlvbiB3aGVuIHR3byBwcm9jZXNzZXMgYXJlIGRl
cGxldGluZyB0aGUgbWVtcG9vbAo+ID4gc2ltdWx0YW5lb3VzbHkuCj4gPgo+ID4gSUlVQyBJIGRv
bid0IHRoaW5rIHBhZ2UgbWVyZ2UgbWF5IGhhcHBlbiBmb3IgZG0tY3J5cHQsIHNvIGlzCj4gPiBf
X2Jpb19hZGRfcGFnZSgpIGdvb2QgZW5vdWdoPyBJJ20gd29ya2luZyBvbiB0aGlzIGNvZGUgdG9v
LCB1c2luZwo+ID4gX19iaW9fYWRkX3BhZ2UoKSB3b3VsZCBtYWtlIG15IHBhdGNoIGVhc2llci4K
Pgo+IElmIHRoZSBCSU8gd2FzIGFsbG9jYXRlZCB3aXRoIGVub3VnaCBidmVjcywgd2UgY291bGQg
dXNlIHRoYXQgZnVuY3Rpb24uIEJ1dCBwYWdlCj4gbWVyZ2luZyByZWR1Y2VzIG92ZXJoZWFkLCBz
byBpZiBpdCBjYW4gaGFwcGVuLCBsZXQncyB1c2UgaXQuCgpJdCBkb2VzIGFsbG9jYXRlIEJJTyB3
aXRoIGVub3VnaCBidmVjcy4gSUlVQyBpdCB3aWxsIG1lcmdlIHRoZQphZGphY2VudCBwYWdlcz8g
SWYgc28gcGFnZSBtZXJnaW5nIG1heSBoYXBwZW4uIFNpbmNlIGRtLWNyeXB0IGRvZXMKYWxsb2Nh
dGUgQklPIHdpdGggZW5vdWdoIGJ2Y2VzLCBzbyBpdCBjYW4ndCBmYWlsIGlmIEkgcmVhZCB0aGUg
Y29kZQpjb3JyZWN0bHkuIEknbSB3b25kZXJpbmcgd2hldGhlciB3ZSBjb3VsZCBoYXZlIGEgbmV2
ZXIgZmFpbCB2YXJpYW50LgoKPgo+ID4KPiA+Pgo+ID4+Pgo+ID4+PiBUaGlzIHdheSB3ZSBjYW4g
bWFyayBiaW9fYWRkX3BhZ2VzIGFzIF9fbXVzdF9jaGVjay4KPiA+Pj4KPiA+Pj4gU2lnbmVkLW9m
Zi1ieTogSm9oYW5uZXMgVGh1bXNoaXJuIDxqb2hhbm5lcy50aHVtc2hpcm5Ad2RjLmNvbT4KPiA+
Pgo+ID4+IFdpdGggdGhlIGNvbW1pdCBtZXNzYWdlIGZpeGVkLAo+ID4+Cj4gPj4gUmV2aWV3ZWQt
Ynk6IERhbWllbiBMZSBNb2FsIDxkYW1pZW4ubGVtb2FsQG9wZW5zb3VyY2Uud2RjLmNvbT4KPiA+
Pgo+ID4+Cj4gPj4gLS0KPiA+PiBEYW1pZW4gTGUgTW9hbAo+ID4+IFdlc3Rlcm4gRGlnaXRhbCBS
ZXNlYXJjaAo+ID4+Cj4gPj4KPgo+IC0tCj4gRGFtaWVuIExlIE1vYWwKPiBXZXN0ZXJuIERpZ2l0
YWwgUmVzZWFyY2gKPgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5j
b20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

