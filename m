Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29B84CCA485
	for <dm-devel@archiver.kernel.org>; Tue, 28 Jun 2022 18:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656439566;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Jl0RiG17PT86kssH/wQzzvs3Vgdfith5QrKTbmd3tDk=;
	b=TA6qyZo/OCZar1iHlf2ybeAqoGdbaLLqwt94RSakOr6UUe6uYdkW2eN+xZ8gn53cf7t1Ok
	plCUhzIO73y+TL7X+R9SV9XqOry39K6ZFytouu2Cl9v5iQ3G2mGg6tWsjClmaMVhfnwYmN
	wZaPMnlILdDRts08yQN64TyENdcMtH8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-4vkBMTtYP8ahN3gvc7sGjQ-1; Tue, 28 Jun 2022 14:06:02 -0400
X-MC-Unique: 4vkBMTtYP8ahN3gvc7sGjQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23BED801755;
	Tue, 28 Jun 2022 18:06:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C26D318EAA;
	Tue, 28 Jun 2022 18:05:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 513871947056;
	Tue, 28 Jun 2022 18:05:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 416B719466DF
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Jun 2022 18:05:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2EF97492CA4; Tue, 28 Jun 2022 18:05:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 294BE492CA3
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 18:05:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1084D801233
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 18:05:58 +0000 (UTC)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-mX-XrjhfOzCVUKvPwmtPtg-1; Tue, 28 Jun 2022 14:05:55 -0400
X-MC-Unique: mX-XrjhfOzCVUKvPwmtPtg-1
Received: by mail-pf1-f180.google.com with SMTP id 136so7593006pfy.10
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 11:05:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=pTcGgtfSu6n7KkCWKQ4ciWe5XeKK5S4riO8KfNVW7Ig=;
 b=apyHjV+c6HRnv1B8hIcvU18ZJ/GpZG+XOeWQv68d/cMGKJLyusxo7agX+doOeEYd51
 yLDjkDiojGvWDLHnlyjwm8pjd5qvOJKBCluK0QIvUGa88irOslq1kRXDseCp0rbA+PEy
 aroa4BAKlxj/YHyrZm/peSjgLFA+s3evwt46xf6up7Y/zuXky7MpS5D7Y0XYjkpmWuLM
 yzp6tpEKcMER24im76xp8Mhz/5MYKb/qqVN7lB4Sfaepl+nOczvWdQOAXbU62nA+WEfe
 26Z4R0uULSLeXx0vcKmKbRH6l2mOxOSHq6FfIO+SfANh2OJAeucUBP5yFXO2Jp9Gl1NF
 h/ww==
X-Gm-Message-State: AJIora/t3fY8vWIyFXEyDp6hZlgkRxSG6lgLFxDypJoXHCu+3ODgiyqn
 JW/4akm0HipCULksGOvWr/pZ3XeVLtemUA==
X-Google-Smtp-Source: AGRyM1v6cdnwBfGpeB2JnkCbahQ14YUYaqjRd3VUKbR8YPBigZjfWVkzlvmFIFzfbBj+r2XqbA+86w==
X-Received: by 2002:a63:7412:0:b0:40c:fa27:9d07 with SMTP id
 p18-20020a637412000000b0040cfa279d07mr18441815pgc.27.1656439554674; 
 Tue, 28 Jun 2022 11:05:54 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
 by smtp.gmail.com with ESMTPSA id
 i3-20020a170902cf0300b0016a0ac06424sm9669985plg.51.2022.06.28.11.05.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Jun 2022 11:05:54 -0700 (PDT)
