From: Adam Hamsik <haaaad@gmail.com>
Subject: Re: libdevmapper patches
Date: Wed, 9 Jul 2008 12:56:21 +0200
Message-ID: <48897AC7-AC13-47EA-87B9-C0012BF4F4C1@gmail.com>
References: <9F196958-3293-4669-9032-ABC0E1F1ADAE@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v926)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9F196958-3293-4669-9032-ABC0E1F1ADAE@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

>
> Hi
>
> *** Please keep me on CC I'm not currently subscribed to this list.  
> ***
>
> I have updated my version of libdevmapper and extracted all my  
> changes from my local source tree.
>
> I have produced 5 patches they are located here [1].
>
> Small description of all patches:
>
> a)netbsd_libdevmapper.diff
> Adds new netbsd protocol file, and glue to parse and create dm-ioctl  
> structures from proplib dictionaries.
>
> b)makefiles.diff
> Changes needed to libdevmapper build system to properly build on  
> netbsd, linux.
>
> c)dmeventd.diff
> Small dmeventd diff which adds signal.h to NetBSD build.
>
> d)libdm-common-netbsd.diff
> Adds support for raw devices to device nodes manipulating routines.
>
> e)libdm-deptree-netbsd.diff
> Remove check for IS_BLK when we build libdevmapper on netbsd.
>
> [1]http://www.netbsd.org/~haad/libdevmapper/

I want to ask if there is any problem with my patches. I was not
able to find any response to it. I have fixed some bugs in my
version so I will upload new patches soon. lvcreate works
fine with them.

Is there anything what I can do to push these patches upstream ?

I have updated these patches to latest stable release and I'm
going to add also lvm2tools patches to this site.

I'm now in the middle of integration of libdevmapper and lvm2tools into
the NetBSD base source tree and I want to have as small differencies to
upstream in our base system as possible.

Regards

Adam.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)

iD8DBQFIdJlVlIxPgX3Go0MRAtERAKDfsArsb1ME382OSdq0R8XGn9WTUACg4kJu
s71ZXb3WyjL0pZ+thZg82CA=
=UoPj
-----END PGP SIGNATURE-----
