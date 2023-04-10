Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DB9FC7619A
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 06:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681195465;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QpnlAM0HZ5YiHrIxIzQbroJPaEW/WImtqR/br+BDfrI=;
	b=aglaIYKV2qIPptLEZ0HGQTN7pLKSTnqCsBCmL8kejWMHzAoxZ7V57iNEPfKPzYg81kGD58
	Rr1dCni7aprsrrIDTBrN8h3wqGMpza98Q2GgtPturDQYceMlr2ySJJWsSw4u/XAU40AjHk
	L7cvf4uMnVvIV34ncE+Uxa7urf9t0bE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-wi3akiCPMoWIlseO6vjiaQ-1; Tue, 11 Apr 2023 02:44:23 -0400
X-MC-Unique: wi3akiCPMoWIlseO6vjiaQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD780855313;
	Tue, 11 Apr 2023 06:44:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CBEB8C15BB8;
	Tue, 11 Apr 2023 06:44:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E2D3319452CB;
	Tue, 11 Apr 2023 06:44:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 04CFF1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 10 Apr 2023 16:06:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E831D18EC7; Mon, 10 Apr 2023 16:06:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E0A3E440BC
 for <dm-devel@redhat.com>; Mon, 10 Apr 2023 16:06:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE1848828C0
 for <dm-devel@redhat.com>; Mon, 10 Apr 2023 16:06:26 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-0GG6u9xaOgCKYfEGsqfGAw-1; Mon, 10 Apr 2023 12:06:23 -0400
X-MC-Unique: 0GG6u9xaOgCKYfEGsqfGAw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id CE73F61D67;
 Mon, 10 Apr 2023 16:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9468C433AA;
 Mon, 10 Apr 2023 16:06:20 +0000 (UTC)
Received: by mail-lj1-f179.google.com with SMTP id e20so5475192lji.6;
 Mon, 10 Apr 2023 09:06:20 -0700 (PDT)
X-Gm-Message-State: AAQBX9fQCSFFRjakTUYCOPobHgWOVEpm9fdGrKuJEupzCYXRV/LW+Nhk
 EgBAGlJWFH2wTsmt1TwguW9SlfMn3PRIbsl9PAU=
X-Google-Smtp-Source: AKy350ZYTf5+tNtIInJ56xYELpkw807n6pcDQqxLzwYNn5kC/wsk/lyy0ZRj6GpVdiG1eSqStA2SCDFU3pUWbh96/vU=
X-Received: by 2002:a2e:b0e2:0:b0:2a5:fe8f:b314 with SMTP id
 h2-20020a2eb0e2000000b002a5fe8fb314mr2152243ljl.5.1681142778696; Mon, 10 Apr
 2023 09:06:18 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1680172791.git.johannes.thumshirn@wdc.com>
 <8b8a3bb2db8c5183ef36c1810f2ac776ac526327.1680172791.git.johannes.thumshirn@wdc.com>
 <CAPhsuW7a+mpn+VprfA2mC5Fc+M9BFq8i6d-y+-o5G1u5dOsk2Q@mail.gmail.com>
 <bbc98aa3-24f0-8ee6-9d74-483564a14f0f@kernel.org>
In-Reply-To: <bbc98aa3-24f0-8ee6-9d74-483564a14f0f@kernel.org>
From: Song Liu <song@kernel.org>
Date: Mon, 10 Apr 2023 09:06:06 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4yQjNgHZpw4UzkhC+GkY+aAFSjC-PDQFFoL-Wg-u2r1Q@mail.gmail.com>
Message-ID: <CAPhsuW4yQjNgHZpw4UzkhC+GkY+aAFSjC-PDQFFoL-Wg-u2r1Q@mail.gmail.com>
To: Johannes Thumshirn <jth@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Tue, 11 Apr 2023 06:44:09 +0000
Subject: Re: [dm-devel] [PATCH v2 17/19] md: raid1: check if adding pages to
 resync bio fails
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 linux-mm@kvack.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
 Andreas Gruenbacher <agruenba@redhat.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Matthew Wilcox <willy@infradead.org>, cluster-devel@redhat.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Mike Snitzer <snitzer@kernel.org>,
 Ming Lei <ming.lei@redhat.com>, linux-raid@vger.kernel.org,
 Bob Peterson <rpeterso@redhat.com>, David Sterba <dsterba@suse.com>,
 Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Damien Le Moal <damien.lemoal@wdc.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBBcHIgNCwgMjAyMyBhdCAxOjI24oCvQU0gSm9oYW5uZXMgVGh1bXNoaXJuIDxqdGhA
