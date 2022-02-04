Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE557C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 14:24:11 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-BOVxiUfpPOeKCRXn8_CqFg-1; Fri, 04 Feb 2022 09:24:09 -0500
X-MC-Unique: BOVxiUfpPOeKCRXn8_CqFg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5987F1923BB8;
	Fri,  4 Feb 2022 14:24:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 943687E120;
	Fri,  4 Feb 2022 14:24:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DF9A54BB7C;
	Fri,  4 Feb 2022 14:24:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 214ENvd7002352 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 09:23:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E6C64C23DC6; Fri,  4 Feb 2022 14:23:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E2591C23DC3
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 14:23:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C28DA85A5BE
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 14:23:56 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-556-SdliFRYsNyKe0svtpVMXGA-1; Fri, 04 Feb 2022 09:23:52 -0500
X-MC-Unique: SdliFRYsNyKe0svtpVMXGA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 07F2D1F38F;
	Fri,  4 Feb 2022 14:15:03 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B8AFF13AE2;
	Fri,  4 Feb 2022 14:15:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id WXHDLOY0/WFfCQAAMHmgww
	(envelope-from <hare@suse.de>); Fri, 04 Feb 2022 14:15:02 +0000
Message-ID: <befa49b3-7606-a3ce-24f7-e184e3df41a3@suse.de>
Date: Fri, 4 Feb 2022 15:15:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.4.0
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	=?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>
References: <alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2202011333160.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<270f30df-f14c-b9e4-253f-bff047d32ff0@nvidia.com>
	<20220203153843.szbd4n65ru4fx5hx@garbanzo>
	<CGME20220203165248uscas1p1f0459e548743e6be26d13d3ed8aa4902@uscas1p1.samsung.com>
	<20220203165238.GA142129@dhcp-10-100-145-180.wdc.com>
	<20220203195155.GB249665@bgt-140510-bm01>
	<863d85e3-9a93-4d8c-cf04-88090eb4cc02@nvidia.com>
	<2bbed027-b9a1-e5db-3a3d-90c40af49e09@opensource.wdc.com>
	<9d5d0b50-2936-eac3-12d3-a309389e03bf@nvidia.com>
	<20220204082445.hczdiy2uhxfi3x2g@ArmHalley.local>
	<4d5410a5-93c3-d73c-6aeb-2c1c7f940963@nvidia.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <4d5410a5-93c3-d73c-6aeb-2c1c7f940963@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 214ENvd7002352
