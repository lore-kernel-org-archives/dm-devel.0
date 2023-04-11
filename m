Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 258A1C76196
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 07:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681197218;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Z1C3DN4jkzi6L4Lkk/haTX2ea6qeFUMLtef9She6xbo=;
	b=eqg6FK/wA6iiTaBvobaDNs3X8ZZk9Br/XsxgBu14JNzrS2o9/Bh9D4yaC6f3XX9NET0629
	5v/Ipy1oYvmAh/UttJ2kjGpFGlFmYeVBVqihUhEVUQyHKgiucxq9XoNH1J/w9TxgmLZyIM
	yafrc7s+mq7ZZ7jO6EFeOcuGucF3V54=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-245-GFuXvBEVNv6NvaLSWptpHA-1; Tue, 11 Apr 2023 03:13:37 -0400
X-MC-Unique: GFuXvBEVNv6NvaLSWptpHA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E24985A5A3;
	Tue, 11 Apr 2023 07:13:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4CAB9C15BBA;
	Tue, 11 Apr 2023 07:13:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1BF8F1946588;
	Tue, 11 Apr 2023 07:13:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9FE131946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 07:13:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D7643440D8; Tue, 11 Apr 2023 07:13:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BE75F440D6
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:13:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EAE1811E7C
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:13:24 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-392-bFrd_-1lOu6b31D4HATZGw-1; Tue,
 11 Apr 2023 03:13:22 -0400
X-MC-Unique: bFrd_-1lOu6b31D4HATZGw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 95E7421A4C;
 Tue, 11 Apr 2023 07:13:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3B50713519;
 Tue, 11 Apr 2023 07:13:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id vf3uDJEINWTpXAAAMHmgww
 (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 07:13:21 +0000
Message-ID: <39789d6a-389f-b2db-8274-1c692baa1117@suse.de>
Date: Tue, 11 Apr 2023 09:13:20 +0200
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
 <20230407200551.12660-6-michael.christie@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230407200551.12660-6-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v6 05/18] scsi: Add support for block PR read
 keys/reservation
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

T24gNC83LzIzIDIyOjA1LCBNaWtlIENocmlzdGllIHdyb3RlOgo+IFRoaXMgYWRkcyBzdXBwb3J0
IGluIHNkLmMgZm9yIHRoZSBibG9jayBQUiByZWFkIGtleXMgYW5kIHJlYWQgcmVzZXJ2YXRpb24K
PiBjYWxsb3V0cywgc28gdXBwZXIgbGF5ZXJzIGxpa2UgTElPIGNhbiBnZXQgdGhlIFBSIGluZm8g
dGhhdCdzIGJlZW4gc2V0dXAKPiB1c2luZyB0aGUgZXhpc3RpbmcgcHIgY2FsbG91dHMgYW5kIHJl
dHVybiBpdCB0byBpbml0aWF0b3JzLgo+IAo+IFNpZ25lZC1vZmYtYnk6IE1pa2UgQ2hyaXN0aWUg
PG1pY2hhZWwuY2hyaXN0aWVAb3JhY2xlLmNvbT4KPiBSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1
bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4KPiBSZXZpZXdlZC1ieTogQ2hyaXN0b3BoIEhlbGx3aWcg
PGhjaEBsc3QuZGU+Cj4gLS0tCj4gICBkcml2ZXJzL3Njc2kvc2NzaV9jb21tb24uYyB8IDIxICsr
KysrKysrKwo+ICAgZHJpdmVycy9zY3NpL3NkLmMgICAgICAgICAgfCA5MSArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKwo+ICAgaW5jbHVkZS9zY3NpL3Njc2lfY29tbW9uLmgg
fCAgMSArCj4gICBpbmNsdWRlL3Njc2kvc2NzaV9wcm90by5oICB8ICA1ICsrKwo+ICAgNCBmaWxl
cyBjaGFuZ2VkLCAxMTggaW5zZXJ0aW9ucygrKQo+IApVbmZvcnR1bmF0ZWx5IHRoaXMgdGllcyBv
dXIgUFIgYWJzdHJhY3Rpb24gdG8gdGhlIFNDU0kgUFIgbW9kZWwuCkxldCdzIGhvcGUgdGhhdCBv
dGhlciBwcm90b2NvbHMgbGlrZSBOVk1lIHdpbGwgbWFwIG9udG8gdGhhdCwgdG9vLgpCdXQgaW4g
dGhlIG1lYW50aW1lOgoKUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRl
PgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAg
IEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJI
LCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcp
LCBHZXNjaMOkZnRzZsO8aHJlcjogSXZvIFRvdGV2LCBBbmRyZXcKTXllcnMsIEFuZHJldyBNY0Rv
bmFsZCwgTWFydGplIEJvdWRpZW4gTW9lcm1hbgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRt
LWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbAo=

