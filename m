Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B26A6C43334
	for <dm-devel@archiver.kernel.org>; Thu, 16 Jun 2022 20:32:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-355-5xz9mgw3N7S_03CpG9uokA-1; Thu, 16 Jun 2022 16:32:12 -0400
X-MC-Unique: 5xz9mgw3N7S_03CpG9uokA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52134101AA46;
	Thu, 16 Jun 2022 20:32:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D58091121314;
	Thu, 16 Jun 2022 20:32:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B79C1194705F;
	Thu, 16 Jun 2022 20:32:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5CD71194705D
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Jun 2022 20:32:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3AF0EC23DBF; Thu, 16 Jun 2022 20:32:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 372DDC08087
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 20:32:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EBCF3817A6F
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 20:32:07 +0000 (UTC)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com
 [209.85.128.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-QDVC6ceJOoGljTw0oFEGsQ-1; Thu, 16 Jun 2022 16:32:03 -0400
X-MC-Unique: QDVC6ceJOoGljTw0oFEGsQ-1
Received: by mail-wm1-f54.google.com with SMTP id z17so1341471wmi.1;
 Thu, 16 Jun 2022 13:32:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=Nhv8AFueLhsJdYQbBTxVg+GTWN7yx+aYmJx09zF/dG0=;
 b=o29pti0DY9qGPp442Gm6GcGL9/WB7YAvJm8U0qJ9bpNpENTXdbQ4AkHGDymeVp+3mt
 S0OpebD5vXP0rfkDXOzGQCj43F46nvqYHsgvgbOFi7gggkvpNggfIVZRfxD/os5zWuCl
 wPTsGhLi6opFSHZFC4nSuuX7SUC0fZRN4lgdYP1SyKYCqpLHHfNFSwWJT4c33cC8cv/y
 tiMxCnSYNeZKaxpqDyhukfS+QPIi/R2/O8cpeGGmBpaeYXj8sDM9+0FWz7ecBOIR4HTw
 n71DhtwzJcxtHMs1ebwjEWCI6T3b2JqVQm4ujvZ7wiHpPWcuh2a7l2g2qOC/XnXexpDh
 7obA==
X-Gm-Message-State: AJIora8hu40Q/kUSgp2CyEgq2a2TJDMdr04fMZ2jnl0B2R04a+H9iOcn
 F5XCdGND/Bm8Mn7e+cNgvKbjevuz3A==
X-Google-Smtp-Source: AGRyM1vAT+ILREd9ONDNG8k8Hm8X6CFlidrh50/Z+5+B7CZNAsGzpF4Tm5TxnQ9k2yHSo9I+86z6KA==
X-Received: by 2002:a05:600c:4f4e:b0:39c:1bbb:734f with SMTP id
 m14-20020a05600c4f4e00b0039c1bbb734fmr6678268wmq.116.1655411521885; 
 Thu, 16 Jun 2022 13:32:01 -0700 (PDT)
Received: from localhost (226.red-81-44-147.dynamicip.rima-tde.net.
 [81.44.147.226]) by smtp.gmail.com with ESMTPSA id
 o12-20020a05600c4fcc00b0039751bb8c62sm7464580wmq.24.2022.06.16.13.32.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 16 Jun 2022 13:32:01 -0700 (PDT)
Message-ID: <950f4ffe-7cf6-b385-1141-f27fbf5ebef9@gmail.com>
Date: Thu, 16 Jun 2022 22:32:00 +0200
MIME-Version: 1.0
To: Martin Wilck <mwilck@suse.com>
References: <20220328170404.8565-1-xose.vazquez@gmail.com>
 <5187f68e1a6595d47d10a05ea01931e1ce8cad27.camel@suse.com>
 <9bdd8437-741b-ff0c-068c-9d8cf211fff0@gmail.com>
 <6e92e5c8678e66808f94b844f86f2573e41ebb01.camel@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <6e92e5c8678e66808f94b844f86f2573e41ebb01.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] multipath-tools: add basic info on how to
 use multipath-tools with NVMe devices
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNC8xLzIyIDEyOjIwLCBNYXJ0aW4gV2lsY2sgd3JvdGU6Cgo+IE9uIE1vbiwgMjAyMi0wMy0y
OCBhdCAxOTo1NyArMDIwMCwgWG9zZSBWYXpxdWV6IFBlcmV6IHdyb3RlOgo+PiBPbiAzLzI4LzIy
IDE5OjQ4LCBNYXJ0aW4gV2lsY2sgd3JvdGU6Cj4+PiBPbiBNb24sIDIwMjItMDMtMjggYXQgMTk6
MDQgKzAyMDAsIFhvc2UgVmF6cXVleiBQZXJleiB3cm90ZToKPj4+PiBDYzogTWFydGluIFdpbGNr
IDxtd2lsY2tAc3VzZS5jb20+Cj4+Pj4gQ2M6IEJlbmphbWluIE1hcnppbnNraSA8Ym1hcnppbnNA
cmVkaGF0LmNvbT4KPj4+PiBDYzogQ2hyaXN0b3BoZSBWYXJvcXVpIDxjaHJpc3RvcGhlLnZhcm9x
dWlAb3BlbnN2Yy5jb20+Cj4+Pj4gQ2M6IERNLURFVkVMIE1MIDxkbS1kZXZlbEByZWRoYXQuY29t
Pgo+Pj4+IFNpZ25lZC1vZmYtYnk6IFhvc2UgVmF6cXVleiBQZXJleiA8eG9zZS52YXpxdWV6QGdt
YWlsLmNvbT4KPj4+PiAtLS0KPj4+PiAgwqDCoFJFQURNRS5udm1lIHwgMTIgKysrKysrKysrKysr
Cj4+Pj4gIMKgwqAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKQo+Pj4+ICDCoMKgY3Jl
YXRlIG1vZGUgMTAwNjQ0IFJFQURNRS5udm1lCj4+Pgo+Pj4gV2h5IGFub3RoZXIgc2VwYXJhdGUg
UkVBRE1FIHdpdGgganVzdCAxMiBsaW5lcz8KPj4+Cj4+PiBNYXJ0aW4KPj4KPj4gUkVBRE1FLm1k
IGlzIGludGVuZGVkIG11bHRpcGF0aC10b29scyBkZXZlbG9wZXJzLgo+PiBBbmQgUkVBRE1FLmFs
dWEgYW5kIFJFQURNRS5udm1lIGFyZSBmb3Igc3lzYWRtaW5zLgo+Pgo+IAo+IEkgc2VlIG5vIGZ1
bmRhbWVudGFsIHJlYXNvbiBub3QgdG8gbWVyZ2UgYWxsIFJFQURNRXMgaW50byBvbmUsCj4gYW5k
IGNyZWF0ZSAic3lzYWRtaW4iIGFuZCAiZGV2ZWxvcGVyIiBzZWN0aW9ucy4KClJFQURNRS5tZCBp
cyBpbiBtYXJrZG93biBzeW50YXguClJFQURNRS5hbHVhIGFuZCBSRUFETUUubnZtZSBhcmUgcGxh
aW4gdGV4dCwgYW5kIGl0cyBjb250ZW50IGlzIGVhc2llciB0byBpZGVudGlmeS4KQXJlIHlvdSBy
dW5uaW5nIG91dCBvZiBpbm9kZXM/IDotKQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRl
dmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbAo=

