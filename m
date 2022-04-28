Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D545C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 28 Apr 2022 21:37:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-fTeCMxFYMRu-M5Wijo-Ucg-1; Thu, 28 Apr 2022 17:37:34 -0400
X-MC-Unique: fTeCMxFYMRu-M5Wijo-Ucg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3B183803508;
	Thu, 28 Apr 2022 21:37:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E431C414A7E7;
	Thu, 28 Apr 2022 21:37:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1BC2C1947048;
	Thu, 28 Apr 2022 21:37:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 547811947047
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Apr 2022 21:37:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3CCB440869D6; Thu, 28 Apr 2022 21:37:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3831D40869CB
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 21:37:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B9B1296A60E
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 21:37:27 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-9_Kj8OZuPECElBVD0afBBw-1; Thu, 28 Apr 2022 17:37:24 -0400
X-MC-Unique: 9_Kj8OZuPECElBVD0afBBw-1
X-IronPort-AV: E=Sophos;i="5.91,296,1647273600"; d="scan'208";a="199986896"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 29 Apr 2022 05:37:23 +0800
IronPort-SDR: z0jrxXUWLZjFLUq4aVQPqlZDJ0R7j98uqo7xNhBfoTtCMlX6Tnz8V5oQjB93/KVS3g/QPHbfOE
 rwyoApuqib4K2PxtdJ4IuEaza0A09h8s2BBiIa9vr1KuRRtIcVUYIuhP8oRglXU+uyeQlChIR8
 3Fi9DIPeLKwRLONto2gURG+edSJx48+3hMxqfCatBpxC1ky8/CCUnH4U9SvTXPqVzEr2RXwoGr
 27Lrv/iLditJwAhCHWnWjXNR+xo1AKu/S/gcDbzwUDpTkDk95D0j4119/QeLB/QzqX4gjuuzQ5
 Ogr2eukAofLHtVbxT6MV235E
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 28 Apr 2022 14:07:31 -0700
IronPort-SDR: gMZG7IPI6xbr79N6jRWgDz3It0w1euoP4m7IYvRqvaT/FnZzyZSVXDSgrDnKwggQnHSgBy59CV
 kRk14PMtVMGP8C0xOoGybo+xpVofBMeiIMyDtTuUPDim/pbQ4dYKn4CyReudvpRHolmuf7XPU2
 fBcZczKs+9gPNXhoGq+X75aGtrjQz7xtl87gGKEnn5oDrtSl3uUr48MNnMrqKTI3VkZGB7UvUs
 wB//iVpQ2fSFlQPNRB9fOexywvTSA16AZyXJSwh8xIl9v51FGmFV9899KARLS6Me9H0Ctqzggk
 12g=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 28 Apr 2022 14:37:23 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kq88x4sjCz1Rwrw
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 14:37:21 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id mWDyZm8srcei for <dm-devel@redhat.com>;
 Thu, 28 Apr 2022 14:37:21 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kq88w02gHz1Rvlc;
 Thu, 28 Apr 2022 14:37:19 -0700 (PDT)
Message-ID: <a6d1c61a-14f2-36dc-5952-4d6897720c7a@opensource.wdc.com>
Date: Fri, 29 Apr 2022 06:37:18 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <CGME20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15@epcas5p4.samsung.com>
 <20220426101241.30100-1-nj.shetty@samsung.com>
 <6a85e8c8-d9d1-f192-f10d-09052703c99a@opensource.wdc.com>
 <20220427124951.GA9558@test-zns>
 <c285f0da-ab1d-2b24-e5a4-21193ef93155@opensource.wdc.com>
 <20220428074926.GG9558@test-zns>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220428074926.GG9558@test-zns>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8yOC8yMiAxNjo0OSwgTml0ZXNoIFNoZXR0eSB3cm90ZToKPiBPbiBUaHUsIEFwciAyOCwg
