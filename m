Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADD70EE14D4
	for <dm-devel@archiver.kernel.org>; Thu,  7 Sep 2023 05:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694065809;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eWcZ9pb80CrkI6AhpSbyfovEBQ6kgXK9Pyn23KOGVYY=;
	b=Nqf9AN5h5mLUehin9TApA1yBGBTmt4tKRqGRBrAD0kQQvcjmdkdCx3oxQd4zCtJH0vKrlL
	GguoQtw7CprS9e4xcVNHO0u7+drIWEDJnmf8Cg5V8mJVVa1E3ic0ud9y2SEmnCTG8oPWnO
	FiqQWK7h/CA/WKpVUtXV6rXoBZ5jLKg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-_9Q6_QBwN2iaJfYINP0Mcg-1; Thu, 07 Sep 2023 01:50:08 -0400
X-MC-Unique: _9Q6_QBwN2iaJfYINP0Mcg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71AA6382255B;
	Thu,  7 Sep 2023 05:50:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5D2B6C03292;
	Thu,  7 Sep 2023 05:50:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3CA95194658F;
	Thu,  7 Sep 2023 05:50:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 57AEC1946595
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Sep 2023 05:50:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2CAFB1678B; Thu,  7 Sep 2023 05:50:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2529110EA0
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 05:50:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01D99181C983
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 05:50:04 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-202-6WsuAHAuNqSdr-6SEKwLHA-1; Thu,
 07 Sep 2023 01:50:03 -0400
X-MC-Unique: 6WsuAHAuNqSdr-6SEKwLHA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id D54322184B;
 Thu,  7 Sep 2023 05:50:01 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A2E3B13458;
 Thu,  7 Sep 2023 05:50:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id fk1vIYhk+WRcYAAAMHmgww
 (envelope-from <hare@suse.de>); Thu, 07 Sep 2023 05:50:00 +0000
Message-ID: <b0f3d320-047b-4bd8-a6fc-25b468caf5b3@suse.de>
Date: Thu, 7 Sep 2023 07:49:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
References: <20230906163844.18754-1-nj.shetty@samsung.com>
 <CGME20230906164312epcas5p397662c68dde1dbc4dc14c3e80ca260b3@epcas5p3.samsung.com>
 <20230906163844.18754-4-nj.shetty@samsung.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230906163844.18754-4-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v15 03/12] block: add copy offload support
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
Cc: martin.petersen@oracle.com, linux-doc@vger.kernel.org, gost.dev@samsung.com,
 Anuj Gupta <anuj20.g@samsung.com>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, mcgrof@kernel.org,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gOS82LzIzIDE4OjM4LCBOaXRlc2ggU2hldHR5IHdyb3RlOgo+IEludHJvZHVjZSBibGtkZXZf
