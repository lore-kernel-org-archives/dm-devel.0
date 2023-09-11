Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B1FFEE7FF4
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 07:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694418331;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Yp43rAaJkgqm9X6xEIQkp6PJe5Vymb3+H1gaIhpHdFw=;
	b=RY2+UISg6t06XK9dELF869MfiZRsOtaG5hushx4JB3wfk7awaUDCWnsMHOkNIuUIScB/yc
	OL34hUU/xGulYRRYHw97mgDwfpVrbNwgbHb4s7HCoEm61EagoTm1L9l15wggukv0nLHRFH
	cosmGeH7LrYBvw3fW3A3gaqXCHeaQLg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325--C-NqFmCO8-rM1wQi8P9hw-1; Mon, 11 Sep 2023 03:45:28 -0400
X-MC-Unique: -C-NqFmCO8-rM1wQi8P9hw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 904688F40C2;
	Mon, 11 Sep 2023 07:45:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 28A7A215670B;
	Mon, 11 Sep 2023 07:45:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E07B31946597;
	Mon, 11 Sep 2023 07:45:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DAA551946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 07:45:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A013340C2064; Mon, 11 Sep 2023 07:45:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9959D40C2009
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 07:45:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C39C8A2D07
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 07:45:24 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-606-JCCEay0tMca0NO_YQ6FAlQ-1; Mon,
 11 Sep 2023 03:45:21 -0400
X-MC-Unique: JCCEay0tMca0NO_YQ6FAlQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 4788D218DF;
 Mon, 11 Sep 2023 07:45:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DF5C9139CC;
 Mon, 11 Sep 2023 07:45:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id mrbHNY/F/mTKbAAAMHmgww
 (envelope-from <hare@suse.de>); Mon, 11 Sep 2023 07:45:19 +0000
Message-ID: <19be4f1f-dc2a-47e7-a7d0-94f3a18778d3@suse.de>
Date: Mon, 11 Sep 2023 09:45:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <20230906163844.18754-1-nj.shetty@samsung.com>
 <CGME20230906164407epcas5p3f9e9f33e15d7648fd1381cdfb97d11f2@epcas5p3.samsung.com>
 <20230906163844.18754-10-nj.shetty@samsung.com>
 <cb767dc9-1732-4e31-bcc6-51c187750d66@suse.de>
 <20230911070724.GA28177@green245>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230911070724.GA28177@green245>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v15 09/12] dm: Add support for copy offload
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
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 martin.petersen@oracle.com, Jonathan Corbet <corbet@lwn.net>,
 gost.dev@samsung.com, linux-doc@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, mcgrof@kernel.org,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gOS8xMS8yMyAwOTowNywgTml0ZXNoIFNoZXR0eSB3cm90ZToKPiBPbiBGcmksIFNlcCAwOCwg
