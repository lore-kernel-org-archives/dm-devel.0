From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: kobject_put vs module unload
Date: Sat, 8 Jan 2011 13:50:50 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1101081340250.1879@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1101072234040.382@hs20-bc2-1.build.redhat.com>
 <20110108055621.GB10391@suse.de> <Pine.LNX.4.64.1101080811400.29089@hs20-bc2-1.build.redhat.com>
 <AANLkTikg7vAG4-E=BD_sC=63R8fDCfEi_wiqnxDnUnK=@mail.gmail.com>
 <Pine.LNX.4.64.1101081258560.24933@hs20-bc2-1.build.redhat.com>
 <AANLkTi=hZ_W877QOwNK3=1-2S03VsKOXF_cVno_ReyrY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168436252-769775331-1294512650=:1879"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=hZ_W877QOwNK3=1-2S03VsKOXF_cVno_ReyrY@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168436252-769775331-1294512650=:1879
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 8 Jan 2011, Kay Sievers wrote:

> On Sat, Jan 8, 2011 at 19:01, Mikulas Patocka <mpatocka@redhat.com> wrote=
:
> > On Sat, 8 Jan 2011, Kay Sievers wrote:
> >> On Sat, Jan 8, 2011 at 14:19, Mikulas Patocka <mpatocka@redhat.com> wr=
ote:
> >> > On Fri, 7 Jan 2011, Greg KH wrote:
> >>
> >> >> > 4) the reference obtained at point 1) is dropped, kobject referen=
ce count
> >> >> > reaches zero and the release callback is called. But that callbac=
k points
> >> >> > to an unloaded module and causes a crash.
> >> >> >
> >> >> > How is it solved? Am I missing something?
> >> >>
> >> >> You have the code that creates and frees the object, to not be in t=
he
> >> >> module that could have been unloaded. =C2=A0It's really just that s=
imple.
> >> >
> >> > If the whole device mapper subsystem can be a module, where can I pu=
t the
> >> > code?
> >> >
> >> > I think a similar bug exists in md, it can also be unloaded as a mod=
ule
> >> > and it has "release" method in its module code.
> >>
> >> If you still have data structures hanging around, these structures are
> >> supposed to take a reference on the module -- and you can not unload
> >> the module as long as this is the case.
> >>
> >> Kay
> >
> > kobject references don't increase module reference count. If kobject he=
ld
> > module references, it would be a fix for this bug, but could cause othe=
r
> > bugs (some modules could be unloadable due to self-references to its ow=
n
> > kobjects).
>=20
> Sure, they don't automatically take references. It's the job of the
> driver/module, to make sure to pin the module for any data of it,
> which might be still in use.
>=20
> Kay

A module can't unpin itself. If it does, the module can be unloaded=20
immediatelly after module_put(THIS_MODULE) call and the function that=20
called module_put crashes.

A module must be unpinned by someone else. The question is: who unpins the=
=20
module when kobject references are gone?

Mikulas
--168436252-769775331-1294512650=:1879--
