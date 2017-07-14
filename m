From: "Schremmer, Steven" <Steve.Schremmer@netapp.com>
Subject: Re: [PATCH 3/4] libmultipath: only listen for uevents
	with	DEVTYPE=disk
Date: Fri, 14 Jul 2017 22:16:46 +0000
Message-ID: <BN6PR06MB248104CDFB472F08E5BC634F8CAD0@BN6PR06MB2481.namprd06.prod.outlook.com>
References: <20170714113209.17177-1-mwilck@suse.com>
	<20170714113209.17177-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170714113209.17177-4-mwilck@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "tang.junhui@zte.com.cn" <tang.junhui@zte.com.cn>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes
	Reinecke <hare@suse.de>, Guan Junxiong <guanjunxiong@huawei.com>
Cc: Martin Wilck <mwilck@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: dm-devel.ids

> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On Behalf Of Martin Wilck
> Sent: Friday, July 14, 2017 6:32 AM
> To: Christophe Varoqui <christophe.varoqui@opensvc.com>; tang.junhui@zte.com.cn; Benjamin Marzinski <bmarzins@redhat.com>;
> Hannes Reinecke <hare@suse.de>; Guan Junxiong <guanjunxiong@huawei.com>
> Cc: Martin Wilck <mwilck@suse.de>; dm-devel@redhat.com; Xose Vazquez Perez <xose.vazquez@gmail.com>; linux-
> nvme@lists.infradead.org
> Subject: [dm-devel] [PATCH 3/4] libmultipath: only listen for uevents with DEVTYPE=disk
> 
> We are only interested in disks anyway. This saves us checking
> for devtype in the uevent processing queue, and is more powerful
> than the previous test in the dropped function
> uevent_can_discard_by_devpath().
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---

Reviewed-by: Steve Schremmer <steve.schremmer@netapp.com>
