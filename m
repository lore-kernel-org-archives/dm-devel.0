Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FFE3C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 12:17:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-r8r96KyyOWu_E45t5VqTug-1; Tue, 22 Mar 2022 08:16:56 -0400
X-MC-Unique: r8r96KyyOWu_E45t5VqTug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AF4219711BE;
	Tue, 22 Mar 2022 12:16:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A71CE778A;
	Tue, 22 Mar 2022 12:16:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 573B91949762;
	Tue, 22 Mar 2022 12:16:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 209951947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 12:16:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BBF3A4229D6; Tue, 22 Mar 2022 12:16:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B75724229AE
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 12:16:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62F3080231F
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 12:16:52 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-EIWaPtq1N7W1WRM7lfqegQ-1; Tue, 22 Mar 2022 08:16:48 -0400
X-MC-Unique: EIWaPtq1N7W1WRM7lfqegQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 5F589210F7;
 Tue, 22 Mar 2022 12:16:47 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3774412FC5;
 Tue, 22 Mar 2022 12:16:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id Ayv1DC++OWJAYQAAMHmgww
 (envelope-from <hare@suse.de>); Tue, 22 Mar 2022 12:16:47 +0000
Message-ID: <b5df2ef1-2d6d-340e-e4b4-09132dc0516b@suse.de>
Date: Tue, 22 Mar 2022 13:16:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To: John Garry <john.garry@huawei.com>, Christoph Hellwig <hch@lst.de>
References: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
 <1647945585-197349-2-git-send-email-john.garry@huawei.com>
 <20220322111848.GA29270@lst.de>
 <cacc3f7b-c8be-0f72-1c52-562c15b468a4@huawei.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <cacc3f7b-c8be-0f72-1c52-562c15b468a4@huawei.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMy8yMi8yMiAxMjozMywgSm9obiBHYXJyeSB3cm90ZToKPiBPbiAyMi8wMy8yMDIyIDExOjE4
LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPj4gT24gVHVlLCBNYXIgMjIsIDIwMjIgYXQgMDY6
Mzk6MzVQTSArMDgwMCwgSm9obiBHYXJyeSB3cm90ZToKPj4+IEFkZCBhbiBBUEkgdG8gYWxsb2Nh
dGUgYSByZXF1ZXN0IHF1ZXVlIHdoaWNoIGFjY2VwdHMgYSBjdXN0b20gc2V0IG9mCj4+PiBibGtf
bXFfb3BzIGZvciB0aGF0IHJlcXVlc3QgcXVldWUuCj4+Pgo+Pj4gVGhlIHJlYXNvbiB3aGljaCB3
ZSBtYXkgd2FudCBjdXN0b20gb3BzIGlzIGZvciBxdWV1aW5nIHJlcXVlc3RzIHdoaWNoIHdlCj4+
PiBkb24ndCB3YW50IHRvIGdvIHRocm91Z2ggdGhlIG5vcm1hbCBxdWV1aW5nIHBhdGguCj4+Cj4+
IEV3dy7CoCBJIHJlYWxseSBkbyBub3QgdGhpbmsgd2Ugc2hvdWxkIGRvIHNlcGFyYXRlIG9wcyBw
ZXIgcXVldWUsIGFzIHRoYXQKPj4gaXMgZ29pbmcgdG8gZ2V0IHVzIGludG8gYSBkZWVwIG1lc3Mg
ZXZlbnR1YWxseS4KPj4KPiAKPiBZZWFoLi4uIHNvIGZhciAoaGVyZSkgaXQgd29ya3Mgb3V0IHF1
aXRlIG5pY2VseSwgYXMgd2UgZG9uJ3QgbmVlZCB0byAKPiBjaGFuZ2UgdGhlIFNDU0kgYmxrIG1x
IG9wcyBub3IgYWxsb2NhdGUgYSBzY3NpX2RldmljZSAtIGV2ZXJ5dGhpbmcgaXMgCj4ganVzdCBz
ZXBhcmF0ZS4KPiAKPiBUaGUgb3RoZXIgbWV0aG9kIG1lbnRpb25lZCBwcmV2aW91c2x5IHdhcyB0
byBhZGQgdGhlIHJlcXVlc3QgInJlc2VydmVkIiAKPiBmbGFnIGFuZCBhZGQgbmV3IHBhdGhzIGlu
IHNjc2lfcXVldWVfcnEoKSBldCBhbCB0byBoYW5kbGUgdGhpcywgYnV0IHRoYXQgCj4gZ2V0cyBt
ZXNzeS4KPiAKPiBBbnkgb3RoZXIgaWRlYXMgLi4uPwo+IAoKQXMgb3V0bGluZWQgaW4gdGhlIG90
aGVyIG1haWwsIEkgdGhpbmsgbWlnaHQgYmUgdXNlZnVsIGlzIHRvIGhhdmUgYSAKX3RoaXJkXyB0
eXBlIG9mIHJlcXVlc3RzIChpbiBhZGRpdGlvbiB0byB0aGUgbm9ybWFsIGFuZCB0aGUgcmVzZXJ2
ZWQgb25lcykuClRoYXQgb25lIHdvdWxkIGJlIGFsbG9jYXRlZCBmcm9tIHRoZSBub3JtYWwgSS9P
IHBvb2wgKGFuZCBoZW5jZSBjb3VsZCAKZmFpbCBpZiB0aGUgcG9vbCBpcyBleGhhdXN0ZWQpLCBi
dXQgd291bGQgYmUgYWJsZSB0byBjYXJyeSBhIGRpZmZlcmVudCAKcGF5bG9hZCAodHlwZSkgdGhh
biB0aGUgbm9ybWFsIHJlcXVlc3RzLgpBbmQgd2UgY291bGQgaGF2ZSBhIHNlcGFyYXRlIHF1ZXVl
X3JxIGZvciB0aGVzZSByZXF1ZXN0cywgYXMgd2UgY2FuIApkaWZmZXJlbnRpYXRlIHRoZW0gaW4g
dGhlIGJsb2NrIGxheWVyLgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tl
CQkgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUJCQkgICAg
ICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBH
ZXJtYW55IEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFH
IE7DvHJuYmVyZyksIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIKCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWwK

