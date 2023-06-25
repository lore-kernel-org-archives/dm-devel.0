Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9156DC0015E
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971629;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0K/IjNj/XdDgqHV/tQ4bMpad+Ajr/ABTFB9v80fGB6c=;
	b=UZNXddEYQRr2dMn1CeK0S3nJlZnX8W57HL3CUPIduh7UV3eQ+RlYe3Ii8AdM3O4tbs+a5+
	xF/22rtOKZYl9eSx9jGzre/hFXo3huaVYL0+q9iMtqIuVrcW8qXmaH2tRQ/Z2+x+paXSPa
	RppuGiCWvh4168tqY1sM1M4TmQvLlAQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-kE5RSUm7OmarMROAzm6QeQ-1; Mon, 10 Jul 2023 02:47:07 -0400
X-MC-Unique: kE5RSUm7OmarMROAzm6QeQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 080801C31C52;
	Mon, 10 Jul 2023 06:46:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E78A1C51488;
	Mon, 10 Jul 2023 06:46:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 205E2194973C;
	Mon, 10 Jul 2023 06:46:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 658E11946587
 for <dm-devel@listman.corp.redhat.com>; Sun, 25 Jun 2023 03:15:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4055214682F9; Sun, 25 Jun 2023 03:15:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 38B6D14682FB
 for <dm-devel@redhat.com>; Sun, 25 Jun 2023 03:15:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BE7928040A6
 for <dm-devel@redhat.com>; Sun, 25 Jun 2023 03:15:15 +0000 (UTC)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-Lq76TH86M3a250dx3mvqUw-1; Sat, 24 Jun 2023 23:15:11 -0400
X-MC-Unique: Lq76TH86M3a250dx3mvqUw-1
Received: by mail-pf1-f169.google.com with SMTP id
 d2e1a72fcca58-6687b209e5aso495378b3a.0
 for <dm-devel@redhat.com>; Sat, 24 Jun 2023 20:15:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687662910; x=1690254910;
 h=content-transfer-encoding:in-reply-to:references:cc:to:from
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=TKI5JnbDIC0GxIDWgHq4O/cOoJK+mFi4lHzSLMfVTqU=;
 b=MjW6ZOmV+28Ns4IqkMOEkTmg714VEvGqu0DYAMPwKXjxueR+WABKZ4mu6tlVEWkqKl
 EJ11jnzdrvilIFsTt/6rprnqcAxCl4bkP2NUiYHbB5FwI8DQTKNyAlDduRHIJu73KJKu
 YL5r2Bf+URv+p66uMbzANwoHhO9T956nM3pLUvQsXUdR5Alp1swBrEx+ZPG1DIEuly+5
 MEu1KKKp3aa2vgxwnF6kVsNQJT2BfSEjMDAcGyirbBXUKmGIPpHmkZlXvTWoMzc4nkLs
 aL18nloIEERwejTQwGvEbu97O3pMDqfj3Q6nDaO+p7ZlEHYP6Olhw8OLQe3kBPMZa4sh
 +yWg==
X-Gm-Message-State: AC+VfDxihBFU8P3K0FjQKvTnNNLNazxBiSP3UbMHU91mfWCd5+Lr/378
 nWlLwji1RUQ170SZplnbiIbfQA==
