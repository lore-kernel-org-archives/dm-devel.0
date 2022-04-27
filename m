Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C778FC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 01:47:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-UY03SO6aOxiIbbZkl7J55w-1; Tue, 26 Apr 2022 21:47:01 -0400
X-MC-Unique: UY03SO6aOxiIbbZkl7J55w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 184F31E1AE41;
	Wed, 27 Apr 2022 01:47:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 04A1414682C6;
	Wed, 27 Apr 2022 01:47:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CA9F71947BBE;
	Wed, 27 Apr 2022 01:46:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AE74A19451F0
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 01:46:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8A2C42024CB8; Wed, 27 Apr 2022 01:46:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 85A762024CB7
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 01:46:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51CD0185A794
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 01:46:44 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-9ESOGjsbN4qrIyoTvhilBg-2; Tue, 26 Apr 2022 21:46:42 -0400
X-MC-Unique: 9ESOGjsbN4qrIyoTvhilBg-2
X-IronPort-AV: E=Sophos;i="5.90,292,1643644800"; d="scan'208";a="199801154"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 27 Apr 2022 09:46:43 +0800
IronPort-SDR: Xn8jdgn9E1khAXlz4d2ax65zul1H2Jb1qd+gp0nlmHqlXAD3LF1Y5sNIhUHRyO6FgJykoc58//
 Np8VIY8xdq3mk8saY2EGjwipmRq5c/ZXq4u/O/J3ZYaKenOqakd5AbUF55YU1o6BUfcMHzrs57
 MSvlOjvuF92G+MLqZXw9UWb5j6/ga9Nh6WB3nrv2gxXft9Lk8KJWcYbZi5Dupx+yxr9cJYJaIO
 R9Mlz2qp+pR/V6cBXENMyZIjrvjLt+XvmDvoXsWUZDZ9AczsiSERfzv5ZA0YUeY6D6a2ht7K1O
 4RmknOtbuPjlwWzqG3+AlC+C
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 26 Apr 2022 18:16:52 -0700
IronPort-SDR: ALV+2V4vXtkGThyEVVGtkoCl9b7lhN+92XzNmERTWOx1ACoH0vnIxJ77U/+tKNEnvtNXUr2JIG
 9ai9me++p/n0GLdNZcQyURklPm77Qx0rt2xG+4wW/eiPlT8b8/aZJWOAsKh00xO+TYQli9AQfY
 lLCLYzIre0OoRxB8hVVpMCAcoUH27WL/6Sxj7S1B0M0KIDR08664O0DVeVKXhYmGGB5mRc/x79
 uHhtagkBu1JQH2TiA0F4OOBfE2IL4zdn0HUpsjkJk3GxwnK253a8a8doBoQHGJFWS3gJPcU5tE
 mTw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 26 Apr 2022 18:46:43 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kp1nY3L2Cz1SVnx
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 18:46:40 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id jMeR84PuyTQC for <dm-devel@redhat.com>;
 Tue, 26 Apr 2022 18:46:39 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kp1nQ10FXz1Rvlc;
 Tue, 26 Apr 2022 18:46:33 -0700 (PDT)
Message-ID: <c02f67e1-2f76-7e52-8478-78e28b96b6a1@opensource.wdc.com>
Date: Wed, 27 Apr 2022 10:46:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <CGME20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15@epcas5p4.samsung.com>
 <20220426101241.30100-1-nj.shetty@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220426101241.30100-1-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
 dm-devel@redhat.com, osandov@fb.com, Alasdair Kergon <agk@redhat.com>,
 Naohiro Aota <naohiro.aota@wdc.com>, msnitzer@redhat.com, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, gost.dev@samsung.com, nitheshshetty@gmail.com,
 James Smart <james.smart@broadcom.com>, hch@lst.de, chaitanyak@nvidia.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Mike Snitzer <snitzer@kernel.org>,
 josef@toxicpanda.com, linux-block@vger.kernel.org, dsterba@suse.com,
 kbusch@kernel.org, Frederick.Knight@netapp.com,
 Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk,
 Johannes Thumshirn <jth@kernel.org>, tytso@mit.edu, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, jack@suse.com, linux-fsdevel@vger.kernel.org,
 lsf-pc@lists.linux-foundation.org, Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8yNi8yMiAxOToxMiwgTml0ZXNoIFNoZXR0eSB3cm90ZToKPiBUaGUgcGF0Y2ggc2VyaWVz
