From: Hannes Reinecke <hare@suse.de>
Subject: RE: path priorities on Sun's 6140
Date: Tue, 18 Sep 2007 16:02:04 +0200
Message-ID: <20070918160204.9j5z53swocogsk4k@imap.suse.de>
References: <66F461DD7EDEEF4AA928FCC80B425B520468B7@c2kp01mail.cucbc.com><46EBA114.10408@linpro.no>
	<66F461DD7EDEEF4AA928FCC80B425B520468B8@c2kp01mail.cucbc.com>
	<66F461DD7EDEEF4AA928FCC80B425B520468B9@c2kp01mail.cucbc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <66F461DD7EDEEF4AA928FCC80B425B520468B9@c2kp01mail.cucbc.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Am Mo 17 Sep 2007 20:36:32 CEST schrieb James Fillman <JFillman@cucbc.com>:

> Ok. So I just realized that if I want to try the new RDAC support, then
> I have to install the new beta kernel as well. It includes the RDAC
> hardware handler.
>
> I'm under serious pressure to get my cluster up and running asap and I
> don't think I want to be installing a bunch of beta packages onto my
> production servers. Especially kernels.

Well, I'm pretty sure their competitor has it with SP1 :-)

> So this might mean not exploring the RDAC solution. Redhat's docs say
> that they support a Sun OpenStorage D280 and our Sun rep says the 6140
> is essentially identical. If that's the case, what am I don't wrong?
>
If you don't have the RDAC hw handler you'll basically have to switch the
array to AVT mode. It works quite well, provided you don't boot the nodes
too often.

Cheers,

Hannes
