Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF87EC7EE24
	for <dm-devel@archiver.kernel.org>; Fri,  2 Jun 2023 15:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685721412;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=E+ConnukisM1YLoabmAn/sBA7nMO925kMU2Sk4ajP+8=;
	b=JpZ4E/eRWgk/soAYPiwIgYq0RUjg41K98W5VihL7XC1OtrEuU9XCA8jQfYSUA8dOhxlunp
	FLPQpi9au1GR3SVX96mVNfpovI/4rpIENXJ0TspQ6OKvysDbAAG9zmAKl8SbmQ5Gg9rDH8
	3xsVHLHmbBElL+ilnFkHYoJrD/cjkXE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-c6qZOghYNu-mFZytgByZmw-1; Fri, 02 Jun 2023 11:56:51 -0400
X-MC-Unique: c6qZOghYNu-mFZytgByZmw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BD61101A53A;
	Fri,  2 Jun 2023 15:56:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 47D37492B0A;
	Fri,  2 Jun 2023 15:56:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 00F0B1946595;
	Fri,  2 Jun 2023 15:56:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EB4CC194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Jun 2023 15:56:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B5DAE40CFD46; Fri,  2 Jun 2023 15:56:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE0E240CFD45
 for <dm-devel@redhat.com>; Fri,  2 Jun 2023 15:56:47 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92DED101A52C
 for <dm-devel@redhat.com>; Fri,  2 Jun 2023 15:56:47 +0000 (UTC)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com
 [209.85.218.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-316-sXijfGPnOvuyVQ0eh_8ZVQ-1; Fri, 02 Jun 2023 11:56:45 -0400
X-MC-Unique: sXijfGPnOvuyVQ0eh_8ZVQ-1
Received: by mail-ej1-f52.google.com with SMTP id
 a640c23a62f3a-96fbe7fbdd4so316485666b.3
 for <dm-devel@redhat.com>; Fri, 02 Jun 2023 08:56:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685721404; x=1688313404;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=zTIlBkKGXE2l4f5yMVZhwf3bgHS8bCAZRCZxQNYneag=;
 b=QoVE1c1SxWCiFkkQLcSLcSI2jszmefi/39A7dLhZ/K3F56qjfgz9fwZVUYdKBt9F8C
 ab8UDOYDUTlAvsyIBLHNe2eWzKRMDLLLiidmK0zjHrH0zPFKJioZejOrOfgxaxazNr/k
 riqhinqcSV8HZlPz/IbnJVpwS0f9WkIOphk+GXh7jST2bWgkkZFo3GqRvPsCTOysLrgx
 IgjlT4GtJwKMvOITAxzu/9yVUSHs1MVKBWXQ+kBt1aOshTkLK7yXy7xC2vNO/IJxPCqS
 HytlcSWn6sMCLucCWexbwqeXBUBcOyJ+mleKJNxYabbCgZnbaGNFf5fK+OX6aBZMrzRM
 sx/Q==
X-Gm-Message-State: AC+VfDxLzfGtfpIgsZEzp7ZE6Uojya9a9+vBttXTwTKRLQSI/LDAgotW
 aU2DzioiBaqHCjbqsvwxrEvyEgk0mHxIgpsUCTRazfjN
X-Google-Smtp-Source: ACHHUZ7ZDMrpNlfqv1knM8s3PHo1s/SJXzdOG/6Q1JuPTJ0zV3BCrXRBv72dvZAsOU6mhmCy+h79bQ==
X-Received: by 2002:a17:907:162c:b0:974:4f34:b04a with SMTP id
 hb44-20020a170907162c00b009744f34b04amr4066414ejc.34.1685721403813; 
 Fri, 02 Jun 2023 08:56:43 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com.
 [209.85.208.43]) by smtp.gmail.com with ESMTPSA id
 x3-20020a170906804300b0096f937b0d3esm912909ejw.3.2023.06.02.08.56.43
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 02 Jun 2023 08:56:43 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id
 4fb4d7f45d1cf-51494659d49so3184104a12.3
 for <dm-devel@redhat.com>; Fri, 02 Jun 2023 08:56:43 -0700 (PDT)
X-Received: by 2002:a05:6402:219:b0:516:4107:7847 with SMTP id
 t25-20020a056402021900b0051641077847mr949599edv.3.1685721402875; Fri, 02 Jun
 2023 08:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230601072829.1258286-1-hch@lst.de>
 <20230601072829.1258286-4-hch@lst.de>
 <CAHk-=wj3TrM-NWUcFUivefNwzbfGdfcgDGfGP12m6WBfH9JpWg@mail.gmail.com>
 <20230602154130.GA26710@lst.de>
