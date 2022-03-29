Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DCCCC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 29 Mar 2022 05:46:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-_LQGb0vTPJmFRQhvXtE0qA-1; Tue, 29 Mar 2022 01:45:56 -0400
X-MC-Unique: _LQGb0vTPJmFRQhvXtE0qA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EAC1899ED4;
	Tue, 29 Mar 2022 05:45:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 20EC92166B3F;
	Tue, 29 Mar 2022 05:45:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B7B211940345;
	Tue, 29 Mar 2022 05:45:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A7E331940342
 for <dm-devel@listman.corp.redhat.com>; Tue, 29 Mar 2022 05:45:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6C8652166B4D; Tue, 29 Mar 2022 05:45:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 686292166B3F
 for <dm-devel@redhat.com>; Tue, 29 Mar 2022 05:45:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA926811E90
 for <dm-devel@redhat.com>; Tue, 29 Mar 2022 05:45:27 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-ikfryRWyP3W2_wuIuFItUw-1; Tue, 29 Mar 2022 01:45:24 -0400
X-MC-Unique: ikfryRWyP3W2_wuIuFItUw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 3030B1F38C
 for <dm-devel@redhat.com>; Tue, 29 Mar 2022 05:45:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 231D013A91
 for <dm-devel@redhat.com>; Tue, 29 Mar 2022 05:45:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id uYf6N/KcQmI2agAAMHmgww
 (envelope-from <hare@suse.de>)
 for <dm-devel@redhat.com>; Tue, 29 Mar 2022 05:45:22 +0000
Message-ID: <2b0b3390-ff91-d9fe-7313-2edf9b2ffebb@suse.de>
Date: Tue, 29 Mar 2022 07:45:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To: dm-devel@redhat.com
References: <alpine.LRH.2.02.2203281232060.11240@file01.intranet.prod.int.rdu2.redhat.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <alpine.LRH.2.02.2203281232060.11240@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH] dm: fix race condition on Alpha
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMy8yOC8yMiAxODozNCwgTWlrdWxhcyBQYXRvY2thIHdyb3RlOgo+IEVhcmx5IGFscGhhIHBy
b2Nlc3NvcnMgY2Fubm90IHdyaXRlIGEgc2luZ2xlIGJ5dGUgb3Igc2hvcnQ7IHRoZXkgcmVhZCA4
Cj4gYnl0ZXMsIG1vZGlmeSB0aGUgdmFsdWUgaW4gcmVnaXN0ZXJzIGFuZCB3cml0ZSBiYWNrIDgg
Ynl0ZXMuCj4gCj4gVGhpcyBjb3VsZCBjYXVzZSByYWNlIGNvbmRpdGlvbiBpbiB0aGUgc3RydWN0
dXJlIGRtX2lvIC0gaWYgdGhlIGZpZWxkcwo+IGZsYWdzIGFuZCBpb19jb3VudCBhcmUgbW9kaWZp
ZWQgc2ltdWx0YW5lb3VzbHkuCj4gCj4gRml4IHRoaXMgYnVnIGJ5IHVzaW5nIDMyLWJpdCBmbGFn
cyBpZiB3ZSBhcmUgb24gQWxwaGEgYW5kIGlmIHdlIGFyZQo+IGNvbXBpbGluZyBmb3IgYSBwcm9j
ZXNzb3IgdGhhdCBkb2Vzbid0IGhhdmUgdGhlIGJ5dGUtd29yZC1leHRlbnNpb24uCj4gCkVycm0u
CgpTZWVpbmcgdGhhdCB0aG9zZSBhbHBoYXMgY291bGQgb25seSBtb2RpZnkgNjQgYml0IGF0b21p
Y2FsbHksIHdoYXQgCmV4YWN0bHkgZG8geW91IGdhaW4gYnkgdXNpbmcgMzItYml0IGZsYWdzPwpT
aG91bGRuJ3QgeW91IGJlIHVzaW5nIDY0LWJpdCBmbGFncz8KCkNoZWVycywKCkhhbm5lcwotLSAK
RHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRl
Y3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1
MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkg
TsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEZl
bGl4IEltZW5kw7ZyZmZlcgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bAo=

