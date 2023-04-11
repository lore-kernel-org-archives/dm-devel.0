Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE6B7C76196
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 07:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681197647;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=n1X2w6x2do0X9ApGmpS+zwD9gp6ks6AuezvxaMZ78XU=;
	b=FVWA3OMxbJrhJha16lmmDfOqkWXfObt6P9AE9YoDTdRDk1TisbANxnUWFMKsXfJ4nsCUN8
	ZODupB3zy9OIuEsw8ZIMavfMGDy6Z65csJhJpMMsN9JVOFbh4fLikVvLHi7NaWJJ59H3+i
	/YGA27KS9KzTM/QYoQGtJaKevBuyYYs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-ZGJrHyTlNOO5GCZV9R5RIQ-1; Tue, 11 Apr 2023 03:20:44 -0400
X-MC-Unique: ZGJrHyTlNOO5GCZV9R5RIQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1627C85A5A3;
	Tue, 11 Apr 2023 07:20:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B755340C83A9;
	Tue, 11 Apr 2023 07:20:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7EFD11946588;
	Tue, 11 Apr 2023 07:20:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 98F721946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 07:20:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 87D204020C82; Tue, 11 Apr 2023 07:20:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8034F4020C80
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:20:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63446855300
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:20:41 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-428-irsqfZD2N3ONc8UnVSBVWQ-1; Tue,
 11 Apr 2023 03:20:39 -0400
X-MC-Unique: irsqfZD2N3ONc8UnVSBVWQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 41D251FDFF;
 Tue, 11 Apr 2023 07:20:38 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E95FD13638;
 Tue, 11 Apr 2023 07:20:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id s/zlN0UKNWQoYQAAMHmgww
 (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 07:20:37 +0000
Message-ID: <6c4584d8-4989-3855-21c8-031e200a88b0@suse.de>
Date: Tue, 11 Apr 2023 09:20:37 +0200
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
 <20230407200551.12660-12-michael.christie@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230407200551.12660-12-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v6 11/18] nvme: Add pr_ops read_keys support
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNC83LzIzIDIyOjA1LCBNaWtlIENocmlzdGllIHdyb3RlOgo+IFRoaXMgcGF0Y2ggYWRkcyBz
dXBwb3J0IGZvciB0aGUgcHJfb3BzIHJlYWRfa2V5cyBjYWxsb3V0IGJ5IGNhbGxpbmcgdGhlCj4g
TlZNZSBSZXNlcnZhdGlvbiBSZXBvcnQgaGVscGVyLCB0aGVuIHBhcnNpbmcgdGhhdCBpbmZvIHRv
IGdldCB0aGUKPiBjb250cm9sbGVyJ3MgcmVnaXN0ZXJlZCBrZXlzLiBCZWNhdXNlIHRoZSBjYWxs
b3V0IGlzIG9ubHkgdXNlZCBpbiB0aGUKPiBrZXJuZWwgd2hlcmUgdGhlIGNhbGxlcnMsIGxpa2Ug
TElPLCBkbyBub3Qga25vdyBhYm91dCBjb250cm9sbGVyL2hvc3QgSURzLAo+IHRoZSBjYWxsb3V0
IGp1c3QgcmV0dXJucyB0aGUgcmVnaXN0ZXJlZCBrZXlzIHdoaWNoIGlzIHJlcXVpcmVkIGJ5IHRo
ZSBTQ1NJCj4gUFIgaW4gUkVBRCBLRVlTIGNvbW1hbmQuCj4gCj4gU2lnbmVkLW9mZi1ieTogTWlr
ZSBDaHJpc3RpZSA8bWljaGFlbC5jaHJpc3RpZUBvcmFjbGUuY29tPgo+IC0tLQo+ICAgZHJpdmVy
cy9udm1lL2hvc3QvcHIuYyB8IDY5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKwo+ICAgaW5jbHVkZS9saW51eC9udm1lLmggICB8ICA0ICsrKwo+ICAgMiBmaWxlcyBj
aGFuZ2VkLCA3MyBpbnNlcnRpb25zKCspCj4gClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2Ug
PGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAg
ICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBT
b2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAo
QUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBUb3RldiwgQW5kcmV3Ck15ZXJz
LCBBbmRyZXcgTWNEb25hbGQsIE1hcnRqZSBCb3VkaWVuIE1vZXJtYW4KCi0tCmRtLWRldmVsIG1h
aWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

