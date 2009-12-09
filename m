From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [dm-devel] [PATCH v2 1/1] dm-raid45
Date: Tue, 8 Dec 2009 17:38:06 -0700
Message-ID: <e9c3a7c20912081638w39469743n76b4114b840f1c43@mail.gmail.com>
References: <1259243112-28175-1-git-send-email-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1259243112-28175-1-git-send-email-heinzm@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: dm-devel.ids

On Thu, Nov 26, 2009 at 6:45 AM,  <heinzm@redhat.com> wrote:
> From: Heinz Mauelshagen <heinzm@redhat.com>
>
> Neil et al.,
>
> finally got around to creating a followup (interim) patch, which allo=
ws
> for changing the xor algorithn at runtime via the message interface,
> hence allowing to test if the xor unrole optimization around the
> supported algorithms is performing better than the assembler
> optimized one in the kernel.

Now that perf is available it would be good to get some comparative
cache utilization statistics on the two approaches.  The assembly
routines make an attempt to avoid polluting L2 (however the memcpy's
into the cache do not).

> If we can prove my findings rigth, we could move those into
> the crypto subsystem xor.
>
> Syntax:
> -------
> dmsetup message $MappedDevice 0 xor $Algorithm $Chunks
>
> $MappedDevice =3D whatever name you picked during creation
> $Algorithm =3D { "xor_8", "xor_16", "xor_32", "xor_64", "xor_blocks" =
}
> $Chunks =3D 2..N # N being the amount of stripes (eg. 5 with 5 disks)
>
> Patch applies to clean mainline git 2.6.32-rc8.
>
> Regards,
> Heinz
>
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> ---
> =A0drivers/md/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A09 +
> =A0drivers/md/Makefile =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A02 +
> =A0drivers/md/dm-memcache.c =A0 =A0 =A0 | =A0301 +++
> =A0drivers/md/dm-memcache.h =A0 =A0 =A0 | =A0 68 +
> =A0drivers/md/dm-raid45.c =A0 =A0 =A0 =A0 | 4720 ++++++++++++++++++++=
++++++++++++++++++++

Where did the investigation of reusing md/raid5.c [1] end up?  This
would simultaneously enable hardware accelerated raid6 for dmraid.

--
Dan

[1] http://marc.info/?l=3Ddm-devel&m=3D124567352518676&w=3D2
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
