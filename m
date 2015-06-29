From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: reinstate path not working
Date: Mon, 29 Jun 2015 14:20:12 -0500
Message-ID: <20150629192012.GO1409@octiron.msp.redhat.com>
References: <20150518162747.GE8491@octiron.msp.redhat.com>
	<CAH=b03t3QGuHM_x-eQTGZRkpYsAmOT4yMRCPQhp-smWM6ZXRhw@mail.gmail.com>
	<CAH=b03v=haA-5A=Vj1EhDVnhDePAZ5u=UaWdhW7zQxGcS8hV2Q@mail.gmail.com>
	<20150605220649.GD2754@octiron.msp.redhat.com>
	<CAH=b03vRNbV0oFze-s__SMb8cDJh5VYQ3uS9OpMhHoRxZhBN=w@mail.gmail.com>
	<CAH=b03tj_EZvAh5v1OG3jhubyhQnkaN=gJsGVsjrjJMQm990zQ@mail.gmail.com>
	<20150611205149.GA1409@octiron.msp.redhat.com>
	<CAH=b03trc-vMz_O0z5Qr7bSL9R+cgFG3pZfmhFufASaUMQO=qw@mail.gmail.com>
	<20150625230244.GN1409@octiron.msp.redhat.com>
	<CAH=b03uPbi4XAFPGNQxjmsyGN2HRWUef0BSEE+HPsVhGwnXhVg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAH=b03uPbi4XAFPGNQxjmsyGN2HRWUef0BSEE+HPsVhGwnXhVg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejaswini Poluri <tejaswinipoluri3@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Jun 26, 2015 at 12:21:48PM +0530, Tejaswini Poluri wrote:
>    Yes I agree that having the same code in both cli_add_map() and ev_add=
_map
>    is not necessary. Hence I would suggest removing get_refwwid() code fr=
om
>    ev_add_map as it is not being used by anyone.
> =

>    ev_add_map(param, NULL, vecs) would create the multipath device by usi=
ng
>    the get_refwwid() code and but all the functions above it like
>    (dm_get_minor, dm_get_major and dm_mapname) would fail and it wouldn't
>    enter any of the other code in ev_add_map like
>    1.dm_map_present,
>    2.add_map_without_path
>    3. sync_map_state
>    which are responsible for registering the map and displaying it.
> =

>    So, I think moving the below code from ev_add_map to cli_add_map shoul=
d be
>    a good idea right.
> =

>    r =3D get_refwwid(dev, DEV_DEVMAP, vecs->pathvec,&refwwid);
>    >
>    >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0 if (refwwid) {
>    >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 r =3D coalesce_=
paths(vecs, NULL, refwwid,0);
>    >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dm_lib_release(=
);
>    >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0 }
>    What do u think?

I agree. We aren't using the code in ev_add_map, so it's presence there
is simply confusing.

-Ben

> =

>    Regards,
>    Tejaswini
>    On Fri, Jun 26, 2015 at 4:32 AM, Benjamin Marzinski
>    <[1]bmarzins@redhat.com> wrote:
> =

>      On Tue, Jun 23, 2015 at 03:48:26PM +0530, Tejaswini Poluri wrote:
>      >=A0 =A0 Hi Ben,
>      >
>      >=A0 =A0 This is regarding the add map issue I have been discussing.=
 Posting
