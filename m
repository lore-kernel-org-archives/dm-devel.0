Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29933C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  2 May 2022 12:14:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-bkLB4ntLME2aIaHrAQxgnA-1; Mon, 02 May 2022 08:14:44 -0400
X-MC-Unique: bkLB4ntLME2aIaHrAQxgnA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4551A38337EE;
	Mon,  2 May 2022 12:14:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9E2D22166B41;
	Mon,  2 May 2022 12:14:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 76B49194705F;
	Mon,  2 May 2022 12:14:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EF109194705E
 for <dm-devel@listman.corp.redhat.com>; Mon,  2 May 2022 12:14:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DB2FD41636A; Mon,  2 May 2022 12:14:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D69C3416171
 for <dm-devel@redhat.com>; Mon,  2 May 2022 12:14:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9B1880A0AD
 for <dm-devel@redhat.com>; Mon,  2 May 2022 12:14:40 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-ZxSXkxGnNNuNyJ9CjKKWWw-1; Mon, 02 May 2022 08:14:38 -0400
X-MC-Unique: ZxSXkxGnNNuNyJ9CjKKWWw-1
X-IronPort-AV: E=Sophos;i="5.91,190,1647273600"; d="scan'208";a="311305091"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 02 May 2022 20:14:37 +0800
IronPort-SDR: 12ScxgI3B5kV7DJRW3P3YwkNLHvtsupGdP3w9ymRRztSY3VNPwACq7TviOzirkxK5hlI9ib1Ul
 1jPjqzRiRkFDhtx30du1SS9syKqnsWSGmadFxKgEQkAbQ9D6n0/JpNICwAEPCVxDuFpkMmMYIh
 aJr0daEs45Mqp7WyjXtlV+QIKVKXaUSIjjGVefIqyx3lizkaYKi5mFbvG5uHz9MtTenHxl+7yr
 azKWf2JBYLViyjibQjNb87QqrTnn4guzrt7OZOWd5BKBWROmt+nUzp1xHL3O5CAAKbAHa4yRwg
 ef1dNYJZDna+RdBjW6FqYmEp
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 02 May 2022 04:44:40 -0700
IronPort-SDR: il4vzrCL8E6+uf3L7yn6tqM8zzw5vKIxKJbjOg2JoG/mH7kW6nYnRqPYhZooZhAVtwTazzVgb2
 VRDDo9/0jvFiiYM+ULpOZ5fWL0H/n/vKTGG8qxCmUwOe1Ov80f7fdvGks1CrypNaE46qO7Xs5z
 7iXlPiovppPo2zCOaZlmVvBLx6VFnaRjhaJ0PEc5F2RNooOaNE6/FXHqBTiXBF2n4b2wVP2xYc
 +9w5/TcOJNyP31x9G+2Z6BXnVoQPg6gqODnxvw4VzAmfpMaoMMzaHCcnRGhH6+Vdxifrfb8Aou
 bTc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 02 May 2022 05:14:38 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KsMTm5XPKz1SHwl
 for <dm-devel@redhat.com>; Mon,  2 May 2022 05:14:36 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id TLZPIEJaI87O for <dm-devel@redhat.com>;
 Mon,  2 May 2022 05:14:36 -0700 (PDT)
Received: from [10.225.81.200] (hq6rw33.ad.shared [10.225.81.200])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KsMTl4knDz1Rvlc;
 Mon,  2 May 2022 05:14:35 -0700 (PDT)
Message-ID: <260b95e8-74bf-9460-cf0d-7e3df1b1a3c7@opensource.wdc.com>
Date: Mon, 2 May 2022 21:14:34 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <CGME20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15@epcas5p4.samsung.com>
 <20220426101241.30100-1-nj.shetty@samsung.com>
 <6a85e8c8-d9d1-f192-f10d-09052703c99a@opensource.wdc.com>
 <20220427124951.GA9558@test-zns>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220427124951.GA9558@test-zns>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMjAyMi8wNC8yNyAyMTo0OSwgTml0ZXNoIFNoZXR0eSB3cm90ZToKPiBPIFdlZCwgQXByIDI3
LCAyMDIyIGF0IDExOjE5OjQ4QU0gKzA5MDAsIERhbWllbiBMZSBNb2FsIHdyb3RlOgo+PiBPbiA0
LzI2LzIyIDE5OjEyLCBOaXRlc2ggU2hldHR5IHdyb3RlOgo+Pj4gVGhlIHBhdGNoIHNlcmllcyBj
b3ZlcnMgdGhlIHBvaW50cyBkaXNjdXNzZWQgaW4gTm92ZW1iZXIgMjAyMSB2aXJ0dWFsIGNhbGwK
Pj4+IFtMU0YvTU0vQkZQIFRPUElDXSBTdG9yYWdlOiBDb3B5IE9mZmxvYWRbMF0uCj4+PiBXZSBo
YXZlIGNvdmVyZWQgdGhlIEluaXRpYWwgYWdyZWVkIHJlcXVpcmVtZW50cyBpbiB0aGlzIHBhdGNo
c2V0Lgo+Pj4gUGF0Y2hzZXQgYm9ycm93cyBNaWt1bGFzJ3MgdG9rZW4gYmFzZWQgYXBwcm9hY2gg
Zm9yIDIgYmRldgo+Pj4gaW1wbGVtZW50YXRpb24uCj4+Pgo+Pj4gT3ZlcmFsbCBzZXJpZXMgc3Vw
cG9ydHMg4oCTCj4+Pgo+Pj4gMS4gRHJpdmVyCj4+PiAtIE5WTWUgQ29weSBjb21tYW5kIChzaW5n
bGUgTlMpLCBpbmNsdWRpbmcgc3VwcG9ydCBpbiBudm1lLXRhcmdldCAoZm9yCj4+PiAgICAgYmxv
Y2sgYW5kIGZpbGUgYmFja2VuZCkKPj4KPj4gSXQgd291bGQgYWxzbyBiZSBuaWNlIHRvIGhhdmUg
Y29weSBvZmZsb2FkIGVtdWxhdGlvbiBpbiBudWxsX2JsayBmb3IgdGVzdGluZy4KPj4KPiAKPiBX
ZSBjYW4gcGxhbiB0aGlzIGluIG5leHQgcGhhc2Ugb2YgY29weSBzdXBwb3J0LCBvbmNlIHRoaXMg
c2VyaWVzIHNldHRsZXMgZG93bi4KCldoeSA/IEhvdyBkbyB5b3UgZXhwZWN0IHBlb3BsZSB0byB0
ZXN0IHNpbXBseSB3aXRob3V0IG51bGxfYmxrID8gU3V0cmUsIHlvdSBzYWlkClFFTVUgY2FuIGJl
IHVzZWQuIEJ1dCBpZiBjb3B5IG9mZmxvYWQgaXMgbm90IHVwc3RyZWFtIGZvciBRRU1VIGVpdGhl
ciwgdGhlcmUgaXMKbm8gZWFzeSB3YXkgdG8gdGVzdC4KCkFkZGluZyB0aGF0IHN1cHBvcnQgdG8g
bnVsbF9ibGsgd291bGQgbm90IGJlIGhhcmQgYXQgYWxsLgoKCgotLSAKRGFtaWVuIExlIE1vYWwK
V2VzdGVybiBEaWdpdGFsIFJlc2VhcmNoCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsCg==

