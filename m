Return-Path: <SRS0=Uigt=FO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2DCFC4361B
	for <dm-devel@archiver.kernel.org>; Thu, 10 Dec 2020 14:45:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2724222D74
	for <dm-devel@archiver.kernel.org>; Thu, 10 Dec 2020 14:45:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2724222D74
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-v_iU9iOOPY-ySuvLwe7vuQ-1; Thu, 10 Dec 2020 09:45:02 -0500
X-MC-Unique: v_iU9iOOPY-ySuvLwe7vuQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E085B8114;
	Thu, 10 Dec 2020 14:44:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6149C5C26D;
	Thu, 10 Dec 2020 14:44:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 358855002D;
	Thu, 10 Dec 2020 14:44:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BA13XZe027131 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Dec 2020 20:03:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4DF65100CBB2; Thu, 10 Dec 2020 01:03:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 49B8A100CBA2
	for <dm-devel@redhat.com>; Thu, 10 Dec 2020 01:03:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F110F80088F
	for <dm-devel@redhat.com>; Thu, 10 Dec 2020 01:03:30 +0000 (UTC)
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com
	[209.85.215.194]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-472-MNOfwTwHN-2oFqfvWl1RtA-1; Wed, 09 Dec 2020 20:03:25 -0500
X-MC-Unique: MNOfwTwHN-2oFqfvWl1RtA-1
Received: by mail-pg1-f194.google.com with SMTP id w5so1826652pgj.3;
	Wed, 09 Dec 2020 17:03:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:from:to:cc:references:message-id:date
	:user-agent:mime-version:in-reply-to:content-transfer-encoding
	:content-language;
	bh=73EtPaaOp1TANFS2/oJJIHj87LdKAP2A9J8wvXGyNCA=;
	b=epxWZP+sf93arhe/5DbDkzccmfqZC3fRI6xkFUJVkLJp9NdfMvLuD84WqICtWdLVPd
	KgO551qnRR1EshH4Ki8vfDoDEVX+t58aoevoKuLtCKYrX8BLeWcLqVbwQfry4gywIPEX
	tikUeMUDngrvoDAZzq9KzRmIZmpyjcupQW/LRpUxi9UEysl6gd8luo0St7qk/dJPalaa
	coNwZ3hfUO7la6w/1Yig85gOhvzvXtdJiQvVMbcWWfMUp2YZmiVO3pM4FzfeDie2ZPtg
	MSj0ITFdeBPa49SSDPUCXRZ1m7wNQxjnonP0ZEXomtd1RrhkSMu2uyMHrSmj23slfE+E
	Ktkw==
X-Gm-Message-State: AOAM531vA8aPkzTsE/UhGYnjJNiI/CS+mRbqDCOHT/VZAm7f5EdaUXCu
	ztnPRuRCWHc6/W5rtRbXCIMtF+BoulVeY5Zr
X-Google-Smtp-Source: ABdhPJyH9dg81cj1A215OkUhdlKrFthaWPMtQ1AVU2nhzs+bXK14piRTn67cXjT9wyVl2YW0ICOumg==
X-Received: by 2002:a17:90a:8508:: with SMTP id
	l8mr1019306pjn.131.1607562203557; 
	Wed, 09 Dec 2020 17:03:23 -0800 (PST)
Received: from [192.168.0.12] ([125.186.151.199])
	by smtp.googlemail.com with ESMTPSA id
	v125sm1333415pgv.6.2020.12.09.17.03.21
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Wed, 09 Dec 2020 17:03:22 -0800 (PST)
From: Hyeongseok Kim <hyeongseok@gmail.com>
To: Mike Snitzer <snitzer@redhat.com>
References: <20201203004659.95708-1-hyeongseok@gmail.com>
	<CABCJKufCS+hbXkGyO9uU3EBscfCpU1f7pi77uzR_+cjo97g=YQ@mail.gmail.com>
	<1939b1ec-b605-8a1a-8ff9-e50c36d60f66@gmail.com>
	<CABCJKueAPHNqdq=k6AhhxDR-oQdNs8+=BhmY8wGdgNcwr_-KMQ@mail.gmail.com>
	<7fda3da9-e0b1-abdd-4bde-3a46405536f5@gmail.com>
