Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AE51C7619A
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 07:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681198318;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Vc19/B+1LNS7wMW3JJa7dDvLv/6WGYbqnw6ZmBkHpmg=;
	b=d9KtO0f7VbTr4HPxc5alVmO4X2ujPU5UAG/+I2BnrFe+52NT5O0Wgi8wSt3v+WRksPgY/9
	QiqClu0b7Fk5ahxczhBrxwZ4FElpN/GTNciZlHG7xKCd6d6/dRX8UR5wfBBkML/hU6EEqU
	RwzABRZQJUArWHS3kIYymgH7ytk2Lk0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-oLCHq6XtN7KwMOCVY4DDUQ-1; Tue, 11 Apr 2023 03:31:55 -0400
X-MC-Unique: oLCHq6XtN7KwMOCVY4DDUQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAEBF85C6E3;
	Tue, 11 Apr 2023 07:31:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A7FED2166B31;
	Tue, 11 Apr 2023 07:31:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 668271946588;
	Tue, 11 Apr 2023 07:31:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CE82E1946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 07:31:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8B0F240BC799; Tue, 11 Apr 2023 07:31:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 83D4F40BC798
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:31:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 685631C068CB
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:31:51 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-541-iJg-d95INAySn7uiQjOwag-1; Tue,
 11 Apr 2023 03:31:49 -0400
X-MC-Unique: iJg-d95INAySn7uiQjOwag-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 3FEAE1FE07;
 Tue, 11 Apr 2023 07:31:48 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D75D013638;
 Tue, 11 Apr 2023 07:31:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id aCIpM+MMNWSkZgAAMHmgww
 (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 07:31:47 +0000
Message-ID: <5152a029-c690-70a1-c9ba-161af9a8bf4d@suse.de>
Date: Tue, 11 Apr 2023 09:31:47 +0200
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
 <20230407200551.12660-17-michael.christie@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230407200551.12660-17-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v6 16/18] scsi: target: Pass struct
 target_opcode_descriptor to enabled
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNC83LzIzIDIyOjA1LCBNaWtlIENocmlzdGllIHdyb3RlOgo+IFRoZSBpYmxvY2sgcHJfb3Bz
IHN1cHBvcnQgZG9lcyBub3Qgc3VwcG9ydCBjb21tYW5kcyB0aGF0IHJlcXVpcmUgcG9ydCBvcgo+
IElfVCBOZXh1cyBpbmZvLiBUaGlzIGFkZHMgYSBzdHJ1Y3QgdGFyZ2V0X29wY29kZV9kZXNjcmlw
dG9yIGFzIGFuIGFyZ3VtZW50Cj4gdG8gdGhlIGVuYWJsZWQgY2FsbG91dCBzbyB3ZSBjYW4gc3Rp
bGwgaGF2ZSB0aGUgY29tbW9uIHRjbV9pc19wcl9lbmFibGVkCj4gYW5kIHRjbV9pc19zY3NpMl9y
ZXNlcnZhdGlvbnNfZW5hYmxlZCBmdW5jdGlvbnMgYW5kIGFsc28gZGV0ZXJtaW5lIGlmIHRoZQo+
IGNvbW1hbmQgaXMgc3VwcG9ydGVkIGJhc2VkIG9uIHRoZSBjb21tYW5kIGFuZCBzZXJ2aWNlIGFj
dGlvbiBhbmQgZGV2aWNlCj4gc2V0dGluZ3MuCj4gCj4gU2lnbmVkLW9mZi1ieTogTWlrZSBDaHJp
c3RpZSA8bWljaGFlbC5jaHJpc3RpZUBvcmFjbGUuY29tPgo+IC0tLQo+ICAgZHJpdmVycy90YXJn
ZXQvdGFyZ2V0X2NvcmVfc3BjLmMgIHwgNDAgKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0t
LQo+ICAgaW5jbHVkZS90YXJnZXQvdGFyZ2V0X2NvcmVfYmFzZS5oIHwgIDMgKystCj4gICAyIGZp
bGVzIGNoYW5nZWQsIDI3IGluc2VydGlvbnMoKyksIDE2IGRlbGV0aW9ucygtKQo+IApSZXZpZXdl
ZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0g
CkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0
ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQw
NTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5
IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBJ
dm8gVG90ZXYsIEFuZHJldwpNeWVycywgQW5kcmV3IE1jRG9uYWxkLCBNYXJ0amUgQm91ZGllbiBN
b2VybWFuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

