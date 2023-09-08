Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05299EE57CA
	for <dm-devel@archiver.kernel.org>; Fri,  8 Sep 2023 06:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694153809;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3SxC3HHVim0KysERiXOffE7uCQbhe1plRqAfxMoh98o=;
	b=BY/fuUeD1q4Jzsevk4OWosVRIEKaqqEbQ3TPY8n5lt6ScvOaxXA8f+8tZFl7m2CAV1p5s0
	p5cRaVs4sa3dpd8lI8h8vPdpH2lZZCnDqFcvPoaEJ3CM5LHzHjUXOEg9AUdDxYl9rTQedE
	8KktYML5Knh/hsFwQbziPciNGhn3R5Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-FXnYB3vrOYSy4GP61Uf2Hw-1; Fri, 08 Sep 2023 02:16:47 -0400
X-MC-Unique: FXnYB3vrOYSy4GP61Uf2Hw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 784DB101A529;
	Fri,  8 Sep 2023 06:16:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 63AC8D47819;
	Fri,  8 Sep 2023 06:16:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 174A9194658F;
	Fri,  8 Sep 2023 06:16:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 71128194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Sep 2023 06:16:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 35846C03295; Fri,  8 Sep 2023 06:16:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DC3AC03292
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 06:16:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C3813C108DD
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 06:16:44 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-362-gp59njH8OF2VnCu8wpGC_w-1; Fri,
 08 Sep 2023 02:16:42 -0400
X-MC-Unique: gp59njH8OF2VnCu8wpGC_w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id E7AD4218E7;
 Fri,  8 Sep 2023 06:16:40 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 616D0131FD;
 Fri,  8 Sep 2023 06:16:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id baswFki8+mQibgAAMHmgww
 (envelope-from <hare@suse.de>); Fri, 08 Sep 2023 06:16:40 +0000
Message-ID: <7bdf32f4-6fac-4ed4-a11f-b6dfe1c45177@suse.de>
Date: Fri, 8 Sep 2023 08:16:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
References: <20230906163844.18754-1-nj.shetty@samsung.com>
 <CGME20230906164434epcas5p16135fb4935a62519360ede42e137bbbb@epcas5p1.samsung.com>
 <20230906163844.18754-13-nj.shetty@samsung.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230906163844.18754-13-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v15 12/12] null_blk: add support for copy
 offload
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
Cc: Vincent Fu <vincent.fu@samsung.com>, martin.petersen@oracle.com,
 linux-doc@vger.kernel.org, gost.dev@samsung.com,
 Anuj Gupta <anuj20.g@samsung.com>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, mcgrof@kernel.org,
 linux-fsdevel@vger.kernel.org,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gOS82LzIzIDE4OjM4LCBOaXRlc2ggU2hldHR5IHdyb3RlOgo+IEltcGxlbWVudGF0aW9uIGlz
IGJhc2VkIG9uIGV4aXN0aW5nIHJlYWQgYW5kIHdyaXRlIGluZnJhc3RydWN0dXJlLgo+IGNvcHlf
bWF4X2J5dGVzOiBBIG5ldyBjb25maWdmcyBhbmQgbW9kdWxlIHBhcmFtZXRlciBpcyBpbnRyb2R1
Y2VkLCB3aGljaAo+IGNhbiBiZSB1c2VkIHRvIHNldCBoYXJkd2FyZS9kcml2ZXIgc3VwcG9ydGVk
IG1heGltdW0gY29weSBsaW1pdC4KPiBPbmx5IHJlcXVlc3QgYmFzZWQgcXVldWUgbW9kZSB3aWxs
IHN1cHBvcnQgZm9yIGNvcHkgb2ZmbG9hZC4KPiBBZGRlZCB0cmFjZWZzIHN1cHBvcnQgdG8gY29w
eSBJTyB0cmFjaW5nLgo+IAo+IFN1Z2dlc3RlZC1ieTogRGFtaWVuIExlIE1vYWwgPGRhbWllbi5s
ZW1vYWxAb3BlbnNvdXJjZS53ZGMuY29tPgo+IFNpZ25lZC1vZmYtYnk6IEFudWogR3VwdGEgPGFu
dWoyMC5nQHNhbXN1bmcuY29tPgo+IFNpZ25lZC1vZmYtYnk6IE5pdGVzaCBTaGV0dHkgPG5qLnNo
ZXR0eUBzYW1zdW5nLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBWaW5jZW50IEZ1IDx2aW5jZW50LmZ1
QHNhbXN1bmcuY29tPgo+IC0tLQo+ICAgRG9jdW1lbnRhdGlvbi9ibG9jay9udWxsX2Jsay5yc3Qg
IHwgIDUgKysKPiAgIGRyaXZlcnMvYmxvY2svbnVsbF9ibGsvbWFpbi5jICAgICB8IDk3ICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKy0KPiAgIGRyaXZlcnMvYmxvY2svbnVsbF9ibGsvbnVs
bF9ibGsuaCB8ICAxICsKPiAgIGRyaXZlcnMvYmxvY2svbnVsbF9ibGsvdHJhY2UuaCAgICB8IDIz
ICsrKysrKysrCj4gICA0IGZpbGVzIGNoYW5nZWQsIDEyMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0
aW9ucygtKQo+IApSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpD
aGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2Vy
bmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1h
eGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdl
c2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYsIEFuZHJldwpNeWVycywgQW5kcmV3IE1jRG9uYWxk
LCBNYXJ0amUgQm91ZGllbiBNb2VybWFuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsCg==

