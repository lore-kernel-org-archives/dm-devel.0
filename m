Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C13C636CC
	for <dm-devel@archiver.kernel.org>; Wed,  8 Feb 2023 00:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675816276;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5ii966dY69QGh6DdKiPli/zPgBjOac3u+HAqZNPjYCc=;
	b=BOZ8tHXtENR/xhEwMOaHVFdZ1/LzwEUOAw9rEFM7jiK8KW80w6VLPwTO1rNUWsEe3A49j7
	0JPkjRCPXwFzTNES8Iybug5Pq0ajTrbDO+knEyuL6Aog86mIQdwrx7G2WvzWeXpbRh78AL
	03HLEl0sOUmsejH5lEHV9ZG46O2O71M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-R1h7JEk2M2eNaaKOjJ4_VQ-1; Tue, 07 Feb 2023 19:31:13 -0500
X-MC-Unique: R1h7JEk2M2eNaaKOjJ4_VQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A64685CCE0;
	Wed,  8 Feb 2023 00:31:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4BD4B35453;
	Wed,  8 Feb 2023 00:31:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F299A194658D;
	Wed,  8 Feb 2023 00:31:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 852511946589
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Feb 2023 00:31:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 74448492B22; Wed,  8 Feb 2023 00:31:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B629492B21
 for <dm-devel@redhat.com>; Wed,  8 Feb 2023 00:31:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E1F985CCE1
 for <dm-devel@redhat.com>; Wed,  8 Feb 2023 00:31:08 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-159-ltToBvASOAC6L0hyr-QZpQ-1; Tue,
 07 Feb 2023 19:31:04 -0500
X-MC-Unique: ltToBvASOAC6L0hyr-QZpQ-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 91E3120C7E38; Tue,  7 Feb 2023 16:31:03 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 91E3120C7E38
Date: Tue, 7 Feb 2023 16:31:03 -0800
From: Fan Wu <wufan@linux.microsoft.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Message-ID: <20230208003103.GC5107@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <033335b26f6becdc3dc0325ef926efd94fcc4dda.camel@huaweicloud.com>
 <20230201004852.GB30104@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <7dc9963c563d0b55bb35109be012e355eef13882.camel@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <7dc9963c563d0b55bb35109be012e355eef13882.camel@huaweicloud.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 02, 2023 at 11:48:18AM +0100, Roberto Sassu wrote:
> On Tue, 2023-01-31 at 16:48 -0800, Fan Wu wrote:
> > On Tue, Jan 31, 2023 at 03:22:05PM +0100, Roberto Sassu wrote:
> > > On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > > > IPE has two known gaps:
> > > > 
> > > > 1. IPE cannot verify the integrity of anonymous executable memory, such as
> > > >   the trampolines created by gcc closures and libffi (<3.4.2), or JIT'd code.
> > > >   Unfortunately, as this is dynamically generated code, there is no way
> > > >   for IPE to ensure the integrity of this code to form a trust basis. In all
> > > >   cases, the return result for these operations will be whatever the admin
> > > >   configures the DEFAULT action for "EXECUTE".
> > > 
> > > I think it would be useful to handle special cases, for example you
> > > could allow a process that created a file with memfd to use it, at the
> > > condition that nobody else writes it.
> > > 
> > > This would be required during the boot, otherwise services could fail
> > > to start (depending on the policy).
> > > 
> > Thanks for the suggestion. I agree with your opinion and I think supporting
> > memfd is possible but restricting read/write needs more hooks. We would like
> > to avoid adding more complexity to this initial posting as necessary. 
> > We will consider this as a future work and will post follow-on patches
> > in the future.
> 
> Ok, maybe it is necessary to specify better the scope of IPE, why the
> current implementation can be considered as complete.
> 
> If we say, IPE can only allow/deny operations on system components with
> immutable security properties, clearly memfd as a component cannot
> fullfill this goal due to the non-immutability. This would apply to any
> component allowing modifications.
> 
> How to address this? What is the immutable property then?
> 
> In the case of memfd, intuitively, a useful property for integrity
> could be for example that the content can be accessed/modified by only
> one process. No other (possibly malicious) processes can tamper with
> that file.
> 
> So, it is true, to make this property immutable more hooks are needed.
> But should it be something that IPE does? Or it should be done by an
> external component (another LSM) that does the enforcement and reports
> to IPE that the property is true? Theoretically (with a proper policy),
> existing LSMs could be used for that purpose too.
> 
> I would say more the second, it should not be IPE job, so that IPE can
> exclusively focus on evaluating properties, not making sure that the
> properties are immutable.
> 
> Roberto
> 
I think the issue here is not about the scope of IPE but the use cases
of IPE. 

We use IPE on fixed-function devices, which are completely locked down.
In our system, IPE denies all anonymous memory execution so memfd will
not work on our system.

Therefore, to make memfd useable with IPE we must add more properties.

-Fan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

