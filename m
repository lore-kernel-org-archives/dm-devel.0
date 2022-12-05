Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C787FC63707
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 13:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670420246;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8NKjW5C84BDbnRpUO6IFPk3Q6/y41fcgUpiX+lSJAC8=;
	b=TgGdXqwHIK9PtAudIR3e1sBwH1UdW6OqozeX+RhHEfULbXfZjaGjtwBBXm9o/HMG3/pnAE
	VMVRFWRmIBCu5OC6uM/MLpq2CvJk7gvNLlOOaJkF0wsJUAUg24weiNkN1L97AADqI4EAYT
	7RMMSlfb7YRfvPX0oZvnrdVG5HC2gfA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-UUpxJ6d0PeWJYPS5bjOBdA-1; Wed, 07 Dec 2022 08:37:23 -0500
X-MC-Unique: UUpxJ6d0PeWJYPS5bjOBdA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEF44857D17;
	Wed,  7 Dec 2022 13:37:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CD55C1121315;
	Wed,  7 Dec 2022 13:37:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 849181946A66;
	Wed,  7 Dec 2022 13:37:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 402C61946588
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Dec 2022 20:35:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 019E32166B2A; Mon,  5 Dec 2022 20:35:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EE2E82166B29
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 20:35:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFC4B86F12A
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 20:35:43 +0000 (UTC)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com
 [209.85.217.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-350-S-4onrnvNweryfKTpTrXMg-1; Mon, 05 Dec 2022 15:35:40 -0500
X-MC-Unique: S-4onrnvNweryfKTpTrXMg-1
Received: by mail-vs1-f53.google.com with SMTP id t5so12255680vsh.8
 for <dm-devel@redhat.com>; Mon, 05 Dec 2022 12:35:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=qFTi/EIm231UDoHzwjip2wcifKLUtbEyBimAW5q1nBE=;
 b=l70AetEXCGbEgTzCZbBHPDu5fo+XOAyhQUaHBrKjNOPOUk2O3ZxyhVF9gMcKcoHJ1p
 3KVFZK+Errwlp5mleLfxIt5I80cO9SJCdCV1rgdQrWEXkS4GZuyfh6qFpkNE1iWA2FHV
 ZaVX5Q4mmTHwEkkI3PP8Vpt1ZZrK0p77nLHm/O1RiJhKTyIcFi6nfPu+2jlaaezqRrNf
 ncRTgSf1u6qbgwiD6yUuPl2Qki5g2Ir/46SGGTV+KO5nrQ4r8mYU//ssN6xIPPx5CltQ
 CNX6NElbN1vAGaNEpcPNsYDy7kg9yWQdVgLhzszR9GXxsWbqX6a8TjO8+NYkN34B+iKI
 4XXA==
X-Gm-Message-State: ANoB5pmwtKif/IUh3mqSMd/0O1nkkiFZYksd4vpbdmNEdWSoopTAfcko
 MZdzj5JxSoCVH+Oxw9Qn+y5tE380ZCZUIeIqIt8pbQ==
X-Google-Smtp-Source: AA0mqf7MB2LLmyAgUEmc373KKoUMFotSP/Hm9OtWsUgrY1RZnvtlRZ/+/FkhUm+SUZshtLHs/8QlYlIHB++A57PkUUg=
X-Received: by 2002:a67:f88c:0:b0:3b0:dbae:4115 with SMTP id
 h12-20020a67f88c000000b003b0dbae4115mr12656784vso.32.1670272539806; Mon, 05
 Dec 2022 12:35:39 -0800 (PST)
MIME-Version: 1.0
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <fe2800f1-aaae-33e8-aaf0-83fd034162d5@kernel.dk>
 <CAJs=3_AKOMWBpvKqvX6_c=zN1cwEM7x9dzGr7na=i-5_16rdEg@mail.gmail.com>
 <23c98c7c-3ed0-0d26-24c0-ed8a63266dcc@kernel.dk>
 <20221205152708-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221205152708-mutt-send-email-mst@kernel.org>
From: Enrico Granata <egranata@google.com>
Date: Mon, 5 Dec 2022 13:35:28 -0700
Message-ID: <CAPR809siFTeKSVxGPmnWpbyKHKoiVY-YYVV+Wzv2bVtvc4XBfA@mail.gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Wed, 07 Dec 2022 13:37:16 +0000
Subject: Re: [dm-devel] [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME
 feature support
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 Alvaro Karsz <alvaro.karsz@solid-run.com>, Jason Wang <jasowang@redhat.com>,
 linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

VGhlIG9yaWdpbmFsIGRlZmluaXRpb25zIGZvciB0aGVzZSBmaWVsZHMgY29tZSBmcm9tIEpFU0Q4
NC1CNTAsIHdoaWNoCmlzIHdoYXQgZU1NQyBzdG9yYWdlIHVzZXMuIEl0IGhhcyBiZWVuIGEgd2hp
bGUsIGJ1dCBJIHJlY2FsbCBVRlMgZG9pbmcKc29tZXRoaW5nIHByZXR0eSBzaW1pbGFyLgpTeXN0
ZW1zIHRoYXQgZG9uJ3QgaGF2ZSBhIHdlbGwgZGVmaW5lZCBub3Rpb24gb2YgZHVyYWJpbGl0eSB3
b3VsZCBqdXN0Cm5vdCBleHBvc2UgdGhlIGZsYWcgKGUuZy4gYSBzcGlubmluZyBkaXNrKSwgYW5k
IGdvaW5nIGZvciB3aGF0CmVNTUMvVUZTIGV4cG9zZSBhbHJlYWR5IHdvdWxkIG1ha2UgaW1wbGVt
ZW50YXRpb25zIGZhaXJseSBzZWFtbGVzcyBmb3IKYSBsb3Qgb2YgY29tbW9uIGVtYmVkZGVkIHNj
ZW5hcmlvcy4KCk9mIGNvdXJzZSwgaWYgeW91IHNlZSByb29tIGZvciBpbXByb3ZlbWVudCB0byB0
aGUgc3BlYywgSSdkIGJlIHZlcnkKaW50ZXJlc3RlZCBpbiBoZWFyaW5nIHlvdXIgdGhvdWdodHMK
ClRoYW5rcywKLSBFbnJpY28KClRoYW5rcywKLSBFbnJpY28KCgpPbiBNb24sIERlYyA1LCAyMDIy
IGF0IDE6MjkgUE0gTWljaGFlbCBTLiBUc2lya2luIDxtc3RAcmVkaGF0LmNvbT4gd3JvdGU6Cj4K
PiBPbiBNb24sIERlYyAwNSwgMjAyMiBhdCAxMTo1Mzo1MUFNIC0wNzAwLCBKZW5zIEF4Ym9lIHdy
b3RlOgo+ID4gT24gMTIvNS8yMiAxMTozNuKAr0FNLCBBbHZhcm8gS2Fyc3ogd3JvdGU6Cj4gPiA+
IEhpLAo+ID4gPgo+ID4gPj4gSXMgdGhpcyBiYXNlZCBvbiBzb21lIHNwZWM/IEJlY2F1c2UgaXQg
bG9va3MgcHJldHR5IG9kZCB0byBtZS4gVGhlcmUKPiA+ID4+IGNhbiBiZSBhIHByZXR0eSB3aWRl
IHJhbmdlIG9mIHR3by90aHJlZS9ldGMgbGV2ZWwgY2VsbHMgd2l0aCB3aWxkbHkKPiA+ID4+IGRp
ZmZlcmVudCByYW5nZXMgb2YgZHVyYWJpbGl0eS4gQW5kIHRoZXJlJ3MgcmVhbGx5IG5vdCBhIGxv
dCBvZiBzbGMKPiA+ID4+IGZvciBnZW5lcmljIGRldmljZXMgdGhlc2UgZGF5cywgaWYgYW55Lgo+
ID4gPgo+ID4gPiBZZXMsIHRoaXMgaXMgYmFzZWQgb24gdGhlIHZpcnRpbyBzcGVjCj4gPiA+IGh0
dHBzOi8vZG9jcy5vYXNpcy1vcGVuLm9yZy92aXJ0aW8vdmlydGlvL3YxLjIvY3NkMDEvdmlydGlv
LXYxLjItY3NkMDEuaHRtbAo+ID4gPiBzZWN0aW9uICA1LjIuNgo+ID4KPiA+IEFuZCB3aGVyZSBk
aWQgdGhpcyBjb21lIGZyb20/Cj4KPgo+IEhlcmUncyB0aGUgY29tbWl0IGxvZyBmcm9tIHRoZSBz
cGVjOgo+ICAgICAgICAgSW4gbWFueSBlbWJlZGRlZCBzeXN0ZW1zLCB2aXJ0aW8tYmxrIGltcGxl
bWVudGF0aW9ucyBhcmUKPiAgICAgICAgIGJhY2tlZCBieSBlTU1DIG9yIFVGUyBzdG9yYWdlIGRl
dmljZXMsIHdoaWNoIGFyZSBzdWJqZWN0IHRvCj4gICAgICAgICBwcmVkaWN0YWJsZSBhbmQgbWVh
c3VyYWJsZSB3ZWFyIG92ZXIgdGltZSBkdWUgdG8gcmVwZWF0ZWQgd3JpdGUKPiAgICAgICAgIGN5
Y2xlcy4KPgo+ICAgICAgICAgRm9yIHN1Y2ggc3lzdGVtcywgaXQgY2FuIGJlIGltcG9ydGFudCB0
byBiZSBhYmxlIHRvIHRyYWNrCj4gICAgICAgICBhY2N1cmF0ZWx5IHRoZSBhbW91bnQgb2Ygd2Vh
ciBpbXBvc2VkIG9uIHRoZSBzdG9yYWdlIG92ZXIKPiAgICAgICAgIHRpbWUgYW5kIHN1cmZhY2Ug
aXQgdG8gYXBwbGljYXRpb25zLiBJbiBhIG5hdGl2ZSBkZXBsb3ltZW50cwo+ICAgICAgICAgdGhp
cyBpcyBnZW5lcmFsbHkgaGFuZGxlZCBieSB0aGUgcGh5c2ljYWwgYmxvY2sgZGV2aWNlIGRyaXZl
cgo+ICAgICAgICAgYnV0IG5vIHN1Y2ggcHJvdmlzaW9uIGlzIG1hZGUgaW4gdmlydGlvLWJsayB0
byBleHBvc2UgdGhlc2UKPiAgICAgICAgIG1ldHJpY3MgZm9yIGRldmljZXMgd2hlcmUgaXQgbWFr
ZXMgc2Vuc2UgdG8gZG8gc28uCj4KPiAgICAgICAgIFRoaXMgcGF0Y2ggYWRkcyBzdXBwb3J0IHRv
IHZpcnRpby1ibGsgZm9yIGxpZmV0aW1lIGFuZCB3ZWFyCj4gICAgICAgICBtZXRyaWNzIHRvIGJl
IGV4cG9zZWQgdG8gdGhlIGd1ZXN0IHdoZW4gYSBkZXBsb3ltZW50IG9mCj4gICAgICAgICB2aXJ0
aW8tYmxrIGlzIGRvbmUgb3ZlciBjb21wYXRpYmxlIGVNTUMgb3IgVUZTIHN0b3JhZ2UuCj4KPiAg
ICAgICAgIFNpZ25lZC1vZmYtYnk6IEVucmljbyBHcmFuYXRhIDxlZ3JhbmF0YUBnb29nbGUuY29t
Pgo+Cj4gQ2MgRW5yaWNvIEdyYW5hdGEgYXMgd2VsbC4KPgo+Cj4gPiAtLQo+ID4gSmVucyBBeGJv
ZQo+ID4KPgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0
cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

