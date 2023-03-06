Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 605B1C61DA4
	for <dm-devel@archiver.kernel.org>; Mon,  6 Mar 2023 11:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678103223;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jcNKwwWpkKEik820gDcDPR6jMBqzTmM6vw8lYxUbRWA=;
	b=RYF5UjAvpwiuVZzTRMFdRhltC3qq0t+mjgCW6GdCBAT9Vg0jUwglM5sV/u1/odUYc+G679
	WuSqaLDjg8J8isNlRtTPZwgGYpU3YNz5HYtpeGvPHl+vjLbE+0KJ5aadoI0WFCFsw345m/
	rDqdi9DOrco8+p0tyNnHYZYiIwLxD08=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-sr9iEZq5NcqIO0SiAiiYZA-1; Mon, 06 Mar 2023 06:47:00 -0500
X-MC-Unique: sr9iEZq5NcqIO0SiAiiYZA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DDB0811E9C;
	Mon,  6 Mar 2023 11:46:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8CDBC2166B26;
	Mon,  6 Mar 2023 11:46:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 00BA0194658C;
	Mon,  6 Mar 2023 11:46:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7F92D1946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Mar 2023 11:46:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4300A492B00; Mon,  6 Mar 2023 11:46:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BC96492C3E
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 11:46:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D5F0382C969
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 11:46:54 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-o6-Bg7GDP66sMXRQ5t118Q-1; Mon,
 06 Mar 2023 06:46:52 -0500
X-MC-Unique: o6-Bg7GDP66sMXRQ5t118Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 3FE1C22358;
 Mon,  6 Mar 2023 11:46:51 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 17D7E13513;
 Mon,  6 Mar 2023 11:46:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id AnE4BKvSBWTVJQAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 06 Mar 2023 11:46:51 +0000
Message-ID: <82cf76fe2b1949337064127eac3ca17c1082d0a7.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>
Date: Mon, 06 Mar 2023 12:46:50 +0100
In-Reply-To: <C9BF0F84-BA7F-432C-A9A7-DC77DFE856CA@purestorage.com>
References: <CAHZQxyJH1etLR5gHuWk4c6-ieioqA4GrJ173B60bnTppke58dw@mail.gmail.com>
 <4bc4be79c2d00cc959932ec935179a46be4b2fbc.camel@suse.com>
 <5A7BD289-0205-42FF-84CD-7C218511A280@purestorage.com>
 <fb99dac64dd41a6a44b3c7ce065608b45ff467c4.camel@suse.com>
 <C9BF0F84-BA7F-432C-A9A7-DC77DFE856CA@purestorage.com>
User-Agent: Evolution 3.46.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] [PATCH] libmultipath: return 'ghost' state
 when port is in transition
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgQnJpYW4sCgpPbiBTYXQsIDIwMjMtMDMtMDQgYXQgMTI6NDkgLTA4MDAsIEJyaWFuIEJ1bmtl
ciB3cm90ZToKPiA+IAo+IFRoZSBjaGVja2luZyBmb3Igc3RhbmRieSBpcyAxNCB5ZWFycyBvbGQs
IGFuZCBzYXlzIHRoYXQgVFVSIHJldHVybnMKPiBhIHVuaXQgYXR0ZW50aW9uIHdoZW4gdGhlIHBh
dGggaXMgaW4gc3RhbmRieS4gSSBhbSBub3Qgc3VyZSB3aHkgdGhhdAo+IHdvdWxkbuKAmXQgYmUg
aGFuZGxlZCBieSB0aGlzIGNvZGUgYWJvdmU6IEkgd291bGQgdGhpbmsgdGhlcmUgc2hvdWxkIGJl
Cj4ganVzdCBvbmUgdW5pdCBhdHRlbnRpb24gZm9yIGVhY2ggSV9UX0wgd2hlbiBhbiBBTFVBIHN0
YXRlIGNoYW5nZQo+IGhhcHBlbnMuTm90IHN1cmUgaG93IGl0IGV4Y2VlZHMgdGhlIHJldHJ5IGNv
dW50Lgo+IAo+IGlmIChrZXkgPT0gMHg2KSB7Cj4gwqDCoMKgIC8qIFVuaXQgQXR0ZW50aW9uLCBy
ZXRyeSAqLwo+IMKgwqDCoCBpZiAo4oCUcmV0cnlfdHVyKQo+IMKgwqDCoMKgwqDCoMKgIGdvdG8g
cmV0cnk7Cj4gfQo+IAo+IEZyb20gbXkgcGVyc3BlY3RpdmUgZmFpbGluZyBhIHBhdGggZm9yIEFM
VUEgc3RhdGUgc3RhbmRieSBpcwo+IHJlYXNvbmFibGUKPiBzaW5jZSBpdCBpcyBub3QgYW4gYWN0
aXZlIHN0YXRlLgoKSSB0aGluayB0aGUgaGlzdG9yaWMgcmF0aW9uYWxlIGZvciB1c2luZyBHSE9T
VCBpcyB0aGF0IHNvbWUgc3RvcmFnZQphcnJheXMsIGluIHBhcnRpY3VsYXIgYWN0aXZlLXBhc3Np
dmUgY29uZmlndXJhdGlvbnMsIG1heSBrZWVwIGNlcnRhaW4KcG9ydCBncm91cHMgaW4gU1RBTkRC
WSBzdGF0ZS4gSWYgU1RBTkRCWSB3YXMgY2xhc3NpZmllZCBhcyBGQUlMRUQsCiJtdWx0aXBhdGgg
LWxsIiB3b3VsZCBzaG93IGFsbCBwYXRocyBvZiBzdWNoIHBvcnQgZ3JvdXBzIGFzIEZBSUxFRCwK
d2hpY2ggd291bGQgY29uZnVzZSB1c2Vycy4KClRoYXQncyB3aGF0IEkgbWVhbnQgYmVmb3JlLCBt
dWx0aXBhdGgncyBHSE9TVCBjYW4gbWVhbiBtdWx0aXBsZSB0aGluZ3MKZGVwZW5kaW5nIG9uIHRo
ZSBhY3R1YWwgaGFyZHdhcmUgaW4gdXNlLCBleHBsaWNpdC9pbXBsaWNpdCBBTFVBLCBldGMuCkdp
dmVuIHRoYXQgdG9kYXkgYmFzaWNhbGx5IGV2ZXJ5IGhhcmR3YXJlIHN1cHBvcnRzIEFMVUEsIHdl
IGNvdWxkCnByb2JhYmx5IGRvIGJldHRlci4gQnV0IGNoYW5naW5nIHRoZSBzZW1hbnRpY3MgaW4g
dGhlIGN1cnJlbnQgc2l0dWF0aW9uCmlzIHJpc2t5IGFuZCBlcnJvciBwcm9uZS4KClJlZ2FyZHMK
TWFydGluCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

