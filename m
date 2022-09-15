Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5709C54EE9
	for <dm-devel@archiver.kernel.org>; Fri, 16 Sep 2022 08:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663317903;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cUqs1mz25c8LkdAKXZAQTmoI4k2JgXPQ/+stMIcWx7U=;
	b=a9wxwILKluM9Qxz2QNSCq5KL1vrwPhHKvbDypZe4HrC1dYjtFNFCJOU7FnK/m8Fz1jMCLI
	+bzzpKdpeslD6H+8j43eNVSc1n9nmLP7xYE6z3HmyNY5fZALhaEEppd5Dq4ryE0ApgGEND
	DYxQOzZFg/J5Pa50uLKjs0bHe0aSolY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-ycVt505mNHKLv3_FU0GUlg-1; Fri, 16 Sep 2022 04:45:00 -0400
X-MC-Unique: ycVt505mNHKLv3_FU0GUlg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1C9C382F1AE;
	Fri, 16 Sep 2022 08:44:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 37D35140EBF5;
	Fri, 16 Sep 2022 08:44:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EAAA61946587;
	Fri, 16 Sep 2022 08:44:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AE77E1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Sep 2022 16:48:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5D9D12166B29; Thu, 15 Sep 2022 16:48:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 59F282166B26
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 16:48:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F577294EDFB
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 16:48:42 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-642-AzdVgFuLPimpViSasUF_qQ-2; Thu, 15 Sep 2022 12:48:39 -0400
X-MC-Unique: AzdVgFuLPimpViSasUF_qQ-2
Received: by mail-pf1-f176.google.com with SMTP id l65so18621624pfl.8
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 09:48:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date;
 bh=zlA6ptTTn1LB8f3ds6R6bK3ndLgpFyQYa5/cgjmBz0k=;
 b=GsEXR3eKKPwWDMckOnDHIhKC8Z6U306Rb2qCk5aUccUnqI2sQzUa2dZY8/6MJHfjDV
 1S+mYEOpotafwSlB3wnzeC294cBK05nRrW7pUd+F7dnMWCBOdro8PwxvaaiKrT/gLX3e
 6QVBVrjZN0BAdLCyg4aw59HIcWObbYqolDwbX2Ey1k+5578+54o019wLxlte8iQdMlPO
 +CVB+0Of+NOIl/SqkDdfELjbfCASFMfc9Q3GACGFQZIIprNpjGaSfpP1UQ69cNZMDPXs
 XwugLKD31z3JQA0rWh+RicQlzT4Y/yUdIabNKo5p2MhXDf3WpBXNufZ9AHrxGyUsxj4S
 +csw==
X-Gm-Message-State: ACrzQf29vJFI/F9mgY7c7z9CRqs/IfyZKhbsPPBakMteGUG0aEE2h8tf
 BaN1LA/QSXzScPBrK6HIZyGAL/egZdq4unjR
X-Google-Smtp-Source: AMsMyM4FdBRmEUaoFqZ1ZX6Vh6XtevMCEGOiKjv87UB8WmxxEo9+INCb9SpLcAAa5zOhruJLuTG+QQ==
X-Received: by 2002:aa7:8892:0:b0:540:edcb:4773 with SMTP id
 z18-20020aa78892000000b00540edcb4773mr674454pfe.19.1663260517947; 
 Thu, 15 Sep 2022 09:48:37 -0700 (PDT)
Received: from sarthakkukreti-glaptop.hsd1.ca.comcast.net
 ([2601:647:4200:b5b0:3af2:34b2:a98a:a652])
 by smtp.gmail.com with ESMTPSA id
 o4-20020a170902bcc400b00177ee563b6dsm13174970pls.33.2022.09.15.09.48.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 15 Sep 2022 09:48:37 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
X-Google-Original-From: Sarthak Kukreti <sarthakkukreti@google.com>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org
Date: Thu, 15 Sep 2022 09:48:18 -0700
Message-Id: <20220915164826.1396245-1-sarthakkukreti@google.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Fri, 16 Sep 2022 08:44:55 +0000
Subject: [dm-devel] [PATCH RFC 0/8] Introduce provisioning primitives for
 thinly provisioned storage
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
Cc: Jens Axboe <axboe@kernel.dk>, Gwendal Grignou <gwendal@google.com>,
 Theodore Ts'o <tytso@mit.edu>, Sarthak Kukreti <sarthakkukreti@chromium.org>,
 "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 Evan Green <evgreen@google.com>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Daniil Lunev <dlunev@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RnJvbTogU2FydGhhayBLdWtyZXRpIDxzYXJ0aGFra3VrcmV0aUBjaHJvbWl1bS5vcmc+CgpIaSwK
