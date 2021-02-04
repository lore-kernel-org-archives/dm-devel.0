Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C0D9C433E0
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 15:07:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0672764F43
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 15:07:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0672764F43
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-aPIZNenUOlOuKPP7z3lSww-1; Thu, 04 Feb 2021 10:06:57 -0500
X-MC-Unique: aPIZNenUOlOuKPP7z3lSww-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFBB26D4E3;
	Thu,  4 Feb 2021 15:06:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8628460BE2;
	Thu,  4 Feb 2021 15:06:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C5CB618095CB;
	Thu,  4 Feb 2021 15:06:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 114F6mHw005040 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Feb 2021 10:06:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8229A103CC3; Thu,  4 Feb 2021 15:06:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D1BD103CBE
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 15:06:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF48A185A797
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 15:06:45 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-559-yp07a7jnP-6v4Zk5y8PQ0w-1;
	Thu, 04 Feb 2021 10:06:38 -0500
X-MC-Unique: yp07a7jnP-6v4Zk5y8PQ0w-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 52417ACB7;
	Thu,  4 Feb 2021 15:06:37 +0000 (UTC)
Message-ID: <57ec651871345e3aae745ba3a75c5f1e59bc25ef.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 04 Feb 2021 16:06:36 +0100
In-Reply-To: <45fe03c8-1cc0-4318-ae84-698959667a6b@huawei.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
	<dcc6fb2a344ce75972242e2c78e2e485b58140da.camel@suse.com>
	<45fe03c8-1cc0-4318-ae84-698959667a6b@huawei.com>
User-Agent: Evolution 3.38.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] multipathd: avoid crash in uevent_cleanup()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2021-02-04 at 09:40 +0800, lixiaokeng wrote:
> 
> 
> On 2021/2/3 21:57, Martin Wilck wrote:
> > > If exit() before all pthread_cancel in child of 0.7.7, there is
> > > no
> > > any crash.
> > What do you mean with "exit() before all pthread_cancel"? If this
> > happens on pthread_cancel(), and you don't call that function, this
> > would actually be expected.
> 
> When running_state is DAEMON_SHUTDOWN, break while then _exit(0). But
> is is not a great method.

I wonder if it would be possible to figure out the LWP numbers (process
IDs) of the different threads before the crash occurs, and compare this
to the gdb output

(gdb) info threads
  Id   Target Id         Frame
* 1    LWP 1997690       0x00007f59a0109647 in ?? ()
  2    LWP 1996840       0x00007f59a0531de7 in ?? ()
  3    LWP 1997692       0x00007f59a0109647 in ?? ()
  4    LWP 1996857       0x00007f59a020d169 in ?? ()

... to identify which thread crashed, and if it's always the same one.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

