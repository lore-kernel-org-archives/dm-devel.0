From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH 0/4] NVMe path failover update
Date: Fri, 15 Sep 2017 17:59:55 +0800
Message-ID: <e965897d-c403-f5f5-d6f2-c2c428baa68e@huawei.com>
References: <1505457030-119611-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1505457030-119611-1-git-send-email-hare@suse.de>
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
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, niuhaoxin <niuhaoxin@huawei.com>, "Shenhong (C)" <shenhong09@huawei.com>
List-Id: dm-devel.ids

Hi Hannes,

Thanks for improving DM-multipath over NVMe.  Please find my comment.

Cheers
Guan Junxiong



On 2017/9/15 14:30, Hannes Reinecke wrote:
> Hi all,
> 
> the current NVMe support is fairly rudimentary, and we've had reports
> about spurious path failures under high load.
> Which is a bit disappointing, seeing that high load is exactly what
> NVMe is about ...
> So here's a patchset to clean up the situation somewhat.
> In particular:
> - I've fixed up the discovery to fall in line with the other transports,
>   like filling out the sg_id fields (so that we're not greeted with weird
>   hashes in the topology output)

Great, that is something I want to touch.  IMO, it's better to use a union
fields such as nvme_id fields which shows the true topology of NVMe/NVMf storage
such as: host NQN ->portid->subsytem NQN ->controller ID ->namespace id .
