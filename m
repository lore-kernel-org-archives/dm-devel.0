Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C2AC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 02:49:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-JkU3K-3tMciiyFqqQien0w-1; Tue, 26 Apr 2022 22:49:13 -0400
X-MC-Unique: JkU3K-3tMciiyFqqQien0w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65042811E78;
	Wed, 27 Apr 2022 02:49:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5176C41136E0;
	Wed, 27 Apr 2022 02:49:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EF0381947BBE;
	Wed, 27 Apr 2022 02:49:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4DFC219451F0
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 02:49:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1C57F463EC6; Wed, 27 Apr 2022 02:49:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 17C56413736
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 02:49:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDCF83801FE0
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 02:49:08 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-4cJgdk7uNhW-BY1AgQfgbg-2; Tue, 26 Apr 2022 22:49:07 -0400
X-MC-Unique: 4cJgdk7uNhW-BY1AgQfgbg-2
X-IronPort-AV: E=Sophos;i="5.90,292,1643644800"; d="scan'208";a="199805621"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 27 Apr 2022 10:49:07 +0800
IronPort-SDR: FNmHCVYVri98Jmrs2WtsSgwA8fRE3W35P87US5MMkc/Ld+/VHuBDHivxf0/ngpqvgomzKYk+/l
 C6bMi6s821oy11r0w5ZvwxWcKXYekmk6qJLFuHja39oY7pn68BnXMfPsdDtpoL8xg66rQdGawX
 4ujZY6I+xhPBycKI8saPX3Dt4K7PlEjPdzBBcguO4k/13GiPOmTNOF6pMWtRWK10yJHmf8ulT3
 WlmShFusQx+CVTTQeP7MT1rQ7ZvhvWgpk1ovelarAT6IX9cwQc0pQr1kd0w4pWP2xAVhQSRbT5
 f3JvWObZAtw8PHO2Tp0I8DuS
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 26 Apr 2022 19:19:59 -0700
IronPort-SDR: 9E/ZkBQZlf/LsOhIZSUfTfJaGvIn5lOJU3x5335fQyE+IdDvpp18YmtH8G7f2yYcgGXFihAZYR
 DQOFKWeoOi1TKJR6maJU3mRLDw5YIlaV0tBZvB+97lQ+CKDa0qcHM/sU+VtZQ65T7lH2mGh0e0
 H5Vni6qFsCHsZMALNnXrmgDHNcMxMhxGiNJ7KGw10uF5BYGMzjB8sMqXNbpQK6lGQBiTbynV05
 Ha5ysE71rNicJu0UNeQ0AjIpR6MhnSp8YBq62m3+2N+IEfj+GzhNV0ZtgmFLkG8WGc7m2zGI7J
 zrk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 26 Apr 2022 19:49:06 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kp39Y3C7wz1SVp2
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 19:49:05 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id 6VWu596VzGXa for <dm-devel@redhat.com>;
 Tue, 26 Apr 2022 19:49:03 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kp39Q3MMrz1Rvlc;
 Tue, 26 Apr 2022 19:48:58 -0700 (PDT)
Message-ID: <513edc25-1c73-6c85-9a50-0e267a106ec0@opensource.wdc.com>
Date: Wed, 27 Apr 2022 11:48:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <20220426101241.30100-1-nj.shetty@samsung.com>
 <CGME20220426101938epcas5p291690dd1f0e931cd9f8139daaf3f9296@epcas5p2.samsung.com>
 <20220426101241.30100-4-nj.shetty@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220426101241.30100-4-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v4 03/10] block: Introduce a new ioctl for
 copy
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
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
 dm-devel@redhat.com, osandov@fb.com, Alasdair Kergon <agk@redhat.com>,
 Naohiro Aota <naohiro.aota@wdc.com>, msnitzer@redhat.com, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, gost.dev@samsung.com, nitheshshetty@gmail.com,
 James Smart <james.smart@broadcom.com>, hch@lst.de, chaitanyak@nvidia.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Mike Snitzer <snitzer@kernel.org>,
 josef@toxicpanda.com, linux-block@vger.kernel.org, dsterba@suse.com,
 kbusch@kernel.org, Frederick.Knight@netapp.com,
 Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk,
 Johannes Thumshirn <jth@kernel.org>, tytso@mit.edu, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, Arnav Dawn <arnav.dawn@samsung.com>,
 jack@suse.com, linux-fsdevel@vger.kernel.org,
 =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier.gonz@samsung.com>,
 lsf-pc@lists.linux-foundation.org, Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8yNi8yMiAxOToxMiwgTml0ZXNoIFNoZXR0eSB3cm90ZToKPiBBZGQgbmV3IEJMS0NPUFkg
