Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 333F7C7EE22
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 00:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683592087;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7lIoJ05+bFxjUAiSEEOItcWIS3o8deArGjyq4PdPsZ8=;
	b=DGk14tjCPABdEYgyPYcN49oSmFnLKw8peX3hUEoOdvTgGCpP4CIrlZN6uc7TdGpZBaRF45
	zrv1CRdrhewjFGAYmbwterDa9e2nJ3AV3FoRgiqpLN9Oyv2CvAp1p0fLbqiDFi0q6EYTNq
	OCmVqLXQQFSCuCFy6NAB/zBRvgbuOeM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-GYk3bit3Op2GyEH_2kiVkQ-1; Mon, 08 May 2023 20:28:04 -0400
X-MC-Unique: GYk3bit3Op2GyEH_2kiVkQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82D058026E8;
	Tue,  9 May 2023 00:28:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2F41D40C206F;
	Tue,  9 May 2023 00:28:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E8D8019452C5;
	Tue,  9 May 2023 00:28:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ED5D119452C4
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 May 2023 00:28:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 62B5840C6F42; Tue,  9 May 2023 00:28:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5ACD440C6F41
 for <dm-devel@redhat.com>; Tue,  9 May 2023 00:28:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CE9A381D4C4
 for <dm-devel@redhat.com>; Tue,  9 May 2023 00:28:00 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-1wmEhyaoNp6cecyyJBeRRQ-1; Mon, 08 May 2023 20:27:58 -0400
X-MC-Unique: 1wmEhyaoNp6cecyyJBeRRQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 058A762F2B
 for <dm-devel@redhat.com>; Tue,  9 May 2023 00:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6930AC433D2
 for <dm-devel@redhat.com>; Tue,  9 May 2023 00:20:19 +0000 (UTC)
Received: by mail-lj1-f176.google.com with SMTP id
 38308e7fff4ca-2ac82b07eb3so51229371fa.1
 for <dm-devel@redhat.com>; Mon, 08 May 2023 17:20:19 -0700 (PDT)
X-Gm-Message-State: AC+VfDz8ekcGATHoKVcaS3DSRw59VRcIr266ZpVSvtJBHtCUq6Wbpjhb
 Mj3oYk8jzynnyftJCl9+8Ci+VpfSSP+Uifh/+KFo2VU=
X-Google-Smtp-Source: ACHHUZ6XguvB359TJD5EVeTjXaiA2ucEsERS2+WbXhgo3pznKhng9msxWTb8gnB50Rzaq/efZNnWYP+FsScnG1YYBIM=
X-Received: by 2002:a17:907:9808:b0:94f:4801:6d08 with SMTP id
 ji8-20020a170907980800b0094f48016d08mr10822326ejc.71.1683591597081; Mon, 08
 May 2023 17:19:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230503183821.1473305-1-john.g.garry@oracle.com>
 <20230503183821.1473305-2-john.g.garry@oracle.com>
In-Reply-To: <20230503183821.1473305-2-john.g.garry@oracle.com>
From: Mike Snitzer <snitzer@kernel.org>
Date: Mon, 8 May 2023 20:19:46 -0400
X-Gmail-Original-Message-ID: <CAH6w=ay1NNxh=9mQv5PCcDi3OY0mgvRXO_0VrmKBLAd1dcUQqQ@mail.gmail.com>
Message-ID: <CAH6w=ay1NNxh=9mQv5PCcDi3OY0mgvRXO_0VrmKBLAd1dcUQqQ@mail.gmail.com>
To: John Garry <john.g.garry@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH RFC 01/16] block: Add atomic write operations
 to request_queue limits
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
Cc: djwong@kernel.org, Himanshu Madhani <himanshu.madhani@oracle.com>,
 linux-nvme@lists.infradead.org, dm-devel@redhat.com, hch@lst.de,
 sagi@grimberg.me, linux-scsi@vger.kernel.org, jmorris@namei.org,
 serge@hallyn.com, jejb@linux.ibm.com, linux-block@vger.kernel.org,
 viro@zeniv.linux.org.uk, dchinner@redhat.com, kbusch@kernel.org,
 paul@paul-moore.com, axboe@kernel.dk, brauner@kernel.org,
 martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBNYXkgMywgMjAyMyBhdCAyOjQw4oCvUE0gSm9obiBHYXJyeSA8am9obi5nLmdhcnJ5
