Return-Path: <SRS0=f+1/=ER=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 668E2C5517A
	for <dm-devel@archiver.kernel.org>; Wed, 11 Nov 2020 15:24:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C33FE206FB
	for <dm-devel@archiver.kernel.org>; Wed, 11 Nov 2020 15:24:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cl/7vISn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C33FE206FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1605108292;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sHc5UTLxTKSNC2nbNPB3H19BzravmRd33MI0aisQhM8=;
	b=Cl/7vISnjfJ/SGknFdWrV/iQJa1B8TnWZBduiWguAhtnbCTxxFU6XzATQc8IUuxp9WDlne
	YI6ED9jJXtT9vn1v4xBZ8vWOjbFv3C5SSsgYiWLDOC0XiSR4Z9WBPwrQFdzj/mjq75NhfT
	CipEn6WTqWE+YgoKiy0YoowTtviZmC4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-KisRneTmPAu23oc0g-Qjbw-1; Wed, 11 Nov 2020 10:24:50 -0500
X-MC-Unique: KisRneTmPAu23oc0g-Qjbw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC95B809DDB;
	Wed, 11 Nov 2020 15:24:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 96603100238E;
	Wed, 11 Nov 2020 15:24:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 417AB5810C;
	Wed, 11 Nov 2020 15:24:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ABFOeGv023985 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 11 Nov 2020 10:24:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4800E7366D; Wed, 11 Nov 2020 15:24:40 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 368D67366F;
	Wed, 11 Nov 2020 15:24:37 +0000 (UTC)
Date: Wed, 11 Nov 2020 10:24:36 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Colin Ian King <colin.king@canonical.com>,
	Mike Christie <michael.christie@oracle.com>
Message-ID: <20201111152436.GA22834@redhat.com>
References: <c5c17cba-3bf2-ce07-ed7f-6e5b5e71427c@canonical.com>
MIME-Version: 1.0
In-Reply-To: <c5c17cba-3bf2-ce07-ed7f-6e5b5e71427c@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] dm: rename multipath path selector source files to
 have "dm-ps" prefix
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 11 2020 at  6:45am -0500,
Colin Ian King <colin.king@canonical.com> wrote:

> Hi,
> 
> Static analysis on linux-next has detected an initialized variable issue
> with the following recent commit:
> 
> commit 28784347451fdbf4671ba97018f816041ba2306a
> Author: Mike Snitzer <snitzer@redhat.com>
> Date:   Tue Nov 10 13:41:53 2020 -0500
> 
>     dm: rename multipath path selector source files to have "dm-ps" prefix
> 
> The analysis is as follows:
> 
>  43
> static int ioa_add_path(struct path_selector *ps, struct dm_path *path,
>  44                        int argc, char **argv, char **error)
>  45 {
>  46        struct selector *s = ps->context;
>  47        struct path_info *pi = NULL;
>    1. var_decl: Declaring variable cpu without initializer.
> 
>  48        unsigned int cpu;
>  49        int ret;
>  50
>    2. Condition argc != 1, taking false branch.
> 
>  51        if (argc != 1) {
>  52                *error = "io-affinity ps: invalid number of arguments";
>  53                return -EINVAL;
>  54        }
>  55
> 
>    Uninitialized scalar variable (UNINIT)
>    3. uninit_use_in_call: Using uninitialized value cpu when calling
> __cpu_to_node.
> 
>  56        pi = kzalloc_node(sizeof(*pi), GFP_KERNEL, cpu_to_node(cpu));
>  57        if (!pi) {
>  58                *error = "io-affinity ps: Error allocating path context";
>  59                return -ENOMEM;
>  60        }

Valid report, but it focuses on a follow-on commit that is just noise.
The commit "dm mpath: add IO affinity path selector" is what is in
quesation, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.11&id=c3d0a31e609e299836fa6ced28cb9ec06b408181

Regardless, Mike Christie, Colin's report has identified a bug.

Please advise on how you'd like to fix ioa_add_path()'s allocation of
'struct path_info'.. pretty sure 'cpu' will default to 0 (on stack)
despite no explicit initialization... so code "works" but does not
do so with a specific cpu allocation affinity.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

