Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6C8C433E0
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 18:56:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F036C22D04
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 18:56:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F036C22D04
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-5EGkXRJTM8C0e72z2iUEmQ-1; Tue, 05 Jan 2021 13:56:43 -0500
X-MC-Unique: 5EGkXRJTM8C0e72z2iUEmQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFC8C80362C;
	Tue,  5 Jan 2021 18:56:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B2E3E5D6CF;
	Tue,  5 Jan 2021 18:56:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 853D9180954D;
	Tue,  5 Jan 2021 18:56:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 105ENEMj011871 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 5 Jan 2021 09:23:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8E3CB2026D48; Tue,  5 Jan 2021 14:23:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 884622026D3B
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 14:23:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3690185A7BC
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 14:23:09 +0000 (UTC)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com
	[209.85.218.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-566-GFnXxdUdMdWlh3mGLn-7sw-1; Tue, 05 Jan 2021 09:23:03 -0500
X-MC-Unique: GFnXxdUdMdWlh3mGLn-7sw-1
Received: by mail-ej1-f46.google.com with SMTP id ce23so41407417ejb.8;
	Tue, 05 Jan 2021 06:23:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc:content-transfer-encoding;
	bh=j1NvKmtJGKiFDjjXKZ0rVwy5v3Z3i/GAMZvpNKKRLfc=;
	b=AwOFXWglLrPA5tpd19nJit6lrRCGg8PkQidcAi2aiWQUTEyiehZkyOvikQfpRf7fw/
	D9yYy6qyV0t+SFB4snT8H4Wd/XINPqj0MD1CAZe6qxXG2uzKUr6+Ls4BCKCl+5NRRm6U
	9CmnbDFDUPA+tQKtI01dilo4/P2gVzZ9JKb/aiJf3piRmIfzRylX+jHZAsjXnIe0cXDM
	HwehvNB9GZ4ahySERohVLqZr6bQXH11q1BRbutDmG5VnZq0aciouH3rlrld/V3fcRNs0
	OZJ/gB5JLpO349DQnP4CoAV9I4KkYg5ywuzwiDA4zYHM/9vSwia2fZXsl04mDdcWKDyR
	GlWA==
X-Gm-Message-State: AOAM533Bj6FTlAhTY132pnYJ47z2P1bOCGcX9PaP/LBbom6fsfq0sESX
	lfODm7MVGbDCXH4XT7f5GB07NwzVzIf5Fnpyozk=
X-Google-Smtp-Source: ABdhPJwnxRqHv2aMqHMbFt0kXTvzZaOUW+aFB6JjMi14SNUWLSvVqm2hXOLS8N/UvGELnDV/oZP5zanvNoGhzXZMTZI=
X-Received: by 2002:a17:907:271c:: with SMTP id
	w28mr70922796ejk.140.1609856581820; 
	Tue, 05 Jan 2021 06:23:01 -0800 (PST)
MIME-Version: 1.0
References: <20210104104159.74236-1-selvakuma.s1@samsung.com>
	<CGME20210104104249epcas5p458d1b5c39b5acfad4e7786eca5dd5c49@epcas5p4.samsung.com>
	<20210104104159.74236-3-selvakuma.s1@samsung.com>
	<BL0PR04MB651402CFA75F72826AC8EE1CE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
	<20210104190254.GB6919@magnolia>
In-Reply-To: <20210104190254.GB6919@magnolia>
From: Selva Jove <selvajove@gmail.com>
Date: Tue, 5 Jan 2021 19:52:48 +0530
Message-ID: <CAHqX9vYCRpX9FSCEaf2+xbYkB-zm7wRTmUka9zGs4D1T6nZb_A@mail.gmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 105ENEMj011871
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 05 Jan 2021 13:56:30 -0500
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"hch@lst.de" <hch@lst.de>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>
Subject: Re: [dm-devel] [RFC PATCH v4 2/3] block: add simple copy support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgRGFycmljaywKCgpPbiBUdWUsIEphbiA1LCAyMDIxIGF0IDEyOjMzIEFNIERhcnJpY2sgSi4g
V29uZyA8ZGFycmljay53b25nQG9yYWNsZS5jb20+IHdyb3RlOgo+Cj4gU2VsdmFLdW1hciBTOiBU
aGlzIGRpZG4ndCBzaG93IHVwIG9uIGRtLWRldmVsLCBzb3JyeSBmb3IgdGhlIE9UIHJlcGx5Li4u
Cj4KPiBPbiBNb24sIEphbiAwNCwgMjAyMSBhdCAxMjo0NzoxMVBNICswMDAwLCBEYW1pZW4gTGUg
TW9hbCB3cm90ZToKPiA+IE9uIDIwMjEvMDEvMDQgMTk6NDgsIFNlbHZhS3VtYXIgUyB3cm90ZToK
PiA+ID4gQWRkIG5ldyBCTEtDT1BZIGlvY3RsIHRoYXQgb2ZmbG9hZHMgY29weWluZyBvZiBvbmUg
b3IgbW9yZSBzb3VyY2VzCj4gPiA+IHJhbmdlcyB0byBhIGRlc3RpbmF0aW9uIGluIHRoZSBkZXZp
Y2UuIEFjY2VwdHMgY29weV9yYW5nZXMgdGhhdCBjb250YWlucwo+ID4gPiBkZXN0aW5hdGlvbiwg
bm8gb2Ygc291cmNlcyBhbmQgcG9pbnRlciB0byB0aGUgYXJyYXkgb2Ygc291cmNlCj4gPiA+IHJh
bmdlcy4gRWFjaCByYW5nZV9lbnRyeSBjb250YWlucyBzdGFydCBhbmQgbGVuZ3RoIG9mIHNvdXJj
ZQo+ID4gPiByYW5nZXMgKGluIGJ5dGVzKS4KPiA+ID4KPiA+ID4gSW50cm9kdWNlIFJFUV9PUF9D
T1BZLCBhIG5vLW1lcmdlIGNvcHkgb2ZmbG9hZCBvcGVyYXRpb24uIENyZWF0ZQo+ID4gPiBiaW8g
d2l0aCBjb250cm9sIGluZm9ybWF0aW9uIGFzIHBheWxvYWQgYW5kIHN1Ym1pdCB0byB0aGUgZGV2
aWNlLgo+ID4gPiBSRVFfT1BfQ09QWSgxOSkgaXMgYSB3cml0ZSBvcCBhbmQgdGFrZXMgem9uZV93
cml0ZV9sb2NrIHdoZW4gc3VibWl0dGVkCj4gPiA+IHRvIHpvbmVkIGRldmljZS4KPiA+ID4KPiA+
ID4gSWYgdGhlIGRldmljZSBkb2Vzbid0IHN1cHBvcnQgY29weSBvciBjb3B5IG9mZmxvYWQgaXMg
ZGlzYWJsZWQsIHRoZW4KPiA+ID4gY29weSBpcyBlbXVsYXRlZCBieSBhbGxvY2F0aW5nIG1lbW9y
eSBvZiB0b3RhbCBjb3B5IHNpemUuIFRoZSBzb3VyY2UKPiA+ID4gcmFuZ2VzIGFyZSByZWFkIGlu
dG8gbWVtb3J5IGJ5IGNoYWluaW5nIGJpbyBmb3IgZWFjaCBzb3VyY2UgcmFuZ2VzIGFuZAo+ID4g
PiBzdWJtaXR0aW5nIHRoZW0gYXN5bmMgYW5kIHRoZSBsYXN0IGJpbyB3YWl0cyBmb3IgY29tcGxl
dGlvbi4gQWZ0ZXIgZGF0YQo+ID4gPiBpcyByZWFkLCBpdCBpcyB3cml0dGVuIHRvIHRoZSBkZXN0
aW5hdGlvbi4KPiA+ID4KPiA+ID4gYmlvX21hcF9rZXJuKCkgaXMgdXNlZCB0byBhbGxvY2F0ZSBi
aW8gYW5kIGFkZCBwYWdlcyBvZiBjb3B5IGJ1ZmZlciB0bwo+ID4gPiBiaW8uIEFzIGJpby0+Ymlf
cHJpdmF0ZSBhbmQgYmlvLT5iaV9lbmRfaW8gaXMgbmVlZGVkIGZvciBjaGFpbmluZyB0aGUKPiA+
ID4gYmlvIGFuZCBvdmVyIHdyaXR0ZW4sIGludmFsaWRhdGVfa2VybmVsX3ZtYXBfcmFuZ2UoKSBm
b3IgcmVhZCBpcyBjYWxsZWQKPiA+ID4gaW4gdGhlIGNhbGxlci4KPiA+ID4KPiA+ID4gSW50cm9k
dWNlIHF1ZXVlIGxpbWl0cyBmb3Igc2ltcGxlIGNvcHkgYW5kIG90aGVyIGhlbHBlciBmdW5jdGlv
bnMuCj4gPiA+IEFkZCBkZXZpY2UgbGltaXRzIGFzIHN5c2ZzIGVudHJpZXMuCj4gPiA+ICAgICAt
IGNvcHlfb2ZmbG9hZAo+ID4gPiAgICAgLSBtYXhfY29weV9zZWN0b3JzCj4gPiA+ICAgICAtIG1h
eF9jb3B5X3Jhbmdlc19zZWN0b3JzCj4gPiA+ICAgICAtIG1heF9jb3B5X25yX3Jhbmdlcwo+ID4g
Pgo+ID4gPiBjb3B5X29mZmxvYWQoPSAwKSBpcyBkaXNhYmxlZCBieSBkZWZhdWx0Lgo+ID4gPiBt
YXhfY29weV9zZWN0b3JzID0gMCBpbmRpY2F0ZXMgdGhlIGRldmljZSBkb2Vzbid0IHN1cHBvcnQg
bmF0aXZlIGNvcHkuCj4gPiA+Cj4gPiA+IE5hdGl2ZSBjb3B5IG9mZmxvYWQgaXMgbm90IHN1cHBv
cnRlZCBmb3Igc3RhY2tlZCBkZXZpY2VzIGFuZCBpcyBkb25lIHZpYQo+ID4gPiBjb3B5IGVtdWxh
dGlvbi4KPiA+ID4KPiA+ID4gU2lnbmVkLW9mZi1ieTogU2VsdmFLdW1hciBTIDxzZWx2YWt1bWEu
czFAc2Ftc3VuZy5jb20+Cj4gPiA+IFNpZ25lZC1vZmYtYnk6IEthbmNoYW4gSm9zaGkgPGpvc2hp
LmtAc2Ftc3VuZy5jb20+Cj4gPiA+IFNpZ25lZC1vZmYtYnk6IE5pdGVzaCBTaGV0dHkgPG5qLnNo
ZXR0eUBzYW1zdW5nLmNvbT4KPiA+ID4gU2lnbmVkLW9mZi1ieTogSmF2aWVyIEdvbnrDoWxleiA8
amF2aWVyLmdvbnpAc2Ftc3VuZy5jb20+Cj4gPiA+IC0tLQo+ID4gPiAgYmxvY2svYmxrLWNvcmUu
YyAgICAgICAgICB8ICA5NCArKysrKysrKysrKysrKy0tCj4gPiA+ICBibG9jay9ibGstbGliLmMg
ICAgICAgICAgIHwgMjIzICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4g
PiA+ICBibG9jay9ibGstbWVyZ2UuYyAgICAgICAgIHwgICAyICsKPiA+ID4gIGJsb2NrL2Jsay1z
ZXR0aW5ncy5jICAgICAgfCAgMTAgKysKPiA+ID4gIGJsb2NrL2Jsay1zeXNmcy5jICAgICAgICAg
fCAgNTAgKysrKysrKysrCj4gPiA+ICBibG9jay9ibGstem9uZWQuYyAgICAgICAgIHwgICAxICsK
PiA+ID4gIGJsb2NrL2JvdW5jZS5jICAgICAgICAgICAgfCAgIDEgKwo+ID4gPiAgYmxvY2svaW9j
dGwuYyAgICAgICAgICAgICB8ICA0MyArKysrKysrKwo+ID4gPiAgaW5jbHVkZS9saW51eC9iaW8u
aCAgICAgICB8ICAgMSArCj4gPiA+ICBpbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oIHwgIDE1ICsr
Kwo+ID4gPiAgaW5jbHVkZS9saW51eC9ibGtkZXYuaCAgICB8ICAxMyArKysKPiA+ID4gIGluY2x1
ZGUvdWFwaS9saW51eC9mcy5oICAgfCAgMTMgKysrCj4KPiBUaGlzIHNlcmllcyBzaG91bGQgYWxz
byBiZSBjYydkIHRvIGxpbnV4LWFwaSBzaW5jZSB5b3UncmUgYWRkaW5nIGEgbmV3Cj4gdXNlcnNw
YWNlIGFwaS4KPgoKU3VyZS4gV2lsbCBjYyBsaW51eC1hcGkKCj4KPiBBbHRlcm5hdGVseSwgc2F2
ZSB5b3Vyc2VsZiB0aGUgdHJvdWJsZSBvZiBwYXNzaW5nIHVzZXJzcGFjZSBBUEkgcmV2aWV3Cj4g
YnkgaG9va2luZyB0aGlzIHVwIHRvIHRoZSBleGlzdGluZyBjb3B5X2ZpbGVfcmFuZ2UgY2FsbCBp
biB0aGUgdmZzLiAgL21lCj4gaG9wZXMgeW91IHNlbnQgYmxrdGVzdHMgdG8gY2hlY2sgdGhlIG9w
ZXJhdGlvbiBvZiB0aGlzIHRoaW5nLCBzaW5jZSBub25lCj4gb2YgdGhlIG9yaWdpbmFsIHBhdGNo
ZXMgbWFkZSBpdCB0byB0aGlzIGxpc3QuCj4KCkFzIHRoZSBpbml0aWFsIHZlcnNpb24gaGFkIG9u
bHkgc291cmNlIGJkZXYsIGNvcHlfZmlsZV9yYWdlIGNhbGwgd2FzIG5vdAp2aWFibGUuIFdpdGgg
dGhpcyB2ZXJzaW9uLCB3ZSBoYXZlIHR3byBiZGV2IGZvciBzb3VyY2UgYW5kIGRlc3RpbmF0aW9u
LgpJJ2xsIHJlbG9vayBhdCB0aGF0LiBTdXJlLiBXaWxsIGFkZCBhIG5ldyBibGt0ZXN0cyBmb3Ig
c2ltcGxlIGNvcHkuCgo+Cj4gSWYgeW91IHJlYWxseSAvZG8vIG5lZWQgYSBuZXcga2VybmVsIGNh
bGwgZm9yIHRoaXMsIHRoZW4gcGxlYXNlIHNlbmQgaW4KPiBhIG1hbnBhZ2UgZG9jdW1lbnRpbmcg
dGhlIGZpZWxkcyBvZiBzdHJ1Y3QgcmFuZ2VfZW50cnkgYW5kIGNvcHlfcmFuZ2UsCj4gYW5kIGhv
dyB1c2VycyBhcmUgc3VwcG9zZWQgdG8gdXNlIHRoaXMuCj4KClN1cmUuIFdpbGwgc2VuZCBhIG1h
bnBhZ2UgZG9jdW1lbnRhdGlvbiBvbmNlIHRoZSBwbHVtYmluZyBpcyBjb25jcmV0ZS4KCj4gPG5v
dyBqdW1waW5nIHRvIHRoZSBpb2N0bCBkZWZpbml0aW9uIGJlY2F1c2UgRGFtaWVuIGFscmVhZHkg
cmV2aWV3ZWQgdGhlCj4gcGx1bWJpbmcuLi4+Cj4KPiA+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUv
dWFwaS9saW51eC9mcy5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2ZzLmgKPiA+ID4gaW5kZXggZjQ0
ZWIwYTA0YWZkLi41Y2FkYjE3NjMxN2EgMTAwNjQ0Cj4gPiA+IC0tLSBhL2luY2x1ZGUvdWFwaS9s
aW51eC9mcy5oCj4gPiA+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9mcy5oCj4gPiA+IEBAIC02
NCw2ICs2NCwxOCBAQCBzdHJ1Y3QgZnN0cmltX3JhbmdlIHsKPiA+ID4gICAgIF9fdTY0IG1pbmxl
bjsKPiA+ID4gIH07Cj4gPiA+Cj4gPiA+ICtzdHJ1Y3QgcmFuZ2VfZW50cnkgewo+ID4gPiArICAg
X191NjQgc3JjOwo+Cj4gSXMgdGhpcyBhbiBvZmZzZXQ/ICBPciB0aGUgZmQgb2YgYW4gb3BlbiBi
ZGV2PwoKVGhpcyBpcyB0aGUgc291cmNlIG9mZnNldC4KCj4KPiA+ID4gKyAgIF9fdTY0IGxlbjsK
PiA+ID4gK307Cj4gPiA+ICsKPiA+ID4gK3N0cnVjdCBjb3B5X3JhbmdlIHsKPiA+ID4gKyAgIF9f
dTY0IGRlc3Q7Cj4gPiA+ICsgICBfX3U2NCBucl9yYW5nZTsKPiA+ID4gKyAgIF9fdTY0IHJhbmdl
X2xpc3Q7Cj4KPiBIbSwgSSB0aGluayB0aGlzIGlzIGEgcG9pbnRlcj8gIFdoeSBub3QganVzdCBw
dXQgdGhlIHJhbmdlX2VudHJ5IGFycmF5Cj4gYXQgdGhlIGVuZCBvZiBzdHJ1Y3QgY29weV9yYW5n
ZT8KPgoKQXMgdGhlIHNpemUgb2YgdGhlIHJhbmdlX2VudHJ5IGFycmF5IGNhbiBjaGFuZ2UgZHlu
YW1pY2FsbHkgZGVwZW5kaW5nIG9uCm5yX3JhbmdlLCBpdCB3YXMgZGlmZmljdWx0IHRvIGRvIGNv
cHlfZnJvbV91c2VyKCkgb24gY29weV9yYW5nZSBzdHJ1Y3R1cmUgaW4gdGhlCmlvY3RsLiBTbyBJ
IGRlY2lkZWQgdG8ga2VlcCB0aGF0IGFzIGEgcG9pbnRlciB0byByYW5nZV9lbnRyeSBhcnJheQpp
bnN0ZWFkIG9mIGtlZXBpbmcKYXJyYXkgYXQgdGhlIGVuZC4KCj4gPiA+ICsgICBfX3U2NCByc3Zk
Owo+Cj4gQWxzbyBuZWVkcyBhIGZsYWdzIGFyZ3VtZW50IHNvIHdlIGRvbid0IGhhdmUgdG8gYWRk
IEJMS0NPUFkyIGluIGxpa2UgMwo+IG1vbnRocy4KPgoKJ3JzdmQnIGZpZWxkIGlzIGtlcHQgdG8g
c3VwcG9ydCBmdXR1cmUgY29waWVzLiBXaWxsIHJlbmFtZSBpdC4KCj4gLS1ECj4KPiA+ID4gK307
Cj4gPiA+ICsKPiA+ID4gIC8qIGV4dGVudC1zYW1lIChkZWR1cGUpIGlvY3RsczsgdGhlc2UgTVVT
VCBtYXRjaCB0aGUgYnRyZnMgaW9jdGwgZGVmaW5pdGlvbnMgKi8KPiA+ID4gICNkZWZpbmUgRklM
RV9ERURVUEVfUkFOR0VfU0FNRSAgICAgICAgICAgICAwCj4gPiA+ICAjZGVmaW5lIEZJTEVfREVE
VVBFX1JBTkdFX0RJRkZFUlMgIDEKPiA+ID4gQEAgLTE4NCw2ICsxOTYsNyBAQCBzdHJ1Y3QgZnN4
YXR0ciB7Cj4gPiA+ICAjZGVmaW5lIEJMS1NFQ0RJU0NBUkQgX0lPKDB4MTIsMTI1KQo+ID4gPiAg
I2RlZmluZSBCTEtST1RBVElPTkFMIF9JTygweDEyLDEyNikKPiA+ID4gICNkZWZpbmUgQkxLWkVS
T09VVCBfSU8oMHgxMiwxMjcpCj4gPiA+ICsjZGVmaW5lIEJMS0NPUFkgX0lPV1IoMHgxMiwgMTI4
LCBzdHJ1Y3QgY29weV9yYW5nZSkKPiA+ID4gIC8qCj4gPiA+ICAgKiBBIGp1bXAgaGVyZTogMTMw
LTEzMSBhcmUgcmVzZXJ2ZWQgZm9yIHpvbmVkIGJsb2NrIGRldmljZXMKPiA+ID4gICAqIChzZWUg
dWFwaS9saW51eC9ibGt6b25lZC5oKQo+ID4gPgo+ID4KPiA+Cj4gPiAtLQo+ID4gRGFtaWVuIExl
IE1vYWwKPiA+IFdlc3Rlcm4gRGlnaXRhbCBSZXNlYXJjaAo+ID4KPiA+Cj4gPgo+ID4gLS0KPiA+
IGRtLWRldmVsIG1haWxpbmcgbGlzdAo+ID4gZG0tZGV2ZWxAcmVkaGF0LmNvbQo+ID4gaHR0cHM6
Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCj4gPgoKVGhhbmtzLApT
ZWx2YQoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBz
Oi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

