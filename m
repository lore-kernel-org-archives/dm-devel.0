Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86F1BC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 24 May 2022 05:21:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-SV8v9WL6N0Cgz68AcEFAtg-1; Tue, 24 May 2022 01:21:50 -0400
X-MC-Unique: SV8v9WL6N0Cgz68AcEFAtg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 449D210A5CC0;
	Tue, 24 May 2022 05:21:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 336352026D6A;
	Tue, 24 May 2022 05:21:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0E0B31947BA1;
	Tue, 24 May 2022 05:21:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 128631947068
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 May 2022 05:21:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E9ACB40869D9; Tue, 24 May 2022 05:21:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E566040869D1
 for <dm-devel@redhat.com>; Tue, 24 May 2022 05:21:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B79E038171F0
 for <dm-devel@redhat.com>; Tue, 24 May 2022 05:21:37 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-9Y8cX93VNielF5YWNeGnhQ-1; Tue, 24 May 2022 01:21:32 -0400
X-MC-Unique: 9Y8cX93VNielF5YWNeGnhQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id A0FE3219F5;
 Tue, 24 May 2022 05:21:31 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 39A1413ADF;
 Tue, 24 May 2022 05:21:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 1UwoDVtrjGK6GgAAMHmgww
 (envelope-from <hare@suse.de>); Tue, 24 May 2022 05:21:31 +0000
Message-ID: <e7a0d9c4-de27-4713-cacd-7017faa1b0d6@suse.de>
Date: Tue, 24 May 2022 07:21:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk, hch@lst.de,
 snitzer@redhat.com, damien.lemoal@opensource.wdc.com,
 Johannes.Thumshirn@wdc.com
