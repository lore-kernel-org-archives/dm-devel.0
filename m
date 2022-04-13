Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5387AC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 13 Apr 2022 07:55:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-178-jIK7IxQ9PQSqNBoF8ew1EA-1; Wed, 13 Apr 2022 03:55:42 -0400
X-MC-Unique: jIK7IxQ9PQSqNBoF8ew1EA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3F87803D7C;
	Wed, 13 Apr 2022 07:55:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 75EA540E80E0;
	Wed, 13 Apr 2022 07:55:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1DB63194036A;
	Wed, 13 Apr 2022 07:55:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8FC8E1949763
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Apr 2022 07:55:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4FFDC2166BDF; Wed, 13 Apr 2022 07:55:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B4212166BB3
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 07:55:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E85D8805A30
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 07:55:04 +0000 (UTC)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
 [209.85.128.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-R73R9cebNi6DZA4zO9848w-1; Wed, 13 Apr 2022 03:55:03 -0400
X-MC-Unique: R73R9cebNi6DZA4zO9848w-1
Received: by mail-wm1-f43.google.com with SMTP id
 ay11-20020a05600c1e0b00b0038eb92fa965so3364608wmb.4
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 00:55:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=Jw6W9TibZfydU2ZMyUQ8RG/3hYhASIcb1Bb7NIi62AI=;
 b=P31AE7F/EENCKwYSOMNNpXWr4zIw1IZEQr9OGW+xIhJaY33KvEi+tqeba6fxz8YArp
 P+KuC8dd903Of3+YRES+FbnWLXtoPcHCnBMCLiNuUlIler8YNDxuygbxMLYhHzl+wzpD
 DexbyhjY8PrN2Tlv06C/OUhGrLB8aW6doOFgB+/o3c749s/LTQB0c35vLqmIBVhDQlLR
 RtO9tBtSruO6j4/E/KpssesfEhzLB6tcMJUTfI9cdmZJYA5hYAYoWiJw9gdnJHfRLFY+
 XDrbn5Owx7dVYz+vUCuxQgp+HDMZbtrjoTA7YmYSi+ckiFoKRLN9n5uo9qkotQDHiVZ9
 ptZA==
X-Gm-Message-State: AOAM530bxyr3y0Vd38O6Lpzbm0kaZgrAuo6wn12dYdNVGbQIQqaADrzT
 MB8Mp5Ydhlb6KX2i26kcFyQk0fnanU4=
X-Google-Smtp-Source: ABdhPJx3E8yY5wAYxQ6e6ZgETpSWGYmeIzXanzqG6DxbWCLGf+gsFjaKYEJMl2W1eE0bYgUs/0i1Rg==
X-Received: by 2002:a1c:e911:0:b0:38e:6c5d:40e5 with SMTP id
 q17-20020a1ce911000000b0038e6c5d40e5mr7342473wmc.116.1649836501575; 
 Wed, 13 Apr 2022 00:55:01 -0700 (PDT)
Received: from [192.168.0.99] ([83.148.32.207])
 by smtp.gmail.com with ESMTPSA id
 s7-20020a5d6a87000000b00207aad420c4sm5510229wru.101.2022.04.13.00.55.00
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 13 Apr 2022 00:55:01 -0700 (PDT)
Message-ID: <cebf10ca-ccf6-0809-dcff-3634817d8a5e@gmail.com>
Date: Wed, 13 Apr 2022 09:55:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
To: dm-devel@redhat.com
References: <YlNUhtXltj8vgvcZ@itl-email>
 <e65dbacc-f241-22ba-62a9-a6f522cce9dc@redhat.com>
 <YlRjvp7SH3To0pHe@itl-email>
 <cc43900d-35a3-14ae-73ef-919ab02e01ff@redhat.com>
 <YlSsMlcE5x2B58hc@itl-email>
 <6a6c09ad-73c9-2450-f1fb-0e3e4ba438e6@redhat.com>
 <20220412142905.GA26912@redhat.com>
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <20220412142905.GA26912@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] Potential enhancements to dm-thin v2
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
Cc: Demi Marie Obenour <demi@invisiblethingslab.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

