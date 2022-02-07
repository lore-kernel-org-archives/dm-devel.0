Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC60DC433EF
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 18:48:20 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-Po-U_Iu1Nq22aVSp_OtdXQ-1; Tue, 08 Feb 2022 13:48:16 -0500
X-MC-Unique: Po-U_Iu1Nq22aVSp_OtdXQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72BBB8144E2;
	Tue,  8 Feb 2022 18:48:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA77E10A3955;
	Tue,  8 Feb 2022 18:48:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DAD684A705;
	Tue,  8 Feb 2022 18:48:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2179vTVv024062 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Feb 2022 04:57:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8360F492CAA; Mon,  7 Feb 2022 09:57:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F3F8492CA4
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 09:57:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6602F811E76
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 09:57:29 +0000 (UTC)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com
	[209.85.208.171]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-478-fZ4ij0XbOCiLMO2AMDtsjw-1; Mon, 07 Feb 2022 04:57:25 -0500
X-MC-Unique: fZ4ij0XbOCiLMO2AMDtsjw-1
Received: by mail-lj1-f171.google.com with SMTP id t7so18696805ljc.10;
	Mon, 07 Feb 2022 01:57:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc:content-transfer-encoding;
	bh=T8GS9Lx/Nzfe8shyS/bZ6AFUZk8Wg4JdFQgCVTpa/ow=;
	b=EhNuZKbxyd3EthJ8uB7RBGxURU3I5hCYbMTIGAhXSb4qJhl/qi1rmf1ElA/KwCBndG
	yNWm1UyDKuz2pDYSGEdKeiAyIOKNbGm1LiRApfF8OnlV/uFXb+2euowfTkyKyK24bWNT
	T4ll+mlqD3o4EgJGJ96hRxG29LX4ivcjjCZ+hWuK49o4eo9cIPMnub3hTjdpCkahl4b5
	3ikns3OoHi0uuDQVA/26WQ9ax0WDkpyxVKiotGikIH9OKc3QQISxveqQGoVmFJ1zce3Y
	1YRx2PrJ8uelznfULzgavWF5B8vpW/3s8KxC7zWvjdLiJQudPaKCKl4izLyKDO14UeUh
	bjag==
X-Gm-Message-State: AOAM531Q44G3cD7B9iaBx8KoBQey8O0HRm/wRSQhHir0gDysN6JlRw38
	dJavqB6+N13OIhkw4zOErZJjsSK67MTJkPeZA8U=
X-Google-Smtp-Source: ABdhPJxV5weaU4Xoj+nXg6b8L1jKYRkPcK3VXq+/Al3uXfmdamOSUyvoF17yjujMX3jIRgFIA5NTrgrLqSjbGfGwu24=
X-Received: by 2002:a05:651c:108:: with SMTP id
	a8mr8630674ljb.479.1644227843616; 
	Mon, 07 Feb 2022 01:57:23 -0800 (PST)
MIME-Version: 1.0
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
In-Reply-To: <20220201102122.4okwj2gipjbvuyux@mpHalley-2>
From: Nitesh Shetty <nitheshshetty@gmail.com>
Date: Mon, 7 Feb 2022 15:27:12 +0530
Message-ID: <CAOSviJ0+97ouVbQpQD1RykdyyM2Z_wVRrQjciizzMPS+pLOEsQ@mail.gmail.com>
To: =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 2179vTVv024062
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 08 Feb 2022 02:51:50 -0500
Cc: "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"kbus >> Keith Busch" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K. Petersen"
	<martin.petersen@oracle.com>, "jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Q2hhaXRhbnlhLAoKSSB3b3VsZCBsaWtlIHRvIGpvaW4gdGhlIGNvbnZlcnNhdGlvbi4KClRoYW5r
