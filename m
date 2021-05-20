Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4060C433ED
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 06:05:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9444461186
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 06:05:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9444461186
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-O0Aa6pLZMD6LLB7hahLORg-1; Thu, 20 May 2021 02:05:52 -0400
X-MC-Unique: O0Aa6pLZMD6LLB7hahLORg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 575B81007B01;
	Thu, 20 May 2021 06:05:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AE1D614FD;
	Thu, 20 May 2021 06:05:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0D04D55353;
	Thu, 20 May 2021 06:05:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K5xmEe015488 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 01:59:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CABCA10D18CC; Thu, 20 May 2021 05:59:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C669B10D18CA
	for <dm-devel@redhat.com>; Thu, 20 May 2021 05:59:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07F3280D0E0
	for <dm-devel@redhat.com>; Thu, 20 May 2021 05:59:46 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-528-jh9F-nxKP624_5JniCwwyA-1;
	Thu, 20 May 2021 01:59:41 -0400
X-MC-Unique: jh9F-nxKP624_5JniCwwyA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id C2D2FAD71;
	Thu, 20 May 2021 05:59:39 +0000 (UTC)
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
References: <20210520042228.974083-1-damien.lemoal@wdc.com>
	<20210520042228.974083-10-damien.lemoal@wdc.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <5d5447dc-6e07-63af-9cc6-c7bf68c99e52@suse.de>
Date: Thu, 20 May 2021 07:59:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210520042228.974083-10-damien.lemoal@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14K5xmEe015488
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 09/11] dm: rearrange core declarations
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS8yMC8yMSA2OjIyIEFNLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToKPiBNb3ZlIHRoZSBkZWZp
bml0aW9ucyBvZiBzdHJ1Y3QgZG1fdGFyZ2V0X2lvLCBzdHJ1Y3QgZG1faW8gYW5kIG9mIHRoZQo+
IGJpdHMgb2YgdGhlIGZsYWdzIGZpZWxkIG9mIHN0cnVjdCBtYXBwZWRfZGV2aWNlIGZyb20gZG0u
YyB0byBkbS1jb3JlLmgKPiB0byBtYWtlIHRoZW0gdXNhYmxlIGZyb20gZG0tem9uZS5jLgo+IEZv
ciB0aGUgc2FtZSByZWFzb24sIGRlY2xhcmUgZGVjX3BlbmRpbmcoKSBpbiBkbS1jb3JlLmggYWZ0
ZXIgcmVuYW1pbmcKPiBpdCB0byBkbV9pb19kZWNfcGVuZGluZygpLiBBbmQgZm9yIHN5bW1ldHJ5
IG9mIHRoZSBmdW5jdGlvbiBuYW1lcywKPiBpbnRyb2R1Y2UgdGhlIGlubGluZSBoZWxwZXIgZG1f
aW9faW5jX3BlbmRpbmcoKSBpbnN0ZWFkIG9mIGRpcmVjdGx5Cj4gdXNpbmcgYXRvbWljX2luYygp
IGNhbGxzLgo+IAo+IFNpZ25lZC1vZmYtYnk6IERhbWllbiBMZSBNb2FsIDxkYW1pZW4ubGVtb2Fs
QHdkYy5jb20+Cj4gLS0tCj4gICBkcml2ZXJzL21kL2RtLWNvcmUuaCB8IDUyICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrCj4gICBkcml2ZXJzL21kL2RtLmMgICAgICB8IDU5
ICsrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4gICAyIGZpbGVz
IGNoYW5nZWQsIDU5IGluc2VydGlvbnMoKyksIDUyIGRlbGV0aW9ucygtKQo+IEkndmUgbmV2ZXIg
YmVlbiBhIGZhbiBvZiBwcml2YXRlIHN0cnVjdHVyZXMuCgpSZXZpZXdlZC1ieTogSGFubmVzIFJl
aW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVp
bmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5k
ZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29m
dHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIg
MzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBGZWxpeCBJbWVuZMO2cmZm
ZXIKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczov
L2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

