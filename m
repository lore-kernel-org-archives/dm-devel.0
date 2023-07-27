Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41ED6C001E0
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 10:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690453983;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j5cZozv9pKMIsyNX23O9pwWH68vjtbn9MssbkHbaa9I=;
	b=d49QEbCdx1jQ8IZX8Gpc5HRXKUrTRYedEYYp2DsmFqHPN7/LFEkAegscMKXYkBysj8gzxU
	oN84SQNe8jBCj19N3Cq33G2U7QYf7g16FuhKXyC1dpE1KmoPQUEaNRCjT0N3IKBchKzCiT
	6Pt+HvZVhK1R6xgbguaiyX0romn2mQc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-61SvDdPUNeuI8MMHfZNmCw-1; Thu, 27 Jul 2023 06:32:56 -0400
X-MC-Unique: 61SvDdPUNeuI8MMHfZNmCw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C1A21044592;
	Thu, 27 Jul 2023 10:32:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8D6D6414A80D;
	Thu, 27 Jul 2023 10:32:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3DF8D1946A6C;
	Thu, 27 Jul 2023 10:32:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 42E2E1946A6C
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Jul 2023 10:30:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 27DB3492B03; Thu, 27 Jul 2023 10:30:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F205492B02
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 10:30:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 026A3901840
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 10:30:04 +0000 (UTC)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com
 [209.85.219.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-eVSk2U3fOhupGXTPl1ywyg-1; Thu, 27 Jul 2023 06:30:01 -0400
X-MC-Unique: eVSk2U3fOhupGXTPl1ywyg-1
Received: by mail-yb1-f174.google.com with SMTP id
 3f1490d57ef6-d167393b95aso2880072276.0; 
 Thu, 27 Jul 2023 03:30:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690453800; x=1691058600;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=omUaDYixzWjtTMpLHRqhT6EXYqbxVHZ/m0JLSVt+zRU=;
 b=K2PLEQ7IZe2s6jHOeLz2RqOTojYpdmIcjZJkgM+octC3DAaJbHRNJ6HKxufW6ZaWUJ
 RxSNjuq3K9FcHtZuKljIZPfKNeeYIaNYcSfNLLF/QOxoDu8fk17CP5Eox07ng5Rv2ODk
 kxxcTuGBCO6II238j+NPqSwFPhEIcyeICNmyUXejQ4JSPcQtsIFLv8usPpvfY71/malz
 kOZeuNtCnH6iPXhg9KjX2NI/04UhLMBdMLtqkI1WToxWzPVL4HL4dFhu8SRvw+a9FbyL
 oDXrB0pnqD6qgCfUmg5xr/5nh351gZ2Xcur3XJYBU0WT78boeWh6J3BKiHWb+VaWKwts
 oYtg==
X-Gm-Message-State: ABy/qLZDaXyFkHbk27SZdhQ/yZg8ndPUMneyBR06PikQu01woJgOXlbw
 qBfAa2HqjgC+b2s7irzs0Y5h4/+QeZi7qX4cZhU=
X-Google-Smtp-Source: APBJJlHBlYlPNCAOaUQmX7sCh/RdKgzYXiRFfLFaMRkHkke9meK1yv0x0Ok78z4gqgOSPSppdBIT7tY7YrKsz3aQ6Jo=
X-Received: by 2002:a25:3617:0:b0:d1f:8809:ffa1 with SMTP id
 d23-20020a253617000000b00d1f8809ffa1mr2701868yba.27.1690453800151; Thu, 27
 Jul 2023 03:30:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230627183629.26571-1-nj.shetty@samsung.com>
 <CGME20230627184010epcas5p4bb6581408d9b67bbbcad633fb26689c9@epcas5p4.samsung.com>
 <20230627183629.26571-3-nj.shetty@samsung.com> <20230720074256.GA5042@lst.de>
In-Reply-To: <20230720074256.GA5042@lst.de>
From: Nitesh Shetty <nitheshshetty@gmail.com>
Date: Thu, 27 Jul 2023 15:59:49 +0530
Message-ID: <CAOSviJ3oDSHk2HXyRZa=A43vCxh-n2YkyuW-qXNq-q=i6bNacQ@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v13 2/9] block: Add copy offload support
 infrastructure
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
Cc: linux-doc@vger.kernel.org, djwong@kernel.org,
 linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
 linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 gost.dev@samsung.com, willy@infradead.org,
 Nitesh Shetty <nj.shetty@samsung.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Mike Snitzer <snitzer@kernel.org>,
 ming.lei@redhat.com, linux-block@vger.kernel.org, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBKdWwgMjAsIDIwMjMgYXQgMToxMuKAr1BNIENocmlzdG9waCBIZWxsd2lnIDxoY2hA
