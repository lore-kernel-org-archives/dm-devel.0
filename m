Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2782DC433FE
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 02:20:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-6WmSSFYSOk-FiOC4Kfp7CQ-1; Tue, 26 Apr 2022 22:20:04 -0400
X-MC-Unique: 6WmSSFYSOk-FiOC4Kfp7CQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DDF03C0D188;
	Wed, 27 Apr 2022 02:20:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 717754047D29;
	Wed, 27 Apr 2022 02:20:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 096291947BBE;
	Wed, 27 Apr 2022 02:20:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BC38319451F0
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 02:20:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 835AF463EDA; Wed, 27 Apr 2022 02:20:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EEBC41615C
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 02:20:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65BF0101AA45
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 02:20:00 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-HK6l2DBEMtGH_8wXS-D3Yw-1; Tue, 26 Apr 2022 22:19:58 -0400
X-MC-Unique: HK6l2DBEMtGH_8wXS-D3Yw-1
X-IronPort-AV: E=Sophos;i="5.90,292,1643644800"; d="scan'208";a="199803644"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 27 Apr 2022 10:19:58 +0800
IronPort-SDR: T00mK5zRgUG2WiCE5DR0sTJ2VWl29JUQtB5tjwkNDFtC0k4bxa8hfNI3nXEfKE1UIxDfoEMe27
 QKCMyudsaz5VGcItKdLw/Zx8SSXk09OKU9I3f0wedbXxQonoZczDYLhSZ7umGfQ7+2Vvk2zDQB
 2telhpiahqxyQaYhd0Hn6cXiBGC4eFm1aekNXfssdc2P1hVWrEwcA+o1GPNRwNVCbcsmIE6u87
 woi5zPDegwTt1mYs0KVzOGYOIC6VlSft+XpCcfLyVJVJTdAMJCYntXjWVqISzCmYEbkgqSuNXn
 ZorerOwGDbOnkyT3xm8atcLr
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 26 Apr 2022 18:50:08 -0700
IronPort-SDR: F5FflXtYlkTKjmsI8BqMCTTlMO0E7Ymv/wllKUZbvM3YiBVYmZoRSRL6obZJhoFxg1ALaBerBK
 bLU8QnTgiCLNBCVvB92Bo8gGe2gmgDRJvvd95HvJza/IkKjQLY/zj3cpJFbZ0VgePApzkGPXTM
 zF3subFYEledRdsrkhE/kvxws8XS0LqYL69SQmdURJQ6pL91zDMjNK0Pm7fe6YFsZFoq1cW7KO
 BwxNEr5Rk2KWH08xRkCg5KK+0j7eNXCO9U5FwuDeQYbZDxlQ0dFHUo3i1I0iwfy/iN5YgLSati
 bJY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 26 Apr 2022 19:19:57 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kp2Ww3Wrbz1SVp1
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 19:19:56 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id jlYrfLTuGH40 for <dm-devel@redhat.com>;
 Tue, 26 Apr 2022 19:19:54 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kp2Wn4QZqz1Rvlc;
 Tue, 26 Apr 2022 19:19:49 -0700 (PDT)