RG5lIDEyLiAwNC4gMjIgdiAxNjoyOSBEYXZpZCBUZWlnbGFuZCBuYXBzYWwoYSk6Cj4gRG5lIDEx
LiAwNC4gMjIgdiAwOjAzIERlbWkgTWFyaWUgT2Jlbm91ciBuYXBzYWwoYSk6Cj4+IEZvciBxdWl0
ZSBhIHdoaWxlLCBJIGhhdmUgd2FudGVkIHRvIHdyaXRlIGEgdG9vbCB0byBtYW5hZ2UgdGhpbiB2
b2x1bWVzCj4+IHRoYXQgaXMgbm90IGJhc2VkIG9uIExWTS4KPiAKPiBPbiBUdWUsIEFwciAxMiwg
MjAyMiBhdCAxMTozMjowOUFNICswMjAwLCBaZGVuZWsgS2FiZWxhYyB3cm90ZToKPj4gSGVyZSBp
cyBhY3R1YWxseSB0aGUgZnVuZGFtZW50YWwgcHJvYmxlbSB3aXRoIHlvdXIgcHJvcG9zYWwgLSBv
dXIgZGVzaWduIHdhcwo+PiBhYm91dCBjYXJlZnVsIHNwbGl0IGJldHdlZW4gdXNlci1zcGFjZSBh
bmQga2VybmVsICd3aG8gaXMgdGhlIG93bmVyL2hvbGRlcgo+PiBvZiBpbmZvcm1hdGlvbifCoCAt
IHlvdXIgcHJvcG9zYWwgdW5mb3J0dW5hdGVseSBkb2VzIG5vdCBmaXQgdGhlIG1vZGVsIHdoZXJl
Cj4+IGx2bTIgaXMgdGhlIGF1dGhvcml0YXRpdmUgb3duZXIgb2YgaW5mbyBhYm91dCBkZXZpY2Vz
Cj4gCj4gVGhlIHByb3Bvc2FsIGlzIGEgbmV3IHRvb2wgdG8gbWFuYWdlIGRtLXRoaW4gZGV2aWNl
cywgbm90IHRvIHJld3JpdGUgbHZtLgo+IEkgd291bGQgaG9wZSB0aGUgdG9vbCBpcyBub3RoaW5n
IGF0IGFsbCBsaWtlIGx2bSwgYnV0IHJhdGhlciAidGhpbnNldHVwIgo+IGluIHRoZSB0cmFkaXRp
b24gb2YgZG1zZXR1cCwgY3J5cHRzZXR1cC4gIEkgdGhpbmsgaXQncyBhIGdyZWF0IGlkZWEgYW5k
Cj4gaGF2ZSB3YW50ZWQgc3VjaCBhIHRvb2wgZm9yIHllYXJzLiAgSSBoYXZlIGEgZmVlbGluZyB0
aGF0IG1hbnkgaGF2ZQo+IGFscmVhZHkgd3JpdHRlbiBhZCBob2MgdGhpbnNldHVwLWxpa2UgdG9v
bHMsIGFuZCB0aGVyZSB3b3VsZCBiZSBmYWlybHkKPiBicm9hZCBpbnRlcmVzdCBpbiBpdCAoZXNw
ZWNpYWxseSBpZiBpdCBoYXMgYSBwcm9wZXIgbGliIGFwaS4pCj4gCgoKVGhlIHByb2JsZW0gd2l0
aCB0aGVzZSAnYWQtaG9jJyB0b29scyBpcyB0aGVpciAnc3VwcG9ydCAtIGFrYSBob3cgdG8gcHJv
Y2VlZCAKaW4gY2FzZSBvZiBhbnkgZmFpbHVyZS4KClNvIHdoaWxlIHRoZXJlIHdpbGwgYmUgbm8g
cHJvYmxlbSB0byBnZW5lcmF0ZSBtYW55IGRldmljZSBpbiB2ZXJ5IGZhc3Qgd2F5IC0gCnRoZSBy
ZWNvdmVyYWJpbGl0eSBmcm9tIGZhaWx1cmUgd2lsbCB0aGVuIGJlIGFsd2F5cyBpbmRpdmlkdWFs
IGJhc2VkIG9uIHRoZSAKc3Vycm91bmRpbmcgZW52aXJvbm1lbnQuCgpTbyBpdCdzIGluIHRoZSBw
cmluY2lwbGUgdGhlIHZlcnkgc2FtZSBjYXNlIGFzIHRoZSByZXF1ZXN0IGZvciBzdXBwb3J0IG9m
IAptYW5hZ2luZyBETSBkZXZpY2VzIHdpdGggJ2V4dGVybmFsJyBtZXRhZGF0YSAtIGlmIHRoZXJl
IGFyZSBkaWZmZXJlbnQgCmNvbnN0cmFpbnMgdG8gbWF0Y2ggLSB5b3UgZW5kIHdpdGggZGlmZmVy
ZW50IHJlcXVpcmVtZW50cyBvbiB0aGUgdG9vbC4KCklmIHRoZXJlIGlzIHB1cmUgZm9jdXMgb24g
dGhpbiBkZXZpY2UgbWFuYWdlbWVudCAtIHN1cmVseSBhIHN0YW5kYWxvbmUgdG9vbCAKZG9lcyB0
aGlzIGpvYnMgZmFzdGVyLgoKClpkZW5lawoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRl
dmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbAo=