MjAyMiBhdCAwNzowNTozMkFNICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToKPj4gT24gNC8y
Ny8yMiAyMTo0OSwgTml0ZXNoIFNoZXR0eSB3cm90ZToKPj4+IE8gV2VkLCBBcHIgMjcsIDIwMjIg
YXQgMTE6MTk6NDhBTSArMDkwMCwgRGFtaWVuIExlIE1vYWwgd3JvdGU6Cj4+Pj4gT24gNC8yNi8y
MiAxOToxMiwgTml0ZXNoIFNoZXR0eSB3cm90ZToKPj4+Pj4gVGhlIHBhdGNoIHNlcmllcyBjb3Zl
cnMgdGhlIHBvaW50cyBkaXNjdXNzZWQgaW4gTm92ZW1iZXIgMjAyMSB2aXJ0dWFsIGNhbGwKPj4+
Pj4gW0xTRi9NTS9CRlAgVE9QSUNdIFN0b3JhZ2U6IENvcHkgT2ZmbG9hZFswXS4KPj4+Pj4gV2Ug
aGF2ZSBjb3ZlcmVkIHRoZSBJbml0aWFsIGFncmVlZCByZXF1aXJlbWVudHMgaW4gdGhpcyBwYXRj
aHNldC4KPj4+Pj4gUGF0Y2hzZXQgYm9ycm93cyBNaWt1bGFzJ3MgdG9rZW4gYmFzZWQgYXBwcm9h
Y2ggZm9yIDIgYmRldgo+Pj4+PiBpbXBsZW1lbnRhdGlvbi4KPj4+Pj4KPj4+Pj4gT3ZlcmFsbCBz
ZXJpZXMgc3VwcG9ydHMg4oCTCj4+Pj4+Cj4+Pj4+IDEuIERyaXZlcgo+Pj4+PiAtIE5WTWUgQ29w
eSBjb21tYW5kIChzaW5nbGUgTlMpLCBpbmNsdWRpbmcgc3VwcG9ydCBpbiBudm1lLXRhcmdldCAo
Zm9yCj4+Pj4+ICAgICBibG9jayBhbmQgZmlsZSBiYWNrZW5kKQo+Pj4+Cj4+Pj4gSXQgd291bGQg
YWxzbyBiZSBuaWNlIHRvIGhhdmUgY29weSBvZmZsb2FkIGVtdWxhdGlvbiBpbiBudWxsX2JsayBm
b3IgdGVzdGluZy4KPj4+Pgo+Pj4KPj4+IFdlIGNhbiBwbGFuIHRoaXMgaW4gbmV4dCBwaGFzZSBv
ZiBjb3B5IHN1cHBvcnQsIG9uY2UgdGhpcyBzZXJpZXMgc2V0dGxlcyBkb3duLgo+Pgo+PiBTbyBo
b3cgY2FuIHBlb3BsZSB0ZXN0IHlvdXIgc2VyaWVzID8gTm90IGEgbG90IG9mIGRyaXZlcyBvdXQg
dGhlcmUgd2l0aAo+PiBjb3B5IHN1cHBvcnQuCj4+Cj4gCj4gWWVhaCBub3QgbWFueSBkcml2ZXMg
YXQgcHJlc2VudCwgUWVtdSBjYW4gYmUgdXNlZCB0byB0ZXN0IE5WTWUgY29weS4KClVwc3RyZWFt
IFFFTVUgPyBXaGF0IGlzIHRoZSBjb21tYW5kIGxpbmUgb3B0aW9ucyA/IEFuIGV4YW1wbGUgd291
bGQgYmUKbmljZS4gQnV0IEkgc3RpbGwgdGhpbmsgbnVsbF9ibGsgc3VwcG9ydCB3b3VsZCBiZSBl
YXNpZXN0LgoKCi0tIApEYW1pZW4gTGUgTW9hbApXZXN0ZXJuIERpZ2l0YWwgUmVzZWFyY2gKCi0t
CmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1h
bi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

