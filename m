Return-Path: <SRS0=MR+g=QE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A64B8C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 15:53:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2F3C6617E3
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 15:53:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2F3C6617E3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-SohaDPzgNkeZm1filn-xNw-1; Wed, 17 Nov 2021 10:53:06 -0500
X-MC-Unique: SohaDPzgNkeZm1filn-xNw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C1ED100F943;
	Wed, 17 Nov 2021 15:53:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8785B5BAFF;
	Wed, 17 Nov 2021 15:52:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8DB74180BAD2;
	Wed, 17 Nov 2021 15:52:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AHFqqti024998 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 10:52:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 26C4C404727D; Wed, 17 Nov 2021 15:52:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 230524047279
	for <dm-devel@redhat.com>; Wed, 17 Nov 2021 15:52:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BEE5811E85
	for <dm-devel@redhat.com>; Wed, 17 Nov 2021 15:52:52 +0000 (UTC)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
	[209.85.216.45]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-558-yej0Ay4PNkORu3ALGjm6Zw-1; Wed, 17 Nov 2021 10:52:47 -0500
X-MC-Unique: yej0Ay4PNkORu3ALGjm6Zw-1
Received: by mail-pj1-f45.google.com with SMTP id
	y14-20020a17090a2b4e00b001a5824f4918so5584402pjc.4; 
	Wed, 17 Nov 2021 07:52:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=hfy7Gp3+JeXESUrx1Gbx2zkhaFaWF3TcaVpxpcqkTgE=;
	b=s/SSRY5P/wGxe/vGNGFpnaMDgYvrzZLck1SYsYaAhBFE9ouBnXJhXMmSvDHz0hbW9K
	4+TV/es8b29kGl1GqJ5yF+qYKD9O+BN+OVduiw4R02MgP4qTbC2UFHAgVp76QQQqEX1I
	TIeMFfgLnLZC8Zoma/2BP2K6h5sKucdB5u5K7Y41AyYRAim4Uf5RhQU34ItudCVpXAUx
	6lW8zf/vXRZ7DUnFMVg5nMvolWE03zD0NNmeN+SUy+++OmvH3PsnC3Dpx9OEcYJIQE0m
	F2i3ukjSAR486MsvJFnYBhYo09fabHq2wZ2kC3HtCkhBSpUAf8z5VZCg2KXEpcJOeHfW
	Qvag==
X-Gm-Message-State: AOAM532RvQDZ2ZYAVb7OCYcD21TQFI3FoFJ6NtbGShU2Whx+KOzkDy3o
	qa/K884X9++azsr0AOj2O14=
X-Google-Smtp-Source: ABdhPJxm8WqyX8LthpnLwyvUjiFp2PmfTmFgScb1CA1TW0//yPGqt3+fmIM8D+HX4+Lp5dSpUb7G3w==
X-Received: by 2002:a17:90a:d70a:: with SMTP id
	y10mr855973pju.36.1637164366198; 
	Wed, 17 Nov 2021 07:52:46 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd?
	([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
	by smtp.gmail.com with ESMTPSA id
	h196sm71706pfe.216.2021.11.17.07.52.44
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 17 Nov 2021 07:52:45 -0800 (PST)
Message-ID: <553c2a78-1902-aa10-6cc6-a76cbd14364c@acm.org>
Date: Wed, 17 Nov 2021 07:52:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.0
To: =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>
References: <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
	<c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
	<20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
	<fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
	<20211008064925.oyjxbmngghr2yovr@mpHalley.local>
	<2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
	<20211029081447.ativv64dofpqq22m@ArmHalley.local>
	<20211103192700.clqzvvillfnml2nu@mpHalley-2>
	<20211116134324.hbs3tp5proxootd7@ArmHalley.localdomain>
	<ab4ec640-9a89-ea25-fe68-85bae2ae5d8d@acm.org>
	<20211117125224.z36hp2crpj4fwngc@ArmHalley.local>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211117125224.z36hp2crpj4fwngc@ArmHalley.local>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Vincent Fu <vincent.fu@samsung.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"hch@lst.de" <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"rwheeler@redhat.com" <rwheeler@redhat.com>
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMTcvMjEgMDQ6NTMsIEphdmllciBHb256w6FsZXogd3JvdGU6Cj4gVGhhbmtzIGZvciBz
aGFyaW5nIHRoaXMuIFdlIHdpbGwgbWFrZSBzdXJlIHRoYXQgRE0gLyBNRCBhcmUgc3VwcG9ydGVk
Cj4gYW5kIHRoZW4gd2UgY2FuIGNvdmVyIGV4YW1wbGVzLiBIb3BlZnVsbHksIHlvdSBndXlzIGNh
biBoZWxwIHdpdGggdGhlCj4gYml0cyBmb3IgZG0tY3J5cHQgdG8gbWFrZSB0aGUgZGVjaXNpb24g
dG8gb2ZmbG9hZCB3aGVuIGl0IG1ha2Ugc2Vuc2UuCgpXaWxsIGFzayBhcm91bmQgdG8gbGVhcm4g
d2hvIHNob3VsZCB3b3JrIG9uIHRoaXMuCgo+IEkgd2lsbCB1cGRhdGUgdGhlIG5vdGVzIHRvIGtl
ZXAgdGhlbSBhbGl2ZS4gTWF5YmUgd2UgY2FuIGhhdmUgdGhlbSBvcGVuCj4gaW4geW91ciBnaXRo
dWIgcGFnZT8KCkZlZWwgZnJlZSB0byBzdWJtaXQgYSBwdWxsIHJlcXVlc3QuCgpUaGFua3MsCgpC
YXJ0LgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6
Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

