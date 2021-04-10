Return-Path: <SRS0=eE7R=JJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CEAC433ED
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 07:40:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 272C561207
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 07:40:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 272C561207
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=javigon.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-Gsh6CmAIMpGqoHi8vS40sg-1; Mon, 12 Apr 2021 03:40:32 -0400
X-MC-Unique: Gsh6CmAIMpGqoHi8vS40sg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F25B1107ACC7;
	Mon, 12 Apr 2021 07:40:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CC4B918AA1;
	Mon, 12 Apr 2021 07:40:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2E19E5534C;
	Mon, 12 Apr 2021 07:40:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13A6X9rR009087 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 10 Apr 2021 02:33:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 439E8219B890; Sat, 10 Apr 2021 06:33:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EA7B219B8A2
	for <dm-devel@redhat.com>; Sat, 10 Apr 2021 06:33:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8950F802317
	for <dm-devel@redhat.com>; Sat, 10 Apr 2021 06:33:06 +0000 (UTC)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com
	[209.85.218.44]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-420-sc52__WkPLKDpkA3N-w1aw-1; Sat, 10 Apr 2021 02:32:59 -0400
X-MC-Unique: sc52__WkPLKDpkA3N-w1aw-1
Received: by mail-ej1-f44.google.com with SMTP id g5so5256757ejx.0
	for <dm-devel@redhat.com>; Fri, 09 Apr 2021 23:32:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:content-transfer-encoding:from:mime-version
	:subject:date:message-id:references:cc:in-reply-to:to;
	bh=QmBA/khm9QQj8QSTpq8GUmMDxfR3EYkN2ltUuGJAbWQ=;
	b=FELlfGLqVunr2BKcAis9qm4ZPxYxbNdmYIAHJchETJr082LJXZrnaq7KoBfpfcYd0v
	X8gWwTeUTgn8Lt1gNVoICOOE5oh3hK5XWIQuQKVPY6smsbCKFG78oDgIFYG9/GIVZH7Y
	vo+q3BUmN5Wk8ksMckWoPDvABuLtDLm+U/oSq+i2rmsgEKdTtj8ft1d6p4vnP7V2L/6e
	DAAIdk3xGJnEEFl1s7A4o0uwXp5P80M+BJs/kEt5nAaGlQS39qGs/+/Xycy2+RvG7K71
	Ich/B5mfjlhAAviKkIX38CVwBCnfEythZD3HAY15sHaTF3uIsg3l8tKhfOfWjCpvWeKT
	jbSw==
X-Gm-Message-State: AOAM533oBbTzeondYH0ebtcntkhiTUBtAgv1ec1fRZeGrZYNdImeEUp2
	5Uw7g17PDrmly1x+5mehCPNBLA==
X-Google-Smtp-Source: ABdhPJwG75/xQdAUY5SZ7i9s/RKcSTINm5eq6NN0AZ16BVTCynQFcgZwYqtZ3G/MLDxy4IQWenOqbw==
X-Received: by 2002:a17:906:1d0e:: with SMTP id
	n14mr19377458ejh.97.1618036378037; 
	Fri, 09 Apr 2021 23:32:58 -0700 (PDT)
Received: from [192.168.10.20] (5.186.124.214.cgn.fibianet.dk. [5.186.124.214])
	by smtp.gmail.com with ESMTPSA id
	ck29sm2558898edb.47.2021.04.09.23.32.57
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 09 Apr 2021 23:32:57 -0700 (PDT)
From: =?utf-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>
Mime-Version: 1.0 (1.0)
Date: Sat, 10 Apr 2021 08:32:56 +0200
Message-Id: <5BE5E1D9-675F-4122-A845-B0A29BB74447@javigon.com>
References: <BYAPR04MB49652982D00724001AE758C986729@BYAPR04MB4965.namprd04.prod.outlook.com>
In-Reply-To: <BYAPR04MB49652982D00724001AE758C986729@BYAPR04MB4965.namprd04.prod.outlook.com>
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13A6X9rR009087
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 12 Apr 2021 03:36:19 -0400
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>, axboe@kernel.dk,
	Damien Le Moal <damien.lemoal@wdc.com>, kch@kernel.org,
	SelvaKumar S <selvakuma.s1@samsung.com>, sagi@grimberg.me,
	snitzer@redhat.com, selvajove@gmail.com,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	hch@lst.de, linux-block@vger.kernel.org, kbusch@kernel.org,
	dm-devel@redhat.com, joshi.k@samsung.com, joshiiitr@gmail.com,
	linux-fsdevel@vger.kernel.org, javier.gonz@samsung.com,
	nj.shetty@samsung.com
