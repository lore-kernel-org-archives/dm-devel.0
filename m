Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D327C61DA3
	for <dm-devel@archiver.kernel.org>; Fri, 24 Feb 2023 08:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677225800;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dx5OFKnxzxHnJjGQvRaWDO3uiIVeDisj7v4Rw4wS1UI=;
	b=Ah1eSiXQH0HnlWMo0SOHtszpTPQiw6W/2/MGlyc4VBnsZP8kF99tz6ZoCjljcZK6psSO/r
	BskG2IHmceYivVq9wyRk1Urj64Hp01298A0r5F9Qgl2tC3tn4Q3dYwp6Iq7Qwg4DaHGre4
	WPnznntykP4PfU+YYhorDSu+gpU5zdA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-iQ8H0VAOO2STnmMVy_S5bA-1; Fri, 24 Feb 2023 03:03:18 -0500
X-MC-Unique: iQ8H0VAOO2STnmMVy_S5bA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB0F6800B23;
	Fri, 24 Feb 2023 08:03:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 169F740C10FA;
	Fri, 24 Feb 2023 08:03:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D3FE719465B2;
	Fri, 24 Feb 2023 08:03:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BB1B619465B1
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Feb 2023 08:02:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0559B1415113; Fri, 24 Feb 2023 08:02:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F224B140EBF4
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 08:02:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8037518A6460
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 08:02:52 +0000 (UTC)
Received: from infra.glanzmann.de (infra.glanzmann.de [88.198.237.220]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-24MADvpBNbe1f6ZIr0ER8A-1; Fri, 24 Feb 2023 03:02:42 -0500
X-MC-Unique: 24MADvpBNbe1f6ZIr0ER8A-1
Received: by infra.glanzmann.de (Postfix, from userid 1000)
 id 476CA7A8007D; Fri, 24 Feb 2023 09:02:40 +0100 (CET)
Date: Fri, 24 Feb 2023 09:02:40 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Chris Hofstaedtler <zeha@debian.org>
Message-ID: <Y/hvIH9DB3Gr1EwQ@glanzmann.de>
References: <Y/YVZ61NB4aP0lHM@glanzmann.de>
 <20230223121857.kadue7dwoynayqni@zeha.at>
MIME-Version: 1.0
In-Reply-To: <20230223121857.kadue7dwoynayqni@zeha.at>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] NetAPP AFF A220 - Debian - multipathing setup
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
Cc: dm-devel@redhat.com, team+linux-blocks@tracker.debian.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGVsbG8gQ2hyaXMsCgo+IFBlciBtdWx0aXBhdGguY29uZig1KToKCj4gfCBzdHJpY3QgICAgQm90
aCBtdWx0aXBhdGggYW5kIG11bHRpcGF0aGQgdHJlYXQgb25seSBzdWNoIGRldmljZXMgYXMgbXVs
dGlwYXRoIGRldmljZXMgd2hpY2ggaGF2ZSBiZWVuCj4gfCAgICAgICAgICAgcGFydCBvZiBhIG11
bHRpcGF0aCBtYXAgcHJldmlvdXNseSwgYW5kIHdoaWNoIGFyZSAgdGhlcmVmb3JlICBsaXN0ZWQg
IGluICB0aGUgIHd3aWRzX2ZpbGUuCj4gfCAgICAgICAgICAgVXNlcnMgY2FuIG1hbnVhbGx5IHNl
dCB1cCBtdWx0aXBhdGggbWFwcyB1c2luZyB0aGUgbXVsdGlwYXRoZCBhZGQgbWFwIGNvbW1hbmQu
IE9uY2Ugc2V0IHVwCj4gfCAgICAgICAgICAgbWFudWFsbHksIHRoZSBtYXAgaXMgcmVtZW1iZXJl
ZCBpbiB0aGUgd3dpZHMgZmlsZSBhbmQgd2lsbCBiZSBzZXQgdXAgYXV0b21hdGljYWxseSBpbiAg
dGhlCj4gfCAgICAgICAgICAgZnV0dXJlLgoKSSB3YXNuJ3QgYXdhcmUgb2YgdGhhdC4gVGhhbmsg
eW91IGZvciBwb2ludGluZyBpdCBvdXQgYW5kIHJlc29sdmluZyBvdXIgaXNzdWUuCgo+IEkgd291
bGQgZ3Vlc3MgeW91ciB3d2lkcy9iaW5kaW5ncyBmaWxlcyBhcmUgZW1wdHksIGFuZCB0aHVzIHlv
dSBuZWVkIHRvCj4gZm9sbG93IHRoZSBhZHZpY2UgaW4gdGhlIG1hbnBhZ2U6IHVzZSBtdWx0aXBh
dGhkIGFkZCBtYXAsIG9yIG1heWJlCj4gbXVsdGlwYXRoIC1hLgoKWWVzLCB0aGF0IGhlbHBlZCwg
b25jZSBJIGV4ZWN1dGVkIHRoZSBmb2xsb3dpbmcgY29tbWFuZHMsIGl0IHdvcmtzOgoKKGxpdmUp
IFsvZXRjL211bHRpcGF0aF0gbHNibGsKTkFNRSAgIE1BSjpNSU4gUk0gICBTSVpFIFJPIFRZUEUg
TU9VTlRQT0lOVApzZGEgICAgICA4OjAgICAgMCAyMzguNUcgIDAgZGlzawpzZGIgICAgICA4OjE2
ICAgMSAgNTguOUcgIDAgZGlzawrilJzilIBzZGIxICAgODoxNyAgIDEgICA4NTVNICAwIHBhcnQK
4pSU4pSAc2RiMiAgIDg6MTggICAxICAgICA0TSAgMCBwYXJ0CnNkYyAgICAgIDg6MzIgICAwICAg
NzUwRyAgMCBkaXNrCnNkZCAgICAgIDg6NDggICAwICAgNzUwRyAgMCBkaXNrCnNyMCAgICAgMTE6
MCAgICAxICAxMDI0TSAgMCByb20KKGxpdmUpIFsvZXRjL211bHRpcGF0aF0gbXVsdGlwYXRoIC1h
IC9kZXYvc2RjCnd3aWQgJzM2MDBhMDk4MDM4MzE0MzY4NzIyNDU1NGI1NDcyNTk2YicgYWRkZWQK
KGxpdmUpIFsvZXRjL211bHRpcGF0aF0gbXVsdGlwYXRoIC1sCihsaXZlKSBbL2V0Yy9tdWx0aXBh
dGhdIGNhdCB3d2lkcwojIE11bHRpcGF0aCB3d2lkcywgVmVyc2lvbiA6IDEuMAojIE5PVEU6IFRo
aXMgZmlsZSBpcyBhdXRvbWF0aWNhbGx5IG1haW50YWluZWQgYnkgbXVsdGlwYXRoIGFuZCBtdWx0
aXBhdGhkLgojIFlvdSBzaG91bGQgbm90IG5lZWQgdG8gZWRpdCB0aGlzIGZpbGUgaW4gbm9ybWFs
IGNpcmN1bXN0YW5jZXMuCiMKIyBWYWxpZCBXV0lEczoKLzM2MDBhMDk4MDM4MzE0MzY4NzIyNDU1
NGI1NDcyNTk2Yi8KKGxpdmUpIFsvZXRjL211bHRpcGF0aF0gL2V0Yy9pbml0LmQvbXVsdGlwYXRo
LXRvb2xzIHJlc3RhcnQKUmVzdGFydGluZyBtdWx0aXBhdGgtdG9vbHMgKHZpYSBzeXN0ZW1jdGwp
OiBtdWx0aXBhdGgtdG9vbHMuc2VydmljZS4KKGxpdmUpIFsvZXRjL211bHRpcGF0aF0gbXVsdGlw
YXRoIC1sCjM2MDBhMDk4MDM4MzE0MzY4NzIyNDU1NGI1NDcyNTk2YiBkbS0wIE5FVEFQUCxMVU4g
Qy1Nb2RlCnNpemU9NzUwRyBmZWF0dXJlcz0nMyBxdWV1ZV9pZl9ub19wYXRoIHBnX2luaXRfcmV0
cmllcyA1MCcgaHdoYW5kbGVyPScxIGFsdWEnIHdwPXJ3CnwtKy0gcG9saWN5PSdzZXJ2aWNlLXRp
bWUgMCcgcHJpbz0wIHN0YXR1cz1hY3RpdmUKfCBgLSA3OjA6MDowIHNkYyA4OjMyIGFjdGl2ZSB1
bmRlZiBydW5uaW5nCmAtKy0gcG9saWN5PSdzZXJ2aWNlLXRpbWUgMCcgcHJpbz0wIHN0YXR1cz1l
bmFibGVkCiAgYC0gODowOjA6MCBzZGQgODo0OCBhY3RpdmUgdW5kZWYgcnVubmluZwoKQ2hlZXJz
LAoJVGhvbWFzCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpo
dHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

