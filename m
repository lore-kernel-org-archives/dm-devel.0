Return-Path: <SRS0=UIu2=FN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D94BC4361B
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:56:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ECF4923B6B
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:56:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECF4923B6B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=javigon.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-Sh0UFfQaPISoG6LHNZNFKw-1; Wed, 09 Dec 2020 04:56:50 -0500
X-MC-Unique: Sh0UFfQaPISoG6LHNZNFKw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CFE41005504;
	Wed,  9 Dec 2020 09:56:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18E7960BF1;
	Wed,  9 Dec 2020 09:56:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BB2C8180954D;
	Wed,  9 Dec 2020 09:56:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B8DDfoM016292 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Dec 2020 08:13:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AA3F3946A9; Tue,  8 Dec 2020 13:13:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A3A32946B9
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 13:13:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EC6B811E78
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 13:13:39 +0000 (UTC)
Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com
	[209.85.208.66]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-477-Rt-haJs4OFOmi0quNRcHcQ-1; Tue, 08 Dec 2020 08:13:36 -0500
X-MC-Unique: Rt-haJs4OFOmi0quNRcHcQ-1
Received: by mail-ed1-f66.google.com with SMTP id k4so17573182edl.0
	for <dm-devel@redhat.com>; Tue, 08 Dec 2020 05:13:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:content-transfer-encoding
	:in-reply-to;
	bh=4H0t76z3d9Gm8+rnlsRXMej2iqZW90QwJGGNcAOGfNQ=;
	b=F60Diqu0fAQV/jhuuPx4hgWEWs3rFfzMmBDqcjFfNz+OTOUaNmUbkdIY57ZXKAuRCO
	tQbwRLDsfdYDpUFwCMJ/hh7gKFEThx1PG1QGRH3XLEHzlyDLAmei7P/mJM7AtxAZ6XCO
	+h/2SDBilqZlcCCrBI3kKWGSur9Vwyf8cbPA+/sgF/mECVkEi4+6J4dZcEFmhACqgNvi
	1Q/B1CzqBWXC/Qkr3/tdjSPfzAte6kBbTnKJd5Jw/TAEn08b3fxrdAjn8Ct/kbFe6/Tn
	n8DO09ohM7Atul3xKTGN80S8KL8KRcLRU+c3KXxQpxE1OG6JnEhIkjS0ThveHPFoQd/i
	8dWw==
X-Gm-Message-State: AOAM530v5nJIDpNbXU23qzx8tx20eZbPtdSM48IrNptjsAjjrB8chOTv
	v6r1CUXheS+qn++fSwkmEcyk/w==
X-Google-Smtp-Source: ABdhPJxzR3lshkmLf680nwJwf3iSrf8fXTQ9WUttlW08OFCU+GJEW3f7mGgCqOCWWXeIGq2QqC1DUQ==
X-Received: by 2002:aa7:dac5:: with SMTP id x5mr25105016eds.198.1607433214946; 
	Tue, 08 Dec 2020 05:13:34 -0800 (PST)
