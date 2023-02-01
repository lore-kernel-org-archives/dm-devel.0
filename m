Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 030D3C63797
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 08:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675238639;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1z63CmYYo6lahzLKZbxaFXsYN+otlUWAUBlFUIl6eGQ=;
	b=RBmiqMCoSrVov3Q9pWMR+co1h98ersZJn/vYujcVArjphTYAsD0XCUm3A5MFvLlR0Ya3SB
	lwCxHStsekUJpNiiErpUjpFqkRa7iv8JCzC1YeWivw1rfox43D62E4aDzNwFJBSFN4kQM5
	AMg+GSwx++tg/scM6HE0/XPKDRZ/tv8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-pRJeTzXpMBGYX9hCzBACjg-1; Wed, 01 Feb 2023 03:03:55 -0500
X-MC-Unique: pRJeTzXpMBGYX9hCzBACjg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A70A23C1024E;
	Wed,  1 Feb 2023 08:03:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 90279112132D;
	Wed,  1 Feb 2023 08:03:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E6BA21946A6B;
	Wed,  1 Feb 2023 08:03:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 25DDF1946587
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Feb 2023 00:49:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 10B78492B00; Wed,  1 Feb 2023 00:49:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 08C5F492C3E
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 00:49:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87211380670A
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 00:49:00 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-94-UEY95R3aPWyeqPA7U4tMtA-1; Tue,
 31 Jan 2023 19:48:53 -0500
X-MC-Unique: UEY95R3aPWyeqPA7U4tMtA-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 6F5F120E0A00; Tue, 31 Jan 2023 16:48:52 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6F5F120E0A00
Date: Tue, 31 Jan 2023 16:48:52 -0800
From: Fan Wu <wufan@linux.microsoft.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Message-ID: <20230201004852.GB30104@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <033335b26f6becdc3dc0325ef926efd94fcc4dda.camel@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <033335b26f6becdc3dc0325ef926efd94fcc4dda.camel@huaweicloud.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Wed, 01 Feb 2023 08:03:52 +0000
Subject: Re: [dm-devel] [RFC PATCH v9 00/16] Integrity Policy Enforcement
 LSM (IPE)
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
 paul@paul-moore.com, dm-devel@redhat.com, corbet@lwn.net,
 roberto.sassu@huawei.com, linux-doc@vger.kernel.org, snitzer@kernel.org,
 jmorris@namei.org, zohar@linux.ibm.com, linux-kernel@vger.kernel.org,
 ebiggers@kernel.org, linux-security-module@vger.kernel.org,
 linux-audit@redhat.com, eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 31, 2023 at 03:22:05PM +0100, Roberto Sassu wrote:
> On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > IPE has two known gaps:
> > 
> > 1. IPE cannot verify the integrity of anonymous executable memory, such as
> >   the trampolines created by gcc closures and libffi (<3.4.2), or JIT'd code.
> >   Unfortunately, as this is dynamically generated code, there is no way
> >   for IPE to ensure the integrity of this code to form a trust basis. In all
> >   cases, the return result for these operations will be whatever the admin
> >   configures the DEFAULT action for "EXECUTE".
> 
> I think it would be useful to handle special cases, for example you
> could allow a process that created a file with memfd to use it, at the
> condition that nobody else writes it.
> 
> This would be required during the boot, otherwise services could fail
> to start (depending on the policy).
> 
Thanks for the suggestion. I agree with your opinion and I think supporting
memfd is possible but restricting read/write needs more hooks. We would like
to avoid adding more complexity to this initial posting as necessary. 
We will consider this as a future work and will post follow-on patches
in the future.

-Fan

> > 2. IPE cannot verify the integrity of interpreted languages' programs when
> >   these scripts invoked via ``<interpreter> <file>``. This is because the
> >   way interpreters execute these files, the scripts themselves are not
> >   evaluated as executable code through one of IPE's hooks. Interpreters
> >   can be enlightened to the usage of IPE by trying to mmap a file into
> >   executable memory (+X), after opening the file and responding to the
> >   error code appropriately. This also applies to included files, or high
> >   value files, such as configuration files of critical system components.
> 
> Ok, it is a well known issue. Hopefully, it will be fixed soon.
> 
> Roberto
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

