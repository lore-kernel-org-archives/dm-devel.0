Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C0ADC77B7A
	for <dm-devel@archiver.kernel.org>; Mon, 17 Apr 2023 18:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681754776;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=P9chVNwG0G3+AyarvZtZceAtpGtpgv6c5TlC8nx1TTQ=;
	b=HKwt5KWHsy4yOwJ69ZKm7IyAUAUrtLNUrtABtnVq1SVCJXkLR6F1v88XBW3e6NB2ky6jrK
	1APLVA67kFqmrUilPv7T96HRIqlok/VYRqTpZtWMeQ76Q1fY/84UJpGTobmi/GMfT3WYY8
	MJ6N2B543de+5tH+3/HwVtm9jeanZhU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-VBc8fnnGONCsRYncptQqXw-1; Mon, 17 Apr 2023 14:06:14 -0400
X-MC-Unique: VBc8fnnGONCsRYncptQqXw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 605E488B7A1;
	Mon, 17 Apr 2023 18:06:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0FDA351FF;
	Mon, 17 Apr 2023 18:06:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C8AD9194658D;
	Mon, 17 Apr 2023 18:06:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EA6451946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 17 Apr 2023 18:06:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D8D532A68; Mon, 17 Apr 2023 18:06:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D1EB647CD0
 for <dm-devel@redhat.com>; Mon, 17 Apr 2023 18:06:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B393238173C4
 for <dm-devel@redhat.com>; Mon, 17 Apr 2023 18:06:10 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-635-ukzYfyPoNAezvegZUFROQA-1; Mon,
 17 Apr 2023 14:06:07 -0400
X-MC-Unique: ukzYfyPoNAezvegZUFROQA-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 627AA21C1E42; Mon, 17 Apr 2023 11:06:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 627AA21C1E42
Date: Mon, 17 Apr 2023 11:06:05 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20230417180605.GA402@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRa+NwKzLfQBmHfMgUp6_d5soQG7JBq-Vn=MUeUAt4tuQ@mail.gmail.com>
 <20230410191035.GB18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhQDvWDshaZvJrHmjcwyHFxv9oYTN9bn0xiTtFZQRp+GPg@mail.gmail.com>
 <20230412233606.GA16658@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhTs3Njfg=1baQ6=58rPLBmyB3cW0R-MfAaEcRF-jAaYBw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhTs3Njfg=1baQ6=58rPLBmyB3cW0R-MfAaEcRF-jAaYBw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Apr 13, 2023 at 02:45:07PM -0400, Paul Moore wrote:
> On Wed, Apr 12, 2023 at 7:36???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > On Tue, Apr 11, 2023 at 05:45:41PM -0400, Paul Moore wrote:
> > > On Mon, Apr 10, 2023 at 3:10???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > > > On Thu, Mar 02, 2023 at 02:04:42PM -0500, Paul Moore wrote:
> > > > > On Mon, Jan 30, 2023 at 5:58???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> ...
> 
> > > I guess this does make me wonder about keeping a non-active policy
> > > loaded in the kernel, what purpose does that serve?
> > >
> >
> > The non-active policy doesn't serve anything unless it is activated. User can
> > even delete a policy if that is no longer needed. Non-active is just the default
> > state when a new policy is loaded.
> >
> > If IPE supports namespace, there is another use case where different containers
> > can select different policies as the active policy from among multiple loaded
> > policies. Deven has presented a demo of this during LSS 2021. But this goes
> > beyond the scope of this version.
> 
> Do you plan to add namespace support at some point in the
> not-too-distant future?  If so, I'm okay with keeping support for
> multiple policies, but if you think you're only going to support one
> active policy at a time, it might be better to remove support for
> multiple (inactive) policies.
> 
> -- 
> paul-moore.com

Another benefit of having multiple policies is that it provides isolation
between different policies. For instance, if we have two policies named
"policy_a" and "policy_b," we can ensure that only team a can update "policy_a,"
and only team b can update "policy_b." This way, both teams can update
their policy without affecting others. However, if there is only one policy
in the system, both teams will have to operate on the same policy, making it
less manageable.

Besides, removing multiple (inactive) policies support will
render the policy_name field meaningless, and we should only audit the policy
hash. I am fine if we decide to go for the single policy option.

-Fan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

