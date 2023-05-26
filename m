Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34852C77B7A
	for <dm-devel@archiver.kernel.org>; Fri, 26 May 2023 02:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685068537;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0tM4Tx5wmWU2uvrFfrpQWTP0HnBVhudc769iZsgFq/g=;
	b=EFPeziWerNkjbW+TqBQ5YYcIZayt46YFoHBJ+bRRkUJrZoo27JAcj/nPWKX7nO78M91zZS
	wE3WKK9AvDcNhBxr9MbiYBXauWH4XNEyVOtSgVc+CV/AyxtMaA48fzMVkLNDRmVi/QKDxj
	baxOWqUqCX8iksBT34zDNgQP5ZBmsng=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-Q8eKn8FPNrqnDhHTbD54sg-1; Thu, 25 May 2023 22:35:34 -0400
X-MC-Unique: Q8eKn8FPNrqnDhHTbD54sg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9574985A5BF;
	Fri, 26 May 2023 02:35:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BA9702166B2B;
	Fri, 26 May 2023 02:35:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 84F4819465A4;
	Fri, 26 May 2023 02:35:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 66BEF19465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 02:35:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 442ECC154D1; Fri, 26 May 2023 02:35:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B9EDC15612
 for <dm-devel@redhat.com>; Fri, 26 May 2023 02:35:30 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F27985A5A8
 for <dm-devel@redhat.com>; Fri, 26 May 2023 02:35:30 +0000 (UTC)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com
 [209.85.218.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-wlYOKYyiONq8FZGKni2amg-1; Thu, 25 May 2023 22:35:27 -0400
X-MC-Unique: wlYOKYyiONq8FZGKni2amg-1
Received: by mail-ej1-f43.google.com with SMTP id
 a640c23a62f3a-96f8d485ef3so30829766b.0
 for <dm-devel@redhat.com>; Thu, 25 May 2023 19:35:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685068526; x=1687660526;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=+W8m3Ca/C7ABr7TnX4n7WXczAjnHTy6VxW28/pga+l4=;
 b=lZZOnc20OlBSFW/ys6qPS4SGd4RWf2IF9ofys+4oIbcj6ZC6PdRYzpSDtTcEZM/c+g
 lVm3qP6uLlt5aHOSOiIFAXaIPvvvp2I6wD2oQFVi6EMVOJu6zxQtaBBXy/nxrkz2wMt0
 0GK6xpT9/YwFZlcDdfO2mKWUYDWPKwczJMV/iZKj9z+9mfA7YbkJbHRIcb0rGDO7x+O6
 COjD6qumg/h+LIoov7sRxKM+CuWKYMN0ok3IVgnm7gLF7a6cJ7+kh7pslgw4odoQW4Z2
 Kmtro+om//Hv/szW16BVhLbwwneE6mkLimc4+9XTct2K3C5G6IoBTFppIKWDLqAn84uu
 0x/w==
X-Gm-Message-State: AC+VfDwd6BMFfqBEh3H9RnQ1gM7AKTokLjo2skIF8+eycckpGWIYJW1d
 j0RCJM2aGMY0vLYMLusqJeUjfcI3jXgvrfrItAqvCQ==
X-Google-Smtp-Source: ACHHUZ4+v93lsnr3vDJxsBIB4NIbwy545X9nEEDCwOA1BxMR0ul1C//JHHo5qpf1DdQM1Wstuba6WbgbYuA6QotLgOc=
X-Received: by 2002:a17:906:dacb:b0:96b:e92:4feb with SMTP id
 xi11-20020a170906dacb00b0096b0e924febmr572925ejb.60.1685068526183; Thu, 25
 May 2023 19:35:26 -0700 (PDT)
MIME-Version: 1.0
References: <ZGeKm+jcBxzkMXQs@redhat.com>
 <ZGgBQhsbU9b0RiT1@dread.disaster.area>
 <ZGu0LaQfREvOQO4h@redhat.com> <ZGzIJlCE2pcqQRFJ@bfoster>
 <ZGzbGg35SqMrWfpr@redhat.com>
 <ZG1dAtHmbQ53aOhA@dread.disaster.area> <ZG5taYoXDRymo/e9@redhat.com>
 <ZG9JD+4Zu36lnm4F@dread.disaster.area> <ZG+GKwFC7M3FfAO5@redhat.com>
 <CAG9=OMNhCNFhTcktxSMYbc5WXkSZ-vVVPtb4ak6B3Z2-kEVX0Q@mail.gmail.com>
 <ZHANCbnHuhnwCrGz@dread.disaster.area>
In-Reply-To: <ZHANCbnHuhnwCrGz@dread.disaster.area>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Thu, 25 May 2023 19:35:14 -0700
Message-ID: <CAG9=OMPxHOzYcy8TQRnvNfNvPvvU=A1pceyL72JfyQwJSKNjQQ@mail.gmail.com>
To: Dave Chinner <david@fromorbit.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v7 0/5] Introduce provisioning primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, dm-devel@redhat.com,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Brian Foster <bfoster@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBNYXkgMjUsIDIwMjMgYXQgNjozNuKAr1BNIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJv
bW9yYml0LmNvbT4gd3JvdGU6Cj4KPiBPbiBUaHUsIE1heSAyNSwgMjAyMyBhdCAwMzo0NzoyMVBN
IC0wNzAwLCBTYXJ0aGFrIEt1a3JldGkgd3JvdGU6Cj4gPiBPbiBUaHUsIE1heSAyNSwgMjAyMyBh
dCA5OjAw4oCvQU0gTWlrZSBTbml0emVyIDxzbml0emVyQGtlcm5lbC5vcmc+IHdyb3RlOgo+ID4g
PiBPbiBUaHUsIE1heSAyNSAyMDIzIGF0ICA3OjM5UCAtMDQwMCwKPiA+ID4gRGF2ZSBDaGlubmVy
IDxkYXZpZEBmcm9tb3JiaXQuY29tPiB3cm90ZToKPiA+ID4gPiBPbiBXZWQsIE1heSAyNCwgMjAy
MyBhdCAwNDowMjo0OVBNIC0wNDAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6Cj4gPiA+ID4gPiBPbiBU
dWUsIE1heSAyMyAyMDIzIGF0ICA4OjQwUCAtMDQwMCwKPiA+ID4gPiA+IERhdmUgQ2hpbm5lciA8
ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3JvdGU6Cj4gPiA+ID4gPiA+IEl0J3Mgd29ydGggbm90aW5n
IHRoYXQgWEZTIGFscmVhZHkgaGFzIGEgY29hcnNlLWdyYWluZWQKPiA+ID4gPiA+ID4gaW1wbGVt
ZW50YXRpb24gb2YgcHJlZmVycmVkIHJlZ2lvbnMgZm9yIG1ldGFkYXRhIHN0b3JhZ2UuIEl0IHdp
bGwKPiA+ID4gPiA+ID4gY3VycmVudGx5IG5vdCB1c2UgdGhvc2UgbWV0YWRhdGEtcHJlZmVycmVk
IHJlZ2lvbnMgZm9yIHVzZXIgZGF0YQo+ID4gPiA+ID4gPiB1bmxlc3MgYWxsIHRoZSByZW1haW5p
bmcgdXNlciBkYXRhIHNwYWNlIGlzIGZ1bGwuICBIZW5jZSBJJ20gcHJldHR5Cj4gPiA+ID4gPiA+
IHN1cmUgdGhhdCBhIHByZS1wcm92aXNpb25pbmcgZW5oYW5jbWVudCBsaWtlIHRoaXMgY2FuIGJl
IGRvbmUKPiA+ID4gPiA+ID4gZW50aXJlbHkgaW4tbWVtb3J5IHdpdGhvdXQgcmVxdWlyaW5nIGFu
eSBuZXcgb24tZGlzayBzdGF0ZSB0byBiZQo+ID4gPiA+ID4gPiBhZGRlZC4KPiA+ID4gPiA+ID4K
PiA+ID4gPiA+ID4gU3VyZSwgaWYgd2UgY3Jhc2ggYW5kIHJlbW91bnQsIHRoZW4gd2UgbWlnaHQg
Y2hvc2UgYSBkaWZmZXJlbnQgTEJBCj4gPiA+ID4gPiA+IHJlZ2lvbiBmb3IgcHJlLXByb3Zpc2lv
bmluZy4gQnV0IHRoYXQncyBub3QgcmVhbGx5IGEgaHVnZSBkZWFsIGFzIHdlCj4gPiA+ID4gPiA+
IGNvdWxkIGFsc28gcnVuIGFuIGludGVybmFsIGJhY2tncm91bmQgcG9zdC1tb3VudCBmc3RyaW0g
b3BlcmF0aW9uIHRvCj4gPiA+ID4gPiA+IHJlbW92ZSBhbnkgdW51c2VkIHByZS1wcm92aXNpb25p
bmcgdGhhdCB3YXMgbGVmdCBvdmVyIGZyb20gd2hlbiB0aGUKPiA+ID4gPiA+ID4gc3lzdGVtIHdl
bnQgZG93bi4KPiA+ID4gPiA+Cj4gPiA+ID4gPiBUaGlzIHdvdWxkIGJlIHRoZSBGSVRSSU0gd2l0
aCBleHRlbnNpb24geW91IG1lbnRpb24gYmVsb3c/IFdoaWNoIGlzIGEKPiA+ID4gPiA+IGZpbGVz
eXN0ZW0gaW50ZXJmYWNlIGRldGFpbD8KPiA+ID4gPgo+ID4gPiA+IE5vLiBXZSBtaWdodCByZXVz
ZSBzb21lIG9mIHRoZSBpbnRlcm5hbCBpbmZyYXN0cnVjdHVyZSB3ZSB1c2UgdG8KPiA+ID4gPiBp
bXBsZW1lbnQgRklUUklNLCBidXQgdGhhdCdzIGFib3V0IGl0LiBJdCdzIGp1c3Qgc29tZXRoaW5n
IGtpbmRhCj4gPiA+ID4gbGlrZSBGSVRSSU0gYnV0IHdpdGggZGlmZmVyZW50IGNvbnN0cmFpbnRz
IGRldGVybWluZWQgYnkgdGhlCj4gPiA+ID4gZmlsZXN5c3RlbSByYXRoZXIgdGhhbiB0aGUgdXNl
ci4uLgo+ID4gPiA+Cj4gPiA+ID4gQXMgaXQgaXMsIEknbSBub3Qgc3VyZSB3ZSdkIGV2ZW4gbmVl
ZCBpdCAtIGEgcHJlaW9kaWMgdXNlcnNwYWNlCj4gPiA+ID4gRklUUklNIHdvdWxkIGFjaGVpdmUg
dGhlIHNhbWUgcmVzdWx0LCBzbyBsZWFrZWQgcHJvdmlzaW9uZWQgc3BhY2VzCj4gPiA+ID4gd291
bGQgZ2V0IGNsZWFuZWQgdXAgZXZlbnR1YWxseSB3aXRob3V0IHRoZSBmaWxlc3lzdGVtIGhhdmlu
ZyB0byBkbwo+ID4gPiA+IGFueXRoaW5nIHNwZWNpZmljLi4uCj4gPiA+ID4KPiA+ID4gPiA+IFNv
IGRtLXRoaW5wIHdvdWxkIF9ub3RfIG5lZWQgdG8gaGF2ZSBuZXcKPiA+ID4gPiA+IHN0YXRlIHRo
YXQgdHJhY2tzICJwcm92aXNpb25lZCBidXQgdW51c2VkIiBibG9jaz8KPiA+ID4gPgo+ID4gPiA+
IE5vIGlkZWEgLSB0aGF0J3MgeW91ciBkb21haW4uIDopCj4gPiA+ID4KPiA+ID4gPiBkbS1zbmFw
c2hvdCwgZm9yIGNlcnRhaW4sIHdpbGwgbmVlZCB0byB0cmFjayBwcm92aXNpb25lZCByZWdpb25z
Cj4gPiA+ID4gYmVjYXVzZSBpdCBoYXMgdG8gZ3VhcmFudGVlIHRoYXQgb3ZlcndyaXRlcyB0byBw
cm92aXNpb25lZCBzcGFjZSBpbgo+ID4gPiA+IHRoZSBvcmlnaW4gZGV2aWNlIHdpbGwgYWx3YXlz
IHN1Y2NlZWQuIEhlbmNlIGl0IG5lZWRzIHRvIGtub3cgaG93Cj4gPiA+ID4gbXVjaCBzcGFjZSBi
cmVha2luZyBzaGFyaW5nIGluIHByb3Zpc2lvbmVkIHJlZ2lvbnMgYWZ0ZXIgYSBzbmFwc2hvdAo+
ID4gPiA+IGhhcyBiZWVuIHRha2VuIHdpdGggYmUgcmVxdWlyZWQuLi4KPiA+ID4KPiA+ID4gZG0t
dGhpbnAgb2ZmZXJzIGl0cyBvd24gbXVjaCBtb3JlIHNjYWxhYmxlIHNuYXBzaG90IHN1cHBvcnQg
KGRvZXNuJ3QKPiA+ID4gdXNlIG9sZCBkbS1zbmFwc2hvdCBOLXdheSBjb3B5b3V0IHRhcmdldCku
Cj4gPiA+Cj4gPiA+IGRtLXNuYXBzaG90IGlzbid0IGdvaW5nIHRvIGJlIG1vZGlmaWVkIHRvIHN1
cHBvcnQgdGhpcyBsZXZlbCBvZgo+ID4gPiBoYXJkZW5pbmcgKGRtLXNuYXBzaG90IGlzIGJhc2lj
YWxseSBpbiAibWFpbnRlbmFuY2Ugb25seSIgbm93KS4KPgo+IEFoLCBvZiBjb3Vyc2UuIFNvcnJ5
IGZvciB0aGUgY29uZnVzaW9uLCBJIHdhcyBraW5kYSB1c2luZwo+IGRtLXNuYXBzaG90IGFzIHNo
b3J0aGFuZCBmb3IgImRtLXRoaW5wICsgc25hcHNob3RzIi4KPgo+ID4gPiBCdXQgSSB1bmRlcnN0
YW5kIHlvdXIgbWVhbmluZzogd2hhdCB5b3Ugc2FpZCBpcyAxMDAlIGFwcGxpY2FibGUgdG8KPiA+
ID4gZG0tdGhpbnAncyBzbmFwc2hvdCBpbXBsZW1lbnRhdGlvbiBhbmQgbmVlZHMgdG8gYmUgYWNj
b3VudGVkIGZvciBpbgo+ID4gPiB0aGlucCdzIG1ldGFkYXRhIChpbmhlcmVudCAncHJvdmlzaW9u
ZWQnIGZsYWcpLgo+Cj4gKm5vZCoKPgo+ID4gQSBiaXQgb3J0aG9nb25hbDogd291bGQgZG0tdGhp
bnAgbmVlZCB0byBkaWZmZXJlbnRpYXRlIGJldHdlZW4KPiA+IHVzZXItdHJpZ2dlcmVkIHByb3Zp
c2lvbiByZXF1ZXN0cyAoZWcuIGZyb20gZmFsbG9jYXRlKCkpIHZzCj4gPiBmcy10cmlnZ2VyZWQg
cmVxdWVzdHM/Cj4KPiBXaHk/ICBIb3cgaXMgdGhlIGd1YXJhbnRlZSB0aGUgYmxvY2sgZGV2aWNl
IGhhcyB0byBwcm92aWRlIHRvCj4gcHJvdmlzaW9uZWQgYXJlYXMgZGlmZmVyZW50IGZvciB1c2Vy
IHZzIGZpbGVzeXN0ZW0gaW50ZXJuYWwKPiBwcm92aXNpb25lZCBzcGFjZT8KPgpBZnRlciB0aGlu
a2luZyB0aGlzIHRocm91Z2gsIEkgc3RhbmQgY29ycmVjdGVkLiBJIHdhcyBwcmltYXJpbHkKY29u
Y2VybmVkIHdpdGggaG93IHRoaXMgd291bGQgYmFsbG9vbiB0aGluIHNuYXBzaG90IHNpemVzIGlm
IHVzZXJzCnBvdGVudGlhbGx5IHByb3Zpc2lvbiBhIGxhcmdlIGNodW5rIG9mIHRoZSBmaWxlc3lz
dGVtIGJ1dCB0aGF0J3MKcHV0dGluZyB0aGUgY2FydCB3YXkgYmVmb3JlIHRoZSBob3JzZS4KCkJl
c3QKU2FydGhhawoKPiA+IEkgd291bGQgbGVhbiB0b3dhcmRzIHVzZXIgcHJvdmlzaW9uZWQgYXJl
YXMgbm90Cj4gPiBnZXR0aW5nIGRlZHVwJ2Qgb24gc25hcHNob3QgY3JlYXRpb24sCj4KPiA8dHdp
dGNoPgo+Cj4gU25hcHNob3R0aW5nIGlzIGEgY2xvbmUgb3BlcmF0aW9uLCBub3QgYSBkZWR1cGUg
b3BlcmF0aW9uLgo+Cj4gWWVzLCB0aGUgZW5kIHJlc3VsdCBvZiBib3RoIGlzIHRoYXQgeW91IGhh
dmUgYSBibG9jayBzaGFyZWQgYmV0d2Vlbgo+IG11bHRpcGxlIGluZGV4ZXMgdGhhdCBuZWVkcyBD
T1cgb24gdGhlIG5leHQgb3ZlcndyaXRlLCBidXQgdGhlIHR3bwo+IG9wZXJhdGlvbnMgdGhhdCBn
ZXQgdG8gdGhhdCBwb2ludCBhcmUgdmVyeSBkaWZmZXJlbnQuLi4KPgo+IDwvcGVkYW50aWMgbW9k
ZSBkaXNlZ2FnZWQ+Cj4KPiA+IGJ1dCB0aGF0IHdvdWxkIGVudGFpbCB0cmFja2luZwo+ID4gdGhl
IHN0YXRlIG9mIHRoZSBvcmlnaW5hbCByZXF1ZXN0IGFuZCBwb3NzaWJseSBhIHByb3Zpc2lvbiBy
ZXF1ZXN0Cj4gPiBmbGFnIChSRVFfUFJPVklTSU9OX0RFRFVQX09OX1NOQVBTSE9UKSBvciBhbiBp
bnZlcnNlIGZsYWcKPiA+IChSRVFfUFJPVklTSU9OX05PREVEVVApLiBQb3NzaWJseSB0b28gY29u
dm9sdXRlZC4uLgo+Cj4gTGV0J3Mgbm90IHRyeSB0byBhZGQgZXZlcnlvbmUncyBmYXZvdXJpdGUg
cG9ueSB0byB0aGlzIGludGVyZmFjZQo+IGJlZm9yZSB3ZSd2ZSBldmVuIGdvdCBpdCBvZmYgdGhl
IGdyb3VuZC4KPgo+IEl0J3MgdGhlIHNpbXBsZSBwcmVjaXNpb24gb2YgdGhlIEFQSSwgdGhlIGxh
Y2sgb2YgY3Jvc3MtbGF5ZXIKPiBjb21tdW5pY2F0aW9uIHJlcXVpcmVtZW50cyBhbmQgdGhlIGFi
aWxpdHkgdG8gaW1wbGVtZW50IGFuZCBvcHRpbWlzZQo+IHRoZSBpbmRlcGVuZGVudCBsYXllcnMg
aW5kZXBlbmRlbnRseSB0aGF0IG1ha2VzIHRoaXMgYSB2ZXJ5Cj4gYXBwZWFsaW5nIHNvbHV0aW9u
Lgo+Cj4gV2UgbmVlZCB0byBzdGFydCB3aXRoIGdldHRpbmcgdGhlIHNpbXBsZSBzdHVmZiB3b3Jr
aW5nIGFuZCBwcm92ZSB0aGUKPiBjb25jZXB0LiBUaGVuIG9uY2Ugd2UgY2FuIG9ic2VydmUgdGhl
IGJlaGF2aW91ciBvZiBhIHdvcmtpbmcgc3lzdGVtCj4gd2UgY2FuIHN0YXJ0IHdvcmtpbmcgb24g
b3B0aW1pc2luZyBpbmRpdmlkdWFsIGxheWVycyBmb3IgZWZmaWNpZW5jeQo+IGFuZCBwZXJmb3Jt
YW5jZS4uLi4KPgo+IENoZWVycywKPgo+IERhdmUuCj4gLS0KPiBEYXZlIENoaW5uZXIKPiBkYXZp
ZEBmcm9tb3JiaXQuY29tCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
Cg==