Received: from localhost (5.186.124.214.cgn.fibianet.dk. [5.186.124.214])
	by smtp.gmail.com with ESMTPSA id u5sm16894960edp.5.2020.12.08.05.13.34
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 08 Dec 2020 05:13:34 -0800 (PST)
Date: Tue, 8 Dec 2020 14:13:33 +0100
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Message-ID: <20201208131333.xoxincxcnh7iz33z@mpHalley>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
	<20201204094659.12732-1-selvakuma.s1@samsung.com>
	<20201207141123.GC31159@lst.de>
	<01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
	<20201207192453.vc6clbdhz73hzs7l@mpHalley>
	<SN4PR0401MB35988951265391511EBC8C6E9BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
	<20201208122248.utv7pqthmmn6uwv6@mpHalley>
	<SN4PR0401MB35983464199FB173FB0C29479BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <SN4PR0401MB35983464199FB173FB0C29479BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 09 Dec 2020 04:56:16 -0500
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [dm-devel] [RFC PATCH v2 0/2] add simple copy support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMDguMTIuMjAyMCAxMjozNywgSm9oYW5uZXMgVGh1bXNoaXJuIHdyb3RlOgo+T24gMDgvMTIv
MjAyMCAxMzoyMiwgSmF2aWVyIEdvbnrDoWxleiB3cm90ZToKPj4gR29vZCBpZGVhLiBBcmUgeW91
IHRoaW5raW5nIG9mIGEgc3lzZnMgZW50cnkgdG8gc2VsZWN0IHRoZSBiYWNrZW5kPwo+Cj5Ob3Qg
c3VyZSBvbiB0aGlzIG9uZSwgaW5pdGlhbGx5IEkgdGhvdWdodCBvZiBhIHN5c2ZzIGZpbGUsIGJ1
dCB0aGVuCj5ob3cgd291bGQgeW91IGRvIGl0LiBPbmUgImdsb2JhbCIgc3lzZnMgZW50cnkgaXMg
cHJvYmFibHkgYSBiYWQgaWRlYS4KPkhhdmluZyBvbmUgcGVyIGJsb2NrIGRldmljZSB0byBzZWxl
Y3QgbmF0aXZlIHZzIGVtdWxhdGlvbiBtYXliZT8gQW5kCj5hIGdvb2Qgd2F5IHRvIGJlbmNobWFy
ay4KCkkgd2FzIHRoaW5raW5nIGEgcGVyIGJsb2NrIGRldmljZSB0byB0YXJnZXQgdGhlIHVzZSBj
YXNlIHdoZXJlIGEgY2VydGFpbgppbXBsZW1lbnRhdGlvbiAvIHdvcmtsb2FkIGlzIGJldHRlciBv
bmUgd2F5IG9yIHRoZSBvdGhlci4KCj4KPlRoZSBvdGhlciBpZGVhIHdvdWxkIGJlIGEgYmVuY2ht
YXJrIGxvb3Agb24gYm9vdCBsaWtlIHRoZSByYWlkIGxpYnJhcnkKPmRvZXMuCj4KPlRoZW4gb24g
dGhlIG90aGVyIGhhbmQsIHRoZXJlIG1pZ2h0IGJlIHdvcmtsb2FkcyB0aGF0IHJ1biBmYXN0ZXIg
d2l0aAo+dGhlIGVtdWxhdGlvbiBhbmQgc29tZSB0aGF0IHJ1biBmYXN0ZXIgd2l0aCB0aGUgaGFy
ZHdhcmUgYWNjZWxlcmF0aW9uLgo+Cj5JIHRoaW5rIHRoZXNlIHBvaW50cyBhcmUgdGhlIHJlYXNv
biB0aGUgbGFzdCBhdHRlbXB0cyBnb3Qgc3R1Y2suCgpZZXMuIEkgYmVsaWV2ZSB0aGF0IGFueSBi
ZW5jaG1hcmsgd2UgcnVuIHdvdWxkIGJlIGJpYXNlZCBpbiBhIGNlcnRhaW4Kd2F5LiBJZiB3ZSBj
YW4gbW92ZSBmb3J3YXJkIHdpdGggYSBzeXNmcyBlbnRyeSBhbmQgZGVmYXVsdCB0byBsZWdhY3kK
cGF0aCwgd2Ugd291bGQgbm90IGFsdGVyIGN1cnJlbnQgYmVoYXZpb3IgYW5kIGVuYWJsZSBOVk1l
IGNvcHkgb2ZmbG9hZAooZm9yIG5vdykgZm9yIHRob3NlIHRoYXQgd2FudCB0byB1c2UgaXQuIFdl
IGNhbiB0aGVuIGJ1aWxkIG9uIHRvcCBvZiBpdC4KCkRvZXMgdGhpcyBzb3VuZCBsaWtlIGEgcmVh
c29uYWJsZSBhcHByb2FjaD8KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRo
YXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