>      the
>      >=A0 =A0 issue again to remind.
>      >
>      >=A0 =A0 Case 1 : remove and add map.
>      >=A0 =A0 root@x86-generic-64:~# multipathd -k'show maps'
>      >=A0 =A0 name=A0=A0=A0 sysfs uuid
>      >=A0 =A0 dmpath0 dm-0=A0 1IET_00010001
>      >=A0 =A0 root@x86-generic-64:~# multipathd -k'remove map dmpath0'
>      >=A0 =A0 ok
>      >=A0 =A0 root@x86-generic-64:~# multipathd -k'show maps'
>      >=A0 =A0 root@x86-generic-64:~# multipathd -k'add map dmpath0'
>      >=A0 =A0 ok
>      >=A0 =A0 root@x86-generic-64:~# multipathd -k'show maps'
>      >=A0 =A0 root@x86-generic-64:~#
>      >=A0 =A0 Once a map is removed, we are able to add it only using #mu=
ltipath=A0
>      >=A0 =A0 command and not using multipathd tools.
>      >
>      >=A0 =A0 I have fixed the problem with two approaches. I would like =
you to
>      review
>      >=A0 =A0 the same.
>      >=A0 =A0 Patch1 : By making 'remove map dmpath0' to remove only the =
map and
>      not the
>      >=A0 =A0 device. I have added extra functions discard_map and dm_rem=
ove_map
>      so as
>      >=A0 =A0 to not interfere with the existing code.
>      >
>      >=A0 =A0 Patch 2: The approach you have suggested.By getting wwid fr=
om the
>      mapname
>      >=A0 =A0 and doing coalesce_paths. I have just moved the following c=
ode in
>      >=A0 =A0 ev_add_map to cli_add_map.
> =

>      This is the general idea we'd like to go with.=A0 However, looking a=
t the
>      latest upstream code, I don't think you should pull code in from
>      ev_add_map() to cli_add_map() like your patch does. cli_add_map()
>      already calls ev_add_map(), and ev_add_map() is certainly able to add
>      the map if it doesn't already exist.
> =

>      You would just need to call it with
> =

>      ev_add_map(param, NULL, vecs);
> =

>      and ev_add_map() will happily create you a new multipath device.=A0 =
All
>      you need to do is make sure that all the functions that ev_add_map()
>      calls with alias can accept a NULL value there.
> =

>      This might not be the best way to go about this, however.=A0 It turn=
s out
>      that right now, even though ev_add_map() technically has the ability=
 to
>      create new maps, nothing currently uses it, and it really doesn't ma=
ke
>      sense for it to be there. Instead of just copying that code, you cou=
ld
>      pull the map creation code out of ev_add_map() and add it to
>      cli_add_map(), for those situations where the requested device doesn=
't
>      already exist.
> =

>      But having the code in both cli_add_map() and ev_add_map() when one
>      already calls the other doesn't seem necessary.
> =

>      -Ben
> =

>      >
>      >=A0 =A0 r =3D get_refwwid(dev, DEV_DEVMAP, vecs->pathvec,&refwwid);
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0 if (refwwid) {
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 r =3D coalesc=
e_paths(vecs, NULL, refwwid,0);
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dm_lib_releas=
e();
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0 }
>      >
>      >=A0 =A0 changed dev to param.
>      >
>      >=A0 =A0 I have tested the same in all 3 versions -0.4.8, 0.4.9 and =
0.5.0.
>      It would
>      >=A0 =A0 be great if you can review the same so that it doesn't caus=
e any
>      extra
>      >=A0 =A0 side effects.
>      >=A0 =A0 I guess Patch2 is the way u have suggested me in the previo=
us mail.
>      Please
>      >=A0 =A0 review it and share your views.
>      >=A0 =A0 Regards,
>      >=A0 =A0 Tejaswini
>      >=A0 =A0 On Fri, Jun 12, 2015 at 2:21 AM, Benjamin Marzinski
>      >=A0 =A0 <[1][2]bmarzins@redhat.com> wrote:
>      >
>      >=A0 =A0 =A0 On Wed, Jun 10, 2015 at 11:46:51AM +0530, Tejaswini Pol=
uri wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 We are testing multipathd tools with =
all the possible
>      options
>      >=A0 =A0 =A0 and the
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 following fails.
>      >=A0 =A0 =A0 >=A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 Case 1 : remove and add map.
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'=
show maps'
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 name=A0=A0=A0 sysfs uuid
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 dmpath0 dm-0=A0 1IET_00010001
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'=
remove map
>      dmpath0'
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'=
show maps'
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'=
add map dmpath0'
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'=
show maps'
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-generic-64:~#
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 Once a map is removed, we are able to=
 add it only using
