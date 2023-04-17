Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 592D7C77B76
	for <dm-devel@archiver.kernel.org>; Mon, 17 Apr 2023 21:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681766320;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QmgAjd2gmWMJWthoG5Yw5TyfOmjolaYRx+HzIK8Nt1U=;
	b=HYdZPNyIca2peUgq9DMfTb78N9qbguop4qtWrDQEXW6YkudDnO0HIjGAFxW1WGocRX5Tkx
	VKHKfftR/kiGz95EOKpgQTahfn6QheOMEBJB8CE7FYbFmVxSnKR4/HGe5j+0jPUCXGWOJ1
	DTnbjUvX6iRJovaU8YqGx2sHxJ0PZbA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-LcgwfmlsPzKU8x4TUiSuQQ-1; Mon, 17 Apr 2023 17:18:37 -0400
X-MC-Unique: LcgwfmlsPzKU8x4TUiSuQQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6B63887403;
	Mon, 17 Apr 2023 21:18:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0F8A41121314;
	Mon, 17 Apr 2023 21:18:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 94383194658C;
	Mon, 17 Apr 2023 21:18:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2C5E71946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 17 Apr 2023 21:18:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0313B40C20FA; Mon, 17 Apr 2023 21:18:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF78C40C83AC
 for <dm-devel@redhat.com>; Mon, 17 Apr 2023 21:18:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D44AF1C09072
 for <dm-devel@redhat.com>; Mon, 17 Apr 2023 21:18:31 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-50-fZCVH-MjOIu9vMlwX7-4Qw-1; Mon,
 17 Apr 2023 17:18:28 -0400
X-MC-Unique: fZCVH-MjOIu9vMlwX7-4Qw-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id C4C642121EDA; Mon, 17 Apr 2023 14:18:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C4C642121EDA
Date: Mon, 17 Apr 2023 14:18:26 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20230417211826.GA6475@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRa+NwKzLfQBmHfMgUp6_d5soQG7JBq-Vn=MUeUAt4tuQ@mail.gmail.com>
 <20230410191035.GB18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhQDvWDshaZvJrHmjcwyHFxv9oYTN9bn0xiTtFZQRp+GPg@mail.gmail.com>
 <20230412233606.GA16658@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhTs3Njfg=1baQ6=58rPLBmyB3cW0R-MfAaEcRF-jAaYBw@mail.gmail.com>
 <20230417180605.GA402@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhSnKbhtgFxOAY7NYZyOkV4kEA0=mVsCyogLBSCJs0r_ig@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhSnKbhtgFxOAY7NYZyOkV4kEA0=mVsCyogLBSCJs0r_ig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [RFC PATCH v9 05/16] ipe: add userspace interface
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 17, 2023 at 04:16:29PM -0400, Paul Moore wrote:
> On Mon, Apr 17, 2023 at 2:06???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > On Thu, Apr 13, 2023 at 02:45:07PM -0400, Paul Moore wrote:
> > > On Wed, Apr 12, 2023 at 7:36???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > > > On Tue, Apr 11, 2023 at 05:45:41PM -0400, Paul Moore wrote:
> > > > > On Mon, Apr 10, 2023 at 3:10???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > > > > > On Thu, Mar 02, 2023 at 02:04:42PM -0500, Paul Moore wrote:
> > > > > > > On Mon, Jan 30, 2023 at 5:58???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > >
> > > ...
> > >
> > > > > I guess this does make me wonder about keeping a non-active policy
> > > > > loaded in the kernel, what purpose does that serve?
> > > > >
> > > >
> > > > The non-active policy doesn't serve anything unless it is activated. User can
> > > > even delete a policy if that is no longer needed. Non-active is just the default
> > > > state when a new policy is loaded.
> > > >
> > > > If IPE supports namespace, there is another use case where different containers
> > > > can select different policies as the active policy from among multiple loaded
> > > > policies. Deven has presented a demo of this during LSS 2021. But this goes
> > > > beyond the scope of this version.
> > >
> > > Do you plan to add namespace support at some point in the
> > > not-too-distant future?  If so, I'm okay with keeping support for
> > > multiple policies, but if you think you're only going to support one
> > > active policy at a time, it might be better to remove support for
> > > multiple (inactive) policies.
> > >
> > > --
> > > paul-moore.com
> >
> > Another benefit of having multiple policies is that it provides isolation
> > between different policies. For instance, if we have two policies named
> > "policy_a" and "policy_b," we can ensure that only team a can update "policy_a,"
> > and only team b can update "policy_b." This way, both teams can update
> > their policy without affecting others. However, if there is only one policy
> > in the system, both teams will have to operate on the same policy, making it
> > less manageable.
> 
> That only really matters if both policies are active at the same time;
> if only one policy can be active at one point in time the only
> permission that matters is the one who can load/activate a policy.
> 
> Allowing for multiple policies complicates the code.  If there is
> another feature that requires multiple policies, e.g. IPE namespaces,
> then that is okay.  However, if there is no feature which requires
> multiple active policies, supporting multiple loaded policies only
> increases the risk of an exploitable bug in the IPE code.
> 
> > Besides, removing multiple (inactive) policies support will
> > render the policy_name field meaningless, and we should only audit the policy
> > hash. I am fine if we decide to go for the single policy option.
> 
> Once again, I think it comes back to: do you still want to support IPE
> namespaces at some point in the future, and if so, when do you expect
> to work on that?
> 

Yes, absolutely! We definitely have plans to support namespaces in the future.
However, it's worth mentioning that there are other tasks that we may need
to prioritize due to their relatively lower complexity. For example, before
we can fully implement namespaces, we need to address some other important
aspects of the system, such as adding a policy language for integrity
enforcement on configuration files and defining trusted certificates
that can sign the root hash. Therefore, the timeline for implementing
namespaces will depend on the completion time of these tasks.

I understand your concerns, and we can proceed with a single policy design
for the initial version.

-Fan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

