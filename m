Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 401F6C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 24 May 2022 05:23:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-lnGOxuTXOMeJAaWcgPEHug-1; Tue, 24 May 2022 01:22:56 -0400
X-MC-Unique: lnGOxuTXOMeJAaWcgPEHug-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7249803CB8;
	Tue, 24 May 2022 05:22:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B3BA4C08087;
	Tue, 24 May 2022 05:22:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 679D81947BA1;
	Tue, 24 May 2022 05:22:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 30BA51947068
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 May 2022 05:22:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1375B1410DD7; Tue, 24 May 2022 05:22:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F8F11410DD5
 for <dm-devel@redhat.com>; Tue, 24 May 2022 05:22:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBA763C025C4
 for <dm-devel@redhat.com>; Tue, 24 May 2022 05:22:52 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-LGkCTEijP2mWRJzHHOwe2w-1; Tue, 24 May 2022 01:22:50 -0400
X-MC-Unique: LGkCTEijP2mWRJzHHOwe2w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 16494219FE;
 Tue, 24 May 2022 05:22:49 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B708013ADF;
 Tue, 24 May 2022 05:22:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id nXFgK6hrjGIBGwAAMHmgww
 (envelope-from <hare@suse.de>); Tue, 24 May 2022 05:22:48 +0000
Message-ID: <3d387876-342d-1516-92aa-24d39aa3f95c@suse.de>
Date: Tue, 24 May 2022 07:22:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk, hch@lst.de,
 snitzer@redhat.com, damien.lemoal@opensource.wdc.com,
 Johannes.Thumshirn@wdc.com
