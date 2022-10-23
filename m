Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9324FA373F
	for <dm-devel@archiver.kernel.org>; Sun, 23 Oct 2022 22:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666562436;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MW4cawvDapv8NsD7RwaVbU7B4bvKMLv/PID0hAGQkw4=;
	b=a4uEaRnctBgd6+PWg1QUSwElHmXnCQpgvaXSTWJSXQT5G97UszB5RNawq6L05WL9qClwEg
	onjrldr/Y0FiJTzjM3iQCPPBiv4IOd/ZZU1YvTdeFVvc8sB63osufNqEgzCz0t92BAv48n
	tVLbgEiHWwK/zDeF2TKRFmq8TkxNcc8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-8Arrmj20P3Sq1Nz2hv5o3Q-1; Sun, 23 Oct 2022 18:00:33 -0400
X-MC-Unique: 8Arrmj20P3Sq1Nz2hv5o3Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D562185A583;
	Sun, 23 Oct 2022 22:00:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6DC5D40C6F9F;
	Sun, 23 Oct 2022 22:00:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5C7341946589;
	Sun, 23 Oct 2022 22:00:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 522DB1946587
 for <dm-devel@listman.corp.redhat.com>; Sun, 23 Oct 2022 22:00:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 31DA442222; Sun, 23 Oct 2022 22:00:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 29C3E17585
 for <dm-devel@redhat.com>; Sun, 23 Oct 2022 22:00:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AE54811E67
 for <dm-devel@redhat.com>; Sun, 23 Oct 2022 22:00:25 +0000 (UTC)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-196-R9lYL8OGOy6gx4qCm8YPkw-1; Sun, 23 Oct 2022 18:00:23 -0400
X-MC-Unique: R9lYL8OGOy6gx4qCm8YPkw-1
Received: by mail-pf1-f173.google.com with SMTP id g28so7528455pfk.8
 for <dm-devel@redhat.com>; Sun, 23 Oct 2022 15:00:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=hvIFbRsnY/vDy+taGpGboiBar50BevLz1lBfrbHmmSw=;
 b=1hi5GQlBNmbH1VVkOpsbClp15laogpxwzNjqyYXRScpnTaOyjEuyG64qyWj5BUC7Di
 cSVsrfFZ+lfdpcJrWwsGlQIeZXjcGTobW3w+7ReoKPRKm62z0z5OtVfwVAsx/D1BnXBO
 bRjqEO5VVszHrIo8GR8EKb3ELp97xyZrxGyItn1GkKPBvu5U7tYQqn8w6lbKU/05G3zZ
 yRqFSo7cq5YyQ7pFHdyOou1onwpJ6TGXzmjLkRjSn56dvjMHPak+PhFclqqk5/MSjJr7
 1SuELa7xOGSfu8mM7GBnmFAVlXIPikp4bXkHfN9a9d2Rmy1ci7+UXdv7tFszr5p7IjXY
 sUEg==
X-Gm-Message-State: ACrzQf1FqA4cMyI6UDH66fV8GspEgJf0TOU0Mf0DVeWnaaY25baiA0Mg
 l3JFK1DH2NlUvOkIPWg9CvbarF3rxXcjWg==
X-Google-Smtp-Source: AMsMyM5VwZrmUlSzb+1EZVG+tpjTbe3LySen3wNOfYDBTBo98hzEeyHHH/8b9UZAgnJ5FzV86+CCWw==
X-Received: by 2002:aa7:8011:0:b0:567:70cc:5b78 with SMTP id
 j17-20020aa78011000000b0056770cc5b78mr26373798pfi.29.1666562422001; 
 Sun, 23 Oct 2022 15:00:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au.
 [49.181.106.210]) by smtp.gmail.com with ESMTPSA id
 a3-20020aa78e83000000b0056beae3dee2sm14606pfr.145.2022.10.23.15.00.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 23 Oct 2022 15:00:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
 (envelope-from <david@fromorbit.com>)
 id 1omj10-005abc-AD; Mon, 24 Oct 2022 09:00:18 +1100
Date: Mon, 24 Oct 2022 09:00:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Message-ID: <20221023220018.GX3600936@dread.disaster.area>
References: <YyIBMJzmbZsUBHpy@magnolia>
 <a6e7f4eb-0664-bbe8-98d2-f8386b226113@fujitsu.com>
 <e3d51a6b-12e9-2a19-1280-5fd9dd64117c@fujitsu.com>
 <deb54a77-90d3-df44-1880-61cce6e3f670@fujitsu.com>
 <1444b9b5-363a-163c-0513-55d1ea951799@fujitsu.com>
 <Yzt6eWLuX/RTjmjj@magnolia>
 <f196bcab-6aa2-6313-8a7c-f8ab409621b7@fujitsu.com>
 <Yzx64zGt2kTiDYaP@magnolia>
 <6a83a56e-addc-f3c4-2357-9589a49bf582@fujitsu.com>
 <Y1NRNtToQTjs0Dbd@magnolia>