aW9jdGwgdGhhdCBvZmZsb2FkcyBjb3B5aW5nIG9mIG9uZSBvciBtb3JlIHNvdXJjZXMgcmFuZ2Vz
Cj4gdG8gb25lIG9yIG1vcmUgZGVzdGluYXRpb24gaW4gYSBkZXZpY2UuIENPUFkgaW9jdGwgYWNj
ZXB0cyBhICdjb3B5X3JhbmdlJwo+IHN0cnVjdHVyZSB0aGF0IGNvbnRhaW5zIG5vIG9mIHJhbmdl
LCBhIHJlc2VydmVkIGZpZWxkICwgZm9sbG93ZWQgYnkgYW4KPiBhcnJheSBvZiByYW5nZXMuIEVh
Y2ggc291cmNlIHJhbmdlIGlzIHJlcHJlc2VudGVkIGJ5ICdyYW5nZV9lbnRyeScgdGhhdAo+IGNv
bnRhaW5zIHNvdXJjZSBzdGFydCBvZmZzZXQsIGRlc3RpbmF0aW9uIHN0YXJ0IG9mZnNldCBhbmQg
bGVuZ3RoIG9mCj4gc291cmNlIHJhbmdlcyAoaW4gYnl0ZXMpCj4gCj4gTUFYX0NPUFlfTlJfUkFO
R0UsIGxpbWl0cyB0aGUgbnVtYmVyIG9mIGVudHJpZXMgZm9yIHRoZSBJT0NUTCBhbmQKPiBNQVhf
Q09QWV9UT1RBTF9MRU5HVEggbGltaXRzIHRoZSB0b3RhbCBjb3B5IGxlbmd0aCwgSU9DVEwgY2Fu
IGhhbmRsZS4KPiAKPiBFeGFtcGxlIGNvZGUsIHRvIGlzc3VlIEJMS0NPUFk6Cj4gLyogU2FtcGxl
IGV4YW1wbGUgdG8gY29weSB0aHJlZSBlbnRyaWVzIHdpdGggW2Rlc3Qsc3JjLGxlbl0sCj4gKiBb
MzI3NjgsIDAsIDQwOTZdIFszNjg2NCwgNDA5NiwgNDA5Nl0gWzQwOTYwLDgxOTIsNDA5Nl0gb24g
c2FtZSBkZXZpY2UgKi8KPiAKPiBpbnQgbWFpbih2b2lkKQo+IHsKPiAJaW50IGksIHJldCwgZmQ7
Cj4gCXVuc2lnbmVkIGxvbmcgc3JjID0gMCwgZHN0ID0gMzI3NjgsIGxlbiA9IDQwOTY7Cj4gCXN0
cnVjdCBjb3B5X3JhbmdlICpjcjsKPiAJY3IgPSAoc3RydWN0IGNvcHlfcmFuZ2UgKiltYWxsb2Mo
c2l6ZW9mKCpjcikrCj4gCQkJCQkoc2l6ZW9mKHN0cnVjdCByYW5nZV9lbnRyeSkqMykpOwo+IAlj
ci0+bnJfcmFuZ2UgPSAzOwo+IAljci0+cmVzZXJ2ZWQgPSAwOwo+IAlmb3IgKGkgPSAwOyBpPCBj
ci0+bnJfcmFuZ2U7IGkrKywgc3JjICs9IGxlbiwgZHN0ICs9IGxlbikgewo+IAkJY3ItPnJhbmdl
X2xpc3RbaV0uZHN0ID0gZHN0Owo+IAkJY3ItPnJhbmdlX2xpc3RbaV0uc3JjID0gc3JjOwo+IAkJ
Y3ItPnJhbmdlX2xpc3RbaV0ubGVuID0gbGVuOwo+IAkJY3ItPnJhbmdlX2xpc3RbaV0uY29tcF9s
ZW4gPSAwOwo+IAl9Cj4gCWZkID0gb3BlbigiL2Rldi9udm1lMG4xIiwgT19SRFdSKTsKPiAJaWYg
KGZkIDwgMCkgcmV0dXJuIDE7Cj4gCXJldCA9IGlvY3RsKGZkLCBCTEtDT1BZLCBjcik7Cj4gCWlm
IChyZXQgIT0gMCkKPiAJICAgICAgIHByaW50ZigiY29weSBmYWlsZWQsIHJldD0gJWRcbiIsIHJl
dCk7Cj4gCWZvciAoaT0wOyBpPCBjci0+bnJfcmFuZ2U7IGkrKykKPiAJCWlmIChjci0+cmFuZ2Vf
bGlzdFtpXS5sZW4gIT0gY3ItPnJhbmdlX2xpc3RbaV0uY29tcF9sZW4pCj4gCQkJcHJpbnRmKCJQ
YXJ0aWFsIGNvcHkgZm9yIGVudHJ5ICVkOiByZXF1ZXN0ZWQgJWxsdSwgY29tcGxldGVkICVsbHVc
biIsCj4gCQkJCQkJCQlpLCBjci0+cmFuZ2VfbGlzdFtpXS5sZW4sCj4gCQkJCQkJCQljci0+cmFu
Z2VfbGlzdFtpXS5jb21wX2xlbik7Cj4gCWNsb3NlKGZkKTsKPiAJZnJlZShjcik7Cj4gCXJldHVy
biByZXQ7Cj4gfQoKTmljZSB0byBoYXZlIGEgY29kZSBleGFtcGxlLiBCdXQgcGxlYXNlIGZvcm1h
dCBpdCBjb3JyZWN0bHkuCgo+IAo+IFNpZ25lZC1vZmYtYnk6IE5pdGVzaCBTaGV0dHkgPG5qLnNo
ZXR0eUBzYW1zdW5nLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBKYXZpZXIgR29uesOhbGV6IDxqYXZp
ZXIuZ29uekBzYW1zdW5nLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBBcm5hdiBEYXduIDxhcm5hdi5k
YXduQHNhbXN1bmcuY29tPgo+IC0tLQo+ICBibG9jay9pb2N0bC5jICAgICAgICAgICB8IDMyICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4gIGluY2x1ZGUvdWFwaS9saW51eC9mcy5o
IHwgIDkgKysrKysrKysrCj4gIDIgZmlsZXMgY2hhbmdlZCwgNDEgaW5zZXJ0aW9ucygrKQo+IAo+
IGRpZmYgLS1naXQgYS9ibG9jay9pb2N0bC5jIGIvYmxvY2svaW9jdGwuYwo+IGluZGV4IDQ2OTQ5
ZjFiMGRiYS4uNThkOTNjMjBmZjMwIDEwMDY0NAo+IC0tLSBhL2Jsb2NrL2lvY3RsLmMKPiArKysg
Yi9ibG9jay9pb2N0bC5jCj4gQEAgLTEyMCw2ICsxMjAsMzYgQEAgc3RhdGljIGludCBibGtfaW9j
dGxfZGlzY2FyZChzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBmbW9kZV90IG1vZGUsCj4gIAly
ZXR1cm4gZXJyOwo+ICB9Cj4gIAo+ICtzdGF0aWMgaW50IGJsa19pb2N0bF9jb3B5KHN0cnVjdCBi
bG9ja19kZXZpY2UgKmJkZXYsIGZtb2RlX3QgbW9kZSwKPiArCQl1bnNpZ25lZCBsb25nIGFyZykK
PiArewo+ICsJc3RydWN0IGNvcHlfcmFuZ2UgY3JhbmdlLCAqcmFuZ2VzID0gTlVMTDsKPiArCXNp
emVfdCBwYXlsb2FkX3NpemUgPSAwOwo+ICsJaW50IHJldDsKPiArCj4gKwlpZiAoIShtb2RlICYg
Rk1PREVfV1JJVEUpKQo+ICsJCXJldHVybiAtRUJBREY7Cj4gKwo+ICsJaWYgKGNvcHlfZnJvbV91
c2VyKCZjcmFuZ2UsICh2b2lkIF9fdXNlciAqKWFyZywgc2l6ZW9mKGNyYW5nZSkpKQo+ICsJCXJl
dHVybiAtRUZBVUxUOwo+ICsKPiArCWlmICh1bmxpa2VseSghY3JhbmdlLm5yX3JhbmdlIHx8IGNy
YW5nZS5yZXNlcnZlZCB8fCBjcmFuZ2UubnJfcmFuZ2UgPj0gTUFYX0NPUFlfTlJfUkFOR0UpKQo+
ICsJCXJldHVybiAtRUlOVkFMOwo+ICsKPiArCXBheWxvYWRfc2l6ZSA9IChjcmFuZ2UubnJfcmFu
Z2UgKiBzaXplb2Yoc3RydWN0IHJhbmdlX2VudHJ5KSkgKyBzaXplb2YoY3JhbmdlKTsKPiArCj4g
KwlyYW5nZXMgPSBtZW1kdXBfdXNlcigodm9pZCBfX3VzZXIgKilhcmcsIHBheWxvYWRfc2l6ZSk7
Cj4gKwlpZiAoSVNfRVJSKHJhbmdlcykpCj4gKwkJcmV0dXJuIFBUUl9FUlIocmFuZ2VzKTsKPiAr
Cj4gKwlyZXQgPSBibGtkZXZfaXNzdWVfY29weShiZGV2LCByYW5nZXMtPm5yX3JhbmdlLCByYW5n
ZXMtPnJhbmdlX2xpc3QsIGJkZXYsIEdGUF9LRVJORUwpOwo+ICsJaWYgKGNvcHlfdG9fdXNlcigo
dm9pZCBfX3VzZXIgKilhcmcsIHJhbmdlcywgcGF5bG9hZF9zaXplKSkKPiArCQlyZXQgPSAtRUZB
VUxUOwo+ICsKPiArCWtmcmVlKHJhbmdlcyk7Cj4gKwlyZXR1cm4gcmV0Owo+ICt9Cj4gKwo+ICBz
dGF0aWMgaW50IGJsa19pb2N0bF9zZWN1cmVfZXJhc2Uoc3RydWN0IGJsb2NrX2RldmljZSAqYmRl
diwgZm1vZGVfdCBtb2RlLAo+ICAJCXZvaWQgX191c2VyICphcmdwKQo+ICB7Cj4gQEAgLTQ4MSw2
ICs1MTEsOCBAQCBzdGF0aWMgaW50IGJsa2Rldl9jb21tb25faW9jdGwoc3RydWN0IGJsb2NrX2Rl
dmljZSAqYmRldiwgZm1vZGVfdCBtb2RlLAo+ICAJCXJldHVybiBibGtfaW9jdGxfZGlzY2FyZChi
ZGV2LCBtb2RlLCBhcmcpOwo+ICAJY2FzZSBCTEtTRUNESVNDQVJEOgo+ICAJCXJldHVybiBibGtf
aW9jdGxfc2VjdXJlX2VyYXNlKGJkZXYsIG1vZGUsIGFyZ3ApOwo+ICsJY2FzZSBCTEtDT1BZOgo+
ICsJCXJldHVybiBibGtfaW9jdGxfY29weShiZGV2LCBtb2RlLCBhcmcpOwo+ICAJY2FzZSBCTEta
RVJPT1VUOgo+ICAJCXJldHVybiBibGtfaW9jdGxfemVyb291dChiZGV2LCBtb2RlLCBhcmcpOwo+
ICAJY2FzZSBCTEtHRVRESVNLU0VROgo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgv
ZnMuaCBiL2luY2x1ZGUvdWFwaS9saW51eC9mcy5oCj4gaW5kZXggODIyYzI4Y2ViZjNhLi5hM2Ix
MzQwNmZmYjggMTAwNjQ0Cj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2ZzLmgKPiArKysgYi9p
bmNsdWRlL3VhcGkvbGludXgvZnMuaAo+IEBAIC03OCw2ICs3OCwxNCBAQCBzdHJ1Y3QgcmFuZ2Vf
ZW50cnkgewo+ICAJX191NjQgY29tcF9sZW47Cj4gIH07Cj4gIAo+ICtzdHJ1Y3QgY29weV9yYW5n
ZSB7Cj4gKwlfX3U2NCBucl9yYW5nZTsKPiArCV9fdTY0IHJlc2VydmVkOwo+ICsKPiArCS8qIFJh
bmdlX2xpc3QgYWx3YXlzIG11c3QgYmUgYXQgdGhlIGVuZCAqLwo+ICsJc3RydWN0IHJhbmdlX2Vu
dHJ5IHJhbmdlX2xpc3RbXTsKPiArfTsKPiArCj4gIC8qIGV4dGVudC1zYW1lIChkZWR1cGUpIGlv
Y3RsczsgdGhlc2UgTVVTVCBtYXRjaCB0aGUgYnRyZnMgaW9jdGwgZGVmaW5pdGlvbnMgKi8KPiAg
I2RlZmluZSBGSUxFX0RFRFVQRV9SQU5HRV9TQU1FCQkwCj4gICNkZWZpbmUgRklMRV9ERURVUEVf
UkFOR0VfRElGRkVSUwkxCj4gQEAgLTE5OSw2ICsyMDcsNyBAQCBzdHJ1Y3QgZnN4YXR0ciB7Cj4g
ICNkZWZpbmUgQkxLUk9UQVRJT05BTCBfSU8oMHgxMiwxMjYpCj4gICNkZWZpbmUgQkxLWkVST09V
VCBfSU8oMHgxMiwxMjcpCj4gICNkZWZpbmUgQkxLR0VURElTS1NFUSBfSU9SKDB4MTIsMTI4LF9f
dTY0KQo+ICsjZGVmaW5lIEJMS0NPUFkgX0lPV1IoMHgxMiwgMTI5LCBzdHJ1Y3QgY29weV9yYW5n
ZSkKPiAgLyoKPiAgICogQSBqdW1wIGhlcmU6IDEzMC0xMzYgYXJlIHJlc2VydmVkIGZvciB6b25l
ZCBibG9jayBkZXZpY2VzCj4gICAqIChzZWUgdWFwaS9saW51eC9ibGt6b25lZC5oKQoKCi0tIApE
YW1pZW4gTGUgTW9hbApXZXN0ZXJuIERpZ2l0YWwgUmVzZWFyY2gKCi0tCmRtLWRldmVsIG1haWxp
bmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

