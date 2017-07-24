From: Yang Feng <philip.yang@huawei.com>
Subject: Re: [PATCH 2/2] multipath-tools/libmultipath: Add args
 min_avg_latency for path_latency.
Date: Mon, 24 Jul 2017 09:45:36 +0800
Message-ID: <34625fa0-76e4-e6f5-6b50-95977d8ce92b@huawei.com>
References: <1500521767-15884-1-git-send-email-philip.yang@huawei.com>
	<1500521767-15884-3-git-send-email-philip.yang@huawei.com>
	<1500574041.32663.7.camel@suse.com>
	<5737cdc5-88fa-b27a-3acb-eacf1b4b0341@huawei.com>
	<1500639962.32663.28.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1500639962.32663.28.camel@suse.de>
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
To: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com, xose.vazquez@gmail.com
Cc: zouming.zouming@huawei.com, hege09@huawei.com, guanjunxiong@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

Dear Martin,

Thanks, I got it.
Regards,
-Yang

On 2017/7/21 20:26, Martin Wilck wrote:
> Dear Yang,
> 
> On Fri, 2017-07-21 at 11:38 +0800, Yang Feng wrote:
>>
>> Sorry, I don't find this similar syntax. Could you give a example of
>> the
>> other prioritizer.
> 
> Please look at the prio_args section in multipath.conf. "weighted" uses
> just space separated args. "iet" uses "parm=value" syntax. That's
> actually most intuitive IMO. No current prio algorithm uses anything
> but space to separate options.
> 
> Regards
> Martin
> 
