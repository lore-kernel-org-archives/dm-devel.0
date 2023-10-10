Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B403FCD98CC
	for <dm-devel@archiver.kernel.org>; Wed, 11 Oct 2023 00:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696982402;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/tQ0c4f9mvxComTpzlggcdlGWMGAoAngOigFUxEjj9U=;
	b=AxrgHwSZagVLeHglwXktrQBIZXpVpGvOF2yNeE37VM8TXx+fJTmTGXD4/NToZQKtJyz5Y2
	w3LRDlr5U+6jCCj6dw2DK0afV18Q2B7q0heuVBx/25YUSIcMnHndMD5spRb5dC/fXKGU26
	DwMpHZMj5gXZy6uLSL81PcmEUAqzcCs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-0sTDytsjMpar4VdATRgnqQ-1; Tue, 10 Oct 2023 20:00:00 -0400
X-MC-Unique: 0sTDytsjMpar4VdATRgnqQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58BD6811E86;
	Tue, 10 Oct 2023 23:59:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D260E1C06533;
	Tue, 10 Oct 2023 23:59:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 85F1919465B8;
	Tue, 10 Oct 2023 23:59:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E7B031946597
 for <dm-devel@listman.corp.redhat.com>; Tue, 10 Oct 2023 23:59:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 90F1A492B05; Tue, 10 Oct 2023 23:59:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 897A7492B04
 for <dm-devel@redhat.com>; Tue, 10 Oct 2023 23:59:55 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A3E0811E7D
 for <dm-devel@redhat.com>; Tue, 10 Oct 2023 23:59:55 +0000 (UTC)
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com
 [209.85.210.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-rOvW6AnvMuuqUAp3atfnGg-1; Tue, 10 Oct 2023 19:59:48 -0400
X-MC-Unique: rOvW6AnvMuuqUAp3atfnGg-1
Received: by mail-pf1-f178.google.com with SMTP id
 d2e1a72fcca58-692c70bc440so4870617b3a.3
 for <dm-devel@redhat.com>; Tue, 10 Oct 2023 16:59:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696982387; x=1697587187;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=vuBhbcRCY14Ehqi0PTSDL9AEIBFyvO42CHNfxwJX88M=;
 b=E+86Hkr7pKcjE8Yd0eGVPXFkydHnPbkcyvfHSQyJE3HlCmedroyAAMz2lhWYv9/REq
 JljGd0fkH5epGRmoWrcJx2WUcD+ebbSnhwwvUKok/6nFtcUQMrMVGYaJsj8Rd30vLwz/
 SyEPeZGp7fZNHIMkP29k14bY4TCUw4MFCFy3X8JXjp05foBwd9yIF55yODhnMZp+PVTJ
 wJoQw5wjik7CiqzDSM1GNRkAnom0bKbOsiqa80+EoW3OVm6Hf8mzpTiyPJENWDUS11dv
 xf407J1HvJ89WP9kEwMBRbOljsTUiSCA2BlIFPBfaUgNGxfvGfxdMowS7QD1/ibmrUqN
 PTwg==
X-Gm-Message-State: AOJu0YyUSQLDYxAgNisKVCualjQ5M3qpGfbZqOPlKqkHikDkPGVEcX6T
 6RdPC8f5lEY3/cn/FJUSYVvBEg==
X-Google-Smtp-Source: AGHT+IFpjvyQUUCRBkdDh5nJwuhEhTd0rb4+c3As4mtWp5MPb97dXj/O7IfeEAEjzA3aYXTJpB6kTA==
X-Received: by 2002:a05:6a21:329c:b0:15c:b7b9:fc21 with SMTP id
 yt28-20020a056a21329c00b0015cb7b9fc21mr19831702pzb.14.1696982387504; 
 Tue, 10 Oct 2023 16:59:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au.
 [49.180.20.59]) by smtp.gmail.com with ESMTPSA id
 y17-20020a056a001c9100b0068fcc7f6b00sm2559718pfw.74.2023.10.10.16.59.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 10 Oct 2023 16:59:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1qqMdc-00CAvp-1A;
 Wed, 11 Oct 2023 10:59:44 +1100
