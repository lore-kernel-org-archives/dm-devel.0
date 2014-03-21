From: Matias Bjorling <m@bjorling.me>
Subject: Re: [PATCH RFC v1 00/01] dm-lightnvm introduction
Date: Fri, 21 Mar 2014 09:42:54 -0700
Message-ID: <532C6C0E.3040608@bjorling.me>
References: <1395383538-18019-1-git-send-email-m@bjorling.me> <CAFLxGvxVYZtXS+PAD4gzGHb6U8HbPOajqT_sF692S-kM5bNJ9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFLxGvxVYZtXS+PAD4gzGHb6U8HbPOajqT_sF692S-kM5bNJ9A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com, NeilBrown <neilb@suse.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 03/21/2014 08:32 AM, Richard Weinberger wrote:
> On Fri, Mar 21, 2014 at 7:32 AM, Matias Bj=F8rling <m@bjorling.me> wr=
ote:
<snip>
>=20
> This sounds very interesting!
>=20
> Is there also a way to expose the flash directly as MTD device?
> I'm thinking of UBI. Maybe both projects can benefit from each others=
=2E
>=20

Hi Richard,

Yes, mostly. It's different from MTD, in that all flash is exposed
through a linear address space, from which the FTL is layered on top.
This allows the device to still do some work, such as ECC, RAID, etc. i=
f
it choose to, but also allows the host to do it.

I think UBI could be a good choice for maintaining each of the flash
"partitions" as there's a lot of small subtle details that have to be
taken care of.

- Matias
