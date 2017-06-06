From: Yang Feng <philip.yang@huawei.com>
Subject: Re: [PATCH v3 1/1] multipath-tools: Prioritizer based on
 a latency algorithm
Date: Tue, 6 Jun 2017 09:48:24 +0800
Message-ID: <d90638aa-22df-f3ba-ffec-25f850c69180@huawei.com>
References: <1496630622-24648-1-git-send-email-philip.yang@huawei.com>
	<1496630622-24648-2-git-send-email-philip.yang@huawei.com>
	<4005a390-9db7-ff4b-f503-2801a80815ab@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4005a390-9db7-ff4b-f503-2801a80815ab@gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, dm-devel@redhat.com, christophe.varoqui@opensvc.com, bmarzins@redhat.com, mwilck@suse.com
Cc: zouming.zouming@huawei.com, hege09@huawei.com, guanjunxiong@huawei.com, shenhong09@huawei.com, qiuxin@huawei.com
List-Id: dm-devel.ids

Hi Xose,

Thanks, the updated patch will be sent later.

Best.

On 2017/6/6 0:43, Xose Vazquez Perez wrote:
> On 06/05/2017 04:43 AM, Yang Feng wrote:
> 
>> diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
>> new file mode 100644
>> index 0000000..081f546
>> --- /dev/null
>> +++ b/libmultipath/prioritizers/path_latency.c
>> @@ -0,0 +1,272 @@
>> +/*
>> + * (C) Copyright HUAWEI Technology Corp. 2017, 2021   All Rights Reserved.
> 
>                                                   ^^^^  <-----------
> 2021 ???
> 

Thanks, "2021" will be deleted.

>> + *
>> + * Author(s): Yang Feng <philip.yang@huawei.com>
>> + *            Zou Ming <zouming.zouming@huawei.com>
>> + *            Guan Junxiong <guanjunxiong@huawei.com>
>> + *
>> + * This file is released under the GPL.
>                                       ^^^  <-----------
> 
> "GPL" is not a licence. The *version* must be specified.
> 
> 
> And it would be nice to start using SPDX tags ( https://spdx.org/ )
> for new files.
> 
> 
> BTW: LFC191 Compliance Basics for Developers course is FREE
>      https://training.linuxfoundation.org/linux-courses/open-source-compliance-courses/compliance-basics-for-developers
> 
> .
> 

"This file is released under the GPL." will be modified to "This file is released under the GPL version 2, or any later version."
