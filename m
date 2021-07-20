Return-Path: <SRS0=+Jjt=MN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB4FC07E9B
	for <dm-devel@archiver.kernel.org>; Wed, 21 Jul 2021 07:57:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 377DF61181
	for <dm-devel@archiver.kernel.org>; Wed, 21 Jul 2021 07:57:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 377DF61181
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-bsMe-IvdP-G8ukedbwXhhg-1; Wed, 21 Jul 2021 03:57:16 -0400
X-MC-Unique: bsMe-IvdP-G8ukedbwXhhg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11EC2192D786;
	Wed, 21 Jul 2021 07:57:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1FF1189BB;
	Wed, 21 Jul 2021 07:57:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 797BA1801028;
	Wed, 21 Jul 2021 07:57:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16K9csGD013849 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 20 Jul 2021 05:38:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 52A9D214182A; Tue, 20 Jul 2021 09:38:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E4C32141829
	for <dm-devel@redhat.com>; Tue, 20 Jul 2021 09:38:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B91D80018D
	for <dm-devel@redhat.com>; Tue, 20 Jul 2021 09:38:51 +0000 (UTC)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com
	[209.85.208.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-439-5TjNMPvfMdmlgDybuD6jSQ-1; Tue, 20 Jul 2021 05:38:47 -0400
X-MC-Unique: 5TjNMPvfMdmlgDybuD6jSQ-1
Received: by mail-ed1-f53.google.com with SMTP id ee25so27633428edb.5;
	Tue, 20 Jul 2021 02:38:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:from:date:message-id:subject:to
	:content-transfer-encoding;
	bh=ob2cL9xsCuqI2PtZCWk4ZnfruGA/KtiWAaZc2Xrr4AE=;
	b=BKPW/5VuKyqwBcLNiHBgIEi+3AfRma+hUyC194bGL78sRCVd+l3T0G4suFk28yK3Yj
	VUYeVpwqN26vukkCGJCYlx1lnvRlhnX8m5VPiBig2Y2rLuPXMa/5avfwfwsr2BzfjcA6
	5L/8Bj7yRdW6XHnEE7jV//4qJT5YEy3obgWKePnaeFR45t0kHbWcRWpWpTk+UIDIGA3V
	siAyeaEMGfULDI1fPowS+dUHPMIzDJsQ9BtkOoqO5ZLMzeFQBqyf2rYdR2130+Y0Gbe6
	XVbLq+npvX9NvRvcCcdnZThqQFfEFHWJbiseFE0Itfpua6QcB7dFjlVVKkszVNwaytYK
	aUIQ==
X-Gm-Message-State: AOAM531n53GoCffc9bUjiIUUVD3691rJI2sdCDgl4pTPPLmofptIxHjn
	gFVnA4u4H7hPMl+a7r2HM115/opI4mSpYtKVDRM=
X-Google-Smtp-Source: ABdhPJyFYULltN0VLmruKU6gln2nBG30ldbFf2khnefL2E+dRSChweVniLR25706q27205hxMP3yUCyt6LutA6yXFB8=
X-Received: by 2002:a05:6402:5209:: with SMTP id
	s9mr30408240edd.92.1626773925557; 
	Tue, 20 Jul 2021 02:38:45 -0700 (PDT)
MIME-Version: 1.0
From: Pintu Agarwal <pintu.ping@gmail.com>
Date: Tue, 20 Jul 2021 15:08:34 +0530
Message-ID: <CAOuPNLhqSpaTm3u4kFsnuZ0PLDKuX8wsxuF=vUJ1TEG0EP+L1g@mail.gmail.com>
To: open list <linux-kernel@vger.kernel.org>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mtd <linux-mtd@lists.infradead.org>, dm-devel@redhat.com,
	Kernelnewbies <kernelnewbies@kernelnewbies.org>, agk@redhat.com,
	snitzer@redhat.com, shli@kernel.org, mpatocka@redhat.com,
	samitolvanen@google.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 16K9csGD013849
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 21 Jul 2021 03:52:50 -0400
Subject: [dm-devel] Kernel 4.14: Using dm-verity with squashfs rootfs -
	mounting issue
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGksCgpPdXIgQVJNMzIgTGludXggZW1iZWRkZWQgc3lzdGVtIGNvbnNpc3RzIG9mIHRoZXNlOgoq
IExpbnV4IEtlcm5lbDogNC4xNAoqIFByb2Nlc3NvcjogUXVhbGNvbW0gQXJtMzIgQ29ydGV4LUE3
CiogU3RvcmFnZTogTkFORCA1MTJNQgoqIFBsYXRmb3JtOiBTaW1wbGUgYnVzeWJveAoqIEZpbGVz
eXN0ZW06IFVCSUZTLCBTcXVhc2hmcwoqIENvbnNpc3RzIG9mIG5hbmQgcmF3IHBhcnRpdGlvbnMs
IHNxdWFzaGZzIHViaSB2b2x1bWVzLgoKTXkgcmVxdWlyZW1lbnQ6CldlIHdhbnRlZCB0byB1c2Ug
ZG0tdmVyaXR5IGF0IGJvb3QgdGltZSB0byBjaGVjayB0aGUgaW50ZWdyaXR5IG9mCnNxdWFzaGZz
LXJvb3RmcyBiZWZvcmUgbW91bnRpbmcuCgpQcm9ibGVtOgpkbS0wIGlzIG5vdCBhYmxlIHRvIGxv
Y2F0ZSBhbmQgbW91bnQgdGhlIHNxdWFzaCBmcyByb290ZnMgYmxvY2suClRoZSBzYW1lIGFwcHJv
YWNoIGlzIHdvcmtpbmcgd2hlbiBlbXVsYXRpbmcgd2l0aCBleHQ0IGJ1dCBmYWlscyB3aXRoIHNx
dWFzaGZzLgoKTG9nczoKWy4uLi5dClsgICAgMC4wMDAwMDBdIEtlcm5lbCBjb21tYW5kIGxpbmU6
IFsuLi5dIHZlcml0eT0iOTYxNjAgMTIwMjAKZDdiOGE3ZDBjMDFiOWFlYzg4ODkzMDg0MTMxM2E4
MTYwM2E1MGEyYTdiZTQ0NjMxYzRjODEzMTk3YTUwZDY4MSAwICIKcm9vdGZzdHlwZT1zcXVhc2hm
cyByb290PS9kZXYvbXRkYmxvY2szNCB1YmkubXRkPTMwLDAsMzAgWy4uLl0Kcm9vdD0vZGV2L2Rt
LTAgZG09InN5c3RlbSBub25lIHJvLDAgOTYxNjAgdmVyaXR5IDEgL2Rldi9tdGRibG9jazM0Ci9k
ZXYvbXRkYmxvY2szOSA0MDk2IDQwOTYgMTIwMjAgOCBzaGEyNTYKZDdiOGE3ZDBjMDFiOWFlYzg4
ODkzMDg0MTMxM2E4MTYwM2E1MGEyYTdiZTQ0NjMxYzRjODEzMTk3YTUwZDY4MQphZWUwODdhNWJl
M2I5ODI5NzhjOTIzZjU2NmE5NDYxMzQ5NmI0MTdmMmFmNTkyNjM5YmM4MGQxNDFlMzRkZmU3Igpb
Li4uLl0KWyAgICA0LjY5MzYyMF0gdnJlZ19jb25uX3BhOiBkaXNh4paSWyAgICA0LjcwMDY2Ml0g
bWQ6IFNraXBwaW5nCmF1dG9kZXRlY3Rpb24gb2YgUkFJRCBhcnJheXMuIChyYWlkPWF1dG9kZXRl
Y3Qgd2lsbCBmb3JjZSkKWyAgICA0LjcwMDcxM10gZGV2aWNlLW1hcHBlcjogaW5pdDogYXR0ZW1w
dGluZyBlYXJseSBkZXZpY2UgY29uZmlndXJhdGlvbi4KWyAgICA0LjcwODIyNF0gZGV2aWNlLW1h
cHBlcjogaW5pdDogYWRkaW5nIHRhcmdldCAnMCA5NjE2MCB2ZXJpdHkgMQovZGV2L210ZGJsb2Nr
MzQgL2Rldi9tdGRibG9jazM5IDQwOTYgNDA5NiAxMjAyMCA4IHNoYTI1NgpkN2I4YTdkMGMwMWI5
YWVjODg4OTMwODQxMzEzYTgxNjAzYTUwYTJhN2JlNDQ2MzFjNGM4MTMxOTdhNTBkNjgxCmFlZTA4
N2E1YmUzYjk4Mjk3OGM5MjNmNTY2YTk0NjEzNDk2YjQxN2YyYWY1OTI2MzliYzgwZDE0MWUzNGRm
ZTcnClsgICAgNC43MTQ5NzldIGRldmljZS1tYXBwZXI6IHZlcml0eTogc2hhMjU2IHVzaW5nIGlt
cGxlbWVudGF0aW9uCiJzaGEyNTYtZ2VuZXJpYyIKWyAgICA0LjczNzgwOF0gZGV2aWNlLW1hcHBl
cjogaW5pdDogZG0tMCBpcyByZWFkeQpbLi4uLl0KWyAgICA1LjI3ODEwM10gTm8gZmlsZXN5c3Rl
bSBjb3VsZCBtb3VudCByb290LCB0cmllZDoKWyAgICA1LjI3ODEwN10gIHNxdWFzaGZzClsgICAg
NS4yODA0NzddClsgICAgNS4yODc2MjddIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBWRlM6
IFVuYWJsZSB0byBtb3VudCByb290CmZzIG9uIHVua25vd24tYmxvY2soMjUzLDApClsuLi5dCgpO
b3Qgc3VyZSwgd2h5IGlzIGl0IHN0aWxsIGxvY2F0aW5nIGJsb2NrICIyNTMiIGhlcmUgd2hpY2gg
c2VlbXMgbGlrZSBhCk1BSk9SIG51bWJlciA/CgpXb3JraW5nIGxvZ3Mgb24gZXh0NDoKWy4uLi5d
ClsgICAgNC41Mjk4MjJdIHbilpJbICAgIDQuNTM0MDM1XSBtZDogU2tpcHBpbmcgYXV0b2RldGVj
dGlvbiBvZiBSQUlECmFycmF5cy4gKHJhaWQ9YXV0b2RldGVjdCB3aWxsIGZvcmNlKQpbICAgIDQu
NTM0MDg3XSBkZXZpY2UtbWFwcGVyOiBpbml0OiBhdHRlbXB0aW5nIGVhcmx5IGRldmljZSBjb25m
aWd1cmF0aW9uLgpbICAgIDQuNTUwMzE2XSBkZXZpY2UtbWFwcGVyOiBpbml0OiBhZGRpbmcgdGFy
Z2V0ICcwIDM4NDQ0MCB2ZXJpdHkgMQovZGV2L3ViaWJsb2NrMF8wIC9kZXYvdWJpYmxvY2swXzAg
NDA5NiA0MDk2IDQ4MDU1IDQ4MDYzIHNoYTI1NgphMDJlMGMxM2FmYjMxZTk5Yjk5OWM2NGFhZTZm
NDY0NGMyNGFkZGJjNThkYjU2ODk5MDJjYzViYTBiZTJkMTViCmFlZTA4N2E1YmUzYjk4Mjk3OGM5
MjNmNTY2YTk0NjEzNDk2YjQxN2YyYWY1OTI2MzliYzgwZDE0MWUzNGRmZTcgMTAKcmVzdGFydF9v
bl9jb3JydXB0aW9uIGlnbm9yZV96ZXJvX2Jsb2NrcyB1c2VfZmVjX2Zyb21fZGV2aWNlCi9kZXYv
dWJpYmxvY2swXzAgZmVjX3Jvb3RzIDIgZmVjX2Jsb2NrcyA0ODQ0MyBmZWNfc3RhcnQgNDg0NDMn
ClsgICAgNC41NzIyMTVdIGRldmljZS1tYXBwZXI6IHZlcml0eTogc2hhMjU2IHVzaW5nIGltcGxl
bWVudGF0aW9uCiJzaGEyNTYtZ2VuZXJpYyIKWyAgICA0LjYxMDY5Ml0gZGV2aWNlLW1hcHBlcjog
aW5pdDogZG0tMCBpcyByZWFkeQpbICAgIDQuNzIwMTc0XSBFWFQ0LWZzIChkbS0wKTogbW91bnRl
ZCBmaWxlc3lzdGVtIHdpdGggb3JkZXJlZCBkYXRhCm1vZGUuIE9wdHM6IChudWxsKQpbICAgIDQu
NzIwNDM4XSBWRlM6IE1vdW50ZWQgcm9vdCAoZXh0NCBmaWxlc3lzdGVtKSByZWFkb25seSBvbiBk
ZXZpY2UgMjUzOjAuClsgICAgNC43MzcyNTZdIGRldnRtcGZzOiBtb3VudGVkClsuLi4uXQoKUXVl
c3Rpb25zOgphKSBJcyBkbS12ZXJpdHkgc3VwcG9zZWQgdG8gd29yayBvbiBzcXVhc2hmcyBibG9j
ayBkZXZpY2VzID8KYikgQXJlIHRoZXJlIGFueSBrbm93biBpc3N1ZXMgd2l0aCBkbS12ZXJpdHkg
b24gS2VybmVsIDQuMTQgPwpjKSBBcmUgdGhlcmUgYW55IHBhdGNoZXMgdGhhdCB3ZSBhcmUgbWlz
c2luZyA/CgoKVGhhbmtzLApQaW50dQoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWw=