X-loop: dm-devel@redhat.com
Cc: "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Keith Busch <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K. Petersen"
	<martin.petersen@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>,
	"jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [dm-devel] [RFC PATCH 3/3] nvme: add the "debug" host driver
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMi80LzIyIDEwOjU4LCBDaGFpdGFueWEgS3Vsa2Fybmkgd3JvdGU6Cj4gT24gMi80LzIyIDEy
OjI0IEFNLCBKYXZpZXIgR29uesOhbGV6IHdyb3RlOgpbIC4uIF0KPj4gRm9yIGEgc29mdHdhcmUt
b25seSBzb2x1dGlvbiwgd2UgaGF2ZSBleHBlcmltZW50ZWQgd2l0aCBzb21ldGhpbmcKPj4gc2lt
aWxhciB0byB0aGUgbnZtZS1kZWJ1ZyBjb2RlIHRoYSBNaWt1bGFzIGlzIHByb3Bvc2luZy4gQWRh
bSBwb2ludGVkIHRvCj4+IHRoZSBudm1lLWxvb3AgdGFyZ2V0IGFzIGFuIGFsdGVybmF0aXZlIGFu
ZCB0aGlzIHNlZW1zIHRvIHdvcmsgcHJldHR5Cj4+IG5pY2VseS4gSSBkbyBub3QgYmVsaWV2ZSB0
aGVyZSBzaG91bGQgYmUgbWFueSBjaGFuZ2VzIHRvIHN1cHBvcnQgY29weQo+PiBvZmZsb2FkIHVz
aW5nIHRoaXMuCj4+Cj4gCj4gSWYgUUVNVSBpcyBzbyBpbmNvbXBldGVudCB0aGVuIHdlIG5lZWQg
dG8gYWRkIGV2ZXJ5IGJpZyBmZWF0dXJlIGludG8KPiB0aGUgTlZNZU9GIHRlc3QgdGFyZ2V0IHNv
IHRoYXQgd2UgY2FuIHRlc3QgaXQgYmV0dGVyID8gaXMgdGhhdCB3aGF0Cj4geW91IGFyZSBwcm9w
b3NpbmcgPyBzaW5jZSBpZiB3ZSBpbXBsZW1lbnQgb25lIGZlYXR1cmUsIGl0IHdpbGwgYmUKPiBo
YXJkIHRvIG5hY2sgYW55IG5ldyBmZWF0dXJlcyB0aGF0IHBwbCB3aWxsIGNvbWUgdXAgd2l0aAo+
IHNhbWUgcmF0aW9uYWxlICJ3aXRoIFFFTVUgYmVpbmcgc2xvdyBhbmQgaGFyZCB0byB0ZXN0IHJh
Y2UKPiBjb25kaXRpb25zIGV0YyAuLiIKPiAKCkhvdyB3b3VsZCB5b3UgdXNlIHFlbXUgZm9yIGJh
cmUtbWV0YWwgdGVzdGluZz8KCj4gYW5kIGlmIHRoYXQgaXMgdGhlIGNhc2Ugd2h5IHdlIGRvbid0
IGhhdmUgWk5TIE5WTWVPRiB0YXJnZXQKPiBtZW1vcnkgYmFja2VkIGVtdWxhdGlvbiA/IElzbid0
IHRoYXQgYSBiaWdnZXIgYW5kIG1vcmUKPiBjb21wbGljYXRlZCBmZWF0dXJlIHRoYW4gU2ltcGxl
IENvcHkgd2hlcmUgY29udHJvbGxlciBzdGF0ZXMKPiBhcmUgaW52b2x2ZWQgd2l0aCBBRU5zID8K
PiAKPiBaTlMga2VybmVsIGNvZGUgdGVzdGluZyBpcyBhbHNvIGRvbmUgb24gUUVNVSwgSSd2ZSBh
bHNvIGZpeGVkCj4gYnVncyBpbiB0aGUgWk5TIGtlcm5lbCBjb2RlIHdoaWNoIGFyZSBkaXNjb3Zl
cmVkIG9uIFFFTVUgYW5kIEkndmUgbm90Cj4gc2VlbiBhbnkgaXNzdWVzIHdpdGggdGhhdC4gR2l2
ZW4gdGhhdCBzaW1wbGUgY29weSBmZWF0dXJlIGlzIHdheSBzbWFsbGVyCj4gdGhhbiBaTlMgaXQg
d2lsbCBsZXNzIGxpa2VseSB0byBzdWZmZXIgZnJvbSBzbG93bmVzcyBhbmQgZXRjIChsaXN0ZWQK
PiBhYm92ZSkgaW4gUUVNVS4KPiAKPiBteSBwb2ludCBpcyBpZiB3ZSBhbGxvdyBvbmUsIHdlIHdp
bGwgYmUgb3BlbmluZyBmbG9vZGdhdGVzIGFuZCB3ZSBuZWVkCj4gdG8gYmUgY2FyZWZ1bCBub3Qg
dG8gYmxvYXQgdGhlIGNvZGUgdW5sZXNzIGl0IGlzIF9hYnNvbHV0ZWx5Cj4gbmVjZXNzYXJ5XyB3
aGljaCBJIGRvbid0IHRoaW5rIGl0IGlzIGJhc2VkIG9uIHRoZSBzaW1wbGUgY29weQo+IHNwZWNp
ZmljYXRpb24uCj4gCgpJIGRvIGhhdmUgYSBzbGlnaHRseSBkaWZmZXJlbnQgdmlldyBvbiB0aGUg
bnZtZSB0YXJnZXQgY29kZTsgaXQgc2hvdWxkIApwcm92aWRlIHRoZSBuZWNlc3NhcnkgbWVhbnMg
dG8gdGVzdCB0aGUgbnZtZSBob3N0IGNvZGUuCkFuZCBzaW1wbGUgY29weSBpcyBvbiBvZiB0aGVz
ZSBmZWF0dXJlcywgZXNwZWNpYWxseSBhcyBpdCB3aWxsIG9wZXJhdGUgCmFzIGFuIGV4cGxvaXRl
ciBvZiB0aGUgbmV3IGZ1bmN0aW9uYWxpdHkuCgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5u
ZXMgUmVpbmVja2UJCSAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3Vz
ZS5kZQkJCSAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUg
U29sdXRpb25zIEdlcm1hbnkgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhS
QiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRl
dmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

