Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12A12C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 03:39:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-sGaDBsTKNFegC6ua6KjQtg-1; Thu, 28 Apr 2022 23:39:46 -0400
X-MC-Unique: sGaDBsTKNFegC6ua6KjQtg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 449978E8CCB;
	Fri, 29 Apr 2022 03:39:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B6AB440CFD0C;
	Fri, 29 Apr 2022 03:39:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 51024194704D;
	Fri, 29 Apr 2022 03:39:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 06CEA1947047
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Apr 2022 03:39:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CDD6240D2825; Fri, 29 Apr 2022 03:39:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C89CA40D2821
 for <dm-devel@redhat.com>; Fri, 29 Apr 2022 03:39:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CBD38E8CC8
 for <dm-devel@redhat.com>; Fri, 29 Apr 2022 03:39:38 +0000 (UTC)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com
 [209.85.214.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-311-fMJtrRx_NP22b1B5vCuFfg-1; Thu, 28 Apr 2022 23:39:36 -0400
X-MC-Unique: fMJtrRx_NP22b1B5vCuFfg-1
Received: by mail-pl1-f169.google.com with SMTP id n8so6067642plh.1
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 20:39:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=qUwunun/VVG6pwTOWhDwXkr9BbstGxHqbcx5TzpKkl0=;
 b=zyd8Dgp+gAjLfxNWLbSHjqIU1Vq3sx7zXXnkZvgpEU9/iwSDIO6zZzPXf1r9kBZPvW
 FWt+Abd8h/eM1FJXXVjI9UxuZLuUYS4AlyQEf1dA4iL58QhqXFoqMOiX3My/vHAI0rdy
 Bx0N8dcBmn2ntY2N8mnyVrLk9m3nn3zGvVomOReA/TrcCMR3pQif+G9MPkYlJD6GveBG
 2Zjaw+s5y0NF6ySSPx23Yhu0uSOKWNTExkkY86HZj28jV8IodlGEXPcETvG2Qets/3Xs
 eMKcey/GbJ0tPyAHIk6x9zJO1hA+esdpv+m4jTKZTmOhhrX2GHLfmliVpEVLU+t6rJY1
 +7Rw==
X-Gm-Message-State: AOAM530n/Up10fydlmwdlvDq4sHTZYyVxld5xHbrtYkRXbfxFNzEupKX
 Wf/07lGSqynyum+MISXol9U=
X-Google-Smtp-Source: ABdhPJxtxVjuFEv0W1FHl8AvFyGb++7DZPYLFEeHuA6owahJDEYGMQWByu+vBRdjF/5hfBrS312ruw==
X-Received: by 2002:a17:902:7884:b0:158:b5b6:572c with SMTP id
 q4-20020a170902788400b00158b5b6572cmr37168381pll.144.1651203575217; 
 Thu, 28 Apr 2022 20:39:35 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd?
 ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
 by smtp.gmail.com with ESMTPSA id
 z2-20020a655a42000000b003c14af505efsm4537074pgs.7.2022.04.28.20.39.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 28 Apr 2022 20:39:33 -0700 (PDT)
Message-ID: <8f00ce03-ec87-b356-29a1-3b01d6c75efa@acm.org>
Date: Thu, 28 Apr 2022 20:39:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Nitesh Shetty <nj.shetty@samsung.com>
References: <CGME20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15@epcas5p4.samsung.com>
 <20220426101241.30100-1-nj.shetty@samsung.com>
 <6a85e8c8-d9d1-f192-f10d-09052703c99a@opensource.wdc.com>
 <20220427124951.GA9558@test-zns>
 <c285f0da-ab1d-2b24-e5a4-21193ef93155@opensource.wdc.com>
 <20220428074926.GG9558@test-zns>
 <a6d1c61a-14f2-36dc-5952-4d6897720c7a@opensource.wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a6d1c61a-14f2-36dc-5952-4d6897720c7a@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNC8yOC8yMiAxNDozNywgRGFtaWVuIExlIE1vYWwgd3JvdGU6Cj4gT24gNC8yOC8yMiAxNjo0
OSwgTml0ZXNoIFNoZXR0eSB3cm90ZToKPj4gT24gVGh1LCBBcHIgMjgsIDIwMjIgYXQgMDc6MDU6
MzJBTSArMDkwMCwgRGFtaWVuIExlIE1vYWwgd3JvdGU6Cj4+PiBPbiA0LzI3LzIyIDIxOjQ5LCBO
aXRlc2ggU2hldHR5IHdyb3RlOgo+Pj4+IE8gV2VkLCBBcHIgMjcsIDIwMjIgYXQgMTE6MTk6NDhB
TSArMDkwMCwgRGFtaWVuIExlIE1vYWwgd3JvdGU6Cj4+Pj4+IE9uIDQvMjYvMjIgMTk6MTIsIE5p
dGVzaCBTaGV0dHkgd3JvdGU6Cj4+Pj4+PiBUaGUgcGF0Y2ggc2VyaWVzIGNvdmVycyB0aGUgcG9p
bnRzIGRpc2N1c3NlZCBpbiBOb3ZlbWJlciAyMDIxIHZpcnR1YWwgY2FsbAo+Pj4+Pj4gW0xTRi9N
TS9CRlAgVE9QSUNdIFN0b3JhZ2U6IENvcHkgT2ZmbG9hZFswXS4KPj4+Pj4+IFdlIGhhdmUgY292
ZXJlZCB0aGUgSW5pdGlhbCBhZ3JlZWQgcmVxdWlyZW1lbnRzIGluIHRoaXMgcGF0Y2hzZXQuCj4+
Pj4+PiBQYXRjaHNldCBib3Jyb3dzIE1pa3VsYXMncyB0b2tlbiBiYXNlZCBhcHByb2FjaCBmb3Ig
MiBiZGV2Cj4+Pj4+PiBpbXBsZW1lbnRhdGlvbi4KPj4+Pj4+Cj4+Pj4+PiBPdmVyYWxsIHNlcmll
cyBzdXBwb3J0cyDigJMKPj4+Pj4+Cj4+Pj4+PiAxLiBEcml2ZXIKPj4+Pj4+IC0gTlZNZSBDb3B5
IGNvbW1hbmQgKHNpbmdsZSBOUyksIGluY2x1ZGluZyBzdXBwb3J0IGluIG52bWUtdGFyZ2V0IChm
b3IKPj4+Pj4+ICAgICAgYmxvY2sgYW5kIGZpbGUgYmFja2VuZCkKPj4+Pj4KPj4+Pj4gSXQgd291
bGQgYWxzbyBiZSBuaWNlIHRvIGhhdmUgY29weSBvZmZsb2FkIGVtdWxhdGlvbiBpbiBudWxsX2Js
ayBmb3IgdGVzdGluZy4KPj4+Pj4KPj4+Pgo+Pj4+IFdlIGNhbiBwbGFuIHRoaXMgaW4gbmV4dCBw
aGFzZSBvZiBjb3B5IHN1cHBvcnQsIG9uY2UgdGhpcyBzZXJpZXMgc2V0dGxlcyBkb3duLgo+Pj4K
Pj4+IFNvIGhvdyBjYW4gcGVvcGxlIHRlc3QgeW91ciBzZXJpZXMgPyBOb3QgYSBsb3Qgb2YgZHJp
dmVzIG91dCB0aGVyZSB3aXRoCj4+PiBjb3B5IHN1cHBvcnQuCj4+Pgo+Pgo+PiBZZWFoIG5vdCBt
YW55IGRyaXZlcyBhdCBwcmVzZW50LCBRZW11IGNhbiBiZSB1c2VkIHRvIHRlc3QgTlZNZSBjb3B5
Lgo+IAo+IFVwc3RyZWFtIFFFTVUgPyBXaGF0IGlzIHRoZSBjb21tYW5kIGxpbmUgb3B0aW9ucyA/
IEFuIGV4YW1wbGUgd291bGQgYmUKPiBuaWNlLiBCdXQgSSBzdGlsbCB0aGluayBudWxsX2JsayBz
dXBwb3J0IHdvdWxkIGJlIGVhc2llc3QuCgorMSBmb3IgYWRkaW5nIGNvcHkgb2ZmbG9hZGluZyBz
dXBwb3J0IGluIG51bGxfYmxrLiBUaGF0IGVuYWJsZXMgcnVubmluZyAKY29weSBvZmZsb2FkaW5n
IHRlc3RzIHdpdGhvdXQgZGVwZW5kaW5nIG9uIFFlbXUuCgpUaGFua3MsCgpCYXJ0LgoKLS0KZG0t
ZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