Subject: Re: [dm-devel] [RFC PATCH v5 0/4] add simple copy support
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

Cj4gT24gMTAgQXByIDIwMjEsIGF0IDAyLjMwLCBDaGFpdGFueWEgS3Vsa2FybmkgPENoYWl0YW55
YS5LdWxrYXJuaUB3ZGMuY29tPiB3cm90ZToKPiAKPiDvu79PbiA0LzkvMjEgMTc6MjIsIE1heCBH
dXJ0b3ZveSB3cm90ZToKPj4+IE9uIDIvMTkvMjAyMSAyOjQ1IFBNLCBTZWx2YUt1bWFyIFMgd3Jv
dGU6Cj4+PiBUaGlzIHBhdGNoc2V0IHRyaWVzIHRvIGFkZCBzdXBwb3J0IGZvciBUUDQwNjVhICgi
U2ltcGxlIENvcHkgQ29tbWFuZCIpLAo+Pj4gdjIwMjAuMDUuMDQgKCJSYXRpZmllZCIpCj4+PiAK
Pj4+IFRoZSBTcGVjaWZpY2F0aW9uIGNhbiBiZSBmb3VuZCBpbiBmb2xsb3dpbmcgbGluay4KPj4+
IGh0dHBzOi8vbnZtZXhwcmVzcy5vcmcvd3AtY29udGVudC91cGxvYWRzL05WTS1FeHByZXNzLTEu
NC1SYXRpZmllZC1UUHMtMS56aXAKPj4+IAo+Pj4gU2ltcGxlIGNvcHkgY29tbWFuZCBpcyBhIGNv
cHkgb2ZmbG9hZGluZyBvcGVyYXRpb24gYW5kIGlzICB1c2VkIHRvIGNvcHkKPj4+IG11bHRpcGxl
IGNvbnRpZ3VvdXMgcmFuZ2VzIChzb3VyY2VfcmFuZ2VzKSBvZiBMQkEncyB0byBhIHNpbmdsZSBk
ZXN0aW5hdGlvbgo+Pj4gTEJBIHdpdGhpbiB0aGUgZGV2aWNlIHJlZHVjaW5nIHRyYWZmaWMgYmV0
d2VlbiBob3N0IGFuZCBkZXZpY2UuCj4+PiAKPj4+IFRoaXMgaW1wbGVtZW50YXRpb24gZG9lc24n
dCBhZGQgbmF0aXZlIGNvcHkgb2ZmbG9hZCBzdXBwb3J0IGZvciBzdGFja2VkCj4+PiBkZXZpY2Vz
IHJhdGhlciBjb3B5IG9mZmxvYWQgaXMgZG9uZSB0aHJvdWdoIGVtdWxhdGlvbi4gUG9zc2libGUg
dXNlCj4+PiBjYXNlcyBhcmUgRjJGUyBnYyBhbmQgQlRSRlMgcmVsb2NhdGlvbi9iYWxhbmNlLgo+
Pj4gCj4+PiAqYmxrZGV2X2lzc3VlX2NvcHkqIHRha2VzIHNvdXJjZSBiZGV2LCBubyBvZiBzb3Vy
Y2VzLCBhcnJheSBvZiBzb3VyY2UKPj4+IHJhbmdlcyAoaW4gc2VjdG9ycyksIGRlc3RpbmF0aW9u
IGJkZXYgYW5kIGRlc3RpbmF0aW9uIG9mZnNldChpbiBzZWN0b3JzKS4KPj4+IElmIGJvdGggc291
cmNlIGFuZCBkZXN0aW5hdGlvbiBibG9jayBkZXZpY2VzIGFyZSBzYW1lIGFuZCBjb3B5X29mZmxv
YWQgPSAxLAo+Pj4gdGhlbiBjb3B5IGlzIGRvbmUgdGhyb3VnaCBuYXRpdmUgY29weSBvZmZsb2Fk
aW5nLiBDb3B5IGVtdWxhdGlvbiBpcyB1c2VkCj4+PiBpbiBvdGhlciBjYXNlcy4KPj4+IAo+Pj4g
QXMgU0NTSSBYQ09QWSBjYW4gdGFrZSB0d28gZGlmZmVyZW50IGJsb2NrIGRldmljZXMgYW5kIG5v
IG9mIHNvdXJjZSByYW5nZSBpcwo+Pj4gZXF1YWwgdG8gMSwgdGhpcyBpbnRlcmZhY2UgY2FuIGJl
IGV4dGVuZGVkIGluIGZ1dHVyZSB0byBzdXBwb3J0IFNDU0kgWENPUFkuCj4+IEFueSBpZGVhIHdo
eSB0aGlzIFRQIHdhc24ndCBkZXNpZ25lZCBmb3IgY29weSBvZmZsb2FkIGJldHdlZW4gMiAKPj4g
ZGlmZmVyZW50IG5hbWVzcGFjZXMgaW4gdGhlIHNhbWUgY29udHJvbGxlciA/Cj4gCj4gWWVzLCBp
dCB3YXMgdGhlIGZpcnN0IGF0dGVtcHQgc28gdG8ga2VlcCBpdCBzaW1wbGUuCj4gCj4gRnVydGhl
ciB3b3JrIGlzIG5lZWRlZCB0byBhZGQgaW5jcmVtZW50YWwgVFAgc28gdGhhdCB3ZSBjYW4gYWxz
byBkbyBhIGNvcHkKPiBiZXR3ZWVuIHRoZSBuYW1lLXNwYWNlcyBvZiBzYW1lIGNvbnRyb2xsZXIg
KGlmIHdlIGNhbid0IGFscmVhZHkpIGFuZCB0byB0aGUKPiBuYW1lc3BhY2VzIHRoYXQgYmVsb25n
cyB0byB0aGUgZGlmZmVyZW50IGNvbnRyb2xsZXIuCj4gCj4+IEFuZCBhIHNpbXBsZSBjb3B5IHdp
bGwgYmUgdGhlIGNhc2Ugd2hlcmUgdGhlIHNyY19uc2lkID09IGRzdF9uc2lkID8KPj4gCj4+IEFs
c28gd2h5IHRoZXJlIGFyZSBtdWx0aXBsZSBzb3VyY2UgcmFuZ2VzIGFuZCBvbmx5IG9uZSBkc3Qg
cmFuZ2UgPyBXZSAKPj4gY291bGQgYWRkIGEgYml0IHRvIGluZGljYXRlIGlmIHRoaXMgcmFuZ2Ug
aXMgc3JjIG9yIGRzdC4uCgpPbmUgb2YgdGhlIHRhcmdldCB1c2UgY2FzZXMgd2FzIFpOUyBpbiBv
cmRlciB0byBhdm9pZCBmYWJyaWMgdHJhbnNmZXJzIGR1cmluZyBob3N0IEdDLiBZb3UgY2FuIHNl
ZSBob3cgdGhpcyBwbGF5cyB3ZWxsIHdpdGggc2V2ZXJhbCB6b25lIHJhbmdlcyBhbmQgYSBzaW5n
bGUgem9uZSBkZXN0aW5hdGlvbi4gCgpJZiB3ZSBzdGFydCBnZXR0aW5nIHN1cHBvcnQgaW4gTGlu
dXggdGhyb3VnaCB0aGUgZGlmZmVyZW50IHBhc3QgY29weSBvZmZsb2FkIGVmZm9ydHMsIEnigJlt
IHN1cmUgd2UgY2FuIGV4dGVuZCB0aGlzIFRQIGluIHRoZSBmdXR1cmUuIAoKCi0tCmRtLWRldmVs
IG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQu
Y29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