Y29weV9vZmZsb2FkIHRvIHBlcmZvcm0gY29weSBvZmZsb2FkLgo+IElzc3VlIFJFUV9PUF9DT1BZ
X1NSQyB3aXRoIHNvdXJjZSBpbmZvIGFsb25nIHdpdGggdGFraW5nIGEgcGx1Zy4KPiBUaGlzIGZs
b3dzIHRpbGwgcmVxdWVzdCBsYXllciBhbmQgd2FpdHMgZm9yIGRzdCBiaW8gdG8gYXJyaXZlLgo+
IElzc3VlIFJFUV9PUF9DT1BZX0RTVCB3aXRoIGRlc3RpbmF0aW9uIGluZm8gYW5kIHRoaXMgYmlv
IHJlYWNoZXMgcmVxdWVzdAo+IGxheWVyIGFuZCBtZXJnZXMgd2l0aCBzcmMgcmVxdWVzdC4KPiBG
b3IgYW55IHJlYXNvbiwgaWYgYSByZXF1ZXN0IGNvbWVzIHRvIHRoZSBkcml2ZXIgd2l0aCBvbmx5
IG9uZSBvZiBzcmMvZHN0Cj4gYmlvLCB3ZSBmYWlsIHRoZSBjb3B5IG9mZmxvYWQuCj4gCj4gTGFy
Z2VyIGNvcHkgd2lsbCBiZSBkaXZpZGVkLCBiYXNlZCBvbiBtYXhfY29weV9zZWN0b3JzIGxpbWl0
Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFudWogR3VwdGEgPGFudWoyMC5nQHNhbXN1bmcuY29tPgo+
IFNpZ25lZC1vZmYtYnk6IE5pdGVzaCBTaGV0dHkgPG5qLnNoZXR0eUBzYW1zdW5nLmNvbT4KPiAt
LS0KPiAgIGJsb2NrL2Jsay1saWIuYyAgICAgICAgfCAyMDIgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysKPiAgIGluY2x1ZGUvbGludXgvYmxrZGV2LmggfCAgIDQgKwo+
ICAgMiBmaWxlcyBjaGFuZ2VkLCAyMDYgaW5zZXJ0aW9ucygrKQo+IAo+IGRpZmYgLS1naXQgYS9i
bG9jay9ibGstbGliLmMgYi9ibG9jay9ibGstbGliLmMKPiBpbmRleCBlNTljMzA2OWU4MzUuLmQy
MmUxZTc0MTdjYSAxMDA2NDQKPiAtLS0gYS9ibG9jay9ibGstbGliLmMKPiArKysgYi9ibG9jay9i
bGstbGliLmMKPiBAQCAtMTAsNiArMTAsMjIgQEAKPiAgIAo+ICAgI2luY2x1ZGUgImJsay5oIgo+
ICAgCj4gKy8qIEtlZXBzIHRyYWNrIG9mIGFsbCBvdXRzdGFuZGluZyBjb3B5IElPICovCj4gK3N0
cnVjdCBibGtkZXZfY29weV9pbyB7Cj4gKwlhdG9taWNfdCByZWZjb3VudDsKPiArCXNzaXplX3Qg
Y29waWVkOwo+ICsJaW50IHN0YXR1czsKPiArCXN0cnVjdCB0YXNrX3N0cnVjdCAqd2FpdGVyOwo+
ICsJdm9pZCAoKmVuZGlvKSh2b2lkICpwcml2YXRlLCBpbnQgc3RhdHVzLCBzc2l6ZV90IGNvcGll
ZCk7Cj4gKwl2b2lkICpwcml2YXRlOwo+ICt9Owo+ICsKPiArLyogS2VlcHMgdHJhY2sgb2Ygc2lu
Z2xlIG91dHN0YW5kaW5nIGNvcHkgb2ZmbG9hZCBJTyAqLwo+ICtzdHJ1Y3QgYmxrZGV2X2NvcHlf
b2ZmbG9hZF9pbyB7Cj4gKwlzdHJ1Y3QgYmxrZGV2X2NvcHlfaW8gKmNpbzsKPiArCWxvZmZfdCBv
ZmZzZXQ7Cj4gK307Cj4gKwo+ICAgc3RhdGljIHNlY3Rvcl90IGJpb19kaXNjYXJkX2xpbWl0KHN0
cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIHNlY3Rvcl90IHNlY3RvcikKPiAgIHsKPiAgIAl1bnNp
Z25lZCBpbnQgZGlzY2FyZF9ncmFudWxhcml0eSA9IGJkZXZfZGlzY2FyZF9ncmFudWxhcml0eShi
ZGV2KTsKPiBAQCAtMTE1LDYgKzEzMSwxOTIgQEAgaW50IGJsa2Rldl9pc3N1ZV9kaXNjYXJkKHN0
cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIHNlY3Rvcl90IHNlY3RvciwKPiAgIH0KPiAgIEVYUE9S
VF9TWU1CT0woYmxrZGV2X2lzc3VlX2Rpc2NhcmQpOwo+ICAgCj4gK3N0YXRpYyBpbmxpbmUgc3Np
emVfdCBibGtkZXZfY29weV9zYW5pdHlfY2hlY2soc3RydWN0IGJsb2NrX2RldmljZSAqYmRldl9p
biwKPiArCQkJCQkgICAgICAgbG9mZl90IHBvc19pbiwKPiArCQkJCQkgICAgICAgc3RydWN0IGJs
b2NrX2RldmljZSAqYmRldl9vdXQsCj4gKwkJCQkJICAgICAgIGxvZmZfdCBwb3Nfb3V0LCBzaXpl
X3QgbGVuKQo+ICt7Cj4gKwl1bnNpZ25lZCBpbnQgYWxpZ24gPSBtYXgoYmRldl9sb2dpY2FsX2Js
b2NrX3NpemUoYmRldl9vdXQpLAo+ICsJCQkJIGJkZXZfbG9naWNhbF9ibG9ja19zaXplKGJkZXZf
aW4pKSAtIDE7Cj4gKwo+ICsJaWYgKChwb3NfaW4gJiBhbGlnbikgfHwgKHBvc19vdXQgJiBhbGln
bikgfHwgKGxlbiAmIGFsaWduKSB8fCAhbGVuIHx8Cj4gKwkgICAgbGVuID49IEJMS19DT1BZX01B
WF9CWVRFUykKPiArCQlyZXR1cm4gLUVJTlZBTDsKPiArCj4gKwlyZXR1cm4gMDsKPiArfQo+ICsK
PiArc3RhdGljIGlubGluZSB2b2lkIGJsa2Rldl9jb3B5X2VuZGlvKHN0cnVjdCBibGtkZXZfY29w
eV9pbyAqY2lvKQo+ICt7Cj4gKwlpZiAoY2lvLT5lbmRpbykgewo+ICsJCWNpby0+ZW5kaW8oY2lv
LT5wcml2YXRlLCBjaW8tPnN0YXR1cywgY2lvLT5jb3BpZWQpOwo+ICsJCWtmcmVlKGNpbyk7Cj4g
Kwl9IGVsc2Ugewo+ICsJCXN0cnVjdCB0YXNrX3N0cnVjdCAqd2FpdGVyID0gY2lvLT53YWl0ZXI7
Cj4gKwo+ICsJCVdSSVRFX09OQ0UoY2lvLT53YWl0ZXIsIE5VTEwpOwo+ICsJCWJsa193YWtlX2lv
X3Rhc2sod2FpdGVyKTsKPiArCX0KPiArfQo+ICsKPiArLyoKPiArICogVGhpcyBtdXN0IG9ubHkg
YmUgY2FsbGVkIG9uY2UgYWxsIGJpb3MgaGF2ZSBiZWVuIGlzc3VlZCBzbyB0aGF0IHRoZSByZWZj
b3VudAo+ICsgKiBjYW4gb25seSBkZWNyZWFzZS4gVGhpcyBqdXN0IHdhaXRzIGZvciBhbGwgYmlv
cyB0byBjb21wbGV0ZS4KPiArICogUmV0dXJucyB0aGUgbGVuZ3RoIG9mIGJ5dGVzIGNvcGllZCBv
ciBlcnJvcgo+ICsgKi8KPiArc3RhdGljIHNzaXplX3QgYmxrZGV2X2NvcHlfd2FpdF9pb19jb21w
bGV0aW9uKHN0cnVjdCBibGtkZXZfY29weV9pbyAqY2lvKQo+ICt7Cj4gKwlzc2l6ZV90IHJldDsK
PiArCj4gKwlmb3IgKDs7KSB7Cj4gKwkJX19zZXRfY3VycmVudF9zdGF0ZShUQVNLX1VOSU5URVJS
VVBUSUJMRSk7Cj4gKwkJaWYgKCFSRUFEX09OQ0UoY2lvLT53YWl0ZXIpKQo+ICsJCQlicmVhazsK
PiArCQlibGtfaW9fc2NoZWR1bGUoKTsKPiArCX0KPiArCV9fc2V0X2N1cnJlbnRfc3RhdGUoVEFT
S19SVU5OSU5HKTsKPiArCXJldCA9IGNpby0+Y29waWVkOwo+ICsJa2ZyZWUoY2lvKTsKPiArCj4g
KwlyZXR1cm4gcmV0Owo+ICt9Cj4gKwo+ICtzdGF0aWMgdm9pZCBibGtkZXZfY29weV9vZmZsb2Fk
X2RzdF9lbmRpbyhzdHJ1Y3QgYmlvICpiaW8pCj4gK3sKPiArCXN0cnVjdCBibGtkZXZfY29weV9v
ZmZsb2FkX2lvICpvZmZsb2FkX2lvID0gYmlvLT5iaV9wcml2YXRlOwo+ICsJc3RydWN0IGJsa2Rl
dl9jb3B5X2lvICpjaW8gPSBvZmZsb2FkX2lvLT5jaW87Cj4gKwo+ICsJaWYgKGJpby0+Ymlfc3Rh
dHVzKSB7Cj4gKwkJY2lvLT5jb3BpZWQgPSBtaW5fdChzc2l6ZV90LCBvZmZsb2FkX2lvLT5vZmZz
ZXQsIGNpby0+Y29waWVkKTsKPiArCQlpZiAoIWNpby0+c3RhdHVzKQo+ICsJCQljaW8tPnN0YXR1
cyA9IGJsa19zdGF0dXNfdG9fZXJybm8oYmlvLT5iaV9zdGF0dXMpOwo+ICsJfQo+ICsJYmlvX3B1
dChiaW8pOwo+ICsKPiArCWlmIChhdG9taWNfZGVjX2FuZF90ZXN0KCZjaW8tPnJlZmNvdW50KSkK
PiArCQlibGtkZXZfY29weV9lbmRpbyhjaW8pOwo+ICt9Cj4gKwo+ICsvKgo+ICsgKiBAYmRldjoJ
YmxvY2sgZGV2aWNlCj4gKyAqIEBwb3NfaW46CXNvdXJjZSBvZmZzZXQKPiArICogQHBvc19vdXQ6
CWRlc3RpbmF0aW9uIG9mZnNldAo+ICsgKiBAbGVuOglsZW5ndGggaW4gYnl0ZXMgdG8gYmUgY29w
aWVkCj4gKyAqIEBlbmRpbzoJZW5kaW8gZnVuY3Rpb24gdG8gYmUgY2FsbGVkIG9uIGNvbXBsZXRp
b24gb2YgY29weSBvcGVyYXRpb24sCj4gKyAqCQlmb3Igc3luY2hyb25vdXMgb3BlcmF0aW9uIHRo
aXMgc2hvdWxkIGJlIE5VTEwKPiArICogQHByaXZhdGU6CWVuZGlvIGZ1bmN0aW9uIHdpbGwgYmUg
Y2FsbGVkIHdpdGggdGhpcyBwcml2YXRlIGRhdGEsCj4gKyAqCQlmb3Igc3luY2hyb25vdXMgb3Bl
cmF0aW9uIHRoaXMgc2hvdWxkIGJlIE5VTEwKPiArICogQGdmcF9tYXNrOgltZW1vcnkgYWxsb2Nh
dGlvbiBmbGFncyAoZm9yIGJpb19hbGxvYykKPiArICoKPiArICogRm9yIHN5bmNocm9ub3VzIG9w
ZXJhdGlvbiByZXR1cm5zIHRoZSBsZW5ndGggb2YgYnl0ZXMgY29waWVkIG9yIGVycm9yCj4gKyAq
IEZvciBhc3luY2hyb25vdXMgb3BlcmF0aW9uIHJldHVybnMgLUVJT0NCUVVFVUVEIG9yIGVycm9y
Cj4gKyAqCj4gKyAqIERlc2NyaXB0aW9uOgo+ICsgKglDb3B5IHNvdXJjZSBvZmZzZXQgdG8gZGVz
dGluYXRpb24gb2Zmc2V0IHdpdGhpbiBibG9jayBkZXZpY2UsIHVzaW5nCj4gKyAqCWRldmljZSdz
IG5hdGl2ZSBjb3B5IG9mZmxvYWQgZmVhdHVyZS4gVGhpcyBmdW5jdGlvbiBjYW4gZmFpbCwgYW5k
Cj4gKyAqCWluIHRoYXQgY2FzZSB0aGUgY2FsbGVyIGNhbiBmYWxsYmFjayB0byBlbXVsYXRpb24u
Cj4gKyAqCVdlIHBlcmZvcm0gY29weSBvcGVyYXRpb24gdXNpbmcgMiBiaW8ncy4KPiArICoJMS4g
V2UgdGFrZSBhIHBsdWcgYW5kIHNlbmQgYSBSRVFfT1BfQ09QWV9TUkMgYmlvIGFsb25nIHdpdGgg
c291cmNlCj4gKyAqCXNlY3RvciBhbmQgbGVuZ3RoLiBPbmNlIHRoaXMgYmlvIHJlYWNoZXMgcmVx
dWVzdCBsYXllciwgd2UgZm9ybSBhCj4gKyAqCXJlcXVlc3QgYW5kIHdhaXQgZm9yIGRzdCBiaW8g
dG8gYXJyaXZlLgo+ICsgKgkyLiBXZSBpc3N1ZSBSRVFfT1BfQ09QWV9EU1QgYmlvIGFsb25nIHdp
dGggZGVzdGluYXRpb24gc2VjdG9yLCBsZW5ndGguCj4gKyAqCU9uY2UgdGhpcyBiaW8gcmVhY2hl
cyByZXF1ZXN0IGxheWVyIGFuZCBmaW5kIGEgcmVxdWVzdCB3aXRoIHByZXZpb3VzbHkKPiArICoJ
c2VudCBzb3VyY2UgaW5mbyB3ZSBtZXJnZSB0aGUgZGVzdGluYXRpb24gYmlvIGFuZCByZXR1cm4u
Cj4gKyAqCTMuIFJlbGVhc2UgdGhlIHBsdWcgYW5kIHJlcXVlc3QgaXMgc2VudCB0byBkcml2ZXIK
PiArICoJVGhpcyBkZXNpZ24gd29ya3Mgb25seSBmb3IgZHJpdmVycyB3aXRoIHJlcXVlc3QgcXVl
dWUuCj4gKyAqLwo+ICtzc2l6ZV90IGJsa2Rldl9jb3B5X29mZmxvYWQoc3RydWN0IGJsb2NrX2Rl
dmljZSAqYmRldiwgbG9mZl90IHBvc19pbiwKPiArCQkJICAgIGxvZmZfdCBwb3Nfb3V0LCBzaXpl
X3QgbGVuLAo+ICsJCQkgICAgdm9pZCAoKmVuZGlvKSh2b2lkICosIGludCwgc3NpemVfdCksCj4g
KwkJCSAgICB2b2lkICpwcml2YXRlLCBnZnBfdCBnZnApCj4gK3sKPiArCXN0cnVjdCBibGtkZXZf
Y29weV9pbyAqY2lvOwo+ICsJc3RydWN0IGJsa2Rldl9jb3B5X29mZmxvYWRfaW8gKm9mZmxvYWRf
aW87Cj4gKwlzdHJ1Y3QgYmlvICpzcmNfYmlvLCAqZHN0X2JpbzsKPiArCXNzaXplX3QgcmVtLCBj
aHVuaywgcmV0Owo+ICsJc3NpemVfdCBtYXhfY29weV9ieXRlcyA9IGJkZXZfbWF4X2NvcHlfc2Vj
dG9ycyhiZGV2KSA8PCBTRUNUT1JfU0hJRlQ7Cj4gKwlzdHJ1Y3QgYmxrX3BsdWcgcGx1ZzsKPiAr
Cj4gKwlpZiAoIW1heF9jb3B5X2J5dGVzKQo+ICsJCXJldHVybiAtRUlOVkFMOwo+ICsKPiArCXJl
dCA9IGJsa2Rldl9jb3B5X3Nhbml0eV9jaGVjayhiZGV2LCBwb3NfaW4sIGJkZXYsIHBvc19vdXQs
IGxlbik7Cj4gKwlpZiAocmV0KQo+ICsJCXJldHVybiByZXQ7Cj4gKwo+ICsJY2lvID0ga3phbGxv
YyhzaXplb2YoKmNpbyksIEdGUF9LRVJORUwpOwo+ICsJaWYgKCFjaW8pCj4gKwkJcmV0dXJuIC1F
Tk9NRU07Cj4gKwlhdG9taWNfc2V0KCZjaW8tPnJlZmNvdW50LCAxKTsKPiArCWNpby0+d2FpdGVy
ID0gY3VycmVudDsKPiArCWNpby0+ZW5kaW8gPSBlbmRpbzsKPiArCWNpby0+cHJpdmF0ZSA9IHBy
aXZhdGU7Cj4gKwo+ICsJLyoKPiArCSAqIElmIHRoZXJlIGlzIGEgZXJyb3IsIGNvcGllZCB3aWxs
IGJlIHNldCB0byBsZWFzdCBzdWNjZXNzZnVsbHkKPiArCSAqIGNvbXBsZXRlZCBjb3BpZWQgbGVu
Z3RoCj4gKwkgKi8KPiArCWNpby0+Y29waWVkID0gbGVuOwo+ICsJZm9yIChyZW0gPSBsZW47IHJl
bSA+IDA7IHJlbSAtPSBjaHVuaykgewo+ICsJCWNodW5rID0gbWluKHJlbSwgbWF4X2NvcHlfYnl0
ZXMpOwo+ICsKPiArCQlvZmZsb2FkX2lvID0ga3phbGxvYyhzaXplb2YoKm9mZmxvYWRfaW8pLCBH
RlBfS0VSTkVMKTsKPiArCQlpZiAoIW9mZmxvYWRfaW8pCj4gKwkJCWdvdG8gZXJyX2ZyZWVfY2lv
Owo+ICsJCW9mZmxvYWRfaW8tPmNpbyA9IGNpbzsKPiArCQkvKgo+ICsJCSAqIEZvciBwYXJ0aWFs
IGNvbXBsZXRpb24sIHdlIHVzZSBvZmZsb2FkX2lvLT5vZmZzZXQgdG8gdHJ1bmNhdGUKPiArCQkg
KiBzdWNjZXNzZnVsIGNvcHkgbGVuZ3RoCj4gKwkJICovCj4gKwkJb2ZmbG9hZF9pby0+b2Zmc2V0
ID0gbGVuIC0gcmVtOwo+ICsKPiArCQlzcmNfYmlvID0gYmlvX2FsbG9jKGJkZXYsIDAsIFJFUV9P
UF9DT1BZX1NSQywgZ2ZwKTsKPiArCQlpZiAoIXNyY19iaW8pCj4gKwkJCWdvdG8gZXJyX2ZyZWVf
b2ZmbG9hZF9pbzsKPiArCQlzcmNfYmlvLT5iaV9pdGVyLmJpX3NpemUgPSBjaHVuazsKPiArCQlz
cmNfYmlvLT5iaV9pdGVyLmJpX3NlY3RvciA9IHBvc19pbiA+PiBTRUNUT1JfU0hJRlQ7Cj4gKwo+
ICsJCWJsa19zdGFydF9wbHVnKCZwbHVnKTsKPiArCQlkc3RfYmlvID0gYmxrX25leHRfYmlvKHNy
Y19iaW8sIGJkZXYsIDAsIFJFUV9PUF9DT1BZX0RTVCwgZ2ZwKTsKPiArCQlpZiAoIWRzdF9iaW8p
Cj4gKwkJCWdvdG8gZXJyX2ZyZWVfc3JjX2JpbzsKPiArCQlkc3RfYmlvLT5iaV9pdGVyLmJpX3Np
emUgPSBjaHVuazsKPiArCQlkc3RfYmlvLT5iaV9pdGVyLmJpX3NlY3RvciA9IHBvc19vdXQgPj4g
U0VDVE9SX1NISUZUOwo+ICsJCWRzdF9iaW8tPmJpX2VuZF9pbyA9IGJsa2Rldl9jb3B5X29mZmxv
YWRfZHN0X2VuZGlvOwo+ICsJCWRzdF9iaW8tPmJpX3ByaXZhdGUgPSBvZmZsb2FkX2lvOwo+ICsK
PiArCQlhdG9taWNfaW5jKCZjaW8tPnJlZmNvdW50KTsKPiArCQlzdWJtaXRfYmlvKGRzdF9iaW8p
Owo+ICsJCWJsa19maW5pc2hfcGx1ZygmcGx1Zyk7Cj4gKwkJcG9zX2luICs9IGNodW5rOwo+ICsJ
CXBvc19vdXQgKz0gY2h1bms7Cj4gKwl9Cj4gKwo+ICsJaWYgKGF0b21pY19kZWNfYW5kX3Rlc3Qo
JmNpby0+cmVmY291bnQpKQo+ICsJCWJsa2Rldl9jb3B5X2VuZGlvKGNpbyk7Cj4gKwlpZiAoY2lv
LT5lbmRpbykKPiArCQlyZXR1cm4gLUVJT0NCUVVFVUVEOwo+ICsKPiArCXJldHVybiBibGtkZXZf
Y29weV93YWl0X2lvX2NvbXBsZXRpb24oY2lvKTsKPiArCj4gK2Vycl9mcmVlX3NyY19iaW86Cj4g
KwliaW9fcHV0KHNyY19iaW8pOwo+ICtlcnJfZnJlZV9vZmZsb2FkX2lvOgo+ICsJa2ZyZWUob2Zm
bG9hZF9pbyk7Cj4gK2Vycl9mcmVlX2NpbzoKPiArCWNpby0+Y29waWVkID0gbWluX3Qoc3NpemVf
dCwgY2lvLT5jb3BpZWQsIChsZW4gLSByZW0pKTsKPiArCWNpby0+c3RhdHVzID0gLUVOT01FTTsK
PiArCWlmIChyZW0gPT0gbGVuKSB7Cj4gKwkJa2ZyZWUoY2lvKTsKPiArCQlyZXR1cm4gY2lvLT5z
dGF0dXM7Cj4gKwl9Cj4gKwlpZiAoY2lvLT5lbmRpbykKPiArCQlyZXR1cm4gY2lvLT5zdGF0dXM7
Cj4gKwo+ICsJcmV0dXJuIGJsa2Rldl9jb3B5X3dhaXRfaW9fY29tcGxldGlvbihjaW8pOwo+ICt9
Cj4gK0VYUE9SVF9TWU1CT0xfR1BMKGJsa2Rldl9jb3B5X29mZmxvYWQpOwoKSG1tLiBUaGF0IGxv
b2tzIGEgYml0IG9kZC4gV2h5IGRvIHlvdSBoYXZlIHRvIHVzZSB3YWl0X2Zvcl9jb21wbGV0aW9u
PwpDYW4ndCB5b3Ugc3VibWl0IHRoZSAnc3JjJyBiaW8sIGFuZCB0aGVuIHN1Ym1pdCB0aGUgJ2Rz
dCcgYmlvIGZyb20gdGhlIAplbmRpbyBoYW5kbGVyIG9mIHRoZSAnc3JjJyBiaW8/CgpDaGVlcnMs
CgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0
b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRz
dHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6Rm
dHNmw7xocmVyOiBJdm8gVG90ZXYsIEFuZHJldwpNeWVycywgQW5kcmV3IE1jRG9uYWxkLCBNYXJ0
amUgQm91ZGllbiBNb2VybWFuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVsCg==

