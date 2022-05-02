Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F095C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  2 May 2022 12:55:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-YfLlt_e_OWKEzhrWVqnHgw-1; Mon, 02 May 2022 08:55:08 -0400
X-MC-Unique: YfLlt_e_OWKEzhrWVqnHgw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13AFB83396D;
	Mon,  2 May 2022 12:55:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2357141636D;
	Mon,  2 May 2022 12:55:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D2753194705F;
	Mon,  2 May 2022 12:55:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1E209194705F
 for <dm-devel@listman.corp.redhat.com>; Mon,  2 May 2022 12:55:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EEC881121339; Mon,  2 May 2022 12:55:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E9D1C111CB81
 for <dm-devel@redhat.com>; Mon,  2 May 2022 12:55:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C7DF811E80
 for <dm-devel@redhat.com>; Mon,  2 May 2022 12:55:01 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-107-yWrSItCJM7S2Wjtp2kv2_Q-1; Mon, 02 May 2022 08:55:00 -0400
X-MC-Unique: yWrSItCJM7S2Wjtp2kv2_Q-1
X-IronPort-AV: E=Sophos;i="5.91,192,1647273600"; d="scan'208";a="311307272"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 02 May 2022 20:54:58 +0800
IronPort-SDR: KGw9tuP2XbTHWhGyCDvoMK0cswBqYbIBDy1y0iUx4Xo5Nq2SyGBxq2ISy4m0yahwNXWGnsgdPw
 ppWy0NYEzgFVa0ng85UinN3636NhUvvZl/Uv8WEQ/MIk0s5udQfgh7IzMu31fxeIUw/7rrOIkC
 hmuKxGJGiuf4+QHJZ4y3vZeKT9b139i3RPWwwkKhhCpTmxtviMVWKHsOmkW7FXW7UMY1/MLkx/
 RFA21EQOubm2/UpLEU3ZsXfegC9NDnGcZxTaGhaGsnvX4B0oxgqgsl6M6MI9ES6mYFem3wF8u/
 9JrmEZwk67UsmEx6F5ZJOqwT
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 02 May 2022 05:25:44 -0700
IronPort-SDR: yMjJettRbffxAcP7A9aFv3f923kn+1nlK/EElOlzKe+Ngj4uWcpfX+U0idGBcQ9sD4d1LMzRny
 BXzFOOdqKROuIZUvWjnwjkrx0fmuStlpGt+tyfyE+SZFcS7EAB7GqHK9QkWQv9W1RWBPJzCafH
 /2sMv9azA0hVbcU3kEdmvRxqBwPJglvO3dBcKI2wTAtX+AFYC24RPlshwvunr8TTB5MqjXv89N
 imAUxO7Z5QELGMUP4qVWbKm1/11cuiNsrApC0jycMBYfC/oSrmIUvP0MHdrm2ISfydYWF1eP/h
 MUA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 02 May 2022 05:54:59 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KsNNL1Lfbz1SVnx
 for <dm-devel@redhat.com>; Mon,  2 May 2022 05:54:58 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id bKndW2usBH8N for <dm-devel@redhat.com>;
 Mon,  2 May 2022 05:54:57 -0700 (PDT)
Received: from [10.225.81.200] (hq6rw33.ad.shared [10.225.81.200])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KsNNJ5Mpmz1Rvlc;
 Mon,  2 May 2022 05:54:56 -0700 (PDT)
