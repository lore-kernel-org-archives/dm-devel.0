Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8BB2C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 21:56:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-cFEB_Sf5P3mzGlmFthyfFA-1; Wed, 27 Apr 2022 17:56:19 -0400
X-MC-Unique: cFEB_Sf5P3mzGlmFthyfFA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18F8D1C0514C;
	Wed, 27 Apr 2022 21:56:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2A09BC27DB5;
	Wed, 27 Apr 2022 21:56:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BFE1F1947046;
	Wed, 27 Apr 2022 21:56:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1A90E1947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 21:56:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D1059C2813B; Wed, 27 Apr 2022 21:56:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CCEEDC27DB5
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 21:56:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FEBC3C01D92
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 21:56:14 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-EMAhBfBENLq0KsGVftkDbw-1; Wed, 27 Apr 2022 17:56:12 -0400
X-MC-Unique: EMAhBfBENLq0KsGVftkDbw-1
X-IronPort-AV: E=Sophos;i="5.90,294,1643644800"; d="scan'208";a="303207063"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2022 05:56:10 +0800
IronPort-SDR: OIyxKnY6UBO/5M+IlQ05EtWTyOrHW+nzsN2dQfnIzjSFZ9e39nfssi7aIW9oS5h0jD6FyKbauw
 LCEyTmFfXHaPM0yAPpA+ubB8sHhkBDf9I6ziiAKJj4uv8DPHeZbrk194PZ6YgmxTlNvHdZ8r+z
 +/5dI/NuiCWkSPtnP7WyTVaEFB6EOBpYAP+DDIRahG/1aoQ6G77XfphNzVZI4eqRczTO/QPcmt
 D6C0U0lmb6Bo6/wLOuUIBdxx+PAodVAXCgyxa9N+nSHWRotsRWDgeugyrKDgCs5gBu75xgQZJ3
 Oqw+Zc6krGlPsyjyqqSamVlk
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Apr 2022 14:27:03 -0700
IronPort-SDR: +5YlOyD1i51AoUJEI4mjbpJR7o2IOUQMJb0u7H9vWLs0tOVIoiD6zIR6D/hkFE7eXZeQfePEFB
 TywWfVjKcS/JpbVTefjw+96bgcwONWTkuUsopsAesRIoJXZqnE4Q9DKMPHDnozSBrXgU1wJMuZ
 6Go950maHi5K7S7ZgaTH9dTd3grGRpWh7W2VJjJqqJvc+civd2wROqfgtJ9mOPKHRN9htOu8SO
 YHHQU4Pi1nD0nfzrZSzdi0xsz63sjBSpxEsxH+1xO69VHWHo9DIURpGohajQoW9QtJEquDNb+t
 mm0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Apr 2022 14:56:12 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KpXd64dWXz1Rvlx
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 14:56:10 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id hbHw3A-H_OhJ for <dm-devel@redhat.com>;
 Wed, 27 Apr 2022 14:56:09 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KpXd44RlGz1Rvlc;
 Wed, 27 Apr 2022 14:56:08 -0700 (PDT)
Message-ID: <3f80a126-e52a-955b-aca4-14218d26faf5@opensource.wdc.com>
Date: Thu, 28 Apr 2022 06:56:07 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <CGME20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15@epcas5p4.samsung.com>
 <20220426101241.30100-1-nj.shetty@samsung.com>
 <c02f67e1-2f76-7e52-8478-78e28b96b6a1@opensource.wdc.com>
 <20220427153826.GE9558@test-zns>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220427153826.GE9558@test-zns>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8yOC8yMiAwMDozOCwgTml0ZXNoIFNoZXR0eSB3cm90ZToKPiBPbiBXZWQsIEFwciAyNywg
