From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH -mm] drivers/md/: Shut up uninitialized variable warnings
Date: Sun, 02 Sep 2007 16:34:36 -0400
Message-ID: <46DB1E5C.2080107@garzik.org>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i n> <alpine.LFD.0.999.0709030151320.29617@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759456AbXIBUes@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0709030151320.29617@enigma.security.iitk.ac.in>
Sender: linux-kernel-owner@vger.kernel.org
To: Satyam Sharma <satyam@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

Satyam Sharma wrote:
> drivers/md/dm-exception-store.c: In function =91persistent_read_metad=
ata=92:
> drivers/md/dm-exception-store.c:452: warning: =91new_snapshot=92 may =
be used uninitialized in this function
>=20
> drivers/md/dm-ioctl.c: In function =91ctl_ioctl=92:
> drivers/md/dm-ioctl.c:1407: warning: =91param=92 may be used uninitia=
lized in this function
>=20
> [ For these, I'd like to especially add -- shame on you, gcc! ]
>=20
> drivers/md/dm-table.c: In function =91dm_get_device=92:
> drivers/md/dm-table.c:472: warning: =91dev=92 may be used uninitializ=
ed in this function
>=20
> are all verified to be bogus warnings. Let's shut them up.
>=20
> ---
>=20
>  drivers/md/dm-exception-store.c |    3 ++-
>  drivers/md/dm-ioctl.c |    2 +-
>  drivers/md/dm-table.c |    2 +-
>  3 file changed, 4 insertions(+), 3 deletion(-)

same comment as with the last uninit'd var patch:  these markers should=
=20
be used sparingly.  Try it on multiple compiler versions, see if it's a=
=20
new behavior.

Quite realistically, you might actually be finding gcc bugs, implying=20
the proper path is to file a gcc bug report (and they are _very_=20
diligent about handling these, its impressive) rather than to patch the=
=20
Linux kernel.

Overall, for any uninitialized_var() patch, we need more info on=20
platform/compiler version/analysis methods/etc.

	Jeff
