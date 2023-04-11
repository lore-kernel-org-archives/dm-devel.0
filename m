Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAA52C76196
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 07:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681197345;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=neYvcvjKbn1vbYOntUpmBfuMm7fJUqvOssbmwdm0DRs=;
	b=HTxj9umw1ND925e5BygTJHgwPcZFxkgLg3MBba882VS6kZ7Y6bFJDjTPC46rpU2u6r9z+9
	i54uAKIKioWiknKioM9NWHkwHsnGOdPzvMt0DxnyHzO7LuDFAcIxcbzjsbj4FpkWDe4L0W
	hdTqrr0GNxMeFYDi4mIGrBKm1xmONL0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-WLMDY9HWNFiW5fE5RK-3Vw-1; Tue, 11 Apr 2023 03:15:42 -0400
X-MC-Unique: WLMDY9HWNFiW5fE5RK-3Vw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92079185A78B;
	Tue, 11 Apr 2023 07:15:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 80D2A4020C80;
	Tue, 11 Apr 2023 07:15:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 40CED1946588;
	Tue, 11 Apr 2023 07:15:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 727251946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 07:15:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 51466C15BB8; Tue, 11 Apr 2023 07:15:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 496CAC15BA0
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:15:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2ED50811E7C
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:15:38 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-346-g-MSFZIaNcWxSFA3WJX2_g-1; Tue,
 11 Apr 2023 03:15:36 -0400
X-MC-Unique: g-MSFZIaNcWxSFA3WJX2_g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 8CA801FE07;
 Tue, 11 Apr 2023 07:09:39 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 318B713519;
 Tue, 11 Apr 2023 07:09:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id HOSTCrMHNWRxWwAAMHmgww
 (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 07:09:39 +0000
Message-ID: <67a2b445-b905-387a-2271-244838ef1056@suse.de>
Date: Tue, 11 Apr 2023 09:09:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To: Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
 hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 linux-nvme@lists.infradead.org, chaitanyak@nvidia.com, kbusch@kernel.org,
 target-devel@vger.kernel.org
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230407200551.12660-3-michael.christie@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230407200551.12660-3-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v6 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
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
Cc: Stefan Haberland <sth@linux.ibm.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNC83LzIzIDIyOjA1LCBNaWtlIENocmlzdGllIHdyb3RlOgo+IEJMS19TVFNfTkVYVVMgaXMg
dXNlZCBmb3IgTlZNZS9TQ1NJIHJlc2VydmF0aW9uIGNvbmZsaWN0cyBhbmQgREFTRCdzCj4gbG9j
a2luZyBmZWF0dXJlIHdoaWNoIHdvcmtzIHNpbWlsYXIgdG8gTlZNZS9TQ1NJIHJlc2VydmF0aW9u
cyB3aGVyZSBhCj4gaG9zdCBjYW4gZ2V0IGEgbG9jayBvbiBhIGRldmljZSBhbmQgd2hlbiB0aGUg
bG9jayBpcyB0YWtlbiBpdCB3aWxsIGdldAo+IGZhaWx1cmVzLgo+IAo+IFRoaXMgcGF0Y2ggcmVu
YW1lcyBCTEtfU1RTX05FWFVTIHNvIGl0IGJldHRlciByZWZsZWN0cyB0aGlzIHR5cGUgb2YKPiB1
c2UuCj4gCj4gU2lnbmVkLW9mZi1ieTogTWlrZSBDaHJpc3RpZSA8bWljaGFlbC5jaHJpc3RpZUBv
cmFjbGUuY29tPgo+IEFja2VkLWJ5OiBTdGVmYW4gSGFiZXJsYW5kIDxzdGhAbGludXguaWJtLmNv
bT4KPiBSZXZpZXdlZC1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+Cj4g
LS0tCj4gICBibG9jay9ibGstY29yZS5jICAgICAgICAgIHwgMiArLQo+ICAgZHJpdmVycy9udm1l
L2hvc3QvY29yZS5jICB8IDIgKy0KPiAgIGRyaXZlcnMvczM5MC9ibG9jay9kYXNkLmMgfCA3ICsr
KysrKy0KPiAgIGRyaXZlcnMvc2NzaS9zY3NpX2xpYi5jICAgfCAyICstCj4gICBpbmNsdWRlL2xp
bnV4L2Jsa190eXBlcy5oIHwgNCArKy0tCj4gICA1IGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlv
bnMoKyksIDYgZGVsZXRpb25zKC0pCj4gClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhh
cmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAg
ICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1
dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcg
TsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBUb3RldiwgQW5kcmV3Ck15ZXJzLCBB
bmRyZXcgTWNEb25hbGQsIE1hcnRqZSBCb3VkaWVuIE1vZXJtYW4KCi0tCmRtLWRldmVsIG1haWxp
bmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

