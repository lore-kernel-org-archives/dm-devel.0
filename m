Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D45CC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 14 Feb 2022 08:48:29 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-HvsfyBouMUSkqlL9INmNRQ-1; Mon, 14 Feb 2022 03:48:19 -0500
X-MC-Unique: HvsfyBouMUSkqlL9INmNRQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76766814243;
	Mon, 14 Feb 2022 08:48:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 58BA91F2EA;
	Mon, 14 Feb 2022 08:48:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 07D51180B617;
	Mon, 14 Feb 2022 08:48:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BFm3w9029544 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 10:48:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D84A8112131B; Fri, 11 Feb 2022 15:48:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D429D1120AB7
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 15:48:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA52A28EC10A
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 15:48:00 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-315-vHrDgmvYMYWSmZLeW8GgIQ-1; Fri, 11 Feb 2022 10:47:58 -0500
X-MC-Unique: vHrDgmvYMYWSmZLeW8GgIQ-1
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="336175145"
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; d="scan'208";a="336175145"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
	by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	11 Feb 2022 07:46:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; d="scan'208";a="542134195"
Received: from ankitata-mobl1.amr.corp.intel.com (HELO
	spandruv-desk1.amr.corp.intel.com) ([10.212.170.20])
	by orsmga008-auth.jf.intel.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 07:46:51 -0800
Message-ID: <077501bfcb710c66754c61d69e45cac66fccf38a.camel@linux.intel.com>
From: srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To: Qing Wang <wangqing@vivo.com>, Konrad Rzeszutek Wilk
	<konrad.wilk@oracle.com>, Roger Pau =?ISO-8859-1?Q?Monn=E9?=
	<roger.pau@citrix.com>, Jens Axboe <axboe@kernel.dk>, Michael Turquette
	<mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, Jani Nikula
	<jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@linux.ie>, 
	Daniel Vetter <daniel@ffwll.ch>, Alex Deucher <alexander.deucher@amd.com>,
	Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>, Dmitry Torokhov
	<dmitry.torokhov@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike
	Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Mauro Carvalho Chehab
	<mchehab@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, xen-devel@lists.xenproject.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Date: Fri, 11 Feb 2022 07:46:51 -0800
In-Reply-To: <1644546640-23283-6-git-send-email-wangqing@vivo.com>
References: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
	<1644546640-23283-6-git-send-email-wangqing@vivo.com>
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35)
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 14 Feb 2022 03:47:51 -0500
Subject: Re: [dm-devel] [PATCH V2 5/13] hid: use time_is_after_jiffies()
 instead of jiffies judgment
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCAyMDIyLTAyLTEwIGF0IDE4OjMwIC0wODAwLCBRaW5nIFdhbmcgd3JvdGU6Cj4gRnJv
bTogV2FuZyBRaW5nIDx3YW5ncWluZ0B2aXZvLmNvbT4KPiAKPiBJdCBpcyBiZXR0ZXIgdG8gdXNl
IHRpbWVfeHh4KCkgZGlyZWN0bHkgaW5zdGVhZCBvZiBqaWZmaWVzIGp1ZGdtZW50Cj4gZm9yIHVu
ZGVyc3RhbmRpbmcuCj4gCj4gU2lnbmVkLW9mZi1ieTogV2FuZyBRaW5nIDx3YW5ncWluZ0B2aXZv
LmNvbT4KQWNrZWQtYnk6IFNyaW5pdmFzIFBhbmRydXZhZGEgPHNyaW5pdmFzLnBhbmRydXZhZGFA
bGludXguaW50ZWwuY29tPgoKPiAtLS0KPiDCoGRyaXZlcnMvaGlkL2ludGVsLWlzaC1oaWQvaXBj
L2lwYy5jIHwgMiArLQo+IMKgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0
aW9uKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaGlkL2ludGVsLWlzaC1oaWQvaXBjL2lw
Yy5jIGIvZHJpdmVycy9oaWQvaW50ZWwtCj4gaXNoLWhpZC9pcGMvaXBjLmMKPiBpbmRleCA4Y2Ni
MjQ2Li4xNWUxNDIzCj4gLS0tIGEvZHJpdmVycy9oaWQvaW50ZWwtaXNoLWhpZC9pcGMvaXBjLmMK
PiArKysgYi9kcml2ZXJzL2hpZC9pbnRlbC1pc2gtaGlkL2lwYy9pcGMuYwo+IEBAIC01NzgsNyAr
NTc4LDcgQEAgc3RhdGljIHZvaWQgX2lzaF9zeW5jX2Z3X2Nsb2NrKHN0cnVjdAo+IGlzaHRwX2Rl
dmljZSAqZGV2KQo+IMKgwqDCoMKgwqDCoMKgwqBzdGF0aWMgdW5zaWduZWQgbG9uZ8KgwqDCoMKg
cHJldl9zeW5jOwo+IMKgwqDCoMKgwqDCoMKgwqB1aW50NjRfdMKgwqDCoMKgwqDCoMKgwqB1c2Vj
Owo+IMKgCj4gLcKgwqDCoMKgwqDCoMKgaWYgKHByZXZfc3luYyAmJiBqaWZmaWVzIC0gcHJldl9z
eW5jIDwgMjAgKiBIWikKPiArwqDCoMKgwqDCoMKgwqBpZiAocHJldl9zeW5jICYmIHRpbWVfaXNf
YWZ0ZXJfamlmZmllcyhwcmV2X3N5bmMgKyAyMCAqIEhaKSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoHJldHVybjsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqBwcmV2X3N5bmMgPSBq
aWZmaWVzOwoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0
cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

