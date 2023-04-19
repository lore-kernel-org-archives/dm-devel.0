Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2592EC77B7A
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 06:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681973848;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wmcSNT24FzkhH1Kn8nJgblxppY5+F65JsN8DQQeyyfI=;
	b=Vq6OO1Yv/CHdwln1QdbhnhIhOC0NncUchHxgPWzAbTjGjWZgqnNc/3zIxQ1wqxT2UKlUA+
	4cCWDKFSMQezCYtk+6L2VnQ7uYNe5B9WSJB/DoblThxWt0vrWelWXHtVhptwF6sdV+9tR5
	r4dnIFNym+AmtKcKc35jHNwU37SxUow=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-jwlS7gboNVWAcuN5dcsJtA-1; Thu, 20 Apr 2023 02:57:24 -0400
X-MC-Unique: jwlS7gboNVWAcuN5dcsJtA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C378E823D4F;
	Thu, 20 Apr 2023 06:57:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B07211410F1F;
	Thu, 20 Apr 2023 06:57:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6DCFF1946A4B;
	Thu, 20 Apr 2023 06:57:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7758519465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Apr 2023 15:19:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 59404492C3F; Wed, 19 Apr 2023 15:19:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 51AF8492B04
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 15:19:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36371811E7C
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 15:19:49 +0000 (UTC)
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-ahAoZheWNvSCgSIVILSdng-1; Wed, 19 Apr 2023 11:19:45 -0400
X-MC-Unique: ahAoZheWNvSCgSIVILSdng-1
Received: by mail-pj1-f69.google.com with SMTP id
 98e67ed59e1d1-2476a718feeso2035705a91.2
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 08:19:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681917584; x=1684509584;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Tk4ILYUitykXDNv2nAhy0f5ydU+4a31pQqGhvmwhdPk=;
 b=fT5M9jMfTLNN5CYNaWXE7eCukWWp4tbCJvko/A1Sp4zuB29ZyuvSO4BGj6KQJkmVMc
 t72hzTbOZ2o7nFj3i7Wybmo4Hq/dlGKM3NSdUnEwjucVR0cdf32cKkihVDKSqqtBHc7C
 KJwX7239V+wW00QNSGE0y++L+lIEBKw2e8oKFv/7RByhmJVp0IES5qpAendICUjGln7i
 DoD4kSmieW35s9m9/Ovpwewwi7OCcOgxKoOZqIgiJi3P74fVu+Kf1ysQT+pSBmoeMXZq
 MaVBolrnIs7J18R5BEY/d6fzFylbvkrDuFzcKjmgNgrZUqm6Lu8K1Y6hlAGNi5YtyC+q
 zVlA==
X-Gm-Message-State: AAQBX9eWUpnwJNiee/514ijJEtEBdmPHXziNYU8qOg23I6aztGyuEGeu
 E9ssGae0zAsCJK7gVuj3n3EQQsYHdk/K1BlXcG9hYVbPd39yvoUf8/Ep6IoWGPKTOFHh69o0SGb
 sHnLH+TeNiAlkkFnGrKGlpsZHAxUGQ6I=
X-Received: by 2002:a17:90a:2ca4:b0:247:fec:3cf with SMTP id
 n33-20020a17090a2ca400b002470fec03cfmr1032471pjd.9.1681917584664; 
 Wed, 19 Apr 2023 08:19:44 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZilzTP35l+fCVfSRmyAr7TA2z2HByJ2c77EoLXxjUVlBIE5WaJ/vbFqG27YJf1gGuB7p5La9B7yskBhiQ6yjg=
X-Received: by 2002:a17:90a:2ca4:b0:247:fec:3cf with SMTP id
 n33-20020a17090a2ca400b002470fec03cfmr1032449pjd.9.1681917584368; Wed, 19 Apr
 2023 08:19:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230419140929.5924-1-jth@kernel.org>
 <20230419140929.5924-12-jth@kernel.org>
In-Reply-To: <20230419140929.5924-12-jth@kernel.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 19 Apr 2023 17:19:31 +0200
Message-ID: <CAHc6FU6U1yZguZGeCc7BUqd1Qm4+SSRK8xbNZWBUSXTk_jjvVQ@mail.gmail.com>
To: Johannes Thumshirn <jth@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Thu, 20 Apr 2023 06:57:04 +0000
Subject: Re: [dm-devel] [PATCH v3 11/19] gfs: use __bio_add_page for adding
 single page to bio
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
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, linux-mm@kvack.org,
 dm-devel@redhat.com, hch@lst.de,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, willy@infradead.org,
 cluster-devel@redhat.com, kch@nvidia.com, snitzer@kernel.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, rpeterso@redhat.com,
 dsterba@suse.com, axboe@kernel.dk, linux-raid@vger.kernel.org,
 damien.lemoal@wdc.com, song@kernel.org, johannes.thumshirn@wdc.com,
 linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBBcHIgMTksIDIwMjMgYXQgNDoxMOKAr1BNIEpvaGFubmVzIFRodW1zaGlybiA8anRo