Date: Wed, 11 Oct 2023 10:59:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZSXlcM2sUeFkHOnb@dread.disaster.area>
References: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
 <20231007012817.3052558-4-sarthakkukreti@chromium.org>
 <ZSM9UDMFNs0050pr@dread.disaster.area>
 <CAG9=OMNPK2s4vsun4B=xQ9nt3qR_fevNP1zSkYq9YG5QPPTsfQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAG9=OMNPK2s4vsun4B=xQ9nt3qR_fevNP1zSkYq9YG5QPPTsfQ@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v8 3/5] loop: Add support for provision
 requests
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBPY3QgMTAsIDIwMjMgYXQgMDM6NDM6MTBQTSAtMDcwMCwgU2FydGhhayBLdWtyZXRp
IHdyb3RlOgo+IE9uIFN1biwgT2N0IDgsIDIwMjMgYXQgNDozN+KAr1BNIERhdmUgQ2hpbm5lciA8
ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3JvdGU6Cj4gPgo+ID4gT24gRnJpLCBPY3QgMDYsIDIwMjMg
YXQgMDY6Mjg6MTVQTSAtMDcwMCwgU2FydGhhayBLdWtyZXRpIHdyb3RlOgo+ID4gPiBBZGQgc3Vw
cG9ydCBmb3IgcHJvdmlzaW9uIHJlcXVlc3RzIHRvIGxvb3BiYWNrIGRldmljZXMuCj4gPiA+IExv
b3AgZGV2aWNlcyB3aWxsIGNvbmZpZ3VyZSBwcm92aXNpb24gc3VwcG9ydCBiYXNlZCBvbgo+ID4g
PiB3aGV0aGVyIHRoZSB1bmRlcmx5aW5nIGJsb2NrIGRldmljZS9maWxlIGNhbiBzdXBwb3J0Cj4g
PiA+IHRoZSBwcm92aXNpb24gcmVxdWVzdCBhbmQgdXBvbiByZWNlaXZpbmcgYSBwcm92aXNpb24g
YmlvLAo+ID4gPiB3aWxsIG1hcCBpdCB0byB0aGUgYmFja2luZyBkZXZpY2Uvc3RvcmFnZS4gRm9y
IGxvb3AgZGV2aWNlcwo+ID4gPiBvdmVyIGZpbGVzLCBhIFJFUV9PUF9QUk9WSVNJT04gcmVxdWVz
dCB3aWxsIHRyYW5zbGF0ZSB0bwo+ID4gPiBhbiBmYWxsb2NhdGUgbW9kZSAwIGNhbGwgb24gdGhl
IGJhY2tpbmcgZmlsZS4KPiA+ID4KPiA+ID4gU2lnbmVkLW9mZi1ieTogU2FydGhhayBLdWtyZXRp
IDxzYXJ0aGFra3VrcmV0aUBjaHJvbWl1bS5vcmc+Cj4gPiA+IFNpZ25lZC1vZmYtYnk6IE1pa2Ug
U25pdHplciA8c25pdHplckBrZXJuZWwub3JnPgo+ID4KPiA+Cj4gPiBIbW1tbS4KPiA+Cj4gPiBU
aGlzIGRvZXNuJ3QgYWN0dWFsbHkgaW1wbGVtZW50IHRoZSByZXF1aXJlZCBzZW1hbnRpY3Mgb2YK
PiA+IFJFUV9QUk9WSVNJT04uIFllcywgaXQgcGFzc2VzIHRoZSBjb21tYW5kIHRvIHRoZSBmaWxl
c3lzdGVtCj4gPiBmYWxsb2NhdGUoKSBpbXBsZW1lbnRhdGlvbiwgYnV0IGZhbGxvY2F0ZSgpIGF0
IHRoZSBmaWxlc3lzdGVtIGxldmVsCj4gPiBkb2VzIG5vdCBoYXZlIHRoZSBzYW1lIHNlbWFudGlj
cyBhcyBSRVFfUFJPVklTSU9OLgo+ID4KPiA+IGkuZS4gYXQgdGhlIGZpbGVzeXN0ZW0gbGV2ZWws
IGZhbGxvY2F0ZSgpIG9ubHkgZ3VhcmFudGVlcyB0aGUgbmV4dAo+ID4gd3JpdGUgdG8gdGhlIHBy
b3Zpc2lvbmVkIHJhbmdlIHdpbGwgc3VjY2VlZCB3aXRob3V0IEVOT1NQQywgaXQgZG9lcwo+ID4g
bm90IGd1YXJhbnRlZSAqZXZlcnkqIHdyaXRlIHRvIHRoZSByYW5nZSB3aWxsIHN1Y2NlZWQgd2l0
aG91dAo+ID4gRU5PU1BDLiBJZiBzb21lb25lIGNsb25lcyB0aGUgbG9vcCBmaWxlIHdoaWxlIGl0
IGlzIGluIHVzZSAoaS5lLgo+ID4gc25hcHNob3RzIGl0IHZpYSBjcCAtLXJlZmxpbmspIHRoZW4g
YWxsIGd1YXJhbnRlZXMgdGhhdCB0aGUgbmV4dAo+ID4gd3JpdGUgdG8gYSBwcm92aXNpb25lZCBM
QkEgcmFuZ2Ugd2lsbCBzdWNjZWVkIHdpdGhvdXQgRU5PU1BDIGFyZQo+ID4gdm9pZGVkLgo+ID4K
PiA+IFNvIHdoaWxlIHRoaXMgd2lsbCB3b3JrIGZvciBiYXNpYyB0ZXN0aW5nIHRoYXQgdGhlIGZp
bGVzeXN0ZW0gaXMKPiA+IGlzc3VpbmcgUkVRX1BST1ZJU0lPTiBiYXNlZCBJTyBjb3JyZWN0bHks
IGl0IGNhbid0IGFjdHVhbGx5IGJlIHVzZWQKPiA+IGZvciBob3N0aW5nIHByb2R1Y3Rpb24gZmls
ZXN5c3RlbXMgdGhhdCBuZWVkIGZ1bGwgUkVRX1BST1ZJU0lPTgo+ID4gZ3VhcmFudGVlcyB3aGVu
IHRoZSBsb29wIGRldmljZSBiYWNraW5nIGZpbGUgaXMgaW5kZXBlbmRlbnRseQo+ID4gc2hhcHNo
b3R0ZWQgdmlhIEZJQ0xPTkUuLi4uCj4gPgo+ID4gQXQgbWluaW11aW0sIHRoaXMgc2V0IG9mIGlt
cGxlbWVudGF0aW9uIGNvbnN0cmFpbnRzIG5lZWRzIHRvYmUKPiA+IGRvY3VtZW50ZWQgc29tZXdo
ZXJlLi4uCj4gPgo+IEZhaXIgcG9pbnQuIEkgd2FudGVkIHRvIGhhdmUgYSBzZXBhcmF0ZSBmYWxs
b2NhdGUoKSBtb2RlCj4gKEZBTExPQ19GTF9QUk9WSVNJT04pIGluIHRoZSBlYXJsaWVyIHNlcmll
cyBvZiB0aGUgcGF0Y2hzZXQgc28gdGhhdCB3ZQo+IGNhbiBkaXN0aW5ndWlzaCBiZXR3ZWVuIGEg
cHJvdmlzaW9uIHJlcXVlc3QgYW5kIGEgcmVndWxhciBmYWxsb2NhdGUoKQo+IGNhbGw7IEkgZHJv
cHBlZCBpdCBmcm9tIHRoZSBzZXJpZXMgYWZ0ZXIgZmVlZGJhY2sgdGhhdCB0aGUgZGVmYXVsdAo+
IGNhc2Ugc2hvdWxkIHN1ZmZpY2UuIEJ1dCB0aGlzIG1pZ2h0IGJlIG9uZSBvZiB0aGUgY2FzZXMg
d2hlcmUgd2UgbmVlZAo+IGFuIGV4cGxpY2l0IGludGVudCB0aGF0IHdlIHdhbnQgdG8gcHJvdmlz
aW9uIHNwYWNlLgoKSVNUUiB0aGF0IEkgY29tbWVudGVkIHRoYXQgZmlsZXN5c3RlbXMgbGlrZSBY
RlMgY2FuJ3QgaW1wbGVtZW50ClJFUV9QUk9WSVNJT04gc2VtYW50aWNzIGZvciBleHRlbnRzIHdp
dGhvdXQgb24tZGlzayBmb3JtYXQKY2hhbmdlcy4gSGVuY2UgdGhhdCBuZWVkcyB0byBoYXBwZW4g
YmVmb3JlIHdlIGV4cG9zZSBhIG5ldyBBUEkgdG8KdXNlcnNwYWNlLi4uLgoKPiBHaXZlbiBhIHNl
cGFyYXRlIEZBTExPQ19GTF9QUk9WSVNJT04gbW9kZSBpbiB0aGUgc2NlbmFyaW8geW91Cj4gbWVu
dGlvbmVkLCB0aGUgZmlsZXN5c3RlbSBjb3VsZCBjb3B5IHByZXZpb3VzbHkgJ3Byb3Zpc2lvbmVk
JyBibG9ja3MKPiB0byBuZXcgYmxvY2tzICh3aGljaCBpbXBsaWNpdGx5IHByb3Zpc2lvbnMgdGhl
bSkgb3IgcmVzZXJ2ZSBibG9ja3MgZm9yCj4gdXNlIChhbmQgcGFzc2luZyB0aHJvdWdoIFJFUV9P
UF9QUk9WSVNJT04gYmVsb3cpLiBUaGF0IGFsc28gbWVhbnMgdGhhdAo+IHRoZSBmaWxlc3lzdGVt
IHNob3VsZCB0cmFjayAncHJvdmlzaW9uZWQnIGJsb2NrcyBhbmQgdGFrZSBhcHByb3ByaWF0ZQo+
IGFjdGlvbnMgdG8gZW5zdXJlIHRoZSBwcm92aXNpb25pbmcgZ3VhcmFudGVlcy4KClllcywgdHJh
Y2tpbmcgcHJvdmlzaW9uZWQgcmFuZ2VzIHBlcnNpc3RlbnRseSBhbmQgdGhlIHJlc2VydmF0aW9u
cwp0aGV5IHJlcXVpcmUgbmVlZHMgb24tZGlzayBmaWxlc3l0ZW0gZm9ybWF0IGNoYW5nZXMgY29t
cGFyZWQgdG8ganVzdApwcmVhbGxvY2F0aW5nIHNwYWNlLiAgTm9uZSBvZiB0aGlzIGZ1bmN0aW9u
YWxpdHkgY3VycmVudGx5IGV4aXN0cyBpbgphbnkgZmlsZXN5c3RlbSB0aGF0IHN1cHBvcnRzIHNo
YXJlZCBleHRlbnRzLCBhbmQgaXQncyBhIGZhaXJseQpzaWduaWZpY2FudCBjaHVuayBvZiBkZXZl
bG9wbWVudCB3b3JrIHRvIHN1cHBvcnQgaXQuCgpOb2JvZHkgaGFzIHBsYW5uZWQgdG8gZG8gdGhp
cyBzb3J0IG9mIGNvbXBsZXggc3VyZ2VyeSB0byBYRlMgYXQKdGhpcyBwb2ludCBpbiB0aW1lLiBJ
IGRvdWJ0IHRoYXQgYW55b25lIG9uIHRoZSBidHJmcyBzaWRlIG9mCnRoaW5ncyBpcyByZWFsbHkg
ZXZlbiBmb2xsb3dpbmcgdGhpcyBkaXNjdXNzaW9uIGJlY2F1c2UgdGhpcyBpcwpsYXJnZWx5IGZv
ciBibG9jayBkZXZpY2UgdGhpbnAgYW5kIHNuYXBzaG90IHN1cHBvcnQKYW5kIGJ0cmZzIGp1c3Qg
ZG9lc24ndCBjYXJlIGFib3V0IHRoYXQuCgo+IEZvciBmaWxlc3lzdGVtcyB3aXRob3V0IGNvcHkt
b24td3JpdGUgc2VtYW50aWNzIChlZy4gZXh0NCksCj4gUkVRX09QX1BST1ZJU0lPTiBzaG91bGQg
c3RpbGwgYmUgZXF1aXZhbGVudCB0byBtb2RlID09IDAuCgpXZWxsLCB5ZXMuIFRoaXMgaXMgdGhl
IHNhbWUgc2l0dWF0aW9uIGFzICJmb3Igbm9uLXNwYXJzZSBibG9jawpkZXZpY2VzLCBSRVFfUFJP
VklTSU9OIGNhbiBqdXN0IGJlIGlnbm9yZWQuIiBUaGlzIGlzIG5vdCBhbgppbnRlcmVzdGluZyB1
c2UgY2FzZSwgbm9yIGEgdXNlIGNhc2UgdGhhdCB0aGUgZnVuY3Rpb25hbGl0eSBvciBBUElzCnNo
b3VsZCBiZSBkZXNpZ25lZCBhcm91bmQuCgotRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBm
cm9tb3JiaXQuY29tCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNv
bQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