Message-ID: <46e95412-9a79-51f8-3d52-caed4875d41f@opensource.wdc.com>
Date: Mon, 2 May 2022 21:54:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
To: Dave Chinner <david@fromorbit.com>, Nitesh Shetty <nj.shetty@samsung.com>
References: <CGME20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15@epcas5p4.samsung.com>
 <20220426101241.30100-1-nj.shetty@samsung.com>
 <6a85e8c8-d9d1-f192-f10d-09052703c99a@opensource.wdc.com>
 <20220427124951.GA9558@test-zns>
 <20220502040951.GC1360180@dread.disaster.area>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220502040951.GC1360180@dread.disaster.area>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v4 00/10] Add Copy offload support
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
Cc: linux-scsi@vger.kernel.org, nitheshshetty@gmail.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMjAyMi8wNS8wMiAxMzowOSwgRGF2ZSBDaGlubmVyIHdyb3RlOgo+IE9uIFdlZCwgQXByIDI3
LCAyMDIyIGF0IDA2OjE5OjUxUE0gKzA1MzAsIE5pdGVzaCBTaGV0dHkgd3JvdGU6Cj4+IE8gV2Vk
LCBBcHIgMjcsIDIwMjIgYXQgMTE6MTk6NDhBTSArMDkwMCwgRGFtaWVuIExlIE1vYWwgd3JvdGU6
Cj4+PiBPbiA0LzI2LzIyIDE5OjEyLCBOaXRlc2ggU2hldHR5IHdyb3RlOgo+Pj4+IFRoZSBwYXRj
aCBzZXJpZXMgY292ZXJzIHRoZSBwb2ludHMgZGlzY3Vzc2VkIGluIE5vdmVtYmVyIDIwMjEgdmly
dHVhbCBjYWxsCj4+Pj4gW0xTRi9NTS9CRlAgVE9QSUNdIFN0b3JhZ2U6IENvcHkgT2ZmbG9hZFsw
XS4KPj4+PiBXZSBoYXZlIGNvdmVyZWQgdGhlIEluaXRpYWwgYWdyZWVkIHJlcXVpcmVtZW50cyBp
biB0aGlzIHBhdGNoc2V0Lgo+Pj4+IFBhdGNoc2V0IGJvcnJvd3MgTWlrdWxhcydzIHRva2VuIGJh
c2VkIGFwcHJvYWNoIGZvciAyIGJkZXYKPj4+PiBpbXBsZW1lbnRhdGlvbi4KPj4+Pgo+Pj4+IE92
ZXJhbGwgc2VyaWVzIHN1cHBvcnRzIOKAkwo+Pj4+Cj4+Pj4gMS4gRHJpdmVyCj4+Pj4gLSBOVk1l
IENvcHkgY29tbWFuZCAoc2luZ2xlIE5TKSwgaW5jbHVkaW5nIHN1cHBvcnQgaW4gbnZtZS10YXJn
ZXQgKGZvcgo+Pj4+ICAgICBibG9jayBhbmQgZmlsZSBiYWNrZW5kKQo+Pj4KPj4+IEl0IHdvdWxk
IGFsc28gYmUgbmljZSB0byBoYXZlIGNvcHkgb2ZmbG9hZCBlbXVsYXRpb24gaW4gbnVsbF9ibGsg
Zm9yIHRlc3RpbmcuCj4+Pgo+Pgo+PiBXZSBjYW4gcGxhbiB0aGlzIGluIG5leHQgcGhhc2Ugb2Yg
Y29weSBzdXBwb3J0LCBvbmNlIHRoaXMgc2VyaWVzIHNldHRsZXMgZG93bi4KPiAKPiBXaHkgbm90
IGp1c3QgaG9vayB0aGUgbG9vcGJhY2sgZHJpdmVyIHVwIHRvIGNvcHlfZmlsZV9yYW5nZSgpIHNv
Cj4gdGhhdCB0aGUgYmFja2VuZCBmaWxlc3lzdGVtIGNhbiBqdXN0IHJlZmxpbmsgY29weSB0aGUg
cmFuZ2VzIGJlaW5nCj4gcGFzc2VkPyBUaGF0IHdvdWxkIGVuYWJsZSB0ZXN0aW5nIG9uIGJ0cmZz
LCBYRlMgYW5kIE5GU3Y0LjIgaG9zdGVkCj4gaW1hZ2UgZmlsZXMgd2l0aG91dCBuZWVkaW5nIGFu
eSBzcGVjaWFsIGJsb2NrIGRldmljZSBzZXR1cCBhdCBhbGwuLi4KClRoYXQgaXMgYSB2ZXJ5IGdv
b2QgaWRlYSAhIEJ1dCB0aGF0IHdpbGwgY292ZXIgb25seSB0aGUgbm9uLXpvbmVkIGNhc2UuIEZv
ciBjb3B5Cm9mZmxvYWQgb24gem9uZWQgZGV2aWNlcywgYWRkaW5nIHN1cHBvcnQgaW4gbnVsbF9i
bGsgaXMgcHJvYmFibHkgdGhlIHNpbXBsZXN0CnRoaW5nIHRvIGRvLgoKPiAKPiBpLmUuIEkgdGhp
bmsgeW91J3JlIGRvaW5nIHRoaXMgY29tcGVsdGVseSBiYWNrd2FyZHMgYnkgdHJ5aW5nIHRvCj4g
dGFyZ2V0IG5vbi1leGlzdGVudCBoYXJkd2FyZSBmaXJzdC4uLi4KPiAKPiBDaGVlcnMsCj4gCj4g
RGF2ZS4KCgotLSAKRGFtaWVuIExlIE1vYWwKV2VzdGVybiBEaWdpdGFsIFJlc2VhcmNoCgotLQpk
bS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4u
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

