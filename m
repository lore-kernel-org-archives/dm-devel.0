From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 1/4] libmultipath: get_udev_uid: make sure
 pp->wwid is 0-terminated
Date: Wed, 19 Jul 2017 03:06:20 +0000
Message-ID: <1500433579.32119.0.camel@wdc.com>
References: <20170718072916.24275-1-mwilck@suse.com>
	<20170718072916.24275-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170718072916.24275-2-mwilck@suse.com>
Content-Language: en-US
Content-ID: <1FE41A13F5732D4EA64AC6BD8B681AFA@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "bmarzins@redhat.com" <bmarzins@redhat.com>, "mwilck@suse.com" <mwilck@suse.com>, "hare@suse.de" <hare@suse.de>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>, "guanjunxiong@huawei.com" <guanjunxiong@huawei.com>
Cc: "mwilck@suse.de" <mwilck@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "tang.junhui@zte.com.cn" <tang.junhui@zte.com.cn>
List-Id: dm-devel.ids

On Tue, 2017-07-18 at 09:29 +0200, Martin Wilck wrote:
> If the first WWID_LEN bytes of the uuid_attribute do not contain
> a 0 byte, pp->wwid may end up not properly terminated. Fix it by
> using strlcpy() rather than strncpy().

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
