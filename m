Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B944C6FD18
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 00:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680135889;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4oPSAA5ixJq57Z3dw7wI4y1uCCIfgl6d9+1ZfrQ09FU=;
	b=aQEt0yRcY6eLdXiaWetBXHfadaLvJrkgSZwuZoe2gOUV2ltv5DFMZZZ8dY2X2NDUzFzG4U
	OFRpZdAxc44BpJ73bjIgiGlxbGvT4k3AtdpzaGL+TNHLr82rucU2L0YgkaZ4C8+71dPRtf
	6aOsbjCBaKYLyk2gsfrW/8uKqj+yEBQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-VL3I4x68Ng2Qt8Wc_8jrpQ-1; Wed, 29 Mar 2023 20:24:45 -0400
X-MC-Unique: VL3I4x68Ng2Qt8Wc_8jrpQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26044185A792;
	Thu, 30 Mar 2023 00:24:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B469D202701E;
	Thu, 30 Mar 2023 00:24:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8598E1946588;
	Thu, 30 Mar 2023 00:24:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CA0491946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 30 Mar 2023 00:24:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8250E492B02; Thu, 30 Mar 2023 00:24:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A48F492B00
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 00:24:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60228385556C
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 00:24:42 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-vdueCCSNM36-eWHA6HPe7w-1; Wed, 29 Mar 2023 20:24:39 -0400
X-MC-Unique: vdueCCSNM36-eWHA6HPe7w-1
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; d="scan'208";a="225116479"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 08:24:38 +0800
IronPort-SDR: /AJWnt+3qjaxy1p1Y53fQi4zGCRt57/JhZ1KQsmzdQ0Flj9F7pwUgZak9TRSOqUOK4PL+HUxF6
 3Vm0xmlQLFRUin5zk5yhjS0M5ojblX2fBOPHhU5ad6jiUGZgXKnCbbE6RDRs1EsjwIS+UyeKEX
 H6U+jm7I+ZJUmbdg1UiYc+cJAMg4Cs0mCHYX4nJPZXVlJd4WG37G3tmz/I3QwDWrNLJ2k04i8r
 wPtaa2bzBplz+Ly5Ukemqk47De/gy4W4BnX+PjpBu7y0/2w1/AjJ8qm42rZ5KUwTkpmuTDmogY
 us4=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 16:40:46 -0700
IronPort-SDR: 2+5H3oJXZnSf24YLJquRohLb6mD3Mf+bBLw6oTdiuRI9lw5E1EGxAe/DZ3PTprSqzUBTV/Wj93
 1p60l8uR42BWYYex1uDBcgxjWnA6zjvFDAPEmdVEUB2kqbWV6Ssf1nw65YpZJ2zUvKG8x0XcMu
 KujOg4+KU0pR1JmHGEevbvUHknL76D8c2B0Vi9KEk/yDXUXyYXwhIzuh0uKGtrFRjOztpN7zYI
 UU7UrMAvgnG5NcorpNuzlk62eqGpErSyMKl2h3uAIWIkX4WuC4VYjwSPVYXAy2+nSpShy/38D9
 ruU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 17:24:38 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn41H3PXqz1RtVn
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 17:24:35 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id 0kfOfzG7JDau for <dm-devel@redhat.com>;
 Wed, 29 Mar 2023 17:24:34 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn41C5RmQz1RtVm;
 Wed, 29 Mar 2023 17:24:31 -0700 (PDT)
Message-ID: <b19696d3-54bb-d997-5e56-aa5fd58b469f@opensource.wdc.com>
Date: Thu, 30 Mar 2023 09:24:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Yang Shi <shy828301@gmail.com>
References: <cover.1680108414.git.johannes.thumshirn@wdc.com>
 <beea645603eccbb045ad9bb777e05a085b91808a.1680108414.git.johannes.thumshirn@wdc.com>
 <3a0f0c92-63cb-3624-c2fe-049a76d1a64a@opensource.wdc.com>
 <CAHbLzkoRdTTbnfz3RyLQAeNJBOEVNGL2WLgRSE2eQ4nR8sRe2g@mail.gmail.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CAHbLzkoRdTTbnfz3RyLQAeNJBOEVNGL2WLgRSE2eQ4nR8sRe2g@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: opensource.wdc.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMy8zMC8yMyAwOToxNywgWWFuZyBTaGkgd3JvdGU6Cj4gT24gV2VkLCBNYXIgMjksIDIwMjMg
