Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9CF2EE57CA
	for <dm-devel@archiver.kernel.org>; Fri,  8 Sep 2023 06:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694153392;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kczi2Xz6rwU09vTd/y/3mUitmUsFuHSQD+RukObqw0Y=;
	b=jIFuVniT0Bp+nTcc5zbLYE9QrzGih4CcznkJfrP1F8vOfeI3WcoK5x5ixcN3huEUn95dJf
	PBs8va3XLn5tOMXc8752puT/MFbfQFc+1jcpC9gQIfSoMREU47a/ivfvBx841tCAOjk81C
	tmofp/8pjXduplHBrTQpG1BddBdqi1M=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-yBGM-_xCNtK4P3j-nxvT3w-1; Fri, 08 Sep 2023 02:09:48 -0400
X-MC-Unique: yBGM-_xCNtK4P3j-nxvT3w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28B7138157BB;
	Fri,  8 Sep 2023 06:09:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 16D5E21EE566;
	Fri,  8 Sep 2023 06:09:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C67AB194658F;
	Fri,  8 Sep 2023 06:09:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9004D194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Sep 2023 06:09:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6AEED2026D2B; Fri,  8 Sep 2023 06:09:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 62CE82026D76
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 06:09:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45C90280FED1
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 06:09:45 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-308-ihy7Wu_wOOeECcuor5ZqSA-1; Fri,
 08 Sep 2023 02:09:42 -0400
X-MC-Unique: ihy7Wu_wOOeECcuor5ZqSA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id E15C1218EC;
 Fri,  8 Sep 2023 06:09:40 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6E6A9131FD;
 Fri,  8 Sep 2023 06:09:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 2GXfGaS6+mQYaQAAMHmgww
 (envelope-from <hare@suse.de>); Fri, 08 Sep 2023 06:09:40 +0000
Message-ID: <2b568b29-c4f4-4058-9a83-b1f37290ae34@suse.de>
Date: Fri, 8 Sep 2023 08:09:40 +0200
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
 <CGME20230906164350epcas5p3f9b8bca1a2cb4d452e5c893cd3222418@epcas5p3.samsung.com>
 <20230906163844.18754-8-nj.shetty@samsung.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230906163844.18754-8-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v15 07/12] nvme: add copy offload support
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
Cc: martin.petersen@oracle.com, Kanchan Joshi <joshi.k@samsung.com>,
 linux-doc@vger.kernel.org, gost.dev@samsung.com,
 Anuj Gupta <anuj20.g@samsung.com>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, mcgrof@kernel.org,
 linux-fsdevel@vger.kernel.org,
 =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier.gonz@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gOS82LzIzIDE4OjM4LCBOaXRlc2ggU2hldHR5IHdyb3RlOgo+IEN1cnJlbnQgZGVzaWduIG9u
bHkgc3VwcG9ydHMgc2luZ2xlIHNvdXJjZSByYW5nZS4KPiBXZSByZWNlaXZlIGEgcmVxdWVzdCB3
aXRoIFJFUV9PUF9DT1BZX1NSQy4KPiBQYXJzZSB0aGlzIHJlcXVlc3Qgd2hpY2ggY29uc2lzdHMg
b2Ygc3JjKDFzdCkgYW5kIGRzdCgybmQpIGJpb3MuCj4gRm9ybSBhIGNvcHkgY29tbWFuZCAoVFAg
NDA2NSkKPiAKPiB0cmFjZSBldmVudCBzdXBwb3J0IGZvciBudm1lX2NvcHlfY21kLgo+IFNldCB0
aGUgZGV2aWNlIGNvcHkgbGltaXRzIHRvIHF1ZXVlIGxpbWl0cy4KPiAKPiBTaWduZWQtb2ZmLWJ5
OiBLYW5jaGFuIEpvc2hpIDxqb3NoaS5rQHNhbXN1bmcuY29tPgo+IFNpZ25lZC1vZmYtYnk6IE5p
dGVzaCBTaGV0dHkgPG5qLnNoZXR0eUBzYW1zdW5nLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBKYXZp
ZXIgR29uesOhbGV6IDxqYXZpZXIuZ29uekBzYW1zdW5nLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBB
bnVqIEd1cHRhIDxhbnVqMjAuZ0BzYW1zdW5nLmNvbT4KPiAtLS0KPiAgIGRyaXZlcnMvbnZtZS9o
b3N0L2NvbnN0YW50cy5jIHwgIDEgKwo+ICAgZHJpdmVycy9udm1lL2hvc3QvY29yZS5jICAgICAg
fCA3OSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+ICAgZHJpdmVycy9udm1l
L2hvc3QvdHJhY2UuYyAgICAgfCAxOSArKysrKysrKysKPiAgIGluY2x1ZGUvbGludXgvYmxrZGV2
LmggICAgICAgIHwgIDEgKwo+ICAgaW5jbHVkZS9saW51eC9udm1lLmggICAgICAgICAgfCA0MyAr
KysrKysrKysrKysrKysrKy0tCj4gICA1IGZpbGVzIGNoYW5nZWQsIDE0MCBpbnNlcnRpb25zKCsp
LCAzIGRlbGV0aW9ucygtKQo+IApSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1
c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAg
ICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25z
IEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJu
YmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYsIEFuZHJldwpNeWVycywgQW5kcmV3
IE1jRG9uYWxkLCBNYXJ0amUgQm91ZGllbiBNb2VybWFuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxp
c3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVsCg==