References: <20220523161601.58078-1-p.raghav@samsung.com>
 <CGME20220523161612eucas1p102a76ba431c934230309042521018915@eucas1p1.samsung.com>
 <20220523161601.58078-7-p.raghav@samsung.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220523161601.58078-7-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v5 6/7] null_blk: use zone_size_sects_shift
 for power of 2 zoned devices
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
Cc: Damien Le Moal <damien.lemoal@wdc.com>, gost.dev@samsung.com,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS8yMy8yMiAxODoxNiwgUGFua2FqIFJhZ2hhdiB3cm90ZToKPiBJbnN0ZWFkIG9mIGRvaW5n
IGlzX3Bvd2VyX29mXzIgYW5kIGlsb2cyIG9wZXJhdGlvbiBmb3IgZXZlcnkgSU8sIGNhY2hlCj4g
dGhlIHpvbmVfc2l6ZV9zZWN0c19zaGlmdCB2YXJpYWJsZSBhbmQgdXNlIGl0IGZvciBwb3dlciBv
ZiAyIHpvbmVkCj4gZGV2aWNlcy4KPiAKPiBUaGlzIHZhcmlhYmxlIHdpbGwgYmUgc2V0IHRvIHpl
cm8gZm9yIG5vbiBwb3dlciBvZiAyIHpvbmVkIGRldmljZXMuCj4gCj4gU3VnZ2VzdGVkLWJ5OiBE
YW1pZW4gTGUgTW9hbCA8ZGFtaWVuLmxlbW9hbEB3ZGMuY29tPgo+IFNpZ25lZC1vZmYtYnk6IFBh
bmthaiBSYWdoYXYgPHAucmFnaGF2QHNhbXN1bmcuY29tPgo+IC0tLQo+ICAgZHJpdmVycy9ibG9j
ay9udWxsX2Jsay9udWxsX2Jsay5oIHwgIDYgKysrKysrCj4gICBkcml2ZXJzL2Jsb2NrL251bGxf
YmxrL3pvbmVkLmMgICAgfCAxMCArKysrKysrKy0tCj4gICAyIGZpbGVzIGNoYW5nZWQsIDE0IGlu
c2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmxv
Y2svbnVsbF9ibGsvbnVsbF9ibGsuaCBiL2RyaXZlcnMvYmxvY2svbnVsbF9ibGsvbnVsbF9ibGsu
aAo+IGluZGV4IDc4ZWI1NmIwY2E1NS4uM2Q2ZTQxYTk0OTFmIDEwMDY0NAo+IC0tLSBhL2RyaXZl
cnMvYmxvY2svbnVsbF9ibGsvbnVsbF9ibGsuaAo+ICsrKyBiL2RyaXZlcnMvYmxvY2svbnVsbF9i
bGsvbnVsbF9ibGsuaAo+IEBAIC03NCw2ICs3NCwxMiBAQCBzdHJ1Y3QgbnVsbGJfZGV2aWNlIHsK
PiAgIAl1bnNpZ25lZCBpbnQgaW1wX2Nsb3NlX3pvbmVfbm87Cj4gICAJc3RydWN0IG51bGxiX3pv
bmUgKnpvbmVzOwo+ICAgCXNlY3Rvcl90IHpvbmVfc2l6ZV9zZWN0czsKPiArCS8qCj4gKwkgKiB6
b25lX3NpemVfc2VjdHNfc2hpZnQgaXMgb25seSB1c2VmdWwgd2hlbiB0aGUgem9uZSBzaXplIGlz
Cj4gKwkgKiBwb3dlciBvZiAyLiBUaGlzIHZhcmlhYmxlIGlzIHNldCB0byB6ZXJvIHdoZW4gem9u
ZSBzaXplIGlzIG5vbgo+ICsJICogcG93ZXIgb2YgMi4KPiArCSAqLwo+ICsJdW5zaWduZWQgaW50
IHpvbmVfc2l6ZV9zZWN0c19zaGlmdDsKPiAgIAlib29sIG5lZWRfem9uZV9yZXNfbWdtdDsKPiAg
IAlzcGlubG9ja190IHpvbmVfcmVzX2xvY2s7Cj4gICAKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9i
bG9jay9udWxsX2Jsay96b25lZC5jIGIvZHJpdmVycy9ibG9jay9udWxsX2Jsay96b25lZC5jCj4g
aW5kZXggMDBjMzRlNjVlZjBhLi44MDZiZWY5OGFjODMgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9i
bG9jay9udWxsX2Jsay96b25lZC5jCj4gKysrIGIvZHJpdmVycy9ibG9jay9udWxsX2Jsay96b25l
ZC5jCj4gQEAgLTEzLDggKzEzLDggQEAgc3RhdGljIGlubGluZSBzZWN0b3JfdCBtYl90b19zZWN0
cyh1bnNpZ25lZCBsb25nIG1iKQo+ICAgCj4gICBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGludCBu
dWxsX3pvbmVfbm8oc3RydWN0IG51bGxiX2RldmljZSAqZGV2LCBzZWN0b3JfdCBzZWN0KQo+ICAg
ewo+IC0JaWYgKGlzX3Bvd2VyX29mXzIoZGV2LT56b25lX3NpemVfc2VjdHMpKQo+IC0JCXJldHVy
biBzZWN0ID4+IGlsb2cyKGRldi0+em9uZV9zaXplX3NlY3RzKTsKPiArCWlmIChkZXYtPnpvbmVf
c2l6ZV9zZWN0c19zaGlmdCkKPiArCQlyZXR1cm4gc2VjdCA+PiBkZXYtPnpvbmVfc2l6ZV9zZWN0
c19zaGlmdDsKPiAgIAo+ICAgCXJldHVybiBkaXY2NF91NjQoc2VjdCwgZGV2LT56b25lX3NpemVf
c2VjdHMpOwo+ICAgfQo+IEBAIC04Miw2ICs4MiwxMiBAQCBpbnQgbnVsbF9pbml0X3pvbmVkX2Rl
dihzdHJ1Y3QgbnVsbGJfZGV2aWNlICpkZXYsIHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxKQo+ICAg
CXpvbmVfY2FwYWNpdHlfc2VjdHMgPSBtYl90b19zZWN0cyhkZXYtPnpvbmVfY2FwYWNpdHkpOwo+
ICAgCWRldl9jYXBhY2l0eV9zZWN0cyA9IG1iX3RvX3NlY3RzKGRldi0+c2l6ZSk7Cj4gICAJZGV2
LT56b25lX3NpemVfc2VjdHMgPSBtYl90b19zZWN0cyhkZXYtPnpvbmVfc2l6ZSk7Cj4gKwo+ICsJ
aWYgKGlzX3Bvd2VyX29mXzIoZGV2LT56b25lX3NpemVfc2VjdHMpKQo+ICsJCWRldi0+em9uZV9z
aXplX3NlY3RzX3NoaWZ0ID0gaWxvZzIoZGV2LT56b25lX3NpemVfc2VjdHMpOwo+ICsJZWxzZQo+
ICsJCWRldi0+em9uZV9zaXplX3NlY3RzX3NoaWZ0ID0gMDsKPiArCj4gICAJZGV2LT5ucl96b25l
cyA9Cj4gICAJCWRpdjY0X3U2NChyb3VuZHVwKGRldl9jYXBhY2l0eV9zZWN0cywgZGV2LT56b25l
X3NpemVfc2VjdHMpLAo+ICAgCQkJICBkZXYtPnpvbmVfc2l6ZV9zZWN0cyk7ClJldmlld2VkLWJ5
OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIu
IEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QK
aGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2
ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8
cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBU
b3RldiwgQW5kcmV3Ck15ZXJzLCBBbmRyZXcgTWNEb25hbGQsIE1hcnRqZSBCb3VkaWVuIE1vZXJt
YW4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

