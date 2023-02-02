Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B217C64EC4
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 07:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675669123;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9Xeudu2EDvKHX1WtEWeow+44S0XcQN/qfeZ5HE6qNBk=;
	b=jRxRoMav/S+Q/u+Pqsod0xAi0q2SjSfS3dAtRmq1np0Hd1jCkr3SKNKAKbtgvnOgbNcAlq
	6JgPiPm4FK8HXiCHWeVKM+e96uDm4xDQWoPF/ed00jbFuUMJIeT9Aplzc7jY8+73theg70
	rtFiQqfKqlwCy5ea2IdlXvaWa/kYJr4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-OgciCL1EN-K_KmayCl78jA-1; Mon, 06 Feb 2023 02:38:38 -0500
X-MC-Unique: OgciCL1EN-K_KmayCl78jA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C661800DA6;
	Mon,  6 Feb 2023 07:38:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 412252166B26;
	Mon,  6 Feb 2023 07:38:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7648A1946587;
	Mon,  6 Feb 2023 07:38:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 51C84194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 10:49:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D0692112132D; Thu,  2 Feb 2023 10:49:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C89CB112132C
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 10:49:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9082B3C0F683
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 10:49:11 +0000 (UTC)
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com
 [14.137.139.23]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-370-tYCt4q-CPaesxPNT4inopQ-1; Thu, 02 Feb 2023 05:49:07 -0500
X-MC-Unique: tYCt4q-CPaesxPNT4inopQ-1
Received: from mail02.huawei.com (unknown [172.18.147.227])
 by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4P6wLH1sCJz9xqcV;
 Thu,  2 Feb 2023 18:40:55 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
 by APP2 (Coremail) with SMTP id GxC2BwBnNl3+lNtjGVTnAA--.14834S2;
 Thu, 02 Feb 2023 11:48:42 +0100 (CET)
Message-ID: <7dc9963c563d0b55bb35109be012e355eef13882.camel@huaweicloud.com>
From: Roberto Sassu <roberto.sassu@huaweicloud.com>
To: Fan Wu <wufan@linux.microsoft.com>
Date: Thu, 02 Feb 2023 11:48:18 +0100
In-Reply-To: <20230201004852.GB30104@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <033335b26f6becdc3dc0325ef926efd94fcc4dda.camel@huaweicloud.com>
 <20230201004852.GB30104@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-Version: 1.0
X-CM-TRANSID: GxC2BwBnNl3+lNtjGVTnAA--.14834S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGw4rWw4DXFWxCryUCF1xXwb_yoW5CFW8pF
 WagayYkr1DKFs2yw1vy3WSqayYv395Ja1UJr98tryUAa15ur1UZF43Ka4Y93W7ur1kZ34Y
 vF42vr9rAF1UCaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
 AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
 x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
 0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
 64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
 8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
 2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
 xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
 6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFDGOUUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAQBF1jj4RztQAEsh
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 06 Feb 2023 07:38:31 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2023-01-31 at 16:48 -0800, Fan Wu wrote:
> On Tue, Jan 31, 2023 at 03:22:05PM +0100, Roberto Sassu wrote:
> > On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > > IPE has two known gaps:
> > > 
> > > 1. IPE cannot verify the integrity of anonymous executable memory, such as
> > >   the trampolines created by gcc closures and libffi (<3.4.2), or JIT'd code.
> > >   Unfortunately, as this is dynamically generated code, there is no way
> > >   for IPE to ensure the integrity of this code to form a trust basis. In all
> > >   cases, the return result for these operations will be whatever the admin
> > >   configures the DEFAULT action for "EXECUTE".
> > 
> > I think it would be useful to handle special cases, for example you
> > could allow a process that created a file with memfd to use it, at the
> > condition that nobody else writes it.
> > 
> > This would be required during the boot, otherwise services could fail
> > to start (depending on the policy).
> > 
> Thanks for the suggestion. I agree with your opinion and I think supporting
> memfd is possible but restricting read/write needs more hooks. We would like
> to avoid adding more complexity to this initial posting as necessary. 
> We will consider this as a future work and will post follow-on patches
> in the future.

Ok, maybe it is necessary to specify better the scope of IPE, why the
current implementation can be considered as complete.

If we say, IPE can only allow/deny operations on system components with
immutable security properties, clearly memfd as a component cannot
fullfill this goal due to the non-immutability. This would apply to any
component allowing modifications.

How to address this? What is the immutable property then?

In the case of memfd, intuitively, a useful property for integrity
could be for example that the content can be accessed/modified by only
one process. No other (possibly malicious) processes can tamper with
that file.

So, it is true, to make this property immutable more hooks are needed.
But should it be something that IPE does? Or it should be done by an
external component (another LSM) that does the enforcement and reports
to IPE that the property is true? Theoretically (with a proper policy),
existing LSMs could be used for that purpose too.

I would say more the second, it should not be IPE job, so that IPE can
exclusively focus on evaluating properties, not making sure that the
properties are immutable.

Roberto

> -Fan
> 
> > > 2. IPE cannot verify the integrity of interpreted languages' programs when
> > >   these scripts invoked via ``<interpreter> <file>``. This is because the
> > >   way interpreters execute these files, the scripts themselves are not
> > >   evaluated as executable code through one of IPE's hooks. Interpreters
> > >   can be enlightened to the usage of IPE by trying to mmap a file into
> > >   executable memory (+X), after opening the file and responding to the
> > >   error code appropriately. This also applies to included files, or high
> > >   value files, such as configuration files of critical system components.
> > 
> > Ok, it is a well known issue. Hopefully, it will be fixed soon.
> > 
> > Roberto
> > 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

