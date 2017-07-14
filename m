From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/4] libmultipath: get_udev_uid: make sure
 pp->wwid is 0-terminated
Date: Fri, 14 Jul 2017 21:27:52 +0000
Message-ID: <1500067671.835.1.camel@wdc.com>
References: <20170714113209.17177-1-mwilck@suse.com>
	<20170714113209.17177-2-mwilck@suse.com>
	<1500044188.2662.4.camel@wdc.com>
	<1500060099.4808.21.camel@suse.de> <1500063703.2662.9.camel@wdc.com>
	<1500067280.4808.27.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1500067280.4808.27.camel@suse.de>
Content-Language: en-US
Content-ID: <26228687BA9D9847A21B441054C76B0D@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "tang.junhui@zte.com.cn" <tang.junhui@zte.com.cn>, "mwilck@suse.de" <mwilck@suse.de>, "hare@suse.de" <hare@suse.de>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>, "guanjunxiong@huawei.com" <guanjunxiong@huawei.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: dm-devel.ids

On Fri, 2017-07-14 at 23:21 +0200, Martin Wilck wrote:
> OK. I'll wait for comments on the other patches, and change v2 of this
> patch to your version.

Hello Martin,

Patch 1/4 of this series is the only patch I wanted to comment on. The other
patches touch code that I'm not familiar enough with to review them.

Bart.
