Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27B48C4167B
	for <dm-devel@archiver.kernel.org>; Mon,  2 Jan 2023 07:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672645391;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZU4iohztJmssPnzIUbOSwRaj0mX2VYaqfGzy8kLxXas=;
	b=JtzCz3PBtmf/mfG3y1Xc4iBhRBJXnG5jILhIpCEF1eHjusBBDQpFXCWpkkKhKsvHdtHf71
	rzOG/z5XyX+69Vu5Zd3Zssg4ORVyDAzy544mQDkr3vuF9k7Iw0ufiQYmvymHwgScandxlj
	wdl8EHRI2i2WRbau6tui/EGC0u1nr8k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-e5k1mQXCML-1ItYgjmpoAw-1; Mon, 02 Jan 2023 02:43:07 -0500
X-MC-Unique: e5k1mQXCML-1ItYgjmpoAw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4640485C6EF;
	Mon,  2 Jan 2023 07:43:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 346A22166B2B;
	Mon,  2 Jan 2023 07:43:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BBC7E194707E;
	Mon,  2 Jan 2023 07:43:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4F5521946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Dec 2022 08:13:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 224EC492B07; Thu, 29 Dec 2022 08:13:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A49E492B06
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:13:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB45787B2A1
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:13:01 +0000 (UTC)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-300---C1IhqbNGqt1VrDFfGTrw-1; Thu, 29 Dec 2022 03:13:00 -0500
X-MC-Unique: --C1IhqbNGqt1VrDFfGTrw-1
Received: by mail-pl1-f176.google.com with SMTP id jl4so12014298plb.8
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 00:12:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=THv6prYzDq2eXsCiqs3MdATdHNqWI4kkKeIbH/Zad64=;
 b=cpHajtDPq5pZSbUXZC50hWA/qvyn849Tlwm6Vv1jRNbs/eGBFfbjgxuR96R6CGy2b+
 qTVEIw5olsFYdsXRE6SoOcxtu8RLtzksH5xCF99OMeQgwX4oFoRlLtCJvkeGq4dfjeTH
 qIEVZOG+DAgtznEPN+oVDcqcegSeMde+/ckUu0zq4XlhmdqeouD3ppP7PWilNGwESRQL
 nx+BeXxHfP2nrwit/IXYQdpcVgsGRAH8z5s3FaJNHBwpRdDHBuWwUjCfgnaziI6HPOgA
 QFuEWRbFk1gjt258Y8Vma+0OO84hN4JKLpt0rb/vceI52K5CxzpzpoTCyvHXVFuB78Wi
 P/Ng==
X-Gm-Message-State: AFqh2koM9lpVjEqlXZZ9tBvKkhf1GmQgABI9g/zddm/cPSd61auhHQMm
 fjxGi8h0u6K9evvsIvG8w4BFQ+owmO4a9G32
X-Google-Smtp-Source: AMrXdXu9lcGIP5E+xv/lfVaOI7oGNaTa8ZYVW9/FVtdg5eoc6mZA7pS4ycv7ew5XN0iSQz9w8aYiWA==
X-Received: by 2002:a05:6a21:3a46:b0:9f:3197:bfa1 with SMTP id
 zu6-20020a056a213a4600b0009f3197bfa1mr40455755pzb.7.1672301579046; 
 Thu, 29 Dec 2022 00:12:59 -0800 (PST)
Received: from sarthakkukreti-glaptop.hsd1.ca.comcast.net
 ([2601:647:4200:b5b0:75ff:1277:3d7b:d67a])
 by smtp.gmail.com with ESMTPSA id
 12-20020a170902e9cc00b00192820d00d0sm6496325plk.120.2022.12.29.00.12.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Dec 2022 00:12:58 -0800 (PST)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: sarthakkukreti@google.com, dm-devel@redhat.com,
 linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Thu, 29 Dec 2022 00:12:45 -0800
