Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21A35C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 02:01:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-rmL8JAG0MOWox4JKPejeiw-1; Tue, 26 Apr 2022 22:01:27 -0400
X-MC-Unique: rmL8JAG0MOWox4JKPejeiw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDD81811E80;
	Wed, 27 Apr 2022 02:01:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A8B0F568640;
	Wed, 27 Apr 2022 02:01:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6FD341947BBE;
	Wed, 27 Apr 2022 02:01:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 97AA519451F0
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 02:01:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 886199E8E; Wed, 27 Apr 2022 02:01:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EF389E8F
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 02:01:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E69B6886491
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 02:01:08 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-cAi17EyLPEq6z5IEa4ezvw-2; Tue, 26 Apr 2022 22:01:06 -0400
X-MC-Unique: cAi17EyLPEq6z5IEa4ezvw-2
X-IronPort-AV: E=Sophos;i="5.90,292,1643644800"; d="scan'208";a="197753704"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 27 Apr 2022 10:01:04 +0800
IronPort-SDR: 4K/zfpyQm2eXdfErX0WbR5n81n2wVohOjSTYtAqP3nnhdJpZzwAdmM+LrxW+O857fIQI29Ux7H
 xobYsswv4PdIRSPnZlJFghGvSvnTM1aD0h246Lz7N3hDfvfNStIwV65AqxYELYKCltCGPhMggu
 PxKZklGBzaaYZE2trnU2IQXjkbMQJzTNNzeZJH/rXeLP5SIMO/Ex3RbZ3NMdTSsO4n6gze8Vpm
 g8BPaGbgREjO0NzWXlQRL67rj7HVwFecEdPT8HUg5Ed5m5HBgpN2pV4tcO8oWCYcMe6g9WMigg
 UbNUqRRQHB3mALbJt8ABZN/L
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 26 Apr 2022 18:31:58 -0700
IronPort-SDR: S9vUhsb+LzKAc641S0ENQbsFc4QBIB6UUqic13+0wItSvMPlu048CXWn8bJYO1T41JJEIav4hi
 6qsle3r9aZBxw2A2vYeCLUlKqnPN5f5foSA8VDwiOJyRAxyofzdDIhoO9+NuQz5jKyOaWt6RK8
 kFbzX1c3YWZ05BCK7ScCNfulN3ggGWcZBJ63EDjbxJI0IdGfoJF9MrBQG1wy+XWe86J195m724
 6UKdL0MrdSsqWUPrpxuD/RpRW2CGYO1ThxwARhqVUPP5rVXFw+J+5MAE6DsorAneu3z1IYf3eA
 LY4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 26 Apr 2022 19:01:04 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kp26759W5z1SVp5
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 19:01:02 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id oWjErHdy0Rnr for <dm-devel@redhat.com>;
 Tue, 26 Apr 2022 19:01:01 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kp25z67Pcz1Rvlc;
 Tue, 26 Apr 2022 19:00:55 -0700 (PDT)
