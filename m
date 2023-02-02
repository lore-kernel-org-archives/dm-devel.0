Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09BAAC61DA4
	for <dm-devel@archiver.kernel.org>; Thu,  2 Feb 2023 19:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675367804;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=M/dxrv5FPlFjYzEpHoCwC6q+JSA+T63i3OxM76bF2Uc=;
	b=SLvnDNKG29UIl9piaryeuTTCDDiCKrD0BD1kkNm3mHC1T88qRX/UEgSzYi5ari+kpT4rzd
	L9JGGwpNL7fjrEXrBHM8GZtSX+rmW5GlwxMdvv9X/BbVYlANB/58i5XIeIafsOAg+4P8Z4
	6VdmIvgOiYIgvZjZsdMlfSwVolQ/7RM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-CxLA4EN-NZO9fpt5-_R1pA-1; Thu, 02 Feb 2023 14:56:43 -0500
X-MC-Unique: CxLA4EN-NZO9fpt5-_R1pA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E59B802314;
	Thu,  2 Feb 2023 19:56:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 524C951E5;
	Thu,  2 Feb 2023 19:56:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 16D08194658C;
	Thu,  2 Feb 2023 19:56:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BA9F31946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 19:56:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9ED27492B00; Thu,  2 Feb 2023 19:56:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 97802492C3E
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 19:56:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 791E4185A7A4
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 19:56:38 +0000 (UTC)
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com
 [209.85.160.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-447-kJujh96ROQK8m8iSuW0E4g-1; Thu, 02 Feb 2023 14:56:36 -0500
X-MC-Unique: kJujh96ROQK8m8iSuW0E4g-1
Received: by mail-qt1-f177.google.com with SMTP id h24so3182422qta.12
 for <dm-devel@redhat.com>; Thu, 02 Feb 2023 11:56:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=puPH7Nn4Vxt3kUnQKHCGR9XbgEDlt42vfosxQIpu+cs=;
 b=vYsNdf+SwdmxZx279LAP7tfCzvk7NXvWdSBZ4+gE6Vprr1AoSDIywg/FLr7o9Tq1Rl
 Gf0RX+VtJ5ToovsHq6bIg8UOu6NUfGF6iqSgyjBb9kMFYaoQ+8OFrGmI7C6KQOozCZc3
 8iqKjkblcQVneIVO6SF7GNj+R4ZjNuu41pL/Z2RzR8fjC5AWS6mff/jZkdqAwTQbCp0W
 f5GXxegThjxYFuDewNApMP9lEcEqPZ7BUK23gnuspuwat3+uK6B+vMFINBOsFbCi8Wi7
 CWA276szgQBHbLi2MeD7y8cUVJhWNb2AqfvlPW8Bjvqb00IZiZ7amrtoVE9UFC8TjWpU
 QS/g==
X-Gm-Message-State: AO0yUKWFydx7Reo6Xi7XLxdjj+vCR5bISfWI5RuS4yowZbopWykGOHBR
 JoEgvZVumD7BefpbGdc6QfevEmw=
X-Google-Smtp-Source: AK7set92dyhIkHCdWF7e92O2MXu6mUmZ6lpekQmSoPBHbD1dR3CVvDYQ1CtAQ9IvY8M0gdRPR2pO1A==
X-Received: by 2002:a05:622a:511:b0:3b8:6c68:6109 with SMTP id
 l17-20020a05622a051100b003b86c686109mr13439452qtx.21.1675367796153; 
 Thu, 02 Feb 2023 11:56:36 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 h6-20020a05620a10a600b007246f005d8bsm293223qkk.116.2023.02.02.11.56.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Feb 2023 11:56:35 -0800 (PST)
Date: Thu, 2 Feb 2023 14:56:34 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
Message-ID: <Y9wVcskXyOk3bbzC@redhat.com>
References: <20230126033358.1880-1-demi@invisiblethingslab.com>
 <Y9vp3XDEQAl7TLND@redhat.com> <Y9wEF3rWfpiCKc2i@itl-email>
MIME-Version: 1.0
In-Reply-To: <Y9wEF3rWfpiCKc2i@itl-email>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [RFC PATCH 0/7] Allow race-free block device handling
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
Cc: Jens Axboe <axboe@kernel.dk>, Juergen Gross <jgross@suse.com>,
 Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 xen-devel@lists.xenproject.org, Alasdair Kergon <agk@redhat.com>,
 Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBGZWIgMDIgMjAyMyBhdCAgMTo0MVAgLTA1MDAsCkRlbWkgTWFyaWUgT2Jlbm91ciA8
ZGVtaUBpbnZpc2libGV0aGluZ3NsYWIuY29tPiB3cm90ZToKCj4gT24gVGh1LCBGZWIgMDIsIDIw
MjMgYXQgMTE6NTA6MzdBTSAtMDUwMCwgTWlrZSBTbml0emVyIHdyb3RlOgo+ID4gT24gV2VkLCBK
YW4gMjUgMjAyMyBhdCAxMDozM1AgLTA1MDAsCj4gPiBEZW1pIE1hcmllIE9iZW5vdXIgPGRlbWlA
aW52aXNpYmxldGhpbmdzbGFiLmNvbT4gd3JvdGU6Cj4gPiAKPiA+ID4gVGhpcyB3b3JrIGFpbXMg
dG8gYWxsb3cgdXNlcnNwYWNlIHRvIGNyZWF0ZSBhbmQgZGVzdHJveSBibG9jayBkZXZpY2VzCj4g
PiA+IGluIGEgcmFjZS1mcmVlIGFuZCBsZWFrLWZyZWUgd2F5LAo+ID4gCj4gPiAicmFjZS1mcmVl
IGFuZCBsZWFrLWZyZWUgd2F5IiBpbXBsaWVzIHRoZXJlIGJvdGggcmFjZXMgYW5kIGxlYWtzIGlu
Cj4gPiBleGlzdGluZyBjb2RlLiBZb3UncmUgbWFraW5nIGNsYWltcyB0aGF0IGFyZSBsaWtlbHkg
dmVyeSBzcGVjaWZpYyB0bwo+ID4geW91ciBYZW4gdXNlLWNhc2UuICBQbGVhc2UgZXhwbGFpbiBt
b3JlIGNhcmVmdWxseS4KPiAKPiBXaWxsIGRvIGluIHYyLgo+IAo+ID4gPiBhbmQgdG8gYWxsb3cg
dGhlbSB0byBiZSBleHBvc2VkIHRvCj4gPiA+IG90aGVyIFhlbiBWTXMgdmlhIGJsa2JhY2sgd2l0
aG91dCBsZWFrcyBvciByYWNlcy4gIEl04oCZcyBtYXJrZWQgYXMgUkZDCj4gPiA+IGZvciBhIGZl
dyByZWFzb25zOgo+ID4gPiAKPiA+ID4gLSBUaGUgY29kZSBoYXMgYmVlbiBvbmx5IGxpZ2h0bHkg
dGVzdGVkLiAgSXQgbWlnaHQgYmUgdW5zdGFibGUgb3IKPiA+ID4gICBpbnNlY3VyZS4KPiA+ID4g
Cj4gPiA+IC0gVGhlIERNX0RFVl9DUkVBVEUgaW9jdGwgZ2FpbnMgYSBuZXcgZmxhZy4gIFVua25v
d24gZmxhZ3Mgd2VyZQo+ID4gPiAgIHByZXZpb3VzbHkgaWdub3JlZCwgc28gdGhpcyBjb3VsZCB0
aGVvcmV0aWNhbGx5IGJyZWFrIGJ1Z2d5IHVzZXJzcGFjZQo+ID4gPiAgIHRvb2xzLgo+ID4gCj4g
PiBOb3Qgc2VlaW5nIGEgcmVhc29uIHRoYXQgdHlwZSBvZiBETSBjaGFuZ2UgaXMgbmVlZGVkLiBJ
ZiB5b3UgZmVlbAo+ID4gc3Ryb25nbHkgYWJvdXQgaXQgc2VuZCBhIHNlcGFyYXRlIHBhdGNoIGFu
ZCB3ZSBjYW4gZGlzY3VzcyBpdC4KPiAKPiBQYXRjaCAyLzcgaXMgdGhlIGRpc2tzZXEgY2hhbmdl
LiAgdjIgd2lsbCBjb250YWluIGEgcmV2aXNlZCBhbmQgdGVzdGVkCj4gdmVyc2lvbiB3aXRoIGEg
Z3JlYXRseSBleHBhbmRlZCBjb21taXQgbWVzc2FnZS4KCkknbSBhd2FyZSB0aGF0IDIvNyBpcyB3
aGVyZSB5b3UgbWFrZSB0aGUgRE0gY2hhbmdlIHRvIGRpc2FsbG93IHVua25vd24KZmxhZ3MsIHdo
YXQgSSdtIHNheWluZyBpcyBJIGRvbid0IHNlZSBhIHJlYXNvbiBmb3IgdGhhdCBjaGFuZ2UuCgpD
ZXJ0YWlubHkgZG9lc24ndCBsb29rIHRvIGJlIGEgcmVxdWlyZW1lbnQgZm9yIGV2ZXJ5dGhpbmcg
ZWxzZSBpbiB0aGF0CnBhdGNoLgoKU28gc2VuZCBhIHNlcGFyYXRlIHBhdGNoLCBidXQgSSdtIGlu
Y2xpbmVkIHRvIF9ub3RfIGFjY2VwdCBpdCBiZWNhdXNlCml0IGRvZXMgcG90ZW50aWFsbHkgYnJl
YWsgc29tZSB1c2Vyc3BhY2UuCiAKPiA+ID4gLSBJIGhhdmUgbm8gaWRlYSBpZiBJIGdvdCB0aGUg
YmxvY2sgZGV2aWNlIHJlZmVyZW5jZSBjb3VudGluZyBhbmQKPiA+ID4gICBsb2NraW5nIGNvcnJl
Y3QuCj4gPiAKPiA+IFlvdXIgaGVhZGVycyBhbmQganVzdGlmY2F0aW9uIGZvciB0aGlzIGxpbmUg
b2Ygd29yayBhcmUgcmVhbGx5IHdheSB0b28KPiA+IHRlcnNlLiBQbGVhc2UgdGFrZSB0aGUgdGlt
ZSB0byBjbGVhcmx5IG1ha2UgdGhlIGNhc2UgZm9yIHlvdXIgY2hhbmdlcwo+ID4gaW4gYm90aCB0
aGUgcGF0Y2ggaGVhZGVycyBhbmQgY29kZS4KPiAKPiBJIHdpbGwgZXhwYW5kIHRoZSBjb21taXQg
bWVzc2FnZSBpbiB2MiwgYnV0IEkgYW0gbm90IHN1cmUgd2hhdCB5b3Ugd2FudAo+IG1lIHRvIGFk
ZCB0byB0aGUgY29kZSBjb21tZW50cy4gIFdvdWxkIHlvdSBtaW5kIGV4cGxhaW5pbmc/CgpOb3Ro
aW5nIHNwZWNpZmljIGFib3V0IGNvZGUsIHdhcyBqdXN0IGEgZ2VuZXJhbCByZW1pbmRlciAoYmFz
ZWQgb24gaG93CnRlcnNlIHRoZSAyLzcgaGVhZGVyIHdhcykuCgpNaWtlCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