MIME-Version: 1.0
In-Reply-To: <Y1NRNtToQTjs0Dbd@magnolia>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH] xfs: fail dax mount if reflink is enabled on
 a partition
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
Cc: "hch@infradead.org" <hch@infradead.org>, toshi.kani@hpe.com,
 dm-devel@redhat.com, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 Brian Foster <bfoster@redhat.com>,
 =?utf-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 =?utf-8?B?UnVhbiwgU2hpeWFuZy/pmK4g5LiW6Ziz?= <ruansy.fnst@fujitsu.com>,
 =?utf-8?B?R290b3UsIFlhc3Vub3JpL+S6lOWztiDlurfmloc=?= <y-goto@fujitsu.com>,
 Jeff Moyer <jmoyer@redhat.com>, zwisler@kernel.org,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBPY3QgMjEsIDIwMjIgYXQgMDc6MTE6MDJQTSAtMDcwMCwgRGFycmljayBKLiBXb25n
IHdyb3RlOgo+IE9uIFRodSwgT2N0IDIwLCAyMDIyIGF0IDEwOjE3OjQ1UE0gKzA4MDAsIFlhbmcs
IFhpYW8v5p2oIOaZkyB3cm90ZToKPiA+IEluIGFkZGl0aW9uLCBJIGRvbid0IGxpa2UgeW91ciBp
ZGVhIGFib3V0IHRoZSB0ZXN0IGNoYW5nZSBiZWNhdXNlIGl0IHdpbGwKPiA+IG1ha2UgZ2VuZXJp
Yy80NzAgYmVjb21lIHRoZSBzcGVjaWFsIHRlc3QgZm9yIFhGUy4gRG8geW91IGtub3cgaWYgd2Ug
Y2FuIGZpeAo+ID4gdGhlIGlzc3VlIGJ5IGNoYW5naW5nIHRoZSB0ZXN0IGluIGFub3RoZXIgd2F5
PyBibGtkaXNjYXJkIC16IGNhbiBmaXggdGhlCj4gPiBpc3N1ZSBiZWNhdXNlIGl0IGRvZXMgemVy
by1maWxsIHJhdGhlciB0aGFuIGRpc2NhcmQgb24gdGhlIGJsb2NrIGRldmljZS4KPiA+IEhvd2V2
ZXIsIGJsa2Rpc2NhcmQgLXogd2lsbCB0YWtlIGEgbG90IG9mIHRpbWUgd2hlbiB0aGUgYmxvY2sg
ZGV2aWNlIGlzCj4gPiBsYXJnZS4KPiAKPiBXZWxsIHdlIC9jb3VsZC8ganVzdCBkbyB0aGF0IHRv
bywgYnV0IHRoYXQgd2lsbCBzdWNrIGlmIHlvdSBoYXZlIDJUQiBvZgo+IHBtZW0uIDspCj4gCj4g
TWF5YmUgYXMgYW4gYWx0ZXJuYXRpdmUgcGF0aCB3ZSBjb3VsZCBqdXN0IGNyZWF0ZSBhIHZlcnkg
c21hbGwKPiBmaWxlc3lzdGVtIG9uIHRoZSBwbWVtIGFuZCB0aGVuIGJsa2Rpc2NhcmQgLXogaXQ/
Cj4gCj4gVGhhdCBzYWlkIC0tIGRvZXMgcGVyc2lzdGVudCBtZW1vcnkgYWN0dWFsbHkgaGF2ZSBh
IGZ1dHVyZT8gIEludGVsCj4gc2N1dHRsZWQgdGhlIGVudGlyZSBPcHRhbmUgcHJvZHVjdCwgY3hs
Lm1lbSBzb3VuZHMgbGlrZSBleHBhbnNpb24KPiBjaGFzc2lzIGZ1bGwgb2YgRFJBTSwgYW5kIGZz
ZGF4IGlzIGhvcnJpYmx5IGJyb2tlbiBpbiA2LjAgKHdlaXJkIGtlcm5lbAo+IGFzc2VydHMgZXZl
cnl3aGVyZSkgYW5kIDYuMSAoZXZlcnkgdGltZSBJIHJ1biBmc3Rlc3RzIG5vdyBJIHNlZSBtYXNz
aXZlCj4gZGF0YSBjb3JydXB0aW9uKS4KCll1cCwgSSBzZWUgdGhlIHNhbWUgdGhpbmcuIGZzZGF4
IHdhcyBhIHRyYWluIHdyZWNrIGluIDYuMCAtIGJyb2tlbgpvbiBib3RoIGV4dDQgYW5kIFhGUy4g
Tm93IHRoYXQgSSBydW4gYSBxdWljayBjaGVjayBvbiA2LjEtcmMxLCBJCmRvbid0IHRoaW5rIHRo
YXQgaGFzIGNoYW5nZWQgYXQgYWxsIC0gSSBzdGlsbCBzZWUgbG90cyBvZiBrZXJuZWwKd2Fybmlu
Z3MsIGRhdGEgY29ycnVwdGlvbiBhbmQgIlhGU19JT0NfQ0xPTkVfUkFOR0U6IEludmFsaWQKYXJn
dW1lbnQiIGVycm9ycy4KCklmIEkgdHVybiBvZmYgcmVmbGluaywgdGhlbiBpbnN0ZWFkIG9mIGRh
dGEgY29ycnVwdGlvbiBJIGdldCBrZXJuZWwKd2FybmluZ3MgbGlrZSB0aGlzIGZyb20gZnN4IGFu
ZCBmc3N0cmVzcyB3b3JrbG9hZHM6CgpbNDE1NDc4LjU1ODQyNl0gLS0tLS0tLS0tLS0tWyBjdXQg
aGVyZSBdLS0tLS0tLS0tLS0tCls0MTU0NzguNTYwNTQ4XSBXQVJOSU5HOiBDUFU6IDEyIFBJRDog
MTUxNTI2MCBhdCBmcy9kYXguYzozODAgZGF4X2luc2VydF9lbnRyeSsweDJhNS8weDMyMApbNDE1
NDc4LjU2NDAyOF0gTW9kdWxlcyBsaW5rZWQgaW46Cls0MTU0NzguNTY1NDg4XSBDUFU6IDEyIFBJ
RDogMTUxNTI2MCBDb21tOiBmc3ggVGFpbnRlZDogRyAgICAgICAgVyA2LjEuMC1yYzEtZGdjKyAj
MTYxNQpbNDE1NDc4LjU2OTIyMV0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0
MEZYICsgUElJWCwgMTk5NiksIEJJT1MgMS4xNS4wLTEgMDQvMDEvMjAxNApbNDE1NDc4LjU3Mjg3
Nl0gUklQOiAwMDEwOmRheF9pbnNlcnRfZW50cnkrMHgyYTUvMHgzMjAKWzQxNTQ3OC41NzQ5ODBd
IENvZGU6IDA4IDQ4IDgzIGM0IDMwIDViIDVkIDQxIDVjIDQxIDVkIDQxIDVlIDQxIDVmIGMzIDQ4
IDhiIDU4IDIwIDQ4IDhkIDUzIDAxIGU5IDY1IGZmIGZmIGZmIDQ4IDhiIDU4IDIwIDQ4IDhkIDUz
IDAxIGU5IDUwIGZmIGZmIGZmIDwwZj4gMGIgZTkgNzAgZmYgZmYgZmYgMzEgZjYgNGMgODkgZTcg
ZTggZGEgZWUgYTcgMDAgZWIgYTQgNDggODEgZTYKWzQxNTQ3OC41ODI3NDBdIFJTUDogMDAwMDpm
ZmZmYzkwMDAyODY3YjcwIEVGTEFHUzogMDAwMTAwMDIKWzQxNTQ3OC41ODQ3MzBdIFJBWDogZmZm
ZmVhMDAwZjBkMDgwMCBSQlg6IDAwMDAwMDAwMDAwMDAwMDEgUkNYOiAwMDAwMDAwMDAwMDAwMDAx
Cls0MTU0NzguNTg3NDg3XSBSRFg6IGZmZmZlYTAwMDAwMDAwMDAgUlNJOiAwMDAwMDAwMDAwMDAw
MDNhIFJESTogZmZmZmVhMDAwZjBkMDg0MApbNDE1NDc4LjU5MDEyMl0gUkJQOiAwMDAwMDAwMDAw
MDAwMDExIFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKWzQxNTQ3
OC41OTIzODBdIFIxMDogZmZmZjg4ODgwMGRjOWMxOCBSMTE6IDAwMDAwMDAwMDAwMDAwMDEgUjEy
OiBmZmZmYzkwMDAyODY3YzU4Cls0MTU0NzguNTk0ODY1XSBSMTM6IGZmZmY4ODg4MDBkYzljMTgg
UjE0OiBmZmZmYzkwMDAyODY3ZTE4IFIxNTogMDAwMDAwMDAwMDAwMDAwMApbNDE1NDc4LjU5Njk4
M10gRlM6ICAwMDAwN2ZkNzE5ZmEyYjgwKDAwMDApIEdTOmZmZmY4ODg4M2VjMDAwMDAoMDAwMCkg
a25sR1M6MDAwMDAwMDAwMDAwMDAwMApbNDE1NDc4LjU5OTM2NF0gQ1M6ICAwMDEwIERTOiAwMDAw
IEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzMwpbNDE1NDc4LjYwMDkwNV0gQ1IyOiAwMDAw
N2ZkNzFhMWFkNjQwIENSMzogMDAwMDAwMDVjZjI0MTAwNiBDUjQ6IDAwMDAwMDAwMDAwNjBlZTAK
WzQxNTQ3OC42MDI4ODNdIENhbGwgVHJhY2U6Cls0MTU0NzguNjAzNTk4XSAgPFRBU0s+Cls0MTU0
NzguNjA0MjI5XSAgZGF4X2ZhdWx0X2l0ZXIrMHgyNDAvMHg2MDAKWzQxNTQ3OC42MDU0MTBdICBk
YXhfaW9tYXBfcHRlX2ZhdWx0KzB4MTljLzB4M2QwCls0MTU0NzguNjA2NzA2XSAgX194ZnNfZmls
ZW1hcF9mYXVsdCsweDFkZC8weDJiMApbNDE1NDc4LjYwNzc0NF0gIF9fZG9fZmF1bHQrMHgyZS8w
eDFkMApbNDE1NDc4LjYwODU4N10gIF9faGFuZGxlX21tX2ZhdWx0KzB4Y2VjLzB4MTdiMApbNDE1
NDc4LjYwOTU5M10gIGhhbmRsZV9tbV9mYXVsdCsweGQwLzB4MmEwCls0MTU0NzguNjEwNTE3XSAg
ZXhjX3BhZ2VfZmF1bHQrMHgxZDkvMHg4MTAKWzQxNTQ3OC42MTEzOThdICBhc21fZXhjX3BhZ2Vf
ZmF1bHQrMHgyMi8weDMwCls0MTU0NzguNjEyMzExXSBSSVA6IDAwMzM6MHg3ZmQ3MWEwNGI5YmEK
WzQxNTQ3OC42MTMxNjhdIENvZGU6IDRkIDI5IGMxIDRjIDI5IGMyIDQ4IDNiIDE1IGRiIDk1IDEx
IDAwIDBmIDg3IGFmIDAwIDAwIDAwIDBmIDEwIDAxIDBmIDEwIDQ5IGYwIDBmIDEwIDUxIGUwIDBm
IDEwIDU5IGQwIDQ4IDgzIGU5IDQwIDQ4IDgzIGVhIDQwIDw0MT4gMGYgMjkgMDEgNDEgMGYgMjkg
NDkgZjAgNDEgMGYgMjkgNTEgZTAgNDEgMGYgMjkgNTkgZDAgNDkgODMgZTkKWzQxNTQ3OC42MTcw
ODNdIFJTUDogMDAyYjowMDAwN2ZmY2YyNzdiZTE4IEVGTEFHUzogMDAwMTAyMDYKWzQxNTQ3OC42
MTgyMTNdIFJBWDogMDAwMDdmZDcxYTFhM2ZjNSBSQlg6IDAwMDAwMDAwMDAwMDBmYzUgUkNYOiAw
MDAwN2ZkNzE5ZjVhNjEwCls0MTU0NzguNjE5ODU0XSBSRFg6IDAwMDAwMDAwMDAwMDk2NGIgUlNJ
OiAwMDAwN2ZkNzE5ZjUwZmQ1IFJESTogMDAwMDdmZDcxYTFhM2ZjNQpbNDE1NDc4LjYyMTI4Nl0g
UkJQOiAwMDAwMDAwMDAwMDMwZmM1IFIwODogMDAwMDAwMDAwMDAwMDAwZSBSMDk6IDAwMDA3ZmQ3
MWExYWQ2NDAKWzQxNTQ3OC42MjI3MzBdIFIxMDogMDAwMDAwMDAwMDAwMDAwMSBSMTE6IDAwMDA3
ZmQ3MWExYWQ2NGUgUjEyOiAwMDAwMDAwMDAwMDA5Njk5Cls0MTU0NzguNjI0MTY0XSBSMTM6IDAw
MDAwMDAwMDAwMGE2NWUgUjE0OiAwMDAwN2ZkNzFhMWEzMDAwIFIxNTogMDAwMDAwMDAwMDAwMDAw
MQpbNDE1NDc4LjYyNTYwMF0gIDwvVEFTSz4KWzQxNTQ3OC42MjYwODddIC0tLVsgZW5kIHRyYWNl
IDAwMDAwMDAwMDAwMDAwMDAgXS0tLQoKRXZlbiBnZW5lcmljLzI0NyBpcyBnZW5lcmF0aW5nIGEg
d2FybmluZyBsaWtlIHRoaXMgZnJvbSB4ZnNfaW8sCndoaWNoIGlzIGEgbW1hcCB2cyBESU8gcmFj
ZXIuIEdpdmVuIHRoYXQgRElPIGRvZXNuJ3QgZXhpc3QgZm9yCmZzZGF4LCB0aGlzIHRlc3QgdHVy
bnMgaW50byBqdXN0IGEgbm9ybWFsIHdyaXRlKCkgdnMgbW1hcCgpIHJhY2VyLgoKR2l2ZW4gdGhl
c2UgYXJlIHRoZSBzYW1lIGZzZGF4IGluZnJhc3RydWN0dXJlIGZhaWx1cmVzIHRoYXQgSQpyZXBv
cnRlZCBmb3IgNi4wLCBpdCBpcyBhbHNvIGxpa2VseSB0aGF0IGV4dDQgaXMgc3RpbGwgdGhyb3dp
bmcKdGhlbS4gSU9Xcywgd2hhdGV2ZXIgZ290IGJyb2tlIGluIHRoZSA2LjAgY3ljbGUgd2Fzbid0
IGZpeGVkIGluIHRoZQo2LjEgY3ljbGUuCgo+IEZyYW5rbHkgYXQgdGhpcyBwb2ludCBJJ20gdGVt
cHRlZCBqdXN0IHRvIHR1cm4gb2YgZnNkYXggc3VwcG9ydCBmb3IgWEZTCj4gZm9yIHRoZSA2LjEg
TFRTIGJlY2F1c2UgSSBkb24ndCBoYXZlIHRpbWUgdG8gZml4IGl0LgoKL21lIHNocnVncwoKQmFj
a3BvcnRpbmcgZml4ZXMgKHdoZW5ldmVyIHRoZXkgY29tZSBhbG9uZykgaXMgYSBwcm9ibGVtIGZv
ciB0aGUKTFRTIGtlcm5lbCBtYWludGFpbmVyIHRvIGRlYWwgd2l0aCwgbm90IHRoZSB1cHN0cmVh
bSBtYWludGFpbmVyLgoKSU1PLCB0aGUgaXNzdWUgcmlnaHQgbm93IGlzIHRoYXQgdGhlIERBWCBt
YWludGFpbmVycyBzZWVtIHRvIGhhdmUKbGl0dGxlIGludGVyZXN0IGluIGVuc3VyaW5nIHRoYXQg
dGhlIEZTREFYIGluZnJhc3RydWN0dXJlIGFjdHVhbGx5CndvcmtzIGNvcnJlY3RseS4gSWYgYW55
dGhpbmcsIHRoZXkgc2VlbSB0byB3YW50IHRvIG1ha2UgdGhpbmdzCmhhcmRlciBmb3IgYmxvY2sg
YmFzZWQgZmlsZXN5c3RlbXMgdG8gdXNlIHBtZW0gZGV2aWNlcyBhbmQgaGVuY2UKRlNEQVguIGUu
Zy4gdGhlIGRpcmVjdGlvbiBvZiB0aGUgREFYIGNvcmUgYXdheSBmcm9tIGJsb2NrIGludGVyZmFj
ZXMKdGhhdCBmaWxlc3lzdGVtcyBuZWVkIGZvciB0aGVpciB1c2Vyc3BhY2UgdG9vbHMgdG8gbWFu
YWdlIHRoZQpzdG9yYWdlLgoKQXQgd2hhdCBwb2ludCBkbyB3ZSBzaW1wbHkgc2F5ICJ0aGUgZXhw
ZXJpbWVudCBmYWlsZWQsIEZTREFYIGlzCmRlYWQiIGFuZCByZW1vdmUgaXQgZnJvbSBYRlMgYWx0
b2dldGhlcj8KCkNoZWVycywKCkRhdmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0
LmNvbQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6
Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