Message-ID: <6a85e8c8-d9d1-f192-f10d-09052703c99a@opensource.wdc.com>
Date: Wed, 27 Apr 2022 11:19:48 +0900
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
ZW5kKQoKSXQgd291bGQgYWxzbyBiZSBuaWNlIHRvIGhhdmUgY29weSBvZmZsb2FkIGVtdWxhdGlv
biBpbiBudWxsX2JsayBmb3IgdGVzdGluZy4KCj4gCj4gMi4gQmxvY2sgbGF5ZXIKPiAtIEJsb2Nr
LWdlbmVyaWMgY29weSAoUkVRX0NPUFkgZmxhZyksIHdpdGggaW50ZXJmYWNlIGFjY29tbW9kYXRp
bmcKPiAgICAgdHdvIGJsb2NrLWRldnMsIGFuZCBtdWx0aS1zb3VyY2UvZGVzdGluYXRpb24gaW50
ZXJmYWNlCj4gLSBFbXVsYXRpb24sIHdoZW4gb2ZmbG9hZCBpcyBuYXRpdmVseSBhYnNlbnQKPiAt
IGRtLWxpbmVhciBzdXBwb3J0IChmb3IgY2FzZXMgbm90IHJlcXVpcmluZyBzcGxpdCkKPiAKPiAz
LiBVc2VyLWludGVyZmFjZQo+IC0gbmV3IGlvY3RsCj4gLSBjb3B5X2ZpbGVfcmFuZ2UgZm9yIHpv
bmVmcwo+IAo+IDQuIEluLWtlcm5lbCB1c2VyCj4gLSBkbS1rY29weWQKPiAtIGNvcHlfZmlsZV9y
YW5nZSBpbiB6b25lZnMKPiAKPiBGb3Igem9uZWZzIGNvcHlfZmlsZV9yYW5nZSAtIFNlZW1zIHdl
IGNhbm5vdCBsZXZlYXJnZSBmc3Rlc3QgaGVyZS4gTGltaXRlZAo+IHRlc3RpbmcgaXMgZG9uZSBh
dCB0aGlzIHBvaW50IHVzaW5nIGEgY3VzdG9tIGFwcGxpY2F0aW9uIGZvciB1bml0IHRlc3Rpbmcu
Cj4gCj4gQXBwcmVjaWF0ZSB0aGUgaW5wdXRzIG9uIHBsdW1iaW5nIGFuZCBob3cgdG8gdGVzdCB0
aGlzIGZ1cnRoZXI/Cj4gUGVyaGFwcyBzb21lIG9mIGl0IGNhbiBiZSBkaXNjdXNzZWQgZHVyaW5n
IExTRi9NTSB0b28uCj4gCj4gWzBdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW52bWUv
Q0ErMUUzcko3Qlo3TGpRWFhUZFgrLTBFZHo9elQxNG1tUEdNaVZDelVnQjMzQzYwdGJRQG1haWwu
Z21haWwuY29tLwo+IAo+IENoYW5nZXMgaW4gdjQ6Cj4gLSBhZGRlZCBjb3B5X2ZpbGVfcmFuZ2Ug
c3VwcG9ydCBmb3Igem9uZWZzCj4gLSBhZGRlZCBkb2N1bWVudGFpb24gYWJvdXQgbmV3IHN5c2Zz
IGVudHJpZXMKPiAtIGluY29ycG9yYXRlZCByZXZpZXcgY29tbWVudHMgb24gdjMKPiAtIG1pbm9y
IGZpeGVzCj4gCj4gCj4gQXJuYXYgRGF3biAoMik6Cj4gICBudm1ldDogYWRkIGNvcHkgY29tbWFu
ZCBzdXBwb3J0IGZvciBiZGV2IGFuZCBmaWxlIG5zCj4gICBmczogYWRkIHN1cHBvcnQgZm9yIGNv
cHkgZmlsZSByYW5nZSBpbiB6b25lZnMKPiAKPiBOaXRlc2ggU2hldHR5ICg3KToKPiAgIGJsb2Nr
OiBJbnRyb2R1Y2UgcXVldWUgbGltaXRzIGZvciBjb3B5LW9mZmxvYWQgc3VwcG9ydAo+ICAgYmxv
Y2s6IEFkZCBjb3B5IG9mZmxvYWQgc3VwcG9ydCBpbmZyYXN0cnVjdHVyZQo+ICAgYmxvY2s6IElu
dHJvZHVjZSBhIG5ldyBpb2N0bCBmb3IgY29weQo+ICAgYmxvY2s6IGFkZCBlbXVsYXRpb24gZm9y
IGNvcHkKPiAgIG52bWU6IGFkZCBjb3B5IG9mZmxvYWQgc3VwcG9ydAo+ICAgZG06IEFkZCBzdXBw
b3J0IGZvciBjb3B5IG9mZmxvYWQuCj4gICBkbTogRW5hYmxlIGNvcHkgb2ZmbG9hZCBmb3IgZG0t
bGluZWFyIHRhcmdldAo+IAo+IFNlbHZhS3VtYXIgUyAoMSk6Cj4gICBkbSBrY29weWQ6IHVzZSBj
b3B5IG9mZmxvYWQgc3VwcG9ydAo+IAo+ICBEb2N1bWVudGF0aW9uL0FCSS9zdGFibGUvc3lzZnMt
YmxvY2sgfCAgODMgKysrKysrKwo+ICBibG9jay9ibGstbGliLmMgICAgICAgICAgICAgICAgICAg
ICAgfCAzNTggKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4gIGJsb2NrL2Jsay1tYXAuYyAg
ICAgICAgICAgICAgICAgICAgICB8ICAgMiArLQo+ICBibG9jay9ibGstc2V0dGluZ3MuYyAgICAg
ICAgICAgICAgICAgfCAgNTkgKysrKysKPiAgYmxvY2svYmxrLXN5c2ZzLmMgICAgICAgICAgICAg
ICAgICAgIHwgMTM4ICsrKysrKysrKysrCj4gIGJsb2NrL2Jsay5oICAgICAgICAgICAgICAgICAg
ICAgICAgICB8ICAgMiArCj4gIGJsb2NrL2lvY3RsLmMgICAgICAgICAgICAgICAgICAgICAgICB8
ICAzMiArKysKPiAgZHJpdmVycy9tZC9kbS1rY29weWQuYyAgICAgICAgICAgICAgIHwgIDU1ICsr
Ky0KPiAgZHJpdmVycy9tZC9kbS1saW5lYXIuYyAgICAgICAgICAgICAgIHwgICAxICsKPiAgZHJp
dmVycy9tZC9kbS10YWJsZS5jICAgICAgICAgICAgICAgIHwgIDQ1ICsrKysKPiAgZHJpdmVycy9t
ZC9kbS5jICAgICAgICAgICAgICAgICAgICAgIHwgICA2ICsKPiAgZHJpdmVycy9udm1lL2hvc3Qv
Y29yZS5jICAgICAgICAgICAgIHwgMTE2ICsrKysrKysrLQo+ICBkcml2ZXJzL252bWUvaG9zdC9m
Yy5jICAgICAgICAgICAgICAgfCAgIDQgKwo+ICBkcml2ZXJzL252bWUvaG9zdC9udm1lLmggICAg
ICAgICAgICAgfCAgIDcgKwo+ICBkcml2ZXJzL252bWUvaG9zdC9wY2kuYyAgICAgICAgICAgICAg
fCAgMjUgKysKPiAgZHJpdmVycy9udm1lL2hvc3QvcmRtYS5jICAgICAgICAgICAgIHwgICA2ICsK
PiAgZHJpdmVycy9udm1lL2hvc3QvdGNwLmMgICAgICAgICAgICAgIHwgIDE0ICsrCj4gIGRyaXZl
cnMvbnZtZS9ob3N0L3RyYWNlLmMgICAgICAgICAgICB8ICAxOSArKwo+ICBkcml2ZXJzL252bWUv
dGFyZ2V0L2FkbWluLWNtZC5jICAgICAgfCAgIDggKy0KPiAgZHJpdmVycy9udm1lL3RhcmdldC9p
by1jbWQtYmRldi5jICAgIHwgIDY1ICsrKysrCj4gIGRyaXZlcnMvbnZtZS90YXJnZXQvaW8tY21k
LWZpbGUuYyAgICB8ICA0OSArKysrCj4gIGZzL3pvbmVmcy9zdXBlci5jICAgICAgICAgICAgICAg
ICAgICB8IDE3OCArKysrKysrKysrKystCj4gIGZzL3pvbmVmcy96b25lZnMuaCAgICAgICAgICAg
ICAgICAgICB8ICAgMSArCj4gIGluY2x1ZGUvbGludXgvYmxrX3R5cGVzLmggICAgICAgICAgICB8
ICAyMSArKwo+ICBpbmNsdWRlL2xpbnV4L2Jsa2Rldi5oICAgICAgICAgICAgICAgfCAgMTcgKysK
PiAgaW5jbHVkZS9saW51eC9kZXZpY2UtbWFwcGVyLmggICAgICAgIHwgICA1ICsKPiAgaW5jbHVk
ZS9saW51eC9udm1lLmggICAgICAgICAgICAgICAgIHwgIDQzICsrKy0KPiAgaW5jbHVkZS91YXBp
L2xpbnV4L2ZzLmggICAgICAgICAgICAgIHwgIDIzICsrCj4gIDI4IGZpbGVzIGNoYW5nZWQsIDEz
NjcgaW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pCj4gCj4gCj4gYmFzZS1jb21taXQ6IGU3
ZDY5ODdlMDlhMzI4ZDRhOTQ5NzAxZGI0MGVmNjNmYmI5NzA2NzAKCgotLSAKRGFtaWVuIExlIE1v
YWwKV2VzdGVybiBEaWdpdGFsIFJlc2VhcmNoCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsCg==

