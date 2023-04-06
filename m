Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6081C76196
	for <dm-devel@archiver.kernel.org>; Thu,  6 Apr 2023 19:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680808820;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mcncbN4vd4z02IOpj5A/mHaxrSrqX1uMeUdqojMwGA8=;
	b=SkMVMuugV5UFQn9yilSAHOEnXo0IFufIH9P8baYMHKDptsgmcU3NHVmEvE+pse4i6ql9p6
	/7LkZP3cHeWPbfhKoqL++nrN3MGpRCc1/bTdGuLBEmARHGTe/UWPpy5T6rFjsh+HFB0Bkq
	Lep0mEbloRcN6xtnrt3HyudsyMYqss8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-NfMq1bIdMOq-cT6X9-klMw-1; Thu, 06 Apr 2023 15:20:19 -0400
X-MC-Unique: NfMq1bIdMOq-cT6X9-klMw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1DC588646A;
	Thu,  6 Apr 2023 19:20:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 481401415117;
	Thu,  6 Apr 2023 19:20:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 008451946595;
	Thu,  6 Apr 2023 19:20:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 396901946587
 for <dm-devel@listman.corp.redhat.com>; Thu,  6 Apr 2023 19:20:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2BBDFC1602C; Thu,  6 Apr 2023 19:20:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 24ABAC1602B
 for <dm-devel@redhat.com>; Thu,  6 Apr 2023 19:20:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08AC3886461
 for <dm-devel@redhat.com>; Thu,  6 Apr 2023 19:20:13 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-215-qE6DOV8MM3CZ1BzHm2yOiA-1; Thu,
 06 Apr 2023 15:20:09 -0400
X-MC-Unique: qE6DOV8MM3CZ1BzHm2yOiA-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id EE920210DF13; Thu,  6 Apr 2023 12:20:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EE920210DF13
Date: Thu, 6 Apr 2023 12:20:07 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20230406192007.GA19196@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-2-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhTtXC=HMUF8uak-29E__xLN2Kh_znn0xdRbm-GkgqBNiA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhTtXC=HMUF8uak-29E__xLN2Kh_znn0xdRbm-GkgqBNiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [RFC PATCH v9 01/16] security: add ipe lsm
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 02, 2023 at 02:00:48PM -0500, Paul Moore wrote:
> On Mon, Jan 30, 2023 at 5:58???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 8a5c25c20d00..5e27e84763cc 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -10273,6 +10273,11 @@ T:     git git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
> >  F:     security/integrity/ima/
> >  F:     security/integrity/
> >
> > +INTEGRITY POLICY ENFORCEMENT (IPE)
> > +M:     Fan Wu <wufan@linux.microsoft.com>
> > +S:     Supported
> > +F:     security/ipe/
> 
> You should probably add a mailing list (L:) and source tree URL (T:)
> to the IPE entry.  You can use the LSM mailing list to start if you
> like, there are several LSMs that do that today, e.g. Smack, Landlock,
> etc.  As far as the source tree is concerned, probably the easiest
> option is a simple GitHub repo, but there are plenty of other choices
> too.
> 
> Both the mailing list and the source URLs can always be updated in the
> future so don't worry too much about being stuck with either long
> term.
> 
> --
> paul-moore.com

We do have a github repo, I will add that link in the next version.

-Fan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