QGtlcm5lbC5vcmc+IHdyb3RlOgo+Cj4gRnJvbTogSm9oYW5uZXMgVGh1bXNoaXJuIDxqb2hhbm5l
cy50aHVtc2hpcm5Ad2RjLmNvbT4KPgo+IFRoZSBHRlMgc3VwZXJibG9jayByZWFkaW5nIGNvZGUg
dXNlcyBiaW9fYWRkX3BhZ2UoKSB0byBhZGQgYSBwYWdlIHRvIGEKPiBuZXdseSBjcmVhdGVkIGJp
by4gYmlvX2FkZF9wYWdlKCkgY2FuIGZhaWwsIGJ1dCB0aGUgcmV0dXJuIHZhbHVlIGlzIG5ldmVy
Cj4gY2hlY2tlZC4KCkl0J3MgR0ZTMiwgbm90IEdGUywgYnV0IG90aGVyd2lzZSB0aGlzIGlzIG9i
dmlvdXNseSBmaW5lLCB0aGFua3MuCgo+IFVzZSBfX2Jpb19hZGRfcGFnZSgpIGFzIGFkZGluZyBh
IHNpbmdsZSBwYWdlIHRvIGEgbmV3bHkgY3JlYXRlZCBiaW8gaXMKPiBndWFyYW50ZWVkIHRvIHN1
Y2NlZWQuCj4KPiBUaGlzIGJyaW5ncyB1cyBhIHN0ZXAgY2xvc2VyIHRvIG1hcmtpbmcgYmlvX2Fk
ZF9wYWdlKCkgYXMgX19tdXN0X2NoZWNrLgo+Cj4gU2lnbmVkLW9mZi1ieTogSm9oYW5uZXMgVGh1
bXNoaXJuIDxqb2hhbm5lcy50aHVtc2hpcm5Ad2RjLmNvbT4KPiBSZXZpZXdlZC1ieTogRGFtaWVu
IExlIE1vYWwgPGRhbWllbi5sZW1vYWxAb3BlbnNvdXJjZS53ZGMuY29tPgoKUmV2aWV3ZWQtYnk6
IEFuZHJlYXMgR3J1ZW5iYWNoZXIgPGFncnVlbmJhQHJlZGhhdC5jb20+Cgo+IC0tLQo+ICBmcy9n
ZnMyL29wc19mc3R5cGUuYyB8IDIgKy0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCAxIGRlbGV0aW9uKC0pCj4KPiBkaWZmIC0tZ2l0IGEvZnMvZ2ZzMi9vcHNfZnN0eXBlLmMgYi9m
cy9nZnMyL29wc19mc3R5cGUuYwo+IGluZGV4IDZkZTkwMWMzYjg5Yi4uZTBjZDBkNDNiMTJmIDEw
MDY0NAo+IC0tLSBhL2ZzL2dmczIvb3BzX2ZzdHlwZS5jCj4gKysrIGIvZnMvZ2ZzMi9vcHNfZnN0
eXBlLmMKPiBAQCAtMjU0LDcgKzI1NCw3IEBAIHN0YXRpYyBpbnQgZ2ZzMl9yZWFkX3N1cGVyKHN0
cnVjdCBnZnMyX3NiZCAqc2RwLCBzZWN0b3JfdCBzZWN0b3IsIGludCBzaWxlbnQpCj4KPiAgICAg
ICAgIGJpbyA9IGJpb19hbGxvYyhzYi0+c19iZGV2LCAxLCBSRVFfT1BfUkVBRCB8IFJFUV9NRVRB
LCBHRlBfTk9GUyk7Cj4gICAgICAgICBiaW8tPmJpX2l0ZXIuYmlfc2VjdG9yID0gc2VjdG9yICog
KHNiLT5zX2Jsb2Nrc2l6ZSA+PiA5KTsKPiAtICAgICAgIGJpb19hZGRfcGFnZShiaW8sIHBhZ2Us
IFBBR0VfU0laRSwgMCk7Cj4gKyAgICAgICBfX2Jpb19hZGRfcGFnZShiaW8sIHBhZ2UsIFBBR0Vf
U0laRSwgMCk7Cj4KPiAgICAgICAgIGJpby0+YmlfZW5kX2lvID0gZW5kX2Jpb19pb19wYWdlOwo+
ICAgICAgICAgYmlvLT5iaV9wcml2YXRlID0gcGFnZTsKPiAtLQo+IDIuMzkuMgo+CgotLQpkbS1k
ZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

