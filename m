From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH 0/21] SUSE multipath-tools resync
Date: Tue, 22 May 2007 00:27:07 +0200
Message-ID: <1179786427.10963.60.camel@localhost.localdomain>
References: <465164F3.7000408@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <465164F3.7000408@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Le lundi 21 mai 2007 =C3=A0 11:22 +0200, Hannes Reinecke a =C3=A9crit :
> Hi Christophe,
>=20
> there have been quite some fixes accumulating here; and as I finally
> found some time I thought it a nice idea to have them sent upstream.
> There are fixes for various bits and pieces; mostly no big deal.
> Most important of these are the following:
>=20
Thanks, I started reading and merging this work.

> - Added an option '-t' to dump the internal hardware table to multipath=
.
>   This is quite helpful when generating your own multipath-tools.conf
>   and you'd like to start with some sensible defaults.

Doesn't the daemon CLI "show config" command fill this need ?
If so, I'd rather drop this patch (and the associated manpage patch).

> - We now got a manpage multipath.conf.5 !

Nice

> - New priority checker 'hp_sw' which will allow us to group these
>   machines by priority, too.
Have you pushed the kernel hardware handler upstream too ? (the
START_STOP one ?)

>=20
- directio checker async mode
Interesting stuff.
1) Do we need the libaio.h copy ?
2) Have you put some thought to SG_IO async mode feasability ?
3) Shouldn't we also timeout the execv() for path prios and ids to avoid
blocking the daemon.

> Some patches might be a bit controversial; they make sense to me, but
> others might think otherwise:
>=20
> - I've removed libsysfs and implemented the sysfs handling internally.
>   With the current changes in sysfs the older libsysfs doesn't work
>   anymore and in either case it was just a big annoyance.

I mostly agree, but this one will be long to review :)

You seem to have a genuine fix in there, in cli_add_map(). It might
deserve a separate patch.

> - I've hacked up kpartx to handle extended partitions as well.
>   Currently it's quite peculiar with kpartx; we'd be generating
>   tables for all partitions _unless_ it's an extended one.
>   So we won't be getting any symlinks to the extended partition
>   when we're using kpartx, although the device itself is present.
>=20
I'll read those later.

> Feel free to omit them if you don't agree.
> And of course, feedback etc is welcome.
>=20
I add this one, that might interest you :

commit 9ff5a680b7803d8932059b2e0d6d295c60c95370
Author: Christophe Varoqui <cvaroqui@zezette.localdomain>
Date:   Tue May 22 00:24:22 2007 +0200

    [libmultipath] new devmapper log handler needs stdarg.h
   =20
    As it uses the va_list type.

> Christophe, please pull from
>=20
> git://git.kernel.org/pub/scm/linux/kernel/hare/multipath-tools/.git
> #upstream-fixes.
>=20
> Cheers,
>=20
> Hannes
