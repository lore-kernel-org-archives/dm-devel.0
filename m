Return-Path: <SRS0=bAPj=HL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE78FC433DB
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 01:36:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EB64A64E66
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 01:36:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB64A64E66
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-aa7z6lDMM6auCdeKEQhD3Q-1; Mon, 08 Feb 2021 20:36:54 -0500
X-MC-Unique: aa7z6lDMM6auCdeKEQhD3Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A05DD19611A7;
	Tue,  9 Feb 2021 01:36:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1149B10013D7;
	Tue,  9 Feb 2021 01:36:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A2B9458074;
	Tue,  9 Feb 2021 01:36:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1191aXPr002242 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Feb 2021 20:36:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 552CE2166B2B; Tue,  9 Feb 2021 01:36:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 500172166B2A
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 01:36:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAD89800BFF
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 01:36:30 +0000 (UTC)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-181-AsEonUdsObWO2mj4mma35A-1; Mon, 08 Feb 2021 20:36:25 -0500
X-MC-Unique: AsEonUdsObWO2mj4mma35A-1
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DZQS250xMz7j8r;
	Tue,  9 Feb 2021 09:34:58 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server
	id 14.3.498.0; Tue, 9 Feb 2021 09:36:16 +0800
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
	<15415073-3b0b-c5a3-ec1d-ced704a42a86@huawei.com>
	<05408634d2361998782d80b34b7de64d452ba09c.camel@suse.com>
	<6c80ccbe-0c35-aef8-e95b-97acd06a3487@huawei.com>
	<7b2c571eb7ff9d54c51037a4fae87796ead1144e.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <3c8f215a-75d5-0f7b-1008-c8c565bb0cf3@huawei.com>
Date: Tue, 9 Feb 2021 09:36:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7b2c571eb7ff9d54c51037a4fae87796ead1144e.camel@suse.com>
X-Originating-IP: [10.174.178.113]
X-CFilter-Loop: Reflected
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


> 
> I still don't fully understand. Above you said "this coredump doesn't
> seem to appear any more". Am I understanding correctly that you
> observed *other* core dumps instead?
> 

No, it is not "instead".
As shown in https://www.spinics.net/lists/dm-devel/msg45293.html,
there are some different crashes in multipathd with no code change.
When blocking of thread cancellation during udev_monitor_receive_device(),
no crash in udev_monitor_receive_device happens but others still
exist.

> 
> The "best" solution would probably be to generally disallow
> cancellation, and only run pthread_testcancel() at certain points in
> the code where we might block (and know that being cancelled would be
> safe). That would not only make multipathd safer from crashing, it
> would also enable us to remove hundreds of ugly
> pthread_cleanup_push()/pop() calls from our code.
> 
> Finding all these points would be a challenge though, and if we don't
> find them, we risk hanging on exit again, which is bad too, and was
> just recently improved.

Do you mean some patches have been made to solve these problem?

Regards,
Lixiaokeng

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

