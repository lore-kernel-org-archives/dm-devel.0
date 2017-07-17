From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH 4/4] libmultipath: fix over-long NVME WWIDs
Date: Mon, 17 Jul 2017 09:13:41 +0800
Message-ID: <f82ac570-4d40-0c69-5c98-7eb2d8c9c875@huawei.com>
References: <20170714113209.17177-1-mwilck@suse.com>
	<20170714113209.17177-5-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170714113209.17177-5-mwilck@suse.com>
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
To: Martin Wilck <mwilck@suse.com>
Cc: Martin Wilck <mwilck@suse.de>, "Shenhong (C)" <shenhong09@huawei.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, tang.junhui@zte.com.cn, guanjunxiong@huawei.com, Yang Feng <philip.yang@huawei.com>, linux-nvme@lists.infradead.org, dm-devel@redhat.com, "Hege (A)" <hege09@huawei.com>
List-Id: dm-devel.ids

Hi, Martin:

On 2017/7/14 19:32, Martin Wilck wrote:
> Fix for NVME wwids looking like this:
> nvme.0000-3163653363666438366239656630386200-4c696e75780000000000000000000000000000000000000000000000000000000000000000000000-00000002

I think the above line is too long and  it's better to split it into two lines.
Otherwise , this patch looks good for me.

Reviewed-by: Guan Junxiong <guanjunxiong@huawei.com>

> which are encountered in some combinations of Linux NVME host and target,
> where the 2nd field represents the serial number (SN) and the 3rd the
> model number (MN).
