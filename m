Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBDE8C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 24 May 2022 07:14:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-bM52Vz6lOhuvDf6RI0b_hg-1; Tue, 24 May 2022 03:14:21 -0400
X-MC-Unique: bM52Vz6lOhuvDf6RI0b_hg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74DF2100BAA0;
	Tue, 24 May 2022 07:14:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 62A70C27E8E;
	Tue, 24 May 2022 07:14:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 27A201947065;
	Tue, 24 May 2022 07:14:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EB6EF194704A
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 May 2022 07:14:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C3DF07AD8; Tue, 24 May 2022 07:14:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BF0167AF5
 for <dm-devel@redhat.com>; Tue, 24 May 2022 07:14:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A334929AA3B7
 for <dm-devel@redhat.com>; Tue, 24 May 2022 07:14:17 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-LdG_DVQbMCWwiXvmIOypAA-1; Tue, 24 May 2022 03:14:14 -0400
X-MC-Unique: LdG_DVQbMCWwiXvmIOypAA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id BB95F1F8B8;
 Tue, 24 May 2022 07:14:12 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6A61113ADF;
 Tue, 24 May 2022 07:14:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id eUf7GMSFjGL1QQAAMHmgww
 (envelope-from <hare@suse.de>); Tue, 24 May 2022 07:14:12 +0000
Message-ID: <83ef402e-1cff-a675-eab6-9fac9bb7565d@suse.de>
Date: Tue, 24 May 2022 09:14:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk, hch@lst.de,
 snitzer@redhat.com, damien.lemoal@opensource.wdc.com,
 Johannes.Thumshirn@wdc.com
References: <20220523161601.58078-1-p.raghav@samsung.com>
 <CGME20220523161606eucas1p2676c4d47f9fcb145f69b29db1f04fe6e@eucas1p2.samsung.com>
 <20220523161601.58078-3-p.raghav@samsung.com>
 <a7a409dc-4cf3-7096-50f6-7f794d4a0b9b@suse.de>
 <214e0c82-ce20-ba0f-77bd-21f3b83fd1f1@samsung.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <214e0c82-ce20-ba0f-77bd-21f3b83fd1f1@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v5 2/7] block: allow blk-zoned devices to
 have non-power-of-2 zone size
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS8yNC8yMiAwOToxMCwgUGFua2FqIFJhZ2hhdiB3cm90ZToKPiBPbiA1LzI0LzIyIDA3OjE5
LCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6Cj4gCj4+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51
eC9ibGtkZXYuaCBiL2luY2x1ZGUvbGludXgvYmxrZGV2LmgKPj4+IGluZGV4IGM0ZTRjNzA3MWI3
Yi4uZjVjN2E0MTAzMmJhIDEwMDY0NAo+Pj4gLS0tIGEvaW5jbHVkZS9saW51eC9ibGtkZXYuaAo+
Pj4gKysrIGIvaW5jbHVkZS9saW51eC9ibGtkZXYuaAo+Pj4gQEAgLTY3Niw2ICs2NzYsMjEgQEAg
c3RhdGljIGlubGluZSB1bnNpZ25lZCBpbnQKPj4+IGJsa19xdWV1ZV96b25lX25vKHN0cnVjdCBy
ZXF1ZXN0X3F1ZXVlICpxLAo+Pj4gIMKgwqDCoMKgwqAgcmV0dXJuIGRpdjY0X3U2NChzZWN0b3Is
IHpvbmVfc2VjdG9ycyk7Cj4+PiAgwqAgfQo+Pj4gIMKgICtzdGF0aWMgaW5saW5lIGJvb2wgYmxr
X3F1ZXVlX2lzX3pvbmVfc3RhcnQoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsCj4+PiBzZWN0b3Jf
dCBzZWMpCj4+PiArewo+Pj4gK8KgwqDCoCBzZWN0b3JfdCB6b25lX3NlY3RvcnMgPSBibGtfcXVl
dWVfem9uZV9zZWN0b3JzKHEpOwo+Pj4gK8KgwqDCoCB1NjQgcmVtYWluZGVyID0gMDsKPj4+ICsK
Pj4+ICvCoMKgwqAgaWYgKCFibGtfcXVldWVfaXNfem9uZWQocSkpCj4+PiArwqDCoMKgwqDCoMKg
wqAgcmV0dXJuIGZhbHNlOwo+Pj4gKwo+Pgo+PiBOb3Qgc3VyZSBpZiB3ZSBuZWVkIHRoaXMgaGVy
ZTsgc3VyZWx5IGJsa19xdWV1ZV96b25lX3NlY3RvcnMoKSB3aWxsCj4+IGFscmVhZHkgYmFyZiwg
YW5kIG5vbmUgb2YgdGhlIGNhbGxlcnMgZGlkIHRoaXMgY2hlY2suCj4+Cj4gSSB0b3RhbGx5IGFn
cmVlIHdpdGggeW91IGJ1dCBhbGwgdGhlIG90aGVyIGJsa19xdWV1ZV8qIGZ1bmN0aW9ucyBoYWQK
PiB0aGlzIGRlZmVuc2l2ZSBjaGVjayBhbmQgSSBkaWRuJ3Qgd2FudCB0byBicmVhayB0aGF0IHBh
dHRlcm46Cj4gCkFoLCBmYWlyIGVub3VnaC4KClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2Ug
PGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAg
ICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBT
b2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAo
QUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBUb3RldiwgQW5kcmV3Ck15ZXJz
LCBBbmRyZXcgTWNEb25hbGQsIE1hcnRqZSBCb3VkaWVuIE1vZXJtYW4KCi0tCmRtLWRldmVsIG1h
aWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

