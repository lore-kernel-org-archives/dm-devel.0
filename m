Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29B62C77B7D
	for <dm-devel@archiver.kernel.org>; Mon, 15 May 2023 17:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684171588;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/vwSGKwDr92IF7g3fsCXbTeLtTlRFhKMK82sD0s0iEI=;
	b=YcdGl5uf9nPezAnXVnNSqQ+0c1LAXz4BX7FX1zvLpkzHnKlzMfv0YIh23qhdCqP5FVIA0n
	vfc+73Ujeo9YewZh18zeiLFNIL4aTfWTeaZNUAAuzNSzTZFwPgpHZhs9fD9XkK4dDFwqtG
	xafduy9PdhaV8jB4piF+LYsc3sMyIxE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-299-ONl_PiC8OvGimPkxKXubKQ-1; Mon, 15 May 2023 13:26:24 -0400
X-MC-Unique: ONl_PiC8OvGimPkxKXubKQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2019D8037A8;
	Mon, 15 May 2023 17:26:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 371A414171B6;
	Mon, 15 May 2023 17:26:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 061A51946595;
	Mon, 15 May 2023 17:26:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 89C9D194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 15 May 2023 17:26:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7865740C206F; Mon, 15 May 2023 17:26:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 70F0640C2063
 for <dm-devel@redhat.com>; Mon, 15 May 2023 17:26:19 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (unknown [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54C55185A790
 for <dm-devel@redhat.com>; Mon, 15 May 2023 17:26:19 +0000 (UTC)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com
 [209.85.208.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563--ATZEGXgN02h71glqQmJ0A-1; Mon, 15 May 2023 13:26:17 -0400
X-MC-Unique: -ATZEGXgN02h71glqQmJ0A-1
Received: by mail-lj1-f182.google.com with SMTP id
 38308e7fff4ca-2ac82b07eb3so132422091fa.1
 for <dm-devel@redhat.com>; Mon, 15 May 2023 10:26:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684171575; x=1686763575;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=hwplf6p4dB5XcAcn8hfIwGjSNgsXkRHxLTyJ9FtxsyY=;
 b=XK1XKBZSNlZ3USTGJw19Q9yrimOruGVy039gu2iL/udi1Is4lvTLa9AIp4ulAV1WXB
 hAIiFoav1+T4fqH+yQSgG1E88jmrupg5To3zJgT03b149OlugyHLPAth7IY6FOUp1ZgN
 d7iobUVHb3kGPZRS/kMmfQcOnllnQDCCvm7x1K9zVrMsOZmLwkspYOd5ru+SO1j7ifPz
 fnyNQB7N48FyF5s3jPh+Y429ety+KtFUFn5LdIUXcdC5t+p9BZectPDQCcICPQSaXuPw
 glPcPUZyD22LrrjFni6Se/nkENm/xxk2ZKP2Gjl997gQbwh/a8LbANdmYXH9Fct6LY0W
 Osuw==
X-Gm-Message-State: AC+VfDx4C1jXY/rrtAH6r+r5YLdwuAHZyJZHt7hCRTLOiCQc7o0oq7pW
 WcE3mpmhpU5LeFm+5AxgiVtTPlue3pT5w3tsFWgUrBXTEGT8zw==
X-Google-Smtp-Source: ACHHUZ5cDIYLU4r+iJ5QbrgnCCEh+6Sj3lUQxHgyczuP2SJqUzKFUNfk0Vy78S3ylVIsWt6KODt80KQtjrt5RcQGScM=
X-Received: by 2002:a19:ac0c:0:b0:4f2:5f41:438f with SMTP id
 g12-20020a19ac0c000000b004f25f41438fmr5462543lfc.30.1684171574877; Mon, 15
 May 2023 10:26:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAF1ivSZJjVq313Zg9nBF0S3DOun=-Vw8saZGPU5cGrB_woM-8g@mail.gmail.com>
 <2aafd5fc-26b4-fa82-4149-a72adf6722b9@suse.de>
 <CAF1ivSaVEr_q9eN0_UpYTdDRsDcVjC17pbVUKbv_X1A3gSKDKw@mail.gmail.com>
 <5e12d3ba-0a12-d3f9-15ba-140cd4909705@suse.de>
 <2505d45e-660f-08ef-0245-9906e16c2b53@kernel.org>
In-Reply-To: <2505d45e-660f-08ef-0245-9906e16c2b53@kernel.org>
From: Ming Lin <minggr@gmail.com>
Date: Mon, 15 May 2023 10:26:03 -0700
Message-ID: <CAF1ivSYN8JrBaoKusAy0eE-J_6mMhpB9KaayLigZZZZ=N+q4ww@mail.gmail.com>
To: Damien Le Moal <dlemoal@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] Does dm-zoned support buffered write?
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBNYXkgMTUsIDIwMjMgYXQgNDo0NuKAr0FNIERhbWllbiBMZSBNb2FsIDxkbGVtb2Fs
QGtlcm5lbC5vcmc+IHdyb3RlOgo+ID4+Cj4gPj4gPT09Cj4gPj4gQXQgYW5vdGhlciB0ZXJtaW5h
bCwKPiA+Pgo+ID4+IHJvb3RAc21yX2Rldjp+IyBwcyBhdXggfCBncmVwIG1rZnMuZXh0NAo+ID4+
IHJvb3QgICAgIDE0MTE3OTEgIDIuOCAgMC4wICAzMDk5MiAxOTg2NCBwdHMvMSAgICBEKyAgIDAx
OjMwICAgMDowMQo+ID4+IG1rZnMuZXh0NCAvZGV2L2RtLTAKPiA+PiByb290ICAgICAxNDEzNjQw
ICAwLjAgIDAuMCAgMTM5NzIgIDI0OTYgcHRzLzAgICAgUysgICAwMTozMSAgIDA6MDAKPiA+PiBn
cmVwIG1rZnMuZXh0NAo+ID4+Cj4gPj4gcm9vdEBzbXJfZGV2On4jIGNhdCAvcHJvYy8xNDExNzkx
L3N0YWNrCj4gPj4gWzwwPl0gd2FpdF9vbl9wYWdlX2JpdCsweDEzMy8weDI3MAo+ID4+IFs8MD5d
IHdhaXRfb25fcGFnZV93cml0ZWJhY2srMHgyNS8weDcwCj4gPj4gWzwwPl0gX19maWxlbWFwX2Zk
YXRhd2FpdF9yYW5nZSsweDg2LzB4ZjAKPiA+PiBbPDA+XSBmaWxlX3dyaXRlX2FuZF93YWl0X3Jh
bmdlKzB4NzQvMHhiMAo+ID4+IFs8MD5dIGJsa2Rldl9mc3luYysweDE2LzB4NDAKPiA+PiBbPDA+
XSBkb19mc3luYysweDM4LzB4NjAKPiA+PiBbPDA+XSBfX3g2NF9zeXNfZnN5bmMrMHgxMC8weDIw
Cj4gPj4gWzwwPl0gZG9fc3lzY2FsbF82NCsweDJkLzB4NzAKPiA+PiBbPDA+XSBlbnRyeV9TWVND
QUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg0NC8weGE5Cj4KPiBOb3Qgc3VyZSBpZiB0aGlzIGlzIGEg
YnVnLCBidXQgZG9pbmcgYSBzaW1wbGUgbWtmcy5leHQ0IG9uIGRtLXpvbmVkIHdpdGggYSBsYXJn
ZQo+IFNNUiBkaXNrIGNhbiB0YWtlICphIHZlcnkgbG9vb29vb25nKiB0aW1lLiBUaGlzIGlzIGJl
Y2F1c2UgbWtmcy5leHQ0IGRvZXMgYSBsb3QKPiBvZiByYW5kb20gd3JpdGVzIGFsbCBvdmVyIHRo
ZSBwbGFjZS4gU28ganVzdCBydW5uaW5nIHRoYXQsIGRtLXpvbmVkIGdvZXMgaW50bwo+IGhlYXZ5
IEdDIG1vZGUuLi4KPgo+IFRvIHNwZWVkIHRoaW5ncyB1cCAoYW5kIGltcHJvdmUgcnVudGltZSBw
ZXJmb3JtYW5jZSksIHVzZSB0aGUgcGFja2VkLW1ldGFkYXRhCj4gZm9ybWF0OiBta2ZzLmV4dDQg
LUUgcGFja2VkX21ldGFfYmxvY2tzPTEKPiBPciBkbyBhIG1rZnMueGZzIHRvIGNvbXBhcmUgYW5k
IHNlZSBob3cgbXVjaCBmYXN0ZXIgaXQgaXMuCgpNeSBTTVIgZGlzayBpcyAyNFQsIDk2OSBjb252
ZW50aW9uYWwgem9uZXMgKyA5NTg5MSBzZXF1ZW50aWFsIHpvbmVzLAplYWNoIHpvbmUgaXMgMjU2
TS4KCkFtYXppbmdseSwgbWtmcy54ZnMgb25seSB0YWtlcyB+OCBzZWNvbmRzIGFuZCBta2ZzLmV4
dDQgLUUKcGFja2VkX21ldGFfYmxvY2tzPTEgb25seSB0YWtlcyAzMiBzZWNvbmRzLgpUaGFua3Mh
Cgpyb290QHNtcl9kZXY6fiMgdGltZSBta2ZzLnhmcyAvZGV2L2RtLTMKbWV0YS1kYXRhPS9kZXYv
ZG0tMyAgICAgICAgICAgICAgaXNpemU9NTEyICAgIGFnY291bnQ9MjQsIGFnc2l6ZT0yNjg0MzU0
NTUgYmxrcwogICAgICAgICA9ICAgICAgICAgICAgICAgICAgICAgICBzZWN0c3o9NDA5NiAgYXR0
cj0yLCBwcm9qaWQzMmJpdD0xCiAgICAgICAgID0gICAgICAgICAgICAgICAgICAgICAgIGNyYz0x
ICAgICAgICBmaW5vYnQ9MSwgc3BhcnNlPTEsIHJtYXBidD0wCiAgICAgICAgID0gICAgICAgICAg
ICAgICAgICAgICAgIHJlZmxpbms9MApkYXRhICAgICA9ICAgICAgICAgICAgICAgICAgICAgICBi
c2l6ZT00MDk2ICAgYmxvY2tzPTYzNDYzNzUxNjgsIGltYXhwY3Q9NQogICAgICAgICA9ICAgICAg
ICAgICAgICAgICAgICAgICBzdW5pdD0wICAgICAgc3dpZHRoPTAgYmxrcwpuYW1pbmcgICA9dmVy
c2lvbiAyICAgICAgICAgICAgICBic2l6ZT00MDk2ICAgYXNjaWktY2k9MCwgZnR5cGU9MQpsb2cg
ICAgICA9aW50ZXJuYWwgbG9nICAgICAgICAgICBic2l6ZT00MDk2ICAgYmxvY2tzPTUyMTcyOCwg
dmVyc2lvbj0yCiAgICAgICAgID0gICAgICAgICAgICAgICAgICAgICAgIHNlY3Rzej00MDk2ICBz
dW5pdD0xIGJsa3MsIGxhenktY291bnQ9MQpyZWFsdGltZSA9bm9uZSAgICAgICAgICAgICAgICAg
ICBleHRzej00MDk2ICAgYmxvY2tzPTAsIHJ0ZXh0ZW50cz0wCgpyZWFsICAgIDBtOC44MzRzCnVz
ZXIgICAgMG0wLjAwMnMKc3lzICAgICAwbTAuMzIycwoKCnJvb3RAc21yX2Rldjp+IyB0aW1lIG1r
ZnMuZXh0NCAtRiAtRSBwYWNrZWRfbWV0YV9ibG9ja3M9MSAvZGV2L2RtLTMKbWtlMmZzIDEuNDQu
NSAoMTUtRGVjLTIwMTgpCi9kZXYvZG0tMyBjb250YWlucyBhIHhmcyBmaWxlIHN5c3RlbQpEaXNj
YXJkaW5nIGRldmljZSBibG9ja3M6IGRvbmUKQ3JlYXRpbmcgZmlsZXN5c3RlbSB3aXRoIDYzNDYz
NzUxNjggNGsgYmxvY2tzIGFuZCAzOTY2NDg0NDggaW5vZGVzCkZpbGVzeXN0ZW0gVVVJRDogOTMx
MzY2NDctMDIxNC00ZWEyLTg0MDMtMjU2MWE0Y2QzZTQyClN1cGVyYmxvY2sgYmFja3VwcyBzdG9y
ZWQgb24gYmxvY2tzOgogICAgICAgIDMyNzY4LCA5ODMwNCwgMTYzODQwLCAyMjkzNzYsIDI5NDkx
MiwgODE5MjAwLCA4ODQ3MzYsIDE2MDU2MzIsIDI2NTQyMDgsCiAgICAgICAgNDA5NjAwMCwgNzk2
MjYyNCwgMTEyMzk0MjQsIDIwNDgwMDAwLCAyMzg4Nzg3MiwgNzE2NjM2MTYsIDc4Njc1OTY4LAog
ICAgICAgIDEwMjQwMDAwMCwgMjE0OTkwODQ4LCA1MTIwMDAwMDAsIDU1MDczMTc3NiwgNjQ0OTcy
NTQ0LCAxOTM0OTE3NjMyLAogICAgICAgIDI1NjAwMDAwMDAsIDM4NTUxMjI0MzIsIDU4MDQ3NTI4
OTYKCkFsbG9jYXRpbmcgZ3JvdXAgdGFibGVzOiBkb25lCldyaXRpbmcgaW5vZGUgdGFibGVzOiBk
b25lCkNyZWF0aW5nIGpvdXJuYWwgKDI2MjE0NCBibG9ja3MpOiBkb25lCldyaXRpbmcgc3VwZXJi
bG9ja3MgYW5kIGZpbGVzeXN0ZW0gYWNjb3VudGluZyBpbmZvcm1hdGlvbjogZG9uZQoKCnJlYWwg
ICAgMG0zMi40NDlzCnVzZXIgICAgMG0wLjMyMHMKc3lzICAgICAwbTEuMTY1cwoKLS0KZG0tZGV2
ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

