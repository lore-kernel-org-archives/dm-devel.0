Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2874C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 12 Jan 2022 06:24:38 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-ci9pDSYpNTe3ntnhClEx5g-1; Wed, 12 Jan 2022 01:24:34 -0500
X-MC-Unique: ci9pDSYpNTe3ntnhClEx5g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C646C100C629;
	Wed, 12 Jan 2022 06:24:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E47C7108BF;
	Wed, 12 Jan 2022 06:24:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9D4651809CB8;
	Wed, 12 Jan 2022 06:24:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20BCYngr014955 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 11 Jan 2022 07:34:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6899853BB; Tue, 11 Jan 2022 12:34:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6338053B3
	for <dm-devel@redhat.com>; Tue, 11 Jan 2022 12:34:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CE803800509
	for <dm-devel@redhat.com>; Tue, 11 Jan 2022 12:34:46 +0000 (UTC)
Received: from lb1.peda.net (peda.net [130.234.6.152]) by relay.mimecast.com
	with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-231-IMj02tjmPXqporGTzJUUqA-1; Tue, 11 Jan 2022 07:34:41 -0500
X-MC-Unique: IMj02tjmPXqporGTzJUUqA-1
Received: from [84.251.221.37] (dsl-jklbng12-54fbdd-37.dhcp.inet.fi
	[84.251.221.37])
	by lb1.peda.net (Postfix) with ESMTPSA id DC1C2600008;
	Tue, 11 Jan 2022 14:25:04 +0200 (EET)
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, song@kernel.org
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
From: Mikko Rantalainen <mikko.rantalainen@peda.net>
Message-ID: <a238949b-f8e2-fc6a-fecc-99df8ec6292a@peda.net>
Date: Tue, 11 Jan 2022 14:25:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 12 Jan 2022 01:22:58 -0500
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, snitzer@redhat.com,
	agk@redhat.com
Subject: Re: [dm-devel] [PATCH V2] md: don't unregister sync_thread with
 reconfig_mutex held
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Guoqing Jiang (2021-02-13 02:49 Europe/Helsinki):
> Unregister sync_thread doesn't need to hold reconfig_mutex since it
> doesn't reconfigure array.
> 
> And it could cause deadlock problem for raid5 as follows:
> 
> 1. process A tried to reap sync thread with reconfig_mutex held after echo
>    idle to sync_action.
> 2. raid5 sync thread was blocked if there were too many active stripes.
> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
>    which causes the number of active stripes can't be decreased.
> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
>    to hold reconfig_mutex.
> 
> More details in the link:
> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t

I don't understand md well enough to suggest a patch but isn't this
logically a classic two lock deadlock problem where

thread 1:
- lock reconfig_mutex
- blocked for sync that requires SB_CHANGE_PENDING

thread 2:
- (logically) acquire lock SB_CHANGE_PENDING
- blocked for reconfig_mutex before SB_CHANGE_PENDING can be released

?

The classic fix for this kind of deadlock is to require these locks to
be always acquired in constant order and released in reverse order.

If you had a rule that SB_CHANGE_PENDING cannot be set or cleared
without already having reconfig_mutex, wouldn't that prevent this
deadlock? (If I understood the issue correctly, it's currently possible
to set but not clear the SB_CHANGE_PENDING without having reconfig_mutex.)

Another possibility is to expect SB_CHANGE_PENDING to be set as part of
sync process required change to "idle" (write to sync_action). In that
case the logic would be you cannot have reconfig_mutex already locked
before setting (logically acquiring lock) SB_CHANGE_PENDING. So the
transfer from active to idle would require first setting
SB_CHANGE_PENDING, doing the required processing (getting and freeing
reconfig_mutex in process) and then clearing SB_CHANGE_PENDING.
Basically the rule would be you must lock SB_CHANGE_PENDING before you
can lock reconfig_mutex.

If I've understood correctly SB_CHANGE_PENDING is not technically a lock
but it's logically used like it were a lock.

Would either of these make sense for the overall design?

Obviously, if it doesn't hurt the performance too much, using a single
lock for everything that needs to be serialized would be much easier.

-- 
Mikko

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

