Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83294CD98CA
	for <dm-devel@archiver.kernel.org>; Tue, 10 Oct 2023 22:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696977786;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RDIFCz2SjVEaUy1Z5yhgmHZe+sxSQJzNNZHCdxYmeKU=;
	b=XNtzGFHpL9i05c5HE2X68ODBgF+krKI8U2+EzPHhKIrOuN/+IDSp3ynevB2TY+sdjRhiQ5
	CofCY3qU9xrav66EmNz3wmUSW4p7dgmoAti4IQ3+Po45zLMG+cPNbH2o5WXHN0Qgl9DdAR
	9GOsHZxaiaoWBX8dTwqW3iX358qwe7A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-LiSLm8bBMNyBW0tlpmO8UQ-1; Tue, 10 Oct 2023 18:43:03 -0400
X-MC-Unique: LiSLm8bBMNyBW0tlpmO8UQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 478A08007A4;
	Tue, 10 Oct 2023 22:43:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 513A72026D37;
	Tue, 10 Oct 2023 22:42:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 19E9719465B8;
	Tue, 10 Oct 2023 22:42:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9D0121946597
 for <dm-devel@listman.corp.redhat.com>; Tue, 10 Oct 2023 22:42:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 794FD9A; Tue, 10 Oct 2023 22:42:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 712B463F45
 for <dm-devel@redhat.com>; Tue, 10 Oct 2023 22:42:56 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5481F3816D84
 for <dm-devel@redhat.com>; Tue, 10 Oct 2023 22:42:56 +0000 (UTC)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com
 [209.85.218.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-rs5KqZZPMICwGsGwlyc5jQ-1; Tue, 10 Oct 2023 18:42:52 -0400
X-MC-Unique: rs5KqZZPMICwGsGwlyc5jQ-1
Received: by mail-ej1-f52.google.com with SMTP id
 a640c23a62f3a-9b27bc8b65eso1037625066b.0
 for <dm-devel@redhat.com>; Tue, 10 Oct 2023 15:42:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696977771; x=1697582571;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=tb9bykOj2PFr0JPtI/2Jn1spETOn70fv/I2YmNILcfw=;
 b=OsVhIjnZ6f4IzP36BORdE8kk3sy/hETWEWxX++xeT0ZBFouMYG0p/GnkEd6xXmyNiD
 vpN55VQ19cATHGF35w0mdQRS66dKeN9xoginErNXipcTFV8CayMdpQ2YYI+t2CQohX1a
 2BUfuauSz+GTXkodyxUUJG2T3Iv967vck7iSbhKBp9W2JQuvmQEaL5pfQN3sVmyWuuc5
 V/SgAnvEjMnkJJEf9xDRd3uv5RQC0sWAko3G3e0cllk7IzTt3AwNMfCHV9WATqjUTKem
 gmAmYANuRw1T75tRUiO+rdz7F1RJtIrRwItpLBsZTkkzkmfenozqlctep4bkvMXyRXPK
 +fGg==
X-Gm-Message-State: AOJu0Yxs4+p1zUscIvci1dSfE9gYCtu8aUELd0RjXoWsXpbgHIbs3w8e
 z9YzAbCRClmFWNSIHpgntYisZp9J74SbJIKt//5hgg==
X-Google-Smtp-Source: AGHT+IHovl1AnfLJUnwNPKM37IAziJkKti9gYfE82FUNcROx92edpN/rECBAy7Ui9Lg+Iqjm2+QUlHjRja83n7tAqZI=
X-Received: by 2002:a17:906:9a:b0:9b2:b149:b818 with SMTP id
 26-20020a170906009a00b009b2b149b818mr17960595ejc.70.1696977771190; Tue, 10
 Oct 2023 15:42:51 -0700 (PDT)
MIME-Version: 1.0
References: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
 <20231007012817.3052558-6-sarthakkukreti@chromium.org>
 <ZSM64EOTVyKNkc/X@dread.disaster.area>
In-Reply-To: <ZSM64EOTVyKNkc/X@dread.disaster.area>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Tue, 10 Oct 2023 15:42:39 -0700
Message-ID: <CAG9=OMP_YbfCyjJGGwoZfgwxO-FmR55F5zv3DO8c2-=YzY8iwA@mail.gmail.com>
To: Dave Chinner <david@fromorbit.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v8 5/5] block: Pass unshare intent via
 REQ_OP_PROVISION
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>,
 Brian Foster <bfoster@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU3VuLCBPY3QgOCwgMjAyMyBhdCA0OjI34oCvUE0gRGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9t
