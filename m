Return-Path: <SRS0=tECb=HA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 156AFC433E0
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 10:54:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3A10D64E15
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 10:54:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A10D64E15
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-Vqxp1LIuMEqirQO0WQPK0g-1; Fri, 29 Jan 2021 05:54:09 -0500
X-MC-Unique: Vqxp1LIuMEqirQO0WQPK0g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC204107ACE3;
	Fri, 29 Jan 2021 10:54:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DD91E271A2;
	Fri, 29 Jan 2021 10:54:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5792B4A7C7;
	Fri, 29 Jan 2021 10:54:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10TArkAl006724 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Jan 2021 05:53:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 210F910FF22; Fri, 29 Jan 2021 10:53:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B6EE10FF3B
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 10:53:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BAA7858284
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 10:53:43 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-570-Yg_sQjWrP3CXbu6Sdxxv5Q-1;
	Fri, 29 Jan 2021 05:53:40 -0500
X-MC-Unique: Yg_sQjWrP3CXbu6Sdxxv5Q-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id C825DACBA
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 10:40:08 +0000 (UTC)
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
From: Coly Li <colyli@suse.de>
Message-ID: <41f1923b-8f45-ff49-e0d9-06bc5a4a6fad@suse.de>
Date: Fri, 29 Jan 2021 18:40:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
	Gecko/20100101 Thunderbird/78.6.1
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
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10TArkAl006724
X-loop: dm-devel@redhat.com
Subject: [dm-devel] dm thin-volume hung as swap: bug or as-design ?
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi folks,

Recently I receive a report that whole system hung and no response after
a while with I/O load. The special configuration is the dm thin-pool
volume is used as the swap partition of the system.

>From the crash dump, I find one task is suspicious which looks as following,

PID: 462    TASK: ffff93033d74a680  CPU: 7   COMMAND: "kworker/u256:1"
 #0 [ffffb24b4d9c3710] __schedule at ffffffff9e29dc3d
 #1 [ffffb24b4d9c37a0] schedule at ffffffff9e29e0bf
 #2 [ffffb24b4d9c37b0] schedule_timeout at ffffffff9e2a179d
 #3 [ffffb24b4d9c3828] wait_for_completion at ffffffff9e29eaaa
 #4 [ffffb24b4d9c3878] __flush_work at ffffffff9dabb277
 #5 [ffffb24b4d9c38f0] drain_all_pages at ffffffff9dc74e05
 #6 [ffffb24b4d9c3920] __alloc_pages_slowpath at ffffffff9dc77279
 #7 [ffffb24b4d9c3a20] __alloc_pages_nodemask at ffffffff9dc77e41
 #8 [ffffb24b4d9c3a80] new_slab at ffffffff9dc99c1a
 #9 [ffffb24b4d9c3ae8] ___slab_alloc at ffffffff9dc9c6d9
#10 [ffffb24b4d9c3b40] exit_shadow_spine at ffffffffc08ef8cf
[dm_persistent_data]
#11 [ffffb24b4d9c3b50] insert at ffffffffc08edfcc [dm_persistent_data]
#12 [ffffb24b4d9c3c30] sm_ll_mutate at ffffffffc08ea20e [dm_persistent_data]
#13 [ffffb24b4d9c3cd8] dm_kcopyd_zero at ffffffffc03f7a39 [dm_mod]
#14 [ffffb24b4d9c3ce8] schedule_zero at ffffffffc093d181 [dm_thin_pool]
#15 [ffffb24b4d9c3d40] process_cell at ffffffffc093d78c [dm_thin_pool]
#16 [ffffb24b4d9c3dc8] do_worker at ffffffffc093dce6 [dm_thin_pool]
#17 [ffffb24b4d9c3e98] process_one_work at ffffffff9daba4d4
#18 [ffffb24b4d9c3ed8] worker_thread at ffffffff9daba6ed
#19 [ffffb24b4d9c3f10] kthread at ffffffff9dac0a2d
#20 [ffffb24b4d9c3f50] ret_from_fork at ffffffff9e400202

This task is writing on a thin-pool volume which is mounted as swap
partition in the system. This is very suspicious, because I see the
dm-thin code, all memory allocation inside from dm-thin code has
explicity GFP_NOIO/GFP_NOFS or implict memalloc_noio_save(), in order to
avoid deadlock in recursive memory reclaim code path.

I do many testings, and confirm such issue can be reproduced in latest
upstream Linux v5.11-rc5+ kernel. If I create two thin-pool volumes, one
is mounted as swap, one is written by heavy I/O pressure. If anonymous
pages swapping happens on the first thin-pool volume while I/O hitting
on second thin-pool, after around 3 minutes the whole system gets hung
and no any response and kernel information for 1 hour+ before I reset
the machine.

My questions are,
- Can a thin-pool volume be used as swap device?
- The above description is a bug, or an already know issue which should
be avoided ?

Thanks in advance.

Coly Li


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

