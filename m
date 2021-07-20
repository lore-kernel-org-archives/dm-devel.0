Return-Path: <SRS0=SJ91=MM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C407C07E95
	for <dm-devel@archiver.kernel.org>; Tue, 20 Jul 2021 21:30:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2002560E0B
	for <dm-devel@archiver.kernel.org>; Tue, 20 Jul 2021 21:30:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2002560E0B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1626816610;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OtkENAXqsRWqQZm/okaDVjfNAfmBl15Y4i/NfNT705E=;
	b=OX/QLaGXm7ZXrcBD2/0mYRAxYhDRKMWqy2ifq5N2QprirgcSS5pcfG4PSamJ49E/BJirmg
	II4AAlYFY7usMESzgViD9SVczKCWhVNua1S1QGwiyxStxF8w6La91XYHyR7FQapHB2Prju
	y5tdPqm0f3rqFv1F9UE5yKTpYxEDocY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-V_XTMElYOua2GmlJBIEYyA-1; Tue, 20 Jul 2021 17:28:28 -0400
X-MC-Unique: V_XTMElYOua2GmlJBIEYyA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1006D804301;
	Tue, 20 Jul 2021 21:28:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 44C045D9D3;
	Tue, 20 Jul 2021 21:28:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6E5E34EA2F;
	Tue, 20 Jul 2021 21:28:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16KLRVHv014512 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 20 Jul 2021 17:27:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2CA73DA696; Tue, 20 Jul 2021 21:27:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 274CFC2117
	for <dm-devel@redhat.com>; Tue, 20 Jul 2021 21:27:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15A6880B71C
	for <dm-devel@redhat.com>; Tue, 20 Jul 2021 21:27:28 +0000 (UTC)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
	[209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-89-4Abc4GF4PN-0R07YXL4wPw-1; Tue, 20 Jul 2021 17:27:26 -0400
X-MC-Unique: 4Abc4GF4PN-0R07YXL4wPw-1
Received: by mail-qv1-f71.google.com with SMTP id
	z1-20020a0cfec10000b02902dbb4e0a8f2so5758452qvs.6
	for <dm-devel@redhat.com>; Tue, 20 Jul 2021 14:27:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:content-transfer-encoding
	:in-reply-to;
	bh=13FGH9IcdsNGls40eCSMkR2G2llimRJCFlJpfj0drAA=;
	b=lo2D9uvQGvDXEVw7r5qu8xkFkKyKCmenq1YxOsj50+UDAOcNt4L5JslsKCla7oVvyI
	DvyzinxREHYzIezQNaPtH4f2RIw9MCVyJ4iizVOR1VQm5LTm23Irz8LlNB3a72Mt1b3Q
	tor27LkehLbswbWf7SbGdAiYx0DEGmS0ljbqLTkdI+gvzfXONVvM2W4b1oxPfl3yC6aj
	cwoxW+nrNZgtwION6gdhPemi6qyzKZerRGPV3sp7PwH++hdKKIZSaBoEqv4NrtGiErwh
	qB874uNMIyumOAlYyGcgxqi8tUKcIYPMRouIscdKdHY5snCyjDAdfOEJ8HKq4KA5GDpO
	YEXQ==
X-Gm-Message-State: AOAM530KMtfB0Oiw3BiRCFYHBKYzuMHZuBPcUrLnNpoN6ZqcQYyFYavv
	yPMqS3GHLB/1/xXXDsE1u2vvxgwajQzwsC1pFlwepNgiRXSjvDkMchgucT/d43UXfw6mYP6ToPO
	lWMnW8YTzf98rGA==
X-Received: by 2002:a37:aa8f:: with SMTP id
	t137mr30800503qke.277.1626816446231; 
	Tue, 20 Jul 2021 14:27:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5ADkrHKUctkZSNxUAO8CeOCIjalPS9tqXHZEs8CzCNQ9nrPOPek18HNDy4oe1aXRTVECpGQ==
X-Received: by 2002:a37:aa8f:: with SMTP id
	t137mr30800488qke.277.1626816445958; 
	Tue, 20 Jul 2021 14:27:25 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	u19sm2816359qtx.48.2021.07.20.14.27.25
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 20 Jul 2021 14:27:25 -0700 (PDT)
Date: Tue, 20 Jul 2021 17:27:24 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <YPc/vON2qvwjfvTe@redhat.com>
References: <20210713004904.8808-1-tusharsu@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <20210713004904.8808-1-tusharsu@linux.microsoft.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-integrity@vger.kernel.org, dm-devel@redhat.com, zohar@linux.ibm.com,
	agk@redhat.com, nramas@linux.microsoft.com
Subject: Re: [dm-devel] [PATCH 0/7] device mapper target measurements using
	IMA
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

T24gTW9uLCBKdWwgMTIgMjAyMSBhdCAgODo0OFAgLTA0MDAsClR1c2hhciBTdWdhbmRoaSA8dHVz
aGFyc3VAbGludXgubWljcm9zb2Z0LmNvbT4gd3JvdGU6Cgo+IEZvciBhIGdpdmVuIHN5c3RlbSwg
dmFyaW91cyBleHRlcm5hbCBzZXJ2aWNlcy9pbmZyYXN0cnVjdHVyZSB0b29scwo+IChpbmNsdWRp
bmcgdGhlIGF0dGVzdGF0aW9uIHNlcnZpY2UpIGludGVyYWN0IHdpdGggaXQgLSBib3RoIGR1cmlu
ZyB0aGUKPiBzZXR1cCBhbmQgZHVyaW5nIHJlc3Qgb2YgdGhlIHN5c3RlbSBydW4tdGltZS4gIFRo
ZXkgc2hhcmUgc2Vuc2l0aXZlIGRhdGEKPiBhbmQvb3IgZXhlY3V0ZSBjcml0aWNhbCB3b3JrbG9h
ZCBvbiB0aGF0IHN5c3RlbS4gIFRoZSBleHRlcm5hbCBzZXJ2aWNlcwo+IG1heSB3YW50IHRvIHZl
cmlmeSB0aGUgY3VycmVudCBydW4tdGltZSBzdGF0ZSBvZiB0aGUgcmVsZXZhbnQga2VybmVsCj4g
c3Vic3lzdGVtcyBiZWZvcmUgZnVsbHkgdHJ1c3RpbmcgdGhlIHN5c3RlbSB3aXRoIGJ1c2luZXNz
LWNyaXRpY2FsCj4gZGF0YS93b3JrbG9hZC4KPiAKPiBEZXZpY2UgbWFwcGVyIGlzIG9uZSBzdWNo
IGtlcm5lbCBzdWJzeXN0ZW0gdGhhdCBwbGF5cyBhIGNyaXRpY2FsIHJvbGUgb24KPiBhIGdpdmVu
IHN5c3RlbSBieSBwcm92aWRpbmcgdmFyaW91cyBpbXBvcnRhbnQgZnVuY3Rpb25hbGl0aWVzIHRv
IHRoZQo+IGJsb2NrIGRldmljZXMgd2l0aCB2YXJpb3VzIHRhcmdldCB0eXBlcyBsaWtlIGNyeXB0
LCB2ZXJpdHksIGludGVncml0eSAKPiBldGMuICBFYWNoIG9mIHRoZXNlIHRhcmdldCB0eXBlc+KA
mSBmdW5jdGlvbmFsaXRpZXMgY2FuIGJlIGNvbmZpZ3VyZWQgd2l0aAo+IHZhcmlvdXMgYXR0cmli
dXRlcy4gIFRoZSBhdHRyaWJ1dGVzIGNob3NlbiB0byBjb25maWd1cmUgdGhlc2UgdGFyZ2V0IHR5
cGVzCj4gY2FuIHNpZ25pZmljYW50bHkgaW1wYWN0IHRoZSBzZWN1cml0eSBwcm9maWxlIG9mIHRo
ZSBibG9jayBkZXZpY2UsCj4gYW5kIGluLXR1cm4sIG9mIHRoZSBzeXN0ZW0gaXRzZWxmLiAgRm9y
IGluc3RhbmNlLCB0aGUgdHlwZSBvZiBlbmNyeXB0aW9uCj4gYWxnb3JpdGhtIGFuZCB0aGUga2V5
IHNpemUgZGV0ZXJtaW5lcyB0aGUgc3RyZW5ndGggb2YgZW5jcnlwdGlvbiBmb3IgYQo+IGdpdmVu
IGJsb2NrIGRldmljZS4KPiAKPiBUaGVyZWZvcmUsIHZlcmlmeWluZyB0aGUgY3VycmVudCBzdGF0
ZSBvZiB2YXJpb3VzIGJsb2NrIGRldmljZXMgYXMgd2VsbAo+IGFzIHRoZWlyIHZhcmlvdXMgdGFy
Z2V0IGF0dHJpYnV0ZXMgaXMgY3J1Y2lhbCBmb3IgZXh0ZXJuYWwgc2VydmljZXMKPiBiZWZvcmUg
ZnVsbHkgdHJ1c3RpbmcgdGhlIHN5c3RlbSB3aXRoIGJ1c2luZXNzLWNyaXRpY2FsIGRhdGEvd29y
a2xvYWQuCj4gCj4gSU1BIHByb3ZpZGVzIHRoZSBuZWNlc3NhcnkgZnVuY3Rpb25hbGl0eSBmb3Ig
ZGV2aWNlIG1hcHBlciB0byBtZWFzdXJlIHRoZQo+IHN0YXRlIGFuZCBjb25maWd1cmF0aW9uIG9m
IHZhcmlvdXMgYmxvY2sgZGV2aWNlcyAtCj4gICAtIEJZIGRldmljZSBtYXBwZXIgaXRzZWxmLCBm
cm9tIHdpdGhpbiB0aGUga2VybmVsLAo+ICAgLSBpbiBhIHRhbXBlciByZXNpc3RhbnQgd2F5LAo+
ICAgLSBhbmQgcmUtbWVhc3VyZWQgLSB0cmlnZ2VyZWQgb24gc3RhdGUvY29uZmlndXJhdGlvbiBj
aGFuZ2UuCj4gCj4gVGhpcyBwYXRjaCBzZXJpZXMgdXNlcyB0aGlzIElNQSBmdW5jdGlvbmFsaXR5
LCBieSBjYWxsaW5nIHRoZSBmdW5jdGlvbgo+IGltYV9tZWFzdXJlX2NyaXRpY2FsX2RhdGEoKSwg
d2hlbiBhIGJsb2NrIGRldmljZSBzdGF0ZSBpcyBjaGFuZ2VkIChlLmcuCj4gb24gZGV2aWNlIGNy
ZWF0ZSwgcmVzdW1lLCByZW5hbWUsIHJlbW92ZSBldGMuKSAgSXQgbWVhc3VyZXMgdGhlIGRldmlj
ZQo+IHN0YXRlIGFuZCBjb25maWd1cmF0aW9uIGFuZCBzdG9yZXMgaXQgaW4gSU1BIGxvZ3MsIHNv
IHRoYXQgaXQgY2FuIGJlCj4gdXNlZCBieSBleHRlcm5hbCBzZXJ2aWNlcyBmb3IgbWFuYWdpbmcg
dGhlIHN5c3RlbS4KCkkgbmVlZGVkIHRvIEVYUE9SVF9TWU1CT0xfR1BMKGltYV9tZWFzdXJlX2Ny
aXRpY2FsX2RhdGEpOyBvdGhlcndpc2UgSQpjb3VsZG4ndCBjb21waWxlLi4gbm90IHN1cmUgYnV0
IEkgY2FuIG9ubHkgaW1hZ2luZSB5b3UgY29tcGlsZSBETQooYW5kIGFsbCB0YXJnZXRzKSB0byBi
ZSBidWlsdGluPwoKSW4gYWRkaXRpb24gdG8gZml4aW5nIHRoYXQgKGluIGZpcnN0IHRhYmxlIGxv
YWQgcGF0Y2gpIEkgY2hhbmdlZAp2YXJpb3VzIHRoaW5ncyBhbG9uZyB0aGUgd2F5IHdoaWxlIEkg
cmV2aWV3ZWQgZWFjaCBwYXRjaC4KClRoaW5ncyB0aGF0IEkgcmVjYWxsIGFyZToKLSBtb3ZlZCAj
aWZkZWYgQ09ORklHX0lNQSBmcm9tIGRtLWltYS5jIHRvIGRtLWltYS5oCi0gZml4ZWQgdmFyaW91
cyB0eXBvcyBhbmQgd2hpdGVzcGFjZQotIGNvbnNpc3RlbnRseSBwcmVwZW5kICIsIiBpbiBTVEFU
VVNUWVBFX0lNQSdzIERNRU1JVCgpcyBhcyBvcHBvc2VkIHRvCiAgaGF2aW5nIGEgbWl4IG9yIHBy
ZSBhbmQgcG9zdGZpeCB0aHJvdWdob3V0IHRhcmdldHMKLSBmaXhlZCB3aGF0IHNlZW1lZCBsaWtl
IG1hbGZvcm1lZCBTVEFUVVNUWVBFX0lNQSBoYW5kbGluZyBmb3IKICBkbS1tdWx0aXBhdGggLS0g
aXQgd2FzIERNRU1JVCgiOyIpIGZvciBlYWNoIGRtLW1wYXRoJ3MgcGF0aGdyb3VwCi0gYWRkZWQg
c29tZSBmaWVsZHMgdG8gZG0tbXBhdGgsIHJlbmFtZWQgc29tZSBJTUEgbmFtZXMgaW4gbmFtZT12
YWx1ZQogIHBhaXJzIHRvIGJlIG1vcmUgY2xlYXIuCgpJJ3ZlIHN0YWdlZCB0aGUgcmVzdWx0IGlu
IGxpbnV4LW5leHQgdmlhIGxpbnV4LWRtLmdpdCdzIGRtLTUuMTUKYnJhbmNoLCBzZWU6Cmh0dHBz
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RldmljZS1tYXBwZXIv
bGludXgtZG0uZ2l0L2xvZy8/aD1kbS01LjE1CgpJJ3ZlIGNvbXBpbGVkIHRlc3RlZCBib3RoIHdp
dGggYW5kIHdpdGhvdXQgQ09ORklHX0lNQSBzZXQuICBCdXQKaGF2ZW4ndCBhY3R1YWxseSB0ZXN0
ZWQgdGhlIGNvZGUuCgpQbGVhc2Ugc2VuZCBhbnkgaW5jcmVtZW50YWwgZml4ZXMgcmVsYXRpdmUg
dG8gdGhlIGRtLTUuMTUgYnJhbmNoIGFuZApJJ2xsIGdldCB0aGVtIGZvbGRlZCBpbiB3aGVyZSBh
cHByb3ByaWF0ZS4KClRoYW5rcywKTWlrZQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRl
dmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbA==