MjAyMiBhdCAxMDo0NjozMkFNICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToKPj4gT24gNC8y
Ni8yMiAxOToxMiwgTml0ZXNoIFNoZXR0eSB3cm90ZToKPj4+IFRoZSBwYXRjaCBzZXJpZXMgY292
ZXJzIHRoZSBwb2ludHMgZGlzY3Vzc2VkIGluIE5vdmVtYmVyIDIwMjEgdmlydHVhbCBjYWxsCj4+
PiBbTFNGL01NL0JGUCBUT1BJQ10gU3RvcmFnZTogQ29weSBPZmZsb2FkWzBdLgo+Pj4gV2UgaGF2
ZSBjb3ZlcmVkIHRoZSBJbml0aWFsIGFncmVlZCByZXF1aXJlbWVudHMgaW4gdGhpcyBwYXRjaHNl
dC4KPj4+IFBhdGNoc2V0IGJvcnJvd3MgTWlrdWxhcydzIHRva2VuIGJhc2VkIGFwcHJvYWNoIGZv
ciAyIGJkZXYKPj4+IGltcGxlbWVudGF0aW9uLgo+Pj4KPj4+IE92ZXJhbGwgc2VyaWVzIHN1cHBv
cnRzIOKAkwo+Pj4KPj4+IDEuIERyaXZlcgo+Pj4gLSBOVk1lIENvcHkgY29tbWFuZCAoc2luZ2xl
IE5TKSwgaW5jbHVkaW5nIHN1cHBvcnQgaW4gbnZtZS10YXJnZXQgKGZvcgo+Pj4gICAgIGJsb2Nr
IGFuZCBmaWxlIGJhY2tlbmQpCj4+Pgo+Pj4gMi4gQmxvY2sgbGF5ZXIKPj4+IC0gQmxvY2stZ2Vu
ZXJpYyBjb3B5IChSRVFfQ09QWSBmbGFnKSwgd2l0aCBpbnRlcmZhY2UgYWNjb21tb2RhdGluZwo+
Pj4gICAgIHR3byBibG9jay1kZXZzLCBhbmQgbXVsdGktc291cmNlL2Rlc3RpbmF0aW9uIGludGVy
ZmFjZQo+Pj4gLSBFbXVsYXRpb24sIHdoZW4gb2ZmbG9hZCBpcyBuYXRpdmVseSBhYnNlbnQKPj4+
IC0gZG0tbGluZWFyIHN1cHBvcnQgKGZvciBjYXNlcyBub3QgcmVxdWlyaW5nIHNwbGl0KQo+Pj4K
Pj4+IDMuIFVzZXItaW50ZXJmYWNlCj4+PiAtIG5ldyBpb2N0bAo+Pj4gLSBjb3B5X2ZpbGVfcmFu
Z2UgZm9yIHpvbmVmcwo+Pj4KPj4+IDQuIEluLWtlcm5lbCB1c2VyCj4+PiAtIGRtLWtjb3B5ZAo+
Pj4gLSBjb3B5X2ZpbGVfcmFuZ2UgaW4gem9uZWZzCj4+Pgo+Pj4gRm9yIHpvbmVmcyBjb3B5X2Zp
bGVfcmFuZ2UgLSBTZWVtcyB3ZSBjYW5ub3QgbGV2ZWFyZ2UgZnN0ZXN0IGhlcmUuIExpbWl0ZWQK
Pj4+IHRlc3RpbmcgaXMgZG9uZSBhdCB0aGlzIHBvaW50IHVzaW5nIGEgY3VzdG9tIGFwcGxpY2F0
aW9uIGZvciB1bml0IHRlc3RpbmcuCj4+Cj4+IGh0dHBzOi8vcHJvdGVjdDIuZmlyZWV5ZS5jb20v
djEvdXJsP2s9YjE0YmY4ZTEtZDAzNjEwOTktYjE0YTczYWUtNzRmZTQ4NWZmZmIxLTliZDliYmIy
NjlhZjE4ZjkmcT0xJmU9Yjk3MTRjMjktZWEyMi00ZmE1LThhMmEtZWViNDJjYTRiZGMxJnU9aHR0
cHMlM0ElMkYlMkZnaXRodWIuY29tJTJGd2VzdGVybmRpZ2l0YWxjb3Jwb3JhdGlvbiUyRnpvbmVm
cy10b29scwo+Pgo+PiAuL2NvbmZpZ3VyZSAtLXdpdGgtdGVzdHMKPj4gbWFrZQo+PiBzdWRvIG1h
a2UgaW5zdGFsbAo+Pgo+PiBUaGVuIHJ1biB0ZXN0cy96b25lZnMtdGVzdHMuc2gKPj4KPj4gQWRk
aW5nIHRlc3QgY2FzZSBpcyBzaW1wbGUuIEp1c3QgYWRkIHNjcmlwdCBmaWxlcyB1bmRlciB0ZXN0
cy9zY3JpcHRzCj4+Cj4+IEkganVzdCByZWFsaXplZCB0aGF0IHRoZSBSRUFETUUgZmlsZSBvZiB0
aGlzIHByb2plY3QgaXMgbm90IGRvY3VtZW50aW5nCj4+IHRoaXMuIEkgd2lsbCB1cGRhdGUgaXQu
Cj4+Cj4gCj4gVGhhbmsgeW91LiBXZSB3aWxsIHRyeSB0byB1c2UgdGhpcy4KPiBBbnkgcGxhbnMg
dG8gaW50ZWdyYXRlIHRoaXMgdGVzdHN1aXRlIHdpdGggZnN0ZXN0cyh4ZnN0ZXN0KSA/CgpOby4g
SXQgaXMgbm90IGEgZ29vZCBmaXQgc2luY2Ugem9uZWZzIGNhbm5vdCBwYXNzIG1vc3Qgb2YgdGhl
IGdlbmVyaWMgdGVzdApjYXNlcy4KCj4gCj4gLS0KPiBOaXRlc2ggU2hldHR5Cj4gCj4gCgoKLS0g
CkRhbWllbiBMZSBNb2FsCldlc3Rlcm4gRGlnaXRhbCBSZXNlYXJjaAoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

