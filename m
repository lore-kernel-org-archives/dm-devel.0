Return-Path: <SRS0=/8Bn=IX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17836C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 25 Mar 2021 01:12:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8083C61A14
	for <dm-devel@archiver.kernel.org>; Thu, 25 Mar 2021 01:12:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8083C61A14
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-vdICQFFcMNOW8XyYJNHXCw-1; Wed, 24 Mar 2021 21:12:50 -0400
X-MC-Unique: vdICQFFcMNOW8XyYJNHXCw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E5171007476;
	Thu, 25 Mar 2021 01:12:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DAA86866F2;
	Thu, 25 Mar 2021 01:12:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 58DFC4BB7C;
	Thu, 25 Mar 2021 01:12:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12P1Cel1026120 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Mar 2021 21:12:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E6F15101F0D3; Thu, 25 Mar 2021 01:12:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E216F101A80A
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 01:12:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7216E85A5A8
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 01:12:36 +0000 (UTC)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com
	[45.249.212.190]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-383-RoywFPW9NQyXVsNtm_dA4A-1; Wed, 24 Mar 2021 21:12:29 -0400
X-MC-Unique: RoywFPW9NQyXVsNtm_dA4A-1
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F5RqL6V0Jz19J10;
	Thu, 25 Mar 2021 09:10:22 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.117) by DGGEMS411-HUB.china.huawei.com
	(10.3.19.211) with Microsoft SMTP Server id 14.3.498.0;
	Thu, 25 Mar 2021 09:12:15 +0800
To: "Ewan D. Milne" <emilne@redhat.com>, lixiaokeng <lixiaokeng@huawei.com>,
	Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>
References: <c8f86351-3036-0945-90d2-2e020d68ccf2@huawei.com>
	<20210322081155.GE1946905@infradead.org>
	<20210322142207.GB30698@redhat.com>
	<a46013db-8143-7b41-95a8-182439b385f2@huawei.com>
	<5612cd9e298488ea9277f8d99ce0fd35240bdc53.camel@redhat.com>
From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <4d0860a6-9f53-2e51-91ea-e2b7c4322d9c@huawei.com>
Date: Thu, 25 Mar 2021 09:12:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
	Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <5612cd9e298488ea9277f8d99ce0fd35240bdc53.camel@redhat.com>
X-Originating-IP: [10.174.176.117]
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: "wubo \(T\)" <wubo40@huawei.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linfeilong <linfeilong@huawei.com>,
	dm-devel@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] md/dm-mpath: check whether all pgpaths have same
 uuid in multipath_ctr()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


