Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E6B8C77B6F
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 07:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681198287;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Rf+bWl0H47fdUpKVGMDlNMAyGqIpt1eQX7V8hJ0uORs=;
	b=eUzM5m0zNsAGHIpMpsby1kY5pelhNC8VjlWKPrp3iN7W4aQ5F2MJpNFEpfFB/9Jrrq1FHB
	WTUp6/FZBkMrRgK6ndPqTXSV949Cuc1XFWRwAFoGRm6Sl8t8cD8a+iU+e/yZd84+y56PIU
	a83Wa014n8Dgu+pHLw424gtwncxwfMw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-_fd48nizPWa3YSolVcBeCg-1; Tue, 11 Apr 2023 03:31:24 -0400
X-MC-Unique: _fd48nizPWa3YSolVcBeCg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8EB50101A531;
	Tue, 11 Apr 2023 07:31:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7BDA71415308;
	Tue, 11 Apr 2023 07:31:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2D1751946588;
	Tue, 11 Apr 2023 07:31:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 710B01946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 07:31:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5127B112132D; Tue, 11 Apr 2023 07:31:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A6371121320
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:31:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BE181C0514C
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:31:21 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-541-y_FfOKsVPgqyOmgKG3Fkpg-1; Tue,
 11 Apr 2023 03:31:19 -0400
X-MC-Unique: y_FfOKsVPgqyOmgKG3Fkpg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 593CE1FE00;
 Tue, 11 Apr 2023 07:31:18 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F3B2E13638;
 Tue, 11 Apr 2023 07:31:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 71B0OsUMNWRiZgAAMHmgww
 (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 07:31:17 +0000
Message-ID: <a78916e3-16f1-3928-8245-bb54532bcb58@suse.de>
Date: Tue, 11 Apr 2023 09:31:17 +0200
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
 <20230407200551.12660-16-michael.christie@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230407200551.12660-16-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v6 15/18] scsi: target: Allow backends to
 hook into PR handling
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNC83LzIzIDIyOjA1LCBNaWtlIENocmlzdGllIHdyb3RlOgo+IEZvciB0aGUgY2FzZXMgd2hl
cmUgeW91IHdhbnQgdG8gZXhwb3J0IGEgZGV2aWNlIHRvIGEgVk0gdmlhIGEgc2luZ2xlCj4gSV9U
IG5leHVzIGFuZCB3YW50IHRvIHBhc3N0aHJvdWdoIHRoZSBQUiBoYW5kbGluZyB0byB0aGUgcGh5
c2ljYWwvcmVhbAo+IGRldmljZSB5b3UgaGF2ZSB0byB1c2UgcHNjc2kgb3IgdGNtdS4gQm90aCBh
cmUgZ29vZCBmb3Igc3BlY2lmaWMgdXNlcwo+IGhvd2V2ZXIgZm9yIHRoZSBjYXNlIHdoZXJlIHlv
dSB3YW50IGdvb2QgcGVyZm9ybWFuY2UsIGFuZCBhcmUgbm90IHVzaW5nCj4gU0NTSSBkZXZpY2Vz
IGRpcmVjdGx5ICh1c2luZyBETS9NRCBSQUlEIG9yIG11bHRpcGF0aCBkZXZpY2VzKSB0aGVuIHdl
IGFyZQo+IG91dCBvZiBsdWNrLgo+IAo+IFRoZSBmb2xsb3dpbmcgcGF0Y2hlcyBhbGxvdyBpYmxv
Y2sgdG8gbWltaW1hbGx5IGhvb2sgaW50byB0aGUgTElPIFBSIGNvZGUKPiBhbmQgdGhlbiBwYXNz
IHRoZSBQUiBoYW5kbGluZyB0byB0aGUgcGh5c2ljYWwgZGV2aWNlLiBOb3RlIHRoYXQgbGlrZSB3
aXRoCj4gdGhlIHRjbXUgYW4gcHNjc2kgY2FzZXMgaXQncyBvbmx5IHN1cHBvcnRlZCB3aGVuIHlv
dSBleHBvcnQgdGhlIGRldmljZSB2aWEKPiBvbmUgSV9UIG5leHVzLgo+IAo+IFRoaXMgcGF0Y2gg
YWRkcyB0aGUgaW5pdGlhbCBMSU8gY2FsbG91dHMuIFRoZSBuZXh0IHBhdGNoIHdpbGwgbW9kaWZ5
Cj4gaWJsb2NrLgo+IAo+IFNpZ25lZC1vZmYtYnk6IE1pa2UgQ2hyaXN0aWUgPG1pY2hhZWwuY2hy
aXN0aWVAb3JhY2xlLmNvbT4KPiBSZXZpZXdlZC1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBs
c3QuZGU+Cj4gLS0tCj4gICBkcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV9wci5jICAgICAgfCA2
MiArKysrKysrKysrKysrKysrKysrKysrKysrKystCj4gICBpbmNsdWRlL3RhcmdldC90YXJnZXRf
Y29yZV9iYWNrZW5kLmggfCAgNCArKwo+ICAgMiBmaWxlcyBjaGFuZ2VkLCA2NSBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pCj4gUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBz
dXNlLmRlPgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAg
ICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9u
cyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xy
bmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjogSXZvIFRvdGV2LCBBbmRyZXcKTXllcnMsIEFuZHJl
dyBNY0RvbmFsZCwgTWFydGplIEJvdWRpZW4gTW9lcm1hbgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbAo=

