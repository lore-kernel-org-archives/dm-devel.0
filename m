Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 579CEC77B75
	for <dm-devel@archiver.kernel.org>; Fri, 12 May 2023 17:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683913283;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=imumuBwKiVAHcqTYLSTT9Ag98JSlalqqelIfL09XwIo=;
	b=GEry6qMpcS6R540hvrTH3pNgPL2oWpD1QtqWW2QNXrXoRh/9zLdpfvH4PXH59DLZqiO2Pz
	J3Vd6grefxpXngVK9VFoN+CofUoSoE3Tsw8kgSw0DKvYNMuDGNwpJyyB2kQs3xTToidom6
	hHBvFlMB93dUQWj/BqkAvAQLt9o3MzU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-uAsLOdkHPcWA4urngBHtOQ-1; Fri, 12 May 2023 13:41:20 -0400
X-MC-Unique: uAsLOdkHPcWA4urngBHtOQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1183138035CF;
	Fri, 12 May 2023 17:41:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B0967C15BA0;
	Fri, 12 May 2023 17:41:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7819719451E4;
	Fri, 12 May 2023 17:41:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 44C7F19451E3
 for <dm-devel@listman.corp.redhat.com>; Fri, 12 May 2023 17:41:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D0F75C16024; Fri, 12 May 2023 17:41:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C85F4C15BA0
 for <dm-devel@redhat.com>; Fri, 12 May 2023 17:41:17 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A61F71C05EAD
 for <dm-devel@redhat.com>; Fri, 12 May 2023 17:41:17 +0000 (UTC)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com
 [209.85.167.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208-51vHFuEDOWGi1JCsu4m5NQ-1; Fri, 12 May 2023 13:41:14 -0400
X-MC-Unique: 51vHFuEDOWGi1JCsu4m5NQ-1
Received: by mail-lf1-f50.google.com with SMTP id
 2adb3069b0e04-4eed764a10cso11470046e87.0
 for <dm-devel@redhat.com>; Fri, 12 May 2023 10:41:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1683913273; x=1686505273;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=c53hysGkM2xBX5c8rx+/87DIDalv/+dKSalszt64gww=;
 b=Q5ZhZ7jHCJA2zAziYNJnFk3e8WiUzFhwkGLfvEFkEoMmuXamxdONfm8DiQ4Wyiswys
 A4wFrfDc7++cv+wllSXMqJiycvBYpwS4sBJSQ7eNmcHLp+T2Emvg0nayi9KfzV8D8Vp2
 YBKexwTb1p+igvIm0fNwKlvi0vHjcDW1AqodhaRnmR+dPLUoG7UbSDWkBvJtHl8xiNfe
 tx7vEUPETk/976txCxXV5OjYokYYbinbISJ1vSmuDLi69AALQOkITBCMRu6qYCj2R105
 erHJ+E8K4t4yT2P13ixDr6JYbcR6WRzN2tuMjgQElv/WDndrNEr0WaN72v2Q3RRG7yGT
 Lp5g==
X-Gm-Message-State: AC+VfDwDw+BkUt04Qer1DS53aq8GMSBHUGFKgIVZXIGpcFAuaMLeWz/d
 1HrQI+tkL7XHNb+GMylvtoL8u8cQODOzN0+Pa2DnMEgNAK6duQ==
X-Google-Smtp-Source: ACHHUZ5mqEY1EG6WWwsI3DDeOBIEVLuHpgUUtelb/U9Ro7CrqhCtkb3eLSDINVo+82KwFNdE7tuuLYSNS8VzL/P1ZdI=
X-Received: by 2002:ac2:592b:0:b0:4ec:5b62:1b46 with SMTP id
 v11-20020ac2592b000000b004ec5b621b46mr3869310lfi.33.1683913272790; Fri, 12
 May 2023 10:41:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAF1ivSZJjVq313Zg9nBF0S3DOun=-Vw8saZGPU5cGrB_woM-8g@mail.gmail.com>
 <2aafd5fc-26b4-fa82-4149-a72adf6722b9@suse.de>
In-Reply-To: <2aafd5fc-26b4-fa82-4149-a72adf6722b9@suse.de>
From: Ming Lin <minggr@gmail.com>
Date: Fri, 12 May 2023 10:41:01 -0700
Message-ID: <CAF1ivSaVEr_q9eN0_UpYTdDRsDcVjC17pbVUKbv_X1A3gSKDKw@mail.gmail.com>
To: Hannes Reinecke <hare@suse.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] Does dm-zoned support buffered write?
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBNYXkgMTEsIDIwMjMgYXQgMTE6NTbigK9BTSBIYW5uZXMgUmVpbmVja2UgPGhhcmVA
c3VzZS5kZT4gd3JvdGU6Cj4KPiBPbiA1LzExLzIzIDIwOjQxLCBNaW5nIExpbiB3cm90ZToKPiA+
IEhpIGxpc3QsCj4gPgo+ID4gSSBoYXZlIGFuIGFwcGxpY2F0aW9uIHRoYXQgbmVlZHMgdG8gdXNl
IGJ1ZmZlcmVkX2lvIHRvIGFjY2VzcyBTTVIgZGlzawo+ID4gZm9yIGdvb2QgcGVyZm9ybWFuY2Uu
Cj4gPgo+ID4gIEZyb20gIlpCRCBTdXBwb3J0IFJlc3RyaWN0aW9ucyIgYXQgaHR0cHM6Ly96b25l
ZHN0b3JhZ2UuaW8vZG9jcy9saW51eC9vdmVydmlldwo+ID4gIgo+ID4gRGlyZWN0IElPIFdyaXRl
cyBUaGUga2VybmVsIHBhZ2UgY2FjaGUgZG9lcyBub3QgZ3VhcmFudGVlIHRoYXQgY2FjaGVkCj4g
PiBkaXJ0eSBwYWdlcyB3aWxsIGJlIGZsdXNoZWQgdG8gYSBibG9jayBkZXZpY2UgaW4gc2VxdWVu
dGlhbCBzZWN0b3IKPiA+IG9yZGVyLiBUaGlzIGNhbiBsZWFkIHRvIHVuYWxpZ25lZCB3cml0ZSBl
cnJvcnMgaWYgYW4gYXBwbGljYXRpb24gdXNlcwo+ID4gYnVmZmVyZWQgd3JpdGVzIHRvIHdyaXRl
IHRvIHRoZSBzZXF1ZW50aWFsIHdyaXRlIHJlcXVpcmVkIHpvbmVzIG9mIGEKPiA+IGRldmljZS4g
VG8gYXZvaWQgdGhpcyBwaXRmYWxsLCBhcHBsaWNhdGlvbnMgdGhhdCBkaXJlY3RseSB1c2UgYSB6
b25lZAo+ID4gYmxvY2sgZGV2aWNlIHdpdGhvdXQgYSBmaWxlIHN5c3RlbSBzaG91bGQgYWx3YXlz
IHVzZSBkaXJlY3QgSS9PCj4gPiBvcGVyYXRpb25zIHRvIHdyaXRlIHRvIHRoZSBzZXF1ZW50aWFs
IHdyaXRlIHJlcXVpcmVkIHpvbmVzIG9mIGEKPiA+IGhvc3QtbWFuYWdlZCBkaXNrICh0aGF0IGlz
LCB0aGV5IHNob3VsZCBpc3N1ZSB3cml0ZSgpIHN5c3RlbSBjYWxscwo+ID4gd2l0aCBhIGJsb2Nr
IGRldmljZSAiZmlsZSBvcGVuIiB0aGF0IHVzZXMgdGhlIE9fRElSRUNUIGZsYWcpLgo+ID4gIgo+
ID4KPiA+IFJhdyB6YmQgZGlzayBvbmx5IHN1cHBvcnRzIGRpcmVjdF9pby4KPiA+Cj4gPiBEb2Vz
IGRtLXpvbmVkIHN1cHBvcnQgYnVmZmVyZWQgaW8gKHdpdGhvdXQgT19ESVJFQ1QpPwo+ID4KPiBZ
ZXMuIEJ1dCBJIF90aGlua18gdGhlIGFib3ZlIHBhcmFncmFwaCBpcyBldmVyIHNvIHNsaWdodGx5
IG91dGRhdGVkLCBhcwo+IHdlJ3ZlIHNwZW50IHF1aXRlIGEgbG90IG9mIHRpbWUgZml4aW5nIHNl
cXVlbnRpYWwgd3JpdGVzIChjZiBibGstem9uZWQKPiBldGMpLiBTbyB3aGlsZSBkbS16b25lZCBp
cyB1c2luZyBidWZmZXJldCB3cml0ZXMgdGhlcmUgd29uJ3QgYmUgYW55Cj4gc2VxdWVudGlhbCB3
cml0ZSBpc3N1ZXMuCj4KPiBBdCBsZWFzdCwgSSBoYXZlIG5vdCB1bmNvdmVyZWQgYW55IG9mIHRo
b3NlIGR1cmluZyB0ZXN0aW5nLgoKSGkgSGFubmVzLAoKSSB1c2UgNS4xMC45MCBrZXJuZWwgYW5k
IHNtciBkaXNrIGNhcGFjaXR5IGlzIDI0VC4KSSBmb2xsb3dlZCB0aGUgYmVsb3cgZ3VpZGUgdG8g
Y3JlYXRlIGRtX3pvbmUgZGV2aWNlIG9uIHRvcCBvZiBzbXIgZGlzay4KaHR0cHM6Ly96b25lZHN0
b3JhZ2UuaW8vZG9jcy9saW51eC9kbQoKVGhlbiBta2ZzLmV4dDQgL2Rldi9kbS0wLCBidXQgaXQg
c2VlbXMgaHVuZy4KQW55IGlkZWFzPwoKWzM3NTUyLjIxNzQ3Ml0gZGV2aWNlLW1hcHBlcjogdWV2
ZW50OiB2ZXJzaW9uIDEuMC4zClszNzU1Mi4yMTc1NDldIGRldmljZS1tYXBwZXI6IGlvY3RsOiA0
LjQzLjAtaW9jdGwgKDIwMjAtMTAtMDEpCmluaXRpYWxpc2VkOiBkbS1kZXZlbEByZWRoYXQuY29t
ClszNzU3NS42MDg1MDBdIGRldmljZS1tYXBwZXI6IHpvbmVkIG1ldGFkYXRhOiAoZG16LTUwMDBj
Y2EyYmZjMGRiMjEpOgpETS1ab25lZCBtZXRhZGF0YSB2ZXJzaW9uIDIKWzM3NTc1LjYwODUwMl0g
ZGV2aWNlLW1hcHBlcjogem9uZWQgbWV0YWRhdGE6IChzZHgpOiBIb3N0LW1hbmFnZWQKem9uZWQg
YmxvY2sgZGV2aWNlClszNzU3NS42MDg1MDNdIGRldmljZS1tYXBwZXI6IHpvbmVkIG1ldGFkYXRh
OiAoc2R4KTogICA1MDc4MjUzNTY4MAo1MTItYnl0ZSBsb2dpY2FsIHNlY3RvcnMgKG9mZnNldCAw
KQpbMzc1NzUuNjA4NTAzXSBkZXZpY2UtbWFwcGVyOiB6b25lZCBtZXRhZGF0YTogKHNkeCk6ICAg
OTY4NjAgem9uZXMgb2YKNTI0Mjg4IDUxMi1ieXRlIGxvZ2ljYWwgc2VjdG9ycyAob2Zmc2V0IDAp
ClszNzU3NS42MDg1MDRdIGRldmljZS1tYXBwZXI6IHpvbmVkIG1ldGFkYXRhOiAoZG16LTUwMDBj
Y2EyYmZjMGRiMjEpOgogOTY4NjAgem9uZXMgb2YgNTI0Mjg4IDUxMi1ieXRlIGxvZ2ljYWwgc2Vj
dG9ycwpbMzc1NzUuNjA5MjA0XSBkZXZpY2UtbWFwcGVyOiB6b25lZDogKGRtei01MDAwY2NhMmJm
YzBkYjIxKTogVGFyZ2V0CmRldmljZTogNTA3NzEwMDEzNDQgNTEyLWJ5dGUgbG9naWNhbCBzZWN0
b3JzICg2MzQ2Mzc1MTY4IGJsb2NrcykKWzM4MTAxLjU0MzM1M10gSU5GTzogdGFzayBta2ZzLmV4
dDQ6MTQxMTc5MSBibG9ja2VkIGZvciBtb3JlIHRoYW4gMTIyIHNlY29uZHMuClszODEwMS41NDMz
ODBdICAgICAgIFRhaW50ZWQ6IEcgICAgICAgICAgIE9FICAgICA1LjEwLjkwLmJtLjEtYW1kNjQr
ICMyClszODEwMS41NDMzOTVdICJlY2hvIDAgPiAvcHJvYy9zeXMva2VybmVsL2h1bmdfdGFza190
aW1lb3V0X3NlY3MiCmRpc2FibGVzIHRoaXMgbWVzc2FnZS4KWzM4MTAxLjU0MzQxMV0gdGFzazpt
a2ZzLmV4dDQgICAgICAgc3RhdGU6RCBzdGFjazogICAgMCBwaWQ6MTQxMTc5MQpwcGlkOjEzODg2
NjAgZmxhZ3M6MHgwMDAwNDAwMApbMzgxMDEuNTQzNDE1XSBDYWxsIFRyYWNlOgpbMzgxMDEuNTQz
NDIyXSAgX19zY2hlZHVsZSsweDNmZC8weDc2MApbMzgxMDEuNTQzNDI1XSAgc2NoZWR1bGUrMHg0
Ni8weGIwClszODEwMS41NDM0MjZdICBpb19zY2hlZHVsZSsweDEyLzB4NDAKWzM4MTAxLjU0MzQy
OV0gIHdhaXRfb25fcGFnZV9iaXQrMHgxMzMvMHgyNzAKWzM4MTAxLjU0MzQzMV0gID8gX19wYWdl
X2NhY2hlX2FsbG9jKzB4YTAvMHhhMApbMzgxMDEuNTQzNDMyXSAgd2FpdF9vbl9wYWdlX3dyaXRl
YmFjaysweDI1LzB4NzAKWzM4MTAxLjU0MzQzNF0gIF9fZmlsZW1hcF9mZGF0YXdhaXRfcmFuZ2Ur
MHg4Ni8weGYwClszODEwMS41NDM0MzVdICBmaWxlX3dyaXRlX2FuZF93YWl0X3JhbmdlKzB4NzQv
MHhiMApbMzgxMDEuNTQzNDM4XSAgYmxrZGV2X2ZzeW5jKzB4MTYvMHg0MApbMzgxMDEuNTQzNDQx
XSAgZG9fZnN5bmMrMHgzOC8weDYwClszODEwMS41NDM0NDJdICBfX3g2NF9zeXNfZnN5bmMrMHgx
MC8weDIwClszODEwMS41NDM0NDVdICBkb19zeXNjYWxsXzY0KzB4MmQvMHg3MApbMzgxMDEuNTQz
NDQ2XSAgZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4NDQvMHhhOQoKPT09CkJlbG93
IGFyZSB0aGUgc3RlcHMgSSBkaWQ6Cgpyb290QHNtcl9kZXY6fiMgYmxrem9uZSByZXNldCAvZGV2
L3NkeAoKcm9vdEBzbXJfZGV2On4jIGRtemFkbSAtLWZvcm1hdCAvZGV2L3NkeAovZGV2L3NkeDog
NTA3ODI1MzU2ODAgNTEyLWJ5dGUgc2VjdG9ycyAoMjQyMTUgR2lCKQogIEhvc3QtbWFuYWdlZCBk
ZXZpY2UKICA5Njg2MCB6b25lcywgb2Zmc2V0IDAKICA5Njg2MCB6b25lcyBvZiA1MjQyODggNTEy
LWJ5dGUgc2VjdG9ycyAoMjU2IE1pQikKICA2NTUzNiA0S0IgZGF0YSBibG9ja3MgcGVyIHpvbmUK
UmVzZXR0aW5nIHNlcXVlbnRpYWwgem9uZXMKV3JpdGluZyBwcmltYXJ5IG1ldGFkYXRhIHNldAog
IFdyaXRpbmcgbWFwcGluZyB0YWJsZQogIFdyaXRpbmcgYml0bWFwIGJsb2NrcwogIFdyaXRpbmcg
c3VwZXIgYmxvY2sgdG8gc2R4IGJsb2NrIDAKV3JpdGluZyBzZWNvbmRhcnkgbWV0YWRhdGEgc2V0
CiAgV3JpdGluZyBtYXBwaW5nIHRhYmxlCiAgV3JpdGluZyBiaXRtYXAgYmxvY2tzCiAgV3JpdGlu
ZyBzdXBlciBibG9jayB0byBzZHggYmxvY2sgMTk2NjA4ClN5bmNpbmcgZGlzawpEb25lLgoKcm9v
dEBzbXJfZGV2On4jIGRtemFkbSAtLXN0YXJ0IC9kZXYvc2R4Ci9kZXYvc2R4OiA1MDc4MjUzNTY4
MCA1MTItYnl0ZSBzZWN0b3JzICgyNDIxNSBHaUIpCiAgSG9zdC1tYW5hZ2VkIGRldmljZQogIDk2
ODYwIHpvbmVzLCBvZmZzZXQgMAogIDk2ODYwIHpvbmVzIG9mIDUyNDI4OCA1MTItYnl0ZSBzZWN0
b3JzICgyNTYgTWlCKQogIDY1NTM2IDRLQiBkYXRhIGJsb2NrcyBwZXIgem9uZQpzZHg6IHN0YXJ0
aW5nIGRtei01MDAwY2NhMmJmYzBkYjIxLCBtZXRhZGF0YSB2ZXIuIDIsIHV1aWQKNzQ5NWUyMWEt
MjNkOS00OWY0LTgzMmEtNzZiMzIxMzYwNzhiCgpyb290QHNtcl9kZXY6fiMgbWtmcy5leHQ0IC9k
ZXYvZG0tMApta2UyZnMgMS40NC41ICgxNS1EZWMtMjAxOCkKRGlzY2FyZGluZyBkZXZpY2UgYmxv
Y2tzOiBkb25lCkNyZWF0aW5nIGZpbGVzeXN0ZW0gd2l0aCA2MzQ2Mzc1MTY4IDRrIGJsb2NrcyBh
bmQgMzk2NjQ4NDQ4IGlub2RlcwpGaWxlc3lzdGVtIFVVSUQ6IGM0N2RlMDZkLTZjZjYtNGE4NS05
NTAyLTc4MzBjYTJmNDUyNgpTdXBlcmJsb2NrIGJhY2t1cHMgc3RvcmVkIG9uIGJsb2NrczoKICAg
ICAgICAzMjc2OCwgOTgzMDQsIDE2Mzg0MCwgMjI5Mzc2LCAyOTQ5MTIsIDgxOTIwMCwgODg0NzM2
LCAxNjA1NjMyLCAyNjU0MjA4LAogICAgICAgIDQwOTYwMDAsIDc5NjI2MjQsIDExMjM5NDI0LCAy
MDQ4MDAwMCwgMjM4ODc4NzIsIDcxNjYzNjE2LCA3ODY3NTk2OCwKICAgICAgICAxMDI0MDAwMDAs
IDIxNDk5MDg0OCwgNTEyMDAwMDAwLCA1NTA3MzE3NzYsIDY0NDk3MjU0NCwgMTkzNDkxNzYzMiwK
ICAgICAgICAyNTYwMDAwMDAwLCAzODU1MTIyNDMyLCA1ODA0NzUyODk2CgpBbGxvY2F0aW5nIGdy
b3VwIHRhYmxlczogZG9uZQpXcml0aW5nIGlub2RlIHRhYmxlczogZG9uZQpDcmVhdGluZyBqb3Vy
bmFsICgyNjIxNDQgYmxvY2tzKTogZG9uZQpXcml0aW5nIHN1cGVyYmxvY2tzIGFuZCBmaWxlc3lz
dGVtIGFjY291bnRpbmcgaW5mb3JtYXRpb246Cgo9PT0KQXQgYW5vdGhlciB0ZXJtaW5hbCwKCnJv
b3RAc21yX2Rldjp+IyBwcyBhdXggfCBncmVwIG1rZnMuZXh0NApyb290ICAgICAxNDExNzkxICAy
LjggIDAuMCAgMzA5OTIgMTk4NjQgcHRzLzEgICAgRCsgICAwMTozMCAgIDA6MDEKbWtmcy5leHQ0
IC9kZXYvZG0tMApyb290ICAgICAxNDEzNjQwICAwLjAgIDAuMCAgMTM5NzIgIDI0OTYgcHRzLzAg
ICAgUysgICAwMTozMSAgIDA6MDAKZ3JlcCBta2ZzLmV4dDQKCnJvb3RAc21yX2Rldjp+IyBjYXQg
L3Byb2MvMTQxMTc5MS9zdGFjawpbPDA+XSB3YWl0X29uX3BhZ2VfYml0KzB4MTMzLzB4MjcwCls8
MD5dIHdhaXRfb25fcGFnZV93cml0ZWJhY2srMHgyNS8weDcwCls8MD5dIF9fZmlsZW1hcF9mZGF0
YXdhaXRfcmFuZ2UrMHg4Ni8weGYwCls8MD5dIGZpbGVfd3JpdGVfYW5kX3dhaXRfcmFuZ2UrMHg3
NC8weGIwCls8MD5dIGJsa2Rldl9mc3luYysweDE2LzB4NDAKWzwwPl0gZG9fZnN5bmMrMHgzOC8w
eDYwCls8MD5dIF9feDY0X3N5c19mc3luYysweDEwLzB4MjAKWzwwPl0gZG9fc3lzY2FsbF82NCsw
eDJkLzB4NzAKWzwwPl0gZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4NDQvMHhhOQoK
LS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0
bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