a2VybmVsLm9yZz4gd3JvdGU6Cj4KPiBPbiAzMS8wMy8yMDIzIDIwOjEzLCBTb25nIExpdSB3cm90
ZToKPiA+IE9uIFRodSwgTWFyIDMwLCAyMDIzIGF0IDM6NDTigK9BTSBKb2hhbm5lcyBUaHVtc2hp
cm4KPiA+IDxqb2hhbm5lcy50aHVtc2hpcm5Ad2RjLmNvbT4gd3JvdGU6Cj4gPj4KPiA+PiBDaGVj
ayBpZiBhZGRpbmcgcGFnZXMgdG8gcmVzeW5jIGJpbyBmYWlscyBhbmQgaWYgYmFpbCBvdXQuCj4g
Pj4KPiA+PiBBcyB0aGUgY29tbWVudCBhYm92ZSBzdWdnZXN0cyB0aGlzIGNhbm5vdCBoYXBwZW4s
IFdBUk4gaWYgaXQgYWN0dWFsbHkKPiA+PiBoYXBwZW5zLgo+ID4+Cj4gPj4gVGhpcyB3YXkgd2Ug
Y2FuIG1hcmsgYmlvX2FkZF9wYWdlcyBhcyBfX211c3RfY2hlY2suCj4gPj4KPiA+PiBTaWduZWQt
b2ZmLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRodW1zaGlybkB3ZGMuY29tPgo+
ID4+IFJldmlld2VkLWJ5OiBEYW1pZW4gTGUgTW9hbCA8ZGFtaWVuLmxlbW9hbEBvcGVuc291cmNl
LndkYy5jb20+Cj4gPj4gLS0tCj4gPj4gICBkcml2ZXJzL21kL3JhaWQxLTEwLmMgfCAgNyArKysr
KystCj4gPj4gICBkcml2ZXJzL21kL3JhaWQxMC5jICAgfCAxMiArKysrKysrKysrLS0KPiA+PiAg
IDIgZmlsZXMgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKPiA+Pgo+
ID4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL3JhaWQxLTEwLmMgYi9kcml2ZXJzL21kL3JhaWQx
LTEwLmMKPiA+PiBpbmRleCBlNjFmNmNhZDRlMDguLmMyMWI2YzE2ODc1MSAxMDA2NDQKPiA+PiAt
LS0gYS9kcml2ZXJzL21kL3JhaWQxLTEwLmMKPiA+PiArKysgYi9kcml2ZXJzL21kL3JhaWQxLTEw
LmMKPiA+PiBAQCAtMTA1LDcgKzEwNSwxMiBAQCBzdGF0aWMgdm9pZCBtZF9iaW9fcmVzZXRfcmVz
eW5jX3BhZ2VzKHN0cnVjdCBiaW8gKmJpbywgc3RydWN0IHJlc3luY19wYWdlcyAqcnAsCj4gPj4g
ICAgICAgICAgICAgICAgICAgKiB3b24ndCBmYWlsIGJlY2F1c2UgdGhlIHZlYyB0YWJsZSBpcyBi
aWcKPiA+PiAgICAgICAgICAgICAgICAgICAqIGVub3VnaCB0byBob2xkIGFsbCB0aGVzZSBwYWdl
cwo+ID4+ICAgICAgICAgICAgICAgICAgICovCj4gPgo+ID4gV2Uga25vdyB0aGVzZSB3b24ndCBm
YWlsLiBTaGFsbCB3ZSBqdXN0IHVzZSBfX2Jpb19hZGRfcGFnZT8KPgo+IFdlIGNvdWxkIHllcywg
YnV0IEkga2luZCBvZiBsaWtlIHRoZSBhc3NlcnQoKSBzdHlsZSB3YXJuaW5nLgo+IEJ1dCBvZiBj
YXVzZSB1bHRpbWF0ZWx5IHlvdXIgY2FsbC4KClRoZSBhc3NlcnQoKSBzdHlsZSB3YXJuaW5nIGlz
IGZpbmUuIEluIHRoaXMgY2FzZSwgcGxlYXNlIHJlbW92ZSB0aGUKIndvbid0IGZhaWwgLi4uIiBj
b21tZW50cy4KClRoYW5rcywKU29uZwoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVs
QHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbAo=