X-Google-Smtp-Source: ACHHUZ4cDGND46+rMO/jpoItKK6gyWoVPMpHTImOruhTgKiq3D9MdRMxw7KZsaNY9vtDgu3MtWReMw==
X-Received: by 2002:a05:6a20:8426:b0:11f:7829:6d6c with SMTP id
 c38-20020a056a20842600b0011f78296d6cmr28507253pzd.3.1687662910560; 
 Sat, 24 Jun 2023 20:15:10 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.146])
 by smtp.gmail.com with ESMTPSA id
 r9-20020a62e409000000b0066642f95bc5sm1648412pfh.35.2023.06.24.20.15.03
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 24 Jun 2023 20:15:10 -0700 (PDT)
Message-ID: <00641d5b-86a3-f5d1-02ee-13b4f815df75@bytedance.com>
Date: Sun, 25 Jun 2023 11:15:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: Dave Chinner <david@fromorbit.com>, paulmck@kernel.org
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-25-zhengqi.arch@bytedance.com>
 <cf0d9b12-6491-bf23-b464-9d01e5781203@suse.cz>
 <ZJU708VIyJ/3StAX@dread.disaster.area>
 <a21047bb-3b87-a50a-94a7-f3fa4847bc08@bytedance.com>
 <ZJYaYv4pACmCaBoT@dread.disaster.area>
 <a7baf44a-1eb8-d4e1-d112-93cf9cdb7beb@bytedance.com>
In-Reply-To: <a7baf44a-1eb8-d4e1-d112-93cf9cdb7beb@bytedance.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH 24/29] mm: vmscan: make global slab shrink
 lockless
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
Cc: djwong@kernel.org, roman.gushchin@linux.dev,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 linux-mm@kvack.org, dm-devel@redhat.com, linux-ext4@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-nfs@vger.kernel.org, RCU <rcu@vger.kernel.org>,
 linux-bcache@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
 linux-raid@vger.kernel.org, brauner@kernel.org, tytso@mit.edu,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIzLzYvMjQgMTk6MDgsIFFpIFpoZW5nIHdyb3RlOgo+IEhpIERhdmUsCj4gCj4gT24g
