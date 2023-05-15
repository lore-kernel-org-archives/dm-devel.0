Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BDE0C77B75
	for <dm-devel@archiver.kernel.org>; Tue, 16 May 2023 05:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684215692;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XI6eSlzGYBBUCfXh4zGwdA0hmgaLH4n3pJEySr9JrNs=;
	b=OwCYOdRP7QXAKodxF7J5QZVlwJx3Rt5fdINcVUSL1oH9Q5Ah9XtBEFhGRKmaPaZGa7MggG
	9/86CZ6kwdTS5+tnVxPbcK5wjNEWvupEzUcN7FWNKqOpMKKRKeBpv4AnCytlMqbj7IGfjN
	vdt8ot0r0XQ7si081bZCxi03k30rOck=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-BOmZOO-UM-GRiUw37hC-hw-1; Tue, 16 May 2023 01:40:49 -0400
X-MC-Unique: BOmZOO-UM-GRiUw37hC-hw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01100101A5D1;
	Tue, 16 May 2023 05:40:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D164140C2063;
	Tue, 16 May 2023 05:40:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 84B101946595;
	Tue, 16 May 2023 05:40:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 79F81194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 15 May 2023 11:53:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 66090C084BB; Mon, 15 May 2023 11:53:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E6CAC15BA0
 for <dm-devel@redhat.com>; Mon, 15 May 2023 11:53:10 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4158638149A9
 for <dm-devel@redhat.com>; Mon, 15 May 2023 11:53:10 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-GZJjbdVLMN2Mu3ggo9kSXg-1; Mon, 15 May 2023 07:53:08 -0400
X-MC-Unique: GZJjbdVLMN2Mu3ggo9kSXg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 9D497618CD;
 Mon, 15 May 2023 11:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5B8C433D2;
 Mon, 15 May 2023 11:46:54 +0000 (UTC)
Message-ID: <2505d45e-660f-08ef-0245-9906e16c2b53@kernel.org>
Date: Mon, 15 May 2023 20:46:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To: Hannes Reinecke <hare@suse.de>, Ming Lin <minggr@gmail.com>
References: <CAF1ivSZJjVq313Zg9nBF0S3DOun=-Vw8saZGPU5cGrB_woM-8g@mail.gmail.com>
 <2aafd5fc-26b4-fa82-4149-a72adf6722b9@suse.de>
 <CAF1ivSaVEr_q9eN0_UpYTdDRsDcVjC17pbVUKbv_X1A3gSKDKw@mail.gmail.com>
 <5e12d3ba-0a12-d3f9-15ba-140cd4909705@suse.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <5e12d3ba-0a12-d3f9-15ba-140cd4909705@suse.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Tue, 16 May 2023 05:40:44 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNS8xNS8yMyAxNTowNiwgSGFubmVzIFJlaW5lY2tlIHdyb3RlOgo+IE9uIDUvMTIvMjMgMTk6
