Return-Path: <SRS0=AGY1=HV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 478EAC433E0
	for <dm-devel@archiver.kernel.org>; Fri, 19 Feb 2021 01:38:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 06A1C64EC7
	for <dm-devel@archiver.kernel.org>; Fri, 19 Feb 2021 01:38:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 06A1C64EC7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-8rVbWK46PlW4gtHMYAiF7g-1; Thu, 18 Feb 2021 20:37:59 -0500
X-MC-Unique: 8rVbWK46PlW4gtHMYAiF7g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9F77801965;
	Fri, 19 Feb 2021 01:37:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CAC4F5D6AD;
	Fri, 19 Feb 2021 01:37:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3F8F757DFD;
	Fri, 19 Feb 2021 01:37:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11J1bV5d008717 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Feb 2021 20:37:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A532D11FC7E; Fri, 19 Feb 2021 01:37:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FBF311FC73
	for <dm-devel@redhat.com>; Fri, 19 Feb 2021 01:37:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7306D1022F0C
	for <dm-devel@redhat.com>; Fri, 19 Feb 2021 01:37:29 +0000 (UTC)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com
	[45.249.212.190]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-171-qTinyVupM9KhtoYvNtg9cA-1; Thu, 18 Feb 2021 20:37:26 -0500
X-MC-Unique: qTinyVupM9KhtoYvNtg9cA-1
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DhYzy6rBjzlLY7;
	Fri, 19 Feb 2021 09:35:26 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server
	id 14.3.498.0; Fri, 19 Feb 2021 09:37:00 +0800
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
	<15415073-3b0b-c5a3-ec1d-ced704a42a86@huawei.com>
	<05408634d2361998782d80b34b7de64d452ba09c.camel@suse.com>
	<6c80ccbe-0c35-aef8-e95b-97acd06a3487@huawei.com>
	<7b2c571eb7ff9d54c51037a4fae87796ead1144e.camel@suse.com>
	<3c8f215a-75d5-0f7b-1008-c8c565bb0cf3@huawei.com>
	<11c072c152937004e5f08ecff8dd9ded7d915af6.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <139b81ce-e6d7-e386-2666-447ecd2da315@huawei.com>
Date: Fri, 19 Feb 2021 09:36:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <11c072c152937004e5f08ecff8dd9ded7d915af6.camel@suse.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11J1bV5d008717
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>, dm-devel@redhat.com,
	hexiaowen@huawei.com
Subject: Re: [dm-devel] [PATCH] multipathd: avoid crash in uevent_cleanup()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable



On 2021/2/10 1:30, Martin Wilck wrote:
> On Tue, 2021-02-09 at 09:36 +0800, lixiaokeng wrote:
>>
>>>
>>> I still don't fully understand. Above you said "this coredump
>>> doesn't
>>> seem to appear any more". Am I understanding correctly that you
>>> observed *other* core dumps instead?
>=20
>>>
>>
>> No, it is not "instead".
>> As shown in https://www.spinics.net/lists/dm-devel/msg45293.html,
>> there are some different crashes in multipathd with no code change.
>> When blocking of thread cancellation during
>> udev_monitor_receive_device(),
>> no crash in udev_monitor_receive_device happens but others still
>> exist.
>=20
> Now I got it, eventually :-) Thanks for the clarification. Would it be
> ossible for you to categorize the different=A0issues and provide core
> dumps?
>=20
> You mentioned in the systemd issue that you were playing around with
> the gcc -fexceptions flag. As I remarked there - how did it get set in
> the first place? What distro are you using?
>>>
>>> The "best" solution would probably be to generally disallow
>>> cancellation, and only run pthread_testcancel() at certain points
>>> in
>>> the code where we might block (and know that being cancelled would
>>> be
>>> safe). That would not only make multipathd safer from crashing, it
>>> would also enable us to remove hundreds of ugly
>>> pthread_cleanup_push()/pop() calls from our code.
>>>
>>> Finding all these points would be a challenge though, and if we
>>> don't
>>> find them, we risk hanging on exit again, which is bad too, and was
>>> just recently improved.
>>
>> Do you mean some patches have been made to solve these problem?
>=20
> No. I could hack up some, but it will take some time.
>=20
Hi Martin,
    How is this problem going?

Regards
Lixiaokeng


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

