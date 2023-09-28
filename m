Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B9BCE7B1F
	for <dm-devel@archiver.kernel.org>; Thu, 28 Sep 2023 19:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695930806;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=d52k4JXmWbJ+5s/i0wF28UQ7YQefvd7n5rdJwBDh2P8=;
	b=Q+UilMJaBIeomBWcMPu9SE2sKofB3P/liL95y8BHiB5vdibAD+LABjT7kLG8iA/5J9Q+wD
	gSHAT7nktw5AB0HoclmnyIrGA6hsZ3i6TdnZcYB2a6f7abp+6OFNfS/XYVAlSTnYhsVrvz
	BYD+fXBjBmM5QvNQeTR9dpzxQ6vfxg4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-SE1htHnaOc6swBROCZRF9g-1; Thu, 28 Sep 2023 15:53:24 -0400
X-MC-Unique: SE1htHnaOc6swBROCZRF9g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1208811E86;
	Thu, 28 Sep 2023 19:53:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 989B12026D68;
	Thu, 28 Sep 2023 19:53:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5F4BF1946588;
	Thu, 28 Sep 2023 19:53:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E7F8E1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Sep 2023 19:15:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D35D740C2070; Thu, 28 Sep 2023 19:15:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CC4C640C2064
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 19:15:40 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5DCF29AA385
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 19:15:40 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-448-6mJJbDpMPdu2eguHWGwvUQ-1; Thu,
 28 Sep 2023 15:15:38 -0400
X-MC-Unique: 6mJJbDpMPdu2eguHWGwvUQ-1
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
 by sin.source.kernel.org (Postfix) with ESMTP id B946ECE1FB9;
 Thu, 28 Sep 2023 19:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADBFC433C7;
 Thu, 28 Sep 2023 19:15:33 +0000 (UTC)
Received: by mail-lf1-f45.google.com with SMTP id
 2adb3069b0e04-5033918c09eso21151888e87.2; 
 Thu, 28 Sep 2023 12:15:33 -0700 (PDT)
X-Gm-Message-State: AOJu0YxsnD9IidjYBviCNDjYhHhVvdK5x7ZMZhwWorGyVuSb7C8obMAR
 AGIuQBRDQyDxApx2BcDAAv/Ob1zWnNV113NegBs=
X-Google-Smtp-Source: AGHT+IEO1NmBSmnMxdEBJpHkUAXkaiTeoWOqTDYI2wL3GtNpnOuZ8NDHwQUXWf51YZnh8VhWkg0jh50rQABdPgFYg7Y=
X-Received: by 2002:a05:6512:1388:b0:500:97e4:587e with SMTP id
 fc8-20020a056512138800b0050097e4587emr2412880lfb.44.1695928532085; Thu, 28
 Sep 2023 12:15:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
In-Reply-To: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 28 Sep 2023 12:15:19 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5cUgqy9fqj+Z4nGPQrAok-eQ=NipNxb0TL_kuCFaPMcw@mail.gmail.com>
Message-ID: <CAPhsuW5cUgqy9fqj+Z4nGPQrAok-eQ=NipNxb0TL_kuCFaPMcw@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH -next v3 00/25] md: synchronize io with array
 reconfiguration
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 xni@redhat.com, yukuai3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgS3VhaSwKClRoYW5rcyBmb3IgdGhlIHBhdGNoc2V0IQoKQSBmZXcgaGlnaCBsZXZlbCBxdWVz
dGlvbnMvc3VnZ2VzdGlvbnM6CgoxLiBUaGlzIGlzIGEgYmlnIGNoYW5nZSB0aGF0IG5lZWRzIGEg
bG90IG9mIGV4cGxhbmF0aW9uLiBXaGlsZSB5b3UgbWFuYWdlZCB0bwprZWVwIGVhY2ggcGF0Y2gg
cmVsYXRpdmVseSBzbWFsbCAoZ3JlYXQgam9iIGJ0dyksIGl0IGlzIG5vdCB2ZXJ5IGNsZWFyIHdo
eSB3ZQpuZWVkIHRoZXNlIGNoYW5nZXMuIFNwZWNpZmljYWxseSwgd2UgYXJlIGFkZGluZyBhIG5l
dyBtdXRleCwgaXQgaXMgd29ydGgKbWVudGlvbmluZyB3aHkgd2UgY2Fubm90IGFjaGlldmUgdGhl
IHNhbWUgZ29hbCB3aXRob3V0IGl0LiBQbGVhc2UgYWRkCm1vcmUgaW5mb3JtYXRpb24gaW4gdGhl
IGNvdmVyIGxldHRlci4gV2Ugd2lsbCBwdXQgcGFydCBvZiB0aGUgY292ZXIgbGV0dGVyIGluCnRo
ZSBtZXJnZSBjb21taXQuCgoyLiBJbiB0aGUgY292ZXIgbGV0dGVyLCBwbGVhc2UgYWxzbyBoaWdo
bGlnaHQgdGhhdCB3ZSBhcmUgcmVtb3ZpbmcKIE1EX0FMTE9XX1NCX1VQREFURSBhbmQgTURfVVBE
QVRJTkdfU0IuIFRoaXMgaXMgYSBiaWcgaW1wcm92ZW1lbnQuCgozLiBQbGVhc2UgcmVhcnJhbmdl
IHRoZSBwYXRjaCBzZXQgc28gdGhhdCB0aGUgdHdvICJSRUFEX09OQ0UvV1JJVEVfT05DRSIKcGF0
Y2hlcyBhcmUgYXQgdGhlIGJlZ2lubmluZy4KCjQuIFBsZWFzZSBjb25zaWRlciBtZXJnaW5nIHNv
bWUgcGF0Y2hlcy4gQ3VycmVudCAiYWRkLWFwaSA9PiB1c2UtYXBpID0+CnJlbW92ZS1vbGQtYXBp
IiBtYWtlcyBpdCB0cmlja3kgdG8gZm9sbG93IHdoYXQgaXMgYmVpbmcgY2hhbmdlZC4gRm9yIHRo
aXMgc2V0LApJIGZvdW5kIHRoZSBkaWZmIG9mIHRoZSB3aG9sZSBzZXQgZWFzaWVyIHRvIGZvbGxv
dyB0aGFuIHNvbWUgb2YgdGhlIGJpZyBwYXRjaGVzLgoKVGhhbmtzIGFnYWluIGZvciB5b3VyIGhh
cmQgd29yayBpbnRvIHRoaXMhClNvbmcKCk9uIFdlZCwgU2VwIDI3LCAyMDIzIGF0IDExOjIy4oCv
UE0gWXUgS3VhaSA8eXVrdWFpMUBodWF3ZWljbG91ZC5jb20+IHdyb3RlOgo+Cj4gRnJvbTogWXUg
S3VhaSA8eXVrdWFpM0BodWF3ZWkuY29tPgpbLi4uXQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0
CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbAo=