bHN0LmRlPiB3cm90ZToKPiA+IFN1Z2dlc3RlZC1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBs
c3QuZGU+Cj4KPiBIbW0sIEknbSBub3Qgc3VyZSBJIHN1Z2dlc3RlZCBhZGRpbmcgY29weSBvZmZs
b2FkLi4KPgpXZSBtZWFudCBmb3IgcmVxdWVzdCBiYXNlZCBkZXNpZ24sIHdlIHdpbGwgcmVtb3Zl
IGl0LgoKPiA+ICBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGludCBibGtfcnFfZ2V0X21heF9zZWdt
ZW50cyhzdHJ1Y3QgcmVxdWVzdCAqcnEpCj4gPiAgewo+ID4gICAgICAgaWYgKHJlcV9vcChycSkg
PT0gUkVRX09QX0RJU0NBUkQpCj4gPiBAQCAtMzAzLDYgKzMxMCw4IEBAIHN0YXRpYyBpbmxpbmUg
Ym9vbCBiaW9fbWF5X2V4Y2VlZF9saW1pdHMoc3RydWN0IGJpbyAqYmlvLAo+ID4gICAgICAgICAg
ICAgICBicmVhazsKPiA+ICAgICAgIH0KPiA+Cj4gPiArICAgICBpZiAodW5saWtlbHkob3BfaXNf
Y29weShiaW8tPmJpX29wZikpKQo+ID4gKyAgICAgICAgICAgICByZXR1cm4gZmFsc2U7Cj4KPiBU
aGlzIGxvb2tzIHdyb25nIHRvIG1lLiAgSSB0aGluayB0aGUgY29weSBvcHMgbmVlZCB0byBiZSBh
ZGRlZCB0byB0aGUKPiBzd2l0Y2ggc3RhdGVtZW50IGFib3ZlIGFzIHRoZXkgaGF2ZSBub24tdHJp
dmlhbCBzcGxpdHRpbmcgZGVjaXNpb25zLgo+IE9yIGF0IGxlYXN0IHNob3VsZCBoYXZlIHRob3Nl
IGFzIHdlJ3JlIG1pc3NpbmcgdGhlIGNvZGUgdG8gc3BsaXQKPiBjb3B5IGNvbW1hbmRzIHJpZ2h0
IG5vdy4KPgoKQWdyZWVkLCBjb3B5IHdpbGwgaGF2ZSBub24tdHJpdmlhbCBzcGxpdHRpbmcgZGVj
aXNpb25zLiBCdXQsIEkKY291bGRuJ3QgdGhpbmsgb2Ygc2NlbmFyaW9zIHdoZXJlIHRoaXMgY291
bGQgaGFwcGVuLCBhcyB3ZSBjaGVjayBmb3IKcXVldWUgbGltaXRzIGJlZm9yZSBpc3N1aW5nIGEg
Y29weS4gRG8geW91IHNlZSBzY2VuYXJpb3Mgd2hlcmUgc3BsaXQKY291bGQgaGFwcGVuIGZvciBj
b3B5IGhlcmUuCgpBY2tlZCBmb3IgYWxsIG90aGVyIHJldmlldyBjb21tZW50cy4KClRoYW5rIHlv
dSwKTml0ZXNoIFNoZXR0eQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bAo=

