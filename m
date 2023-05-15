Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2447CC7EE24
	for <dm-devel@archiver.kernel.org>; Mon, 15 May 2023 06:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684130811;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=an+6LR7zIuMprRSUGAz+GAn+dZ76uLLEZnmRmKCLBUY=;
	b=fVkkVG7G/oPC5uGIEknc6ne4fHI95D0H8TLVke5Z/9RUuzHN0il/QqC2c41DEpvUaFul8c
	HRQUeaPsOOORvPEzPMaSb/yGobd4ts///uiaBAv+EEBp4FPhZMG6y08cVHWpJ6JuYrX1HX
	FLLmHBOtSJBteUGlQkppEPbZzuJrNg8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-p1AOJhdaP6GPaSmN5fummA-1; Mon, 15 May 2023 02:06:48 -0400
X-MC-Unique: p1AOJhdaP6GPaSmN5fummA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D14FB3815F60;
	Mon, 15 May 2023 06:06:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5E56A492B01;
	Mon, 15 May 2023 06:06:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 009A51946595;
	Mon, 15 May 2023 06:06:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 63CDB194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 15 May 2023 06:06:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 378F6483EC2; Mon, 15 May 2023 06:06:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F1C240B947
 for <dm-devel@redhat.com>; Mon, 15 May 2023 06:06:44 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDAB11C05AE2
 for <dm-devel@redhat.com>; Mon, 15 May 2023 06:06:43 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-449-_yL-SoGyNNGlr4vWt93xvw-1; Mon,
 15 May 2023 02:06:42 -0400
X-MC-Unique: _yL-SoGyNNGlr4vWt93xvw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 8675621DA7;
 Mon, 15 May 2023 06:06:40 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6E739138E5;
 Mon, 15 May 2023 06:06:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id YqsiGfDLYWSnaAAAMHmgww
 (envelope-from <hare@suse.de>); Mon, 15 May 2023 06:06:40 +0000
Message-ID: <5e12d3ba-0a12-d3f9-15ba-140cd4909705@suse.de>
Date: Mon, 15 May 2023 08:06:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
To: Ming Lin <minggr@gmail.com>
References: <CAF1ivSZJjVq313Zg9nBF0S3DOun=-Vw8saZGPU5cGrB_woM-8g@mail.gmail.com>
 <2aafd5fc-26b4-fa82-4149-a72adf6722b9@suse.de>
 <CAF1ivSaVEr_q9eN0_UpYTdDRsDcVjC17pbVUKbv_X1A3gSKDKw@mail.gmail.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <CAF1ivSaVEr_q9eN0_UpYTdDRsDcVjC17pbVUKbv_X1A3gSKDKw@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS8xMi8yMyAxOTo0MSwgTWluZyBMaW4gd3JvdGU6Cj4gT24gVGh1LCBNYXkgMTEsIDIwMjMg
