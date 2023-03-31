Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4275AC77B6F
	for <dm-devel@archiver.kernel.org>; Mon,  3 Apr 2023 06:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680504270;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uBLiw3EULvLbbtiJ+kls04HEMPXFnjylRyX3eVdreEU=;
	b=eMXpAK0mZi6iodV5/ipQqStjAjcTX1fTqHbrb/dvqbpj4ue/FSpRW8wlHWVlPlWLJkeJ3k
	sUzRjz6yMbat8t1wfJaxLOjVtOj7TfYTCmoJUxfZmo1NLUmtS3C+yA37IogSvEQwM7R9dB
	I9Bo8rX4x1sBZGvZKYcqLruS+1Xr2e0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-rm62u9EBOvy3kAx0JnTy8w-1; Mon, 03 Apr 2023 02:44:26 -0400
X-MC-Unique: rm62u9EBOvy3kAx0JnTy8w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ADAFD2823800;
	Mon,  3 Apr 2023 06:44:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 08FF5140E94F;
	Mon,  3 Apr 2023 06:44:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BDDF71946A76;
	Mon,  3 Apr 2023 06:44:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 17A1319465BC
 for <dm-devel@listman.corp.redhat.com>; Fri, 31 Mar 2023 17:54:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C65CC2166B34; Fri, 31 Mar 2023 17:54:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BF6E02166B33
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 17:54:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A12C43C0F424
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 17:54:21 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-9WIrWJ4LNb6xVBWXxccjSg-1; Fri, 31 Mar 2023 13:54:19 -0400
X-MC-Unique: 9WIrWJ4LNb6xVBWXxccjSg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 5C2EE62AFF;
 Fri, 31 Mar 2023 17:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39958C433A4;
 Fri, 31 Mar 2023 17:54:17 +0000 (UTC)
Received: by mail-lf1-f41.google.com with SMTP id q16so29915972lfe.10;
 Fri, 31 Mar 2023 10:54:17 -0700 (PDT)
X-Gm-Message-State: AAQBX9feKGwqLMu5OwUCieZyfbTW2NC0CzoVCjagYbu1LLwClNULJ6zM
 tsbiQC/Rx0l9d08xmnpJRIaAenEMSeIGWad9yd4=
X-Google-Smtp-Source: AKy350YvKqb0dBoMYfGdDtedXvU05FWt6KdyndNuIJije8MdSUJrkHi6AamvXBmeJg5t6pczjm2RarPTQzd6MOIJepA=
X-Received: by 2002:ac2:5610:0:b0:4dd:a4e1:4861 with SMTP id
 v16-20020ac25610000000b004dda4e14861mr8234430lfd.3.1680285255256; Fri, 31 Mar
 2023 10:54:15 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1680172791.git.johannes.thumshirn@wdc.com>
 <07ae41b981f1b5f8de80a3f0a8ab2f34034077a6.1680172791.git.johannes.thumshirn@wdc.com>
In-Reply-To: <07ae41b981f1b5f8de80a3f0a8ab2f34034077a6.1680172791.git.johannes.thumshirn@wdc.com>
From: Song Liu <song@kernel.org>
Date: Fri, 31 Mar 2023 10:54:03 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4gxjRx-X6d46O7SsNb=nesrUKVv+s76C1DtkZdcGmyXw@mail.gmail.com>
Message-ID: <CAPhsuW4gxjRx-X6d46O7SsNb=nesrUKVv+s76C1DtkZdcGmyXw@mail.gmail.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Mon, 03 Apr 2023 06:44:20 +0000
Subject: Re: [dm-devel] [PATCH v2 15/19] md: check for failure when adding
 pages in alloc_behind_master_bio
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
 Damien Le Moal <damien.lemoal@wdc.com>, cluster-devel@redhat.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Dave Kleikamp <shaggy@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Mike Snitzer <snitzer@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org,
 Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBNYXIgMzAsIDIwMjMgYXQgMzo0NOKAr0FNIEpvaGFubmVzIFRodW1zaGlybgo8am9o
YW5uZXMudGh1bXNoaXJuQHdkYy5jb20+IHdyb3RlOgo+Cj4gYWxsb2NfYmVoaW5kX21hc3Rlcl9i
aW8oKSBjYW4gcG9zc2libHkgYWRkIG11bHRpcGxlIHBhZ2VzIHRvIGEgYmlvLCBidXQgaXQKPiBp
cyBub3QgY2hlY2tpbmcgZm9yIHRoZSByZXR1cm4gdmFsdWUgb2YgYmlvX2FkZF9wYWdlKCkgaWYg
YWRkaW5nIHJlYWxseQo+IHN1Y2NlZWRlZC4KPgo+IENoZWNrIGlmIHRoZSBwYWdlIGFkZGluZyBz
dWNjZWVkZWQgYW5kIGlmIG5vdCBiYWlsIG91dC4KPgo+IFNpZ25lZC1vZmYtYnk6IEpvaGFubmVz
IFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5jb20+Cj4gUmV2aWV3ZWQtYnk6IERh
bWllbiBMZSBNb2FsIDxkYW1pZW4ubGVtb2FsQG9wZW5zb3VyY2Uud2RjLmNvbT4KPiAtLS0KPiAg
ZHJpdmVycy9tZC9yYWlkMS5jIHwgMyArKy0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbigtKQo+Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvcmFpZDEuYyBi
L2RyaXZlcnMvbWQvcmFpZDEuYwo+IGluZGV4IDY4YTllMmQ5OTg1Yi4uYmQ3YzMzOWE4NGExIDEw
MDY0NAo+IC0tLSBhL2RyaXZlcnMvbWQvcmFpZDEuYwo+ICsrKyBiL2RyaXZlcnMvbWQvcmFpZDEu
Ywo+IEBAIC0xMTQ3LDcgKzExNDcsOCBAQCBzdGF0aWMgdm9pZCBhbGxvY19iZWhpbmRfbWFzdGVy
X2JpbyhzdHJ1Y3QgcjFiaW8gKnIxX2JpbywKPiAgICAgICAgICAgICAgICAgaWYgKHVubGlrZWx5
KCFwYWdlKSkKPiAgICAgICAgICAgICAgICAgICAgICAgICBnb3RvIGZyZWVfcGFnZXM7Cj4KPiAt
ICAgICAgICAgICAgICAgYmlvX2FkZF9wYWdlKGJlaGluZF9iaW8sIHBhZ2UsIGxlbiwgMCk7Cj4g
KyAgICAgICAgICAgICAgIGlmICghYmlvX2FkZF9wYWdlKGJlaGluZF9iaW8sIHBhZ2UsIGxlbiwg
MCkpCj4gKyAgICAgICAgICAgICAgICAgICAgICAgZ290byBmcmVlX3BhZ2VzOwoKV2Ugd2lsbCBs
ZWFrIHBhZ2UgaGVyZSwgbm8/CgpUaGFua3MsClNvbmcKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlz
dApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWwK

