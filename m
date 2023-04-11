Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24521C7619A
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 07:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681197455;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wi5zMiqT2sBjOfmuPWRtNIkciqxOZrwMJBm8BCWcZco=;
	b=LfAIEfMTEB9HfAd7O1FUuoBBodLNFwfItF+qDq2kgqqirgJ9/dYULQpgBayxH5I2bRcuCs
	4VZilQtWsqpm0104EkujJeqdAhPCvriTRj/1EAcBv3oEoh4KHBbBtzZnVY1Ci8+q08fC+F
	PexkzVDDn3Xcgl4i4vtTobgAzwfqRNg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-LbI-SdBrMgiMmIjcEsJtQg-1; Tue, 11 Apr 2023 03:17:33 -0400
X-MC-Unique: LbI-SdBrMgiMmIjcEsJtQg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07AD8185A78B;
	Tue, 11 Apr 2023 07:17:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EAF49C15BA0;
	Tue, 11 Apr 2023 07:17:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 972AA1946588;
	Tue, 11 Apr 2023 07:17:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3B67F1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 07:17:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 23D4040C83A9; Tue, 11 Apr 2023 07:17:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C57340C20FA
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:17:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01AB88996E4
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:17:30 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-vUaEPD8-P_WcM_-FpveIQA-1; Tue,
 11 Apr 2023 03:17:28 -0400
X-MC-Unique: vUaEPD8-P_WcM_-FpveIQA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 8248D21A54;
 Tue, 11 Apr 2023 07:17:27 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2449213638;
 Tue, 11 Apr 2023 07:17:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id OtWfB4cJNWQiXwAAMHmgww
 (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 07:17:27 +0000
Message-ID: <5b8c3a6e-6a97-6917-e172-468ba220e03f@suse.de>
Date: Tue, 11 Apr 2023 09:17:26 +0200
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
 <20230407200551.12660-10-michael.christie@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230407200551.12660-10-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v6 09/18] nvme: Move pr code to it's own file
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
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNC83LzIzIDIyOjA1LCBNaWtlIENocmlzdGllIHdyb3RlOgo+IFRoaXMgcGF0Y2ggbW92ZXMg
dGhlIHByIGNvZGUgdG8gaXQncyBvd24gZmlsZSBiZWNhdXNlIEknbSBnb2luZyB0byBiZQo+IGFk
ZGluZyBtb3JlIGZ1bmN0aW9ucyBhbmQgY29yZS5jIGlzIGdldHRpbmcgYmlnZ2VyLgo+IAo+IFNp
Z25lZC1vZmYtYnk6IE1pa2UgQ2hyaXN0aWUgPG1pY2hhZWwuY2hyaXN0aWVAb3JhY2xlLmNvbT4K
PiBSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4KPiBSZXZp
ZXdlZC1ieTogS2VpdGggQnVzY2ggPGtidXNjaEBrZXJuZWwub3JnPgo+IC0tLQo+ICAgZHJpdmVy
cy9udm1lL2hvc3QvTWFrZWZpbGUgfCAgIDIgKy0KPiAgIGRyaXZlcnMvbnZtZS9ob3N0L2NvcmUu
YyAgIHwgMTQ4IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KPiAgIGRyaXZlcnMv
bnZtZS9ob3N0L252bWUuaCAgIHwgICAyICsKPiAgIGRyaXZlcnMvbnZtZS9ob3N0L3ByLmMgICAg
IHwgMTU4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKPiAgIDQgZmlsZXMg
Y2hhbmdlZCwgMTYxIGluc2VydGlvbnMoKyksIDE0OSBkZWxldGlvbnMoLSkKPiAgIGNyZWF0ZSBt
b2RlIDEwMDY0NCBkcml2ZXJzL252bWUvaG9zdC9wci5jCj4gUmV2aWV3ZWQtYnk6IEhhbm5lcyBS
ZWluZWNrZSA8aGFyZUBzdXNlLmRlPgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJl
aW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2Uu
ZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNv
ZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKSFJC
IDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjogSXZvIFRvdGV2LCBBbmRy
ZXcKTXllcnMsIEFuZHJldyBNY0RvbmFsZCwgTWFydGplIEJvdWRpZW4gTW9lcm1hbgoKLS0KZG0t
ZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