In-Reply-To: <20230602154130.GA26710@lst.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Jun 2023 11:56:26 -0400
X-Gmail-Original-Message-ID: <CAHk-=wjggN+tR1j21UenO3jVTeSSoOKru==0zgkYYh=frdgCgQ@mail.gmail.com>
Message-ID: <CAHk-=wjggN+tR1j21UenO3jVTeSSoOKru==0zgkYYh=frdgCgQ@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 3/3] block: fail writes to read-only devices
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux-foundation.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBKdW4gMiwgMjAyMyBhdCAxMTo0MeKAr0FNIENocmlzdG9waCBIZWxsd2lnIDxoY2hA
bHN0LmRlPiB3cm90ZToKPgo+IEV4Y2VwdCB0aGUgd2hvbGUgbWFrZSBhIHRoaW5nIHJlYWRvbmx5
IGp1c3QgZm9yIGZ1biBpcyB0aGUgY29ybmVyIGNhc2UuCj4gRE0gZG9lcyBpdCwgYW5kIHdlIGhh
dmUgYSBzeXNmcyBmaWxlIHRvIGFsbG93IGl0LiAgQnV0IHRoZSB1c3VhbAo+IGNhc2UgaXMgdGhh
dCBhIGJsb2NrIGRldmljZSBoYXMgYmVlbiByZWFkLW9ubHkgYWxsIHRoZSB0aW1lLCBvciBoYXMK
PiBiZWVuIGZvcmNlIHRvIGJlIHJlYWQtb25seSBieSB0aGUgYWN0dWFsIHN0b3JhZ2UgZGV2aWNl
LCB3aGljaAo+IGRvZXNuJ3Qga25vdyBhbnl0aGluZyBhYm91dCB0aGUgZmlsZSBkZXNjcmlwdG9y
IG1vZGVsLCBhbmQgd2lsbAo+IG5vdCBiZSBoYXBweS4KClRoZSAiaXQncyBhbHdheXMgYmVlbiBy
ZWFkLW9ubHkiIGNhc2UgaXMgdW5hbWJpZ3VvdXMuCgpTbyBJIGRvIHdvbmRlciBpZiB3ZSBzaG91
bGQgaGF2ZSB0d28gcmVhZC1vbmx5IGJpdHM6IGEgImhhcmQiIGFuZAoic29mdCIgYml0LCBhbmQg
bWFrZSB0aGUgb3Blbi10aW1lIG9uZSB0aGUgaGFyZCBiaXQuCgpBbnl3YXksIEknbSBvayB0cnlp
bmcgdGhpcyBzaW1wbGUgdGhpbmcgb25jZSBtb3JlLCBidXQgaWYgd2UgZW5kIHVwCmdldHRpbmcg
cmVwb3J0cyBvZiBicmVha2FnZSBhZ2FpbiwgSSB0aGluayB5b3UgbWF5IGp1c3QgbmVlZCB0byBh
Y2NlcHQKdGhlIGZhY3QgdGhhdCAic29tZWJvZHkgdHVybmVkIHRoZSBkZXZpY2UgcmVhZC1vbmx5
IGFmdGVyIHRoZSBmYWN0IgptYXkganVzdCBiZSBzb21ldGhpbmcgdGhlIGtlcm5lbCB3aWxsIGhh
dmUgdG8gY29udGludWUgdG8gZGVhbCB3aXRoLgoKV2UgbWlnaHQgYmUgYWJsZSB0byBzcXVpcnJl
bGwgdGhlICJyZWFkLW9ubHkgYXQgdGltZSBvZiBvcGVuIiBiaXQgYXdheQppbiB0aGUgZmlsZSBk
ZXNjcmlwdG9yIGluIHRoZSBGTU9ERV9DQU5fV1JJVEUgYml0IG9yIHNvbWV0aGluZyBsaWtlCnRo
YXQgKGFsdGhvdWdoIHRoYXQgd291bGQgZ2l2ZXMgdGhlIHdyb25nIGVycm9yIGZvciB3cml0ZSgp
OiAtRUlOVkFMCmluc3RlYWQgb2YgLUVST0ZTIG9yIHdoYXRldmVyKQoKICAgICAgICAgICAgICAg
ICBMaW51cwoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0
cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

