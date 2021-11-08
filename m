Return-Path: <SRS0=u3eZ=P3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D46C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  8 Nov 2021 21:25:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3ED59611C0
	for <dm-devel@archiver.kernel.org>; Mon,  8 Nov 2021 21:25:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3ED59611C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636406747;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NY1nTXorRZWp7+l4t7reOxytcYtAzglTzx1yGDiLT8o=;
	b=jOt3LXfq1m7fAclgICqtkRiwI8Gi4u7WX0oiUDMG15cK9jFC46DMdUSXe8pO2KkZNQK8c1
	axkr/T4oL24oOLXvgZveFx4OX3sfLjaguQDx4ApBR+muSjm1MKKF+eMBt0i2idKZNHS2YF
	Vn7g3ASmtc26Ue9rMorNjSShgmvjQxw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-NorUoNDaNiCUrUP6NTcGDQ-1; Mon, 08 Nov 2021 16:25:45 -0500
X-MC-Unique: NorUoNDaNiCUrUP6NTcGDQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEB7B2E77;
	Mon,  8 Nov 2021 21:25:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 733955DEFA;
	Mon,  8 Nov 2021 21:25:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E5214180BAD2;
	Mon,  8 Nov 2021 21:25:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A8LPaBT029675 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Nov 2021 16:25:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6182251DD; Mon,  8 Nov 2021 21:25:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C59F51DC
	for <dm-devel@redhat.com>; Mon,  8 Nov 2021 21:25:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DD9B85A5B9
	for <dm-devel@redhat.com>; Mon,  8 Nov 2021 21:25:33 +0000 (UTC)
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
	[209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-399-egkHcQKiMdaBEXKrxa8_tg-1; Mon, 08 Nov 2021 16:25:30 -0500
X-MC-Unique: egkHcQKiMdaBEXKrxa8_tg-1
Received: by mail-qt1-f199.google.com with SMTP id
	o14-20020a05622a138e00b002a79da5b350so13012016qtk.15
	for <dm-devel@redhat.com>; Mon, 08 Nov 2021 13:25:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
	:content-disposition:content-transfer-encoding;
	bh=W7TpvqGrz04otehW9BPhDkn1ECsn2bQCSMhkfPgKOyA=;
	b=ko8zV5B7UqCd45wjZizeL0Wm0Yt5CYx96DlqXnXDPlH1fIERPeF5lfBgP9ECtH6EH5
	Rr6zsYHE0aFbzwoBCzSqOTR4ZrhWQ/aHTa57UGFU5C/NmK+Hfp0tk+IG/mfkmelufV+w
	BJOw+sgriv8Q9yc6lNGyDHW1kofGoZRGpNS5VCVUtpGw4ybg7TtMQZ7YnoWFidLbYTyv
	lDO6OC7doqmZouQuWjv5a9V6sSzK+eNOi25Isnmr4gA4ru9LpqH4geS8qiYKXhRzHh6r
	PXelZYg/O+U0b2kWhbxzUQIN1Ox5wkfU9Dox1kch2gSZPtyyE6zTajOfF5vHuLud06RN
	8bpw==
X-Gm-Message-State: AOAM533khqWCjbG4uHflY6MYovJ9VUPLlDEPTEAR8chip0+svUrcqwBN
	aAv9FrftsAeXRporNpgjYfrZdjOH71nieiuUO9JKEHqaUxCw+8TsQv64vIQOtug5fkLz7uAxI7b
	d4PUTbpecuugtlQ==
X-Received: by 2002:a05:622a:1828:: with SMTP id
	t40mr2055979qtc.0.1636406729805; 
	Mon, 08 Nov 2021 13:25:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxTf9eWxWzxdB+GBDlg+lz8e3uJ2Sr3lNLecaQE3xf5NzhVYRaDToWPOIlVifcLZALUzR0mxw==
X-Received: by 2002:a05:622a:1828:: with SMTP id
	t40mr2055960qtc.0.1636406729617; 
	Mon, 08 Nov 2021 13:25:29 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	o126sm768581qke.11.2021.11.08.13.25.29
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 08 Nov 2021 13:25:29 -0800 (PST)
Date: Mon, 8 Nov 2021 16:25:28 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YYmVyArwFwN/FdfA@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Michael =?iso-8859-1?Q?Wei=DF?= <michael.weiss@aisec.fraunhofer.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Cai Huoqing <caihuoqing@baidu.com>, Christoph Hellwig <hch@lst.de>,
	Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] [git pull] device mapper changes for 5.16
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgTGludXMsCgpUaGUgZm9sbG93aW5nIGNoYW5nZXMgc2luY2UgY29tbWl0IGQyMDhiODk0MDFl
MDczZGU5ODZkYzg5MTAzN2M1YTY2OGY1ZDVkOTU6CgogIGRtOiBmaXggbWVtcG9vbCBOVUxMIHBv
aW50ZXIgcmFjZSB3aGVuIGNvbXBsZXRpbmcgSU8gKDIwMjEtMTAtMTIgMTM6NTQ6MTAgLTA0MDAp
CgphcmUgYXZhaWxhYmxlIGluIHRoZSBHaXQgcmVwb3NpdG9yeSBhdDoKCiAgZ2l0Oi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RldmljZS1tYXBwZXIvbGludXgtZG0u
Z2l0IHRhZ3MvZm9yLTUuMTYvZG0tY2hhbmdlcwoKZm9yIHlvdSB0byBmZXRjaCBjaGFuZ2VzIHVw
IHRvIDc1NTI3NTBkMDQ5NGZkZDEyZjcxYWNkOGE0MzJmNTEzMzRhNDQ2MmQ6CgogIGRtIHRhYmxl
OiBsb2cgdGFibGUgY3JlYXRpb24gZXJyb3IgY29kZSAoMjAyMS0xMS0wMSAxMzoyODo1MiAtMDQw
MCkKClBsZWFzZSBwdWxsLCB0aGFua3MuCk1pa2UKCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KLSBBZGQgRE0gY29yZSBzdXBw
b3J0IGZvciBlbWl0dGluZyBhdWRpdCBldmVudHMgdGhyb3VnaCB0aGUgYXVkaXQKICBzdWJzeXN0
ZW0uIEFsc28gZW5oYW5jZSBib3RoIHRoZSBpbnRlZ3JpdHkgYW5kIGNyeXB0IHRhcmdldHMgdG8g
ZW1pdAogIGV2ZW50cyB0byB2aWEgZG0tYXVkaXQuCgotIFZhcmlvdXMgb3RoZXIgc2ltcGxlIGNv
ZGUgaW1wcm92ZW1lbnRzIGFuZCBjbGVhbnVwcy4KCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KQ2FpIEh1b3FpbmcgKDIpOgog
ICAgICBkbSBjcnlwdDogTWFrZSB1c2Ugb2YgdGhlIGhlbHBlciBtYWNybyBrdGhyZWFkX3J1bigp
CiAgICAgIGRtIHdyaXRlY2FjaGU6IE1ha2UgdXNlIG9mIHRoZSBoZWxwZXIgbWFjcm8ga3RocmVh
ZF9ydW4oKQoKQ2hyaXN0b3BoIEhlbGx3aWcgKDQpOgogICAgICBkbSBpbnRlZ3JpdHk6IHVzZSBi
dmVjX2ttYXBfbG9jYWwgaW4gaW50ZWdyaXR5X21ldGFkYXRhCiAgICAgIGRtIGludGVncml0eTog
dXNlIGJ2ZWNfa21hcF9sb2NhbCBpbiBfX2pvdXJuYWxfcmVhZF93cml0ZQogICAgICBkbSBsb2cg
d3JpdGVzOiB1c2UgbWVtY3B5X2Zyb21fYnZlYyBpbiBsb2dfd3JpdGVzX21hcAogICAgICBkbSB2
ZXJpdHk6IHVzZSBidmVjX2ttYXBfbG9jYWwgaW4gdmVyaXR5X2Zvcl9idl9ibG9jawoKQ2hyaXN0
b3BoZSBKQUlMTEVUICgxKToKICAgICAgZG06IFJlbW92ZSByZWR1bmRhbnQgZmx1c2hfd29ya3F1
ZXVlKCkgY2FsbHMKCkx1aXMgQ2hhbWJlcmxhaW4gKDEpOgogICAgICBkbTogYWRkIGFkZF9kaXNr
KCkgZXJyb3IgaGFuZGxpbmcKCk1pY2hhZWwgV2Vpw58gKDMpOgogICAgICBkbTogaW50cm9kdWNl
IGF1ZGl0IGV2ZW50IG1vZHVsZSBmb3IgZGV2aWNlIG1hcHBlcgogICAgICBkbSBpbnRlZ3JpdHk6
IGxvZyBhdWRpdCBldmVudHMgZm9yIGRtLWludGVncml0eSB0YXJnZXQKICAgICAgZG0gY3J5cHQ6
IGxvZyBhZWFkIGludGVncml0eSB2aW9sYXRpb25zIHRvIGF1ZGl0IHN1YnN5c3RlbQoKTWljaGHF
giBNaXJvc8WCYXcgKDIpOgogICAgICBkbTogbWFrZSB3b3JrcXVldWUgbmFtZXMgZGV2aWNlLXNw
ZWNpZmljCiAgICAgIGRtIHRhYmxlOiBsb2cgdGFibGUgY3JlYXRpb24gZXJyb3IgY29kZQoKIGRy
aXZlcnMvbWQvS2NvbmZpZyAgICAgICAgICAgIHwgMTAgKysrKysrCiBkcml2ZXJzL21kL01ha2Vm
aWxlICAgICAgICAgICB8ICA0ICsrKwogZHJpdmVycy9tZC9kbS1hdWRpdC5jICAgICAgICAgfCA4
NCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCiBkcml2ZXJzL21k
L2RtLWF1ZGl0LmggICAgICAgICB8IDY2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysKIGRyaXZlcnMvbWQvZG0tYnVmaW8uYyAgICAgICAgIHwgIDEgLQogZHJpdmVycy9tZC9kbS1j
cnlwdC5jICAgICAgICAgfCAyNSArKysrKysrKystLS0tCiBkcml2ZXJzL21kL2RtLWludGVncml0
eS5jICAgICB8IDM1ICsrKysrKysrKysrKystLS0tLQogZHJpdmVycy9tZC9kbS1sb2ctd3JpdGVz
LmMgICAgfCAgNiArKy0tCiBkcml2ZXJzL21kL2RtLXRhYmxlLmMgICAgICAgICB8ICA0ICstLQog
ZHJpdmVycy9tZC9kbS12ZXJpdHktdGFyZ2V0LmMgfCAgNiArKy0tCiBkcml2ZXJzL21kL2RtLXdy
aXRlY2FjaGUuYyAgICB8ICA2ICsrLS0KIGRyaXZlcnMvbWQvZG0tem9uZWQtdGFyZ2V0LmMgIHwg
IDEgLQogZHJpdmVycy9tZC9kbS5jICAgICAgICAgICAgICAgfCAgNiArKy0tCiBpbmNsdWRlL3Vh
cGkvbGludXgvYXVkaXQuaCAgICB8ICAyICsrCiAxNCBmaWxlcyBjaGFuZ2VkLCAyMjQgaW5zZXJ0
aW9ucygrKSwgMzIgZGVsZXRpb25zKC0pCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9tZC9k
bS1hdWRpdC5jCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9tZC9kbS1hdWRpdC5oCgotLQpk
bS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4u
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

