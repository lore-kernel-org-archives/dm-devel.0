Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8A97C74A5B
	for <dm-devel@archiver.kernel.org>; Fri, 17 Mar 2023 14:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679065031;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7XmonG/Tu96e2FS9h05qmAgNCTzE8ANpM4YYs0mrPPk=;
	b=DWH/rHAAE0uYSS4+SRKmoMyQyEIXKm2h4LsIlekO+bpo0DkrY4eQVDNReZXi8p89XTpeIj
	maLIvIDRTVe9tE4O8BzeC31xQTBnOKcGRWb8RrzdaHJvkm+/DJpbuIVyTJ4Aja2gyo4JS9
	iz/MJT8CsZbMUvq11uktYB6ZeIG34z0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-8VNPAChxMgyrv7yLIcyuMg-1; Fri, 17 Mar 2023 10:57:09 -0400
X-MC-Unique: 8VNPAChxMgyrv7yLIcyuMg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53CCD3855585;
	Fri, 17 Mar 2023 14:57:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 400921121319;
	Fri, 17 Mar 2023 14:57:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 10F871946597;
	Fri, 17 Mar 2023 14:57:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 793E31946597
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Mar 2023 22:53:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6A21640CFD42; Thu, 16 Mar 2023 22:53:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6361440CFD40
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 22:53:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4966D811E7D
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 22:53:46 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-640-b5Aq0cvsMiKrH-gkwn42Dg-1; Thu,
 16 Mar 2023 18:53:42 -0400
X-MC-Unique: b5Aq0cvsMiKrH-gkwn42Dg-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id EC6622057035; Thu, 16 Mar 2023 15:53:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EC6622057035
Date: Thu, 16 Mar 2023 15:53:40 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20230316225340.GB22567@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-8-git-send-email-wufan@linux.microsoft.com>
 <3723852.kQq0lBPeGt@x2>
 <CAHC9VhRqMrTuvVtwzJoK2U=6O1QuaQ8ceA6+qm=6ib0TOUEeSw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhRqMrTuvVtwzJoK2U=6O1QuaQ8ceA6+qm=6ib0TOUEeSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [RFC PATCH v9 07/16] uapi|audit|ipe: add ipe
 auditing support
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
Cc: axboe@kernel.dk, linux-security-module@vger.kernel.org, tytso@mit.edu,
 corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 snitzer@kernel.org, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org, dm-devel@redhat.com,
 linux-audit@redhat.com, linux-block@vger.kernel.org, eparis@redhat.com,
 linux-fscrypt@vger.kernel.org, Steve Grubb <sgrubb@redhat.com>,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 02, 2023 at 02:05:33PM -0500, Paul Moore wrote:
> On Tue, Jan 31, 2023 at 12:11???PM Steve Grubb <sgrubb@redhat.com> wrote:
> >
> > Hello,
> >
> > On Monday, January 30, 2023 5:57:22 PM EST Fan Wu wrote:
> > > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > >
> > > Users of IPE require a way to identify when and why an operation fails,
> > > allowing them to both respond to violations of policy and be notified
> > > of potentially malicious actions on their systens with respect to IPE
> > > itself.
> > >
> > > The new 1420 audit, AUDIT_IPE_ACCESS indicates the result of a policy
> > > evaulation of a resource. The other two events, AUDIT_MAC_POLICY_LOAD,
> > > and AUDIT_MAC_CONFIG_CHANGE represent a new policy was loaded into the
> > > kernel and the currently active policy changed, respectively.
> >
> > Typically when you reuse an existing record type, it is expected to maintain
> > the same fields in the same order. Also, it is expect that fields that are
> > common across diferent records have the same meaning. To aid in this, we have
> > a field dictionary here:
> >
> > https://github.com/linux-audit/audit-documentation/blob/main/specs/fields/
> > field-dictionary.csv
> >
> > For example, dev is expected to be 2 hex numbers separated by a colon which
> > are the device major and minor numbers. But down a couple lines from here, we
> > find dev="tmpfs". But isn't that a filesystem type?
> 
> What Steve said.
> 
> I'll also add an administrative note, we just moved upstream Linux
> audit development to a new mailing list, audit@vger.kernel.org, please
> use that in future patch submissions.  As a positive, it's a fully
> open list so you won't run into moderation delays/notifications/etc.
> 
Thanks for the info, I will update the address.

> > > This patch also adds support for success auditing, allowing users to
> > > identify how a resource passed policy. It is recommended to use this
> > > option with caution, as it is quite noisy.
> > >
> > > This patch adds the following audit records:
> > >
> > >   audit: AUDIT1420 path="/tmp/tmpwxmam366/deny/bin/hello" dev="tmpfs"
> > >     ino=72 rule="DEFAULT op=EXECUTE action=DENY"
> >
> > Do we really need to log the whole rule?
> 
> Fan, would it be reasonable to list the properties which caused the
> access denial?  That seems like it might be more helpful than the
> specific rule, or am I missing something?
> 
Audit the whole rule can let the user find the reason of a policy decision.
We need the whole rule because an allow/block is not caused by a specific
property, but the combination of all property conditions in a rule.

We could also add a verbose switch such that we only audit
the whole rule when a user turned the verbose switch on. 

-Fan

> paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