IGNvdmVycyB0aGUgcG9pbnRzIGRpc2N1c3NlZCBpbiBOb3ZlbWJlciAyMDIxIHZpcnR1YWwgY2Fs
bAo+IFtMU0YvTU0vQkZQIFRPUElDXSBTdG9yYWdlOiBDb3B5IE9mZmxvYWRbMF0uCj4gV2UgaGF2
ZSBjb3ZlcmVkIHRoZSBJbml0aWFsIGFncmVlZCByZXF1aXJlbWVudHMgaW4gdGhpcyBwYXRjaHNl
dC4KPiBQYXRjaHNldCBib3Jyb3dzIE1pa3VsYXMncyB0b2tlbiBiYXNlZCBhcHByb2FjaCBmb3Ig
MiBiZGV2Cj4gaW1wbGVtZW50YXRpb24uCj4gCj4gT3ZlcmFsbCBzZXJpZXMgc3VwcG9ydHMg4oCT
Cj4gCj4gMS4gRHJpdmVyCj4gLSBOVk1lIENvcHkgY29tbWFuZCAoc2luZ2xlIE5TKSwgaW5jbHVk
aW5nIHN1cHBvcnQgaW4gbnZtZS10YXJnZXQgKGZvcgo+ICAgICBibG9jayBhbmQgZmlsZSBiYWNr
ZW5kKQo+IAo+IDIuIEJsb2NrIGxheWVyCj4gLSBCbG9jay1nZW5lcmljIGNvcHkgKFJFUV9DT1BZ
IGZsYWcpLCB3aXRoIGludGVyZmFjZSBhY2NvbW1vZGF0aW5nCj4gICAgIHR3byBibG9jay1kZXZz
LCBhbmQgbXVsdGktc291cmNlL2Rlc3RpbmF0aW9uIGludGVyZmFjZQo+IC0gRW11bGF0aW9uLCB3
aGVuIG9mZmxvYWQgaXMgbmF0aXZlbHkgYWJzZW50Cj4gLSBkbS1saW5lYXIgc3VwcG9ydCAoZm9y
IGNhc2VzIG5vdCByZXF1aXJpbmcgc3BsaXQpCj4gCj4gMy4gVXNlci1pbnRlcmZhY2UKPiAtIG5l
dyBpb2N0bAo+IC0gY29weV9maWxlX3JhbmdlIGZvciB6b25lZnMKPiAKPiA0LiBJbi1rZXJuZWwg
dXNlcgo+IC0gZG0ta2NvcHlkCj4gLSBjb3B5X2ZpbGVfcmFuZ2UgaW4gem9uZWZzCj4gCj4gRm9y
IHpvbmVmcyBjb3B5X2ZpbGVfcmFuZ2UgLSBTZWVtcyB3ZSBjYW5ub3QgbGV2ZWFyZ2UgZnN0ZXN0
IGhlcmUuIExpbWl0ZWQKPiB0ZXN0aW5nIGlzIGRvbmUgYXQgdGhpcyBwb2ludCB1c2luZyBhIGN1
c3RvbSBhcHBsaWNhdGlvbiBmb3IgdW5pdCB0ZXN0aW5nLgoKaHR0cHM6Ly9naXRodWIuY29tL3dl
c3Rlcm5kaWdpdGFsY29ycG9yYXRpb24vem9uZWZzLXRvb2xzCgouL2NvbmZpZ3VyZSAtLXdpdGgt
dGVzdHMKbWFrZQpzdWRvIG1ha2UgaW5zdGFsbAoKVGhlbiBydW4gdGVzdHMvem9uZWZzLXRlc3Rz
LnNoCgpBZGRpbmcgdGVzdCBjYXNlIGlzIHNpbXBsZS4gSnVzdCBhZGQgc2NyaXB0IGZpbGVzIHVu
ZGVyIHRlc3RzL3NjcmlwdHMKCkkganVzdCByZWFsaXplZCB0aGF0IHRoZSBSRUFETUUgZmlsZSBv
ZiB0aGlzIHByb2plY3QgaXMgbm90IGRvY3VtZW50aW5nCnRoaXMuIEkgd2lsbCB1cGRhdGUgaXQu
Cgo+IAo+IEFwcHJlY2lhdGUgdGhlIGlucHV0cyBvbiBwbHVtYmluZyBhbmQgaG93IHRvIHRlc3Qg
dGhpcyBmdXJ0aGVyPwo+IFBlcmhhcHMgc29tZSBvZiBpdCBjYW4gYmUgZGlzY3Vzc2VkIGR1cmlu
ZyBMU0YvTU0gdG9vLgo+IAo+IFswXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1udm1l
L0NBKzFFM3JKN0JaN0xqUVhYVGRYKy0wRWR6PXpUMTRtbVBHTWlWQ3pVZ0IzM0M2MHRiUUBtYWls
LmdtYWlsLmNvbS8KPiAKPiBDaGFuZ2VzIGluIHY0Ogo+IC0gYWRkZWQgY29weV9maWxlX3Jhbmdl
IHN1cHBvcnQgZm9yIHpvbmVmcwo+IC0gYWRkZWQgZG9jdW1lbnRhaW9uIGFib3V0IG5ldyBzeXNm
cyBlbnRyaWVzCj4gLSBpbmNvcnBvcmF0ZWQgcmV2aWV3IGNvbW1lbnRzIG9uIHYzCj4gLSBtaW5v
ciBmaXhlcwo+IAo+IAo+IEFybmF2IERhd24gKDIpOgo+ICAgbnZtZXQ6IGFkZCBjb3B5IGNvbW1h
bmQgc3VwcG9ydCBmb3IgYmRldiBhbmQgZmlsZSBucwo+ICAgZnM6IGFkZCBzdXBwb3J0IGZvciBj
b3B5IGZpbGUgcmFuZ2UgaW4gem9uZWZzCj4gCj4gTml0ZXNoIFNoZXR0eSAoNyk6Cj4gICBibG9j
azogSW50cm9kdWNlIHF1ZXVlIGxpbWl0cyBmb3IgY29weS1vZmZsb2FkIHN1cHBvcnQKPiAgIGJs
b2NrOiBBZGQgY29weSBvZmZsb2FkIHN1cHBvcnQgaW5mcmFzdHJ1Y3R1cmUKPiAgIGJsb2NrOiBJ
bnRyb2R1Y2UgYSBuZXcgaW9jdGwgZm9yIGNvcHkKPiAgIGJsb2NrOiBhZGQgZW11bGF0aW9uIGZv
ciBjb3B5Cj4gICBudm1lOiBhZGQgY29weSBvZmZsb2FkIHN1cHBvcnQKPiAgIGRtOiBBZGQgc3Vw
cG9ydCBmb3IgY29weSBvZmZsb2FkLgo+ICAgZG06IEVuYWJsZSBjb3B5IG9mZmxvYWQgZm9yIGRt
LWxpbmVhciB0YXJnZXQKPiAKPiBTZWx2YUt1bWFyIFMgKDEpOgo+ICAgZG0ga2NvcHlkOiB1c2Ug
Y29weSBvZmZsb2FkIHN1cHBvcnQKPiAKPiAgRG9jdW1lbnRhdGlvbi9BQkkvc3RhYmxlL3N5c2Zz
LWJsb2NrIHwgIDgzICsrKysrKysKPiAgYmxvY2svYmxrLWxpYi5jICAgICAgICAgICAgICAgICAg
ICAgIHwgMzU4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKwo+ICBibG9jay9ibGstbWFwLmMg
ICAgICAgICAgICAgICAgICAgICAgfCAgIDIgKy0KPiAgYmxvY2svYmxrLXNldHRpbmdzLmMgICAg
ICAgICAgICAgICAgIHwgIDU5ICsrKysrCj4gIGJsb2NrL2Jsay1zeXNmcy5jICAgICAgICAgICAg
ICAgICAgICB8IDEzOCArKysrKysrKysrKwo+ICBibG9jay9ibGsuaCAgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgIDIgKwo+ICBibG9jay9pb2N0bC5jICAgICAgICAgICAgICAgICAgICAgICAg
fCAgMzIgKysrCj4gIGRyaXZlcnMvbWQvZG0ta2NvcHlkLmMgICAgICAgICAgICAgICB8ICA1NSAr
KystCj4gIGRyaXZlcnMvbWQvZG0tbGluZWFyLmMgICAgICAgICAgICAgICB8ICAgMSArCj4gIGRy
aXZlcnMvbWQvZG0tdGFibGUuYyAgICAgICAgICAgICAgICB8ICA0NSArKysrCj4gIGRyaXZlcnMv
bWQvZG0uYyAgICAgICAgICAgICAgICAgICAgICB8ICAgNiArCj4gIGRyaXZlcnMvbnZtZS9ob3N0
L2NvcmUuYyAgICAgICAgICAgICB8IDExNiArKysrKysrKy0KPiAgZHJpdmVycy9udm1lL2hvc3Qv
ZmMuYyAgICAgICAgICAgICAgIHwgICA0ICsKPiAgZHJpdmVycy9udm1lL2hvc3QvbnZtZS5oICAg
ICAgICAgICAgIHwgICA3ICsKPiAgZHJpdmVycy9udm1lL2hvc3QvcGNpLmMgICAgICAgICAgICAg
IHwgIDI1ICsrCj4gIGRyaXZlcnMvbnZtZS9ob3N0L3JkbWEuYyAgICAgICAgICAgICB8ICAgNiAr
Cj4gIGRyaXZlcnMvbnZtZS9ob3N0L3RjcC5jICAgICAgICAgICAgICB8ICAxNCArKwo+ICBkcml2
ZXJzL252bWUvaG9zdC90cmFjZS5jICAgICAgICAgICAgfCAgMTkgKysKPiAgZHJpdmVycy9udm1l
L3RhcmdldC9hZG1pbi1jbWQuYyAgICAgIHwgICA4ICstCj4gIGRyaXZlcnMvbnZtZS90YXJnZXQv
aW8tY21kLWJkZXYuYyAgICB8ICA2NSArKysrKwo+ICBkcml2ZXJzL252bWUvdGFyZ2V0L2lvLWNt
ZC1maWxlLmMgICAgfCAgNDkgKysrKwo+ICBmcy96b25lZnMvc3VwZXIuYyAgICAgICAgICAgICAg
ICAgICAgfCAxNzggKysrKysrKysrKysrLQo+ICBmcy96b25lZnMvem9uZWZzLmggICAgICAgICAg
ICAgICAgICAgfCAgIDEgKwo+ICBpbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oICAgICAgICAgICAg
fCAgMjEgKysKPiAgaW5jbHVkZS9saW51eC9ibGtkZXYuaCAgICAgICAgICAgICAgIHwgIDE3ICsr
Cj4gIGluY2x1ZGUvbGludXgvZGV2aWNlLW1hcHBlci5oICAgICAgICB8ICAgNSArCj4gIGluY2x1
ZGUvbGludXgvbnZtZS5oICAgICAgICAgICAgICAgICB8ICA0MyArKystCj4gIGluY2x1ZGUvdWFw
aS9saW51eC9mcy5oICAgICAgICAgICAgICB8ICAyMyArKwo+ICAyOCBmaWxlcyBjaGFuZ2VkLCAx
MzY3IGluc2VydGlvbnMoKyksIDE1IGRlbGV0aW9ucygtKQo+IAo+IAo+IGJhc2UtY29tbWl0OiBl
N2Q2OTg3ZTA5YTMyOGQ0YTk0OTcwMWRiNDBlZjYzZmJiOTcwNjcwCgoKLS0gCkRhbWllbiBMZSBN
b2FsCldlc3Rlcm4gRGlnaXRhbCBSZXNlYXJjaAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRt
LWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbAo=

