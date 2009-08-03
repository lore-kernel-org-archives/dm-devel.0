From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: about multipath path group
Date: Mon, 3 Aug 2009 14:31:41 -0500
Message-ID: <20090803193141.GQ15326@ether.msp.redhat.com>
References: <2005566d0907212349i13c7d5aft7af3506dc572b8e7@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2005566d0907212349i13c7d5aft7af3506dc572b8e7@mail.gmail.com>
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

On Wed, Jul 22, 2009 at 02:49:39PM +0800, =E6=9D=A8=E4=BC=9F wrote:
>    Dear all:
>=20
>    Q1: In RHEL 5.2, make and make install multipath-tools-0.4.8, why do=
es not
>    command "multipath -p" work well?

Are you using the upstream or the RHEL code.  multipath -p does work in
the RHEL code, although, if you run multipath again, or reconfigure
multipathd, it will notice that your devices aren't set up the way the
config says they should be, and it will change them back.  In general,
multipath -p is pretty worthless, you should change the configuration to
use the path grouping policy you want.

>=20
>    Q2: In RHEL 5.2, configure path group policy as failover or group_by=
_prio,
>    and then create path-prio.sh to set the priority of paths. however, =
the
>    path group with the highest priority is not always active, if I don'=
t
>    recreate the multipath devices. why is that? how I make the path gro=
up
>    with the highest priority is active on-line?

By default, multipath is configured for manual failback.  This means
that multipathd won't switch from the current active pathgroup to a
higher priority one, unless you manually force it to do so. The
easiest way to do this is by running

# service multipathd reload  or
# multipathd -k"reconfigure"

adding=20

defaults {
	<other_defaults>
	failback immediate
}

to /etc/multipath.conf will make multipath immdiately switch to the
highest priority path group.

-Ben

>=20
>    William

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