References: <20220523161601.58078-1-p.raghav@samsung.com>
 <CGME20220523161607eucas1p2b6245eafb81dee3e2efbec3ab86a854d@eucas1p2.samsung.com>
 <20220523161601.58078-4-p.raghav@samsung.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220523161601.58078-4-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v5 3/7] nvme: zns: Allow ZNS drives that have
 non-power_of_2 zone size
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
Cc: gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS8yMy8yMiAxODoxNSwgUGFua2FqIFJhZ2hhdiB3cm90ZToKPiBSZW1vdmUgdGhlIGNvbmRp
dGlvbiB3aGljaCBkaXNhbGxvd3Mgbm9uLXBvd2VyX29mXzIgem9uZSBzaXplIFpOUyBkcml2ZQo+
IHRvIGJlIHVwZGF0ZWQgYW5kIHVzZSBnZW5lcmljIG1ldGhvZCB0byBjYWxjdWxhdGUgbnVtYmVy
IG9mIHpvbmVzCj4gaW5zdGVhZCBvZiByZWx5aW5nIG9uIGxvZyBhbmQgc2hpZnQgYmFzZWQgY2Fs
Y3VsYXRpb24gb24gem9uZSBzaXplLgo+IAo+IFRoZSBwb3dlcl9vZl8yIGNhbGN1bGF0aW9uIGhh
cyBiZWVuIHJlcGxhY2VkIGRpcmVjdGx5IHdpdGggZ2VuZXJpYwo+IGNhbGN1bGF0aW9uIHdpdGhv
dXQgc3BlY2lhbCBoYW5kbGluZy4gQm90aCBtb2RpZmllZCBmdW5jdGlvbnMgYXJlIG5vdAo+IHVz
ZWQgaW4gaG90IHBhdGhzLCB0aGV5IGFyZSBvbmx5IHVzZWQgZHVyaW5nIGluaXRpYWxpemF0aW9u
ICYKPiByZXZhbGlkYXRpb24gb2YgdGhlIFpOUyBkZXZpY2UuCj4gCj4gQXMgcm91bmRkb3duIG1h
Y3JvIGZyb20gbWF0aC5oIGRvZXMgbm90IHdvcmsgZm9yIDMyIGJpdCBhcmNoaXRlY3R1cmVzLAo+
IHJvdW5kIGRvd24gb3BlcmF0aW9uIGlzIG9wZW4gY29kZWQuCj4gCj4gUmV2aWV3ZWQtYnk6IEx1
aXMgQ2hhbWJlcmxhaW4gPG1jZ3JvZkBrZXJuZWwub3JnPgo+IFJldmlld2VkIGJ5OiBBZGFtIE1h
bnphbmFyZXMgPGEubWFuemFuYXJlc0BzYW1zdW5nLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBQYW5r
YWogUmFnaGF2IDxwLnJhZ2hhdkBzYW1zdW5nLmNvbT4KPiAtLS0KPiAgIGRyaXZlcnMvbnZtZS9o
b3N0L3pucy5jIHwgMjEgKysrKysrKysrKysrLS0tLS0tLS0tCj4gICAxIGZpbGUgY2hhbmdlZCwg
MTIgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9udm1lL2hvc3Qvem5zLmMgYi9kcml2ZXJzL252bWUvaG9zdC96bnMuYwo+IGluZGV4IDlmODFi
ZWI0ZGY0ZS4uZDkyZjkzN2Q1Y2I5IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbnZtZS9ob3N0L3pu
cy5jCj4gKysrIGIvZHJpdmVycy9udm1lL2hvc3Qvem5zLmMKPiBAQCAtMTAxLDEzICsxMDEsNiBA
QCBpbnQgbnZtZV91cGRhdGVfem9uZV9pbmZvKHN0cnVjdCBudm1lX25zICpucywgdW5zaWduZWQg
bGJhZikKPiAgIAl9Cj4gICAKPiAgIAlucy0+enN6ZSA9IG52bWVfbGJhX3RvX3NlY3QobnMsIGxl
NjRfdG9fY3B1KGlkLT5sYmFmZVtsYmFmXS56c3plKSk7Cj4gLQlpZiAoIWlzX3Bvd2VyX29mXzIo
bnMtPnpzemUpKSB7Cj4gLQkJZGV2X3dhcm4obnMtPmN0cmwtPmRldmljZSwKPiAtCQkJImludmFs
aWQgem9uZSBzaXplOiVsbHUgZm9yIG5hbWVzcGFjZToldVxuIiwKPiAtCQkJbnMtPnpzemUsIG5z
LT5oZWFkLT5uc19pZCk7Cj4gLQkJc3RhdHVzID0gLUVOT0RFVjsKPiAtCQlnb3RvIGZyZWVfZGF0
YTsKPiAtCX0KPiAgIAo+ICAgCWJsa19xdWV1ZV9zZXRfem9uZWQobnMtPmRpc2ssIEJMS19aT05F
RF9ITSk7Cj4gICAJYmxrX3F1ZXVlX2ZsYWdfc2V0KFFVRVVFX0ZMQUdfWk9ORV9SRVNFVEFMTCwg
cSk7Cj4gQEAgLTEyOCw4ICsxMjEsMTMgQEAgc3RhdGljIHZvaWQgKm52bWVfem5zX2FsbG9jX3Jl
cG9ydF9idWZmZXIoc3RydWN0IG52bWVfbnMgKm5zLAo+ICAgCWNvbnN0IHNpemVfdCBtaW5fYnVm
c2l6ZSA9IHNpemVvZihzdHJ1Y3QgbnZtZV96b25lX3JlcG9ydCkgKwo+ICAgCQkJCSAgIHNpemVv
ZihzdHJ1Y3QgbnZtZV96b25lX2Rlc2NyaXB0b3IpOwo+ICAgCj4gKwkvKgo+ICsJICogRGl2aXNp
b24gaXMgdXNlZCB0byBjYWxjdWxhdGUgbnJfem9uZXMgd2l0aCBubyBzcGVjaWFsIGhhbmRsaW5n
Cj4gKwkgKiBmb3IgcG93ZXIgb2YgMiB6b25lIHNpemVzIGFzIHRoaXMgZnVuY3Rpb24gaXMgbm90
IGludm9rZWQgaW4gYQo+ICsJICogaG90IHBhdGgKPiArCSAqLwo+ICAgCW5yX3pvbmVzID0gbWlu
X3QodW5zaWduZWQgaW50LCBucl96b25lcywKPiAtCQkJIGdldF9jYXBhY2l0eShucy0+ZGlzaykg
Pj4gaWxvZzIobnMtPnpzemUpKTsKPiArCQkJIGRpdjY0X3U2NChnZXRfY2FwYWNpdHkobnMtPmRp
c2spLCBucy0+enN6ZSkpOwo+ICAgCj4gICAJYnVmc2l6ZSA9IHNpemVvZihzdHJ1Y3QgbnZtZV96
b25lX3JlcG9ydCkgKwo+ICAgCQlucl96b25lcyAqIHNpemVvZihzdHJ1Y3QgbnZtZV96b25lX2Rl
c2NyaXB0b3IpOwo+IEBAIC0xODIsNiArMTgwLDcgQEAgaW50IG52bWVfbnNfcmVwb3J0X3pvbmVz
KHN0cnVjdCBudm1lX25zICpucywgc2VjdG9yX3Qgc2VjdG9yLAo+ICAgCWludCByZXQsIHpvbmVf
aWR4ID0gMDsKPiAgIAl1bnNpZ25lZCBpbnQgbnosIGk7Cj4gICAJc2l6ZV90IGJ1ZmxlbjsKPiAr
CXU2NCByZW1haW5kZXIgPSAwOwo+ICAgCj4gICAJaWYgKG5zLT5oZWFkLT5pZHMuY3NpICE9IE5W
TUVfQ1NJX1pOUykKPiAgIAkJcmV0dXJuIC1FSU5WQUw7Cj4gQEAgLTE5Nyw3ICsxOTYsMTEgQEAg
aW50IG52bWVfbnNfcmVwb3J0X3pvbmVzKHN0cnVjdCBudm1lX25zICpucywgc2VjdG9yX3Qgc2Vj
dG9yLAo+ICAgCWMuem1yLnpyYXNmID0gTlZNRV9aUkFTRl9aT05FX1JFUE9SVF9BTEw7Cj4gICAJ
Yy56bXIucHIgPSBOVk1FX1JFUE9SVF9aT05FX1BBUlRJQUw7Cj4gICAKPiAtCXNlY3RvciAmPSB+
KG5zLT56c3plIC0gMSk7Cj4gKwkvKgo+ICsJICogUm91bmQgZG93biB0aGUgc2VjdG9yIHZhbHVl
IHRvIHRoZSBuZWFyZXN0IHpvbmUgc3RhcnQKPiArCSAqLwo+ICsJZGl2NjRfdTY0X3JlbShzZWN0
b3IsIG5zLT56c3plLCAmcmVtYWluZGVyKTsKPiArCXNlY3RvciAtPSByZW1haW5kZXI7Cj4gICAJ
d2hpbGUgKHpvbmVfaWR4IDwgbnJfem9uZXMgJiYgc2VjdG9yIDwgZ2V0X2NhcGFjaXR5KG5zLT5k
aXNrKSkgewo+ICAgCQltZW1zZXQocmVwb3J0LCAwLCBidWZsZW4pOwo+ICAgClJldmlld2VkLWJ5
OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIu
IEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QK
aGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2
ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8
cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBU
b3RldiwgQW5kcmV3Ck15ZXJzLCBBbmRyZXcgTWNEb25hbGQsIE1hcnRqZSBCb3VkaWVuIE1vZXJt
YW4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