ClRoaXMgcGF0Y2ggc2VyaWVzIGlzIGFuIFJGQyBvZiBhIG1lY2hhbmlzbSB0byBwYXNzIHRocm91
Z2ggcHJvdmlzaW9uIHJlcXVlc3RzIG9uIHN0YWNrZWQgdGhpbmx5IHByb3Zpc2lvbmVkIHN0b3Jh
Z2UgZGV2aWNlcy9maWxlc3lzdGVtcy4KClRoZSBsaW51eCBrZXJuZWwgcHJvdmlkZXMgc2V2ZXJh
bCBtZWNoYW5pc21zIHRvIHNldCB1cCB0aGlubHkgcHJvdmlzaW9uZWQgYmxvY2sgc3RvcmFnZSBh
YnN0cmFjdGlvbnMgKGVnLiBkbS10aGluLCBsb29wIGRldmljZXMgb3ZlciBzcGFyc2UgZmlsZXMp
LCBlaXRoZXIgZGlyZWN0bHkgYXMgYmxvY2sgZGV2aWNlcyBvciBiYWNraW5nIHN0b3JhZ2UgZm9y
IGZpbGVzeXN0ZW1zLiBDdXJyZW50bHksIHNob3J0IG9mIHdyaXRpbmcgZGF0YSB0byBlaXRoZXIg
dGhlIGRldmljZSBvciBmaWxlc3lzdGVtLCB0aGVyZSBpcyBubyB3YXkgZm9yIHVzZXJzIHRvIHBy
ZS1hbGxvY2F0ZSBzcGFjZSBmb3IgdXNlIGluIHN1Y2ggc3RvcmFnZSBzZXR1cHMuIENvbnNpZGVy
IHRoZSBmb2xsb3dpbmcgdXNlLWNhc2VzOgoKMSkgU3VzcGVuZC10by1kaXNrIGFuZCByZXN1bWUg
ZnJvbSBhIGRtLXRoaW4gZGV2aWNlOiBJbiBvcmRlciB0byBlbnN1cmUgdGhhdCB0aGUgdW5kZXJs
eWluZyB0aGlucG9vbCBtZXRhZGF0YSBpcyBub3QgbW9kaWZpZWQgZHVyaW5nIHRoZSBzdXNwZW5k
IG1lY2hhbmlzbSwgdGhlIGRtLXRoaW4gZGV2aWNlIG5lZWRzIHRvIGJlIGZ1bGx5IHByb3Zpc2lv
bmVkLgoyKSBJZiBhIGZpbGVzeXN0ZW0gdXNlcyBhIGxvb3AgZGV2aWNlIG92ZXIgYSBzcGFyc2Ug
ZmlsZSwgZmFsbG9jYXRlKCkgb24gdGhlIGZpbGVzeXN0ZW0gd2lsbCBhbGxvY2F0ZSBibG9ja3Mg
Zm9yIGZpbGVzIGJ1dCB0aGUgdW5kZXJseWluZyBzcGFyc2UgZmlsZSB3aWxsIHJlbWFpbiBpbnRh
Y3QuCjMpIEFub3RoZXIgZXhhbXBsZSBpcyB2aXJ0dWFsIG1hY2hpbmUgdXNpbmcgYSBzcGFyc2Ug
ZmlsZS9kbS10aGluIGFzIGEgc3RvcmFnZSBkZXZpY2U7IGJ5IGRlZmF1bHQsIGFsbG9jYXRpb25z
IHdpdGhpbiB0aGUgVk0gYm91bmRhcmllcyB3aWxsIG5vdCBhZmZlY3QgdGhlIGhvc3QuCjQpIFNl
dmVyYWwgc3RvcmFnZSBzdGFuZGFyZHMgc3VwcG9ydCBtZWNoYW5pc21zIGZvciB0aGluIHByb3Zp
c2lvbmluZyBvbiByZWFsIGhhcmR3YXJlIGRldmljZXMuIEZvciBleGFtcGxlOgogIGEuIFRoZSBO
Vk1lIHNwZWMgMS4wYiBzZWN0aW9uIDIuMS4xIGxvb3NlbHkgdGFsa3MgYWJvdXQgdGhpbiBwcm92
aXNpb25pbmc6ICJXaGVuIHRoZSBUSElOUCBiaXQgaW4gdGhlIE5TRkVBVCBmaWVsZCBvZiB0aGUg
SWRlbnRpZnkgTmFtZXNwYWNlIGRhdGEgc3RydWN0dXJlIGlzIHNldCB0byDigJgx4oCZLCB0aGUg
Y29udHJvbGxlciAuLi4gc2hhbGwgdHJhY2sgdGhlIG51bWJlciBvZiBhbGxvY2F0ZWQgYmxvY2tz
IGluIHRoZSBOYW1lc3BhY2UgVXRpbGl6YXRpb24gZmllbGQiCiAgYi4gVGhlIFNDU2kgQmxvY2sg
Q29tbWFuZHMgcmVmZXJlbmNlIC0gNCBzZWN0aW9uIHJlZmVyZW5jZXMgIlRoaW4gcHJvdmlzaW9u
ZWQgbG9naWNhbCB1bml0cyIsCiAgYy4gVUZTIDMuMCBzcGVjIHNlY3Rpb24gMTMuMy4zIHJlZmVy
ZW5jZXMgIlRoaW4gcHJvdmlzaW9uaW5nIi4KCkluIGFsbCBvZiB0aGUgYWJvdmUgc2l0dWF0aW9u
cywgY3VycmVudGx5IHRoZSBvbmx5IHdheSBmb3IgcHJlLWFsbG9jYXRpbmcgc3BhY2UgaXMgdG8g
aXNzdWUgd3JpdGVzIChvciB1c2UgV1JJVEVfWkVST0VTL1dSSVRFX1NBTUUpLiBIb3dldmVyLCB0
aGF0IGRvZXMgbm90IHNjYWxlIHdlbGwgd2l0aCBsYXJnZXIgcHJlLWFsbG9jYXRpb24gc2l6ZXMu
IAoKVGhpcyBwYXRjaHNldCBpbnRyb2R1Y2VzIHByaW1pdGl2ZXMgdG8gc3VwcG9ydCBibG9jay1s
ZXZlbCBwcm92aXNpb25pbmcgKG5vdGU6IHRoZSB0ZXJtICdwcm92aXNpb25pbmcnIGlzIHVzZWQg
dG8gcHJldmVudCBvdmVybG9hZGluZyB0aGUgdGVybSAnYWxsb2NhdGlvbnMvcHJlLWFsbG9jYXRp
b25zJykgcmVxdWVzdHMgYWNyb3NzIGZpbGVzeXN0ZW1zIGFuZCBibG9jayBkZXZpY2VzLiBUaGlz
IGFsbG93cyBmYWxsb2NhdGUoKSBhbmQgZmlsZSBjcmVhdGlvbiByZXF1ZXN0cyB0byByZXNlcnZl
IHNwYWNlIGFjcm9zcyBzdGFja2VkIGxheWVycyBvZiBibG9jayBkZXZpY2VzIGFuZCBmaWxlc3lz
dGVtcy4gQ3VycmVudGx5LCB0aGUgcGF0Y2hzZXQgY292ZXJzIGEgcHJvdG90eXBlIG9uIHRoZSBk
ZXZpY2UtbWFwcGVyIHRhcmdldHMsIGxvb3AgZGV2aWNlIGFuZCBleHQ0LCBidXQgdGhlIHNhbWUg
bWVjaGFuaXNtIGNhbiBiZSBleHRlbmRlZCB0byBvdGhlciBmaWxlc3lzdGVtcy9ibG9jayBkZXZp
Y2VzIGFzIHdlbGwgYXMgZXh0ZW5kZWQgZm9yIHVzZSB3aXRoIGRldmljZXMgaW4gNCBhLWMuCgpQ
YXRjaCAxIGludHJvZHVjZXMgUkVRX09QX1BST1ZJU0lPTiBhcyBhIG5ldyByZXF1ZXN0IHR5cGUu
IFRoZSBwcm92aXNpb24gcmVxdWVzdCBhY3RzIGxpa2UgdGhlIGludmVyc2Ugb2YgYSBkaXNjYXJk
IHJlcXVlc3Q7IGluc3RlYWQgb2Ygbm90aWZ5aW5nIGxvd2VyIGxheWVycyB0aGF0IHRoZSBibG9j
ayByYW5nZSB3aWxsIG5vIGxvbmdlciBiZSB1c2VkLCBwcm92aXNpb24gYWN0cyBhcyBhIHJlcXVl
c3QgdG8gbG93ZXIgbGF5ZXJzIHRvIHByb3Zpc2lvbiBkaXNrIHNwYWNlIGZvciB0aGUgZ2l2ZW4g
YmxvY2sgcmFuZ2UuIFJlYWwgaGFyZHdhcmUgc3RvcmFnZSBkZXZpY2VzIHdpbGwgY3VycmVudGx5
IGRpc2FibGUgdGhlIHByb3Zpc2lvaW5nIGNhcGFiaWxpdHkgYnV0IGZvciB0aGUgc3RhbmRhcmRz
IGxpc3RlZCBpbiA0YS4tYy4sIFJFUV9PUF9QUk9WSVNJT04gY2FuIGJlIG92ZXJsb2FkZWQgZm9y
IHVzZSBhcyB0aGUgcHJvdmlzaW9pbmcgcHJpbWl0aXZlIGZvciBmdXR1cmUgZGV2aWNlcy4KClBh
dGNoIDIgaW1wbGVtZW50cyBSRVFfT1BfUFJPVklTSU9OIGhhbmRsaW5nIGZvciBzb21lIG9mIHRo
ZSBkZXZpY2UtbWFwcGVyIHRhcmdldHMuIFRoaXMgYWRkaXRpb25hbGx5IGFkZHMgc3VwcG9ydCBm
b3IgcHJlLWFsbG9jYXRpbmcgc3BhY2UgZm9yIHRoaW5seSBwcm92aXNpb25lZCBsb2dpY2FsIHZv
bHVtZXMgdmlhIGZhbGxvY2F0ZSgpCgpQYXRjaCAzIGltcGxlbWVudHMgdGhlIGhhbmRsaW5nIGZv
ciB2aXJ0aW8tYmxrLgoKUGF0Y2ggNCBpbnRyb2R1Y2VzIGFuIGZhbGxvY2F0ZSgpIG1vZGUgKEZB
TExPQ19GTF9QUk9WSVNJT04pIHRoYXQgc2VuZHMgYSBwcm92aXNpb24gcmVxdWVzdCB0byB0aGUg
dW5kZXJseWluZyBibG9jayBkZXZpY2UgKGFuZCBiZXlvbmQpLiBUaGlzIGFjdHMgYXMgdGhlIHBy
aW1hcnkgbWVjaGFuaXNtIGZvciBmaWxlLWxldmVsIHByb3Zpc2lvaW5nLgoKUGF0Y2ggNSB3aXJl
cyB1cCB0aGUgbG9vcCBkZXZpY2UgaGFuZGxpbmcgb2YgUkVRX09QX1BST1ZJU0lPTi4KClBhdGNo
ZXMgNi04IGNvdmVyIGEgcHJvdG90eXBlIGltcGxlbWVudGF0aW9uIGZvciBleHQ0LCB3aGljaCBp
bmNsdWRlcyB3aXJpbmcgdXAgdGhlIGZhbGxvY2F0ZSgpIGltcGxlbWVudGF0aW9uLCBpbnRyb2R1
Y2luZyBhIGZpbGVzeXN0ZW0gbGV2ZWwgb3B0aW9uIChjYWxsZWQgJ3Byb3Zpc2lvbicpIHRvIGNv
bnRyb2wgdGhlIGRlZmF1bHQgYWxsb2NhdGlvbiBiZWhhdmlvdXIgYW5kIGZpbmFsbHkgYSBmaWxl
IGxldmVsIG92ZXJyaWRlIHRvIHJldGFpbiBjdXJyZW50IGhhbmRsaW5nLCBldmVuIG9uIGZpbGVz
eXN0ZW1zIG1vdW50ZWQgd2l0aCAncHJvdmlzaW9uJwoKVGVzdGluZzoKLS0tLS0tLS0KLSBBIGJh
Y2twb3J0IG9mIHRoaXMgcGF0Y2ggc2VyaWVzIHdhcyB0ZXN0ZWQgb24gQ2hyb21pdW1PUyB1c2lu
ZyBhIDUuMTAga2VybmVsLgotIEZpbGUgb24gZXh0NCBvbiBhIHRoaW4gbG9naWNhbCB2b2x1bWU6
IGZhbGxvY2F0ZShGQUxMT0NfRkxfUFJPVklTSU9OKSA6IDQuNnMsIGRkIGlmPS9kZXYvemVybyBv
Zj0uLi46IDYgbWlucy4KClRPRE9zOgotLS0tLS0KMSkgVGhlIHN0YWNrZWQgYmxvY2sgZGV2aWNl
cyAoZG0tKiwgbG9vcCBldGMuKSBjdXJyZW50bHkgdW5jb25kaXRpb25hbGx5IHBhc3MgdGhyb3Vn
aCBwcm92aXNpb24gcmVxdWVzdHMuIEFkZCBzdXBwb3J0IGZvciBwcm92aXNpb24sIHNpbWlsYXIg
dG8gaG93IGRpc2NhcmQgaGFuZGxpbmcgaXMgc2V0IHVwICh3aXRoIG9wdGlvbnMgdG8gZGlzYWJs
ZSwgcGFzc2Rvd24gb3IgcGFzc3Rocm91Z2ggcmVxdWVzdHMpLgoyKSBCbGt0ZXN0cyBhbmQgWGZz
dGVzdHMgZm9yIHZhbGlkYXRpbmcgcHJvdmlzaW9uaW5nLgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbAo=

