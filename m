Return-Path: <SRS0=Uigt=FO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45959C4361B
	for <dm-devel@archiver.kernel.org>; Thu, 10 Dec 2020 03:39:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7B6EF2184D
	for <dm-devel@archiver.kernel.org>; Thu, 10 Dec 2020 03:39:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B6EF2184D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-Adsj07_nN4i1kgAdJWQhWg-1; Wed, 09 Dec 2020 22:39:18 -0500
X-MC-Unique: Adsj07_nN4i1kgAdJWQhWg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C24718C8C00;
	Thu, 10 Dec 2020 03:39:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DD77010013C0;
	Thu, 10 Dec 2020 03:39:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 064C44BB7B;
	Thu, 10 Dec 2020 03:39:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BA3d5Ig011986 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Dec 2020 22:39:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 35B702026D5D; Thu, 10 Dec 2020 03:39:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 30CD02026D47
	for <dm-devel@redhat.com>; Thu, 10 Dec 2020 03:39:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57822800B3A
	for <dm-devel@redhat.com>; Thu, 10 Dec 2020 03:39:02 +0000 (UTC)
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com
	[209.85.210.195]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-337-hgwBm6Q-PpKoenk3orIV_w-1; Wed, 09 Dec 2020 22:38:58 -0500
X-MC-Unique: hgwBm6Q-PpKoenk3orIV_w-1
Received: by mail-pf1-f195.google.com with SMTP id 11so2755166pfu.4;
	Wed, 09 Dec 2020 19:38:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=vl3B7XtbEhQjt2nq8MXPBFdyJIVZUFP3ezbjFEmRzg8=;
	b=qHaZ37tGdlEaXanjfLUv7VLZrED1GWH650o4YXi0iEtR13+0ZPNIvgA6/dwoqQQ1i8
	B2EVSeIEJhR9u5CboWjDcKJ0S/BtBT0h1KlbvdgRRc4zUMBXeCTxZ85g5mPoIIN8Alwh
	x5xFThddpCa+FTlHrTxbQaWHI6zfZ7D3qEeLRRUQliO8AoyFakyuanG2UthizK3oDHB6
	50UbwO1R8WCrdpRgurfhduwTHCHtLs+VyLtx0rls4CKHPcxYFDaoVeCcpOnWo9S9CJxV
	k0tvFR5cm6A6olju8bnW87ibZKO8fRF/81dt7pZ/gsNSPaVrzwfYq3OPngthUYK3iP8C
	bPCw==
X-Gm-Message-State: AOAM533mBrkn9usExi9P9pYJuNLjK5k1YnuaKAUgAtWs3DjB+NLNyNjo
	z9K1EFGUfWvKV5EHpYEVPbk=
X-Google-Smtp-Source: ABdhPJyk5LMpvJBOnoJv/cjrpAyasLKu4LBxr7jKQq4OCERkzn7Dwo1S3bQcoGiBB3763Qi0ahgwYw==
X-Received: by 2002:a63:fe41:: with SMTP id x1mr4835088pgj.254.1607571536653; 
	Wed, 09 Dec 2020 19:38:56 -0800 (PST)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net.
	[73.241.217.19])
	by smtp.gmail.com with ESMTPSA id b4sm3743505pju.33.2020.12.09.19.38.54
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 09 Dec 2020 19:38:55 -0800 (PST)
To: Palmer Dabbelt <palmer@dabbelt.com>, Christoph Hellwig <hch@infradead.org>
References: <mhng-97fc5874-29d0-4d9e-8c92-d3704a482f28@palmerdabbelt-glaptop1>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <6fb5be2d-c6ca-c21b-dddf-9b314973dcfe@acm.org>
Date: Wed, 9 Dec 2020 19:38:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <mhng-97fc5874-29d0-4d9e-8c92-d3704a482f28@palmerdabbelt-glaptop1>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, linux-doc@vger.kernel.org, shuah@kernel.org,
	corbet@lwn.net, linux-kernel@vger.kernel.org,
	Josef Bacik <josef@toxicpanda.com>, linux-raid@vger.kernel.org,
	song@kernel.org, dm-devel@redhat.com,
	Mike Christie <michael.christie@oracle.com>,
	linux-kselftest@vger.kernel.org, kernel-team@android.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v1 0/5] dm: dm-user: New target that proxies
 BIOs to userspace
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMTIvNy8yMCAxMDo1NSBBTSwgUGFsbWVyIERhYmJlbHQgd3JvdGU6Cj4gQWxsIGluIGFsbCwg
SSd2ZSBmb3VuZCBpdCBhIGJpdCBoYXJkIHRvIGZpZ3VyZSBvdXQgd2hhdCBzb3J0IG9mIGludGVy
ZXN0Cj4gcGVvcGxlCj4gaGF2ZSBpbiBkbS11c2VyOiB3aGVuIEkgYnJpbmcgdGhpcyB1cCBJIHNl
ZW0gdG8gcnVuIGludG8gcGVvcGxlIHdobyd2ZSBkb25lCj4gc2ltaWxhciB0aGluZ3MgYmVmb3Jl
IGFuZCBhcmUgdmFndWVseSBpbnRlcmVzdGVkLCBidXQgY2VydGFpbmx5IG5vYm9keSBpcwo+IGNo
b21waW5nIGF0IHRoZSBiaXQuwqAgSSdtIHNlbmRpbmcgaXQgb3V0IGluIHRoaXMgZWFybHkgc3Rh
dGUgdG8gdHJ5IGFuZAo+IGZpZ3VyZQo+IG91dCBpZiBpdCdzIGludGVyZXN0aW5nIGVub3VnaCB0
byBrZWVwIGdvaW5nLgoKQ2MtaW5nIEpvc2VmIGFuZCBNaWtlIHNpbmNlIHRoZWlyIG5iZCBjb250
cmlidXRpb25zIG1ha2UgbWUgd29uZGVyCndoZXRoZXIgdGhpcyBuZXcgZHJpdmVyIGNvdWxkIGJl
IHVzZWZ1bCB0byB0aGVpciB1c2UgY2FzZXM/CgpUaGFua3MsCgpCYXJ0LgoKLS0KZG0tZGV2ZWwg
bWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

