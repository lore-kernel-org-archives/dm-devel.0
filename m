Return-Path: <SRS0=9wY3=H7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE51C433E0
	for <dm-devel@archiver.kernel.org>; Mon,  1 Mar 2021 16:40:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1214464DE5
	for <dm-devel@archiver.kernel.org>; Mon,  1 Mar 2021 16:40:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1214464DE5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-SmwBSyLZMRa1yptAsUIhNQ-1; Mon, 01 Mar 2021 11:40:25 -0500
X-MC-Unique: SmwBSyLZMRa1yptAsUIhNQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44839801965;
	Mon,  1 Mar 2021 16:40:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 78CDD6C940;
	Mon,  1 Mar 2021 16:40:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1D35418095CB;
	Mon,  1 Mar 2021 16:40:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 121GeD4K031697 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Mar 2021 11:40:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B8D6C30BA1; Mon,  1 Mar 2021 16:40:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B144C30B86
	for <dm-devel@redhat.com>; Mon,  1 Mar 2021 16:40:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0C22100AFE4
	for <dm-devel@redhat.com>; Mon,  1 Mar 2021 16:40:10 +0000 (UTC)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com
	[209.85.167.44]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-333-5gsC5ceNP6CbVyzwWenQWQ-1; Mon, 01 Mar 2021 11:40:08 -0500
X-MC-Unique: 5gsC5ceNP6CbVyzwWenQWQ-1
Received: by mail-lf1-f44.google.com with SMTP id d3so26495658lfg.10
	for <dm-devel@redhat.com>; Mon, 01 Mar 2021 08:40:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc:content-transfer-encoding;
	bh=CNwzyYvYWC4l1BSyU4TwBmZ2Ign7WLOUb9FZbNexJt8=;
	b=NgkMELeGBNgK20IpN5tvVDnOaLwYk+6ysyaqWBAZdgUbabzfajZIRkXwpjspojFhuE
	ZnNYg5KwpCtyAtrRoV5wx/PvMikb5OEhyEIun2o12qtptqwcZSSA+SFhWuOu2WSKcqZW
	zJaWZwkZJbAa25EQmNFCj2KoY3ZOWreRnMAIs4hV/JZ5llrinUkBO616NHlkvqo1VEUT
	7bP1dMTGQigzVLbirtBIQXo4Hytgr5GONuIFe2tnMR3vF4KuXVRtOZ1thrlRusfflt0a
	piKZxV0bwIOJp3gmd8OhAVp3fmKQzpOj2Y4bHluJ3GL6OxN/xmB4X+NA8jZA11/Y7Erv
	1Y7g==
X-Gm-Message-State: AOAM531GgxdWmOA58ZD459OGQpmGJXVlhT8onovcbHUnF1GHY4/s25Sg
	/JivhSb5J/4eq7mIlGyFv34/J+lORrKceBA6LmA0gJ7c
X-Google-Smtp-Source: ABdhPJzVAMZSgB92HaEDjboTmr6crv0mEJBJTpsL90xX/PSE5E6IBkdvpNNQNTwLBzBalWFimcLAQarACFXJ3jXtMIQ=
X-Received: by 2002:a19:6d0:: with SMTP id 199mr9315296lfg.18.1614616806982;
	Mon, 01 Mar 2021 08:40:06 -0800 (PST)
MIME-Version: 1.0
References: <388321540.261431070.1614606275832.JavaMail.zimbra@cines.fr>
In-Reply-To: <388321540.261431070.1614606275832.JavaMail.zimbra@cines.fr>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Mon, 1 Mar 2021 10:39:55 -0600
Message-ID: <CAAMCDecdJ6e1KZT0ritgYV18unRphm_QP4-UWvCLOuKCYaOH7g@mail.gmail.com>
To: bchatelain@cines.fr
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 121GeD4K031697
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] multipath with SAS and FC.
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