QG9yYWNsZS5jb20+IHdyb3RlOgo+Cj4gRnJvbTogSGltYW5zaHUgTWFkaGFuaSA8aGltYW5zaHUu
bWFkaGFuaUBvcmFjbGUuY29tPgo+Cj4gQWRkIHRoZSBmb2xsb3dpbmcgbGltaXRzOgo+IC0gYXRv
bWljX3dyaXRlX2JvdW5kYXJ5Cj4gLSBhdG9taWNfd3JpdGVfbWF4X2J5dGVzCj4gLSBhdG9taWNf
d3JpdGVfdW5pdF9tYXgKPiAtIGF0b21pY193cml0ZV91bml0X21pbgo+Cj4gU2lnbmVkLW9mZi1i
eTogSGltYW5zaHUgTWFkaGFuaSA8aGltYW5zaHUubWFkaGFuaUBvcmFjbGUuY29tPgo+IFNpZ25l
ZC1vZmYtYnk6IEpvaG4gR2FycnkgPGpvaG4uZy5nYXJyeUBvcmFjbGUuY29tPgo+IC0tLQo+ICBE
b2N1bWVudGF0aW9uL0FCSS9zdGFibGUvc3lzZnMtYmxvY2sgfCA0MiArKysrKysrKysrKysrKysr
KysrKysKPiAgYmxvY2svYmxrLXNldHRpbmdzLmMgICAgICAgICAgICAgICAgIHwgNTYgKysrKysr
KysrKysrKysrKysrKysrKysrKysrKwo+ICBibG9jay9ibGstc3lzZnMuYyAgICAgICAgICAgICAg
ICAgICAgfCAzMyArKysrKysrKysrKysrKysrCj4gIGluY2x1ZGUvbGludXgvYmxrZGV2LmggICAg
ICAgICAgICAgICB8IDIzICsrKysrKysrKysrKwo+ICA0IGZpbGVzIGNoYW5nZWQsIDE1NCBpbnNl
cnRpb25zKCspCj4KCi4uLgoKPiBkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLXNldHRpbmdzLmMgYi9i
bG9jay9ibGstc2V0dGluZ3MuYwo+IGluZGV4IDg5NmI0NjU0YWIwMC4uZTIxNzMxNzE1YTEyIDEw
MDY0NAo+IC0tLSBhL2Jsb2NrL2Jsay1zZXR0aW5ncy5jCj4gKysrIGIvYmxvY2svYmxrLXNldHRp
bmdzLmMKPiBAQCAtNTksNiArNTksOSBAQCB2b2lkIGJsa19zZXRfZGVmYXVsdF9saW1pdHMoc3Ry
dWN0IHF1ZXVlX2xpbWl0cyAqbGltKQo+ICAgICAgICAgbGltLT56b25lZCA9IEJMS19aT05FRF9O
T05FOwo+ICAgICAgICAgbGltLT56b25lX3dyaXRlX2dyYW51bGFyaXR5ID0gMDsKPiAgICAgICAg
IGxpbS0+ZG1hX2FsaWdubWVudCA9IDUxMTsKPiArICAgICAgIGxpbS0+YXRvbWljX3dyaXRlX3Vu
aXRfbWluID0gbGltLT5hdG9taWNfd3JpdGVfdW5pdF9tYXggPSAxOwo+ICsgICAgICAgbGltLT5h
dG9taWNfd3JpdGVfbWF4X2J5dGVzID0gNTEyOwo+ICsgICAgICAgbGltLT5hdG9taWNfd3JpdGVf
Ym91bmRhcnkgPSAwOwo+ICB9CgpOb3Qgc2VlaW5nIHJlcXVpcmVkIGNoYW5nZXMgdG8gYmxrX3Nl
dF9zdGFja2luZ19saW1pdHMoKSBub3IgYmxrX3N0YWNrX2xpbWl0cygpLgoKU29ycnkgdG8gcmVt
aW5kIHlvdSBvZiBETSBhbmQgTUQgbGltaXRzIHN0YWNraW5nIHJlcXVpcmVtZW50cy4gOykKCk1p
a2UKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