cywKTml0ZXNoCgpPbiBTdW4sIEZlYiA2LCAyMDIyIGF0IDc6MjkgUE0gSmF2aWVyIEdvbnrDoWxl
eiA8amF2aWVyQGphdmlnb24uY29tPiB3cm90ZToKPgo+IE9uIDI3LjAxLjIwMjIgMDc6MTQsIENo
YWl0YW55YSBLdWxrYXJuaSB3cm90ZToKPiA+SGksCj4gPgo+ID4qIEJhY2tncm91bmQgOi0KPiA+
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0KPiA+Cj4gPkNvcHkgb2ZmbG9hZCBpcyBhIGZlYXR1cmUgdGhhdCBhbGxv
d3MgZmlsZS1zeXN0ZW1zIG9yIHN0b3JhZ2UgZGV2aWNlcwo+ID50byBiZSBpbnN0cnVjdGVkIHRv
IGNvcHkgZmlsZXMvbG9naWNhbCBibG9ja3Mgd2l0aG91dCByZXF1aXJpbmcKPiA+aW52b2x2ZW1l
bnQgb2YgdGhlIGxvY2FsIENQVS4KPiA+Cj4gPldpdGggcmVmZXJlbmNlIHRvIHRoZSBSSVNDLVYg
c3VtbWl0IGtleW5vdGUgWzFdIHNpbmdsZSB0aHJlYWRlZAo+ID5wZXJmb3JtYW5jZSBpcyBsaW1p
dGluZyBkdWUgdG8gRGVuYXJkIHNjYWxpbmcgYW5kIG11bHRpLXRocmVhZGVkCj4gPnBlcmZvcm1h
bmNlIGlzIHNsb3dpbmcgZG93biBkdWUgTW9vcmUncyBsYXcgbGltaXRhdGlvbnMuIFdpdGggdGhl
IHJpc2UKPiA+b2YgU05JQSBDb21wdXRhdGlvbiBUZWNobmljYWwgU3RvcmFnZSBXb3JraW5nIEdy
b3VwIChUV0cpIFsyXSwKPiA+b2ZmbG9hZGluZyBjb21wdXRhdGlvbnMgdG8gdGhlIGRldmljZSBv
ciBvdmVyIHRoZSBmYWJyaWNzIGlzIGJlY29taW5nCj4gPnBvcHVsYXIgYXMgdGhlcmUgYXJlIHNl
dmVyYWwgc29sdXRpb25zIGF2YWlsYWJsZSBbMl0uIE9uZSBvZiB0aGUgY29tbW9uCj4gPm9wZXJh
dGlvbiB3aGljaCBpcyBwb3B1bGFyIGluIHRoZSBrZXJuZWwgYW5kIGlzIG5vdCBtZXJnZWQgeWV0
IGlzIENvcHkKPiA+b2ZmbG9hZCBvdmVyIHRoZSBmYWJyaWNzIG9yIG9uIHRvIHRoZSBkZXZpY2Uu
Cj4gPgo+ID4qIFByb2JsZW0gOi0KPiA+LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KPiA+Cj4gPlRoZSBvcmlnaW5h
bCB3b3JrIHdoaWNoIGlzIGRvbmUgYnkgTWFydGluIGlzIHByZXNlbnQgaGVyZSBbM10uIFRoZQo+
ID5sYXRlc3Qgd29yayB3aGljaCBpcyBwb3N0ZWQgYnkgTWlrdWxhcyBbNF0gaXMgbm90IG1lcmdl
ZCB5ZXQuIFRoZXNlIHR3bwo+ID5hcHByb2FjaGVzIGFyZSB0b3RhbGx5IGRpZmZlcmVudCBmcm9t
IGVhY2ggb3RoZXIuIFNldmVyYWwgc3RvcmFnZQo+ID52ZW5kb3JzIGRpc2NvdXJhZ2UgbWl4aW5n
IGNvcHkgb2ZmbG9hZCByZXF1ZXN0cyB3aXRoIHJlZ3VsYXIgUkVBRC9XUklURQo+ID5JL08uIEFs
c28sIHRoZSBmYWN0IHRoYXQgdGhlIG9wZXJhdGlvbiBmYWlscyBpZiBhIGNvcHkgcmVxdWVzdCBl
dmVyCj4gPm5lZWRzIHRvIGJlIHNwbGl0IGFzIGl0IHRyYXZlcnNlcyB0aGUgc3RhY2sgaXQgaGFz
IHRoZSB1bmZvcnR1bmF0ZQo+ID5zaWRlLWVmZmVjdCBvZiBwcmV2ZW50aW5nIGNvcHkgb2ZmbG9h
ZCBmcm9tIHdvcmtpbmcgaW4gcHJldHR5IG11Y2gKPiA+ZXZlcnkgY29tbW9uIGRlcGxveW1lbnQg
Y29uZmlndXJhdGlvbiBvdXQgdGhlcmUuCj4gPgo+ID4qIEN1cnJlbnQgc3RhdGUgb2YgdGhlIHdv
cmsgOi0KPiA+LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KPiA+Cj4gPldpdGggWzNdIGJlaW5nIGhhcmQgdG8gaGFu
ZGxlIGFyYml0cmFyeSBETS9NRCBzdGFja2luZyB3aXRob3V0Cj4gPnNwbGl0dGluZyB0aGUgY29t
bWFuZCBpbiB0d28sIG9uZSBmb3IgY29weWluZyBJTiBhbmQgb25lIGZvciBjb3B5aW5nCj4gPk9V
VC4gV2hpY2ggaXMgdGhlbiBkZW1vbnN0cmF0ZWQgYnkgdGhlIFs0XSB3aHkgWzNdIGl0IGlzIG5v
dCBhIHN1aXRhYmxlCj4gPmNhbmRpZGF0ZS4gQWxzbywgd2l0aCBbNF0gdGhlcmUgaXMgYW4gdW5y
ZXNvbHZlZCBwcm9ibGVtIHdpdGggdGhlCj4gPnR3by1jb21tYW5kIGFwcHJvYWNoIGFib3V0IGhv
dyB0byBoYW5kbGUgY2hhbmdlcyB0byB0aGUgRE0gbGF5b3V0Cj4gPmJldHdlZW4gYW4gSU4gYW5k
IE9VVCBvcGVyYXRpb25zLgo+ID4KPiA+V2UgaGF2ZSBjb25kdWN0ZWQgYSBjYWxsIHdpdGggaW50
ZXJlc3RlZCBwZW9wbGUgbGF0ZSBsYXN0IHllYXIgc2luY2UKPiA+bGFjayBvZiBMU0ZNTU0gYW5k
IHdlIHdvdWxkIGxpa2UgdG8gc2hhcmUgdGhlIGRldGFpbHMgd2l0aCBicm9hZGVyCj4gPmNvbW11
bml0eSBtZW1iZXJzLgo+Cj4gQ2hhaXRhbnlhLAo+Cj4gSSB3b3VsZCBhbHNvIGxpa2UgdG8gam9p
biB0aGUgRjJGIGNvbnZlcnNhdGlvbiBhcyBhIGZvbGxvdyB1cCBvZiB0aGUKPiB2aXJ0dWFsIG9u
ZSBsYXN0IHllYXIuIFdlIHdpbGwgaGF2ZSBhIGZpcnN0IHZlcnNpb24gb2YgdGhlIHBhdGNoZXMK
PiBwb3N0ZWQgaW4gdGhlIG5leHQgZmV3IHdlZWtzLiBUaGlzIHdpbGwgaG9wZWZ1bGx5IHNlcnZl
IGFzIGEgZ29vZCBmaXJzdAo+IHN0ZXAuCj4KPiBBZGRpbmcgS2FuY2hhbiB0byB0aHJlYWQgdG9v
Lgo+Cj4gSmF2aWVyCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5j
b20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

