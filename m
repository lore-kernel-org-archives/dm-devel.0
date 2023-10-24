Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23A1749D
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CRDBuPjt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698119587;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XsaNGjlcimJtQjiAwAEMf2P9+0lBW+WKE/hjZAD7dek=;
	b=CRDBuPjtZnGKXeGE1fIHIrtcRetJX0B2iESC/K2EHkkkkXyxLHk6qOEIvcL66R8VSFqwSM
	nGBVzQkTPtBvrUjO9RlLxO54dVg1jHGu0tkTOARQonWYYiUQW3T0bb0SMfF4BvghtUxM0D
	RPjqvQ/UeCgrHp98M5v6Nm5Ix3iwToE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-GKWeklhLP_2BJo-cU5mWWg-1; Mon, 23 Oct 2023 23:52:56 -0400
X-MC-Unique: GKWeklhLP_2BJo-cU5mWWg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20178185A7A2
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 172A125C2
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D8C591946589
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8D9101946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 03:52:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6CC162026D66; Tue, 24 Oct 2023 03:52:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6529C2026D4C
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:55 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C47638143A2
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:55 +0000 (UTC)
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com
 [209.85.222.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-yA9r3FGnMxGQN6Wx_FwLFA-1; Mon, 23 Oct 2023 23:52:38 -0400
X-MC-Unique: yA9r3FGnMxGQN6Wx_FwLFA-1
Received: by mail-qk1-f169.google.com with SMTP id
 af79cd13be357-7789a4c01easo264258085a.0
 for <dm-devel@redhat.com>; Mon, 23 Oct 2023 20:52:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698119558; x=1698724358;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=XsaNGjlcimJtQjiAwAEMf2P9+0lBW+WKE/hjZAD7dek=;
 b=PNJEKBW3BJbq/I0Z8TtuUTI8QAO1q5GyxYVyIgdd79Kz6s4YrRxuGC1uxVj4Y2SyzK
 XEEnKHeXj+Kqw9pDi+WKvhrOXIaym/pmih6Kf5rdwXOrm5Djgtb97funBCFoiPf6abd5
 NvElaYSpOzQZuWrQxlgK9aRtrB3P34QRijwCyU030GATFRobc+utePV0tRWGCKSqvHU8
 AFOGBSPBir3ckT6qWaXtU+x46Gfr3Da+8mhTj4zdnb8YKvi7793O0O7dOhfnVocbVirb
 1tZ+77Q8Xh4+X7xPvolAZAAxXDP0WehXxRl1oN7q2+wiYCBJ0Ep1EGTngJ3r0Vnd30VG
 /2Ug==
X-Gm-Message-State: AOJu0YyFhKsMLR/iD9wwFtRPoIJ6yfSA3GsCMBeAlmYB5KKm3GWWzTdW
 sQsnHxiWmj+tqOmRevS3rmTt
X-Google-Smtp-Source: AGHT+IFgtMi4EqN6N9ZtnfOHbANV4Egy0LBPK5cs6vsX4rIphs5HUZhBFo1nSJ25zSqGEggCASqLKw==
X-Received: by 2002:a05:620a:430d:b0:778:8dc1:bb7b with SMTP id
 u13-20020a05620a430d00b007788dc1bb7bmr13244374qko.27.1698119557740; 
 Mon, 23 Oct 2023 20:52:37 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 s4-20020ad45004000000b0063f88855ef2sm3286811qvo.101.2023.10.23.20.52.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Oct 2023 20:52:37 -0700 (PDT)
Date: Mon, 23 Oct 2023 23:52:36 -0400
Message-ID: <88259677752389b350614857e6003b8c.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Subject: Re: [PATCH RFC v11 18/19] ipe: kunit test for parser
References: <1696457386-3010-19-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-19-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
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
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org,
 Deven Bowers <deven.desai@linux.microsoft.com>, roberto.sassu@huawei.com,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, audit@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>,
 linux-integrity@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 2
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> Add various happy/unhappy unit tests for both IPE's parser.

I'm going to suggest: "... for IPE's policy parser."

Also, aside from the policy parser tests, are there any other IPE
functional tests?  We do have a testing guideline for new LSM
submissions:

 "New LSMs must be accompanied by a test suite to verify basic
  functionality and help identify regressions. The test suite
  must be publicly available without download restrictions
  requiring accounts, subscriptions, etc. Test coverage does
  not need to reach a specific percentage, but core functionality
  and any user interfaces should be well covered by the test
  suite. Maintaining the test suite in a public git repository is
  preferable over tarball snapshots. Integrating the test suite
  with existing automated Linux kernel testing services is
  encouraged."

https://github.com/LinuxSecurityModule/kernel/blob/main/README.md#new-lsm-guidelines

> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v1-v6:
>   + Not present
> 
> v7:
>   Introduced
> 
> v8:
>   + Remove the kunit tests with respect to the fsverity digest, as these
>     require significant changes to work with the new method of acquiring
>     the digest at runtime.
> 
> v9:
>   + Remove the kunit tests related to ipe_context
> 
> v10:
>   + No changes
> 
> v11:
>   + No changes
> ---
>  security/ipe/Kconfig        |  17 +++
>  security/ipe/Makefile       |   3 +
>  security/ipe/policy_tests.c | 294 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 314 insertions(+)
>  create mode 100644 security/ipe/policy_tests.c

--
paul-moore.com

