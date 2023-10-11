Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B76ACD98E0
	for <dm-devel@archiver.kernel.org>; Wed, 11 Oct 2023 00:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696983221;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZwE2OXewQp7aF3KQLU0vWLck/ZFpN3HVqTYdygUDs2E=;
	b=GdfkcahV3xxsbQazBvF71bflPgzmjdVo9qeRZxVpJgetOWuv8GDCMh3GlTqE5jnlV9V8tJ
	5WaISNKWYSN+nC3Di8vfgWYVTErwS5OluTfjFE2kfg1fkSLIJgcLtNlS0z9MldZFFM1ZCN
	f0I+Z/ZeIpoYD6O3HW3fNvohMhsh9Mw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-FWI0EquXM9Kh1a1469pX4g-1; Tue, 10 Oct 2023 20:13:28 -0400
X-MC-Unique: FWI0EquXM9Kh1a1469pX4g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01D8B887E48;
	Wed, 11 Oct 2023 00:13:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9984BC0F788;
	Wed, 11 Oct 2023 00:13:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 56F9219465B8;
	Wed, 11 Oct 2023 00:13:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 07F401946597
 for <dm-devel@listman.corp.redhat.com>; Wed, 11 Oct 2023 00:13:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BA4AE10F1BEA; Wed, 11 Oct 2023 00:13:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B28CC1005E2A
 for <dm-devel@redhat.com>; Wed, 11 Oct 2023 00:13:23 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91EE28F5DA1
 for <dm-devel@redhat.com>; Wed, 11 Oct 2023 00:13:23 +0000 (UTC)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-lhzlz1vAPP-QdMx4_bo5cg-1; Tue, 10 Oct 2023 20:13:22 -0400
X-MC-Unique: lhzlz1vAPP-QdMx4_bo5cg-1
Received: by mail-pf1-f171.google.com with SMTP id
 d2e1a72fcca58-69101022969so5559731b3a.3
 for <dm-devel@redhat.com>; Tue, 10 Oct 2023 17:13:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696983201; x=1697588001;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=bXYSMoj+4mDjgRP2mTt2Aa1GtDE1UTVBqHkHte3xwzo=;
 b=V5IgvdN4cA6HCXtqR8T/ZsOudUdSSuAJY8gcrCTeU8b7rOC8nKiDyMcq3uJKYnGvIZ
 w6ps4eqXTJUsw0v9dtrPjkLebZ0YWC4Aji77VBgf+2tOduNihfSw83VY0Q3fH0RHQC28
 Dyzl4YcvxjppC+G1A/QSpnq5rSRvVoxHUqft6MzsFKP7uUH64BnbsFKHTehrwpkttAhT
 eKgNo6QPcrfZfDsOuYmWvfnRkM+F4IRMg+Ov4USnZX6Fcy7SCo+seYfuztY1bQlk9UgQ
 /Z9CLwzhaOi1v/SopHvZ9ari1VISrXEmNwM9v8LHQ4wCZRHCDDPaTWNknVk8g9Mr+Jmd
 GryQ==
X-Gm-Message-State: AOJu0Yww5Xr2MEJnxoIY4xST034dwIMkJ989yQrOgYG3zyw0CNYSwUeH
 XlVTRJED79S7Fe7UeEgbDLK90VAWcRLmhWyApeQ=
X-Google-Smtp-Source: AGHT+IEhIWc+rwqEXOm79XKP02Vs6tvtegdLCI6fFlAq/EvagoUmMI4WFKDIe3c26N4RyxgWNDKTzA==
X-Received: by 2002:a05:6a20:9385:b0:161:3120:e840 with SMTP id
 x5-20020a056a20938500b001613120e840mr24937687pzh.2.1696983200909; 
 Tue, 10 Oct 2023 17:13:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au.
 [49.180.20.59]) by smtp.gmail.com with ESMTPSA id
 p10-20020a170902eaca00b001b8a85489a3sm12443132pld.262.2023.10.10.17.13.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 10 Oct 2023 17:13:20 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1qqMqk-00CB5y-0c;
 Wed, 11 Oct 2023 11:13:18 +1100
