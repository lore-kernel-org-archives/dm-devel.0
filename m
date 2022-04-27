Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D00B3C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 10:31:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-R6zJopilMx68mPkawANn1w-1; Wed, 27 Apr 2022 06:31:16 -0400
X-MC-Unique: R6zJopilMx68mPkawANn1w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1EEF80346E;
	Wed, 27 Apr 2022 10:31:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A0F1AC28127;
	Wed, 27 Apr 2022 10:31:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 36D2B1947042;
	Wed, 27 Apr 2022 10:31:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 95AFE1947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 10:31:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 785877774; Wed, 27 Apr 2022 10:31:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 71F1E9E8E
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 10:31:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9E60801E67
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 10:31:03 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-07qhaoBgMdqwcwbziQTYgg-1; Wed, 27 Apr 2022 06:30:59 -0400
X-MC-Unique: 07qhaoBgMdqwcwbziQTYgg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id EF7831F38D;
 Wed, 27 Apr 2022 10:30:57 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 73EA91323E;
 Wed, 27 Apr 2022 10:30:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id wzGnGmEbaWJ0AgAAMHmgww
 (envelope-from <hare@suse.de>); Wed, 27 Apr 2022 10:30:57 +0000
Message-ID: <96acbc76-1de8-4be0-314c-4a6a9284c5a3@suse.de>
Date: Wed, 27 Apr 2022 12:30:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <20220426101241.30100-1-nj.shetty@samsung.com>
 <CGME20220426101910epcas5p4fd64f83c6da9bbd891107d158a2743b5@epcas5p4.samsung.com>
 <20220426101241.30100-2-nj.shetty@samsung.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220426101241.30100-2-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v4 01/10] block: Introduce queue limits for
 copy-offload support
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
 Johannes Thumshirn <jth@kernel.org>, tytso@mit.edu,
 Kanchan Joshi <joshi.k@samsung.com>, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, Arnav Dawn <arnav.dawn@samsung.com>,
 jack@suse.com, linux-fsdevel@vger.kernel.org,
 lsf-pc@lists.linux-foundation.org,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
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

T24gNC8yNi8yMiAxMjoxMiwgTml0ZXNoIFNoZXR0eSB3cm90ZToKPiBBZGQgZGV2aWNlIGxpbWl0
cyBhcyBzeXNmcyBlbnRyaWVzLAo+ICAgICAgICAgIC0gY29weV9vZmZsb2FkIChSVykKPiAgICAg
ICAgICAtIGNvcHlfbWF4X2J5dGVzIChSVykKPiAgICAgICAgICAtIGNvcHlfbWF4X2h3X2J5dGVz
IChSTykKPiAgICAgICAgICAtIGNvcHlfbWF4X3JhbmdlX2J5dGVzIChSVykKPiAgICAgICAgICAt
IGNvcHlfbWF4X3JhbmdlX2h3X2J5dGVzIChSTykKPiAgICAgICAgICAtIGNvcHlfbWF4X25yX3Jh
bmdlcyAoUlcpCj4gICAgICAgICAgLSBjb3B5X21heF9ucl9yYW5nZXNfaHcgKFJPKQo+IAo+IEFi
b3ZlIGxpbWl0cyBoZWxwIHRvIHNwbGl0IHRoZSBjb3B5IHBheWxvYWQgaW4gYmxvY2sgbGF5ZXIu
Cj4gY29weV9vZmZsb2FkLCB1c2VkIGZvciBzZXR0aW5nIGNvcHkgb2ZmbG9hZCgxKSBvciBlbXVs
YXRpb24oMCkuCj4gY29weV9tYXhfYnl0ZXM6IG1heGltdW0gdG90YWwgbGVuZ3RoIG9mIGNvcHkg
aW4gc2luZ2xlIHBheWxvYWQuCj4gY29weV9tYXhfcmFuZ2VfYnl0ZXM6IG1heGltdW0gbGVuZ3Ro
IGluIGEgc2luZ2xlIGVudHJ5Lgo+IGNvcHlfbWF4X25yX3JhbmdlczogbWF4aW11bSBudW1iZXIg
b2YgZW50cmllcyBpbiBhIHBheWxvYWQuCj4gY29weV9tYXhfKl9od18qOiBSZWZsZWN0cyB0aGUg
ZGV2aWNlIHN1cHBvcnRlZCBtYXhpbXVtIGxpbWl0cy4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBOaXRl
c2ggU2hldHR5IDxuai5zaGV0dHlAc2Ftc3VuZy5jb20+Cj4gU2lnbmVkLW9mZi1ieTogS2FuY2hh
biBKb3NoaSA8am9zaGkua0BzYW1zdW5nLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBBcm5hdiBEYXdu
IDxhcm5hdi5kYXduQHNhbXN1bmcuY29tPgo+IC0tLQo+ICAgRG9jdW1lbnRhdGlvbi9BQkkvc3Rh
YmxlL3N5c2ZzLWJsb2NrIHwgIDgzICsrKysrKysrKysrKysrKysKPiAgIGJsb2NrL2Jsay1zZXR0
aW5ncy5jICAgICAgICAgICAgICAgICB8ICA1OSArKysrKysrKysrKysKPiAgIGJsb2NrL2Jsay1z
eXNmcy5jICAgICAgICAgICAgICAgICAgICB8IDEzOCArKysrKysrKysrKysrKysrKysrKysrKysr
KysKPiAgIGluY2x1ZGUvbGludXgvYmxrZGV2LmggICAgICAgICAgICAgICB8ICAxMyArKysKPiAg
IDQgZmlsZXMgY2hhbmdlZCwgMjkzIGluc2VydGlvbnMoKykKPiAKClJldmlld2VkLWJ5OiBIYW5u
ZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5l
cyBSZWluZWNrZQkJICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNl
LmRlCQkJICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBT
b2x1dGlvbnMgR2VybWFueSBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKSFJC
IDM2ODA5IChBRyBOw7xybmJlcmcpLCBHRjogRmVsaXggSW1lbmTDtnJmZmVyCgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

