From: "Yury Konovalov" <ykonovalov@gmail.com>
Subject: Re: Question about dm-multipath and Sun StorageTek 6140
Date: Mon, 12 Feb 2007 10:36:07 +0300
Message-ID: <744db6db0702112336r4d83ed3eucaa590975e5f0b52@mail.gmail.com>
References: <45CC4540.7020707@informatik.uni-stuttgart.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <45CC4540.7020707@informatik.uni-stuttgart.de>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Ralf,

2007/2/9, Ralf Aum=C3=BCller <Ralf.Aumueller@informatik.uni-stuttgart.de>=
:

> - is it true that I need a hardware-specific handler for arrays running
>   with active/passive controllers (like the Sun StorageTek 6140) to
>   get the the LUN trespassing working?

It's true only for non-AVT mode (set host type to Linux to turn AVT mode =
on)

> - did someone get the Sun StorageTek 6140 configured for dm-multipath?
>   (so that the LUN trespassing works)

It should work as it does for other boxes with LSILogic controllers.

path_grouping_policy    group_by_prio
path_checker            tur
prio_callout            "/sbin/mpath_prio_tpc /dev/%n"

--=20
Best Regards.