WW91IGNhbiB1c2UgYWN0aXZlL2FjdGl2ZSBvbiBGQyBhbmQgb24gU0FTLgoKQnV0IHNvbWUgY2hl
YXBlci9zaW1wbGVyIGFycmF5cy9kZXZpY2VzIGFyZSBub3QgYWN0aXZlL2FjdGl2ZSwgdGhleQph
cmUgYWN0aXZlL3Bhc3NpdmUgYW5kIHRoYXQgcmVxdWlyZXMgYSBzY3NpX2RoKiBtb2R1bGUgdG8g
aGFuZGxlIHRoZQpub24tYWN0aXZlL25vbi1yZXNwb25kaW5nIHBhdGggY29ycmVjdGx5LiAgSSBk
b24ndCBrbm93IGlmIHlvdXJzIGlzCm9uZSBvZiB0aG9zZS4KCllvdSB3aWxsIG5lZWQgdG8gZmlu
ZCB0aGUgdmVuZG9ycyBob3ctdG8gZG9jIG9uIHRoZSByZXF1aXJlZCBjb25maWcKb3B0aW9ucyBh
cyBzb21lIG9wdGlvbnMgd2lsbCBub3Qgd29yayBvbiBzb21lIGRldmljZXMsIGFuZCBpbiBzb21l
CmNhc2VzIHRoZXJlIG1heSBuZWVkIHRvIGFsc28gYmUgdGhpbmdzIHNldCBpbiB0aGUgYXJyYXkg
aXRzZWxmIHRvCmFsbG93IGNlcnRhaW4gdGhpbmdzIG11bHRpcGF0aCBuZWVkcyB0byBkby4KCk9u
IE1vbiwgTWFyIDEsIDIwMjEgYXQgNzo1NCBBTSA8YmNoYXRlbGFpbkBjaW5lcy5mcj4gd3JvdGU6
Cj4KPiBIZWxsbywKPgo+IEkgdHJ5IHRvIHVzZSBtdWx0aXBhdGggd2l0aCBTQVMgZGlzaywgdHJh
bnNwb3J0ZWQgYnkgRmliZXIgQ2hhbm5lbCwgb24KPiBEZWxsIENvbXBlbGxlbnQuCj4gTXkgdm9s
dW1lIGlzIGRldGVjdGVkIG9uIDJ4IFI0NDAgUG93ZXJFZGdlIGhvc3RlZCBieSBDZW50b3MgOCBh
bmQKPiBvcmNoZXN0cmF0ZWQgYnkgb1ZpcnQuCj4KPgo+IFByb2JsZW1hdGljIDoKPgo+IE9uIG15
IHR3byBvdmlydCBub2RlIHdpdGggdGhlIHNhbWUgY29uZmlndXJhdGlvbiBhbmQgaGFyZHdhcmUK
PiBzcGVjaWZpY2F0aW9ucywKPiBJIGdpdmUgdGhpcyBzYW1lIGJlaGF2b3IsIG9uZSBvZiBteSB0
d28gbGluaywgaXMgZmxhcHBpbmcgQUNUSVZFIHRvIEZBSUxFRAo+Cj4gU29tZXRoaW5nIGxpa2Ug
dGhpcyA6Cj4gIyBtdWx0aXBhdGggLWxsCj4gMzYwMDBkMzEwMDNkNWMyMDAwMDAwMDAwMDAwMDAw
MDEwIGRtLTMgQ09NUEVMTlQsQ29tcGVsbGVudCBWb2wKPiBzaXplPTEuNVQgZmVhdHVyZXM9JzEg
cXVldWVfaWZfbm9fcGF0aCcgaHdoYW5kbGVyPScxIGFsdWEnIHdwPXJ3Cj4gYC0rLSBwb2xpY3k9
J3NlcnZpY2UtdGltZSAwJyBwcmlvPTI1IHN0YXR1cz1hY3RpdmUKPiAgICB8LSAxOjA6MDoyIHNk
YiA4OjE2IGFjdGl2ZSByZWFkeSBydW5uaW5nCj4gICAgYC0gMTowOjE6MiBzZGMgODozMiBmYWls
ZWQgcmVhZHkgcnVubmluZyAgIC0tIGxvb3BpbmcgZmFpbGVkL3JlYWR5Cj4KPgo+IFNvbWUgaW50
ZXJlc3Rpbmcgc3R1ZmYgOgo+Cj4gIyBtdWx0aXBhdGhkIHNob3cgY29uZmlnIDogRnVsbCBAIGh0
dHBzOi8vcGFzdGViaW4uZnIvODU5NjUKPgo+IGJsYWNrbGlzdCB7Cj4gwrfCt8K3Cj4gICAgICBk
ZXZpY2Ugewo+ICAgICAgICAgIHZlbmRvciAiQ09NUEVMTlQiCj4gICAgICAgICAgcHJvZHVjdCAi
Q29tcGVsbGVudCBWb2wiCj4gICAgICAgICAgcGF0aF9ncm91cGluZ19wb2xpY3kgIm11bHRpYnVz
Igo+ICAgICAgICAgIG5vX3BhdGhfcmV0cnkgInF1ZXVlIgo+ICAgICAgfQo+IMK3wrfCtwo+IH0K
Pgo+ICBMb2daIDogRnVsbCBAIGh0dHBzOi8vcGFzdGViaW4uZnIvODU5NjgKPiBGZWIgMjUgMTE6
NDg6MjQgaXNpbGR1ci1hZG0ga2VybmVsOiBkZXZpY2UtbWFwcGVyOiBtdWx0aXBhdGg6IDI1Mzoz
OiBSZWluc3RhdGluZyBwYXRoIDg6MzIuCj4gRmViIDI1IDExOjQ4OjI0IGlzaWxkdXItYWRtIGtl
cm5lbDogc2QgMTowOjE6MjogYWx1YTogcG9ydCBncm91cCBmMDFjIHN0YXRlIFMgbm9uLXByZWZl
cnJlZCBzdXBwb3J0cyB0b2x1U05BCj4gRmViIDI1IDExOjQ4OjI0IGlzaWxkdXItYWRtIGtlcm5l
bDogZGV2aWNlLW1hcHBlcjogbXVsdGlwYXRoOiAyNTM6MzogRmFpbGluZyBwYXRoIDg6MzIuCj4g
RmViIDI1IDExOjQ4OjI1IGlzaWxkdXItYWRtIG11bHRpcGF0aGRbNjU5NDYwXTogc2RjOiBtYXJr
IGFzIGZhaWxlZAo+Cj4KPiAgIyBsc3Njc2kgLWwKPiBbMDoyOjA6MF0gICAgZGlzayAgICBERUxM
ICAgICBQRVJDIEgzMzAgQWRwICAgIDQuMzAgIC9kZXYvc2RhCj4gICAgc3RhdGU9cnVubmluZyBx
dWV1ZV9kZXB0aD0yNTYgc2NzaV9sZXZlbD02IHR5cGU9MCBkZXZpY2VfYmxvY2tlZD0wIHRpbWVv
dXQ9OTAKPiBbMTowOjA6Ml0gICAgZGlzayAgICBDT01QRUxOVCBDb21wZWxsZW50IFZvbCAgIDA3
MDQgIC9kZXYvc2RiCj4gICAgc3RhdGU9cnVubmluZyBxdWV1ZV9kZXB0aD0yNTQgc2NzaV9sZXZl
bD02IHR5cGU9MCBkZXZpY2VfYmxvY2tlZD0wIHRpbWVvdXQ9MzAKPiBbMTowOjE6Ml0gICAgZGlz
ayAgICBDT01QRUxOVCBDb21wZWxsZW50IFZvbCAgIDA3MDQgIC9kZXYvc2RjCj4gICAgc3RhdGU9
cnVubmluZyBxdWV1ZV9kZXB0aD0yNTQgc2NzaV9sZXZlbD02IHR5cGU9MCBkZXZpY2VfYmxvY2tl
ZD0wIHRpbWVvdXQ9MzAKPgo+Cj4gICMgbHNtb2QgfCBncmVwIGZjCj4gYm54MmZjICAgICAgICAg
ICAgICAgIDExMDU5MiAgMAo+IGNuaWMgICAgICAgICAgICAgICAgICAgNjk2MzIgIDEgYm54MmZj
Cj4gbGliZmNvZSAgICAgICAgICAgICAgICA3NzgyNCAgMiBxZWRmLGJueDJmYwo+IGxpYmZjICAg
ICAgICAgICAgICAgICAxNDc0NTYgIDMgcWVkZixibngyZmMsbGliZmNvZQo+IHNjc2lfdHJhbnNw
b3J0X2ZjICAgICAgNjk2MzIgIDMgcWVkZixsaWJmYyxibngyZmMKPgo+Cj4gICMgbHNtb2QgfCBn
cmVwIHNhcwo+IG1wdDNzYXMgIDMwMzEwNCA0Cj4gcmFpZF9jbGFzcyAgMTYzODQgMSBtcHQzc2Fz
Cj4gbWVnYXJhaWRfc2FzICAxNzIwMzIgMgo+IHNjc2lfdHJhbnNwb3J0X3NhcyAgNDUwNTYgMW1w
dDNzYXMKPgo+Cj4KPiBJJ3ZlIG1hZGUgYSBtaXNjb25maWd1cmF0aW9uID8KPiBJcyBJdCBwb3Nz
aWJsZSB0byB1c2UgU0FTIG92ZXIgRkMgPwo+Cj4gVGhhbmsgeW91Lgo+Cj4KPiBSZWdhcmRzLAo+
IEJlbm9pdCBDaGF0ZWxhaW4uCj4KPgo+IC0tCj4gZG0tZGV2ZWwgbWFpbGluZyBsaXN0Cj4gZG0t
ZGV2ZWxAcmVkaGF0LmNvbQo+IGh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWwKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

