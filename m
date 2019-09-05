From: Huaisheng HS1 Ye <yehs1@lenovo.com>
Subject: Re: [PATCH] dm writecache: skip writecache_wait for pmem mode
Date: Thu, 5 Sep 2019 05:59:13 +0000
Message-ID: <HK2PR03MB4418CB96B9E7B640B8B9CFB192BB0@HK2PR03MB4418.apcprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "prarit@redhat.com" <prarit@redhat.com>, Tzu ting Yu1 <tyu1@lenovo.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Huaisheng Ye <yehs2007@zoho.com>
List-Id: dm-devel.ids

> -----Original Message-----
> From: Mikulas Patocka <mpatocka@redhat.com>
> Sent: Wednesday, September 4, 2019 11:36 PM
> On Wed, 4 Sep 2019, Huaisheng HS1 Ye wrote:
>=20
> >
> > Hi Mikulas,
> >
> > Thanks for your reply, I see what you mean, but I can't agree with you.
> >
> > For pmem mode, this code path (writecache_flush) is much more hot than
> > SSD mode. Because in the code, the AUTOCOMMIT_BLOCKS_PMEM has been
> > defined to 64, which means if more than 64 blocks have been inserted
> > to cache device, also called uncommitted, writecache_flush would be cal=
led.
> > Otherwise, there is a timer callback function will be called every
> > 1000 milliseconds.
> >
> > #define AUTOCOMMIT_BLOCKS_SSD		65536
> > #define AUTOCOMMIT_BLOCKS_PMEM		64
> > #define AUTOCOMMIT_MSEC			1000
> >
> > So when dm-writecache running in working mode, there are continuous
> > WRITE operations has been mapped to writecache_map, writecache_flush
> > will be used much more often than SSD mode.
> >
> > Cheers,
> > Huaisheng Ye
>=20
> So, you save one instruction cache line for every 64*4096 bytes written t=
o
> persistent memory.
>=20
> If you insist on it, I can acknowledge it, but I think it is really an
> over-optimization.
>=20
> Acked-By: Mikulas Patocka <mpatocka@redhat.com>
>=20
> Mikulas

Thanks for your Acked-by, I have learned so much from your code.

And I have another question about the LRU.
Current code only put the last written blocks into the front of list wc->lr=
u, READ hit doesn't affect the position of block in wc->lru.
That is to say, if a block has been written to cache device, even there wou=
ld be a lot of READ operation for that block next but without WRITE hit, wh=
ich still would flow to the end of wc->lru, and eventually it would be writ=
ten back.

I am not sure whether this behavior disobeys LRU principle or not. But if t=
his situation above appears, that would lead to some HOT blocks (without WR=
ITE hit) had been written back, even READ hit many times.
Is it worth submitting patch to adjust the position of blocks when READ hit=
?
Just a discussion, I want to know your design idea.

Cheers,
Huaisheng Ye
