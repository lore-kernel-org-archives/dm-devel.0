From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 01/14] fs: remove the unused SB_I_MULTIROOT flag
Date: Wed, 22 Jul 2020 06:54:53 +0000
Message-ID: <SN4PR0401MB35987802444E56DED8C7962E9B790@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200722062552.212200-1-hch@lst.de>
 <20200722062552.212200-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>
List-Id: dm-devel.ids

A little bit of git archeology shows the last user of SB_I_MULTIROOT is gon=
e with=0A=
f2aedb713c28 ("NFS: Add fs_context support.")=0A=
=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
