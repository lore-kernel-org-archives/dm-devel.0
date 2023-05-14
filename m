Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C39C6C77B7D
	for <dm-devel@archiver.kernel.org>; Sun, 14 May 2023 11:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684063154;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JlCpcK9CG1NLznUkA/BM94SngNBn/W/nUfMht+DtUh8=;
	b=Ya38olJcINT806zvUS/iFiPgr/U6G0QtO3//9LqZHd3WBTh71HpdwKJVUwDnqziYDqxXs8
	kD4fkUTD6hWm+Ibazr1UV2FO3fznlNbc38iqdqsHbDSBumDoDI92IB093UixHlLVSZB4Qv
	NTOBeYe4BaOSkuKsjJt7qobi45quD6o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-sydGAqLmO-SX95NjLY4BZw-1; Sun, 14 May 2023 07:19:11 -0400
X-MC-Unique: sydGAqLmO-SX95NjLY4BZw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87E6F1C0336F;
	Sun, 14 May 2023 11:19:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BA86663F84;
	Sun, 14 May 2023 11:19:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6413B1946595;
	Sun, 14 May 2023 11:19:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8A342194658C
 for <dm-devel@listman.corp.redhat.com>; Sun, 14 May 2023 11:19:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6CF8D2166B2A; Sun, 14 May 2023 11:19:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 631592166B32
 for <dm-devel@redhat.com>; Sun, 14 May 2023 11:19:04 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BA453C0F23C
 for <dm-devel@redhat.com>; Sun, 14 May 2023 11:19:04 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-148-Zoj_dFjrMZ2UsPWdpsa_dA-1; Sun,
 14 May 2023 07:19:02 -0400
X-MC-Unique: Zoj_dFjrMZ2UsPWdpsa_dA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id C7FC622018;
 Sun, 14 May 2023 11:11:35 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5B10C138F5;
 Sun, 14 May 2023 11:11:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id NxdmEubBYGSxdAAAMHmgww
 (envelope-from <colyli@suse.de>); Sun, 14 May 2023 11:11:34 +0000
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
From: Coly Li <colyli@suse.de>
In-Reply-To: <20230512080757.387523-1-kch@nvidia.com>
Date: Sun, 14 May 2023 13:11:22 +0200
Message-Id: <08DD3B6F-0A2D-4725-847F-BACF40D07310@suse.de>
References: <20230512080757.387523-1-kch@nvidia.com>
To: Chaitanya Kulkarni <kch@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [RFC PATCH] block: add meaningful macro for flush op
 flags
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
Cc: axboe@kernel.dk, linux-raid <linux-raid@vger.kernel.org>, sagi@grimberg.me,
 linux-scsi@vger.kernel.org, snitzer@kernel.org, dm-devel@redhat.com,
 linux-nvme@lists.infradead.org, hch@lst.de, linux-block@vger.kernel.org,
 song@kernel.org, Bcache Linux <linux-bcache@vger.kernel.org>,
 target-devel@vger.kernel.org, martin.petersen@oracle.com,
 kent.overstreet@gmail.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Cgo+IDIwMjPlubQ15pyIMTLml6UgMTA6MDfvvIxDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlk
aWEuY29tPiDlhpnpgZPvvJoKPiAKPiBGbHVzaCByZXF1ZXN0cyBhcmUgaW1wbGVtZW50ZWQgYXMg
UkVRX09QX1dSSVRFICsgUkVRX09QX1BSRUZMVVNICj4gY29tYmluYXRpb24gYW5kIG5vdCBSRVFf
T1BfRkxVU0ggKyBSRVFfUFJFRkxVU0ggY29tYmluYXRpb24uCj4gCj4gVGhpcyB1bmNsZWFyIG5h
dHVyZSBoYXMgbGVhZCB0byB0aGUgY29uZnVzaW9uIGFuZCBidWdzIGluIHRoZSBjb2RlIGZvcgo+
IGJsb2NrIGRyaXZlcnMgY2F1c2luZyBtb3JlIHdvcmsgZm9yIHRlc3RpbmcsIHJldmlld3MgYW5k
IGZpeGVzIDotCj4gCj4gMS4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL1pGSGdlZldvZlZ0
MjR0UmxAaW5mcmFkZWFkLm9yZy8KPiAyLiBodHRwczovL21hcmMuaW5mby8/bD1saW51eC1ibG9j
ayZtPTE2ODM4NjM2NDAyNjQ5OCZ3PTIKPiAKPiBBZGQgYSBtYWNybyAobmFtZSBjYW4gbWUgbW9y
ZSBtZWFuaW5nZnVsKSB3aXRoIGEgbWVhbmluZ2Z1bCBjb21tZW50Cj4gY2xlYXJpbmcgdGhlIGNv
bmZ1c2lvbiBhbmQgcmVwbGFjZSB0aGUgUkVRX09QX1dSSVRFIHwgUkVRX1BSRUZMVVNIIHdpdGgK
PiB0aGUgbmV3IG1hY3JvIG5hbWUgdGhhdCBhbHNvIHNhdmVzIGNvZGUgcmVwZXRhdGlvbi4KPiAK
PiBTaWduZWQtb2ZmLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPgoKPiAt
LS0gYS9pbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oCj4gKysrIGIvaW5jbHVkZS9saW51eC9ibGtf
dHlwZXMuaAo+IEBAIC00NTUsNiArNDU1LDEzIEBAIGVudW0gcmVxX2ZsYWdfYml0cyB7Cj4gI2Rl
ZmluZSBSRVFfTk9NRVJHRV9GTEFHUyBcCj4gKFJFUV9OT01FUkdFIHwgUkVRX1BSRUZMVVNIIHwg
UkVRX0ZVQSkKPiAKPiArLyoKPiArICogRmx1c2ggcmVxdWVzdHMgYXJlIGltcGxlbWVudGVkIGFz
IFJFUV9PUF9XUklURSArIFJFUV9PUF9QUkVGTFVTSCBjb21iaW5hdGlvbgo+ICsgKiBhbmQgbm90
IFJFUV9PUF9GTFVTSCArIFJFUV9QUkVGTFVTSCBjb21iaW5hdGlvbi4KPiArICovCj4gKwo+ICsj
ZGVmaW5lIFJFUV9GTFVTSF9PUEYgKFJFUV9PUF9XUklURSB8IFJFUV9QUkVGTFVTSCkKPiArCj4g
ZW51bSBzdGF0X2dyb3VwIHsKPiBTVEFUX1JFQUQsCj4gU1RBVF9XUklURSwKPiAtLSAKClBlcnNv
bmFsbHkgSSBsaWtlIGN1cnJlbnQgZXhwbGljaXQgd2F5LCBpdCBpcyBzaW1wbGVyIHRoYW4gYW4g
ZXh0cmEgbWFjcm8uIFRoaXMgaXMganVzdCBteSBvd24gcG9pbnRzLCBGWUkuCgpUaGFua3MuCgpD
b2x5IExpCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

