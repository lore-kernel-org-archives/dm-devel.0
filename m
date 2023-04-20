Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D064C77B7F
	for <dm-devel@archiver.kernel.org>; Fri, 21 Apr 2023 06:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682059692;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6IoeQvWpe9Lj30sqjtlVOzR26oFdyNsXKjjX8H07tfk=;
	b=bmGes96A+oujwKVzR7hTisHPWB876NW1NpZyemP7sAf7dJ1615xZgZnTGluCmi7NpNrDCP
	eFyizTc5iZNH9TNkDmTXnecQm9scriiBPw+w7ufj7hjALEMNsHh2Qnd8DAISGIsgJxmFwk
	hjszZC152ITop00BTImuUmYMsefyCiA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-fy8H2K5kOeWl_txNwp7pxA-1; Fri, 21 Apr 2023 02:48:07 -0400
X-MC-Unique: fy8H2K5kOeWl_txNwp7pxA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB3A0185A792;
	Fri, 21 Apr 2023 06:47:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C9F652166B36;
	Fri, 21 Apr 2023 06:47:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C0D821946A40;
	Fri, 21 Apr 2023 06:47:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1FCEC1946A41
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 08:55:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0EBE751E3; Thu, 20 Apr 2023 08:55:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0734063A5D
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 08:55:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D11D0185A78B
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 08:55:38 +0000 (UTC)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
 [209.85.128.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-bmqiScu0MOSfy5HRdmcDfg-1; Thu, 20 Apr 2023 04:55:34 -0400
X-MC-Unique: bmqiScu0MOSfy5HRdmcDfg-1
Received: by mail-wm1-f50.google.com with SMTP id
 o9-20020a05600c510900b003f17012276fso2685983wms.4; 
 Thu, 20 Apr 2023 01:55:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681980932; x=1684572932;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=Z3oaCtnRgdVnX+/49rnLNjwqRbR+N3XhGwT33lpTGps=;
 b=ffYxorRkgrkicXaIifeUUeceTpisHJhFaeziY6NTewn6UKnEeO2Dnaj7GQiUJrnW/z
 XaFqtd1Yhr7gDoVaOB533N0qlLh5kF28Rv8gxVw93ImFbnTn/GHsOmIaObdceTYFCJwa
 4hWNPBsrRcDcQ/cfuRM/8eMmmWqB0ERVmRKTt1Qkn5Acm3kyl406PNYVML5DxRxus9dv
 P+rOLu1eN5BNSgcOLfmebMhzeGfoVXnh3kS7RUFFBa1VIaMr5xsTsnEvx71uRRgY32/R
 509XNNmhZX0VydvYMS3Fp5EsnRRcbAHc2TwMSwnVzbdeVA2M2/8WJKO+eCNgG4TjtV6c
 kxhA==
X-Gm-Message-State: AAQBX9dpZRDXUD8TnmGJwOKQi1vI71GbxUIIcGVGhQs0/eRlh+gJ+5UO
 sEU2ggGfgAo1IqnD/K5b3DwhIrONmnlcMT2k
X-Google-Smtp-Source: AKy350bKYLeXMzDzDJ6Y6qo/aThxWX/i4drIepoJR2AxRlr5KQ8S+fMnYJCtI7ItM3tNru7pKV43XQ==
X-Received: by 2002:a05:600c:acf:b0:3f1:72e6:2a69 with SMTP id
 c15-20020a05600c0acf00b003f172e62a69mr740456wmr.4.1681980932068; 
 Thu, 20 Apr 2023 01:55:32 -0700 (PDT)
Received: from [192.168.32.129] (aftr-62-216-205-152.dynamic.mnet-online.de.
 [62.216.205.152]) by smtp.gmail.com with ESMTPSA id
 ip29-20020a05600ca69d00b003f1712b1402sm4669681wmb.30.2023.04.20.01.55.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 20 Apr 2023 01:55:31 -0700 (PDT)
Message-ID: <0028b1b9-980a-4b3b-b290-099368e44f9f@kernel.org>
Date: Thu, 20 Apr 2023 10:55:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Andreas Gruenbacher <agruenba@redhat.com>
References: <20230419140929.5924-1-jth@kernel.org>
 <20230419140929.5924-12-jth@kernel.org>
 <CAHc6FU6U1yZguZGeCc7BUqd1Qm4+SSRK8xbNZWBUSXTk_jjvVQ@mail.gmail.com>
From: Johannes Thumshirn <jth@kernel.org>
In-Reply-To: <CAHc6FU6U1yZguZGeCc7BUqd1Qm4+SSRK8xbNZWBUSXTk_jjvVQ@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Fri, 21 Apr 2023 06:47:49 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTkvMDQvMjAyMyAxNzoxOSwgQW5kcmVhcyBHcnVlbmJhY2hlciB3cm90ZToKPiBPbiBXZWQs
IEFwciAxOSwgMjAyMyBhdCA0OjEw4oCvUE0gSm9oYW5uZXMgVGh1bXNoaXJuIDxqdGhAa2VybmVs
Lm9yZz4gd3JvdGU6Cj4+Cj4+IEZyb206IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1
bXNoaXJuQHdkYy5jb20+Cj4+Cj4+IFRoZSBHRlMgc3VwZXJibG9jayByZWFkaW5nIGNvZGUgdXNl
cyBiaW9fYWRkX3BhZ2UoKSB0byBhZGQgYSBwYWdlIHRvIGEKPj4gbmV3bHkgY3JlYXRlZCBiaW8u
IGJpb19hZGRfcGFnZSgpIGNhbiBmYWlsLCBidXQgdGhlIHJldHVybiB2YWx1ZSBpcyBuZXZlcgo+
PiBjaGVja2VkLgo+IAo+IEl0J3MgR0ZTMiwgbm90IEdGUywgYnV0IG90aGVyd2lzZSB0aGlzIGlz
IG9idmlvdXNseSBmaW5lLCB0aGFua3MuCj4gCgpPb3BzIGZpeGVkIGluIHY0CgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

