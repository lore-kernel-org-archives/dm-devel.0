Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62218C7EE23
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 06:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686206955;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+A4g98evtAJ8cM0/UzvIIPCDfTeIOl07VuLVDamMa5I=;
	b=K66B9YXNYlfEIccqp+SInCXPtDqsTJ7c9bQWK0LGSrObcfXxnYaUIpYtcZstRW2BA6Dfpd
	XXkzKaS3dCTPg3kuG8KMgxoa/TlZt4UeR/uigL1KAEj9uabnFMAyLz3qYq/qpN+j39fwFL
	+vYBk+n8nwjN2mDyVrBiBVJrZPIgaqA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-m08dLtvcOi-9VWcEwfPGig-1; Thu, 08 Jun 2023 02:49:12 -0400
X-MC-Unique: m08dLtvcOi-9VWcEwfPGig-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C23E28EC12B;
	Thu,  8 Jun 2023 06:49:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 894DA4026E0;
	Thu,  8 Jun 2023 06:49:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7FE431954399;
	Thu,  8 Jun 2023 06:48:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 10D2A19465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 09:38:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E12EA403362; Wed,  7 Jun 2023 09:38:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D9A6C477F61
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 09:38:41 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1BE73801FF4
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 09:38:41 +0000 (UTC)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com
 [209.85.218.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-znr1SkYAMJSe8Bl0S6crcA-1; Wed, 07 Jun 2023 05:38:40 -0400
X-MC-Unique: znr1SkYAMJSe8Bl0S6crcA-1
Received: by mail-ej1-f48.google.com with SMTP id
 a640c23a62f3a-9745ba45cd1so935079366b.1
 for <dm-devel@redhat.com>; Wed, 07 Jun 2023 02:38:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686130719; x=1688722719;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=gjKWGYzTLmxl6ndmaqY1vhf0MYCxKeiBaM5D6TZOn9k=;
 b=SdG2XdJ8n8eWN67RRzpehW5MWEi7Pso27Wc3kU+AK9DPrfkNowh/M2v8ONABgVD0fi
 goColi7HKiGAesH9yvoCS/NyEvfbPDSbZW2fcCo5GyFSy5PfEu/sPQbX0NcTKPC2XqlC
 PwJLSDWM+iAblj740K+v8432YegJd3MJyyXvu0nnzjtI0G/+y2soyXnrYralhnhffFlB
 vascI9AX634N9SgyXXtuj9BBK+HS3nvDk9Y7DwjhAVbzJFhoJv/r6Dt923xfBj+Ljnd1
 E+NHBL+5oqPd4MouWSQFFYq1IRFvRixABHPeeDneBgVk5DVDpqJRooObReDLEQ6KhGcd
 eu8Q==
X-Gm-Message-State: AC+VfDxEChvfp+g5buOwSfCuvhVxhp8J1IGKjGdbCoZfebReQIyel7pR
 x5WVEN4FWyecG1n13dY3wgSD0LAAMh+dMwXy19BYHg==
X-Google-Smtp-Source: ACHHUZ4JO4oLBtR+CLz1tcyt1M0aK5Az38dx3TKZ26TI2779MlmTOIaNGaUTpmyncHvDOVtnmf3szZ6EUx+OtsgHRJ4=
X-Received: by 2002:a17:907:3f22:b0:96b:1608:3563 with SMTP id
 hq34-20020a1709073f2200b0096b16083563mr5475281ejc.58.1686130718689; Wed, 07
 Jun 2023 02:38:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-15-hch@lst.de>
In-Reply-To: <20230606073950.225178-15-hch@lst.de>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Wed, 7 Jun 2023 11:38:27 +0200
Message-ID: <CAMGffEk8Zex5+u69YW9AXGQh-ch79mw7=Gn3L1M=qwvZCVa5VA@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Thu, 08 Jun 2023 06:48:45 +0000
Subject: Re: [dm-devel] [PATCH 14/31] rnbd-srv: don't pass a holder for
 non-exclusive blkdev_get_by_path
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: ionos.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBKdW4gNiwgMjAyMyBhdCA5OjQw4oCvQU0gQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBs
c3QuZGU+IHdyb3RlOgo+Cj4gUGFzc2luZyBhIGhvbGRlciB0byBibGtkZXZfZ2V0X2J5X3BhdGgg
d2hlbiBGTU9ERV9FWENMIGlzbid0IHNldCBkb2Vzbid0Cj4gbWFrZSBzZW5zZSwgc28gcGFzcyBO
VUxMIGluc3RlYWQuCj4KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxz
dC5kZT4KQWNrZWQtYnk6IEphY2sgV2FuZyA8amlucHUud2FuZ0Bpb25vcy5jb20+Cj4gLS0tCj4g
IGRyaXZlcnMvYmxvY2svcm5iZC9ybmJkLXNydi5jIHwgMiArLQo+ICAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKPgo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2Js
b2NrL3JuYmQvcm5iZC1zcnYuYyBiL2RyaXZlcnMvYmxvY2svcm5iZC9ybmJkLXNydi5jCj4gaW5k
ZXggY2VjMjJiYmFlMmY5YTUuLmNlNTA1ZTU1MmY0ZDUwIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMv
YmxvY2svcm5iZC9ybmJkLXNydi5jCj4gKysrIGIvZHJpdmVycy9ibG9jay9ybmJkL3JuYmQtc3J2
LmMKPiBAQCAtNzE5LDcgKzcxOSw3IEBAIHN0YXRpYyBpbnQgcHJvY2Vzc19tc2dfb3BlbihzdHJ1
Y3Qgcm5iZF9zcnZfc2Vzc2lvbiAqc3J2X3Nlc3MsCj4gICAgICAgICAgICAgICAgIGdvdG8gcmVq
ZWN0Owo+ICAgICAgICAgfQo+Cj4gLSAgICAgICBiZGV2ID0gYmxrZGV2X2dldF9ieV9wYXRoKGZ1
bGxfcGF0aCwgb3Blbl9mbGFncywgVEhJU19NT0RVTEUsIE5VTEwpOwo+ICsgICAgICAgYmRldiA9
IGJsa2Rldl9nZXRfYnlfcGF0aChmdWxsX3BhdGgsIG9wZW5fZmxhZ3MsIE5VTEwsIE5VTEwpOwo+
ICAgICAgICAgaWYgKElTX0VSUihiZGV2KSkgewo+ICAgICAgICAgICAgICAgICByZXQgPSBQVFJf
RVJSKGJkZXYpOwo+ICAgICAgICAgICAgICAgICBwcl9lcnIoIk9wZW5pbmcgZGV2aWNlICclcycg
b24gc2Vzc2lvbiAlcyBmYWlsZWQsIGZhaWxlZCB0byBvcGVuIHRoZSBibG9jayBkZXZpY2UsIGVy
cjogJWRcbiIsCj4gLS0KPiAyLjM5LjIKPgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRl
dmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbAo=

