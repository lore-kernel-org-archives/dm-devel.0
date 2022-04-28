Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9058BC4332F
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:23:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-xl0-fllENFOIyfmApDzEMg-1; Fri, 29 Apr 2022 04:23:54 -0400
X-MC-Unique: xl0-fllENFOIyfmApDzEMg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D20FF185A7A4;
	Fri, 29 Apr 2022 08:23:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BFCCA1468942;
	Fri, 29 Apr 2022 08:23:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5B8321947069;
	Fri, 29 Apr 2022 08:23:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9CD601947046
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Apr 2022 06:54:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 72F0840F9D6B; Thu, 28 Apr 2022 06:54:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6EA3840F9D68
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 06:54:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 568AD85A5A8
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 06:54:31 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-sDxaOzodP4ipNRGU5v6pDQ-1; Thu, 28 Apr 2022 02:54:29 -0400
X-MC-Unique: sDxaOzodP4ipNRGU5v6pDQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 80B90210EE;
 Thu, 28 Apr 2022 06:54:27 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6D7E313A8C;
 Thu, 28 Apr 2022 06:54:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id UAizGSM6amLtWQAAMHmgww
 (envelope-from <mliska@suse.cz>); Thu, 28 Apr 2022 06:54:27 +0000
Message-ID: <568d96f5-470d-8d46-cfb7-10411cde3e9f@suse.cz>
Date: Thu, 28 Apr 2022 08:54:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
References: <ecddb51d-7666-b18b-f295-58fc0397b4c7@suse.cz>
 <b002e110e01345eaee7ad46187fa2b1980faa275.camel@suse.com>
From: =?UTF-8?Q?Martin_Li=c5=a1ka?= <mliska@suse.cz>
In-Reply-To: <b002e110e01345eaee7ad46187fa2b1980faa275.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: Re: [dm-devel] [PATCH][V2] Fix possibility to redefine
 -D_FORTIFY_SOURCE macro.
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8xMi8yMiAyMjoyNCwgTWFydGluIFdpbGNrIHdyb3RlOgo+IE9uIFR1ZSwgMjAyMi0wNC0x
MiBhdCAxMzoxOSArMDIwMCwgTWFydGluIExpxaFrYSB3cm90ZToKPj4gQXMgZXhwbGFpbmVkIGhl
cmU6Cj4+IGh0dHBzOi8vZ2l0aHViLmNvbS9vcGVuc3ZjL211bHRpcGF0aC10b29scy9pc3N1ZXMv
MjkKPj4KPj4gdXNpbmcgLVdwLC1EX0ZPUlRJRllfU09VUkNFIGNhbm5vdCBiZSByZWRlZmluZWQg
d2l0aAo+PiAtVV9GT1JUSUZZX1NPVVJDRSAtRF9GT1JUSUZZX1NPVVJDRT0zLgo+Pgo+PiBTaWdu
ZWQtb2ZmLWJ5OiBNYXJ0aW4gTGlza2EgPG1saXNrYUBzdXNlLmN6Pgo+IAo+IFJldmlld2VkLWJ5
OiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KPiAKPiAKCkhpLgoKTWF5IEkgcGxlYXNl
IHBpbmcgdGhpcz8KClRoYW5rcywKTWFydGluCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsCg==

