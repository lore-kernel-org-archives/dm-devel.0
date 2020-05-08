From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH] dm: track io errors per mapped device
Date: Fri, 8 May 2020 01:12:56 +0000
Message-ID: <DM6PR04MB49726E28257263F5A1C643B386A20@DM6PR04MB4972.namprd04.prod.outlook.com>
References: <20200507230532.5733-1-kj@orbekk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Kjetil Orbekk <kj@orbekk.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc: "harshads@google.com" <harshads@google.com>, Khazhismel Kumykov <khazhy@google.com>
List-Id: dm-devel.ids

On 05/07/2020 04:06 PM, Kjetil Orbekk wrote:=0A=
> +		if (tio->error)=0A=
> +			atomic_inc(&md->ioerr_cnt);=0A=
=0A=
Given that there are so many errors how would user know what=0A=
kind of error is generated and how many times?=0A=
=0A=