Date: Tue, 28 Jun 2022 11:05:53 -0700
From: Kees Cook <keescook@chromium.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Message-ID: <202206281104.7CC3935@keescook>
References: <20220627180432.GA136081@embeddedor>
 <CAMuHMdU27TG_rpd=WTRPRcY22A4j4aN-6d_8OmK2aNpX06G3ig@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAMuHMdU27TG_rpd=WTRPRcY22A4j4aN-6d_8OmK2aNpX06G3ig@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH][next] treewide: uapi: Replace zero-length
 arrays with flexible-array members
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
Cc: nvdimm@lists.linux.dev,
 ALSA Development Mailing List <alsa-devel@alsa-project.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, KVM list <kvm@vger.kernel.org>,
 DRI Development <dri-devel@lists.freedesktop.org>,
 "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
 dm-devel@redhat.com, target-devel <target-devel@vger.kernel.org>,
 MTD Maling List <linux-mtd@lists.infradead.org>,
 linux-hardening@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-s390 <linux-s390@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>,
 linux-rdma <linux-rdma@vger.kernel.org>,
 the arch/x86 maintainers <x86@kernel.org>,
 kasan-dev <kasan-dev@googlegroups.com>, lvs-devel@vger.kernel.org,
 coreteam@netfilter.org, V9FS Developers <v9fs-developer@lists.sourceforge.net>,
 Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
 linux-can@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-m68k <linux-m68k@lists.linux-m68k.org>,
 virtualization@lists.linux-foundation.org, io-uring@vger.kernel.org,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 netdev <netdev@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>,
 Linux MMC List <linux-mmc@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-perf-users@vger.kernel.org, linux-sctp@vger.kernel.org,
 NetFilter <netfilter-devel@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBKdW4gMjgsIDIwMjIgYXQgMDk6Mjc6MjFBTSArMDIwMCwgR2VlcnQgVXl0dGVyaG9l
dmVuIHdyb3RlOgo+IEhpIEd1c3Rhdm8sCj4gCj4gVGhhbmtzIGZvciB5b3VyIHBhdGNoIQo+IAo+
IE9uIE1vbiwgSnVuIDI3LCAyMDIyIGF0IDg6MDQgUE0gR3VzdGF2byBBLiBSLiBTaWx2YQo+IDxn
dXN0YXZvYXJzQGtlcm5lbC5vcmc+IHdyb3RlOgo+ID4gVGhlcmUgaXMgYSByZWd1bGFyIG5lZWQg
aW4gdGhlIGtlcm5lbCB0byBwcm92aWRlIGEgd2F5IHRvIGRlY2xhcmUKPiA+IGhhdmluZyBhIGR5
bmFtaWNhbGx5IHNpemVkIHNldCBvZiB0cmFpbGluZyBlbGVtZW50cyBpbiBhIHN0cnVjdHVyZS4K
PiA+IEtlcm5lbCBjb2RlIHNob3VsZCBhbHdheXMgdXNlIOKAnGZsZXhpYmxlIGFycmF5IG1lbWJl
cnPigJ1bMV0gZm9yIHRoZXNlCj4gPiBjYXNlcy4gVGhlIG9sZGVyIHN0eWxlIG9mIG9uZS1lbGVt
ZW50IG9yIHplcm8tbGVuZ3RoIGFycmF5cyBzaG91bGQKPiA+IG5vIGxvbmdlciBiZSB1c2VkWzJd
Lgo+IAo+IFRoZXNlIHJ1bGVzIGFwcGx5IHRvIHRoZSBrZXJuZWwsIGJ1dCB1YXBpIGlzIG5vdCBj
b25zaWRlcmVkIHBhcnQgb2YgdGhlCj4ga2VybmVsLCBzbyBkaWZmZXJlbnQgcnVsZXMgYXBwbHku
ICBVYXBpIGhlYWRlciBmaWxlcyBzaG91bGQgd29yayB3aXRoCj4gd2hhdGV2ZXIgY29tcGlsZXIg
dGhhdCBjYW4gYmUgdXNlZCBmb3IgY29tcGlsaW5nIHVzZXJzcGFjZS4KClJpZ2h0LCB1c2Vyc3Bh
Y2UgaXNuJ3QgYm91bmQgYnkgdGhlc2UgcnVsZXMsIGJ1dCB0aGUga2VybmVsIGVuZHMgdXAKY29u
c3VtaW5nIHRoZXNlIHN0cnVjdHVyZXMsIHNvIHdlIG5lZWQgdG8gZml4IHRoZW0uIFRoZSBbMF0g
LT4gW10KY2hhbmdlcyAod2hlbiB0aGV5IGFyZSBub3QgZXJyb25lb3VzbHkgYmVpbmcgdXNlZCB3
aXRoaW4gb3RoZXIKc3RydWN0dXJlcykgaXMgdmFsaWQgZm9yIGFsbCBjb21waWxlcnMuIEZsZXhp
YmxlIGFycmF5cyBhcmUgQzk5OyBpdCdzCmJlZW4gMjMgeWVhcnMuIDopCgpCdXQsIHllcywgd2hl
cmUgd2UgRE8gYnJlYWsgc3R1ZmYgd2UgbmVlZCB0byB3b3JrYXJvdW5kIGl0LCBldGMuCgotLSAK
S2VlcyBDb29rCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpo
dHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

