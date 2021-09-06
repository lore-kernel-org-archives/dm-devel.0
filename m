Return-Path: <SRS0=WplP=N4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED260C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  6 Sep 2021 06:17:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4A80F600CC
	for <dm-devel@archiver.kernel.org>; Mon,  6 Sep 2021 06:17:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4A80F600CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-51VD3fJePcyFw-AjKxPWOA-1; Mon, 06 Sep 2021 02:17:01 -0400
X-MC-Unique: 51VD3fJePcyFw-AjKxPWOA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49F3A512C;
	Mon,  6 Sep 2021 06:16:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B2B2619C87;
	Mon,  6 Sep 2021 06:16:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9E7DC1809C98;
	Mon,  6 Sep 2021 06:16:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1866GjZ5027303 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 6 Sep 2021 02:16:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 684C050167; Mon,  6 Sep 2021 06:16:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 631E22955
	for <dm-devel@redhat.com>; Mon,  6 Sep 2021 06:16:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 979241857F03
	for <dm-devel@redhat.com>; Mon,  6 Sep 2021 06:16:42 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-425-gH1kSwzlMkuFZqy7giDK-Q-1; Mon, 06 Sep 2021 02:16:36 -0400
X-MC-Unique: gH1kSwzlMkuFZqy7giDK-Q-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B8DD32007F;
	Mon,  6 Sep 2021 06:16:34 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id B8ACF13299;
	Mon,  6 Sep 2021 06:16:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap1.suse-dmz.suse.de with ESMTPSA id lP1cKkGyNWFKTwAAGKfGzw
	(envelope-from <hare@suse.de>); Mon, 06 Sep 2021 06:16:33 +0000
To: Luis Chamberlain <mcgrof@kernel.org>, axboe@kernel.dk,
	martin.petersen@oracle.com, jejb@linux.ibm.com, kbusch@kernel.org,
	sagi@grimberg.me, adrian.hunter@intel.com, beanhuo@micron.com,
	ulf.hansson@linaro.org, avri.altman@wdc.com, swboyd@chromium.org,
	agk@redhat.com, snitzer@redhat.com, josef@toxicpanda.com
References: <20210830212538.148729-1-mcgrof@kernel.org>
	<20210830212538.148729-4-mcgrof@kernel.org>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <677ca876-b003-d3b5-9e2e-d50ebef82cce@suse.de>
Date: Mon, 6 Sep 2021 08:16:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210830212538.148729-4-mcgrof@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1866GjZ5027303
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, bvanassche@acm.org, linux-scsi@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, ming.lei@redhat.com,
	hch@infradead.org, dm-devel@redhat.com, nbd@other.debian.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH v3 3/8] nvme: add error handling support for
	add_disk()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gOC8zMC8yMSAxMToyNSBQTSwgTHVpcyBDaGFtYmVybGFpbiB3cm90ZToKPiBXZSBuZXZlciBj
aGVja2VkIGZvciBlcnJvcnMgb24gYWRkX2Rpc2soKSBhcyB0aGlzIGZ1bmN0aW9uCj4gcmV0dXJu
ZWQgdm9pZC4gTm93IHRoYXQgdGhpcyBpcyBmaXhlZCwgdXNlIHRoZSBzaGlueSBuZXcKPiBlcnJv
ciBoYW5kbGluZy4KPiAKPiBSZXZpZXdlZC1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3Qu
ZGU+Cj4gU2lnbmVkLW9mZi1ieTogTHVpcyBDaGFtYmVybGFpbiA8bWNncm9mQGtlcm5lbC5vcmc+
Cj4gLS0tCj4gICBkcml2ZXJzL252bWUvaG9zdC9jb3JlLmMgfCA5ICsrKysrKysrLQo+ICAgMSBm
aWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+IAo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL252bWUvaG9zdC9jb3JlLmMgYi9kcml2ZXJzL252bWUvaG9zdC9jb3JlLmMK
PiBpbmRleCA4Njc5YTEwOGY1NzEuLjY4N2QzYmU1NjNhMyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJz
L252bWUvaG9zdC9jb3JlLmMKPiArKysgYi9kcml2ZXJzL252bWUvaG9zdC9jb3JlLmMKPiBAQCAt
Mzc2Myw3ICszNzYzLDkgQEAgc3RhdGljIHZvaWQgbnZtZV9hbGxvY19ucyhzdHJ1Y3QgbnZtZV9j
dHJsICpjdHJsLCB1bnNpZ25lZCBuc2lkLAo+ICAgCj4gICAJbnZtZV9nZXRfY3RybChjdHJsKTsK
PiAgIAo+IC0JZGV2aWNlX2FkZF9kaXNrKGN0cmwtPmRldmljZSwgbnMtPmRpc2ssIG52bWVfbnNf
aWRfYXR0cl9ncm91cHMpOwo+ICsJaWYgKGRldmljZV9hZGRfZGlzayhjdHJsLT5kZXZpY2UsIG5z
LT5kaXNrLCBudm1lX25zX2lkX2F0dHJfZ3JvdXBzKSkKPiArCQlnb3RvIG91dF9jbGVhbnVwX25z
X2Zyb21fbGlzdDsKPiArCj4gICAJaWYgKCFudm1lX25zX2hlYWRfbXVsdGlwYXRoKG5zLT5oZWFk
KSkKPiAgIAkJbnZtZV9hZGRfbnNfY2Rldihucyk7Cj4gICAKPiBAQCAtMzc3Myw2ICszNzc1LDEx
IEBAIHN0YXRpYyB2b2lkIG52bWVfYWxsb2NfbnMoc3RydWN0IG52bWVfY3RybCAqY3RybCwgdW5z
aWduZWQgbnNpZCwKPiAgIAo+ICAgCXJldHVybjsKPiAgIAo+ICsgb3V0X2NsZWFudXBfbnNfZnJv
bV9saXN0Ogo+ICsJbnZtZV9wdXRfY3RybChjdHJsKTsKPiArCWRvd25fd3JpdGUoJmN0cmwtPm5h
bWVzcGFjZXNfcndzZW0pOwo+ICsJbGlzdF9kZWxfaW5pdCgmbnMtPmxpc3QpOwo+ICsJdXBfd3Jp
dGUoJmN0cmwtPm5hbWVzcGFjZXNfcndzZW0pOwo+ICAgIG91dF91bmxpbmtfbnM6Cj4gICAJbXV0
ZXhfbG9jaygmY3RybC0+c3Vic3lzLT5sb2NrKTsKPiAgIAlsaXN0X2RlbF9yY3UoJm5zLT5zaWJs
aW5ncyk7Cj4gCkkgd291bGQgcmF0aGVyIHR1cm4gdGhpcyBhcm91bmQsIGFuZCBjYWxsICdudm1l
X3B1dF9jdHJsKCknIGFmdGVyIApyZW1vdmluZyB0aGUgbmFtZXNwYWNlIGZyb20gdGhlIGxpc3Qu
IEJ1dCBpdCdzIHByb2JhYmx5IG1vcmUgYSBzdHlsZSAKaXNzdWUsIGNvbWUgdG8gdGhpbmsgb2Yg
aXQuCgpSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMs
CgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0
b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRz
dHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6Rm
dHNmw7xocmVyOiBGZWxpeCBJbWVuZMO2cmZmZXIKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVs

