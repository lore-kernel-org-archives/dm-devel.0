Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75525C6FD18
	for <dm-devel@archiver.kernel.org>; Fri, 31 Mar 2023 05:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680240170;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rTwTAa1SwgbL08P1mbm0bUi7QUZpqYK5FJUKRxtHy1E=;
	b=F+3bYmdd9GIFpGIuHfkFlTuUSiER/4P29lmI4d+04Gz386LkQq/Hey0E52rEEkOYs2qcqf
	pFu01mKzoDS6mCetbMThBClC9ZRdCq9QIPzlNveOtxLTcKt9qk6SyRAAXlKFokA/7phJjY
	D9RhXyMzgrFCoBmFOhwCj9/wKVj0ha8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-GX140FdTMmukhvtKTvzYww-1; Fri, 31 Mar 2023 01:22:48 -0400
X-MC-Unique: GX140FdTMmukhvtKTvzYww-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B56B9185A7B3;
	Fri, 31 Mar 2023 05:22:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1DBCD1121315;
	Fri, 31 Mar 2023 05:22:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A698C194658F;
	Fri, 31 Mar 2023 05:22:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 875C41946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 30 Mar 2023 15:22:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0336D4020C84; Thu, 30 Mar 2023 15:22:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF8B14020C82
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 15:22:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2D511012BA0
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 15:22:07 +0000 (UTC)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com
 [209.85.219.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-DL2RIwqOMXmA1nSiBCL-4w-1; Thu, 30 Mar 2023 11:22:05 -0400
X-MC-Unique: DL2RIwqOMXmA1nSiBCL-4w-1
Received: by mail-yb1-f172.google.com with SMTP id k17so23906548ybm.11;
 Thu, 30 Mar 2023 08:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1680189724;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=WNUGs7yKfBFC1B8PDt10II7FMSSlTydS7EGiHNu1RbU=;
 b=yxP0IujQG2VWjw15XLbV43CLvh2WhV4IgMAZsaqBDiDS7vCwXFIAfeu/teMxzrsd+M
 EoSF7FWdr8W1Hv/vsbOOieozX9y/radnJJ0lt5U1JkHfbbQbIWE1DZX1CS7xvxvDvJeI
 8ckUjz1iXwxlpJ8VZyt7EGwNMDnFG8Z92aKrxsGeevRmuFcBs65UzhSToL2Ll9qRIpJY
 b2ojo0dzkt9anRHT7Rtp0AzHajpIDAsZkacgFhUVFi4TeXLERM0QLaODOof2rROqkwkj
 bUu26fA6DwBG64jIRSqNqx39qE4cgNBMEAs3KRSJYUpKbUAGJu/KQOqb+X5gwY4hqmie
 sxRQ==
X-Gm-Message-State: AAQBX9fL0w7rMPzHa5+Lnyp2vnw7o2aV19yoIavI02271R0aYzOE99zY
 a2f7DBqIomD1DKmLrgZ7bcMPA/M3p7AJcBHuGIw=
X-Google-Smtp-Source: AKy350af9dirrryOJXb1UWHeQHVFQI5GJBkJybiFkxBW+xnISF2ErTcLRbUGhDBcOsgKxifwL+Bv9k0Jd11YNeK0OFM=
X-Received: by 2002:a05:6902:1004:b0:b75:968e:f282 with SMTP id
 w4-20020a056902100400b00b75968ef282mr15539300ybt.11.1680189724556; Thu, 30
 Mar 2023 08:22:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230327084103.21601-1-anuj20.g@samsung.com>
 <CGME20230327084244epcas5p1b0ede867e558ff6faf258de3656a8aa4@epcas5p1.samsung.com>
 <20230327084103.21601-5-anuj20.g@samsung.com>
 <20230329-glitter-drainpipe-bdf9d3876ac4@brauner>
 <20230329124236.GB3895@green5> <20230330-strode-deforest-b65424417062@brauner>
In-Reply-To: <20230330-strode-deforest-b65424417062@brauner>
From: Nitesh Shetty <nitheshshetty@gmail.com>
Date: Thu, 30 Mar 2023 20:51:53 +0530
Message-ID: <CAOSviJ2T=MdYbGtd9CBx8bCZh9in3MpzfOywxSVEFQEpi6dAgA@mail.gmail.com>
To: Christian Brauner <brauner@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Fri, 31 Mar 2023 05:22:41 +0000
Subject: Re: [dm-devel] [PATCH v8 4/9] fs,
 block: copy_file_range for def_blk_ops for direct block device.
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
Cc: linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, gost.dev@samsung.com,
 damien.lemoal@opensource.wdc.com, James Smart <james.smart@broadcom.com>,
 Nitesh Shetty <nj.shetty@samsung.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Mike Snitzer <snitzer@kernel.org>,
 ming.lei@redhat.com, linux-block@vger.kernel.org,
 Keith Busch <kbusch@kernel.org>, bvanassche@acm.org,
 Jens Axboe <axboe@kernel.dk>, joshi.k@samsung.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBNYXIgMzAsIDIwMjMgYXQgMTE6MTjigK9BTSBDaHJpc3RpYW4gQnJhdW5lciA8YnJh
dW5lckBrZXJuZWwub3JnPiB3cm90ZToKPgo+IE9uIFdlZCwgTWFyIDI5LCAyMDIzIGF0IDA2OjEy
OjM2UE0gKzA1MzAsIE5pdGVzaCBTaGV0dHkgd3JvdGU6Cj4gPiBPbiBXZWQsIE1hciAyOSwgMjAy
MyBhdCAwMjoxNDo0MFBNICswMjAwLCBDaHJpc3RpYW4gQnJhdW5lciB3cm90ZToKPiA+ID4gT24g
TW9uLCBNYXIgMjcsIDIwMjMgYXQgMDI6MTA6NTJQTSArMDUzMCwgQW51aiBHdXB0YSB3cm90ZToK
PiA+ID4gPiBGcm9tOiBOaXRlc2ggU2hldHR5IDxuai5zaGV0dHlAc2Ftc3VuZy5jb20+Cj4gPiA+
ID4KPiA+ID4gPiBGb3IgZGlyZWN0IGJsb2NrIGRldmljZSBvcGVuZWQgd2l0aCBPX0RJUkVDVCwg
dXNlIGNvcHlfZmlsZV9yYW5nZSB0bwo+ID4gPiA+IGlzc3VlIGRldmljZSBjb3B5IG9mZmxvYWQs
IGFuZCBmYWxsYmFjayB0byBnZW5lcmljX2NvcHlfZmlsZV9yYW5nZSBpbmNhc2UKPiA+ID4gPiBk
ZXZpY2UgY29weSBvZmZsb2FkIGNhcGFiaWxpdHkgaXMgYWJzZW50Lgo+ID4gPiA+IE1vZGlmeSBj
aGVja3MgdG8gYWxsb3cgYmRldnMgdG8gdXNlIGNvcHlfZmlsZV9yYW5nZS4KPiA+ID4gPgo+ID4g
PiA+IFN1Z2dlc3RlZC1ieTogTWluZyBMZWkgPG1pbmcubGVpQHJlZGhhdC5jb20+Cj4gPiA+ID4g
U2lnbmVkLW9mZi1ieTogQW51aiBHdXB0YSA8YW51ajIwLmdAc2Ftc3VuZy5jb20+Cj4gPiA+ID4g
U2lnbmVkLW9mZi1ieTogTml0ZXNoIFNoZXR0eSA8bmouc2hldHR5QHNhbXN1bmcuY29tPgo+ID4g
PiA+IC0tLQo+ID4gPiA+ICBibG9jay9ibGstbGliLmMgICAgICAgIHwgMjIgKysrKysrKysrKysr
KysrKysrKysrKwo+ID4gPiA+ICBibG9jay9mb3BzLmMgICAgICAgICAgIHwgMjAgKysrKysrKysr
KysrKysrKysrKysKPiA+ID4gPiAgZnMvcmVhZF93cml0ZS5jICAgICAgICB8IDExICsrKysrKysr
Ky0tCj4gPiA+ID4gIGluY2x1ZGUvbGludXgvYmxrZGV2LmggfCAgMyArKysKPiA+ID4gPiAgNCBm
aWxlcyBjaGFuZ2VkLCA1NCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+ID4gPiA+Cj4g
PiA+ID4gZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1saWIuYyBiL2Jsb2NrL2Jsay1saWIuYwo+ID4g
PiA+IGluZGV4IGEyMTgxOWU1OWIyOS4uYzI4ODU3M2M3ZTc3IDEwMDY0NAo+ID4gPiA+IC0tLSBh
L2Jsb2NrL2Jsay1saWIuYwo+ID4gPiA+ICsrKyBiL2Jsb2NrL2Jsay1saWIuYwo+ID4gPiA+IEBA
IC00NzUsNiArNDc1LDI4IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBibGtfY2hlY2tfY29weV9vZmZs
b2FkKHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxX2luLAo+ID4gPiA+ICAgcmV0dXJuIGJsa19xdWV1
ZV9jb3B5KHFfaW4pICYmIGJsa19xdWV1ZV9jb3B5KHFfb3V0KTsKPiA+ID4gPiAgfQo+ID4gPiA+
Cj4gPiA+ID4gK2ludCBibGtkZXZfY29weV9vZmZsb2FkKHN0cnVjdCBibG9ja19kZXZpY2UgKmJk
ZXZfaW4sIGxvZmZfdCBwb3NfaW4sCj4gPiA+ID4gKyAgICAgICAgICAgICAgIHN0cnVjdCBibG9j
a19kZXZpY2UgKmJkZXZfb3V0LCBsb2ZmX3QgcG9zX291dCwgc2l6ZV90IGxlbiwKPiA+ID4gPiAr
ICAgICAgICAgICAgICAgY2lvX2lvZG9uZV90IGVuZF9pbywgdm9pZCAqcHJpdmF0ZSwgZ2ZwX3Qg
Z2ZwX21hc2spCj4gPiA+ID4gK3sKPiA+ID4gPiArIHN0cnVjdCByZXF1ZXN0X3F1ZXVlICppbl9x
ID0gYmRldl9nZXRfcXVldWUoYmRldl9pbik7Cj4gPiA+ID4gKyBzdHJ1Y3QgcmVxdWVzdF9xdWV1
ZSAqb3V0X3EgPSBiZGV2X2dldF9xdWV1ZShiZGV2X291dCk7Cj4gPiA+ID4gKyBpbnQgcmV0ID0g
LUVJTlZBTDsKPiA+ID4KPiA+ID4gV2h5IGluaXRpYWxpemUgdG8gLUVJTlZBTCBpZiBibGtfY29w
eV9zYW5pdHlfY2hlY2soKSBpbml0aWFsaXplcyBpdAo+ID4gPiByaWdodCBhd2F5IGFueXdheT8K
PiA+ID4KPiA+Cj4gPiBhY2tlZC4KPiA+Cj4gPiA+ID4gKyBib29sIG9mZmxvYWQgPSBmYWxzZTsK
PiA+ID4KPiA+ID4gU2FtZSB0aGluZyB3aXRoIGluaXRpYWxpemluZyBvZmZsb2FkLgo+ID4gPgo+
ID4gYWNrZWQKPiA+Cj4gPiA+ID4gKwo+ID4gPiA+ICsgcmV0ID0gYmxrX2NvcHlfc2FuaXR5X2No
ZWNrKGJkZXZfaW4sIHBvc19pbiwgYmRldl9vdXQsIHBvc19vdXQsIGxlbik7Cj4gPiA+ID4gKyBp
ZiAocmV0KQo+ID4gPiA+ICsgICAgICAgICByZXR1cm4gcmV0Owo+ID4gPiA+ICsKPiA+ID4gPiAr
IG9mZmxvYWQgPSBibGtfY2hlY2tfY29weV9vZmZsb2FkKGluX3EsIG91dF9xKTsKPiA+ID4gPiAr
IGlmIChvZmZsb2FkKQo+ID4gPiA+ICsgICAgICAgICByZXQgPSBfX2Jsa19jb3B5X29mZmxvYWQo
YmRldl9pbiwgcG9zX2luLCBiZGV2X291dCwgcG9zX291dCwKPiA+ID4gPiArICAgICAgICAgICAg
ICAgICAgICAgICAgIGxlbiwgZW5kX2lvLCBwcml2YXRlLCBnZnBfbWFzayk7Cj4gPiA+ID4gKwo+
ID4gPiA+ICsgcmV0dXJuIHJldDsKPiA+ID4gPiArfQo+ID4gPiA+ICtFWFBPUlRfU1lNQk9MX0dQ
TChibGtkZXZfY29weV9vZmZsb2FkKTsKPiA+ID4gPiArCj4gPiA+ID4gIC8qCj4gPiA+ID4gICAq
IEBiZGV2X2luOiAgICAgc291cmNlIGJsb2NrIGRldmljZQo+ID4gPiA+ICAgKiBAcG9zX2luOiAg
ICAgIHNvdXJjZSBvZmZzZXQKPiA+ID4gPiBkaWZmIC0tZ2l0IGEvYmxvY2svZm9wcy5jIGIvYmxv
Y2svZm9wcy5jCj4gPiA+ID4gaW5kZXggZDJlNmJlNGUzZDFjLi4zYjdjMDU4MzFkNWMgMTAwNjQ0
Cj4gPiA+ID4gLS0tIGEvYmxvY2svZm9wcy5jCj4gPiA+ID4gKysrIGIvYmxvY2svZm9wcy5jCj4g
PiA+ID4gQEAgLTYxMSw2ICs2MTEsMjUgQEAgc3RhdGljIHNzaXplX3QgYmxrZGV2X3JlYWRfaXRl
cihzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBpb3ZfaXRlciAqdG8pCj4gPiA+ID4gICByZXR1
cm4gcmV0Owo+ID4gPiA+ICB9Cj4gPiA+ID4KPiA+ID4gPiArc3RhdGljIHNzaXplX3QgYmxrZGV2
X2NvcHlfZmlsZV9yYW5nZShzdHJ1Y3QgZmlsZSAqZmlsZV9pbiwgbG9mZl90IHBvc19pbiwKPiA+
ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBmaWxlICpmaWxlX291dCwgbG9m
Zl90IHBvc19vdXQsCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICBzaXplX3QgbGVu
LCB1bnNpZ25lZCBpbnQgZmxhZ3MpCj4gPiA+ID4gK3sKPiA+ID4gPiArIHN0cnVjdCBibG9ja19k
ZXZpY2UgKmluX2JkZXYgPSBJX0JERVYoYmRldl9maWxlX2lub2RlKGZpbGVfaW4pKTsKPiA+ID4g
PiArIHN0cnVjdCBibG9ja19kZXZpY2UgKm91dF9iZGV2ID0gSV9CREVWKGJkZXZfZmlsZV9pbm9k
ZShmaWxlX291dCkpOwo+ID4gPiA+ICsgaW50IGNvbXBfbGVuID0gMDsKPiA+ID4gPiArCj4gPiA+
ID4gKyBpZiAoKGZpbGVfaW4tPmZfaW9jYl9mbGFncyAmIElPQ0JfRElSRUNUKSAmJgo+ID4gPiA+
ICsgICAgICAgICAoZmlsZV9vdXQtPmZfaW9jYl9mbGFncyAmIElPQ0JfRElSRUNUKSkKPiA+ID4g
PiArICAgICAgICAgY29tcF9sZW4gPSBibGtkZXZfY29weV9vZmZsb2FkKGluX2JkZXYsIHBvc19p
biwgb3V0X2JkZXYsCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgcG9zX291dCwg
bGVuLCBOVUxMLCBOVUxMLCBHRlBfS0VSTkVMKTsKPiA+ID4gPiArIGlmIChjb21wX2xlbiAhPSBs
ZW4pCj4gPiA+ID4gKyAgICAgICAgIGNvbXBfbGVuID0gZ2VuZXJpY19jb3B5X2ZpbGVfcmFuZ2Uo
ZmlsZV9pbiwgcG9zX2luICsgY29tcF9sZW4sCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgZmls
ZV9vdXQsIHBvc19vdXQgKyBjb21wX2xlbiwgbGVuIC0gY29tcF9sZW4sIGZsYWdzKTsKPiA+ID4K
PiA+ID4gSSdtIG5vdCBkZWVwbHkgZmFtaWxpYXIgd2l0aCB0aGlzIGNvZGUgYnV0IHRoaXMgbG9v
a3Mgb2RkLiBJdCBhdCBsZWFzdAo+ID4gPiBzZWVtcyBwb3NzaWJsZSB0aGF0IGNvbXBfbGVuIGNv
dWxkIGJlIC1FSU5WQUwgYW5kIGxlbiAyMCBhdCB3aGljaCBwb2ludAo+ID4gPiB5b3UnZCBiZSBk
b2luZyBsZW4gLSBjb21wX2xlbiBha2EgMjAgLSAyMiA9IC0yIGluIGdlbmVyaWNfY29weV9maWxl
X3JhbmdlKCkuCj4KPiAyMCAtIC0yMiA9IDQ0IG9mYwo+Cj4gPgo+ID4gY29tcF9sZW4gc2hvdWxk
IGJlIDAgaW5jYXNlIG9mIGVycm9yLiBXZSBkbyBhZ3JlZSwgc29tZSBmdW5jdGlvbgo+Cj4gSSBt
ZWFuLCBub3QgdG8gaGFtbWVyIG9uIHRoaXMgcG9pbnQgdG9vIG11Y2ggYnV0IGp1c3QgdG8gYmUg
Y2xlYXIKPiBibGtfY29weV9zYW5pdHlfY2hlY2soKSwgd2hpY2ggaXMgaW50cm9kdWNlZCBpbiB0
aGUgc2Vjb25kIHBhdGNoLCBjYW4KPiByZXR1cm4gYm90aCAtRVBFUk0gYW5kIC1FSU5WQUwgYW5k
IGlzIGZpcnN0IGNhbGxlZCBpbgo+IGJsa2Rldl9jb3B5X29mZmxvYWQoKSBzbyBpdCdzIGRlZmlu
aXRlbHkgcG9zc2libGUgZm9yIGNvbXBfbGVuIHRvIGJlCj4gbmVnYXRpdmUuCgpBY2tlZC4gV2ls
bCBiZSB1cGRhdGVkIGluIHRoZSBuZXh0IHZlcnNpb24uCgpUaGFuayB5b3UsCk5pdGVzaCBTaGV0
dHkKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

