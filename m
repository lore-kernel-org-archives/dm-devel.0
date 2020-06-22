From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [RFC PATCH 2/2] dm: don't try to split REQ_OP_ZONE_APPEND bios
Date: Mon, 22 Jun 2020 07:51:13 +0000
Message-ID: <SN4PR0401MB35985AA8FE160B3B0417DB3C9B970@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200619065905.22228-1-johannes.thumshirn@wdc.com>
 <20200619065905.22228-3-johannes.thumshirn@wdc.com>
 <CY4PR04MB37514CDC42E7F545244D66C6E7980@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200619162658.GB24642@redhat.com>
 <CY4PR04MB37514F8CCE7918A7C13FCA82E7970@CY4PR04MB3751.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Naohiro Aota <Naohiro.Aota@wdc.com>
List-Id: dm-devel.ids

On 22/06/2020 02:27, Damien Le Moal wrote:=0A=
[...]=0A=
> Just to be extra sure, I checked this again. Since for zoned block device=
s the=0A=
> mapping of a target must be zoned aligned and a zone append command is al=
ways=0A=
> fully contained within a zone, we do not need this check. The stacked lim=
its and=0A=
> submit_bio() code will fail a zone append command that is too large or th=
at=0A=
> spans zones before we get here.=0A=
> =0A=
> That is of course assuming that the target does not expose zones that are=
 mapped=0A=
> using multiple chunks from different devices. There is currently no targe=
t doing=0A=
> that, so this is OK. We can safely drop this patch.=0A=
=0A=
Yeah I think we can drop that one.=0A=
