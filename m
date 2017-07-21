From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH 2/2] multipath-tools/libmultipath: Add args
 min_avg_latency for path_latency.
Date: Fri, 21 Jul 2017 14:22:34 +0200
Message-ID: <1500639754.32663.24.camel@suse.de>
References: <1500521767-15884-1-git-send-email-philip.yang@huawei.com>
	<1500521767-15884-3-git-send-email-philip.yang@huawei.com>
	<1500574041.32663.7.camel@suse.com>
	<5737cdc5-88fa-b27a-3acb-eacf1b4b0341@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5737cdc5-88fa-b27a-3acb-eacf1b4b0341@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Yang Feng <philip.yang@huawei.com>, dm-devel@redhat.com, xose.vazquez@gmail.com
Cc: zouming.zouming@huawei.com, hege09@huawei.com, guanjunxiong@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

Dear Yang,

On Fri, 2017-07-21 at 11:38 +0800, Yang Feng wrote:
> 
> Sorry, I don't find this similar syntax. Could you give a example of
> the
> other prioritizer.

Please look at the prio_args section in multipath.conf. "weighted" uses
just space separated args. "iet" uses "parm=value" syntax. That's
actually most intuitive IMO. No current prio algorithm uses anything
but space to separate options.

Regards
Martin

-- 
