Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46F06C7618E
	for <dm-devel@archiver.kernel.org>; Fri, 17 Mar 2023 14:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679064893;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4GdU2O0Cnj9V35e3Cr0LuProlBsbJ80L7g85Qk+YfvA=;
	b=KFwu1ixj6jUt+TaHq92Kg3YQrdGcdUu41EtZEf4g1nzGC2nMNNq4u2y7eTt3zZ6CtJeKMn
	h7KiNZ2o2BVpKs5TqVRQBToJ9CHICl4XSYMPqKbBk2eiFAaMlDxfF4JUl0mdF/WS5qoPPq
	gU1Ps5ATQF9L87eF9qsY4B9+pWcMkPE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-5t1-YCgGNlCln5UOl-l7dw-1; Fri, 17 Mar 2023 10:54:50 -0400
X-MC-Unique: 5t1-YCgGNlCln5UOl-l7dw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DDD93C1015D;
	Fri, 17 Mar 2023 14:54:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3AD47C15BA0;
	Fri, 17 Mar 2023 14:54:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E20A31946A51;
	Fri, 17 Mar 2023 14:54:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 521E41946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Mar 2023 22:10:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3E7972166B29; Thu, 16 Mar 2023 22:10:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 379092166B26
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 22:10:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1631D29A9CAD
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 22:10:42 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-657-kaOKI6GVMvmOz5gz_4r_nQ-1; Thu,
 16 Mar 2023 18:10:37 -0400
X-MC-Unique: kaOKI6GVMvmOz5gz_4r_nQ-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 49B962057034; Thu, 16 Mar 2023 15:10:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 49B962057034
Date: Thu, 16 Mar 2023 15:10:36 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20230316221036.GA22567@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-12-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRdm_xpXNQvSVO2hkx2js=_zzo2DiQ6PvEjAEet4OjxNw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhRdm_xpXNQvSVO2hkx2js=_zzo2DiQ6PvEjAEet4OjxNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [RFC PATCH v9 11/16] ipe: add support for dm-verity
 as a trust provider
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
 dm-devel@redhat.com, corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 snitzer@kernel.org, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 linux-security-module@vger.kernel.org, linux-audit@redhat.com,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 02, 2023 at 02:08:04PM -0500, Paul Moore wrote:
> 
> If you had both IPE and dm-verity enabled in your kernel build, is
> there ever a case where you wouldn't want IPE_PROP_DM_VERITY?  I
> suspect you can just have IPE and dm-verity select IPE_PROP_DM_VERITY
> and not bother the user/admin with the additional Kconfig knob.
> 
Sorry for the late reply, I was relocating to a new country and it
took me some time to settle down.

I have read your comments and I will try to answer some questions
that I can answer right now. For the remaining questions, I need more
time to get more context and information. I will get back to you
as soon as possible.

For this one I agree just have IPE and dm-verity select IPE_PROP_DM_VERITY
is better, I will update this in the next version.

> 
> --
> paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