b3JiaXQuY29tPiB3cm90ZToKPgo+IE9uIEZyaSwgT2N0IDA2LCAyMDIzIGF0IDA2OjI4OjE3UE0g
LTA3MDAsIFNhcnRoYWsgS3VrcmV0aSB3cm90ZToKPiA+IEFsbG93IFJFUV9PUF9QUk9WSVNJT04g
dG8gcGFzcyBpbiBhbiBleHRyYSBSRVFfVU5TSEFSRSBiaXQgdG8KPiA+IGFubm90YXRlIHVuc2hh
cmUgcmVxdWVzdHMgdG8gdW5kZXJseWluZyBsYXllcnMuIExheWVycyB0aGF0IHN1cHBvcnQKPiA+
IEZBTExPQ19GTF9VTlNIQVJFIHdpbGwgYmUgYWJsZSB0byB1c2UgdGhpcyBhcyBhbiBpbmRpY2F0
b3Igb2Ygd2hpY2gKPiA+IGZhbGxvY2F0ZSgpIG1vZGUgdG8gdXNlLgo+ID4KPiA+IFN1Z2dlc3Rl
ZC1ieTogRGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4KPiA+IFNpZ25lZC1vZmYt
Ynk6IFNhcnRoYWsgS3VrcmV0aSA8c2FydGhha2t1a3JldGlAY2hyb21pdW0ub3JnPgo+ID4gLS0t
Cj4gPiAgYmxvY2svYmxrLWxpYi5jICAgICAgICAgICB8ICA2ICsrKysrLQo+ID4gIGJsb2NrL2Zv
cHMuYyAgICAgICAgICAgICAgfCAgNiArKysrLS0KPiA+ICBkcml2ZXJzL2Jsb2NrL2xvb3AuYyAg
ICAgIHwgMzUgKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0KPiA+ICBpbmNsdWRl
L2xpbnV4L2Jsa190eXBlcy5oIHwgIDMgKysrCj4gPiAgaW5jbHVkZS9saW51eC9ibGtkZXYuaCAg
ICB8ICAzICsrLQo+ID4gIDUgZmlsZXMgY2hhbmdlZCwgNDMgaW5zZXJ0aW9ucygrKSwgMTAgZGVs
ZXRpb25zKC0pCj4KPiBJIGhhdmUgbm8gaWRlYSBob3cgZmlsZXN5c3RlbXMgKG9yIGV2ZW4gdXNl
cnNwYWNlIGFwcGxpY2F0aW9ucywgZm9yCj4gdGhhdCBtYXR0ZXIpIGFyZSBzdXBwb3NlZCB0byB1
c2UgdGhpcyAtIHRoZXkgaGF2ZSBubyBpZGVhIGlmIHRoZQo+IHVuZGVybHlpbmcgYmxvY2sgZGV2
aWNlIGhhcyBzaGFyZWQgYmxvY2tzIGZvciBMQkEgcmFuZ2VzIGl0IGFscmVhZHkKPiBoYXMgYWxs
b2NhdGVkIGFuZCBwcm92aXNpb25lZC4gSU9XcywgSSBkb24ndCBrbm93IHdhaHQgdGhlIHNlbWFu
dGljcwo+IG9mIHRoaXMgZnVuY3Rpb24gaXMsIGl0IGlzIG5vdCBkb2N1bWVudGVkIGFueXdoZXJl
LCBhbmQgdGhlcmUgaXMgbm8KPiB1c2UgY2FzZSBwcmVzZW50IHRoYXQgdGVsbHMgbWUgaG93IGl0
IG1pZ2h0IGdldCB1c2VkLgo+Cj4gWWVzLCB1bnNoYXJlIGF0IHRoZSBmaWxlIGxldmVsIG1lYW5z
IHRoZSBmaWxlc3lzdGVtIHRyaWVzIHRvIGJyZWFrCj4gaW50ZXJuYWwgZGF0YSBleHRlbnQgc2hh
cmluZywgYnV0IGlmIHRoZSBibG9jayBsYXllcnMgb3IgYmFja2luZwo+IGRldmljZXMgYXJlIGRv
aW5nIGRlZHVwbGljYXRpb24gYW5kIHNoYXJpbmcgdW5rbm93biB0byB0aGUKPiBhcHBsaWNhdGlv
biBvciBmaWxlc3lzdGVtLCBob3cgZG8gdGhleSBldmVyIGtub3cgdGhhdCB0aGlzIG9wZXJhdGlv
bgo+IG1pZ2h0IG5lZWQgdG8gYmUgcGVyZm9ybWVkPyBJbiB3aGF0IGNhc2VzIGRvIHdlIG5lZWQg
dG8gYmUgYWJsZSB0bwo+IHVuc2hhcmUgYmxvY2sgZGV2aWNlIHJhbmdlcywgYW5kIGhvdyBpcyB0
aGF0IGRpZmZlcmVudCB0byB0aGUKPiBndWFyYW50ZWVzIHRoYXQgUkVRX1BST1ZJU0lPTiBpcyBh
bHJlYWR5IHN1cHBvc2VkIHRvIGdpdmUgZm9yCj4gcHJvdmlzaW9uZWQgcmFuZ2VzIHRoYXQgYXJl
IHRoZW4gc3Vic2VxdWVudGx5IHNoYXJlZCBieSB0aGUgYmxvY2sKPiBkZXZpY2UgKGUuZy4gYnkg
c25hcHNob3RzKT8KPgo+IEFsc28sIGZyb20gYW4gQVBJIHBlcnNwZWN0aXZlLCB0aGlzIGlzIGFu
ICJ1bnNoYXJlIiBkYXRhIG9wZXJhdGlvbiwKPiBub3QgYSAicHJvdmlzaW9uIiBvcGVyYXRpb24u
IEhlbmNlIEknZCBzdWdnZXN0IHRoYXQgdGhlIEFQSSBzaG91bGQKPiBiZSBibGtkZXZfaXNzdWVf
dW5zaGFyZSgpIHJhdGhlciB0aGFuIG9wdGlvbmFsIGJlaGF2aW91ciB0bwo+IF9wcm92aXNpb24o
KSB3aGljaCAtIGJlZm9yZSB0aGlzIHBhdGNoIC0gaGFkIGNsZWFyIGFuZCB3ZWxsIGRlZmluZWQK
PiBtZWFuaW5nLi4uLgo+CkZhaXIgcG9pbnRzLCB0aGUgaW50ZW50IGZyb20gdGhlIGNvbnZlcnNh
dGlvbiB3aXRoIERhcnJpY2sgd2FzIHRoZQphZGRpdGlvbiBvZiBzdXBwb3J0IGZvciBGQUxMT0Nf
RkxfVU5TSEFSRV9SQU5HRSBpbiBwYXRjaCAyIG9mIHY0CihvcmlnaW5hbGx5IHN1Z2dlc3RlZCBi
eSBCcmlhbiBGb3JzdGVyIGluIFsxXSk6IGlmIHdlIGFsbG93CmZhbGxvY2F0ZShVTlNIQVJFX1JB
TkdFKSBvbiBhIGxvb3AgZGV2aWNlIChleC4gZm9yIGNyZWF0aW5nIGEKc25hcHNob3QsIHNpbWls
YXIgaW4gbmF0dXJlIHRvIHRoZSBGSUNMT05FIGV4YW1wbGUgeW91IG1lbnRpb25lZCBvbgp0aGUg
bG9vcCBwYXRjaCksIHdlJ2QgKGlkZWFsbHkpIHdhbnQgdG8gcGFzcyBpdCB0aHJvdWdoIHRvIHRo
ZQp1bmRlcmx5aW5nIGxheWVycyBhbmQgbGV0IHRoZW0gZmlndXJlIG91dCB3aGF0IHRvIGRvIHdp
dGggaXQuIEJ1dCBpdAppcyBvbmx5IGZvciBzaXR1YXRpb25zIHdoZXJlIHdlIGFyZSBleHBsaWNp
dGx5IGtub3cgd2hhdCB0aGUKdW5kZXJseWluZyBsYXllcnMgYXJlIGFuZCB3aGF0J3MgdGhlIG1l
Y2hhCgpJIGFncmVlIHRob3VnaCB0aGF0IGl0IGNsb3VkcyB0aGUgQVBJIGEgYml0IGFuZCBJIGRv
bid0IHRoaW5rIGl0Cm5lY2Vzc2FyaWx5IG5lZWRzIHRvIGJlIGEgcGFydCBvZiB0aGUgaW5pdGlh
bCBwYXRjaCBzZXJpZXM6IGZvciBub3csIEkKcHJvcG9zZSBrZWVwaW5nIGp1c3QgbW9kZSB6ZXJv
IChhbmQgRkFMTE9DX0ZMX0tFRVBfU0laRSkgaGFuZGxpbmcgaW4KdGhlIGJsb2NrIHNlcmllcyBw
YXRjaCBhbmQgZHJvcCB0aGlzIHBhdGNoIGZvciBub3cuIFdEWVQ/CgpCZXN0ClNhcnRoYWsKClsx
XSBodHRwczovL3BhdGNod29yay5vemxhYnMub3JnL3Byb2plY3QvbGludXgtZXh0NC9wYXRjaC8y
MDIzMDQxNDAwMDIxOS45MjY0MC0yLXNhcnRoYWtrdWtyZXRpQGNocm9taXVtLm9yZy8jMzA5Nzc0
NgoKCgoKPiBDaGVlcnMsCj4KPiBEYXZlLgo+IC0tCj4gRGF2ZSBDaGlubmVyCj4gZGF2aWRAZnJv
bW9yYml0LmNvbQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20K
aHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

