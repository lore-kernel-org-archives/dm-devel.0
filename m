Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6239FC6FD1D
	for <dm-devel@archiver.kernel.org>; Mon, 20 Mar 2023 19:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679340147;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=w7e45JcK0VaBHzz2QhESlC7Idl/4jkDlRuXD1z3mNg4=;
	b=Wy2fchuj5i97NvK+E5SN0KoKLhSI2gRzmMREFeipc1mnunNucq1UAwdE2HEXBd8nKh1EkA
	S//GeAG6FxBS75Z94ylZa4IwU+E1VBUkmiMZYX7pegW7L9RLQMZNH2aSTF4Q5nah+nfRRO
	CthKJhg9SDJQ9bOetRVT2E+kCTAQ6+8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-bTS8m4fMNbWy2A90Xr-r8w-1; Mon, 20 Mar 2023 15:22:24 -0400
X-MC-Unique: bTS8m4fMNbWy2A90Xr-r8w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 068E21C068C6;
	Mon, 20 Mar 2023 19:22:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5E93118EC2;
	Mon, 20 Mar 2023 19:22:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1E0FC19465A2;
	Mon, 20 Mar 2023 19:22:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 70C6E1946594
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Mar 2023 19:22:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 39A252166B2A; Mon, 20 Mar 2023 19:22:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FFF32166B29
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 19:22:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C9C41C068C6
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 19:22:18 +0000 (UTC)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
 [209.85.214.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-puo1sN9XMeCDCYJrNWgD7g-1; Mon, 20 Mar 2023 15:22:16 -0400
X-MC-Unique: puo1sN9XMeCDCYJrNWgD7g-1
Received: by mail-pl1-f181.google.com with SMTP id h8so13615406plf.10
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 12:22:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679340134;
 h=to:date:message-id:subject:mime-version:content-transfer-encoding
 :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ynB3vmi7ikxOTFzH2qwoVV/Nj9LRZhsiUjv2Aj+M80g=;
 b=RhOk65V4KC+lMBFSLWmIxzX4kbi91zlE1KimRlDXV6tohEA/BTehYKBejxGK3kj07F
 JA6E5vIjXRuYkipipkHQgoPqfX3NU24v7RirC1A/r3aXmzn+ogxaiSpPv5BpSD4oAcEB
 lm8wex1glNq27YTLWHddp3w0bTiyGj/ni4fi5Opks4e8PmGOK780WfZgJOfXUVplJ3bX
 JWE8ssMonln3N60eQ9jmP6HBxKTk3etUHr6NtbGG+nO/qmLbSxyBK1qpOc4d0WgkZaej
 LagOTUfaQa2gY+0YzXWvsExVNJF3bKvMcS5aMeBzwtP/aGO8pShKRc+XXpAUYSuO3EJC
 TbYA==
X-Gm-Message-State: AO0yUKVXJvZIiBL5Y/3Ux/nBysAe5K+ncHUr06M7zZMA+UisU7B1JGz7
 bfTphRzpz9cGgf+vl1noaiFTls7kD7xhCPDblHv7+bjHgxMBoWeIktExkrXImbguUeL/FFWVrb4
 ntzU1MNShF9m2jL/g/BlWdL5UCspWuwIjG5fNdahhd1zNaOUZABgu54Q86DxG8saf7oWpykkK
X-Google-Smtp-Source: AK7set8KRyfwLefDqM84Izs0w7p4J8mekhc9e4hkG0JOoHrWpmzR1lhF2lN+dFYEY42cKmDfT/b63w==
X-Received: by 2002:a05:6a20:1222:b0:d9:e5db:5287 with SMTP id
 v34-20020a056a20122200b000d9e5db5287mr3139388pzf.4.1679340134292; 
 Mon, 20 Mar 2023 12:22:14 -0700 (PDT)
Received: from smtpclient.apple ([136.226.79.14])
 by smtp.gmail.com with ESMTPSA id
 e9-20020aa78249000000b0058b927b9653sm6882987pfn.92.2023.03.20.12.22.13
 for <dm-devel@redhat.com>
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 20 Mar 2023 12:22:13 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Message-Id: <DB68C384-BA3A-40E8-9223-4868EE30B68A@purestorage.com>
Date: Mon, 20 Mar 2023 12:22:02 -0700
To: device-mapper development <dm-devel@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH] libmultipathd Avoid parsing errors due to
 unsupported designators
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

