From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH] dm: don't call report zones for more than the user
 requested
Date: Tue, 4 Aug 2020 11:26:57 +0000
Message-ID: <SN4PR0401MB3598A9D49399D70697DCEC789B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200804092501.7938-1-johannes.thumshirn@wdc.com>
 <CY4PR04MB3751EB538B7F29FBDBB4EBA4E74A0@CY4PR04MB3751.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Naohiro Aota <Naohiro.Aota@wdc.com>
List-Id: dm-devel.ids

On 04/08/2020 12:17, Damien Le Moal wrote:=0A=
> =0A=
> Looks good. I think this needs a Cc: stable.=0A=
=0A=
Indeed, Mike can you add these two when applying or do you want me to resen=
d?=0A=
=0A=
Fixes: d41003513e61 ("block: rework zone reporting")=0A=
Cc: stable@vger.kernel.org # v5.5+=0A=