Message-Id: <20221229081252.452240-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Mon, 02 Jan 2023 07:42:59 +0000
Subject: [dm-devel] [PATCH v2 0/8] Introduce provisioning primitives for
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
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGksCgpUaGlzIHBhdGNoIHNlcmllcyBhZGRzIGEgbWVjaGFuaXNtIHRvIHBhc3MgdGhyb3VnaCBw
cm92aXNpb24gcmVxdWVzdHMgb24Kc3RhY2tlZCB0aGlubHkgcHJvdmlzaW9uZWQgc3RvcmFnZSBk
ZXZpY2VzL2ZpbGVzeXN0ZW1zLgoKVGhlIGxpbnV4IGtlcm5lbCBwcm92aWRlcyBzZXZlcmFsIG1l
Y2hhbmlzbXMgdG8gc2V0IHVwIHRoaW5seSBwcm92aXNpb25lZApibG9jayBzdG9yYWdlIGFic3Ry
YWN0aW9ucyAoZWcuIGRtLXRoaW4sIGxvb3AgZGV2aWNlcyBvdmVyIHNwYXJzZSBmaWxlcyksCmVp
dGhlciBkaXJlY3RseSBhcyBibG9jayBkZXZpY2VzIG9yIGJhY2tpbmcgc3RvcmFnZSBmb3IgZmls
ZXN5c3RlbXMuIEN1cnJlbnRseSwKc2hvcnQgb2Ygd3JpdGluZyBkYXRhIHRvIGVpdGhlciB0aGUg
ZGV2aWNlIG9yIGZpbGVzeXN0ZW0sIHRoZXJlIGlzIG5vIHdheSBmb3IKdXNlcnMgdG8gcHJlLWFs
bG9jYXRlIHNwYWNlIGZvciB1c2UgaW4gc3VjaCBzdG9yYWdlIHNldHVwcy4gQ29uc2lkZXIgdGhl
CmZvbGxvd2luZyB1c2UtY2FzZXM6CgoxKSBTdXNwZW5kLXRvLWRpc2sgYW5kIHJlc3VtZSBmcm9t
IGEgZG0tdGhpbiBkZXZpY2U6IEluIG9yZGVyIHRvIGVuc3VyZSB0aGF0CiAgIHRoZSB1bmRlcmx5
aW5nIHRoaW5wb29sIG1ldGFkYXRhIGlzIG5vdCBtb2RpZmllZCBkdXJpbmcgdGhlIHN1c3BlbmQK
ICAgbWVjaGFuaXNtLCB0aGUgZG0tdGhpbiBkZXZpY2UgbmVlZHMgdG8gYmUgZnVsbHkgcHJvdmlz
aW9uZWQuCjIpIElmIGEgZmlsZXN5c3RlbSB1c2VzIGEgbG9vcCBkZXZpY2Ugb3ZlciBhIHNwYXJz
ZSBmaWxlLCBmYWxsb2NhdGUoKSBvbiB0aGUKICAgZmlsZXN5c3RlbSB3aWxsIGFsbG9jYXRlIGJs
b2NrcyBmb3IgZmlsZXMgYnV0IHRoZSB1bmRlcmx5aW5nIHNwYXJzZSBmaWxlCiAgIHdpbGwgcmVt
YWluIGludGFjdC4KMykgQW5vdGhlciBleGFtcGxlIGlzIHZpcnR1YWwgbWFjaGluZSB1c2luZyBh
IHNwYXJzZSBmaWxlL2RtLXRoaW4gYXMgYSBzdG9yYWdlCiAgIGRldmljZTsgYnkgZGVmYXVsdCwg
YWxsb2NhdGlvbnMgd2l0aGluIHRoZSBWTSBib3VuZGFyaWVzIHdpbGwgbm90IGFmZmVjdAogICB0
aGUgaG9zdC4KNCkgU2V2ZXJhbCBzdG9yYWdlIHN0YW5kYXJkcyBzdXBwb3J0IG1lY2hhbmlzbXMg
Zm9yIHRoaW4gcHJvdmlzaW9uaW5nIG9uCiAgIHJlYWwgaGFyZHdhcmUgZGV2aWNlcy4gRm9yIGV4
YW1wbGU6CiAgIGEuIFRoZSBOVk1lIHNwZWMgMS4wYiBzZWN0aW9uIDIuMS4xIGxvb3NlbHkgdGFs
a3MgYWJvdXQgdGhpbiBwcm92aXNpb25pbmc6CiAgICAgICJXaGVuIHRoZSBUSElOUCBiaXQgaW4g
dGhlIE5TRkVBVCBmaWVsZCBvZiB0aGUgSWRlbnRpZnkgTmFtZXNwYWNlIGRhdGEKICAgICAgIHN0
cnVjdHVyZSBpcyBzZXQgdG8g4oCYMeKAmSwgdGhlIGNvbnRyb2xsZXIgLi4uIHNoYWxsIHRyYWNr
IHRoZSBudW1iZXIgb2YKICAgICAgIGFsbG9jYXRlZCBibG9ja3MgaW4gdGhlIE5hbWVzcGFjZSBV
dGlsaXphdGlvbiBmaWVsZCIKICAgYi4gVGhlIFNDU2kgQmxvY2sgQ29tbWFuZHMgcmVmZXJlbmNl
IC0gNCBzZWN0aW9uIHJlZmVyZW5jZXMgIlRoaW4KICAgICAgcHJvdmlzaW9uZWQgbG9naWNhbCB1
bml0cyIsCiAgIGMuIFVGUyAzLjAgc3BlYyBzZWN0aW9uIDEzLjMuMyByZWZlcmVuY2VzICJUaGlu
IHByb3Zpc2lvbmluZyIuCgpJbiBhbGwgdGhlIGFib3ZlIHNpdHVhdGlvbnMsIGN1cnJlbnRseSwg
dGhlIG9ubHkgd2F5IGZvciBwcmUtYWxsb2NhdGluZyBzcGFjZQppcyB0byBpc3N1ZSB3cml0ZXMg
KG9yIHVzZSBXUklURV9aRVJPRVMvV1JJVEVfU0FNRSkuIEhvd2V2ZXIsIHRoYXQgZG9lcyBub3QK
c2NhbGUgd2VsbCB3aXRoIGxhcmdlciBwcmUtYWxsb2NhdGlvbiBzaXplcy4KClRoaXMgcGF0Y2hz
ZXQgaW50cm9kdWNlcyBwcmltaXRpdmVzIHRvIHN1cHBvcnQgYmxvY2stbGV2ZWwgcHJvdmlzaW9u
aW5nIChub3RlOgp0aGUgdGVybSAncHJvdmlzaW9uaW5nJyBpcyB1c2VkIHRvIHByZXZlbnQgb3Zl
cmxvYWRpbmcgdGhlIHRlcm0KJ2FsbG9jYXRpb25zL3ByZS1hbGxvY2F0aW9ucycpIHJlcXVlc3Rz
IGFjcm9zcyBmaWxlc3lzdGVtcyBhbmQgYmxvY2sgZGV2aWNlcy4KVGhpcyBhbGxvd3MgZmFsbG9j
YXRlKCkgYW5kIGZpbGUgY3JlYXRpb24gcmVxdWVzdHMgdG8gcmVzZXJ2ZSBzcGFjZSBhY3Jvc3MK
c3RhY2tlZCBsYXllcnMgb2YgYmxvY2sgZGV2aWNlcyBhbmQgZmlsZXN5c3RlbXMuIEN1cnJlbnRs
eSwgdGhlIHBhdGNoc2V0IGNvdmVycwphIHByb3RvdHlwZSBvbiB0aGUgZGV2aWNlLW1hcHBlciB0
YXJnZXRzLCBsb29wIGRldmljZSBhbmQgZXh0NCwgYnV0IHRoZSBzYW1lCm1lY2hhbmlzbSBjYW4g
YmUgZXh0ZW5kZWQgdG8gb3RoZXIgZmlsZXN5c3RlbXMvYmxvY2sgZGV2aWNlcyBhcyB3ZWxsIGFz
IGV4dGVuZGVkCmZvciB1c2Ugd2l0aCBkZXZpY2VzIGluIDQgYS1jLgoKUGF0Y2ggMSBpbnRyb2R1
Y2VzIFJFUV9PUF9QUk9WSVNJT04gYXMgYSBuZXcgcmVxdWVzdCB0eXBlLgpUaGUgcHJvdmlzaW9u
IHJlcXVlc3QgYWN0cyBsaWtlIHRoZSBpbnZlcnNlIG9mIGEgZGlzY2FyZCByZXF1ZXN0OyBpbnN0
ZWFkCm9mIG5vdGlmeWluZyBsb3dlciBsYXllcnMgdGhhdCB0aGUgYmxvY2sgcmFuZ2Ugd2lsbCBu
byBsb25nZXIgYmUgdXNlZCwgcHJvdmlzaW9uCmFjdHMgYXMgYSByZXF1ZXN0IHRvIGxvd2VyIGxh
eWVycyB0byBwcm92aXNpb24gZGlzayBzcGFjZSBmb3IgdGhlIGdpdmVuIGJsb2NrCnJhbmdlLiBS
ZWFsIGhhcmR3YXJlIHN0b3JhZ2UgZGV2aWNlcyB3aWxsIGN1cnJlbnRseSBkaXNhYmxlIHRoZSBw
cm92aXNpb2luZwpjYXBhYmlsaXR5IGJ1dCBmb3IgdGhlIHN0YW5kYXJkcyBsaXN0ZWQgaW4gNGEu
LWMuLCBSRVFfT1BfUFJPVklTSU9OIGNhbiBiZQpvdmVybG9hZGVkIGZvciB1c2UgYXMgdGhlIHBy
b3Zpc2lvaW5nIHByaW1pdGl2ZSBmb3IgZnV0dXJlIGRldmljZXMuCgpQYXRjaCAyIGltcGxlbWVu
dHMgUkVRX09QX1BST1ZJU0lPTiBoYW5kbGluZyBmb3Igc29tZSBvZiB0aGUgZGV2aWNlLW1hcHBl
cgp0YXJnZXRzLiBUaGlzIGFkZGl0aW9uYWxseSBhZGRzIHN1cHBvcnQgZm9yIHByZS1hbGxvY2F0
aW5nIHNwYWNlIGZvciB0aGlubHkKcHJvdmlzaW9uZWQgbG9naWNhbCB2b2x1bWVzIHZpYSBmYWxs
b2NhdGUoKQoKUGF0Y2ggMyBpbnRyb2R1Y2VzIGFuIGZhbGxvY2F0ZSgpIG1vZGUgKEZBTExPQ19G
TF9QUk9WSVNJT04pIHRoYXQgc2VuZHMgYQpwcm92aXNpb24gcmVxdWVzdCB0byB0aGUgdW5kZXJs
eWluZyBibG9jayBkZXZpY2UgKGFuZCBiZXlvbmQpLiBUaGlzIGFjdHMgYXMgdGhlCnByaW1hcnkg
bWVjaGFuaXNtIGZvciBmaWxlIHByb3Zpc2lvbmluZyBhcyB3ZWxsIGFzIGRpc2FtYmlndWF0ZXMg
dGhlIG5vdGlvbiBvZgp2aXJ0dWFsIGFuZCB0cnVlIGRpc2sgc3BhY2UgYWxsb2NhdGlvbnMgZm9y
IHRoaW5seSBwcm92aXNpb25lZCBzdG9yYWdlIGRldmljZXMvCmZpbGVzeXN0ZW1zLiBXaXRoIHBh
dGNoIDMsIHRoZSAnZGVmYXVsdCcgZmFsbG9jYXRlKCkgbW9kZSBpcyBwcmVzZXJ2ZWQgdG8KcGVy
Zm9ybSBwcmVhbGxvY2F0aW9uIGF0IHRoZSBjdXJyZW50IGFsbG9jYXRpb24gbGF5ZXIgYW5kICdw
cm92aXNpb24nIG1vZGUKYWRkcyB0aGUgY2FwYWJpbGl0eSB0byBwdW5jaCB0aHJvdWdoIHRoZSBh
bGxvY2F0aW9ucyB0byB0aGUgdW5kZXJseWluZyB0aGlubHkKcHJvdmlzaW9uZWQgc3RvcmFnZSBs
YXllcnMuIEZvciByZWd1bGFyIGZpbGVzeXN0ZW1zLCBib3RoIGFsbG9jYXRpb24gbW9kZXMKYXJl
IGVxdWl2YWxlbnQuCgpQYXRjaCA0IHdpcmVzIHVwIHRoZSBsb29wIGRldmljZSBoYW5kbGluZyBv
ZiBSRVFfT1BfUFJPVklTSU9OLgoKUGF0Y2hlcyA1LTcgY292ZXIgYSBwcm90b3R5cGUgaW1wbGVt
ZW50YXRpb24gZm9yIGV4dDQsIHdoaWNoIGluY2x1ZGVzIHdpcmluZyB1cAp0aGUgZmFsbG9jYXRl
KCkgaW1wbGVtZW50YXRpb24sIGludHJvZHVjaW5nIGEgZmlsZXN5c3RlbSBsZXZlbCBvcHRpb24g
KGNhbGxlZAoncHJvdmlzaW9uJykgdG8gY29udHJvbCB0aGUgZGVmYXVsdCBhbGxvY2F0aW9uIGJl
aGF2aW91ciBhbmQsIGZpbmFsbHksIGEKZmlsZS1sZXZlbCBvdmVycmlkZSB0byByZXRhaW4gY3Vy
cmVudCBoYW5kbGluZywgZXZlbiBvbiBmaWxlc3lzdGVtcyBtb3VudGVkIHdpdGgKJ3Byb3Zpc2lv
bicuIFRoZXNlIG9wdGlvbnMgYWxsb3cgdXNlcnMgb2Ygc3RhY2tlZCBmaWxlc3lzdGVtcyB0byBm
bGV4aWJseSB0YWtlCmFkdmFudGFnZSBvZiBwcm92aXNpb25pbmcuCgpUZXN0aW5nOgotLS0tLS0t
LQotIFRlc3RlZCBvbiBhIFZNIHJ1bm5pbmcgYSA2LjIga2VybmVsLgotIFRoZSBmb2xsb3dpbmcg
cGVyZm9tcm1hbmNlIG1lYXN1cmVtZW50cyB3ZXJlIGNvbGxlY3RlZCB3aXRoIGZhbGxvY2F0ZSgy
KQpwYXRjaGVkIHRvIGFkZCBzdXBwb3J0IGZvciBGQUxMT0NfRkxfUFJPVklTSU9OIHZpYSBhIGNv
bW1hbmQgbGluZSBvcHRpb24gCmAtcC8tLXByb3Zpc2lvbmAuCgotIFByZWFsbG9jYXRpb24gb2Yg
ZG0tdGhpbiBkZXZpY2VzOgpBcyBleHBlY3RlZCwgYXZvaWRpbmcgdGhlIG5lZWQgdG8gemVybyBv
dXQgdGhpbmx5LXByb3Zpc2lvbmVkIGJsb2NrIGRldmljZXMgdG8KcHJlYWxsb2NhdGUgc3BhY2Ug
c3BlZWRzIHVwIHRoZSBwcm92aXNpb25pbmcgb3BlcmF0aW9uIHNpZ25pZmljYW50bHk6CgpUaGUg
Zm9sbG93aW5nIHdhcyB0ZXN0ZWQgb24gYSBkbS10aGluIGRldmljZSBzZXQgdXAgb24gdG9wIG9m
IGEgZG0tdGhpbnAgd2l0aApza2lwX2Jsb2NrX3plcm9pbmc9dHJ1ZS4KQSkgWmVyb291dCB3YXMg
bWVhc3VyZWQgdXNpbmcgYGZhbGxvY2F0ZSAteiAuLi5gCkIpIFByb3Zpc2lvbiB3YXMgbWVhc3Vy
ZWQgdXNpbmcgYGZhbGxvY2F0ZSAtcCAuLi5gLgoKU2l6ZSAgICBUaW1lICAgICBBCUIKNTEyTSAg
ICByZWFsICAgICAxLjA5MyAgMC4wMzQKICAgICAgICB1c2VyICAgICAwICAgICAgMAogICAgICAg
IHN5cyAgICAgIDAuMDIyICAwLjAxCjFHICAgICAgcmVhbCAgICAgMi4xODIgIDAuMDQ4CiAgICAg
ICAgdXNlciAgICAgMCAgICAgIDAuMDEKICAgICAgICBzeXMgICAgICAwLjAyMiAgMAoyRyAgICAg
IHJlYWwgICAgIDQuMzQ0ICAwLjA4MgogICAgICAgIHVzZXIgICAgIDAgICAgICAwLjAxCiAgICAg
ICAgc3lzICAgICAgMC4wMzYgIDAKNEcgICAgICByZWFsICAgICA4LjY3OSAgMC4xNTMKICAgICAg
ICB1c2VyICAgICAwICAgICAgMC4wMQogICAgICAgIHN5cyAgICAgIDAuMDczICAwCjhHICAgICAg
cmVhbCAgICAxNy43NzcgIDAuMzE4CiAgICAgICAgdXNlciAgICAgMCAgICAgIDAuMDEKICAgICAg
ICBzeXMgICAgICAwLjE0NCAgMAoKLSBQcmVhbGxvY2F0aW9uIG9mIGZpbGVzIG9uIGZpbGVzeXN0
ZW1zClNpbmNlIGZhbGxvY2F0ZSgpIHdpdGggRkFMTE9DX0ZMX1BST1ZJU0lPTiBjYW4gbm93IHBh
c3MgZG93biB0aHJvdWdoCmZpbGVzeXN0ZW1zL2Jsb2NrIGRldmljZXMsIHRoaXMgcmVzdWx0cyBp
biBhbiBleHBlY3RlZCBzbG93ZG93biBpbiBmYWxsb2NhdGUoKQpjYWxscyBpZiB0aGUgcHJvdmlz
aW9uIHJlcXVlc3QgaXMgc2VudCB0byB0aGUgdW5kZXJseWluZyBsYXllcnMuCgpUaGUgbWVhc3Vy
ZW1lbnRzIHdlcmUgdGFrZW4gdXNpbmcgZmFsbG9jYXRlKCkgb24gZXh0NCBmaWxlc3lzdGVtcyBz
ZXQgdXAgd2l0aAp0aGUgZm9sbG93aW5nIG9wdHMvYmxvY2sgZGV2aWNlczoKQSkgZXh0NCBmaWxl
c3lzdGVtIG1vdW50ZWQgd2l0aCAnbm9wcm92aXNpb24nCkIpIGV4dDQgZmlsZXN5c3RlbSBtb3Vu
dGVkIHdpdGggJ3Byb3Zpc2lvbicgb24gYSBkbS10aGluIGRldmljZS4KQykgZXh0NCBmaWxlc3lz
dGVtIG1vdW50ZWQgd2l0aCAncHJvdmlzaW9uJyBvbiBhIGxvb3AgZGV2aWNlIHdpdGggYSBzcGFy
c2UKICAgYmFja2luZyBmaWxlIG9uIHRoZSBmaWxlc3lzdGVtIGluIChCKS4KClNpemUJVGltZQlB
CUIJQwo1MTJNCXJlYWwJMC4wMTEJMC4wMzYJMC4wNDEKCXVzZXIJMC4wMgkwLjAzCTAuMDAyCglz
eXMJMAkwCTAKMUcJcmVhbAkwLjAxMQkwLjA1NQkwLjA2NAoJdXNlcgkwCTAJMC4wMwoJc3lzCTAu
MDAzCTAuMDA0CTAKMkcJcmVhbAkwLjAxMQkwLjEwOQkwLjExNwoJdXNlcgkwCTAJMC4wMDQKCXN5
cwkwLjAwMwkwLjAwNgkwCjRHCXJlYWwJMC4wMTEJMC4yMjQJMC4yMzEKCXVzZXIJMAkwCTAuMDA2
CglzeXMJMC4wMDQJMC4wMTIJMAo4RwlyZWFsCTAuMDE3CTAuNDI2CTAuNTI3Cgl1c2VyCTAJMAkw
LjAxMwoJc3lzCTAuMDA5CTAuMDI0CTAKCkFzIGV4cGVjdGVkLCB0aGUgYWRkaXRpb25hbCBwcm92
aXNpb24gcmVxdWVzdHMgd2lsbCBzbG93IGRvd24gZmFsbG9jYXRlKCkgY2FsbHMKYW5kIHRoZSBk
ZWdyZWUgb2Ygc2xvd2Rvd24gZGVwZW5kcyBvbiB0aGUgbnVtYmVyIG9mIGxheWVycyB0aGF0IHRo
ZSBwcm92aXNpb24KcmVxdWVzdCBpcyBwYXNzZWQgdGhyb3VnaCB0byBhcyB3ZWxsIGFzIHRoZSBj
b21wbGV4aXR5IG9mIGFsbG9jYXRpb24gb24gdGhvc2UKbGF5ZXJzLgoKVE9ET3M6Ci0tLS0tLQot
IFhmc3Rlc3RzIGZvciB2YWxpZGF0aW5nIHByb3Zpc2lvbmluZyByZXN1bHRzIGluIGFsbG9jYXRp
b24uCgpDaGFuZ2Vsb2c6CgpWMjoKLSBGaXggc3RhY2tlZCBsaW1pdCBoYW5kbGluZy4KLSBFbmFi
bGUgcHJvdmlzaW9uIHJlcXVlc3QgaGFuZGxpbmcgaW4gZG0tc25hcHNob3QKLSBEb24ndCBjYWxs
IHRydW5jYXRlX2JkZXZfcmFuZ2UgaWYgYmxrZGV2X2ZhbGxvY2F0ZSgpIGlzIGNhbGxlZCB3aXRo
CiAgRkFMTE9DX0ZMX1BST1ZJU0lPTi4KLSBDbGFyaWZ5IHNlbWFudGljcyBvZiBGQUxMT0NfRkxf
UFJPVklTSU9OIGFuZCB3aHkgaXQgbmVlZHMgdG8gYmUgYSBzZXBhcmF0ZSBmbGFnCiAgKGFzIG9w
cG9zZWQgdG8gb3ZlcmxvYWRpbmcgbW9kZSA9PSAwKS4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlz
dApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWwK

