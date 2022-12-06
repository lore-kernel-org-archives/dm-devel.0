Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFC31C352A1
	for <dm-devel@archiver.kernel.org>; Tue,  6 Dec 2022 14:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670338369;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/RS3OPAhMv9GrcQ7+Wkv8P0h1AuNMV/Ic6m8HgHFgAE=;
	b=bDQwdwgo+PpCaL2VhLySV3JhC1DK9HpLLPeOyVHatfphkLBj3JWAd+dokTpnAeBEuUikIP
	VXBQkqTBSOyDpKSZefLsQ3ff7zFtJtit0Hs5x77CAFprut1eZm0yENn59+sa+OuY8BhEzT
	sNH80zOXifeZIy0x1zMbGS3S6iILzkE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-QEdV9jH2P9yYCeNGSijDGA-1; Tue, 06 Dec 2022 09:52:40 -0500
X-MC-Unique: QEdV9jH2P9yYCeNGSijDGA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A627B186E392;
	Tue,  6 Dec 2022 14:51:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9343AC15BA4;
	Tue,  6 Dec 2022 14:51:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6F507194658C;
	Tue,  6 Dec 2022 14:51:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 222FB1946589
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Dec 2022 14:51:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F32D340C6F9F; Tue,  6 Dec 2022 14:51:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E969440C6EC4
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 14:51:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAD84381A72C
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 14:51:36 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-649-jBL2eac8NiCkzEnTkKtFJg-1; Tue,
 06 Dec 2022 09:51:34 -0500
X-MC-Unique: jBL2eac8NiCkzEnTkKtFJg-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 9267F1FE36;
 Tue,  6 Dec 2022 14:51:33 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 6B12F132F3;
 Tue,  6 Dec 2022 14:51:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap1.suse-dmz.suse.de with ESMTPSA id 4f0yDfNWj2PiMQAAGKfGzw
 (envelope-from <colyli@suse.de>); Tue, 06 Dec 2022 14:51:31 +0000
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
From: Coly Li <colyli@suse.de>
In-Reply-To: <20221206144902.GA31845@lst.de>
Date: Tue, 6 Dec 2022 22:51:17 +0800
Message-Id: <51D61E7A-055D-4F6F-AC4C-748D7E0C5E12@suse.de>
References: <20221206144057.720846-1-hch@lst.de>
 <434E4CE3-EA46-4CD9-9EAF-5C1B99B8A603@suse.de>
 <20221206144902.GA31845@lst.de>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] block: remove bio_set_op_attrs
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>,
 snitzer@kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Cgo+IDIwMjLlubQxMuaciDbml6UgMjI6NDnvvIxDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5k
ZT4g5YaZ6YGT77yaCj4gCj4gT24gVHVlLCBEZWMgMDYsIDIwMjIgYXQgMTA6NDY6MzFQTSArMDgw
MCwgQ29seSBMaSB3cm90ZToKPj4gQlRXLCBtYXkgSSBhc2sgd2h5IGJpb19zZXRfb3BfYXR0cnMo
KSBpcyByZW1vdmVkLiBRdWl0ZSBsb25nIHRpbWUgYWdvIGl0IHdhcyBhZGRlZCB0byBhdm9pZCBv
cGVuIGNvZGUsIGFuZCBub3cgd2UgcmVtb3ZlIGl0IHRvIHVzZSBvcGVuIGNvZGVkIGFzc2lnbm1l
bnRzLiBXaGF0IGlzIHRoZSBtb3RpdmF0aW9uIGZvciBub3c/Cj4gCj4gSXQgd2FzIGFkZGVkIHdo
ZW4gdGhlIGZsYWdzIGVuY29kaW5nIHdhcyBhIG1lc3MuICBOb3cgdGhhdCB0aGUgUlFGXwo+IGZs
YWdzIGFyZSBzcGxpdCBvdXQgdGhpbmdzIGhhdmUgYmVjb21lIG11Y2ggc2ltcGxlciBhbmQgd2Ug
ZG9uJ3QgbmVlZAo+IHRvIGhpZGUgYSBzaW1wbGUgYXNzaWdubWVudCBvZiBhIHZhbHVlIHRvIGEg
ZmllbGQuCgpJIHNlZS4gVGhhbmtzIGZvciBkb2luZyB0aGlzLgoKQ29seSBMaQoKLS0KZG0tZGV2
ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