MjAyMyBhdCAwODoxMzozN0FNICswMjAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6Cj4+IE9uIDkv
Ni8yMyAxODozOCwgTml0ZXNoIFNoZXR0eSB3cm90ZToKPj4+IEJlZm9yZSBlbmFibGluZyBjb3B5
IGZvciBkbSB0YXJnZXQsIGNoZWNrIGlmIHVuZGVybHlpbmcgZGV2aWNlcyBhbmQKPj4+IGRtIHRh
cmdldCBzdXBwb3J0IGNvcHkuIEF2b2lkIHNwbGl0IGhhcHBlbmluZyBpbnNpZGUgZG0gdGFyZ2V0
Lgo+Pj4gRmFpbCBlYXJseSBpZiB0aGUgcmVxdWVzdCBuZWVkcyBzcGxpdCwgY3VycmVudGx5IHNw
bGl0dGluZyBjb3B5Cj4+PiByZXF1ZXN0IGlzIG5vdCBzdXBwb3J0ZWQuCj4+Pgo+PiBBbmQgaGVy
ZSBpcyB3aGVyZSBJIHdvdWxkIGhhdmUgZXhwZWN0ZWQgdGhlIGVtdWxhdGlvbiB0byB0YWtlIHBs
YWNlOwo+PiBkaWRuJ3QgeW91IGhhdmUgaXQgaW4gb25lIG9mIHRoZSBlYXJsaWVyIGl0ZXJhdGlv
bnM/Cj4gCj4gTm8sIGJ1dCBpdCB3YXMgdGhlIG90aGVyIHdheSByb3VuZC4KPiBJbiBkbS1rY29w
eWQgd2UgdXNlZCBkZXZpY2Ugb2ZmbG9hZCwgaWYgdGhhdCB3YXMgcG9zc2libGUsIGJlZm9yZSB1
c2luZyBkZWZhdWx0Cj4gZG0tbWFwcGVyIGNvcHkuIEl0IHdhcyBkcm9wcGVkIGluIHRoZSBjdXJy
ZW50IHNlcmllcywKPiB0byBzdHJlYW1saW5lIHRoZSBwYXRjaGVzIGFuZCBtYWtlIHRoZSBzZXJp
ZXMgZWFzaWVyIHRvIHJldmlldy4KPiAKPj4gQWZ0ZXIgYWxsLCBkZXZpY2UtbWFwcGVyIGFscmVh
ZHkgaGFzIHRoZSBpbmZyYXN0cnVjdHVyZSBmb3IgY29weWluZwo+PiBkYXRhIGJldHdlZW4gZGV2
aWNlcywgc28gYWRkaW5nIGEgY29weS1vZmZsb2FkIGVtdWxhdGlvbiBmb3IgZGV2aWNlLW1hcHBl
cgo+PiBzaG91bGQgYmUgdHJpdmlhbC4KPiBJIGRpZCBub3QgdW5kZXJzdGFuZCB0aGlzLCBjYW4g
eW91IHBsZWFzZSBlbGFib3JhdGUgPwo+IApQbGVhc2Ugc2VlIG15IGNvbW1lbnRzIHRvIHBhdGNo
IDA0LgpXZSBzaG91bGQgb25seSBpbXBsZW1lbnQgY29weS1vZmZsb2FkIGlmIHRoZXJlIGlzIGEg
ZGVkaWNhdGVkIAppbmZyYXN0cnVjdHVyZSBpbiBwbGFjZS4gQnV0IHdlIHNob3VsZCBub3QgaGF2
ZSBhICdnZW5lcmljJyBjb3B5LW9mZmxvYWQgCmVtdWxhdGlvbi4KUHJvYmxlbSBpcyB0aGF0ICdy
ZWFsJyBjb3B5LW9mZmxvYWQgZnVuY3Rpb25hbGl0aWVzIChpZSBmb3IgTlZNZSBvciAKU0NTSSkg
YXJlIHJpZGRsZWQgd2l0aCBjb3JuZXItY2FzZXMgd2hlcmUgY29weS1vZmZsb2FkIGRvZXMgX25v
dF8gd29yaywKYW5kIHdoZXJlIGNvbW1hbmRzIG1pZ2h0IGZhaWwgaWYgcGFydGljdWxhciBjb25k
aXRpb25zIGFyZSBub3QgbWV0LgpGYWxsaW5nIGJhY2sgdG8gYSBnZW5lcmljIGltcGxlbWVudGF0
aW9uIHdpbGwgY2F1c2UgYXBwbGljYXRpb25zIHRvIAphc3N1bWUgdGhhdCBjb3B5LW9mZmxvYWQg
d29ya2VkLCBhbmQgdGhhdCBpdCBnYWluZWQgcGVyZm9ybWFuY2UgYXMKdGhlIGFwcGxpY2F0aW9u
IGp1c3QgaGFkIHRvIGlzc3VlIGEgc2luZ2xlIGNvbW1hbmQuCldoZXJlYXMgaW4gZmFjdCB0aGUg
b3Bwb3NpdGUgaXMgdHJ1ZTsgaXQgd2Fzbid0IGEgc2luZ2xlIGNvbW1hbmQsIGFuZCAKdGhlIGFw
cGxpY2F0aW9uIG1pZ2h0IGhhdmUgcGVyZm9ybWVkIGJldHRlciBieSBpc3N1aW5nIHRoZSBjb21t
YW5kcwppdHNlbGYuClJldHVybmluZyAtRU9QTk9UU1VQUCBpbiB0aGVzZSBjYXNlcyB3aWxsIGlu
Zm9ybSB0aGUgYXBwbGljYXRpb24gdGhhdCAKdGhlIGF0dGVtcHQgZGlkbid0IHdvcmssIGFuZCB0
aGF0IGl0IHdpbGwgaGF2ZSB0byBmYWxsIGJhY2sgdG8gdGhlCidub3JtYWwnIGNvcHkuCgpDaGVl
cnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVs
IFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZl
bGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2No
w6RmdHNmw7xocmVyOiBJdm8gVG90ZXYsIEFuZHJldwpNeWVycywgQW5kcmV3IE1jRG9uYWxkLCBN
YXJ0amUgQm91ZGllbiBNb2VybWFuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxA
cmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsCg==