YXQgNDo0OeKAr1BNIERhbWllbiBMZSBNb2FsCj4gPGRhbWllbi5sZW1vYWxAb3BlbnNvdXJjZS53
ZGMuY29tPiB3cm90ZToKPj4KPj4gT24gMy8zMC8yMyAwMjowNiwgSm9oYW5uZXMgVGh1bXNoaXJu
IHdyb3RlOgo+Pj4gQ2hlY2sgaWYgYWRkaW5nIHBhZ2VzIHRvIGNsb25lIGJpbyBmYWlscyBhbmQg
aWYgYmFpbCBvdXQuCj4+Cj4+IE5vcGUuIFRoZSBjb2RlIHJldHJpZXMgd2l0aCBkaXJlY3QgcmVj
bGFpbSB1bnRpbCBpdCBzdWNjZWVkcy4gV2hpY2ggaXMgdmVyeQo+PiBzdXNwaWNpb3VzLi4uCj4g
Cj4gSXQgaXMgbm90IHJlbGF0ZWQgdG8gYmlvX2FkZF9wYWdlKCkgZmFpbHVyZS4gSXQgaXMgdXNl
ZCB0byBhdm9pZCBhCj4gcmFjZSBjb25kaXRpb24gd2hlbiB0d28gcHJvY2Vzc2VzIGFyZSBkZXBs
ZXRpbmcgdGhlIG1lbXBvb2wKPiBzaW11bHRhbmVvdXNseS4KPiAKPiBJSVVDIEkgZG9uJ3QgdGhp
bmsgcGFnZSBtZXJnZSBtYXkgaGFwcGVuIGZvciBkbS1jcnlwdCwgc28gaXMKPiBfX2Jpb19hZGRf
cGFnZSgpIGdvb2QgZW5vdWdoPyBJJ20gd29ya2luZyBvbiB0aGlzIGNvZGUgdG9vLCB1c2luZwo+
IF9fYmlvX2FkZF9wYWdlKCkgd291bGQgbWFrZSBteSBwYXRjaCBlYXNpZXIuCgpJZiB0aGUgQklP
IHdhcyBhbGxvY2F0ZWQgd2l0aCBlbm91Z2ggYnZlY3MsIHdlIGNvdWxkIHVzZSB0aGF0IGZ1bmN0
aW9uLiBCdXQgcGFnZQptZXJnaW5nIHJlZHVjZXMgb3ZlcmhlYWQsIHNvIGlmIGl0IGNhbiBoYXBw
ZW4sIGxldCdzIHVzZSBpdC4KCj4gCj4+Cj4+Pgo+Pj4gVGhpcyB3YXkgd2UgY2FuIG1hcmsgYmlv
X2FkZF9wYWdlcyBhcyBfX211c3RfY2hlY2suCj4+Pgo+Pj4gU2lnbmVkLW9mZi1ieTogSm9oYW5u
ZXMgVGh1bXNoaXJuIDxqb2hhbm5lcy50aHVtc2hpcm5Ad2RjLmNvbT4KPj4KPj4gV2l0aCB0aGUg
Y29tbWl0IG1lc3NhZ2UgZml4ZWQsCj4+Cj4+IFJldmlld2VkLWJ5OiBEYW1pZW4gTGUgTW9hbCA8
ZGFtaWVuLmxlbW9hbEBvcGVuc291cmNlLndkYy5jb20+Cj4+Cj4+Cj4+IC0tCj4+IERhbWllbiBM
ZSBNb2FsCj4+IFdlc3Rlcm4gRGlnaXRhbCBSZXNlYXJjaAo+Pgo+PgoKLS0gCkRhbWllbiBMZSBN
b2FsCldlc3Rlcm4gRGlnaXRhbCBSZXNlYXJjaAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRt
LWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbAo=