On 2021/3/24 1:11, Ewan D. Milne wrote:
> On Tue, 2021-03-23 at 15:47 +0800, lixiaokeng wrote:
>>
>> On 2021/3/22 22:22, Mike Snitzer wrote:
>>> On Mon, Mar 22 2021 at  4:11am -0400,
>>> Christoph Hellwig <hch@infradead.org> wrote:
>>>
>>>> On Sat, Mar 20, 2021 at 03:19:23PM +0800, Zhiqiang Liu wrote:
>>>>> From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>>>>>
>>>>> When we make IO stress test on multipath device, there will
>>>>> be a metadata err because of wrong path. In the test, we
>>>>> concurrent execute 'iscsi device login|logout' and
>>>>> 'multipath -r' command with IO stress on multipath device.
>>>>> In some case, systemd-udevd may have not time to process
>>>>> uevents of iscsi device logout|login, and then 'multipath -r'
>>>>> command triggers multipathd daemon calls ioctl to load table
>>>>> with incorrect old device info from systemd-udevd.
>>>>> Then, one iscsi path may be incorrectly attached to another
>>>>> multipath which has different uuid. Finally, the metadata err
>>>>> occurs when umounting filesystem to down write metadata on
>>>>> the iscsi device which is actually not owned by the multipath
>>>>> device.
>>>>>
>>>>> So we need to check whether all pgpaths of one multipath have
>>>>> the same uuid, if not, we should throw a error.
>>>>>
>>>>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>>>>> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
>>>>> Signed-off-by: linfeilong <linfeilong@huawei.com>
>>>>> Signed-off-by: Wubo <wubo40@huawei.com>
>>>>> ---
>>>>>  drivers/md/dm-mpath.c   | 52
>>>>> +++++++++++++++++++++++++++++++++++++++++
>>>>>  drivers/scsi/scsi_lib.c |  1 +
>>>>>  2 files changed, 53 insertions(+)
>>>>>
>>>>> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
>>>>> index bced42f082b0..f0b995784b53 100644
>>>>> --- a/drivers/md/dm-mpath.c
>>>>> +++ b/drivers/md/dm-mpath.c
>>>>> @@ -24,6 +24,7 @@
>>>>>  #include <linux/workqueue.h>
>>>>>  #include <linux/delay.h>
>>>>>  #include <scsi/scsi_dh.h>
>>>>> +#include <linux/dm-ioctl.h>
>>>>>  #include <linux/atomic.h>
>>>>>  #include <linux/blk-mq.h>
>>>>>
>>>>> @@ -1169,6 +1170,45 @@ static int parse_features(struct
>>>>> dm_arg_set *as, struct multipath *m)
>>>>>  	return r;
>>>>>  }
>>>>>
>>>>> +#define SCSI_VPD_LUN_ID_PREFIX_LEN 4
>>>>> +#define MPATH_UUID_PREFIX_LEN 7
>>>>> +static int check_pg_uuid(struct priority_group *pg, char
>>>>> *md_uuid)
>>>>> +{
>>>>> +	char pgpath_uuid[DM_UUID_LEN] = {0};
>>>>> +	struct request_queue *q;
>>>>> +	struct pgpath *pgpath;
>>>>> +	struct scsi_device *sdev;
>>>>> +	ssize_t count;
>>>>> +	int r = 0;
>>>>> +
>>>>> +	list_for_each_entry(pgpath, &pg->pgpaths, list) {
>>>>> +		q = bdev_get_queue(pgpath->path.dev->bdev);
>>>>> +		sdev = scsi_device_from_queue(q);
>>>>
>>>> Common dm-multipath code should never poke into scsi
>>>> internals.  This
>>>> is something for the device handler to check.  It probably also
>>>> won't
>>>> work for all older devices.
>>>
>>> Definitely.
>>>
>>> But that aside, userspace (multipathd) _should_ be able to do extra
>>> validation, _before_ pushing down a new table to the kernel, rather
>>> than
>>> forcing the kernel to do it.
>>>
>>
>> Martin (committer of multipath-tools) said that:
>> "Don't get me wrong, I don't argue against tough testing. But we
>> should
>> be aware that there are always time intervals during which
>> multipathd's
>> picture of the present devices is different from what the kernel
>> sees."
>>
>> It is difficult to solve this in multipathd.
>>
>> Regards,
>> Lixiaokeng
>>
> 
> I think the patch is no good.  There are plenty of devices that don't
> support VPD page 83h:
> 
> int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
> {
>         u8 cur_id_type = 0xff;
>         u8 cur_id_size = 0;
>         unsigned char *d, *cur_id_str;
>         unsigned char __rcu *vpd_pg83;
>         int id_size = -EINVAL;
> 
>         rcu_read_lock();
>         vpd_pg83 = rcu_dereference(sdev->vpd_pg83);
>         if (!vpd_pg83) {
>                 rcu_read_unlock();
>                 return -ENXIO;
>         }
> 
> and the DM layer should not be looking at the properties of the
> underlying devices in this way anyway.  It should be pushed down
> to the table.
> 
Thanks for your suggestion.
I will have a try to modify the patch as your advice.


Regards
Zhiqiang Liu.
> -Ewan
> 
> 
> 
> 
> .
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

