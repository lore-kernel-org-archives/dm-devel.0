Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04F7CC04FE0
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971640;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nOVop/cb8cGZnV2/a0CwUxJs388Yq2TsdnFnZCLQye0=;
	b=PUo63ZrcmbtncJ/GrQonkhq8iB5+ekm0E+CuV6444ZPKmpPeGDivfLPIlZitdmYWKmWKmH
	4nRNDYheomauvcI7ufVEpvoTGihxaaobkwbcAVDEkk9c6hrT8D6/kINe4m/XChpvitTkVi
	fOHY+1D1Wh+MW0/kc1oLX+1od4yPpts=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-J072QA0qOMSlfBtv8XP3KA-1; Mon, 10 Jul 2023 02:47:13 -0400
X-MC-Unique: J072QA0qOMSlfBtv8XP3KA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2566C88710F;
	Mon, 10 Jul 2023 06:47:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10DE04CD0D7;
	Mon, 10 Jul 2023 06:47:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0726B1946A7E;
	Mon, 10 Jul 2023 06:47:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 657141946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 26 Jun 2023 15:20:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 365F8C1ED97; Mon, 26 Jun 2023 15:20:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E17DC00049
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 15:20:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04A28185A78B
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 15:20:56 +0000 (UTC)
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com
 [66.111.4.27]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-7_gtwqVkMCaGmGaqQCevTg-1; Mon, 26 Jun 2023 11:20:54 -0400
X-MC-Unique: 7_gtwqVkMCaGmGaqQCevTg-1
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
 by mailout.nyi.internal (Postfix) with ESMTP id DC4105C00CE;
 Mon, 26 Jun 2023 11:12:36 -0400 (EDT)
Received: from imap48 ([10.202.2.98])
 by compute1.internal (MEProxy); Mon, 26 Jun 2023 11:12:36 -0400
X-ME-Sender: <xms:5KqZZMiijZk4GWNTi8Zm6Rom_4iJ750DKy3j2ZH3DV43ZriI3PXBGw>
 <xme:5KqZZFAb5GmyUZdWt5JuCXzTv2Hm5GTJ3rKCmiLiBj1H_RFXF7QlOeKfXFz0O4Ni_
 oi3noi3m7tkhg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeehfedgkedvucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhepofgfggfkjghffffhvfevufgtgfesthhqredtreerjeenucfhrhhomhepfdev
 hhhrihhsucfnrghmsgdfuceolhgrmhgshiesuggvsghirghnrdhorhhgqeenucggtffrrg
 htthgvrhhnpeetjeevfeekieejgeejieehgfffvdeugeejueeuhfehudffteduhfffjeff
 ueeljeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
 hlrghmsgihseguvggsihgrnhdrohhrgh
X-ME-Proxy: <xmx:5KqZZEHZyYvvuTLQegH4DudWJfE-fa8GOnwnDkzL5N91Ec51k1NcqQ>
 <xmx:5KqZZNRS8ciiAVbnwOHNk5fScgyqeueVsVCcS3T-U5vS1nyHF0UNEg>
 <xmx:5KqZZJyA3s6HIuugzlk_xcWt_oO-AQ_wDqXd54zuxcmRUQ6jOkZxQg>
 <xmx:5KqZZHZ9plChw5oDK-UPyPdhpfL88ENEBo4NMDa6MFIkOeXKWIyNBA>
Feedback-ID: i1f084090:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
 id 9FCF831A0063; Mon, 26 Jun 2023 11:12:36 -0400 (EDT)
User-Agent: Cyrus-JMAP/3.9.0-alpha0-499-gf27bbf33e2-fm-20230619.001-gf27bbf33
Mime-Version: 1.0
Message-Id: <8baf47c3-ad74-42bc-9d50-7a2db4a0d92a@app.fastmail.com>
In-Reply-To: <f3a301cc93949552b5f943f66b6b19259275c616.camel@suse.com>
References: <20230606171221.1472-1-zeha@debian.org>
 <f3a301cc93949552b5f943f66b6b19259275c616.camel@suse.com>
Date: Mon, 26 Jun 2023 16:12:14 +0100
From: "Chris Lamb" <lamby@debian.org>
To: "Martin Wilck" <mwilck@suse.com>,
 "Christian Hofstaedtler" <zeha@debian.org>, dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH] multipath-tools build: accept
 KBUILD_BUILD_TIMESTAMP from env
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: debian.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

TWFydGluIFdpbGNrIHdyb3RlOgoKPiBDYW4gd2UgZG8gdGhpcyBpbnN0ZWFkPyBJdCBsb29rcyBz
bGlnaHRseSBtb3JlIHJlYWRhYmxlIHRvIG1lLgoKTEdUTS4KCgpSZWdhcmRzLAoKLS0gCiAgICAg
ICwnJ2AuCiAgICAgOiA6JyAgOiAgICAgQ2hyaXMgTGFtYgogICAgIGAuIGAnYCAgICAgIGxhbWJ5
QGRlYmlhbi5vcmcg8J+NpSBjaHJpcy1sYW1iLmNvLnVrCiAgICAgICBgLQoKLS0KZG0tZGV2ZWwg
bWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

