From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: multipath-tools 0.7.4 failure to remove device
Date: Tue, 16 Jan 2018 23:05:48 +0100
Message-ID: <6cb5b742-74b4-26ff-c52f-fe5f47ab2aef@gmail.com>
References: <20180112083833.apsybil4ux4d2y32@jak-x230>
	<1515789339.3409.33.camel@suse.com>
	<20180112214700.ljxlypo5nar6oh3m@jak-x230>
	<1515795481.9139.8.camel@suse.com>
	<20180115154424.fcjuudt7phxrks6q@jak-x230>
	<1516032730.5699.38.camel@suse.com>
	<20180115162658.wlccxhlaq56byykg@jak-x230>
	<1516034784.5699.44.camel@suse.com>
	<20180116202946.GO5638@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180116202946.GO5638@octiron.msp.redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, development mailing list <dm-devel@redhat.com>
Cc: Julian Andres Klode <julian.klode@canonical.com>, Guan Junxiong <guanjunxiong@huawei.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On 01/16/2018 09:30 PM, Benjamin Marzinski wrote:

> RedHat also removes your patches to force ignore_wwids off and imply -n
> 
> 64e27ec066a001012f44550f095c93443e91d845
> ffbb886a8a16cb063d669cd76a1e656fd3ec8c4b


For reference, they are at(-RH- prefix):

https://src.fedoraproject.org/rpms/device-mapper-multipath/tree/master or
$ git clone https://src.fedoraproject.org/rpms/device-mapper-multipath.git