NDEsIE1pbmcgTGluIHdyb3RlOgo+PiBPbiBUaHUsIE1heSAxMSwgMjAyMyBhdCAxMTo1NuKAr0FN
IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPiB3cm90ZToKPj4+Cj4+PiBPbiA1LzExLzIz
IDIwOjQxLCBNaW5nIExpbiB3cm90ZToKPj4+PiBIaSBsaXN0LAo+Pj4+Cj4+Pj4gSSBoYXZlIGFu
IGFwcGxpY2F0aW9uIHRoYXQgbmVlZHMgdG8gdXNlIGJ1ZmZlcmVkX2lvIHRvIGFjY2VzcyBTTVIg
ZGlzawo+Pj4+IGZvciBnb29kIHBlcmZvcm1hbmNlLgo+Pj4+Cj4+Pj4gICBGcm9tICJaQkQgU3Vw
cG9ydCBSZXN0cmljdGlvbnMiIGF0IGh0dHBzOi8vem9uZWRzdG9yYWdlLmlvL2RvY3MvbGludXgv
b3ZlcnZpZXcKPj4+PiAiCj4+Pj4gRGlyZWN0IElPIFdyaXRlcyBUaGUga2VybmVsIHBhZ2UgY2Fj
aGUgZG9lcyBub3QgZ3VhcmFudGVlIHRoYXQgY2FjaGVkCj4+Pj4gZGlydHkgcGFnZXMgd2lsbCBi
ZSBmbHVzaGVkIHRvIGEgYmxvY2sgZGV2aWNlIGluIHNlcXVlbnRpYWwgc2VjdG9yCj4+Pj4gb3Jk
ZXIuIFRoaXMgY2FuIGxlYWQgdG8gdW5hbGlnbmVkIHdyaXRlIGVycm9ycyBpZiBhbiBhcHBsaWNh
dGlvbiB1c2VzCj4+Pj4gYnVmZmVyZWQgd3JpdGVzIHRvIHdyaXRlIHRvIHRoZSBzZXF1ZW50aWFs
IHdyaXRlIHJlcXVpcmVkIHpvbmVzIG9mIGEKPj4+PiBkZXZpY2UuIFRvIGF2b2lkIHRoaXMgcGl0
ZmFsbCwgYXBwbGljYXRpb25zIHRoYXQgZGlyZWN0bHkgdXNlIGEgem9uZWQKPj4+PiBibG9jayBk
ZXZpY2Ugd2l0aG91dCBhIGZpbGUgc3lzdGVtIHNob3VsZCBhbHdheXMgdXNlIGRpcmVjdCBJL08K
Pj4+PiBvcGVyYXRpb25zIHRvIHdyaXRlIHRvIHRoZSBzZXF1ZW50aWFsIHdyaXRlIHJlcXVpcmVk
IHpvbmVzIG9mIGEKPj4+PiBob3N0LW1hbmFnZWQgZGlzayAodGhhdCBpcywgdGhleSBzaG91bGQg
aXNzdWUgd3JpdGUoKSBzeXN0ZW0gY2FsbHMKPj4+PiB3aXRoIGEgYmxvY2sgZGV2aWNlICJmaWxl
IG9wZW4iIHRoYXQgdXNlcyB0aGUgT19ESVJFQ1QgZmxhZykuCj4+Pj4gIgo+Pj4+Cj4+Pj4gUmF3
IHpiZCBkaXNrIG9ubHkgc3VwcG9ydHMgZGlyZWN0X2lvLgo+Pj4+Cj4+Pj4gRG9lcyBkbS16b25l
ZCBzdXBwb3J0IGJ1ZmZlcmVkIGlvICh3aXRob3V0IE9fRElSRUNUKT8KPj4+Pgo+Pj4gWWVzLiBC
dXQgSSBfdGhpbmtfIHRoZSBhYm92ZSBwYXJhZ3JhcGggaXMgZXZlciBzbyBzbGlnaHRseSBvdXRk
YXRlZCwgYXMKPj4+IHdlJ3ZlIHNwZW50IHF1aXRlIGEgbG90IG9mIHRpbWUgZml4aW5nIHNlcXVl
bnRpYWwgd3JpdGVzIChjZiBibGstem9uZWQKPj4+IGV0YykuIFNvIHdoaWxlIGRtLXpvbmVkIGlz
IHVzaW5nIGJ1ZmZlcmV0IHdyaXRlcyB0aGVyZSB3b24ndCBiZSBhbnkKPj4+IHNlcXVlbnRpYWwg
d3JpdGUgaXNzdWVzLgo+Pj4KPj4+IEF0IGxlYXN0LCBJIGhhdmUgbm90IHVuY292ZXJlZCBhbnkg
b2YgdGhvc2UgZHVyaW5nIHRlc3RpbmcuCj4+Cj4+IEhpIEhhbm5lcywKPj4KPj4gSSB1c2UgNS4x
MC45MCBrZXJuZWwgYW5kIHNtciBkaXNrIGNhcGFjaXR5IGlzIDI0VC4KPj4gSSBmb2xsb3dlZCB0
aGUgYmVsb3cgZ3VpZGUgdG8gY3JlYXRlIGRtX3pvbmUgZGV2aWNlIG9uIHRvcCBvZiBzbXIgZGlz
ay4KPj4gaHR0cHM6Ly96b25lZHN0b3JhZ2UuaW8vZG9jcy9saW51eC9kbQo+Pgo+PiBUaGVuIG1r
ZnMuZXh0NCAvZGV2L2RtLTAsIGJ1dCBpdCBzZWVtcyBodW5nLgo+PiBBbnkgaWRlYXM/Cj4+Cj4+
IFszNzU1Mi4yMTc0NzJdIGRldmljZS1tYXBwZXI6IHVldmVudDogdmVyc2lvbiAxLjAuMwo+PiBb
Mzc1NTIuMjE3NTQ5XSBkZXZpY2UtbWFwcGVyOiBpb2N0bDogNC40My4wLWlvY3RsICgyMDIwLTEw
LTAxKQo+PiBpbml0aWFsaXNlZDogZG0tZGV2ZWxAcmVkaGF0LmNvbQo+PiBbMzc1NzUuNjA4NTAw
XSBkZXZpY2UtbWFwcGVyOiB6b25lZCBtZXRhZGF0YTogKGRtei01MDAwY2NhMmJmYzBkYjIxKToK
Pj4gRE0tWm9uZWQgbWV0YWRhdGEgdmVyc2lvbiAyCj4+IFszNzU3NS42MDg1MDJdIGRldmljZS1t
YXBwZXI6IHpvbmVkIG1ldGFkYXRhOiAoc2R4KTogSG9zdC1tYW5hZ2VkCj4+IHpvbmVkIGJsb2Nr
IGRldmljZQo+PiBbMzc1NzUuNjA4NTAzXSBkZXZpY2UtbWFwcGVyOiB6b25lZCBtZXRhZGF0YTog
KHNkeCk6ICAgNTA3ODI1MzU2ODAKPj4gNTEyLWJ5dGUgbG9naWNhbCBzZWN0b3JzIChvZmZzZXQg
MCkKPj4gWzM3NTc1LjYwODUwM10gZGV2aWNlLW1hcHBlcjogem9uZWQgbWV0YWRhdGE6IChzZHgp
OiAgIDk2ODYwIHpvbmVzIG9mCj4+IDUyNDI4OCA1MTItYnl0ZSBsb2dpY2FsIHNlY3RvcnMgKG9m
ZnNldCAwKQo+PiBbMzc1NzUuNjA4NTA0XSBkZXZpY2UtbWFwcGVyOiB6b25lZCBtZXRhZGF0YTog
KGRtei01MDAwY2NhMmJmYzBkYjIxKToKPj4gICA5Njg2MCB6b25lcyBvZiA1MjQyODggNTEyLWJ5
dGUgbG9naWNhbCBzZWN0b3JzCj4+IFszNzU3NS42MDkyMDRdIGRldmljZS1tYXBwZXI6IHpvbmVk
OiAoZG16LTUwMDBjY2EyYmZjMGRiMjEpOiBUYXJnZXQKPj4gZGV2aWNlOiA1MDc3MTAwMTM0NCA1
MTItYnl0ZSBsb2dpY2FsIHNlY3RvcnMgKDYzNDYzNzUxNjggYmxvY2tzKQo+PiBbMzgxMDEuNTQz
MzUzXSBJTkZPOiB0YXNrIG1rZnMuZXh0NDoxNDExNzkxIGJsb2NrZWQgZm9yIG1vcmUgdGhhbiAx
MjIgc2Vjb25kcy4KPj4gWzM4MTAxLjU0MzM4MF0gICAgICAgVGFpbnRlZDogRyAgICAgICAgICAg
T0UgICAgIDUuMTAuOTAuYm0uMS1hbWQ2NCsgIzIKPj4gWzM4MTAxLjU0MzM5NV0gImVjaG8gMCA+
IC9wcm9jL3N5cy9rZXJuZWwvaHVuZ190YXNrX3RpbWVvdXRfc2VjcyIKPj4gZGlzYWJsZXMgdGhp
cyBtZXNzYWdlLgo+PiBbMzgxMDEuNTQzNDExXSB0YXNrOm1rZnMuZXh0NCAgICAgICBzdGF0ZTpE
IHN0YWNrOiAgICAwIHBpZDoxNDExNzkxCj4+IHBwaWQ6MTM4ODY2MCBmbGFnczoweDAwMDA0MDAw
Cj4+IFszODEwMS41NDM0MTVdIENhbGwgVHJhY2U6Cj4+IFszODEwMS41NDM0MjJdICBfX3NjaGVk
dWxlKzB4M2ZkLzB4NzYwCj4+IFszODEwMS41NDM0MjVdICBzY2hlZHVsZSsweDQ2LzB4YjAKPj4g
WzM4MTAxLjU0MzQyNl0gIGlvX3NjaGVkdWxlKzB4MTIvMHg0MAo+PiBbMzgxMDEuNTQzNDI5XSAg
d2FpdF9vbl9wYWdlX2JpdCsweDEzMy8weDI3MAo+PiBbMzgxMDEuNTQzNDMxXSAgPyBfX3BhZ2Vf
Y2FjaGVfYWxsb2MrMHhhMC8weGEwCj4+IFszODEwMS41NDM0MzJdICB3YWl0X29uX3BhZ2Vfd3Jp
dGViYWNrKzB4MjUvMHg3MAo+PiBbMzgxMDEuNTQzNDM0XSAgX19maWxlbWFwX2ZkYXRhd2FpdF9y
YW5nZSsweDg2LzB4ZjAKPj4gWzM4MTAxLjU0MzQzNV0gIGZpbGVfd3JpdGVfYW5kX3dhaXRfcmFu
Z2UrMHg3NC8weGIwCj4+IFszODEwMS41NDM0MzhdICBibGtkZXZfZnN5bmMrMHgxNi8weDQwCj4+
IFszODEwMS41NDM0NDFdICBkb19mc3luYysweDM4LzB4NjAKPj4gWzM4MTAxLjU0MzQ0Ml0gIF9f
eDY0X3N5c19mc3luYysweDEwLzB4MjAKPj4gWzM4MTAxLjU0MzQ0NV0gIGRvX3N5c2NhbGxfNjQr
MHgyZC8weDcwCj4+IFszODEwMS41NDM0NDZdICBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJh
bWUrMHg0NC8weGE5Cj4+Cj4+ID09PQo+PiBCZWxvdyBhcmUgdGhlIHN0ZXBzIEkgZGlkOgo+Pgo+
PiByb290QHNtcl9kZXY6fiMgYmxrem9uZSByZXNldCAvZGV2L3NkeAo+Pgo+PiByb290QHNtcl9k
ZXY6fiMgZG16YWRtIC0tZm9ybWF0IC9kZXYvc2R4Cj4+IC9kZXYvc2R4OiA1MDc4MjUzNTY4MCA1
MTItYnl0ZSBzZWN0b3JzICgyNDIxNSBHaUIpCj4+ICAgIEhvc3QtbWFuYWdlZCBkZXZpY2UKPj4g
ICAgOTY4NjAgem9uZXMsIG9mZnNldCAwCj4+ICAgIDk2ODYwIHpvbmVzIG9mIDUyNDI4OCA1MTIt
Ynl0ZSBzZWN0b3JzICgyNTYgTWlCKQo+PiAgICA2NTUzNiA0S0IgZGF0YSBibG9ja3MgcGVyIHpv
bmUKPj4gUmVzZXR0aW5nIHNlcXVlbnRpYWwgem9uZXMKPj4gV3JpdGluZyBwcmltYXJ5IG1ldGFk
YXRhIHNldAo+PiAgICBXcml0aW5nIG1hcHBpbmcgdGFibGUKPj4gICAgV3JpdGluZyBiaXRtYXAg
YmxvY2tzCj4+ICAgIFdyaXRpbmcgc3VwZXIgYmxvY2sgdG8gc2R4IGJsb2NrIDAKPj4gV3JpdGlu
ZyBzZWNvbmRhcnkgbWV0YWRhdGEgc2V0Cj4+ICAgIFdyaXRpbmcgbWFwcGluZyB0YWJsZQo+PiAg
ICBXcml0aW5nIGJpdG1hcCBibG9ja3MKPj4gICAgV3JpdGluZyBzdXBlciBibG9jayB0byBzZHgg
YmxvY2sgMTk2NjA4Cj4+IFN5bmNpbmcgZGlzawo+PiBEb25lLgo+Pgo+IEhtbS4gSSBkb24ndCBh
Y3R1YWxseSBzZWUgaG93IG1hbnkgQ01SIHpvbmVzIHRoZSBkcml2ZSBoYXMuCj4gCj4+IHJvb3RA
c21yX2Rldjp+IyBkbXphZG0gLS1zdGFydCAvZGV2L3NkeAo+PiAvZGV2L3NkeDogNTA3ODI1MzU2
ODAgNTEyLWJ5dGUgc2VjdG9ycyAoMjQyMTUgR2lCKQo+PiAgICBIb3N0LW1hbmFnZWQgZGV2aWNl
Cj4+ICAgIDk2ODYwIHpvbmVzLCBvZmZzZXQgMAo+PiAgICA5Njg2MCB6b25lcyBvZiA1MjQyODgg
NTEyLWJ5dGUgc2VjdG9ycyAoMjU2IE1pQikKPj4gICAgNjU1MzYgNEtCIGRhdGEgYmxvY2tzIHBl
ciB6b25lCj4+IHNkeDogc3RhcnRpbmcgZG16LTUwMDBjY2EyYmZjMGRiMjEsIG1ldGFkYXRhIHZl
ci4gMiwgdXVpZAo+PiA3NDk1ZTIxYS0yM2Q5LTQ5ZjQtODMyYS03NmIzMjEzNjA3OGIKPj4KPj4g
cm9vdEBzbXJfZGV2On4jIG1rZnMuZXh0NCAvZGV2L2RtLTAKPj4gbWtlMmZzIDEuNDQuNSAoMTUt
RGVjLTIwMTgpCj4+IERpc2NhcmRpbmcgZGV2aWNlIGJsb2NrczogZG9uZQo+PiBDcmVhdGluZyBm
aWxlc3lzdGVtIHdpdGggNjM0NjM3NTE2OCA0ayBibG9ja3MgYW5kIDM5NjY0ODQ0OCBpbm9kZXMK
Pj4gRmlsZXN5c3RlbSBVVUlEOiBjNDdkZTA2ZC02Y2Y2LTRhODUtOTUwMi03ODMwY2EyZjQ1MjYK
Pj4gU3VwZXJibG9jayBiYWNrdXBzIHN0b3JlZCBvbiBibG9ja3M6Cj4+ICAgICAgICAgIDMyNzY4
LCA5ODMwNCwgMTYzODQwLCAyMjkzNzYsIDI5NDkxMiwgODE5MjAwLCA4ODQ3MzYsIDE2MDU2MzIs
IDI2NTQyMDgsCj4+ICAgICAgICAgIDQwOTYwMDAsIDc5NjI2MjQsIDExMjM5NDI0LCAyMDQ4MDAw
MCwgMjM4ODc4NzIsIDcxNjYzNjE2LCA3ODY3NTk2OCwKPj4gICAgICAgICAgMTAyNDAwMDAwLCAy
MTQ5OTA4NDgsIDUxMjAwMDAwMCwgNTUwNzMxNzc2LCA2NDQ5NzI1NDQsIDE5MzQ5MTc2MzIsCj4+
ICAgICAgICAgIDI1NjAwMDAwMDAsIDM4NTUxMjI0MzIsIDU4MDQ3NTI4OTYKPj4KPj4gQWxsb2Nh
dGluZyBncm91cCB0YWJsZXM6IGRvbmUKPj4gV3JpdGluZyBpbm9kZSB0YWJsZXM6IGRvbmUKPj4g
Q3JlYXRpbmcgam91cm5hbCAoMjYyMTQ0IGJsb2Nrcyk6IGRvbmUKPj4gV3JpdGluZyBzdXBlcmJs
b2NrcyBhbmQgZmlsZXN5c3RlbSBhY2NvdW50aW5nIGluZm9ybWF0aW9uOgo+Pgo+PiA9PT0KPj4g
QXQgYW5vdGhlciB0ZXJtaW5hbCwKPj4KPj4gcm9vdEBzbXJfZGV2On4jIHBzIGF1eCB8IGdyZXAg
bWtmcy5leHQ0Cj4+IHJvb3QgICAgIDE0MTE3OTEgIDIuOCAgMC4wICAzMDk5MiAxOTg2NCBwdHMv
MSAgICBEKyAgIDAxOjMwICAgMDowMQo+PiBta2ZzLmV4dDQgL2Rldi9kbS0wCj4+IHJvb3QgICAg
IDE0MTM2NDAgIDAuMCAgMC4wICAxMzk3MiAgMjQ5NiBwdHMvMCAgICBTKyAgIDAxOjMxICAgMDow
MAo+PiBncmVwIG1rZnMuZXh0NAo+Pgo+PiByb290QHNtcl9kZXY6fiMgY2F0IC9wcm9jLzE0MTE3
OTEvc3RhY2sKPj4gWzwwPl0gd2FpdF9vbl9wYWdlX2JpdCsweDEzMy8weDI3MAo+PiBbPDA+XSB3
YWl0X29uX3BhZ2Vfd3JpdGViYWNrKzB4MjUvMHg3MAo+PiBbPDA+XSBfX2ZpbGVtYXBfZmRhdGF3
YWl0X3JhbmdlKzB4ODYvMHhmMAo+PiBbPDA+XSBmaWxlX3dyaXRlX2FuZF93YWl0X3JhbmdlKzB4
NzQvMHhiMAo+PiBbPDA+XSBibGtkZXZfZnN5bmMrMHgxNi8weDQwCj4+IFs8MD5dIGRvX2ZzeW5j
KzB4MzgvMHg2MAo+PiBbPDA+XSBfX3g2NF9zeXNfZnN5bmMrMHgxMC8weDIwCj4+IFs8MD5dIGRv
X3N5c2NhbGxfNjQrMHgyZC8weDcwCj4+IFs8MD5dIGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdm
cmFtZSsweDQ0LzB4YTkKCk5vdCBzdXJlIGlmIHRoaXMgaXMgYSBidWcsIGJ1dCBkb2luZyBhIHNp
bXBsZSBta2ZzLmV4dDQgb24gZG0tem9uZWQgd2l0aCBhIGxhcmdlClNNUiBkaXNrIGNhbiB0YWtl
ICphIHZlcnkgbG9vb29vb25nKiB0aW1lLiBUaGlzIGlzIGJlY2F1c2UgbWtmcy5leHQ0IGRvZXMg
YSBsb3QKb2YgcmFuZG9tIHdyaXRlcyBhbGwgb3ZlciB0aGUgcGxhY2UuIFNvIGp1c3QgcnVubmlu
ZyB0aGF0LCBkbS16b25lZCBnb2VzIGludG8KaGVhdnkgR0MgbW9kZS4uLgoKVG8gc3BlZWQgdGhp
bmdzIHVwIChhbmQgaW1wcm92ZSBydW50aW1lIHBlcmZvcm1hbmNlKSwgdXNlIHRoZSBwYWNrZWQt
bWV0YWRhdGEKZm9ybWF0OiBta2ZzLmV4dDQgLUUgcGFja2VkX21ldGFfYmxvY2tzPTEKT3IgZG8g
YSBta2ZzLnhmcyB0byBjb21wYXJlIGFuZCBzZWUgaG93IG11Y2ggZmFzdGVyIGl0IGlzLgoKPiAK
PiBCdXQgdGhhdCBqdXN0IG1lYW5zIHRoYXQgd2UncmUgd2FpdGluZyBmb3IgSS9PIHRvIGNvbXBs
ZXRlOyB0aGVyZSBtdXN0IAo+IGJlIGFub3RoZXIgdGhyZWFkIHByb2Nlc3NpbmcgdGhlIEkvTy4K
PiBJZiB0aGlzIGlzIHRoZSBvbmx5IGFjdGl2ZSB0aHJlYWQgaW4geW91IHN5c3RlbSBzb21ldGhp
bmcgaXMgc2VyaW91c2x5IAo+IGhvc2VkLgo+IAo+IEJ1dCBJIGd1ZXNzIEkgZG9uJ3QgbmVlZCB0
byB0ZWxsIF95b3VfIHRoYXQgOi0pCj4gCj4gQ2hlZXJzLAo+IAo+IEhhbm5lcwoKLS0gCkRhbWll
biBMZSBNb2FsCldlc3Rlcm4gRGlnaXRhbCBSZXNlYXJjaAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbAo=

