Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89052C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 13 May 2022 22:09:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-uXzZSmZoPuih_fl1PMOIBw-1; Fri, 13 May 2022 18:09:56 -0400
X-MC-Unique: uXzZSmZoPuih_fl1PMOIBw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 348F53804062;
	Fri, 13 May 2022 22:09:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DA49F40D2822;
	Fri, 13 May 2022 22:09:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7F9E91932238;
	Fri, 13 May 2022 22:09:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 86B4F194975B
 for <dm-devel@listman.corp.redhat.com>; Fri, 13 May 2022 22:09:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 29B712166B18; Fri, 13 May 2022 22:09:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 24EAB2166B16
 for <dm-devel@redhat.com>; Fri, 13 May 2022 22:09:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F2D3101A52C
 for <dm-devel@redhat.com>; Fri, 13 May 2022 22:09:46 +0000 (UTC)
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com
 [209.85.214.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-rfecWxoaN9GD42zf6kjUNw-1; Fri, 13 May 2022 18:09:44 -0400
X-MC-Unique: rfecWxoaN9GD42zf6kjUNw-1
Received: by mail-pl1-f177.google.com with SMTP id n18so9208924plg.5
 for <dm-devel@redhat.com>; Fri, 13 May 2022 15:09:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=Mip6GB+UOxs40OE0wM8HSHN4JOWEcgh6ZJadFhE8R6M=;
 b=vD7cM/LTOLWWCZfi4cogmLcVHmWRzHZ+SLAX/OD2/all+JrY3adVJCL72bknp+g6KE
 SzHcsub42iixZNmf2pF/UlB4u7yhediSqfj+dcrv9vTaHB6shgIHipNRT/2A6lpn/+dK
 QtYgVRiDFKGMgStW6C9ldJXOyydf6FB5sMF2DkVywLrpy9SXCkmq3oxH/UaXWLh/XCoB
 Jf0P5Ul7wyzoIQ+qqMavNAonEOIT/xrzCaDpKsrj0c89E+z2YJ1CL9wCnEzUsAI+Q3kq
 Jw61KLXojaqcNFrpqaJYzkHf3PrT2E1X7lQuZ93y9VpiN08Azx73p8PoNTiXsBBXINT3
 1rkA==
X-Gm-Message-State: AOAM5318QqvsmU6JUQQBM/AgfDFlLShYA742ffEW1I7GyIl9AooNBh4K
 Ajx8P3mgcNwwX0WbeJ5/VK5vDAE+gLIWvsD7aHHZPw==
X-Google-Smtp-Source: ABdhPJzpfY8MlgI5f++tvopz4LYKd5ilu/z06Js/hnaOsL1+374Mzjwb83UO8JaxESRupngEQCtjfZyPDj2zPFQAv3s=
X-Received: by 2002:a17:90b:3845:b0:1dc:a733:2ece with SMTP id
 nl5-20020a17090b384500b001dca7332ecemr6990831pjb.220.1652479783256; Fri, 13
 May 2022 15:09:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220422224508.440670-5-jane.chu@oracle.com>
 <165247892149.4131000.9240706498758561525.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <165247892149.4131000.9240706498758561525.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 May 2022 15:09:32 -0700
Message-ID: <CAPcyv4g8Tkx_b_Rs1WeAeV1knxV-z2r7Gmf56b8XN=CTyj6RVQ@mail.gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v10 4/7] dax: introduce DAX_RECOVERY_WRITE
 dax access mode
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
Cc: Jane Chu <jane.chu@oracle.com>, Linux NVDIMM <nvdimm@lists.linux.dev>,
 Mike Snitzer <snitzer@redhat.com>,
 device-mapper development <dm-devel@redhat.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
 Vivek Goyal <vgoyal@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBNYXkgMTMsIDIwMjIgYXQgMjo1NiBQTSBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxp
