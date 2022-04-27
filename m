Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D07E7C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 10:37:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-eM6Go3M_NL-ll9-06iNxiQ-1; Wed, 27 Apr 2022 06:37:16 -0400
X-MC-Unique: eM6Go3M_NL-ll9-06iNxiQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C4173C0F086;
	Wed, 27 Apr 2022 10:37:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4810040CFD05;
	Wed, 27 Apr 2022 10:37:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 01DA11947042;
	Wed, 27 Apr 2022 10:37:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ACC731947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 10:37:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8FF8CC52C89; Wed, 27 Apr 2022 10:37:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BF61C52C84
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 10:37:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 735A01014A61
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 10:37:11 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-3Dlw-8PtPSa_mamueIcc2w-1; Wed, 27 Apr 2022 06:37:09 -0400
X-MC-Unique: 3Dlw-8PtPSa_mamueIcc2w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id DE5591F747;
 Wed, 27 Apr 2022 10:37:07 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 942411323E;
 Wed, 27 Apr 2022 10:37:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id VQRnI9McaWJTBQAAMHmgww
 (envelope-from <hare@suse.de>); Wed, 27 Apr 2022 10:37:07 +0000
Message-ID: <a885def5-7373-28d9-6ed6-bc836864c67c@suse.de>
Date: Wed, 27 Apr 2022 12:37:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <20220426101241.30100-1-nj.shetty@samsung.com>
 <CGME20220426101938epcas5p291690dd1f0e931cd9f8139daaf3f9296@epcas5p2.samsung.com>
 <20220426101241.30100-4-nj.shetty@samsung.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220426101241.30100-4-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
 Alexander Viro <viro@zeniv.linux.org.uk>, kbusch@kernel.org,
 Frederick.Knight@netapp.com, Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk,
 Johannes Thumshirn <jth@kernel.org>, tytso@mit.edu, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, Arnav Dawn <arnav.dawn@samsung.com>,
 jack@suse.com, linux-fsdevel@vger.kernel.org,
 =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier.gonz@samsung.com>,
 lsf-pc@lists.linux-foundation.org,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNC8yNi8yMiAxMjoxMiwgTml0ZXNoIFNoZXR0eSB3cm90ZToKPiBBZGQgbmV3IEJMS0NPUFkg
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
biByZXQ7Cj4gfQo+IAo+IFNpZ25lZC1vZmYtYnk6IE5pdGVzaCBTaGV0dHkgPG5qLnNoZXR0eUBz
YW1zdW5nLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBKYXZpZXIgR29uesOhbGV6IDxqYXZpZXIuZ29u
ekBzYW1zdW5nLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBBcm5hdiBEYXduIDxhcm5hdi5kYXduQHNh
bXN1bmcuY29tPgo+IC0tLQo+ICAgYmxvY2svaW9jdGwuYyAgICAgICAgICAgfCAzMiArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKwo+ICAgaW5jbHVkZS91YXBpL2xpbnV4L2ZzLmggfCAg
OSArKysrKysrKysKPiAgIDIgZmlsZXMgY2hhbmdlZCwgNDEgaW5zZXJ0aW9ucygrKQo+IApSZXZp
ZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMK
LS0gCkRyLiBIYW5uZXMgUmVpbmVja2UJCSAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0
ZWN0CmhhcmVAc3VzZS5kZQkJCSAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNV
U0UgU29mdHdhcmUgU29sdXRpb25zIEdlcm1hbnkgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkg
TsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZl
cgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9s
aXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