YXQgMTE6NTbigK9BTSBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4gd3JvdGU6Cj4+Cj4+
IE9uIDUvMTEvMjMgMjA6NDEsIE1pbmcgTGluIHdyb3RlOgo+Pj4gSGkgbGlzdCwKPj4+Cj4+PiBJ
IGhhdmUgYW4gYXBwbGljYXRpb24gdGhhdCBuZWVkcyB0byB1c2UgYnVmZmVyZWRfaW8gdG8gYWNj
ZXNzIFNNUiBkaXNrCj4+PiBmb3IgZ29vZCBwZXJmb3JtYW5jZS4KPj4+Cj4+PiAgIEZyb20gIlpC
RCBTdXBwb3J0IFJlc3RyaWN0aW9ucyIgYXQgaHR0cHM6Ly96b25lZHN0b3JhZ2UuaW8vZG9jcy9s
aW51eC9vdmVydmlldwo+Pj4gIgo+Pj4gRGlyZWN0IElPIFdyaXRlcyBUaGUga2VybmVsIHBhZ2Ug
Y2FjaGUgZG9lcyBub3QgZ3VhcmFudGVlIHRoYXQgY2FjaGVkCj4+PiBkaXJ0eSBwYWdlcyB3aWxs
IGJlIGZsdXNoZWQgdG8gYSBibG9jayBkZXZpY2UgaW4gc2VxdWVudGlhbCBzZWN0b3IKPj4+IG9y
ZGVyLiBUaGlzIGNhbiBsZWFkIHRvIHVuYWxpZ25lZCB3cml0ZSBlcnJvcnMgaWYgYW4gYXBwbGlj
YXRpb24gdXNlcwo+Pj4gYnVmZmVyZWQgd3JpdGVzIHRvIHdyaXRlIHRvIHRoZSBzZXF1ZW50aWFs
IHdyaXRlIHJlcXVpcmVkIHpvbmVzIG9mIGEKPj4+IGRldmljZS4gVG8gYXZvaWQgdGhpcyBwaXRm
YWxsLCBhcHBsaWNhdGlvbnMgdGhhdCBkaXJlY3RseSB1c2UgYSB6b25lZAo+Pj4gYmxvY2sgZGV2
aWNlIHdpdGhvdXQgYSBmaWxlIHN5c3RlbSBzaG91bGQgYWx3YXlzIHVzZSBkaXJlY3QgSS9PCj4+
PiBvcGVyYXRpb25zIHRvIHdyaXRlIHRvIHRoZSBzZXF1ZW50aWFsIHdyaXRlIHJlcXVpcmVkIHpv
bmVzIG9mIGEKPj4+IGhvc3QtbWFuYWdlZCBkaXNrICh0aGF0IGlzLCB0aGV5IHNob3VsZCBpc3N1
ZSB3cml0ZSgpIHN5c3RlbSBjYWxscwo+Pj4gd2l0aCBhIGJsb2NrIGRldmljZSAiZmlsZSBvcGVu
IiB0aGF0IHVzZXMgdGhlIE9fRElSRUNUIGZsYWcpLgo+Pj4gIgo+Pj4KPj4+IFJhdyB6YmQgZGlz
ayBvbmx5IHN1cHBvcnRzIGRpcmVjdF9pby4KPj4+Cj4+PiBEb2VzIGRtLXpvbmVkIHN1cHBvcnQg
YnVmZmVyZWQgaW8gKHdpdGhvdXQgT19ESVJFQ1QpPwo+Pj4KPj4gWWVzLiBCdXQgSSBfdGhpbmtf
IHRoZSBhYm92ZSBwYXJhZ3JhcGggaXMgZXZlciBzbyBzbGlnaHRseSBvdXRkYXRlZCwgYXMKPj4g
d2UndmUgc3BlbnQgcXVpdGUgYSBsb3Qgb2YgdGltZSBmaXhpbmcgc2VxdWVudGlhbCB3cml0ZXMg
KGNmIGJsay16b25lZAo+PiBldGMpLiBTbyB3aGlsZSBkbS16b25lZCBpcyB1c2luZyBidWZmZXJl
dCB3cml0ZXMgdGhlcmUgd29uJ3QgYmUgYW55Cj4+IHNlcXVlbnRpYWwgd3JpdGUgaXNzdWVzLgo+
Pgo+PiBBdCBsZWFzdCwgSSBoYXZlIG5vdCB1bmNvdmVyZWQgYW55IG9mIHRob3NlIGR1cmluZyB0
ZXN0aW5nLgo+IAo+IEhpIEhhbm5lcywKPiAKPiBJIHVzZSA1LjEwLjkwIGtlcm5lbCBhbmQgc21y
IGRpc2sgY2FwYWNpdHkgaXMgMjRULgo+IEkgZm9sbG93ZWQgdGhlIGJlbG93IGd1aWRlIHRvIGNy
ZWF0ZSBkbV96b25lIGRldmljZSBvbiB0b3Agb2Ygc21yIGRpc2suCj4gaHR0cHM6Ly96b25lZHN0
b3JhZ2UuaW8vZG9jcy9saW51eC9kbQo+IAo+IFRoZW4gbWtmcy5leHQ0IC9kZXYvZG0tMCwgYnV0
IGl0IHNlZW1zIGh1bmcuCj4gQW55IGlkZWFzPwo+IAo+IFszNzU1Mi4yMTc0NzJdIGRldmljZS1t
YXBwZXI6IHVldmVudDogdmVyc2lvbiAxLjAuMwo+IFszNzU1Mi4yMTc1NDldIGRldmljZS1tYXBw
ZXI6IGlvY3RsOiA0LjQzLjAtaW9jdGwgKDIwMjAtMTAtMDEpCj4gaW5pdGlhbGlzZWQ6IGRtLWRl
dmVsQHJlZGhhdC5jb20KPiBbMzc1NzUuNjA4NTAwXSBkZXZpY2UtbWFwcGVyOiB6b25lZCBtZXRh
ZGF0YTogKGRtei01MDAwY2NhMmJmYzBkYjIxKToKPiBETS1ab25lZCBtZXRhZGF0YSB2ZXJzaW9u
IDIKPiBbMzc1NzUuNjA4NTAyXSBkZXZpY2UtbWFwcGVyOiB6b25lZCBtZXRhZGF0YTogKHNkeCk6
IEhvc3QtbWFuYWdlZAo+IHpvbmVkIGJsb2NrIGRldmljZQo+IFszNzU3NS42MDg1MDNdIGRldmlj
ZS1tYXBwZXI6IHpvbmVkIG1ldGFkYXRhOiAoc2R4KTogICA1MDc4MjUzNTY4MAo+IDUxMi1ieXRl
IGxvZ2ljYWwgc2VjdG9ycyAob2Zmc2V0IDApCj4gWzM3NTc1LjYwODUwM10gZGV2aWNlLW1hcHBl
cjogem9uZWQgbWV0YWRhdGE6IChzZHgpOiAgIDk2ODYwIHpvbmVzIG9mCj4gNTI0Mjg4IDUxMi1i
eXRlIGxvZ2ljYWwgc2VjdG9ycyAob2Zmc2V0IDApCj4gWzM3NTc1LjYwODUwNF0gZGV2aWNlLW1h
cHBlcjogem9uZWQgbWV0YWRhdGE6IChkbXotNTAwMGNjYTJiZmMwZGIyMSk6Cj4gICA5Njg2MCB6
b25lcyBvZiA1MjQyODggNTEyLWJ5dGUgbG9naWNhbCBzZWN0b3JzCj4gWzM3NTc1LjYwOTIwNF0g
ZGV2aWNlLW1hcHBlcjogem9uZWQ6IChkbXotNTAwMGNjYTJiZmMwZGIyMSk6IFRhcmdldAo+IGRl
dmljZTogNTA3NzEwMDEzNDQgNTEyLWJ5dGUgbG9naWNhbCBzZWN0b3JzICg2MzQ2Mzc1MTY4IGJs
b2NrcykKPiBbMzgxMDEuNTQzMzUzXSBJTkZPOiB0YXNrIG1rZnMuZXh0NDoxNDExNzkxIGJsb2Nr
ZWQgZm9yIG1vcmUgdGhhbiAxMjIgc2Vjb25kcy4KPiBbMzgxMDEuNTQzMzgwXSAgICAgICBUYWlu
dGVkOiBHICAgICAgICAgICBPRSAgICAgNS4xMC45MC5ibS4xLWFtZDY0KyAjMgo+IFszODEwMS41
NDMzOTVdICJlY2hvIDAgPiAvcHJvYy9zeXMva2VybmVsL2h1bmdfdGFza190aW1lb3V0X3NlY3Mi
Cj4gZGlzYWJsZXMgdGhpcyBtZXNzYWdlLgo+IFszODEwMS41NDM0MTFdIHRhc2s6bWtmcy5leHQ0
ICAgICAgIHN0YXRlOkQgc3RhY2s6ICAgIDAgcGlkOjE0MTE3OTEKPiBwcGlkOjEzODg2NjAgZmxh
Z3M6MHgwMDAwNDAwMAo+IFszODEwMS41NDM0MTVdIENhbGwgVHJhY2U6Cj4gWzM4MTAxLjU0MzQy
Ml0gIF9fc2NoZWR1bGUrMHgzZmQvMHg3NjAKPiBbMzgxMDEuNTQzNDI1XSAgc2NoZWR1bGUrMHg0
Ni8weGIwCj4gWzM4MTAxLjU0MzQyNl0gIGlvX3NjaGVkdWxlKzB4MTIvMHg0MAo+IFszODEwMS41
NDM0MjldICB3YWl0X29uX3BhZ2VfYml0KzB4MTMzLzB4MjcwCj4gWzM4MTAxLjU0MzQzMV0gID8g
X19wYWdlX2NhY2hlX2FsbG9jKzB4YTAvMHhhMAo+IFszODEwMS41NDM0MzJdICB3YWl0X29uX3Bh
Z2Vfd3JpdGViYWNrKzB4MjUvMHg3MAo+IFszODEwMS41NDM0MzRdICBfX2ZpbGVtYXBfZmRhdGF3
YWl0X3JhbmdlKzB4ODYvMHhmMAo+IFszODEwMS41NDM0MzVdICBmaWxlX3dyaXRlX2FuZF93YWl0
X3JhbmdlKzB4NzQvMHhiMAo+IFszODEwMS41NDM0MzhdICBibGtkZXZfZnN5bmMrMHgxNi8weDQw
Cj4gWzM4MTAxLjU0MzQ0MV0gIGRvX2ZzeW5jKzB4MzgvMHg2MAo+IFszODEwMS41NDM0NDJdICBf
X3g2NF9zeXNfZnN5bmMrMHgxMC8weDIwCj4gWzM4MTAxLjU0MzQ0NV0gIGRvX3N5c2NhbGxfNjQr
MHgyZC8weDcwCj4gWzM4MTAxLjU0MzQ0Nl0gIGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFt
ZSsweDQ0LzB4YTkKPiAKPiA9PT0KPiBCZWxvdyBhcmUgdGhlIHN0ZXBzIEkgZGlkOgo+IAo+IHJv
b3RAc21yX2Rldjp+IyBibGt6b25lIHJlc2V0IC9kZXYvc2R4Cj4gCj4gcm9vdEBzbXJfZGV2On4j
IGRtemFkbSAtLWZvcm1hdCAvZGV2L3NkeAo+IC9kZXYvc2R4OiA1MDc4MjUzNTY4MCA1MTItYnl0
ZSBzZWN0b3JzICgyNDIxNSBHaUIpCj4gICAgSG9zdC1tYW5hZ2VkIGRldmljZQo+ICAgIDk2ODYw
IHpvbmVzLCBvZmZzZXQgMAo+ICAgIDk2ODYwIHpvbmVzIG9mIDUyNDI4OCA1MTItYnl0ZSBzZWN0
b3JzICgyNTYgTWlCKQo+ICAgIDY1NTM2IDRLQiBkYXRhIGJsb2NrcyBwZXIgem9uZQo+IFJlc2V0
dGluZyBzZXF1ZW50aWFsIHpvbmVzCj4gV3JpdGluZyBwcmltYXJ5IG1ldGFkYXRhIHNldAo+ICAg
IFdyaXRpbmcgbWFwcGluZyB0YWJsZQo+ICAgIFdyaXRpbmcgYml0bWFwIGJsb2Nrcwo+ICAgIFdy
aXRpbmcgc3VwZXIgYmxvY2sgdG8gc2R4IGJsb2NrIDAKPiBXcml0aW5nIHNlY29uZGFyeSBtZXRh
ZGF0YSBzZXQKPiAgICBXcml0aW5nIG1hcHBpbmcgdGFibGUKPiAgICBXcml0aW5nIGJpdG1hcCBi
bG9ja3MKPiAgICBXcml0aW5nIHN1cGVyIGJsb2NrIHRvIHNkeCBibG9jayAxOTY2MDgKPiBTeW5j
aW5nIGRpc2sKPiBEb25lLgo+IApIbW0uIEkgZG9uJ3QgYWN0dWFsbHkgc2VlIGhvdyBtYW55IENN
UiB6b25lcyB0aGUgZHJpdmUgaGFzLgoKPiByb290QHNtcl9kZXY6fiMgZG16YWRtIC0tc3RhcnQg
L2Rldi9zZHgKPiAvZGV2L3NkeDogNTA3ODI1MzU2ODAgNTEyLWJ5dGUgc2VjdG9ycyAoMjQyMTUg
R2lCKQo+ICAgIEhvc3QtbWFuYWdlZCBkZXZpY2UKPiAgICA5Njg2MCB6b25lcywgb2Zmc2V0IDAK
PiAgICA5Njg2MCB6b25lcyBvZiA1MjQyODggNTEyLWJ5dGUgc2VjdG9ycyAoMjU2IE1pQikKPiAg
ICA2NTUzNiA0S0IgZGF0YSBibG9ja3MgcGVyIHpvbmUKPiBzZHg6IHN0YXJ0aW5nIGRtei01MDAw
Y2NhMmJmYzBkYjIxLCBtZXRhZGF0YSB2ZXIuIDIsIHV1aWQKPiA3NDk1ZTIxYS0yM2Q5LTQ5ZjQt
ODMyYS03NmIzMjEzNjA3OGIKPiAKPiByb290QHNtcl9kZXY6fiMgbWtmcy5leHQ0IC9kZXYvZG0t
MAo+IG1rZTJmcyAxLjQ0LjUgKDE1LURlYy0yMDE4KQo+IERpc2NhcmRpbmcgZGV2aWNlIGJsb2Nr
czogZG9uZQo+IENyZWF0aW5nIGZpbGVzeXN0ZW0gd2l0aCA2MzQ2Mzc1MTY4IDRrIGJsb2NrcyBh
bmQgMzk2NjQ4NDQ4IGlub2Rlcwo+IEZpbGVzeXN0ZW0gVVVJRDogYzQ3ZGUwNmQtNmNmNi00YTg1
LTk1MDItNzgzMGNhMmY0NTI2Cj4gU3VwZXJibG9jayBiYWNrdXBzIHN0b3JlZCBvbiBibG9ja3M6
Cj4gICAgICAgICAgMzI3NjgsIDk4MzA0LCAxNjM4NDAsIDIyOTM3NiwgMjk0OTEyLCA4MTkyMDAs
IDg4NDczNiwgMTYwNTYzMiwgMjY1NDIwOCwKPiAgICAgICAgICA0MDk2MDAwLCA3OTYyNjI0LCAx
MTIzOTQyNCwgMjA0ODAwMDAsIDIzODg3ODcyLCA3MTY2MzYxNiwgNzg2NzU5NjgsCj4gICAgICAg
ICAgMTAyNDAwMDAwLCAyMTQ5OTA4NDgsIDUxMjAwMDAwMCwgNTUwNzMxNzc2LCA2NDQ5NzI1NDQs
IDE5MzQ5MTc2MzIsCj4gICAgICAgICAgMjU2MDAwMDAwMCwgMzg1NTEyMjQzMiwgNTgwNDc1Mjg5
Ngo+IAo+IEFsbG9jYXRpbmcgZ3JvdXAgdGFibGVzOiBkb25lCj4gV3JpdGluZyBpbm9kZSB0YWJs
ZXM6IGRvbmUKPiBDcmVhdGluZyBqb3VybmFsICgyNjIxNDQgYmxvY2tzKTogZG9uZQo+IFdyaXRp
bmcgc3VwZXJibG9ja3MgYW5kIGZpbGVzeXN0ZW0gYWNjb3VudGluZyBpbmZvcm1hdGlvbjoKPiAK
PiA9PT0KPiBBdCBhbm90aGVyIHRlcm1pbmFsLAo+IAo+IHJvb3RAc21yX2Rldjp+IyBwcyBhdXgg
fCBncmVwIG1rZnMuZXh0NAo+IHJvb3QgICAgIDE0MTE3OTEgIDIuOCAgMC4wICAzMDk5MiAxOTg2
NCBwdHMvMSAgICBEKyAgIDAxOjMwICAgMDowMQo+IG1rZnMuZXh0NCAvZGV2L2RtLTAKPiByb290
ICAgICAxNDEzNjQwICAwLjAgIDAuMCAgMTM5NzIgIDI0OTYgcHRzLzAgICAgUysgICAwMTozMSAg
IDA6MDAKPiBncmVwIG1rZnMuZXh0NAo+IAo+IHJvb3RAc21yX2Rldjp+IyBjYXQgL3Byb2MvMTQx
MTc5MS9zdGFjawo+IFs8MD5dIHdhaXRfb25fcGFnZV9iaXQrMHgxMzMvMHgyNzAKPiBbPDA+XSB3
YWl0X29uX3BhZ2Vfd3JpdGViYWNrKzB4MjUvMHg3MAo+IFs8MD5dIF9fZmlsZW1hcF9mZGF0YXdh
aXRfcmFuZ2UrMHg4Ni8weGYwCj4gWzwwPl0gZmlsZV93cml0ZV9hbmRfd2FpdF9yYW5nZSsweDc0
LzB4YjAKPiBbPDA+XSBibGtkZXZfZnN5bmMrMHgxNi8weDQwCj4gWzwwPl0gZG9fZnN5bmMrMHgz
OC8weDYwCj4gWzwwPl0gX194NjRfc3lzX2ZzeW5jKzB4MTAvMHgyMAo+IFs8MD5dIGRvX3N5c2Nh
bGxfNjQrMHgyZC8weDcwCj4gWzwwPl0gZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4
NDQvMHhhOQoKQnV0IHRoYXQganVzdCBtZWFucyB0aGF0IHdlJ3JlIHdhaXRpbmcgZm9yIEkvTyB0
byBjb21wbGV0ZTsgdGhlcmUgbXVzdCAKYmUgYW5vdGhlciB0aHJlYWQgcHJvY2Vzc2luZyB0aGUg
SS9PLgpJZiB0aGlzIGlzIHRoZSBvbmx5IGFjdGl2ZSB0aHJlYWQgaW4geW91IHN5c3RlbSBzb21l
dGhpbmcgaXMgc2VyaW91c2x5IApob3NlZC4KCkJ1dCBJIGd1ZXNzIEkgZG9uJ3QgbmVlZCB0byB0
ZWxsIF95b3VfIHRoYXQgOi0pCgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVj
a2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdh
cmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4
MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYsIEFuZHJldwpN
eWVycywgQW5kcmV3IE1jRG9uYWxkLCBNYXJ0amUgQm91ZGllbiBNb2VybWFuCgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