VW5zdXBwb3J0ZWQgZGVzaWduYXRvcnMsIGV2ZW4gaWYgdGhleSBhcmUgY29ycmVjdCwgd2lsbCBy
ZXN1bHQKaW4gcGFyc2luZyBlcnJvcnMuIEFkZCBzdXBwb3J0IGZvciB0aGVzZSB0d286CgpMb2dp
Y2FsIFVuaXQgR3JvdXAgKDB4NikKVmVuZG9yIFNwZWNpZmljICgweDApCgpNYXIgMjAgMTM6Mzc6
MzUgaW5pdDEwNy0xOCBtdWx0aXBhdGhbNDUwMTZdOiBwYXJzZV92cGRfcGc4MzoKaW52YWxpZCBk
ZXZpY2UgZGVzaWduYXRvciBhdCBvZmZzZXQgODc6IDAxMDYwMDA0Ck1hciAyMCAxMzozNzozNSBp
bml0MTA3LTE4IG11bHRpcGF0aFs0NTAxNl06IHBhcnNlX3ZwZF9wZzgzOgppbnZhbGlkIGRldmlj
ZSBkZXNpZ25hdG9yIGF0IG9mZnNldCAxMzE6IDAyMDAwMDA1CgpUaGFua3MsCkJyaWFuCgpTaWdu
ZWQtb2ZmLWJ5OiBCcmlhbiBCdW5rZXIgPGJyaWFuQHB1cmVzdG9yYWdlLmNvbT4K4oCUCi0tLQog
bGlibXVsdGlwYXRoL2Rpc2NvdmVyeS5jIHwgOCArKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDgg
aW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYyBiL2xp
Ym11bHRpcGF0aC9kaXNjb3ZlcnkuYwppbmRleCBkOWVlMmNiOS4uMzA2ODg0ZjYgMTAwNjQ0Ci0t
LSBhL2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYworKysgYi9saWJtdWx0aXBhdGgvZGlzY292ZXJ5
LmMKQEAgLTEyMTEsNiArMTIxMSwxNCBAQCBwYXJzZV92cGRfcGc4Myhjb25zdCB1bnNpZ25lZCBj
aGFyICppbiwgc2l6ZV90IGluX2xlbiwKICAgICAgICAgICAgICAgICAgICAgICAgaW52YWxpZCA9
IChkWzNdIDwgOCk7CiAgICAgICAgICAgICAgICAgICAgICAgIG5ld19wcmlvID0gMjsKICAgICAg
ICAgICAgICAgICAgICAgICAgYnJlYWs7CisgICAgICAgICAgICAgICBjYXNlIDB4NjoKKyAgICAg
ICAgICAgICAgICAgICAgICAgLyogTG9naWNhbCBVbml0IEdyb3VwICovCisgICAgICAgICAgICAg
ICAgICAgICAgIGludmFsaWQgPSAoZFszXSAhPSA0KTsKKyAgICAgICAgICAgICAgICAgICAgICAg
YnJlYWs7CisgICAgICAgICAgICAgICBjYXNlIDB4MDoKKyAgICAgICAgICAgICAgICAgICAgICAg
LyogVmVuZG9yIFNwZWNpZmljICovCisgICAgICAgICAgICAgICAgICAgICAgIGludmFsaWQgPSAw
OworICAgICAgICAgICAgICAgICAgICAgICBicmVhazsKICAgICAgICAgICAgICAgIGNhc2UgMHhh
OgogICAgICAgICAgICAgICAgICAgICAgICBjb25kbG9nKDIsICIlczogVVVJRCBpZGVudGlmaWVy
cyBub3QgeWV0IHN1cHBvcnRlZCIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgX19m
dW5jX18pOwotLQoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29t
Cmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