MjAyMy82LzI0IDA2OjE5LCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4+IE9uIEZyaSwgSnVuIDIzLCAy
MDIzIGF0IDA5OjEwOjU3UE0gKzA4MDAsIFFpIFpoZW5nIHdyb3RlOgo+Pj4gT24gMjAyMy82LzIz
IDE0OjI5LCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4+Pj4gT24gVGh1LCBKdW4gMjIsIDIwMjMgYXQg
MDU6MTI6MDJQTSArMDIwMCwgVmxhc3RpbWlsIEJhYmthIHdyb3RlOgo+Pj4+PiBPbiA2LzIyLzIz
IDEwOjUzLCBRaSBaaGVuZyB3cm90ZToKPj4+PiBZZXMsIEkgc3VnZ2VzdGVkIHRoZSBJRFIgcm91
dGUgYmVjYXVzZSByYWRpeCB0cmVlIGxvb2t1cHMgdW5kZXIgUkNVCj4+Pj4gd2l0aCByZWZlcmVu
Y2UgY291bnRlZCBvYmplY3RzIGFyZSBhIGtub3duIHNhZmUgcGF0dGVybiB0aGF0IHdlIGNhbgo+
Pj4+IGVhc2lseSBjb25maXJtIGlzIGNvcnJlY3Qgb3Igbm90LsKgIEhlbmNlIEkgc3VnZ2VzdGVk
IHRoZSB1bmlmaWNhdGlvbgo+Pj4+ICsgSURSIHJvdXRlIGJlY2F1c2UgaXQgbWFrZXMgdGhlIGxp
ZmUgb2YgcmV2aWV3ZXJzIHNvLCBzbyBtdWNoCj4+Pj4gZWFzaWVyLi4uCj4+Pgo+Pj4gSW4gZmFj
dCwgSSBvcmlnaW5hbGx5IHBsYW5uZWQgdG8gdHJ5IHRoZSB1bmlmaWNhdGlvbiArIElEUiBtZXRo
b2QgeW91Cj4+PiBzdWdnZXN0ZWQgYXQgdGhlIGJlZ2lubmluZy4gQnV0IGluIHRoZSBjYXNlIG9m
IENPTkZJR19NRU1DRyBkaXNhYmxlZCwKPj4+IHRoZSBzdHJ1Y3QgbWVtX2Nncm91cCBpcyBub3Qg
ZXZlbiBkZWZpbmVkLCBhbmQgcm9vdF9tZW1fY2dyb3VwIGFuZAo+Pj4gc2hyaW5rZXJfaW5mbyB3
aWxsIG5vdCBiZSBhbGxvY2F0ZWQuwqAgVGhpcyByZXF1aXJlZCBtb3JlIGNvZGUgCj4+PiBjaGFu
Z2VzLCBzbwo+Pj4gSSBlbmRlZCB1cCBrZWVwaW5nIHRoZSBzaHJpbmtlcl9saXN0IGFuZCBpbXBs
ZW1lbnRpbmcgdGhlIGFib3ZlIHBhdHRlcm4uCj4+Cj4+IFllcy4gR28gYmFjayBhbmQgcmVhZCB3
aGF0IEkgb3JpZ2luYWxseSBzYWlkIG5lZWRlZCB0byBiZSBkb25lCj4+IGZpcnN0LiBJbiB0aGUg
Y2FzZSBvZiBDT05GSUdfTUVNQ0c9biwgYSBkdW1teSByb290IG1lbWNnIHN0aWxsIG5lZWRzCj4+
IHRvIGV4aXN0IHRoYXQgaG9sZHMgYWxsIG9mIHRoZSBnbG9iYWwgc2hyaW5rZXJzLiBUaGVuIHNo
cmlua19zbGFiKCkKPj4gaXMgb25seSBldmVyIHBhc3NlZCBhIG1lbWNnIHRoYXQgc2hvdWxkIGJl
IGl0ZXJhdGVkLgo+Pgo+PiBZZXMsIGl0IG5lZWRzIGNoYW5nZXMgZXh0ZXJuYWwgdG8gdGhlIHNo
cmlua2VyIGNvZGUgaXRzZWxmIHRvIGJlCj4+IG1hZGUgdG8gd29yay4gQW5kIGV2ZW4gaWYgbWVt
Y2cncyBhcmUgbm90IGVuYWJsZWQsIHdlIGNhbiBzdGlsbCB1c2UKPj4gdGhlIG1lbWNnIHN0cnVj
dHVyZXMgdG8gZW5zdXJlIGEgY29tbW9uIGFic3RyYWN0aW9uIGlzIHVzZWQgZm9yIHRoZQo+PiBz
aHJpbmtlciB0cmFja2luZyBpbmZyYXN0cnVjdHVyZS4uLi4KPiAKPiBZZWFoLCB3aGF0IEkgaW1h
Z2luZWQgYmVmb3JlIHdhcyB0byBkZWZpbmUgYSBtb3JlIGNvbmNpc2Ugc3RydWN0Cj4gbWVtX2Nn
cm91cCBpbiB0aGUgY2FzZSBvZiBDT05GSUdfTUVNQ0c9biwgdGhlbiBhbGxvY2F0ZSBhIGR1bW15
IHJvb3QKPiBtZW1jZyBvbiBzeXN0ZW0gYm9vdDoKPiAKPiAjaWZkZWYgIUNPTkZJR19NRU1DRwo+
IAo+IHN0cnVjdCBzaHJpbmtlcl9pbmZvIHsKPiAgwqDCoMKgwqBzdHJ1Y3QgcmN1X2hlYWQgcmN1
Owo+ICDCoMKgwqDCoGF0b21pY19sb25nX3QgKm5yX2RlZmVycmVkOwo+ICDCoMKgwqDCoHVuc2ln
bmVkIGxvbmcgKm1hcDsKPiAgwqDCoMKgwqBpbnQgbWFwX25yX21heDsKPiB9Owo+IAo+IHN0cnVj
dCBtZW1fY2dyb3VwX3Blcl9ub2RlIHsKPiAgwqDCoMKgwqBzdHJ1Y3Qgc2hyaW5rZXJfaW5mbyBf
X3JjdcKgwqDCoCAqc2hyaW5rZXJfaW5mbzsKPiB9Owo+IAo+IHN0cnVjdCBtZW1fY2dyb3VwIHsK
PiAgwqDCoMKgwqBzdHJ1Y3QgbWVtX2Nncm91cF9wZXJfbm9kZSAqbm9kZWluZm9bXTsKPiB9Owo+
IAo+ICNlbmRpZgo+IAo+IEJ1dCBJIGhhdmUgYSBjb25jZXJuOiBpZiBhbGwgZ2xvYmFsIHNocmlu
a2VycyBhcmUgdHJhY2tpbmcgd2l0aCB0aGUKPiBpbmZvLT5tYXAgb2Ygcm9vdCBtZW1jZywgYSBz
aHJpbmtlci0+aWQgbmVlZHMgdG8gYmUgYXNzaWduZWQgdG8gdGhlbSwKPiB3aGljaCB3aWxsIGNh
dXNlIGluZm8tPm1hcF9ucl9tYXggdG8gYmVjb21lIGxhcmdlciB0aGFuIGJlZm9yZSwgdGhlbgo+
IG1ha2luZyB0aGUgdHJhdmVyc2FsIG9mIGluZm8tPm1hcCBzbG93ZXIuCgpCdXQgbW9zdCBvZiB0
aGUgc3lzdGVtIGlzICdzYi14eHgnIHNocmlua2VyIGluc3RhbmNlcywgdGhleSBhbGwgaGF2ZQp0
aGUgU0hSSU5LRVJfTUVNQ0dfQVdBUkUgZmxhZywgc28gaXQgc2hvdWxkIGhhdmUgbGl0dGxlIGlt
cGFjdCBvbiB0aGUKc3BlZWQgb2YgdHJhdmVyc2luZyBpbmZvLT5tYXAuIDspCgo+IAo+Pgo+Pj4g
SWYgdGhlIGFib3ZlIHBhdHRlcm4gaXMgbm90IHNhZmUsIEkgd2lsbCBnbyBiYWNrIHRvIHRoZSB1
bmlmaWNhdGlvbiArCj4+PiBJRFIgbWV0aG9kLgo+Pgo+PiBBbmQgdGhhdCBpcyBleGFjdGx5IGhv
dyB3ZSBnb3QgaW50byB0aGlzIG1lc3MgaW4gdGhlIGZpcnN0IHBsYWNlLi4uLgo+IAo+IEkgb25s
eSBmb3VuZCBvbmUgc2ltaWxhciBwYXR0ZXJuIGluIHRoZSBrZXJuZWw6Cj4gCj4gZnMvc21iL3Nl
cnZlci9vcGxvY2suYzpmaW5kX3NhbWVfbGVhc2Vfa2V5L3NtYl9icmVha19hbGxfbGV2SUlfb3Bs
b2NrL2xvb2t1cF9sZWFzZV9pbl90YWJsZQo+IAo+IEJ1dCBJSVVDLCB0aGUgcmVmY291bnQgaGVy
ZSBuZWVkcyB0byBiZSBkZWNyZW1lbnRlZCBhZnRlciBob2xkaW5nCj4gcmN1IGxvY2sgYXMgSSBk
aWQgYWJvdmUuCj4gCj4gU28gcmVnYXJkbGVzcyBvZiB3aGV0aGVyIHdlIGNob29zZSB1bmlmaWNh
dGlvbiArIElEUiBpbiB0aGUgZW5kLCBJIHN0aWxsCj4gd2FudCB0byBjb25maXJtIHdoZXRoZXIg
dGhlIHBhdHRlcm4gSSBpbXBsZW1lbnRlZCBhYm92ZSBpcyBzYWZlLiA6KQoKQWxzbyArIFJDVSBt
YWlsaW5nIGxpc3QuCgo+IAo+IFRoYW5rcywKPiBRaQo+IAo+Pgo+PiAtRGF2ZQoKLS0KZG0tZGV2
ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