Message-ID: <b004e7c7-f795-77ed-19b9-983785780e92@gmail.com>
Date: Thu, 10 Dec 2020 10:03:19 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
	Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <7fda3da9-e0b1-abdd-4bde-3a46405536f5@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 10 Dec 2020 09:44:21 -0500
Cc: device-mapper development <dm-devel@redhat.com>,
	=?UTF-8?B?6rmA7ZiV7ISd?= <hyeongseok.kim@lge.com>,
	Alasdair Kergon <agk@redhat.com>, Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [dm-devel] [PATCH] dm verity: skip verity work on I/O errors
 when system is shutting down
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: ko-KR
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGkgTWlrZSwKCkhvdyBkbyB5b3UgdGhpbmsgYWJvdXQgdGhpcyBwYXRjaD8KCgoKT24gMTIvNy8y
MCA4OjE4IEFNLCBoeWVvbmdzZW9rIHdyb3RlOgo+IE9uIDEyLzUvMjAgODowMyBBTSwgU2FtaSBU
b2x2YW5lbiB3cm90ZToKPj4gT24gVGh1LCBEZWMgMywgMjAyMCBhdCAzOjQ2IFBNIGh5ZW9uZ3Nl
b2sgPGh5ZW9uZ3Nlb2tAZ21haWwuY29tPiB3cm90ZToKPj4+IE9uIDEyLzQvMjAgMjoyMiBBTSwg
U2FtaSBUb2x2YW5lbiB3cm90ZToKPj4+PiBIaSwKPj4+Pgo+Pj4+IE9uIFdlZCwgRGVjIDIsIDIw
MjAgYXQgNDo0OCBQTSBIeWVvbmdzZW9rIEtpbSAKPj4+PiA8aHllb25nc2Vva0BnbWFpbC5jb20+
IHdyb3RlOgo+Pj4+PiBJZiBlbWVyZ2VuY3kgc3lzdGVtIHNodXRkb3duIGlzIGNhbGxlZCwgbGlr
ZSBieSB0aGVybWFsIHNodXRkb3duLAo+Pj4+PiBkbSBkZXZpY2UgY291bGQgYmUgYWxpdmUgd2hl
biB0aGUgYmxvY2sgZGV2aWNlIGNvdWxkbid0IHByb2Nlc3MKPj4+Pj4gSS9PIHJlcXVlc3RzIGFu
eW1vcmUuIEluIHRoaXMgc3RhdHVzLCB0aGUgaGFuZGxpbmcgb2YgSS9PIGVycm9ycwo+Pj4+PiBi
eSBuZXcgZG0gSS9PIHJlcXVlc3RzIG9yIGJ5IHRob3NlIGFscmVhZHkgaW4tZmxpZ2h0IGNhbiBs
ZWFkIHRvCj4+Pj4+IGEgdmVyaXR5IGNvcnJ1cHRpb24gc3RhdGUsIHdoaWNoIGlzIG1pc2p1ZGdt
ZW50Lgo+Pj4+PiBTbywgc2tpcCB2ZXJpdHkgd29yayBmb3IgSS9PIGVycm9yIHdoZW4gc3lzdGVt
IGlzIHNodXR0aW5nIGRvd24uCj4+Pj4gVGhhbmsgeW91IGZvciB0aGUgcGF0Y2guIEkgYWdyZWUg
dGhhdCBhdHRlbXB0aW5nIHRvIGNvcnJlY3QgSS9PIGVycm9ycwo+Pj4+IHdoZW4gdGhlIHN5c3Rl
bSBpcyBzaHV0dGluZyBkb3duLCBhbmQgdGh1cyBnZW5lcmF0aW5nIG1vcmUgSS9PIHRoYXQncwo+
Pj4+IGxpa2VseSBnb2luZyB0byBmYWlsLCBpcyBub3QgYSBnb29kIGlkZWEuCj4+Pj4KPj4+Pj4g
U2lnbmVkLW9mZi1ieTogSHllb25nc2VvayBLaW0gPGh5ZW9uZ3Nlb2tAZ21haWwuY29tPgo+Pj4+
PiAtLS0KPj4+Pj4gwqDCoCBkcml2ZXJzL21kL2RtLXZlcml0eS10YXJnZXQuYyB8IDEyICsrKysr
KysrKysrLQo+Pj4+PiDCoMKgIDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pCj4+Pj4+Cj4+Pj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLXZlcml0eS10
YXJnZXQuYyAKPj4+Pj4gYi9kcml2ZXJzL21kL2RtLXZlcml0eS10YXJnZXQuYwo+Pj4+PiBpbmRl
eCBmNzQ5ODJkY2JlYTAuLmJhNjJjNTM3Nzk4YiAxMDA2NDQKPj4+Pj4gLS0tIGEvZHJpdmVycy9t
ZC9kbS12ZXJpdHktdGFyZ2V0LmMKPj4+Pj4gKysrIGIvZHJpdmVycy9tZC9kbS12ZXJpdHktdGFy
Z2V0LmMKPj4+Pj4gQEAgLTY0LDYgKzY0LDE1IEBAIHN0cnVjdCBidWZmZXJfYXV4IHsKPj4+Pj4g
wqDCoMKgwqDCoMKgwqDCoMKgIGludCBoYXNoX3ZlcmlmaWVkOwo+Pj4+PiDCoMKgIH07Cj4+Pj4+
Cj4+Pj4+ICsvKgo+Pj4+PiArICogV2hpbGUgc3lzdGVtIHNodXRkb3duLCBza2lwIHZlcml0eSB3
b3JrIGZvciBJL08gZXJyb3IuCj4+Pj4+ICsgKi8KPj4+Pj4gK3N0YXRpYyBpbmxpbmUgYm9vbCB2
ZXJpdHlfaXNfc3lzdGVtX3NodXR0aW5nX2Rvd24odm9pZCkKPj4+Pj4gK3sKPj4+Pj4gK8KgwqDC
oMKgwqDCoCByZXR1cm4gc3lzdGVtX3N0YXRlID09IFNZU1RFTV9IQUxUIHx8IHN5c3RlbV9zdGF0
ZSA9PSAKPj4+Pj4gU1lTVEVNX1BPV0VSX09GRgo+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB8fCBzeXN0ZW1fc3RhdGUgPT0gU1lTVEVNX1JFU1RBUlQ7Cj4+Pj4+ICt9Cj4+Pj4g
V2hpY2ggb2YgdGhlc2Ugc3RhdGVzIGRvZXMgdGhlIHN5c3RlbSBnZXQgdG8gZHVyaW5nIGFuIGVt
ZXJnZW5jeQo+Pj4+IHNodXRkb3duPyBDYW4gd2Ugc2ltcGxpZnkgdGhpcyBieSBjaGFuZ2luZyB0
aGUgdGVzdCB0byBzeXN0ZW1fc3RhdGUgPgo+Pj4+IFNZU1RFTV9SVU5OSU5HPwo+Pj4gSSBvbmx5
IHNhdyB0aGF0IGl0IHdhcyBTWVNURU1fUE9XRVJfT0ZGIG9yIFNZU1RFTV9SRVNUQVJULCBJIHdv
bmRlciBpZgo+Pj4gSS9PIGVycm9yIGNhbiBvY2N1ciBpbiBTWVNURU1fU1VTUEVORCBzdGF0ZS4K
Pj4gT0ssIHNvIHRoaW5rIHRoZSBjdXJyZW50IHZlcnNpb24gaXMgZmluZSB0aGVuLgo+Pgo+Pj4g
QXMgZmFyIGFzIEkga25vdywgdGhpcyBjb3VsZCBiZSBoYXBwZW4gaW4gZW1lcmdlbmN5IHNodXRk
b3duIGNhc2UsCj4+PiBjYW4geW91IGV4cGxhaW4gaWYgeW91IGhhdmUgYSBjYXNlIHdoZW4gSS9P
IGVycm9yIGNhbiBvY2N1ciBieQo+Pj4gU1lTVEVNX1NVU1BFTkQ/Cj4+IE5vLCBJIGRvbid0IGhh
dmUgYSBjYXNlIHdoZXJlIHRoYXQgd291bGQgaGFwcGVuLgo+Pgo+Pj4+IE90aGVyd2lzZSwgdGhp
cyBsb29rcyBnb29kIHRvIG1lLiBIb3dldmVyLCBJJ20gbm93IHdvbmRlcmluZyBpZiBhbiBJL08K
Pj4+PiBlcnJvciBzaG91bGQgZXZlciByZXN1bHQgaW4gdmVyaXR5X2hhbmRsZV9lcnIoKSBiZWlu
ZyBjYWxsZWQuIFdpdGhvdXQKPj4+PiBGRUMsIGRtLXZlcml0eSB3b24ndCBjYWxsIHZlcml0eV9o
YW5kbGVfZXJyKCkgd2hlbiBJL08gZmFpbHMsIGJ1dCB3aXRoCj4+Pj4gRkVDIGVuYWJsZWQsIGl0
IGN1cnJlbnRseSBkb2VzLCBhc3N1bWluZyBlcnJvciBjb3JyZWN0aW9uIGZhaWxzLiBBbnkKPj4+
PiB0aG91Z2h0cz8KPj4+IFllcywgSSBoYXZlIHRob3VnaHQgYWJvdXQgdGhpcywgYW5kIHRvIGJl
IGhvbmVzdCwgSSB0aGluayB2ZXJpdHkgb3IgRkVDCj4+PiBzaG91bGQgbm90IGNhbGwgdmVyaXR5
X2hhbmRsZV9lcnJvcigpIGluIGNhc2Ugb2YgSS9PIGVycm9ycy4KPj4gSSB0ZW5kIHRvIGFncmVl
LiBXZSBjb3VsZCBzaW1wbHkgY2hlY2sgdGhlIG9yaWdpbmFsIGJpby0+Ymlfc3RhdHVzIGluCj4+
IHZlcml0eV92ZXJpZnlfaW8oKSBhbmQgaWYgd2UgZmFpbGVkIHRvIGNvcnJlY3QgYW4gSS9PIGVy
cm9yLCByZXR1cm4gYW4KPj4gZXJyb3IgaW5zdGVhZCBvZiBnb2luZyBpbnRvIHZlcml0eV9oYW5k
bGVfZXJyKCkuIEFueSB0aG91Z2h0cz8KPj4KPj4+IEJ1dCwgYmVjYXVzZSBJIGNvdWxkbid0IGtu
b3cgdGhlIGFiaWxpdHkgb2YgRkVDLCBJIG9ubHkgZm9jdXNlZCBvbiBub3QKPj4+IGJyZWFraW5n
IGN1cmVudCBsb2dpY3Mgb3RoZXIgdGhhbiBzeXN0ZW0gc2h1dGRvd24gJiYgSS9PIGVycm9ycyBj
YXNlLgo+PiBTdXJlLCBtYWtlcyBzZW5zZS4gV2UgY2FuIGFkZHJ3ZXNzIHRoYXQgc2VwYXJhdGVs
eS4KPiBTb3VuZHMgcmVhc29uYWJsZS4gSSBob3BlIHRoZSBuZXh0IGltcHJvdmVtZW50cy4KPj4K
Pj4gUmV2aWV3ZWQtYnk6IFNhbWkgVG9sdmFuZW4gPHNhbWl0b2x2YW5lbkBnb29nbGUuY29tPgo+
Pgo+PiBTYW1pCj4+Cj4gVGhhbmsgeW91IGZvciB0aGUgcmV2aWV3Lgo+Cj4gSHllb25nc2Vvawo+
Cj4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
d3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