>      >=A0 =A0 =A0 #multipath=A0
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 command and not using multipathd tool=
s.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 It is working the way it was designed, but pos=
sibly it would
>      make
>      >=A0 =A0 =A0 sense
>      >=A0 =A0 =A0 >=A0 =A0 to change the design.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 You have mentioned that it would make sense to=
 change the
>      design to
>      >=A0 =A0 =A0 add
>      >=A0 =A0 =A0 >=A0 =A0 map. Are there plans to change the design ?
>      >=A0 =A0 =A0 >=A0 =A0 I am trying to understand the code flow to cha=
nge the
>      design. Can
>      >=A0 =A0 =A0 you
>      >=A0 =A0 =A0 >=A0 =A0 guide me if we should stop removing the device=
 from in the
>      remove
>      >=A0 =A0 =A0 map code
>      >=A0 =A0 =A0 >=A0 =A0 flow or start adding the device and the map in=
 the add map
>      code
>      >=A0 =A0 =A0 flow.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0have tried to understand the remove map cod=
e flow of
>      multipathd in
>      >=A0 =A0 =A0 0.4.8
>      >=A0 =A0 =A0 >=A0 =A0 code.
>      >
>      >=A0 =A0 =A0 I think that we want multipath to actually remove the m=
ap
>      (instead of
>      >=A0 =A0 =A0 just not monitoring it) when you call "remove map <map>=
". We just
>      want
>      >=A0 =A0 =A0 "add map <map>" to try to create the map if it doesn't =
exist.=A0 To
>      do
>      >=A0 =A0 =A0 that, you would need to first firgure out what WWID is =
associated
>      with
>      >=A0 =A0 =A0 <map>. Presumably, <map> could either be an alias, wwid=
, or even
>      the
>      >=A0 =A0 =A0 name of a path in the map. Once you found the map, you =
would have
>      to
>      >=A0 =A0 =A0 call the code to create the map.
>      >
>      >=A0 =A0 =A0 Also, to answer your IRC question, no the 0.4.8 code is=
 not still
