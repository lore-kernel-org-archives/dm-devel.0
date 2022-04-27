Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A23EC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 10:29:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-yBPZPsM7MuKWysJLRfTN5Q-1; Wed, 27 Apr 2022 06:29:25 -0400
X-MC-Unique: yBPZPsM7MuKWysJLRfTN5Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFE7A38378A3;
	Wed, 27 Apr 2022 10:29:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3E0EB53CF;
	Wed, 27 Apr 2022 10:29:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 12FA91947042;
	Wed, 27 Apr 2022 10:29:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2A2831947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 10:29:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1C1D214682D9; Wed, 27 Apr 2022 10:29:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 17C6514682C5
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 10:29:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE26B38378A2
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 10:29:19 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-bmfKS9u4MMyKz3YoIcaf7w-1; Wed, 27 Apr 2022 06:29:18 -0400
X-MC-Unique: bmfKS9u4MMyKz3YoIcaf7w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 63E961F388;
 Wed, 27 Apr 2022 10:29:16 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 193711323E;
 Wed, 27 Apr 2022 10:29:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 24OHBfwaaWJ/AQAAMHmgww
 (envelope-from <hare@suse.de>); Wed, 27 Apr 2022 10:29:16 +0000
Message-ID: <2082148f-890f-e5f4-c304-b99212aa377e@suse.de>
Date: Wed, 27 Apr 2022 12:29:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <20220426101241.30100-1-nj.shetty@samsung.com>
 <CGME20220426101921epcas5p341707619b5e836490284a42c92762083@epcas5p3.samsung.com>
 <20220426101241.30100-3-nj.shetty@samsung.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220426101241.30100-3-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v4 02/10] block: Add copy offload support
 infrastructure
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
 Alexander Viro <viro@zeniv.linux.org.uk>, kbusch@kernel.org,
 Frederick.Knight@netapp.com, Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk,
 Johannes Thumshirn <jth@kernel.org>, tytso@mit.edu, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, Arnav Dawn <arnav.dawn@samsung.com>,
 jack@suse.com, linux-fsdevel@vger.kernel.org,
 lsf-pc@lists.linux-foundation.org,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNC8yNi8yMiAxMjoxMiwgTml0ZXNoIFNoZXR0eSB3cm90ZToKPiBJbnRyb2R1Y2UgYmxrZGV2