Date: Wed, 11 Oct 2023 11:13:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZSXono3GkXhgrZ1T@dread.disaster.area>
References: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
 <ZSNANlreccIVXuo+@dread.disaster.area>
 <CAG9=OMMM3S373Y6UEeXxnOyvMvA9wmAVd4Jrdjt3gzkz9d2yUg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAG9=OMMM3S373Y6UEeXxnOyvMvA9wmAVd4Jrdjt3gzkz9d2yUg@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v8 0/5] Introduce provisioning primitives
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBPY3QgMTAsIDIwMjMgYXQgMDM6NDI6NTNQTSAtMDcwMCwgU2FydGhhayBLdWtyZXRp
IHdyb3RlOgo+IE9uIFN1biwgT2N0IDgsIDIwMjMgYXQgNDo1MOKAr1BNIERhdmUgQ2hpbm5lciA8
ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3JvdGU6Cj4gPgo+ID4gT24gRnJpLCBPY3QgMDYsIDIwMjMg
YXQgMDY6Mjg6MTJQTSAtMDcwMCwgU2FydGhhayBLdWtyZXRpIHdyb3RlOgo+ID4gPiBIaSwKPiA+
ID4KPiA+ID4gVGhpcyBwYXRjaCBzZXJpZXMgaXMgdmVyc2lvbiA4IG9mIHRoZSBwYXRjaCBzZXJp
ZXMgdG8gaW50cm9kdWNlCj4gPiA+IGJsb2NrLWxldmVsIHByb3Zpc2lvbmluZyBtZWNoYW5pc20g
KG9yaWdpbmFsIFsxXSksIHdoaWNoIGlzIHVzZWZ1bCBmb3IgcHJvdmlzaW9uaW5nCj4gPiA+IHNw
YWNlIGFjcm9zcyB0aGlubHkgcHJvdmlzaW9uZWQgc3RvcmFnZSBhcmNoaXRlY3R1cmVzIChsb29w
IGRldmljZXMKPiA+ID4gYmFja2VkIGJ5IHNwYXJzZSBmaWxlcywgZG0tdGhpbiBkZXZpY2VzLCB2
aXJ0aW8tYmxrKS4gVGhpcyBzZXJpZXMgaGFzCj4gPiA+IG1pbmltYWwgY2hhbmdlcyBvdmVyIHY3
WzJdLgo+ID4gPgo+ID4gPiBUaGlzIHBhdGNoIHNlcmllcyBpcyByZWJhc2VkIGZyb20gdGhlIGxp
bnV4LWRtL2RtLTYuNS1wcm92aXNpb24tc3VwcG9ydCBbMV0gb24gdG8KPiA+ID4gKGNhYzQwNWEz
YmZhMiBNZXJnZSB0YWcgJ2Zvci02LjYtcmMzLXRhZycpLiBJbiBhZGRpdGlvbiwgdGhlcmUncyBh
bgo+ID4gPiBhZGRpdGlvbmFsIHBhdGNoIHRvIGFsbG93IHBhc3NpbmcgdGhyb3VnaCBhbiB1bnNo
YXJlIGludGVudCB2aWEgUkVRX09QX1BST1ZJU0lPTgo+ID4gPiAoc3VnZ2VzdGVkIGJ5IERhcnJp
Y2sgaW4gWzRdKS4KPiA+Cj4gPiBUaGUgWEZTIHBhdGNoZXMgSSBqdXN0IHBvc3RlZCB3ZXJlIHNt
b2tlIHRlc3RlZCBhIHdoaWxlIGJhY2sgYWdhaW5zdAo+ID4gbG9vcCBkZXZpY2VzIGFuZCB0aGVu
IGZvcndhcmQgcG9ydGVkIHRvIHRoaXMgcGF0Y2hzZXQuIEdvb2QgZm9yCj4gPiB0ZXN0aW5nIHRo
YXQgdXNlcnNwYWNlIGRyaXZlbiBmaWxlIHByZWFsbG9jYXRpb24gZ2V0cyBwcm9wYWdhdGVkIGJ5
Cj4gPiB0aGUgZmlsZXN5c3RlbSBkb3duIHRvIHRoZSBiYWNraW5nIGRldmljZSBjb3JyZWN0bHkg
YW5kIHRoYXQKPiA+IHN1YnNlcXVlbnQgSU8gdG8gdGhlIGZpbGUgdGhlbiBkb2VzIHRoZSByaWdo
dCB0aGluZyAoZS5nLiBmaW8KPiA+IHRlc3RpbmcgdXNpbmcgZmFsbG9jYXRlKCkgdG8gc2V0IHVw
IHRoZSBmaWxlcyBiZWluZyB3cml0dGVuIHRvKS4uLi4KPiA+Cj4gCj4gVGhhbmtzISBJJ3ZlIGJl
ZW4gdGVzdGluZyB3aXRoIGEgV0lQIHBhdGNoIGZvciBleHQ0LCBJJ2xsIGdpdmUgeW91cgo+IHBh
dGNoZXMgYSB0cnkuIE9uY2Ugd2UgYXJlIGNsb3NlciB0byBzdWJtaXR0aW5nIHRoZSBmaWxlc3lz
dGVtCj4gc3VwcG9ydCwgd2UgY2FuIGZvcm1hbGl6ZSB0aGUgdGVzdCBpbnRvIGFuIHhmc3Rlc3Qg
KHNwYXJzZSBmaWxlICsgbG9vcAo+ICsgZmlsZXN5c3RlbSwgZmFsbG9jYXRlKCkgZmlsZSwgY2hl
Y2sgdGhlIHNpemUgb2YgdGhlIHVuZGVybHlpbmcKPiBzcGFyc2UgZmlsZSkuCgpUaGF0J3Mgbm90
IHJlYWxseSBhIHZhbGlkIHRlc3QgLSB0aGVyZSBhcmUgc28gbWFueSBvcHRpb25hbCBmaWxlc3lz
dGVtCmJlaGF2aW91cnMgdGhhdCBjYW4gY2hhbmdlIHRoZSBsYXlvdXQgb2YgdGhlIGJhY2tpbmcg
ZmlsZSBmb3IgdGhlCnNhbWUgdXBwZXIgZmlsZXN5c3RlbSBvcGVyYXRpb25zLgoKV2hhdCB3ZSBh
Y3R1YWxseSBuZWVkIHRvIHRlc3QgaXMgdGhlIEVOT1NQQyBndWFyYW50ZWVzLCBub3QgdGhhdApm
YWxsb2NhdGUgaGFzIGJlZW4gY2FsbGVkIGJ5IHRoZSBsb29wIGRldmljZS4gaS5lLiB0aGF0IEVO
T1NQQyBpcwpwcm9wYWdhdGVkIGZyb20gdGhlIHVuZGVybHlpbmcgZmlsZXN5c3RlbSB0aG91Z2gg
dGhlIGxvb3AgZGV2aWNlIHRvCnRoZSBhcHBsaWNhdGlvbiBydW5uaW5nIG9uIHRoZSB1cHBlciBm
aWxlc3lzdGVtIGFwcHJvcHJpYXRlbHkuICBlLmcuCndoZW4gdGhlIGxvd2VyIGZpbGVzeXN0ZW0g
aXMgYXQgRU5PU1BDLCB0aGUgd3JpdGVzIGludG8gcHJvdmlzaW9uZWQKc3BhY2UgaW4gdGhlIGxv
b3AgZGV2aWNlIGJhY2tpbmcgZmlsZSBjb250aW51ZSB0byBzdWNjZWVkIHdpdGhvdXQKRU5PU1BD
IGJlaW5nIHJlcG9ydGVkIHRvIHRoZSB1cHBlciBmaWxlc3lzdGVtLgoKaS5lLiB0aGlzIG5lZWRz
IHRvIGJlIHRlc3RlZCBmcm9tIHRoZSBwZXJzcGVjdGl2ZSBvZiB0aGUgQVBJCnByZXNlbnRlZCB0
byB0aGUgdXBwZXIgZmlsZXN5c3RlbSwgbm90IGJ5IHJ1bm5pbmcgYW4gdXBwZXIgZnMKb3BlcmF0
aW9uIGFuZCB0aGVuIHRyeWluZyB0byBpbmZlciBjb3JyZWN0IGJlaGF2aW91ciBieSBwZWVyaW5n
IGF0CnRoZSBzdGF0ZSBvZiB0aGUgbG93ZXIgZmlsZXN5c3RlbS4uLgoKQ2hlZXJzLAoKRGF2ZS4K
LS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWls
bWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

