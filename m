Return-Path: <SRS0=xkgx=EQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BA4C56201
	for <dm-devel@archiver.kernel.org>; Tue, 10 Nov 2020 07:55:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E81FB20897
	for <dm-devel@archiver.kernel.org>; Tue, 10 Nov 2020 07:55:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E81FB20897
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-bOHM8JkwN9aM89lbJYi8tA-1; Tue, 10 Nov 2020 02:55:15 -0500
X-MC-Unique: bOHM8JkwN9aM89lbJYi8tA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 023D756C33;
	Tue, 10 Nov 2020 07:55:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DA4D95B4D4;
	Tue, 10 Nov 2020 07:55:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7242244A43;
	Tue, 10 Nov 2020 07:55:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A9NT5nK004595 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 9 Nov 2020 18:29:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0BF9A110F75B; Mon,  9 Nov 2020 23:29:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 05CDB1004058
	for <dm-devel@redhat.com>; Mon,  9 Nov 2020 23:28:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9797801184
	for <dm-devel@redhat.com>; Mon,  9 Nov 2020 23:28:58 +0000 (UTC)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
	[209.85.128.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-263-SvoTo4CpPOW-EO--ihcWjQ-1; Mon, 09 Nov 2020 18:28:54 -0500
X-MC-Unique: SvoTo4CpPOW-EO--ihcWjQ-1
Received: by mail-wm1-f52.google.com with SMTP id t67so1193899wmt.5;
	Mon, 09 Nov 2020 15:28:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=uVd85Bl4q22td+3jSMit0FtxZJ1sJtChRiPRn7GLPMw=;
	b=o7r7nGx6jwmMvFFQ975DWd9RwCb9/9elWzCRVmcyOMlGcPNxZHFc/8YCi00bsdBh4P
	A+boaSKnIZ0K1+iXxFhNwoYB7N4qlVVqTUELP05LYh+pXdpfE6J76UoCog/E1MQ2K6Lc
	b7t5w4G/T1LgawgIAvy418foOBaHAx7nsqNB2r7+gZKmL/UHgS050MQ5hfDScL+v+nXe
	cNIiV3ndJnXclaYOE8mltqRfBp6iv2xKVWowzyHZu9pvCIl+iNsxukeNDD+GoHtAyz5U
	EIKlSiCN6K+iTWf4BRaNB0NyWEV5vdntZYHJ7SD7Bqmr5FM5cNYIvmjqVhJwoSb4ba/n
	q18Q==
X-Gm-Message-State: AOAM531AxbeBGHPYm0A0wx8hsf+jvunwtSdrJs7PAAhPmaT79YIn2YIQ
	L0jexqK1aXq4gEU7c0DujgI=
X-Google-Smtp-Source: ABdhPJyLfZWJAVtXVvWavay6Dkz/YKClz0bIC5QMERvUePaULd58OWlCLidmjNr2cN/ZVx4HfgINbw==
X-Received: by 2002:a7b:c2f7:: with SMTP id e23mr1575766wmk.100.1604964532362; 
	Mon, 09 Nov 2020 15:28:52 -0800 (PST)
Received: from ?IPv6:2601:647:4802:9070:f26a:270b:f54c:37eb?
	([2601:647:4802:9070:f26a:270b:f54c:37eb])
	by smtp.gmail.com with ESMTPSA id
	c17sm6900728wro.19.2020.11.09.15.28.46
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 09 Nov 2020 15:28:51 -0800 (PST)
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
References: <20201106190337.1973127-1-hch@lst.de>
	<20201106190337.1973127-4-hch@lst.de>
	<1d06cdfa-a904-30be-f3ec-08ae2fa85cbd@suse.de>
	<20201109085340.GB27483@lst.de>
	<e79f9a96-ef53-d6ea-f6e7-e141bdd2e2d2@suse.de>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <d28042e3-3123-5dfc-d0a2-aab0012150c8@grimberg.me>
Date: Mon, 9 Nov 2020 15:28:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e79f9a96-ef53-d6ea-f6e7-e141bdd2e2d2@suse.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 10 Nov 2020 02:55:04 -0500
Cc: Justin Sanders <justin@coraid.com>, Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
	Ilya Dryomov <idryomov@gmail.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
	linux-raid@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>, drbd-dev@tron.linbit.com,
	ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Minchan Kim <minchan@kernel.org>, linux-fsdevel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 03/24] nvme: let
 set_capacity_revalidate_and_notify update the bdev size
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Cj4gWyAuLiBdCj4+PiBPcmlnaW5hbGx5IG52bWUgbXVsdGlwYXRoIHdvdWxkIHVwZGF0ZS9jaGFu
Z2UgdGhlIHNpemUgb2YgdGhlIG11bHRpcGF0aAo+Pj4gZGV2aWNlIGFjY29yZGluZyB0byB0aGUg
dW5kZXJseWluZyBwYXRoIGRldmljZXMuCj4+PiBXaXRoIHRoaXMgcGF0Y2ggdGhlIHNpemUgb2Yg
dGhlIG11bHRpcGF0aCBkZXZpY2Ugd2lsbCBfbm90XyBjaGFuZ2UgaWYgCj4+PiB0aGVyZQo+Pj4g
aXMgYSBjaGFuZ2Ugb24gdGhlIHVuZGVybHlpbmcgZGV2aWNlcy4KPj4KPj4gWWVzLCBpdCB3aWxs
LsKgIFRha2UgYSBjbG9zZSBsb29rIGF0IG52bWVfdXBkYXRlX2Rpc2tfaW5mbyBhbmQgaG93IGl0
IGlzCj4+IGNhbGxlZC4KPj4KPiBPa2F5LCB0aGVuOiBXaGF0IHdvdWxkIGJlIHRoZSBjb3JyZWN0
IHdheSBvZiBoYW5kbGluZyBhIHNpemUgdXBkYXRlIGZvciAKPiBOVk1lIG11bHRpcGF0aD8KPiBB
c3N1bWluZyB3ZSdyZSBnZXR0aW5nIGFuIEFFTiBmb3IgZWFjaCBwYXRoIHNpZ25hbGxpbmcgdGhl
IHNpemUgY2hhbmdlCj4gKG9yIGEgY29udHJvbGxlciByZXNldCBsZWFkaW5nIHRvIGEgc2l6ZSBj
aGFuZ2UpLgo+IFNvIGlmIHdlJ3JlIHVwZGF0aW5nIHRoZSBzaXplIG9mIHRoZSBtdWx0aXBhdGgg
ZGV2aWNlIHRvZ2V0aGVyIHdpdGggdGhlIAo+IHBhdGggZGV2aWNlIGF0IHRoZSBmaXJzdCBBRU4v
cmVzZXQgd2UnbGwgZW5kIHVwIHdpdGggdGhlIG90aGVyIHBhdGhzIAo+IGhhdmluZyBhIGRpZmZl
cmVudCBzaXplIHRoYW4gdGhlIG11bHRpcGF0aCBkZXZpY2UgKGFuZCB0aGUgcGF0aCB3ZSd2ZSAK
PiBqdXN0IGJlZW4gdXBkYXRpbmcpLgo+IC0gRG8gd2UgY2FyZSwgb3IgY3Jvc3MgZmluZ2VycyBh
bmQgaG9wZSBmb3IgdGhlIGJlc3Q/Cj4gLSBTaG91bGRuJ3Qgd2UgZGV0ZWN0IHRoZSBjYXNlIHdo
ZXJlIHdlIHdvbid0IGdldCBhIHNpemUgdXBkYXRlIGZvciB0aGUgCj4gb3RoZXIgcGF0aHMsIG9y
LCBpbmRlZWQsIHdlIGhhdmUgYSBnZW51aW5lIGRldmljZSBzaXplIG1pc21hdGNoIGR1ZSB0byBh
IAo+IG1pc2NvbmZpZ3VyYXRpb24gb24gdGhlIHRhcmdldD8KPiAKPiBJRSBzaG91bGRuJ3Qgd2Ug
aGF2ZSBhIGZsYWcgJ3NpemUgdXBkYXRlIHBlbmRpbmcnIGZvciB0aGUgb3RoZXIgcGF0aHMsLCAK
PiB0byB0YWtlIHRoZW0gb3V0IG91ZiB1c2UgdGVtcG9yYXJpbHkgdW50aWwgdGhlIG90aGVyIEFF
TnMvcmVzZXRzIGhhdmUgCj4gYmVlbiBwcm9jZXNzZWQ/Cgp0aGUgbXBhdGggZGV2aWNlIHdpbGwg
dGFrZSB0aGUgbWluaW11bSBzaXplIGZyb20gYWxsIHRoZSBwYXRocywgdGhhdCBpcwp3aGF0IGJs
a19zdGFja19saW1pdHMgZG9lcy4gV2hlbiB0aGUgQUVOIGZvciBhbGwgdGhlIHBhdGhzIHdpbGwg
YXJyaXZlCnRoZSBtcGF0aCBzaXplIHdpbGwgdXBkYXRlLgoKTm90IHN1cmUgaG93IHRoaXMgaXMg
ZGlmZmVyZW50IHRoYW4gd2hhdCB3ZSBoYXZlIHRvZGF5Li4uCgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWw=