X2lzc3VlX2NvcHkgd2hpY2ggc3VwcG9ydHMgc291cmNlIGFuZCBkZXN0aW5hdGlvbiBiZGV2cywK
PiBhbmQgYW4gYXJyYXkgb2YgKHNvdXJjZSwgZGVzdGluYXRpb24gYW5kIGNvcHkgbGVuZ3RoKSB0
dXBsZXMuCj4gSW50cm9kdWNlIFJFUV9DT1BZIGNvcHkgb2ZmbG9hZCBvcGVyYXRpb24gZmxhZy4g
Q3JlYXRlIGEgcmVhZC13cml0ZQo+IGJpbyBwYWlyIHdpdGggYSB0b2tlbiBhcyBwYXlsb2FkIGFu
ZCBzdWJtaXR0ZWQgdG8gdGhlIGRldmljZSBpbiBvcmRlci4KPiBSZWFkIHJlcXVlc3QgcG9wdWxh
dGVzIHRva2VuIHdpdGggc291cmNlIHNwZWNpZmljIGluZm9ybWF0aW9uIHdoaWNoCj4gaXMgdGhl
biBwYXNzZWQgd2l0aCB3cml0ZSByZXF1ZXN0Lgo+IFRoaXMgZGVzaWduIGlzIGNvdXJ0ZXN5IE1p
a3VsYXMgUGF0b2NrYSdzIHRva2VuIGJhc2VkIGNvcHkKPiAKPiBMYXJnZXIgY29weSB3aWxsIGJl
IGRpdmlkZWQsIGJhc2VkIG9uIG1heF9jb3B5X3NlY3RvcnMsCj4gbWF4X2NvcHlfcmFuZ2Vfc2Vj
dG9yIGxpbWl0cy4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBOaXRlc2ggU2hldHR5IDxuai5zaGV0dHlA
c2Ftc3VuZy5jb20+Cj4gU2lnbmVkLW9mZi1ieTogQXJuYXYgRGF3biA8YXJuYXYuZGF3bkBzYW1z
dW5nLmNvbT4KPiAtLS0KPiAgIGJsb2NrL2Jsay1saWIuYyAgICAgICAgICAgfCAyMzIgKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKPiAgIGJsb2NrL2Jsay5oICAgICAgICAg
ICAgICAgfCAgIDIgKwo+ICAgaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaCB8ICAyMSArKysrCj4g
ICBpbmNsdWRlL2xpbnV4L2Jsa2Rldi5oICAgIHwgICAyICsKPiAgIGluY2x1ZGUvdWFwaS9saW51
eC9mcy5oICAgfCAgMTQgKysrCj4gICA1IGZpbGVzIGNoYW5nZWQsIDI3MSBpbnNlcnRpb25zKCsp
Cj4gCj4gZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1saWIuYyBiL2Jsb2NrL2Jsay1saWIuYwo+IGlu
ZGV4IDA5YjdlMTIwMGMwZi4uYmE5ZGEyZDJmNDI5IDEwMDY0NAo+IC0tLSBhL2Jsb2NrL2Jsay1s
aWIuYwo+ICsrKyBiL2Jsb2NrL2Jsay1saWIuYwo+IEBAIC0xMTcsNiArMTE3LDIzOCBAQCBpbnQg
YmxrZGV2X2lzc3VlX2Rpc2NhcmQoc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwgc2VjdG9yX3Qg
c2VjdG9yLAo+ICAgfQo+ICAgRVhQT1JUX1NZTUJPTChibGtkZXZfaXNzdWVfZGlzY2FyZCk7Cj4g
ICAKPiArLyoKPiArICogV2FpdCBvbiBhbmQgcHJvY2VzcyBhbGwgaW4tZmxpZ2h0IEJJT3MuICBU
aGlzIG11c3Qgb25seSBiZSBjYWxsZWQgb25jZQo+ICsgKiBhbGwgYmlvcyBoYXZlIGJlZW4gaXNz
dWVkIHNvIHRoYXQgdGhlIHJlZmNvdW50IGNhbiBvbmx5IGRlY3JlYXNlLgo+ICsgKiBUaGlzIGp1
c3Qgd2FpdHMgZm9yIGFsbCBiaW9zIHRvIG1ha2UgaXQgdGhyb3VnaCBiaW9fY29weV9lbmRfaW8u
IElPCj4gKyAqIGVycm9ycyBhcmUgcHJvcGFnYXRlZCB0aHJvdWdoIGNpby0+aW9fZXJyb3IuCj4g
KyAqLwo+ICtzdGF0aWMgaW50IGNpb19hd2FpdF9jb21wbGV0aW9uKHN0cnVjdCBjaW8gKmNpbykK
PiArewo+ICsJaW50IHJldCA9IDA7Cj4gKwl1bnNpZ25lZCBsb25nIGZsYWdzOwo+ICsKPiArCXNw
aW5fbG9ja19pcnFzYXZlKCZjaW8tPmxvY2ssIGZsYWdzKTsKPiArCWlmIChjaW8tPnJlZmNvdW50
KSB7Cj4gKwkJY2lvLT53YWl0ZXIgPSBjdXJyZW50Owo+ICsJCV9fc2V0X2N1cnJlbnRfc3RhdGUo
VEFTS19VTklOVEVSUlVQVElCTEUpOwo+ICsJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmNpby0+
bG9jaywgZmxhZ3MpOwo+ICsJCWJsa19pb19zY2hlZHVsZSgpOwo+ICsJCS8qIHdha2UgdXAgc2V0
cyB1cyBUQVNLX1JVTk5JTkcgKi8KPiArCQlzcGluX2xvY2tfaXJxc2F2ZSgmY2lvLT5sb2NrLCBm
bGFncyk7Cj4gKwkJY2lvLT53YWl0ZXIgPSBOVUxMOwo+ICsJCXJldCA9IGNpby0+aW9fZXJyOwo+
ICsJfQo+ICsJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmY2lvLT5sb2NrLCBmbGFncyk7Cj4gKwlr
dmZyZWUoY2lvKTsKPiArCj4gKwlyZXR1cm4gcmV0Owo+ICt9Cj4gKwo+ICtzdGF0aWMgdm9pZCBi
aW9fY29weV9lbmRfaW8oc3RydWN0IGJpbyAqYmlvKQo+ICt7Cj4gKwlzdHJ1Y3QgY29weV9jdHgg
KmN0eCA9IGJpby0+YmlfcHJpdmF0ZTsKPiArCXN0cnVjdCBjaW8gKmNpbyA9IGN0eC0+Y2lvOwo+
ICsJc2VjdG9yX3QgY2xlbjsKPiArCWludCByaSA9IGN0eC0+cmFuZ2VfaWR4Owo+ICsJdW5zaWdu
ZWQgbG9uZyBmbGFnczsKPiArCWJvb2wgd2FrZSA9IGZhbHNlOwo+ICsKPiArCWlmIChiaW8tPmJp
X3N0YXR1cykgewo+ICsJCWNpby0+aW9fZXJyID0gYmlvLT5iaV9zdGF0dXM7Cj4gKwkJY2xlbiA9
IChiaW8tPmJpX2l0ZXIuYmlfc2VjdG9yIDw8IFNFQ1RPUl9TSElGVCkgLSBjdHgtPnN0YXJ0X3Nl
YzsKPiArCQljaW8tPnJsaXN0W3JpXS5jb21wX2xlbiA9IG1pbl90KHNlY3Rvcl90LCBjbGVuLCBj
aW8tPnJsaXN0W3JpXS5jb21wX2xlbik7Cj4gKwl9Cj4gKwlfX2ZyZWVfcGFnZShiaW8tPmJpX2lv
X3ZlY1swXS5idl9wYWdlKTsKPiArCWtmcmVlKGN0eCk7Cj4gKwliaW9fcHV0KGJpbyk7Cj4gKwo+
ICsJc3Bpbl9sb2NrX2lycXNhdmUoJmNpby0+bG9jaywgZmxhZ3MpOwo+ICsJaWYgKCgoLS1jaW8t
PnJlZmNvdW50KSA8PSAwKSAmJiBjaW8tPndhaXRlcikKPiArCQl3YWtlID0gdHJ1ZTsKPiArCXNw
aW5fdW5sb2NrX2lycXJlc3RvcmUoJmNpby0+bG9jaywgZmxhZ3MpOwo+ICsJaWYgKHdha2UpCj4g
KwkJd2FrZV91cF9wcm9jZXNzKGNpby0+d2FpdGVyKTsKPiArfQo+ICsKPiArLyoKPiArICogYmxr
X2NvcHlfb2ZmbG9hZAktIFVzZSBkZXZpY2UncyBuYXRpdmUgY29weSBvZmZsb2FkIGZlYXR1cmUK
PiArICogR28gdGhyb3VnaCB1c2VyIHByb3ZpZGUgcGF5bG9hZCwgcHJlcGFyZSBuZXcgcGF5bG9h
ZCBiYXNlZCBvbiBkZXZpY2UncyBjb3B5IG9mZmxvYWQgbGltaXRzLgo+ICsgKi8KPiAraW50IGJs
a19jb3B5X29mZmxvYWQoc3RydWN0IGJsb2NrX2RldmljZSAqc3JjX2JkZXYsIGludCBucl9zcmNz
LAo+ICsJCXN0cnVjdCByYW5nZV9lbnRyeSAqcmxpc3QsIHN0cnVjdCBibG9ja19kZXZpY2UgKmRz
dF9iZGV2LCBnZnBfdCBnZnBfbWFzaykKPiArewo+ICsJc3RydWN0IHJlcXVlc3RfcXVldWUgKnNx
ID0gYmRldl9nZXRfcXVldWUoc3JjX2JkZXYpOwo+ICsJc3RydWN0IHJlcXVlc3RfcXVldWUgKmRx
ID0gYmRldl9nZXRfcXVldWUoZHN0X2JkZXYpOwo+ICsJc3RydWN0IGJpbyAqcmVhZF9iaW8sICp3
cml0ZV9iaW87Cj4gKwlzdHJ1Y3QgY29weV9jdHggKmN0eDsKPiArCXN0cnVjdCBjaW8gKmNpbzsK
PiArCXN0cnVjdCBwYWdlICp0b2tlbjsKPiArCXNlY3Rvcl90IHNyY19ibGssIGNvcHlfbGVuLCBk
c3RfYmxrOwo+ICsJc2VjdG9yX3QgcmVtYWluaW5nLCBtYXhfY29weV9sZW4gPSBMT05HX01BWDsK
PiArCXVuc2lnbmVkIGxvbmcgZmxhZ3M7Cj4gKwlpbnQgcmkgPSAwLCByZXQgPSAwOwo+ICsKPiAr
CWNpbyA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBjaW8pLCBHRlBfS0VSTkVMKTsKPiArCWlmICgh
Y2lvKQo+ICsJCXJldHVybiAtRU5PTUVNOwo+ICsJY2lvLT5ybGlzdCA9IHJsaXN0Owo+ICsJc3Bp
bl9sb2NrX2luaXQoJmNpby0+bG9jayk7Cj4gKwo+ICsJbWF4X2NvcHlfbGVuID0gbWluX3Qoc2Vj
dG9yX3QsIHNxLT5saW1pdHMubWF4X2NvcHlfc2VjdG9ycywgZHEtPmxpbWl0cy5tYXhfY29weV9z
ZWN0b3JzKTsKPiArCW1heF9jb3B5X2xlbiA9IG1pbjMobWF4X2NvcHlfbGVuLCAoc2VjdG9yX3Qp
c3EtPmxpbWl0cy5tYXhfY29weV9yYW5nZV9zZWN0b3JzLAo+ICsJCQkoc2VjdG9yX3QpZHEtPmxp
bWl0cy5tYXhfY29weV9yYW5nZV9zZWN0b3JzKSA8PCBTRUNUT1JfU0hJRlQ7Cj4gKwo+ICsJZm9y
IChyaSA9IDA7IHJpIDwgbnJfc3JjczsgcmkrKykgewo+ICsJCWNpby0+cmxpc3RbcmldLmNvbXBf
bGVuID0gcmxpc3RbcmldLmxlbjsKPiArCQlzcmNfYmxrID0gcmxpc3RbcmldLnNyYzsKPiArCQlk
c3RfYmxrID0gcmxpc3RbcmldLmRzdDsKPiArCQlmb3IgKHJlbWFpbmluZyA9IHJsaXN0W3JpXS5s
ZW47IHJlbWFpbmluZyA+IDA7IHJlbWFpbmluZyAtPSBjb3B5X2xlbikgewo+ICsJCQljb3B5X2xl
biA9IG1pbihyZW1haW5pbmcsIG1heF9jb3B5X2xlbik7Cj4gKwo+ICsJCQl0b2tlbiA9IGFsbG9j
X3BhZ2UoZ2ZwX21hc2spOwo+ICsJCQlpZiAodW5saWtlbHkoIXRva2VuKSkgewo+ICsJCQkJcmV0
ID0gLUVOT01FTTsKPiArCQkJCWdvdG8gZXJyX3Rva2VuOwo+ICsJCQl9Cj4gKwo+ICsJCQljdHgg
PSBremFsbG9jKHNpemVvZihzdHJ1Y3QgY29weV9jdHgpLCBnZnBfbWFzayk7Cj4gKwkJCWlmICgh
Y3R4KSB7Cj4gKwkJCQlyZXQgPSAtRU5PTUVNOwo+ICsJCQkJZ290byBlcnJfY3R4Owo+ICsJCQl9
Cj4gKwkJCWN0eC0+Y2lvID0gY2lvOwo+ICsJCQljdHgtPnJhbmdlX2lkeCA9IHJpOwo+ICsJCQlj
dHgtPnN0YXJ0X3NlYyA9IGRzdF9ibGs7Cj4gKwo+ICsJCQlyZWFkX2JpbyA9IGJpb19hbGxvYyhz
cmNfYmRldiwgMSwgUkVRX09QX1JFQUQgfCBSRVFfQ09QWSB8IFJFUV9OT01FUkdFLAo+ICsJCQkJ
CWdmcF9tYXNrKTsKPiArCQkJaWYgKCFyZWFkX2Jpbykgewo+ICsJCQkJcmV0ID0gLUVOT01FTTsK
PiArCQkJCWdvdG8gZXJyX3JlYWRfYmlvOwo+ICsJCQl9Cj4gKwkJCXJlYWRfYmlvLT5iaV9pdGVy
LmJpX3NlY3RvciA9IHNyY19ibGsgPj4gU0VDVE9SX1NISUZUOwo+ICsJCQlfX2Jpb19hZGRfcGFn
ZShyZWFkX2JpbywgdG9rZW4sIFBBR0VfU0laRSwgMCk7Cj4gKwkJCS8qX19iaW9fYWRkX3BhZ2Ug
aW5jcmVhc2VzIGJpX3NpemUgYnkgbGVuLCBzbyBvdmVyd3JpdGUgaXQgd2l0aCBjb3B5IGxlbiov
Cj4gKwkJCXJlYWRfYmlvLT5iaV9pdGVyLmJpX3NpemUgPSBjb3B5X2xlbjsKPiArCQkJcmV0ID0g
c3VibWl0X2Jpb193YWl0KHJlYWRfYmlvKTsKPiArCQkJYmlvX3B1dChyZWFkX2Jpbyk7Cj4gKwkJ
CWlmIChyZXQpCj4gKwkJCQlnb3RvIGVycl9yZWFkX2JpbzsKPiArCj4gKwkJCXdyaXRlX2JpbyA9
IGJpb19hbGxvYyhkc3RfYmRldiwgMSwgUkVRX09QX1dSSVRFIHwgUkVRX0NPUFkgfCBSRVFfTk9N
RVJHRSwKPiArCQkJCQlnZnBfbWFzayk7Cj4gKwkJCWlmICghd3JpdGVfYmlvKSB7Cj4gKwkJCQly
ZXQgPSAtRU5PTUVNOwo+ICsJCQkJZ290byBlcnJfcmVhZF9iaW87Cj4gKwkJCX0KPiArCQkJd3Jp
dGVfYmlvLT5iaV9pdGVyLmJpX3NlY3RvciA9IGRzdF9ibGsgPj4gU0VDVE9SX1NISUZUOwo+ICsJ
CQlfX2Jpb19hZGRfcGFnZSh3cml0ZV9iaW8sIHRva2VuLCBQQUdFX1NJWkUsIDApOwo+ICsJCQkv
Kl9fYmlvX2FkZF9wYWdlIGluY3JlYXNlcyBiaV9zaXplIGJ5IGxlbiwgc28gb3ZlcndyaXRlIGl0
IHdpdGggY29weSBsZW4qLwo+ICsJCQl3cml0ZV9iaW8tPmJpX2l0ZXIuYmlfc2l6ZSA9IGNvcHlf
bGVuOwo+ICsJCQl3cml0ZV9iaW8tPmJpX2VuZF9pbyA9IGJpb19jb3B5X2VuZF9pbzsKPiArCQkJ
d3JpdGVfYmlvLT5iaV9wcml2YXRlID0gY3R4Owo+ICsKPiArCQkJc3Bpbl9sb2NrX2lycXNhdmUo
JmNpby0+bG9jaywgZmxhZ3MpOwo+ICsJCQkrK2Npby0+cmVmY291bnQ7Cj4gKwkJCXNwaW5fdW5s
b2NrX2lycXJlc3RvcmUoJmNpby0+bG9jaywgZmxhZ3MpOwo+ICsKPiArCQkJc3VibWl0X2Jpbyh3
cml0ZV9iaW8pOwo+ICsJCQlzcmNfYmxrICs9IGNvcHlfbGVuOwo+ICsJCQlkc3RfYmxrICs9IGNv
cHlfbGVuOwo+ICsJCX0KPiArCX0KPiArCgpIbW0uIEknbSBub3Qgc3VyZSBpZiBJIGxpa2UgdGhl
IGNvcHkgbG9vcC4KV2hhdCBJIGRlZmluaXRlbHkgd291bGQgZG8gaXMgdG8gYWxsb2NhdGUgdGhl
IHdyaXRlIGJpbyBiZWZvcmUgcmVhZGluZyAKZGF0YTsgYWZ0ZXIgYWxsLCBpZiB3ZSBjYW4ndCBh
bGxvY2F0ZSB0aGUgd3JpdGUgYmlvIHJlYWRpbmcgaXMgcHJldHR5IAptdWNoIHBvaW50bGVzcy4K
CkJ1dCB0aGUgcmVhbCBpc3N1ZSBJIGhhdmUgd2l0aCB0aGlzIGlzIHRoYXQgaXQncyBkb2luZyBz
eW5jaHJvbm91cyAKcmVhZHMsIHRoZXJlYnkgbGltaXRpbmcgdGhlIHBlcmZvcm1hbmNlLgoKQ2Fu
J3QgeW91IHN1Ym1pdCB0aGUgd3JpdGUgYmlvIGZyb20gdGhlIGVuZF9pbyBmdW5jdGlvbiBvZiB0
aGUgcmVhZCBiaW8/ClRoYXQgd291bGQgZGlzZW50YW5nbGUgdGhpbmdzLCBhbmQgd2Ugc2hvdWxk
IGJlIGdldHRpbmcgYSBiZXR0ZXIgCnBlcmZvcm1hbmNlLgoKQ2hlZXJzLAoKSGFubmVzCi0tIApE
ci4gSGFubmVzIFJlaW5lY2tlCQkgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdApo
YXJlQHN1c2UuZGUJCQkgICAgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNv
ZnR3YXJlIFNvbHV0aW9ucyBHZXJtYW55IEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJu
YmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIKCi0t
CmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1h
bi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