Message-ID: <76a89205-f4f1-1e51-aa23-c8082bfefd3c@opensource.wdc.com>
Date: Wed, 27 Apr 2022 11:00:54 +0900
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
MiBiZGV2Cj4gaW1wbGVtZW50YXRpb24uCgpQbGVhc2UgcmVkdWNlIHRoZSBkaXN0cmlidXRpb24g
bGlzdC4gTGlzdCBzZXJ2ZXJzIChhbmQgZW1haWwgY2xpZW50cykgYXJlCmNvbXBsYWluaW5nIGFi
b3V0IGl0IGJlaW5nIHRvbyBsYXJnZS4KCj4gCj4gT3ZlcmFsbCBzZXJpZXMgc3VwcG9ydHMg4oCT
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
c3RvbSBhcHBsaWNhdGlvbiBmb3IgdW5pdCB0ZXN0aW5nLgo+IAo+IEFwcHJlY2lhdGUgdGhlIGlu
cHV0cyBvbiBwbHVtYmluZyBhbmQgaG93IHRvIHRlc3QgdGhpcyBmdXJ0aGVyPwo+IFBlcmhhcHMg
c29tZSBvZiBpdCBjYW4gYmUgZGlzY3Vzc2VkIGR1cmluZyBMU0YvTU0gdG9vLgo+IAo+IFswXSBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1udm1lL0NBKzFFM3JKN0JaN0xqUVhYVGRYKy0w
RWR6PXpUMTRtbVBHTWlWQ3pVZ0IzM0M2MHRiUUBtYWlsLmdtYWlsLmNvbS8KPiAKPiBDaGFuZ2Vz
IGluIHY0Ogo+IC0gYWRkZWQgY29weV9maWxlX3JhbmdlIHN1cHBvcnQgZm9yIHpvbmVmcwo+IC0g
YWRkZWQgZG9jdW1lbnRhaW9uIGFib3V0IG5ldyBzeXNmcyBlbnRyaWVzCj4gLSBpbmNvcnBvcmF0
ZWQgcmV2aWV3IGNvbW1lbnRzIG9uIHYzCj4gLSBtaW5vciBmaXhlcwo+IAo+IAo+IEFybmF2IERh
d24gKDIpOgo+ICAgbnZtZXQ6IGFkZCBjb3B5IGNvbW1hbmQgc3VwcG9ydCBmb3IgYmRldiBhbmQg
ZmlsZSBucwo+ICAgZnM6IGFkZCBzdXBwb3J0IGZvciBjb3B5IGZpbGUgcmFuZ2UgaW4gem9uZWZz
Cj4gCj4gTml0ZXNoIFNoZXR0eSAoNyk6Cj4gICBibG9jazogSW50cm9kdWNlIHF1ZXVlIGxpbWl0
cyBmb3IgY29weS1vZmZsb2FkIHN1cHBvcnQKPiAgIGJsb2NrOiBBZGQgY29weSBvZmZsb2FkIHN1
cHBvcnQgaW5mcmFzdHJ1Y3R1cmUKPiAgIGJsb2NrOiBJbnRyb2R1Y2UgYSBuZXcgaW9jdGwgZm9y
IGNvcHkKPiAgIGJsb2NrOiBhZGQgZW11bGF0aW9uIGZvciBjb3B5Cj4gICBudm1lOiBhZGQgY29w
eSBvZmZsb2FkIHN1cHBvcnQKPiAgIGRtOiBBZGQgc3VwcG9ydCBmb3IgY29weSBvZmZsb2FkLgo+
ICAgZG06IEVuYWJsZSBjb3B5IG9mZmxvYWQgZm9yIGRtLWxpbmVhciB0YXJnZXQKPiAKPiBTZWx2
YUt1bWFyIFMgKDEpOgo+ICAgZG0ga2NvcHlkOiB1c2UgY29weSBvZmZsb2FkIHN1cHBvcnQKPiAK
PiAgRG9jdW1lbnRhdGlvbi9BQkkvc3RhYmxlL3N5c2ZzLWJsb2NrIHwgIDgzICsrKysrKysKPiAg
YmxvY2svYmxrLWxpYi5jICAgICAgICAgICAgICAgICAgICAgIHwgMzU4ICsrKysrKysrKysrKysr
KysrKysrKysrKysrKwo+ICBibG9jay9ibGstbWFwLmMgICAgICAgICAgICAgICAgICAgICAgfCAg
IDIgKy0KPiAgYmxvY2svYmxrLXNldHRpbmdzLmMgICAgICAgICAgICAgICAgIHwgIDU5ICsrKysr
Cj4gIGJsb2NrL2Jsay1zeXNmcy5jICAgICAgICAgICAgICAgICAgICB8IDEzOCArKysrKysrKysr
Kwo+ICBibG9jay9ibGsuaCAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDIgKwo+ICBibG9j
ay9pb2N0bC5jICAgICAgICAgICAgICAgICAgICAgICAgfCAgMzIgKysrCj4gIGRyaXZlcnMvbWQv
ZG0ta2NvcHlkLmMgICAgICAgICAgICAgICB8ICA1NSArKystCj4gIGRyaXZlcnMvbWQvZG0tbGlu
ZWFyLmMgICAgICAgICAgICAgICB8ICAgMSArCj4gIGRyaXZlcnMvbWQvZG0tdGFibGUuYyAgICAg
ICAgICAgICAgICB8ICA0NSArKysrCj4gIGRyaXZlcnMvbWQvZG0uYyAgICAgICAgICAgICAgICAg
ICAgICB8ICAgNiArCj4gIGRyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYyAgICAgICAgICAgICB8IDEx
NiArKysrKysrKy0KPiAgZHJpdmVycy9udm1lL2hvc3QvZmMuYyAgICAgICAgICAgICAgIHwgICA0
ICsKPiAgZHJpdmVycy9udm1lL2hvc3QvbnZtZS5oICAgICAgICAgICAgIHwgICA3ICsKPiAgZHJp
dmVycy9udm1lL2hvc3QvcGNpLmMgICAgICAgICAgICAgIHwgIDI1ICsrCj4gIGRyaXZlcnMvbnZt
ZS9ob3N0L3JkbWEuYyAgICAgICAgICAgICB8ICAgNiArCj4gIGRyaXZlcnMvbnZtZS9ob3N0L3Rj
cC5jICAgICAgICAgICAgICB8ICAxNCArKwo+ICBkcml2ZXJzL252bWUvaG9zdC90cmFjZS5jICAg
ICAgICAgICAgfCAgMTkgKysKPiAgZHJpdmVycy9udm1lL3RhcmdldC9hZG1pbi1jbWQuYyAgICAg
IHwgICA4ICstCj4gIGRyaXZlcnMvbnZtZS90YXJnZXQvaW8tY21kLWJkZXYuYyAgICB8ICA2NSAr
KysrKwo+ICBkcml2ZXJzL252bWUvdGFyZ2V0L2lvLWNtZC1maWxlLmMgICAgfCAgNDkgKysrKwo+
ICBmcy96b25lZnMvc3VwZXIuYyAgICAgICAgICAgICAgICAgICAgfCAxNzggKysrKysrKysrKysr
LQo+ICBmcy96b25lZnMvem9uZWZzLmggICAgICAgICAgICAgICAgICAgfCAgIDEgKwo+ICBpbmNs
dWRlL2xpbnV4L2Jsa190eXBlcy5oICAgICAgICAgICAgfCAgMjEgKysKPiAgaW5jbHVkZS9saW51
eC9ibGtkZXYuaCAgICAgICAgICAgICAgIHwgIDE3ICsrCj4gIGluY2x1ZGUvbGludXgvZGV2aWNl
LW1hcHBlci5oICAgICAgICB8ICAgNSArCj4gIGluY2x1ZGUvbGludXgvbnZtZS5oICAgICAgICAg
ICAgICAgICB8ICA0MyArKystCj4gIGluY2x1ZGUvdWFwaS9saW51eC9mcy5oICAgICAgICAgICAg
ICB8ICAyMyArKwo+ICAyOCBmaWxlcyBjaGFuZ2VkLCAxMzY3IGluc2VydGlvbnMoKyksIDE1IGRl
bGV0aW9ucygtKQo+IAo+IAo+IGJhc2UtY29tbWl0OiBlN2Q2OTg3ZTA5YTMyOGQ0YTk0OTcwMWRi
NDBlZjYzZmJiOTcwNjcwCgoKLS0gCkRhbWllbiBMZSBNb2FsCldlc3Rlcm4gRGlnaXRhbCBSZXNl
YXJjaAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6
Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

