Return-Path: <SRS0=/8Bn=IX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6574BC433E4
	for <dm-devel@archiver.kernel.org>; Thu, 25 Mar 2021 01:22:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AFA2761A1F
	for <dm-devel@archiver.kernel.org>; Thu, 25 Mar 2021 01:22:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFA2761A1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-8iPT2BM_PTm1I-ETU3UWHA-1; Wed, 24 Mar 2021 21:22:17 -0400
X-MC-Unique: 8iPT2BM_PTm1I-ETU3UWHA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C66B3101964E;
	Thu, 25 Mar 2021 01:22:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D4726BF74;
	Thu, 25 Mar 2021 01:22:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 193F11809C83;
	Thu, 25 Mar 2021 01:22:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12P1MAEV027741 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Mar 2021 21:22:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 514A0F51B5; Thu, 25 Mar 2021 01:22:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B524F5573
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 01:22:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74072811E93
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 01:22:07 +0000 (UTC)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com
	[45.249.212.191]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-39-1Trkws-QPaWi6zeA1-frVQ-1; Wed, 24 Mar 2021 21:22:04 -0400
X-MC-Unique: 1Trkws-QPaWi6zeA1-frVQ-1
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F5S1r5WxszNmxN;
	Thu, 25 Mar 2021 09:19:28 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.117) by DGGEMS403-HUB.china.huawei.com
	(10.3.19.203) with Microsoft SMTP Server id 14.3.498.0;
	Thu, 25 Mar 2021 09:21:51 +0800
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>
References: <c8f86351-3036-0945-90d2-2e020d68ccf2@huawei.com>
	<20210322081155.GE1946905@infradead.org>
	<20210322142207.GB30698@redhat.com>
From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <cd71d0fa-31d1-5cd8-74a1-8b124724b3b1@huawei.com>
Date: Thu, 25 Mar 2021 09:21:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
	Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210322142207.GB30698@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: lixiaokeng <lixiaokeng@huawei.com>, "wubo \(T\)" <wubo40@huawei.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 2021/3/22 22:22, Mike Snitzer wrote:
> On Mon, Mar 22 2021 at  4:11am -0400,
> Christoph Hellwig <hch@infradead.org> wrote:
> 
>> On Sat, Mar 20, 2021 at 03:19:23PM +0800, Zhiqiang Liu wrote:
>>> From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>>>
>>> When we make IO stress test on multipath device, there will
>>> be a metadata err because of wrong path. In the test, we
>>> concurrent execute 'iscsi device login|logout' and
>>> 'multipath -r' command with IO stress on multipath device.
>>> In some case, systemd-udevd may have not time to process
>>> uevents of iscsi device logout|login, and then 'multipath -r'
>>> command triggers multipathd daemon calls ioctl to load table
>>> with incorrect old device info from systemd-udevd.
>>> Then, one iscsi path may be incorrectly attached to another
>>> multipath which has different uuid. Finally, the metadata err
>>> occurs when umounting filesystem to down write metadata on
>>> the iscsi device which is actually not owned by the multipath
>>> device.
>>>
>>> So we need to check whether all pgpaths of one multipath have
>>> the same uuid, if not, we should throw a error.
>>>
>>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>>> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
>>> Signed-off-by: linfeilong <linfeilong@huawei.com>
>>> Signed-off-by: Wubo <wubo40@huawei.com>
>>> ---
>>>  drivers/md/dm-mpath.c   | 52 +++++++++++++++++++++++++++++++++++++++++
>>>  drivers/scsi/scsi_lib.c |  1 +
>>>  2 files changed, 53 insertions(+)
>>>
>>> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
>>> index bced42f082b0..f0b995784b53 100644
>>> --- a/drivers/md/dm-mpath.c
>>> +++ b/drivers/md/dm-mpath.c
>>> @@ -24,6 +24,7 @@
>>>  #include <linux/workqueue.h>
>>>  #include <linux/delay.h>
>>>  #include <scsi/scsi_dh.h>
>>> +#include <linux/dm-ioctl.h>
>>>  #include <linux/atomic.h>
>>>  #include <linux/blk-mq.h>
>>>
>>> @@ -1169,6 +1170,45 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
>>>  	return r;
>>>  }
>>>
>>> +#define SCSI_VPD_LUN_ID_PREFIX_LEN 4
>>> +#define MPATH_UUID_PREFIX_LEN 7
>>> +static int check_pg_uuid(struct priority_group *pg, char *md_uuid)
>>> +{
>>> +	char pgpath_uuid[DM_UUID_LEN] = {0};
>>> +	struct request_queue *q;
>>> +	struct pgpath *pgpath;
>>> +	struct scsi_device *sdev;
>>> +	ssize_t count;
>>> +	int r = 0;
>>> +
>>> +	list_for_each_entry(pgpath, &pg->pgpaths, list) {
>>> +		q = bdev_get_queue(pgpath->path.dev->bdev);
>>> +		sdev = scsi_device_from_queue(q);
>>
>> Common dm-multipath code should never poke into scsi internals.  This
>> is something for the device handler to check.  It probably also won't
>> work for all older devices.
> 
> Definitely.
> 
> But that aside, userspace (multipathd) _should_ be able to do extra
> validation, _before_ pushing down a new table to the kernel, rather than
> forcing the kernel to do it.

As your said, it is better to do extra validation in userspace (multipathd).
However, in some cases, the userspace cannot see the real-time present devices
info as Martin (committer of multipath-tools) said.
In addition, the kernel can see right device info in the table at any time,
so the uuid check in kernel can ensure one multipath is composed with paths mapped to
the same device.

Considering the severity of the wrong path in multipath, I think it worths more
checking.

Regards
Zhiqiang Liu.


> 
> .
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