>      being
>      >=A0 =A0 =A0 developed upstream.=A0 All upstream patches only go aga=
inst the
>      current
>      >=A0 =A0 =A0 head. There are no other upstream branches.
>      >
>      >=A0 =A0 =A0 -Ben
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 ev_remove_map (char * devname, struct vectors =
* vecs)
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0 flush_map(mpp, vec=
s);
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0=A0=A0=A0=A0=A0 dm_flush_map(mpp->alias,
>      DEFAULT_TARGET);
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if
>      (!dm_map_present(mapname))
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0 =A0=A0 =A0=A0 return 0;
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 if (dm_type(mapname, type) =
<=3D 0)
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret=
urn 1;
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 if (dm_remove_partmaps(mapn=
ame))
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret=
urn 1;
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 if (dm_get_opencount(mapnam=
e)) {
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con=
dlog(2, "%s: map in use", mapname);
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret=
urn 1;
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 } =A0=A0=A0=A0=A0
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 r =3D dm_simplecmd(DM_DEVIC=
E_REMOVE, mapname);
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 if (r) {
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con=
dlog(4, "multipath map %s removed",
>      mapname);
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0=A0 =A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 return 0;
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 orphan_paths(vecs->pathvec, mpp);
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 remove_map(mpp, vecs,
>      stop_waiter_thread,
>      >=A0 =A0 =A0 1);
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 Is removing this below line, the right step to=
 stop removing
>      the
>      >=A0 =A0 =A0 device ?
>      >=A0 =A0 =A0 >=A0 =A0 r =3D dm_simplecmd(DM_DEVICE_REMOVE, mapname);
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 Regards,
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 Tejaswini
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 On Mon, Jun 8, 2015 at 11:15 AM, Tejaswini Pol=
uri
>      >=A0 =A0 =A0 >=A0 =A0 <[1][2][3]tejaswinipoluri3@gmail.com> wrote:
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 Thanks a lot Ben for the quick and detaile=
d reply. I have
>      been
>      >=A0 =A0 =A0 >=A0 =A0 =A0 struggling to understand and conclude the =
issues with
>      multipath
>      >=A0 =A0 =A0 as I am
>      >=A0 =A0 =A0 >=A0 =A0 =A0 the only one working from my team. Your in=
puts help me a
>      lot.
>      >=A0 =A0 =A0 Thanks
>      >=A0 =A0 =A0 >=A0 =A0 =A0 again.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 Regards,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 Tejaswini
>      >=A0 =A0 =A0 >=A0 =A0 =A0 On Sat, Jun 6, 2015 at 3:36 AM, Benjamin M=
arzinski
>      >=A0 =A0 =A0 >=A0 =A0 =A0 <[2][3][4]bmarzins@redhat.com> wrote:
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 On Fri, Jun 05, 2015 at 02:31:20PM +05=
30, Tejaswini
>      Poluri
>      >=A0 =A0 =A0 wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Hii Ben,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 We are testing multipathd too=
ls with all the
>      possible
>      >=A0 =A0 =A0 options and
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 following fails.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Case 1 : remove and add map.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multip=
athd -k'show maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 name=A0=A0=A0 sysfs uuid
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 dmpath0 dm-0=A0 1IET_00010001
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multip=
athd -k'remove map
>      dmpath0'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multip=
athd -k'show maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multip=
athd -k'add map
>      dmpath0'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multip=
athd -k'show maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~#
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Once a map is removed, we are=
 able to add it only
>      using
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 #multipath=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 command and not using multipa=
thd tools.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 It is working the way it was designed,=
 but possibly it
>      would
>      >=A0 =A0 =A0 make
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 sense
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 to change the design.=A0 The "remove m=
ap" command, not
>      only stops
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 multipathd from monitoring the multipa=
th device, but it
>      removes
>      >=A0 =A0 =A0 it
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 from
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 the system as well.=A0 The "add map" c=
ommand makes
>      multipath
>      >=A0 =A0 =A0 monitor an
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 already existing multipath device that=
 in wasn't
>      previously
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 monitoring.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 These commands do this for historical =
reasons.=A0
>      multipathd
>      >=A0 =A0 =A0 wasn't
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 originally in charge of creating multi=
path devices,
>      multipath
>      >=A0 =A0 =A0 was.=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 Once
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 it had created the device, it ran
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 multipathd -k"add map <MAP>"
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 to make multipathd start monitoring it=
.=A0 However things
>      haven't
>      >=A0 =A0 =A0 worked
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 this way since RHEL4, so possibly "add=
 map" should
>      actually
>      >=A0 =A0 =A0 create the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 device if it doesn't currently exist.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Case 2 : Active paths=A0 test=
 case
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 # while true ; do sleep 3 ; m=
ultipathd -k'remove
>      path sdb'
>      >=A0 =A0 =A0 ;
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 multipathd
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 -k'add path sdb' ; multipathd=
 -k'show maps status'
>      ; done
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 name failback queueing paths =
dm-st
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 dmpath0 - - 1 active // It sh=
ould be 2.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 This is simply a timing issue.=A0 What=
 you are seeing it
>      the
>      >=A0 =A0 =A0 number of
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 active paths.=A0 These are paths that =
the kernel can use.
>      The
>      >=A0 =A0 =A0 "add path"
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 command doesn't update the kernel stat=
e.=A0 This happens
>      later in
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 response
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 to the kernel reloading the device tab=
le. So, in a
>      second or
>      >=A0 =A0 =A0 two, this
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 will say 2, as expected.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 We would like to know if the =
test cases are valid
>      and if
>      >=A0 =A0 =A0 these
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 are bugs or
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 any design issues.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Case 3 : Fail path and reinst=
ate path
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multip=
athd -k"fail path
>      sdc";
>      >=A0 =A0 =A0 multipathd
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 -k'reinstate path sdc'; multi=
pathd -k"show paths";
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 [ 3962.708523] dev=
ice-mapper: multipath:
>      Failing path
>      >=A0 =A0 =A0 8:32.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 hcil=A0=A0=A0 dev =
dev_t pri dm_st=A0=A0 chk_st=A0=A0
>      next_check
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 4:0:0:1 sdc 8:32=
=A0 1=A0=A0 [active][faulty]
>      ..........
>      >=A0 =A0 =A0 1/20=A0=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 <=3D=3DCHECK
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 5:0:0:1 sdd 8:48=
=A0 1=A0=A0 [active][ready]=A0
>      XX........
>      >=A0 =A0 =A0 4/20
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 sdc path becomes [active][rea=
dy] only after the
>      polling
>      >=A0 =A0 =A0 interval
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 but not
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 immediately after the reinsta=
te path command.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 You have answered that this i=
s a design issue. But
>      we have
>      >=A0 =A0 =A0 heard
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 from our
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 test team that the same test =
case works in RHEL6.
>      Did you
>      >=A0 =A0 =A0 observe
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 it?
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 I am also finding that the te=
st cases fail because
>      we are
>      >=A0 =A0 =A0 trying
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 to do
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 multiple commands at one shot=
.=A0 Please share your
>      thoughts
>      >=A0 =A0 =A0 so
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 that it
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 could help me in debugging th=
e issues further.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 It's totally possible that the checker=
 state is
>      immediately
>      >=A0 =A0 =A0 updated in
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 RHEL6.=A0 Like I said before, what it =
currently does,
>      although
>      >=A0 =A0 =A0 correct,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 is confusing, and perhaps we need a di=
fferent checker
>      state for
>      >=A0 =A0 =A0 paths
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 where the "fail path" command has been=
 used.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 -Ben
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Regards,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Tejaswini
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 On Tue, May 19, 2015 at 5:37 =
PM, Tejaswini Poluri
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 <[1][3][4][5]tejaswinipoluri3=
@gmail.com> wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 Thanks a lot Ben. I will =
look into it more.=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 On Mon, May 18, 2015 at 9=
:57 PM, Benjamin
>      Marzinski
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 <[2][4][5][6]bmarzins@red=
hat.com> wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 On Mon, May 18, 2015 =
at 02:09:27PM +0530,
>      Tejaswini
>      >=A0 =A0 =A0 Poluri
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Hii,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 We are tryin=
g to test multipath setup in
>      our
>      >=A0 =A0 =A0 target and
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 tried the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 various
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 commands of =
multipathd demaon and we find
>      the
>      >=A0 =A0 =A0 following
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 error:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-gen=
eric-64:~# multipathd -k"fail
>      path
>      >=A0 =A0 =A0 sdc";
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 multipathd
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 -k'reinstate=
 path
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 sdc'; multip=
athd -k"show paths";
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 [ 3962.70852=
3] device-mapper: multipath:
>      Failing
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 path=A08:32.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 hcil=A0 =A0 =
dev dev_t pri dm_st=A0 =A0chk_st=A0
>      =A0next_check
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 4:0:0:1 sdc=
=A08:32=A0 1=A0 =A0[active][faulty]
>      ..........
>      >=A0 =A0 =A0 1/20=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 =A0 <<<=3D=3D=3D
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 CHECK
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 5:0:0:1 sdd=
=A08:48=A0 1=A0 =A0[active][ready]=A0
>      XX........
>      >=A0 =A0 =A0 4/20
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 sdc path bec=
omes [active][ready] only
>      after the
>      >=A0 =A0 =A0 polling
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 interval
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 but not
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 immediately =
after the reinstate path
>      command.=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 I am observi=
ng this in latest multipath
>      tools in
>      >=A0 =A0 =A0 ubuntu
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 machine
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 as well.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Please let m=
e know if its a known issue or
>      if I
>      >=A0 =A0 =A0 am doing
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 something wrong.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Regards.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Tejaswini
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 the reinstate command=
 is supposed to reinstate
>      the
>      >=A0 =A0 =A0 device
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 with the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 kernel, and it does t=
hat. The checker state
>      doesn't
>      >=A0 =A0 =A0 change
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 until the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 next time that the pa=
th is checked.=A0 I agree
>      that it's
>      >=A0 =A0 =A0 odd
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 that the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 check state switches =
to faulty as soon as you
>      fail the
>      >=A0 =A0 =A0 path,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 but it
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 doesn't switch back u=
ntil the next check after
>      you
>      >=A0 =A0 =A0 reinistate
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 it.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 The issue is that mul=
tipathd needs to override
>      the
>      >=A0 =A0 =A0 checker
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 output,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 so that a failed path=
 won't be immeditately
>      >=A0 =A0 =A0 reinstated.=A0 Once
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 path comes back, mult=
ipathd wants to record the
>      switch
>      >=A0 =A0 =A0 in the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 checker
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 thread, so that it ca=
n refresh path information
>      what
>      >=A0 =A0 =A0 wasn't
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 automatically done wh=
en the path was
>      reinstated.=A0
>      >=A0 =A0 =A0 However, it
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 may make
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 more sense to have a =
different checker state
>      for when
>      >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 device is
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 in the failed state, =
so that it's obvious that
>      the
>      >=A0 =A0 =A0 checker
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 state is
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 being overruled.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 -Ben
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 > --
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 > dm-devel mailing li=
st
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 > [3][5][6][7]dm-deve=
l@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 [4][6][7][8]https://www.redhat.com/mailman/listinfo/dm-=
devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 --
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 dm-devel mailing list
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 [5][7][8][9]dm-devel@=
redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0
>      >=A0 =A0 =A0 [6][8][9][10]https://www.redhat.com/mailman/listinfo/dm=
-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 > References
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Visible links
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 1. mailto:[9][10][11]tejaswin=
ipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 2. mailto:[10][11][12]bmarzin=
s@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 3. mailto:[11][12][13]dm-deve=
l@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 4.
>      >=A0 =A0 =A0 [12][13][14]https://www.redhat.com/mailman/listinfo/dm-=
devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 5. mailto:[13][14][15]dm-deve=
l@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 6.
>      >=A0 =A0 =A0 [14][15][16]https://www.redhat.com/mailman/listinfo/dm-=
devel
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 > References
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 Visible links
>      >=A0 =A0 =A0 >=A0 =A0 1. mailto:[16][17]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 2. mailto:[17][18]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 3. mailto:[18][19]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 4. mailto:[19][20]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 5. mailto:[20][21]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 6. [21][22]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 7. mailto:[22][23]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 8. [23][24]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 9. mailto:[24][25]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A010. mailto:[25][26]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A011. mailto:[26][27]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A012. [27][28]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A013. mailto:[28][29]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A014. [29][30]https://www.redhat.com/mailman/list=
info/dm-devel
>      >
>      > References
>      >
>      >=A0 =A0 Visible links
>      >=A0 =A0 1. mailto:[31]bmarzins@redhat.com
>      >=A0 =A0 2. mailto:[32]tejaswinipoluri3@gmail.com
>      >=A0 =A0 3. mailto:[33]bmarzins@redhat.com
>      >=A0 =A0 4. mailto:[34]tejaswinipoluri3@gmail.com
>      >=A0 =A0 5. mailto:[35]bmarzins@redhat.com
>      >=A0 =A0 6. mailto:[36]dm-devel@redhat.com
>      >=A0 =A0 7. [37]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 8. mailto:[38]dm-devel@redhat.com
>      >=A0 =A0 9. [39]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A010. mailto:[40]tejaswinipoluri3@gmail.com
>      >=A0 =A011. mailto:[41]bmarzins@redhat.com
>      >=A0 =A012. mailto:[42]dm-devel@redhat.com
>      >=A0 =A013. [43]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A014. mailto:[44]dm-devel@redhat.com
>      >=A0 =A015. [45]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A016. mailto:[46]tejaswinipoluri3@gmail.com
>      >=A0 =A017. mailto:[47]bmarzins@redhat.com
>      >=A0 =A018. mailto:[48]tejaswinipoluri3@gmail.com
>      >=A0 =A019. mailto:[49]bmarzins@redhat.com
>      >=A0 =A020. mailto:[50]dm-devel@redhat.com
>      >=A0 =A021. [51]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A022. mailto:[52]dm-devel@redhat.com
>      >=A0 =A023. [53]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A024. mailto:[54]tejaswinipoluri3@gmail.com
>      >=A0 =A025. mailto:[55]bmarzins@redhat.com
>      >=A0 =A026. mailto:[56]dm-devel@redhat.com
>      >=A0 =A027. [57]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A028. mailto:[58]dm-devel@redhat.com
>      >=A0 =A029. [59]https://www.redhat.com/mailman/listinfo/dm-devel
> =

> References
> =

>    Visible links
>    1. mailto:bmarzins@redhat.com
>    2. mailto:bmarzins@redhat.com
>    3. mailto:tejaswinipoluri3@gmail.com
>    4. mailto:bmarzins@redhat.com
>    5. mailto:tejaswinipoluri3@gmail.com
>    6. mailto:bmarzins@redhat.com
>    7. mailto:dm-devel@redhat.com
>    8. https://www.redhat.com/mailman/listinfo/dm-devel
>    9. mailto:dm-devel@redhat.com
>   10. https://www.redhat.com/mailman/listinfo/dm-devel
>   11. mailto:tejaswinipoluri3@gmail.com
>   12. mailto:bmarzins@redhat.com
>   13. mailto:dm-devel@redhat.com
>   14. https://www.redhat.com/mailman/listinfo/dm-devel
>   15. mailto:dm-devel@redhat.com
>   16. https://www.redhat.com/mailman/listinfo/dm-devel
>   17. mailto:tejaswinipoluri3@gmail.com
>   18. mailto:bmarzins@redhat.com
>   19. mailto:tejaswinipoluri3@gmail.com
>   20. mailto:bmarzins@redhat.com
>   21. mailto:dm-devel@redhat.com
>   22. https://www.redhat.com/mailman/listinfo/dm-devel
>   23. mailto:dm-devel@redhat.com
>   24. https://www.redhat.com/mailman/listinfo/dm-devel
>   25. mailto:tejaswinipoluri3@gmail.com
>   26. mailto:bmarzins@redhat.com
>   27. mailto:dm-devel@redhat.com
>   28. https://www.redhat.com/mailman/listinfo/dm-devel
>   29. mailto:dm-devel@redhat.com
>   30. https://www.redhat.com/mailman/listinfo/dm-devel
>   31. mailto:bmarzins@redhat.com
>   32. mailto:tejaswinipoluri3@gmail.com
>   33. mailto:bmarzins@redhat.com
>   34. mailto:tejaswinipoluri3@gmail.com
>   35. mailto:bmarzins@redhat.com
>   36. mailto:dm-devel@redhat.com
>   37. https://www.redhat.com/mailman/listinfo/dm-devel
>   38. mailto:dm-devel@redhat.com
>   39. https://www.redhat.com/mailman/listinfo/dm-devel
>   40. mailto:tejaswinipoluri3@gmail.com
>   41. mailto:bmarzins@redhat.com
>   42. mailto:dm-devel@redhat.com
>   43. https://www.redhat.com/mailman/listinfo/dm-devel
>   44. mailto:dm-devel@redhat.com
>   45. https://www.redhat.com/mailman/listinfo/dm-devel
>   46. mailto:tejaswinipoluri3@gmail.com
>   47. mailto:bmarzins@redhat.com
>   48. mailto:tejaswinipoluri3@gmail.com
>   49. mailto:bmarzins@redhat.com
>   50. mailto:dm-devel@redhat.com
>   51. https://www.redhat.com/mailman/listinfo/dm-devel
>   52. mailto:dm-devel@redhat.com
>   53. https://www.redhat.com/mailman/listinfo/dm-devel
>   54. mailto:tejaswinipoluri3@gmail.com
>   55. mailto:bmarzins@redhat.com
>   56. mailto:dm-devel@redhat.com
>   57. https://www.redhat.com/mailman/listinfo/dm-devel
>   58. mailto:dm-devel@redhat.com
>   59. https://www.redhat.com/mailman/listinfo/dm-devel
