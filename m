Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01BECC74A5B
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 00:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680135492;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NhgD+NmyubkD1vLJjFd3tXUwTO8Z9VYpuHQqGnnT4GI=;
	b=Yl3T+Bv77x7kbDpXwHK4T39ur75ux1ZJ2MfkN8DBN6c2SAGt7vJkhtzj7242LbHRjHK5eU
	DC8+AqkvEh3Wtf40dq98h5azvYii0bLqvLV9b/P2iqJCWKjMwk0jOgoUl1SleYVP5RA8PG
	Pm0SrHO+KxyBV2mzwWviV6ifjJUKaio=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-LQZ6vWJ4OqquHpv_ymfLIw-1; Wed, 29 Mar 2023 20:18:09 -0400
X-MC-Unique: LQZ6vWJ4OqquHpv_ymfLIw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09A14101A550;
	Thu, 30 Mar 2023 00:18:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AE2C5492B00;
	Thu, 30 Mar 2023 00:18:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8F8841946588;
	Thu, 30 Mar 2023 00:18:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D07E21946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 30 Mar 2023 00:18:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BCAAE492B0B; Thu, 30 Mar 2023 00:18:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B50B4492B02
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 00:18:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8FF7800B23
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 00:18:05 +0000 (UTC)
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com
 [209.85.215.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-gI5Mgs1EOpmh3iB4ecsEfg-1; Wed, 29 Mar 2023 20:18:00 -0400
X-MC-Unique: gI5Mgs1EOpmh3iB4ecsEfg-1
Received: by mail-pg1-f170.google.com with SMTP id y19so10356754pgk.5;
 Wed, 29 Mar 2023 17:17:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1680135478;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=GFrxtn9d5G2riP70vvdw/yu25SnT/y5gfBPSK+n92IU=;
 b=LpKtAgQOX94WhCiGz+FmMEF7U1gU0jCibl4DWGljYdDCaBkxnXHC3fSYA+o/Ks3Ta8
 MVe2td7/8s7RPhkgDN+MemyN/NQ9iCwXbUUJ7kab4ue7PoqgokQL/yHOYnJ/DwpeRWQs
 3dV43p3Ns8o3EQhoyiKjUhFRLaVUQ3Eh3qs2Sm38XSa1AYzXcCxaxtIFKpyCku3jHPyg
 P5qd6yQrqLBdaFt1mjwxu+ZoAgw0nVQ3fjygb8zqlT3vLSEpXGPhMt5KvRCFBUIgxbvu
 21LQ+2D2g+mDUPJrkJzYrrhT2FY423lMsqoC4JvPd0GU2kFZ6HAW1u7JvP4tD+bA03pm
 SjlA==
X-Gm-Message-State: AAQBX9cVVe7zSB4p8f6NTo0qef23oOZxCmc182ghcZKdBVV+XkYsKu5C
 kW7f/ANrAsrAfMVWjfx80TlL5M5/xXuQFx2YIP8=
X-Google-Smtp-Source: AKy350aEVPs1e5xvudW7+v0SaWp4yk4rckHRftoj/jiGIVi7YJx59Ax0QojqF2IskeBIF4cBFMwK7DyHsh5zud9IPEs=
X-Received: by 2002:a05:6a00:2e9f:b0:628:1e57:afd7 with SMTP id
 fd31-20020a056a002e9f00b006281e57afd7mr10923270pfb.0.1680135478121; Wed, 29
 Mar 2023 17:17:58 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1680108414.git.johannes.thumshirn@wdc.com>
 <beea645603eccbb045ad9bb777e05a085b91808a.1680108414.git.johannes.thumshirn@wdc.com>
 <3a0f0c92-63cb-3624-c2fe-049a76d1a64a@opensource.wdc.com>
In-Reply-To: <3a0f0c92-63cb-3624-c2fe-049a76d1a64a@opensource.wdc.com>
From: Yang Shi <shy828301@gmail.com>
Date: Wed, 29 Mar 2023 17:17:46 -0700
Message-ID: <CAHbLzkoRdTTbnfz3RyLQAeNJBOEVNGL2WLgRSE2eQ4nR8sRe2g@mail.gmail.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBNYXIgMjksIDIwMjMgYXQgNDo0OeKAr1BNIERhbWllbiBMZSBNb2FsCjxkYW1pZW4u
bGVtb2FsQG9wZW5zb3VyY2Uud2RjLmNvbT4gd3JvdGU6Cj4KPiBPbiAzLzMwLzIzIDAyOjA2LCBK
b2hhbm5lcyBUaHVtc2hpcm4gd3JvdGU6Cj4gPiBDaGVjayBpZiBhZGRpbmcgcGFnZXMgdG8gY2xv
bmUgYmlvIGZhaWxzIGFuZCBpZiBiYWlsIG91dC4KPgo+IE5vcGUuIFRoZSBjb2RlIHJldHJpZXMg
d2l0aCBkaXJlY3QgcmVjbGFpbSB1bnRpbCBpdCBzdWNjZWVkcy4gV2hpY2ggaXMgdmVyeQo+IHN1
c3BpY2lvdXMuLi4KCkl0IGlzIG5vdCByZWxhdGVkIHRvIGJpb19hZGRfcGFnZSgpIGZhaWx1cmUu
IEl0IGlzIHVzZWQgdG8gYXZvaWQgYQpyYWNlIGNvbmRpdGlvbiB3aGVuIHR3byBwcm9jZXNzZXMg
YXJlIGRlcGxldGluZyB0aGUgbWVtcG9vbApzaW11bHRhbmVvdXNseS4KCklJVUMgSSBkb24ndCB0
aGluayBwYWdlIG1lcmdlIG1heSBoYXBwZW4gZm9yIGRtLWNyeXB0LCBzbyBpcwpfX2Jpb19hZGRf
cGFnZSgpIGdvb2QgZW5vdWdoPyBJJ20gd29ya2luZyBvbiB0aGlzIGNvZGUgdG9vLCB1c2luZwpf
X2Jpb19hZGRfcGFnZSgpIHdvdWxkIG1ha2UgbXkgcGF0Y2ggZWFzaWVyLgoKPgo+ID4KPiA+IFRo
aXMgd2F5IHdlIGNhbiBtYXJrIGJpb19hZGRfcGFnZXMgYXMgX19tdXN0X2NoZWNrLgo+ID4KPiA+
IFNpZ25lZC1vZmYtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdk
Yy5jb20+Cj4KPiBXaXRoIHRoZSBjb21taXQgbWVzc2FnZSBmaXhlZCwKPgo+IFJldmlld2VkLWJ5
OiBEYW1pZW4gTGUgTW9hbCA8ZGFtaWVuLmxlbW9hbEBvcGVuc291cmNlLndkYy5jb20+Cj4KPgo+
IC0tCj4gRGFtaWVuIExlIE1vYWwKPiBXZXN0ZXJuIERpZ2l0YWwgUmVzZWFyY2gKPgo+CgotLQpk
bS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4u
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

