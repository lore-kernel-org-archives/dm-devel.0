From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 9/9] libmultipath: hwtable: add Lenovo DE
	series
Date: Sat, 16 Mar 2019 23:44:27 +0100
Message-ID: <c26afda7-41bc-798e-c35f-c336e1799a06@gmail.com>
References: <20190315161155.24062-1-mwilck@suse.com>
	<20190315161155.24062-10-mwilck@suse.com>
	<BN8PR06MB579317ED3B7E69E11BC1DEEE8C440@BN8PR06MB5793.namprd06.prod.outlook.com>
	<035a04387b76a8b310a88501f00c2b1bcaa5209c.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <035a04387b76a8b310a88501f00c2b1bcaa5209c.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, "Schremmer, Steven" <Steve.Schremmer@netapp.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: ng-eseries-upstream-maintainers <ng-eseries-upstream-maintainers@netapp.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 3/15/19 5:59 PM, Martin Wilck wrote:

> Currently, we have these in hwtable.c:
> 
>  * Maintainer: Martin George <marting@netapp.com>

only for ONTAP.

>  * Maintainer: PJ Waskiewicz <pj.waskiewicz@netapp.com>

and only for SolidFir.

> Should they all be replaced by the ng-eseries address?

No. ng-eseries address is just for RDAC devices.

> Also, if you happen to know a Lenovo maintainer, feel free to
> tell me.

It could be deserted. There is no maintainer for all other rdac arrays.
All of them share the same config, inherited from "SANtricity(RDAC) family".
