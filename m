Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3A1EC433FE
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 07:48:30 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-NAS27wm7PSGZqw7ZrC7_Aw-1; Wed, 01 Dec 2021 02:48:26 -0500
X-MC-Unique: NAS27wm7PSGZqw7ZrC7_Aw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9697981CCB4;
	Wed,  1 Dec 2021 07:48:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C4EEADCB;
	Wed,  1 Dec 2021 07:48:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 575464CA9B;
	Wed,  1 Dec 2021 07:48:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AUHUwR9009169 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Nov 2021 12:30:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7D4BF401E32; Tue, 30 Nov 2021 17:30:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79A35401E22
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 17:30:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F427811E84
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 17:30:58 +0000 (UTC)
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-270-X_bkNXEgOrSUMkOT4BAP-A-1; Tue, 30 Nov 2021 12:30:56 -0500
X-MC-Unique: X_bkNXEgOrSUMkOT4BAP-A-1
Received: from [192.168.0.2] (ip5f5aeac2.dynamic.kabel-deutschland.de
	[95.90.234.194])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest
	SHA256) (No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 8B1EC61E5FE00;
	Tue, 30 Nov 2021 18:25:06 +0100 (CET)
Message-ID: <a3a1fed7-b886-8603-aa20-20d667a837a7@molgen.mpg.de>
Date: Tue, 30 Nov 2021 18:25:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.2
To: Song Liu <song@kernel.org>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
	<36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
	<CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
	<9f28f6e2-e46a-bfed-09d8-2fec941ea881@cloud.ionos.com>
	<CAPhsuW4V8JCCKePj11rf3zo4MJTz6TpW6DDeNmcJBfRSoN+NDA@mail.gmail.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <CAPhsuW4V8JCCKePj11rf3zo4MJTz6TpW6DDeNmcJBfRSoN+NDA@mail.gmail.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 01 Dec 2021 02:47:50 -0500
Cc: linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
	Donald Buczek <buczek@molgen.mpg.de>, it+raid@molgen.mpg.de
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Dear Linux folks,


Am 20.03.21 um 00:00 schrieb Song Liu:
> On Wed, Feb 24, 2021 at 1:26 AM Guoqing Jiang wrote:

>> On 2/24/21 10:09, Song Liu wrote:
>>> On Mon, Feb 15, 2021 at 3:08 AM Paul Menzel wrote:
>>>>
>>>> [+cc Donald]
>>>>
>>>> Am 13.02.21 um 01:49 schrieb Guoqing Jiang:
>>>>> Unregister sync_thread doesn't need to hold reconfig_mutex since it
>>>>> doesn't reconfigure array.
>>>>>
>>>>> And it could cause deadlock problem for raid5 as follows:
>>>>>
>>>>> 1. process A tried to reap sync thread with reconfig_mutex held after echo
>>>>>       idle to sync_action.
>>>>> 2. raid5 sync thread was blocked if there were too many active stripes.
>>>>> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
>>>>>       which causes the number of active stripes can't be decreased.
>>>>> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
>>>>>       to hold reconfig_mutex.
>>>>>
>>>>> More details in the link:
>>>>> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
>>>>>
>>>>> And add one parameter to md_reap_sync_thread since it could be called by
>>>>> dm-raid which doesn't hold reconfig_mutex.
>>>>>
>>>>> Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
>>>>> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
>>>
>>> I don't really like this fix. But I haven't got a better (and not too
>>> complicated)
>>> alternative.
>>>
>>>>> ---
>>>>> V2:
>>>>> 1. add one parameter to md_reap_sync_thread per Jack's suggestion.
>>>>>
>>>>>     drivers/md/dm-raid.c |  2 +-
>>>>>     drivers/md/md.c      | 14 +++++++++-----
>>>>>     drivers/md/md.h      |  2 +-
>>>>>     3 files changed, 11 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>>>>> index cab12b2..0c4cbba 100644
>>>>> --- a/drivers/md/dm-raid.c
>>>>> +++ b/drivers/md/dm-raid.c
>>>>> @@ -3668,7 +3668,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
>>>>>         if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
>>>>>                 if (mddev->sync_thread) {
>>>>>                         set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>>>> -                     md_reap_sync_thread(mddev);
>>>>> +                     md_reap_sync_thread(mddev, false);
>>>
>>> I think we can add mddev_lock() and mddev_unlock() here and then we don't
>>> need the extra parameter?
>>
>> I thought it too, but I would prefer get the input from DM people first.
>>
>> @ Mike or Alasdair
> 
> Hi Mike and Alasdair,
> 
> Could you please comment on this option: adding mddev_lock() and mddev_unlock()
> to raid_message() around md_reap_sync_thread()?

The issue is unfortunately still unresolved (at least Linux 5.10.82). 
How can we move forward?


Kind regards,

Paul

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

