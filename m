Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B8FFC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 15:31:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-qmRnics9Na-UQ9RkPSJXWw-1; Tue, 22 Mar 2022 11:31:50 -0400
X-MC-Unique: qmRnics9Na-UQ9RkPSJXWw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBB7829DD994;
	Tue, 22 Mar 2022 15:31:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D52161427AE4;
	Tue, 22 Mar 2022 15:31:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 87B371940340;
	Tue, 22 Mar 2022 15:31:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5D57E1949762
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 15:31:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 31B3840357BD; Tue, 22 Mar 2022 15:31:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DA284010A02
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 15:31:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1388E800882
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 15:31:45 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-g1ZZi6BGPECAXeR5ldgAyg-1; Tue, 22 Mar 2022 11:31:41 -0400
X-MC-Unique: g1ZZi6BGPECAXeR5ldgAyg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 8274A210F1;
 Tue, 22 Mar 2022 15:31:39 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 63EFD133B6;
 Tue, 22 Mar 2022 15:31:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id dFkVGNvrOWKxTQAAMHmgww
 (envelope-from <hare@suse.de>); Tue, 22 Mar 2022 15:31:39 +0000
Message-ID: <85bbf7a7-70c2-2410-6399-5f0454621c23@suse.de>
Date: Tue, 22 Mar 2022 16:31:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To: John Garry <john.garry@huawei.com>, Christoph Hellwig <hch@lst.de>
References: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
 <1647945585-197349-2-git-send-email-john.garry@huawei.com>
 <20220322111848.GA29270@lst.de>
 <cacc3f7b-c8be-0f72-1c52-562c15b468a4@huawei.com>
 <b5df2ef1-2d6d-340e-e4b4-09132dc0516b@suse.de>
 <a5e42012-c1fc-082e-e636-594abc07dd70@huawei.com>
 <306df4cf-0ee0-2b1e-044c-aed6c70122f9@suse.de>
 <0f7b9765-8835-25b5-4cdb-bc78edddad37@huawei.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <0f7b9765-8835-25b5-4cdb-bc78edddad37@huawei.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 01/11] blk-mq: Add blk_mq_init_queue_ops()
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
Cc: axboe@kernel.dk, bvanassche@acm.org, martin.petersen@oracle.com,
 chenxiang66@hisilicon.com, damien.lemoal@opensource.wdc.com,
 linux-kernel@vger.kernel.org, ming.lei@redhat.com, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org,
 jejb@linux.ibm.com, beanhuo@micron.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMy8yMi8yMiAxNjoxNywgSm9obiBHYXJyeSB3cm90ZToKPiBPbiAyMi8wMy8yMDIyIDE0OjAz
LCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6Cj4+Pgo+Pj4gQXMgbWVudGlvbmVkIGluIHRoZSBjb3Zl
ciBsZXR0ZXIgcmVzcG9uc2UsIGl0IGp1c3Qgc2VlbXMgYmVzdCB0byBrZWVwIAo+Pj4gdGhlIG5v
cm1hbCBzY3NpX2NtbmQgcGF5bG9hZCBidXQgaGF2ZSBvdGhlciBtZWFucyB0byBhZGQgb24gdGhl
IAo+Pj4gaW50ZXJuYWwgY29tbWFuZCBkYXRhLCBsaWtlIHVzaW5nIGhvc3Rfc2NyaWJibGUgb3Ig
c2NzaV9jbW5kIHByaXYgZGF0YS4KPj4+Cj4+IFdlbGw7IEkgZm91bmQgdGhhdCBtb3N0IGRyaXZl
cnMgSSBoYWQgYmVlbiBsb29raW5nIGF0IHRoZSBzY3NpIGNvbW1hbmQgCj4+IHBheWxvYWQgaXNu
J3QgdXNlZCBhdCBhbGw7IHRoZSBkcml2ZXJzIHByaW1hcmlseSBjYXJlZCBhYm91dCB0aGUgCj4+
IChkcml2ZXItcHJvdmlkZWQpIHBheWxvYWQsIGFuZCB3ZXJlIGNvbXBsZXRlbHkgaWdub3Jpbmcg
dGhlIHNjc2kgCj4+IGNvbW1hbmQgcGF5bG9hZC4KPj4KPj4gU2ltaWxhciBmb3IgQVRBL2xpYnNh
czogeW91IGJhc2ljYWxseSBuZXZlciBpc3N1ZSByZWFsIHNjc2kgY29tbWFuZHMsIAo+PiBidXQg
ZWl0aGVyICdyYXcnIEFUQSByZXF1ZXN0cyBvciBTQ1NJIFRNRnMuIE5vbmUgb2Ygd2hpY2ggYXJl
IHNjc2kgCj4+IGNvbW1hbmRzLCBzbyBwcm92aWRpbmcgdGhlbSBpcyBhIGJpdCBvZiBhIHdhc3Rl
Lgo+Pgo+PiAoQW5kIGNhdXNlcyBpcnJpdGF0aW9ucywgdG9vLCBhcyBhIHNjc2kgY29tbWFuZCBy
ZXF1aXJlcyBhc3NvY2lhdGVkIAo+PiBwb2ludGVycyBsaWtlIC0+ZGV2aWNlIGV0YyB0byBiZSBz
ZXQgdXAuIFdoaWNoIG1ha2VzIGl0IHRyaWNreSB0byB1c2UgCj4+IGZvciB0aGUgaW5pdGlhbCBk
ZXZpY2Ugc2V0dXAuKQo+IAo+IEEgcHJvYmxlbSBJIHNlZSBpcyB0aGF0IGluIHNjc2lfbXFfaW5p
dF9yZXF1ZXN0KCkgd2UgYWxsb2NhdGUgbWVtb3JpZXMgCj4gbGlrZSBzZW5zZV9idWZmZXIgYW5k
IHByb3Rfc2RiIGFuZCBzdG9yZSB0aGUgcG9pbnRlcnMgaW4gdGhlIHNjc2lfY21uZCAKPiBwYXls
b2FkLiBJZiB3ZSB0aGVuIHJldXNlIGEgc2NzaV9jbW5kIHBheWxvYWQgYXMgYW4gImludGVybmFs
IiBjb21tYW5kIAo+IHBheWxvYWQgdGhlbiB0aGlzIGRhdGEgbWF5IGJlIGxvc3QuCj4gCj4gSXQg
bWlnaHQgYmUgcG9zc2libGUgdG8gcmV1c2UgdGhlIHNjc2kgY21uZCBwYXlsb2FkIGZvciB0aGUg
ImludGVybmFsIiwgCj4gYnV0IEkgd291bGQgcmF0aGVyIG5vdCBnZXQgaHVuZyB1cCBvbiBpdCBu
b3cgaWYgcG9zc2libGUuCj4gCk9yLCBrZWVwIHRoZSBwYXlsb2FkIGFzIGlzLCBhbmQgdXNlIHRo
ZSAnaW50ZXJuYWwnIG1hcmtlciB0byBpbmRpY2F0ZSAKdGhhdCB0aGUgc2NzaSBwYXlsb2FkIGlz
IG5vdCB2YWxpZC4KVGhhdCB3b3VsZCBzYXZlIHVzIHF1aXRlIHNvbWUgY2hlY2tzIGR1cmluZyBl
bmRpbyBwcm9jZXNzaW5nLgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tl
CQkgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUJCQkgICAg
ICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBH
ZXJtYW55IEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFH
IE7DvHJuYmVyZyksIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIKCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWwK

