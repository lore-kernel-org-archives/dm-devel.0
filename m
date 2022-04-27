Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AA26C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 22:05:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-VHGq-gJ2MrKKkR5iK_szdg-1; Wed, 27 Apr 2022 18:05:43 -0400
X-MC-Unique: VHGq-gJ2MrKKkR5iK_szdg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C258811E76;
	Wed, 27 Apr 2022 22:05:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 59F1CC2813B;
	Wed, 27 Apr 2022 22:05:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F1B4E1947046;
	Wed, 27 Apr 2022 22:05:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ECD001947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 22:05:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 97535407E1C1; Wed, 27 Apr 2022 22:05:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 92C9F407E1C0
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 22:05:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AB271C04B67
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 22:05:38 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-ynR3iqkbNFKFiL_LbJlkhw-1; Wed, 27 Apr 2022 18:05:36 -0400
X-MC-Unique: ynR3iqkbNFKFiL_LbJlkhw-1
X-IronPort-AV: E=Sophos;i="5.90,294,1643644800"; d="scan'208";a="198996974"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2022 06:05:34 +0800
IronPort-SDR: lMozZFKkN8Z3NpYloOPFW/yuLbXhriKmq1zvtAOXXEe8XsebpDp/t3EmmaXAb0LpripYbDvnTZ
 E0skQbhjvYY/HvxzAiy9rSg7F2XjEn6N/MWQWDcMjEmJAd5XnxodmgLAuplzQEd2nQCYNsOZvi
 xuWD+8ug4ok4o9YO2MFRizewbE11IIxV7sSrg7kMkX8sLUdAhvYpLfc/V8QlD6y+Z9wCSljvAe
 ivdKDw9VG6Xg3Du0srgvZdIWh/E3BJeHkuW9LXybKS3Af35AWdCwVoXAiNePgbwsomTpnxwmMT
 4cCssfmlrAOvxb6yUTiBb0NM
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Apr 2022 14:35:44 -0700
IronPort-SDR: GVZPB4ECRsMCS+e0IZDNmWN0cc1eNwM2zHETjDPE1cudtSCbQdOGMdIGoXJLkPiL/kpOkl5s5N
 h7kWZiB8nliNkG5rB35zaYMIgD0hs5eL5sEI7yGMc4pVp2OaW/3VmJUR0lCJP5j1qDf5me/8mH
 qW9pvMwmkA7icdwFhWJDpyMVzgmY7hBqU7hqbpSwB+M67eKKwTPivO89EqoIzP8fHf3wBqndlt
 YPg6DrQSstg7F2OMrVe2YguU3gs6EpoFNju6y4D7NNAzDwYpOzcv8hcX0nbVajzh6X2+JSQoYD
 QWo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Apr 2022 15:05:35 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KpXqy5Y39z1Rvlx
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 15:05:34 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id gxEomG5vHcOP for <dm-devel@redhat.com>;
 Wed, 27 Apr 2022 15:05:34 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KpXqx1gFtz1Rvlc;
 Wed, 27 Apr 2022 15:05:33 -0700 (PDT)
Message-ID: <c285f0da-ab1d-2b24-e5a4-21193ef93155@opensource.wdc.com>
Date: Thu, 28 Apr 2022 07:05:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8yNy8yMiAyMTo0OSwgTml0ZXNoIFNoZXR0eSB3cm90ZToKPiBPIFdlZCwgQXByIDI3LCAy
MDIyIGF0IDExOjE5OjQ4QU0gKzA5MDAsIERhbWllbiBMZSBNb2FsIHdyb3RlOgo+PiBPbiA0LzI2
LzIyIDE5OjEyLCBOaXRlc2ggU2hldHR5IHdyb3RlOgo+Pj4gVGhlIHBhdGNoIHNlcmllcyBjb3Zl
cnMgdGhlIHBvaW50cyBkaXNjdXNzZWQgaW4gTm92ZW1iZXIgMjAyMSB2aXJ0dWFsIGNhbGwKPj4+
IFtMU0YvTU0vQkZQIFRPUElDXSBTdG9yYWdlOiBDb3B5IE9mZmxvYWRbMF0uCj4+PiBXZSBoYXZl
IGNvdmVyZWQgdGhlIEluaXRpYWwgYWdyZWVkIHJlcXVpcmVtZW50cyBpbiB0aGlzIHBhdGNoc2V0
Lgo+Pj4gUGF0Y2hzZXQgYm9ycm93cyBNaWt1bGFzJ3MgdG9rZW4gYmFzZWQgYXBwcm9hY2ggZm9y
IDIgYmRldgo+Pj4gaW1wbGVtZW50YXRpb24uCj4+Pgo+Pj4gT3ZlcmFsbCBzZXJpZXMgc3VwcG9y
dHMg4oCTCj4+Pgo+Pj4gMS4gRHJpdmVyCj4+PiAtIE5WTWUgQ29weSBjb21tYW5kIChzaW5nbGUg
TlMpLCBpbmNsdWRpbmcgc3VwcG9ydCBpbiBudm1lLXRhcmdldCAoZm9yCj4+PiAgICAgYmxvY2sg
YW5kIGZpbGUgYmFja2VuZCkKPj4KPj4gSXQgd291bGQgYWxzbyBiZSBuaWNlIHRvIGhhdmUgY29w
eSBvZmZsb2FkIGVtdWxhdGlvbiBpbiBudWxsX2JsayBmb3IgdGVzdGluZy4KPj4KPiAKPiBXZSBj
YW4gcGxhbiB0aGlzIGluIG5leHQgcGhhc2Ugb2YgY29weSBzdXBwb3J0LCBvbmNlIHRoaXMgc2Vy
aWVzIHNldHRsZXMgZG93bi4KClNvIGhvdyBjYW4gcGVvcGxlIHRlc3QgeW91ciBzZXJpZXMgPyBO
b3QgYSBsb3Qgb2YgZHJpdmVzIG91dCB0aGVyZSB3aXRoCmNvcHkgc3VwcG9ydC4KCj4gCj4gLS0K
PiBOaXRlc2ggU2hldHR5Cj4gCj4gCgoKLS0gCkRhbWllbiBMZSBNb2FsCldlc3Rlcm4gRGlnaXRh
bCBSZXNlYXJjaAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20K
aHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

