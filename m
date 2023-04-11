Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADF48C7619A
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 07:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681197088;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2a7naxB+fnvIR2IlyZDjkgJfIv4KzJyIBxpTh8yc590=;
	b=FBH3HswiqdWdLY/yyqJZKea2H4/GMlSxwbNLPBk/7FbVBEFSKiATVPbmHEmXKUywPxWGej
	vsbj8YXVhu8myct1V8RtP+lD52uuo5eleAlFP79xlOik/mdMxy4ZczKBvwbpiE2TRp1BUy
	+/wpvhjO4672bDxPUzpPgBMAPklJafE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-I2ia2VHtOd6qp5dWDwG9Zg-1; Tue, 11 Apr 2023 03:11:25 -0400
X-MC-Unique: I2ia2VHtOd6qp5dWDwG9Zg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B3E729ABA1C;
	Tue, 11 Apr 2023 07:11:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 59E221121320;
	Tue, 11 Apr 2023 07:11:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AA7C81946A41;
	Tue, 11 Apr 2023 07:11:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DBE0D1946A42
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 07:11:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C6C731121339; Tue, 11 Apr 2023 07:11:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BF85A1121333
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:11:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A19823C0F196
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:11:07 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-101-D_ZKDWmEP3Kr6B-I5uZzOw-1; Tue,
 11 Apr 2023 03:11:06 -0400
X-MC-Unique: D_ZKDWmEP3Kr6B-I5uZzOw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id D86A81FDFF;
 Tue, 11 Apr 2023 07:11:04 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8B99B13519;
 Tue, 11 Apr 2023 07:11:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 03L2IAgINWQMXAAAMHmgww
 (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 07:11:04 +0000
Message-ID: <512a6380-6bc4-b49f-37d7-32fb7e7aa478@suse.de>
Date: Tue, 11 Apr 2023 09:11:04 +0200
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
 <20230407200551.12660-5-michael.christie@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230407200551.12660-5-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v6 04/18] scsi: Move sd_pr_type to scsi_common
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
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNC83LzIzIDIyOjA1LCBNaWtlIENocmlzdGllIHdyb3RlOgo+IExJTyBpcyBnb2luZyB0byB3
YW50IHRvIGRvIHRoZSBzYW1lIGJsb2NrIHRvL2Zyb20gU0NTSSBwciB0eXBlcyBhcyBzZC5jCj4g
c28gdGhpcyBtb3ZlcyB0aGUgc2RfcHJfdHlwZSBoZWxwZXIgdG8gc2NzaV9jb21tb24gYW5kIHJl
bmFtZXMgaXQuIFRoZQo+IG5leHQgcGF0Y2ggd2lsbCB0aGVuIGFsc28gYWRkIGEgaGVscGVyIHRv
IGdvIGZyb20gdGhlIFNDU0kgdmFsdWUgdG8gdGhlCj4gYmxvY2sgb25lIGZvciB1c2Ugd2l0aCBQ
RVJTSVNURU5UX1JFU0VSVkVfSU4gY29tbWFuZHMuCj4gCj4gU2lnbmVkLW9mZi1ieTogTWlrZSBD
aHJpc3RpZSA8bWljaGFlbC5jaHJpc3RpZUBvcmFjbGUuY29tPgo+IFJldmlld2VkLWJ5OiBDaHJp
c3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KPiBSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGth
cm5pIDxrY2hAbnZpZGlhLmNvbT4KPiAtLS0KPiAgIGRyaXZlcnMvc2NzaS9zY3NpX2NvbW1vbi5j
IHwgMjIgKysrKysrKysrKysrKysrKysrKysrKwo+ICAgZHJpdmVycy9zY3NpL3NkLmMgICAgICAg
ICAgfCAzMyArKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KPiAgIGluY2x1ZGUvc2Nz
aS9zY3NpX2NvbW1vbi5oIHwgMTIgKysrKysrKysrKysrCj4gICAzIGZpbGVzIGNoYW5nZWQsIDQy
IGluc2VydGlvbnMoKyksIDI1IGRlbGV0aW9ucygtKQo+IApSZXZpZXdlZC1ieTogSGFubmVzIFJl
aW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVp
bmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5k
ZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29m
dHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIg
MzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYsIEFuZHJl
dwpNeWVycywgQW5kcmV3IE1jRG9uYWxkLCBNYXJ0amUgQm91ZGllbiBNb2VybWFuCgotLQpkbS1k
ZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