YW1zQGludGVsLmNvbT4gd3JvdGU6Cj4KPiBGcm9tOiBKYW5lIENodSA8amFuZS5jaHVAb3JhY2xl
LmNvbT4KPgo+IFVwIHRpbGwgbm93LCBkYXhfZGlyZWN0X2FjY2VzcygpIGlzIHVzZWQgaW1wbGlj
aXRseSBmb3Igbm9ybWFsCj4gYWNjZXNzLCBidXQgZm9yIHRoZSBwdXJwb3NlIG9mIHJlY292ZXJ5
IHdyaXRlLCBkYXggcmFuZ2Ugd2l0aAo+IHBvaXNvbiBpcyByZXF1ZXN0ZWQuICBUbyBtYWtlIHRo
ZSBpbnRlcmZhY2UgY2xlYXIsIGludHJvZHVjZQo+ICAgICAgICAgZW51bSBkYXhfYWNjZXNzX21v
ZGUgewo+ICAgICAgICAgICAgICAgICBEQVhfQUNDRVNTLAo+ICAgICAgICAgICAgICAgICBEQVhf
UkVDT1ZFUllfV1JJVEUsCj4gICAgICAgICB9Cj4gd2hlcmUgREFYX0FDQ0VTUyBpcyB1c2VkIGZv
ciBub3JtYWwgZGF4IGFjY2VzcywgYW5kCj4gREFYX1JFQ09WRVJZX1dSSVRFIGlzIHVzZWQgZm9y
IGRheCByZWNvdmVyeSB3cml0ZS4KPgo+IFN1Z2dlc3RlZC1ieTogRGFuIFdpbGxpYW1zIDxkYW4u
ai53aWxsaWFtc0BpbnRlbC5jb20+Cj4gU2lnbmVkLW9mZi1ieTogSmFuZSBDaHUgPGphbmUuY2h1
QG9yYWNsZS5jb20+Cj4gUmV2aWV3ZWQtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRl
Pgo+IENjOiBWaXZlayBHb3lhbCA8dmdveWFsQHJlZGhhdC5jb20+Cj4gQ2M6IE1pa2UgU25pdHpl
ciA8c25pdHplckByZWRoYXQuY29tPgo+IFNpZ25lZC1vZmYtYnk6IERhbiBXaWxsaWFtcyA8ZGFu
Lmoud2lsbGlhbXNAaW50ZWwuY29tPgpbLi5dCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcv
bnZkaW1tL3BtZW0tZGF4LmMgYi90b29scy90ZXN0aW5nL252ZGltbS9wbWVtLWRheC5jCj4gaW5k
ZXggYWYxOWM4NTU1OGU3Li5kY2MzMjhlYmE4MTEgMTAwNjQ0Cj4gLS0tIGEvdG9vbHMvdGVzdGlu
Zy9udmRpbW0vcG1lbS1kYXguYwo+ICsrKyBiL3Rvb2xzL3Rlc3RpbmcvbnZkaW1tL3BtZW0tZGF4
LmMKPiBAQCAtOCw3ICs4LDggQEAKPiAgI2luY2x1ZGUgPG5kLmg+Cj4KPiAgbG9uZyBfX3BtZW1f
ZGlyZWN0X2FjY2VzcyhzdHJ1Y3QgcG1lbV9kZXZpY2UgKnBtZW0sIHBnb2ZmX3QgcGdvZmYsCj4g
LSAgICAgICAgICAgICAgIGxvbmcgbnJfcGFnZXMsIHZvaWQgKiprYWRkciwgcGZuX3QgKnBmbikK
PiArICAgICAgICAgICAgICAgbG9uZyBucl9wYWdlcywgZW51bSBkYXhfYWNjZXNzX21vZGUgbW9k
ZSwgdm9pZCAqKmthZGRyLAo+ICsgICAgICAgICAgICAgICBwZm5fdCAqcGZuKQoKTG9jYWwgYnVp
bGQgdGVzdCByZXBvcnRzOgoKdG9vbHMvdGVzdGluZy9udmRpbW0vcG1lbS1kYXguYzoxMTo1Mzog
ZXJyb3I6IHBhcmFtZXRlciA0ICjigJhtb2Rl4oCZKSBoYXMKaW5jb21wbGV0ZSB0eXBlCiAgIDEx
IHwgICAgICAgICAgICAgICAgIGxvbmcgbnJfcGFnZXMsIGVudW0gZGF4X2FjY2Vzc19tb2RlIG1v
ZGUsIHZvaWQgKiprYWRkciwKICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
fn5+fn5+fn5+fn5+fn5+fn5+fn5+Xn5+fgoKCi4uLnNvIG5lZWQgdG8gaW5jbHVkZSBsaW51eC9k
YXguaCBpbiB0aGlzIGZpbGUgbm93IGZvciB0aGF0IGRlZmluaXRpb24uCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

