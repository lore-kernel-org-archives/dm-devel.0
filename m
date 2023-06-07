Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67EDFC7EE37
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 06:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686206960;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JBzUv3Z1ZfNfhUzJyD8ReJmJAoIiezMb+uz3+O/QSW8=;
	b=eL2Lf04lkVTiqzbiuj9heeiEKnhHVxySi+2En+lc27vaZFggBtyFXfMvhWVTCS48XWrxXq
	+BOVKWqDdYOeugg/ER8ZiNXH3GwTP6kpBMbWj+KqA48Ufbmkt2zUbcRn0+G1EZBuP4wtGJ
	5WpY8t84yGGr2fxv/08y5++2Zs5Aqd0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-R_V1Kq_qMPq-p5Oi0cffIQ-1; Thu, 08 Jun 2023 02:49:17 -0400
X-MC-Unique: R_V1Kq_qMPq-p5Oi0cffIQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2486A805BC3;
	Thu,  8 Jun 2023 06:49:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1429940CFD48;
	Thu,  8 Jun 2023 06:49:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C7E911937754;
	Thu,  8 Jun 2023 06:48:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D694819465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 09:43:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9161D140E956; Wed,  7 Jun 2023 09:43:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A47E140E955
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 09:43:42 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F126101A531
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 09:43:42 +0000 (UTC)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com
 [209.85.208.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-jb5o5fsIMziXRmCGLdXJDw-1; Wed, 07 Jun 2023 05:43:40 -0400
X-MC-Unique: jb5o5fsIMziXRmCGLdXJDw-1
Received: by mail-ed1-f54.google.com with SMTP id
 4fb4d7f45d1cf-514953b3aa6so938693a12.1
 for <dm-devel@redhat.com>; Wed, 07 Jun 2023 02:43:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686131019; x=1688723019;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=h7De2dV56C4HlWldqRhiqrthNBSi3YmqE+PsGIwemH4=;
 b=BftIkOzB1Cf7gq74pddW0jJSU5rE8IIWbgaiYamoWyZSifOuCvV88H7Mp/zDVN64OB
 W4suPASdmX1ymW2ECSaAc9EBw2pb+BN8SLMLJlivniHPqkrWb2X4BW6FBZkpUktRWi/p
 HPr2bDyO8qGqDrvqjKiJ/0jF1yHoOLS8yWG99jZZK7L+2yNHwYqQUgJCxHuIspEAawUg
 Cf01H562TbUptrGfkodWMcv0jzGAfVwtC6DbCbCgjjqIFOTsefWWTNE37hv4UPxh/MHs
 kgVrBzk2r3fSUDf1kKZmSrYtkkiHFEIxi479im/ZsKI1WOdIil7JgejyIMBAOqIZSJxX
 aP9w==
X-Gm-Message-State: AC+VfDwvqtn9HRMBwFSMpG4iDiHaxjPQ0l3XfIaPuomHnnFlriGck40u
 fdWlFxpJxdHOZbzdQXHn9NzdJCFeFiUSoG2DiKkwGQ==
X-Google-Smtp-Source: ACHHUZ5Zsd3dLhUTQg2QCup0RdocqPkCkN0n7M2rugZo5XtKl4/VHXYLtkyrTBeTzA0h2H5Q3Eo78GSAj7z6EomEI0Y=
X-Received: by 2002:aa7:c6c8:0:b0:514:7f39:aa82 with SMTP id
 b8-20020aa7c6c8000000b005147f39aa82mr3567915eds.27.1686131019731; Wed, 07 Jun
 2023 02:43:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-25-hch@lst.de>
In-Reply-To: <20230606073950.225178-25-hch@lst.de>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Wed, 7 Jun 2023 11:43:28 +0200
Message-ID: <CAMGffEnM-XmQWjBu8EmXxFPouH9uQX45gL2PFW5vQJu5OaaYjA@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Thu, 08 Jun 2023 06:48:45 +0000
Subject: Re: [dm-devel] [PATCH 24/31] rnbd-srv: replace sess->open_flags
 with a "bool readonly"
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
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org,
 Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>,
 dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org,
 Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org,
 linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
 linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: ionos.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBKdW4gNiwgMjAyMyBhdCA5OjQx4oCvQU0gQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBs
c3QuZGU+IHdyb3RlOgo+Cj4gU3RvcCBwYXNzaW5nIHRoZSBmbW9kZV90IGFyb3VuZCBhbmQganVz
dCB1c2UgYSBzaW1wbGUgYm9vbCB0byB0cmFjayBpZgo+IGFuIGV4cG9ydCBpcyByZWFkLW9ubHku
Cj4KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KQWNrZWQt
Ynk6IEphY2sgV2FuZyA8amlucHUud2FuZ0Bpb25vcy5jb20+Cj4gLS0tCj4gIGRyaXZlcnMvYmxv
Y2svcm5iZC9ybmJkLXNydi1zeXNmcy5jIHwgIDMgKy0tCj4gIGRyaXZlcnMvYmxvY2svcm5iZC9y
bmJkLXNydi5jICAgICAgIHwgMTUgKysrKysrKy0tLS0tLS0tCj4gIGRyaXZlcnMvYmxvY2svcm5i
ZC9ybmJkLXNydi5oICAgICAgIHwgIDIgKy0KPiAgMyBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlv
bnMoKyksIDExIGRlbGV0aW9ucygtKQo+Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmxvY2svcm5i
ZC9ybmJkLXNydi1zeXNmcy5jIGIvZHJpdmVycy9ibG9jay9ybmJkL3JuYmQtc3J2LXN5c2ZzLmMK
PiBpbmRleCBkNWQ5MjY3ZTFmYTVlNC4uZWJkOTU3NzFjODVlYzcgMTAwNjQ0Cj4gLS0tIGEvZHJp
dmVycy9ibG9jay9ybmJkL3JuYmQtc3J2LXN5c2ZzLmMKPiArKysgYi9kcml2ZXJzL2Jsb2NrL3Ju
YmQvcm5iZC1zcnYtc3lzZnMuYwo+IEBAIC04OCw4ICs4OCw3IEBAIHN0YXRpYyBzc2l6ZV90IHJl
YWRfb25seV9zaG93KHN0cnVjdCBrb2JqZWN0ICprb2JqLCBzdHJ1Y3Qga29ial9hdHRyaWJ1dGUg
KmF0dHIsCj4KPiAgICAgICAgIHNlc3NfZGV2ID0gY29udGFpbmVyX29mKGtvYmosIHN0cnVjdCBy
bmJkX3Nydl9zZXNzX2Rldiwga29iaik7Cj4KPiAtICAgICAgIHJldHVybiBzeXNmc19lbWl0KHBh
Z2UsICIlZFxuIiwKPiAtICAgICAgICAgICAgICAgICAgICAgICAgICEoc2Vzc19kZXYtPm9wZW5f
ZmxhZ3MgJiBGTU9ERV9XUklURSkpOwo+ICsgICAgICAgcmV0dXJuIHN5c2ZzX2VtaXQocGFnZSwg
IiVkXG4iLCBzZXNzX2Rldi0+cmVhZG9ubHkpOwo+ICB9Cj4KPiAgc3RhdGljIHN0cnVjdCBrb2Jq
X2F0dHJpYnV0ZSBybmJkX3Nydl9kZXZfc2Vzc2lvbl9yb19hdHRyID0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9ibG9jay9ybmJkL3JuYmQtc3J2LmMgYi9kcml2ZXJzL2Jsb2NrL3JuYmQvcm5iZC1z
cnYuYwo+IGluZGV4IDI5ZDU2MDQ3MmQwNWJhLi5iNjgwMDcxMzQyYjg5OCAxMDA2NDQKPiAtLS0g
YS9kcml2ZXJzL2Jsb2NrL3JuYmQvcm5iZC1zcnYuYwo+ICsrKyBiL2RyaXZlcnMvYmxvY2svcm5i
ZC9ybmJkLXNydi5jCj4gQEAgLTIyMiw3ICsyMjIsNyBAQCB2b2lkIHJuYmRfZGVzdHJveV9zZXNz
X2RldihzdHJ1Y3Qgcm5iZF9zcnZfc2Vzc19kZXYgKnNlc3NfZGV2LCBib29sIGtlZXBfaWQpCj4g
ICAgICAgICBibGtkZXZfcHV0KHNlc3NfZGV2LT5iZGV2LCBOVUxMKTsKPiAgICAgICAgIG11dGV4
X2xvY2soJnNlc3NfZGV2LT5kZXYtPmxvY2spOwo+ICAgICAgICAgbGlzdF9kZWwoJnNlc3NfZGV2
LT5kZXZfbGlzdCk7Cj4gLSAgICAgICBpZiAoc2Vzc19kZXYtPm9wZW5fZmxhZ3MgJiBGTU9ERV9X
UklURSkKPiArICAgICAgIGlmICghc2Vzc19kZXYtPnJlYWRvbmx5KQo+ICAgICAgICAgICAgICAg
ICBzZXNzX2Rldi0+ZGV2LT5vcGVuX3dyaXRlX2NudC0tOwo+ICAgICAgICAgbXV0ZXhfdW5sb2Nr
KCZzZXNzX2Rldi0+ZGV2LT5sb2NrKTsKPgo+IEBAIC01NjEsNyArNTYxLDcgQEAgc3RhdGljIHZv
aWQgcm5iZF9zcnZfZmlsbF9tc2dfb3Blbl9yc3Aoc3RydWN0IHJuYmRfbXNnX29wZW5fcnNwICpy
c3AsCj4gIHN0YXRpYyBzdHJ1Y3Qgcm5iZF9zcnZfc2Vzc19kZXYgKgo+ICBybmJkX3Nydl9jcmVh
dGVfc2V0X3Nlc3NfZGV2KHN0cnVjdCBybmJkX3Nydl9zZXNzaW9uICpzcnZfc2VzcywKPiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zdCBzdHJ1Y3Qgcm5iZF9tc2dfb3BlbiAqb3Bl
bl9tc2csCj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGJsb2NrX2Rldmlj
ZSAqYmRldiwgZm1vZGVfdCBvcGVuX2ZsYWdzLAo+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIGJvb2wgcmVhZG9ubHksCj4gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHJuYmRfc3J2X2RldiAqc3J2X2RldikKPiAgewo+
ICAgICAgICAgc3RydWN0IHJuYmRfc3J2X3Nlc3NfZGV2ICpzZGV2ID0gcm5iZF9zZXNzX2Rldl9h
bGxvYyhzcnZfc2Vzcyk7Cj4gQEAgLTU3Niw3ICs1NzYsNyBAQCBybmJkX3Nydl9jcmVhdGVfc2V0
X3Nlc3NfZGV2KHN0cnVjdCBybmJkX3Nydl9zZXNzaW9uICpzcnZfc2VzcywKPiAgICAgICAgIHNk
ZXYtPmJkZXYgICAgICAgICAgICAgID0gYmRldjsKPiAgICAgICAgIHNkZXYtPnNlc3MgICAgICAg
ICAgICAgID0gc3J2X3Nlc3M7Cj4gICAgICAgICBzZGV2LT5kZXYgICAgICAgICAgICAgICA9IHNy
dl9kZXY7Cj4gLSAgICAgICBzZGV2LT5vcGVuX2ZsYWdzICAgICAgICA9IG9wZW5fZmxhZ3M7Cj4g
KyAgICAgICBzZGV2LT5yZWFkb25seSAgICAgICAgICA9IHJlYWRvbmx5Owo+ICAgICAgICAgc2Rl
di0+YWNjZXNzX21vZGUgICAgICAgPSBvcGVuX21zZy0+YWNjZXNzX21vZGU7Cj4KPiAgICAgICAg
IHJldHVybiBzZGV2Owo+IEBAIC02ODEsMTMgKzY4MSwxMiBAQCBzdGF0aWMgaW50IHByb2Nlc3Nf
bXNnX29wZW4oc3RydWN0IHJuYmRfc3J2X3Nlc3Npb24gKnNydl9zZXNzLAo+ICAgICAgICAgc3Ry
dWN0IHJuYmRfc3J2X3Nlc3NfZGV2ICpzcnZfc2Vzc19kZXY7Cj4gICAgICAgICBjb25zdCBzdHJ1
Y3Qgcm5iZF9tc2dfb3BlbiAqb3Blbl9tc2cgPSBtc2c7Cj4gICAgICAgICBzdHJ1Y3QgYmxvY2tf
ZGV2aWNlICpiZGV2Owo+IC0gICAgICAgZm1vZGVfdCBvcGVuX2ZsYWdzOwo+ICsgICAgICAgZm1v
ZGVfdCBvcGVuX2ZsYWdzID0gRk1PREVfUkVBRDsKPiAgICAgICAgIGNoYXIgKmZ1bGxfcGF0aDsK
PiAgICAgICAgIHN0cnVjdCBybmJkX21zZ19vcGVuX3JzcCAqcnNwID0gZGF0YTsKPgo+ICAgICAg
ICAgdHJhY2VfcHJvY2Vzc19tc2dfb3BlbihzcnZfc2Vzcywgb3Blbl9tc2cpOwo+Cj4gLSAgICAg
ICBvcGVuX2ZsYWdzID0gRk1PREVfUkVBRDsKPiAgICAgICAgIGlmIChvcGVuX21zZy0+YWNjZXNz
X21vZGUgIT0gUk5CRF9BQ0NFU1NfUk8pCj4gICAgICAgICAgICAgICAgIG9wZW5fZmxhZ3MgfD0g
Rk1PREVfV1JJVEU7Cj4KPiBAQCAtNzM2LDkgKzczNSw5IEBAIHN0YXRpYyBpbnQgcHJvY2Vzc19t
c2dfb3BlbihzdHJ1Y3Qgcm5iZF9zcnZfc2Vzc2lvbiAqc3J2X3Nlc3MsCj4gICAgICAgICAgICAg
ICAgIGdvdG8gYmxrZGV2X3B1dDsKPiAgICAgICAgIH0KPgo+IC0gICAgICAgc3J2X3Nlc3NfZGV2
ID0gcm5iZF9zcnZfY3JlYXRlX3NldF9zZXNzX2RldihzcnZfc2Vzcywgb3Blbl9tc2csCj4gLSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBiZGV2LCBv
cGVuX2ZsYWdzLAo+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgc3J2X2Rldik7Cj4gKyAgICAgICBzcnZfc2Vzc19kZXYgPSBybmJkX3Nydl9jcmVh
dGVfc2V0X3Nlc3NfZGV2KHNydl9zZXNzLCBvcGVuX21zZywgYmRldiwKPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIG9wZW5fbXNnLT5hY2Nlc3NfbW9kZSA9PSBSTkJEX0FDQ0VTU19S
TywKPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNydl9kZXYpOwo+ICAgICAgICAg
aWYgKElTX0VSUihzcnZfc2Vzc19kZXYpKSB7Cj4gICAgICAgICAgICAgICAgIHByX2VycigiT3Bl
bmluZyBkZXZpY2UgJyVzJyBvbiBzZXNzaW9uICVzIGZhaWxlZCwgY3JlYXRpbmcgc2Vzc19kZXYg
ZmFpbGVkLCBlcnI6ICVsZFxuIiwKPiAgICAgICAgICAgICAgICAgICAgICAgIGZ1bGxfcGF0aCwg
c3J2X3Nlc3MtPnNlc3NuYW1lLCBQVFJfRVJSKHNydl9zZXNzX2RldikpOwo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL2Jsb2NrL3JuYmQvcm5iZC1zcnYuaCBiL2RyaXZlcnMvYmxvY2svcm5iZC9ybmJk
LXNydi5oCj4gaW5kZXggZjU5NjJmZDMxZDYyZTQuLjc2MDc3YTlkYjNkZDU1IDEwMDY0NAo+IC0t
LSBhL2RyaXZlcnMvYmxvY2svcm5iZC9ybmJkLXNydi5oCj4gKysrIGIvZHJpdmVycy9ibG9jay9y
bmJkL3JuYmQtc3J2LmgKPiBAQCAtNTIsNyArNTIsNyBAQCBzdHJ1Y3Qgcm5iZF9zcnZfc2Vzc19k
ZXYgewo+ICAgICAgICAgc3RydWN0IGtvYmplY3QgICAgICAgICAgICAgICAgICBrb2JqOwo+ICAg
ICAgICAgdTMyICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkZXZpY2VfaWQ7Cj4gICAgICAg
ICBib29sICAgICAgICAgICAgICAgICAgICAgICAgICAgIGtlZXBfaWQ7Cj4gLSAgICAgICBmbW9k
ZV90ICAgICAgICAgICAgICAgICAgICAgICAgIG9wZW5fZmxhZ3M7Cj4gKyAgICAgICBib29sICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHJlYWRvbmx5Owo+ICAgICAgICAgc3RydWN0IGtyZWYg
ICAgICAgICAgICAgICAgICAgICBrcmVmOwo+ICAgICAgICAgc3RydWN0IGNvbXBsZXRpb24gICAg
ICAgICAgICAgICAqZGVzdHJveV9jb21wOwo+ICAgICAgICAgY2hhciAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBwYXRobmFtZVtOQU1FX01BWF07Cj4gLS0KPiAyLjM5LjIKPgoKLS0KZG0tZGV2
ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

