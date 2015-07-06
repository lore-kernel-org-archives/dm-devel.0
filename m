From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: reinstate path not working
Date: Mon, 6 Jul 2015 12:45:15 -0500
Message-ID: <20150706174515.GP1409@octiron.msp.redhat.com>
References: <CAH=b03v=haA-5A=Vj1EhDVnhDePAZ5u=UaWdhW7zQxGcS8hV2Q@mail.gmail.com>
	<20150605220649.GD2754@octiron.msp.redhat.com>
	<CAH=b03vRNbV0oFze-s__SMb8cDJh5VYQ3uS9OpMhHoRxZhBN=w@mail.gmail.com>
	<CAH=b03tj_EZvAh5v1OG3jhubyhQnkaN=gJsGVsjrjJMQm990zQ@mail.gmail.com>
	<20150611205149.GA1409@octiron.msp.redhat.com>
	<CAH=b03trc-vMz_O0z5Qr7bSL9R+cgFG3pZfmhFufASaUMQO=qw@mail.gmail.com>
	<20150625230244.GN1409@octiron.msp.redhat.com>
	<CAH=b03uPbi4XAFPGNQxjmsyGN2HRWUef0BSEE+HPsVhGwnXhVg@mail.gmail.com>
	<20150629192012.GO1409@octiron.msp.redhat.com>
	<CAH=b03sF=a8DbbspoxNYkzJaBDSCxV-sG6b4W0rN1GAxJtKDhg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAH=b03sF=a8DbbspoxNYkzJaBDSCxV-sG6b4W0rN1GAxJtKDhg@mail.gmail.com>
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

On Tue, Jun 30, 2015 at 11:22:37AM +0530, Tejaswini Poluri wrote:
>    Thanks Ben. So should I push the code to the upstream and get an appro=
val?
>    Regards,

Yes. Thanks!

-Ben

>    Tejaswini
>    On Tue, Jun 30, 2015 at 12:50 AM, Benjamin Marzinski
>    <[1]bmarzins@redhat.com> wrote:
> =

>      On Fri, Jun 26, 2015 at 12:21:48PM +0530, Tejaswini Poluri wrote:
>      >=A0 =A0 Yes I agree that having the same code in both cli_add_map()=
 and
>      ev_add_map
>      >=A0 =A0 is not necessary. Hence I would suggest removing get_refwwi=
d() code
>      from
>      >=A0 =A0 ev_add_map as it is not being used by anyone.
>      >
>      >=A0 =A0 ev_add_map(param, NULL, vecs) would create the multipath de=
vice by
>      using
>      >=A0 =A0 the get_refwwid() code and but all the functions above it l=
ike
>      >=A0 =A0 (dm_get_minor, dm_get_major and dm_mapname) would fail and =
it
>      wouldn't
>      >=A0 =A0 enter any of the other code in ev_add_map like
>      >=A0 =A0 1.dm_map_present,
>      >=A0 =A0 2.add_map_without_path
>      >=A0 =A0 3. sync_map_state
>      >=A0 =A0 which are responsible for registering the map and displayin=
g it.
>      >
>      >=A0 =A0 So, I think moving the below code from ev_add_map to cli_ad=
d_map
>      should be
>      >=A0 =A0 a good idea right.
>      >
>      >=A0 =A0 r =3D get_refwwid(dev, DEV_DEVMAP, vecs->pathvec,&refwwid);
>      >=A0 =A0 >
>      >=A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0 if (refwwid) {
>      >=A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 r =
=3D coalesce_paths(vecs, NULL, refwwid,0);
>      >=A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dm_l=
ib_release();
>      >=A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0 }
>      >=A0 =A0 What do u think?
> =

>      I agree. We aren't using the code in ev_add_map, so it's presence th=
ere
>      is simply confusing.
> =

>      -Ben
>      >
>      >=A0 =A0 Regards,
>      >=A0 =A0 Tejaswini
>      >=A0 =A0 On Fri, Jun 26, 2015 at 4:32 AM, Benjamin Marzinski
>      >=A0 =A0 <[1][2]bmarzins@redhat.com> wrote:
>      >
>      >=A0 =A0 =A0 On Tue, Jun 23, 2015 at 03:48:26PM +0530, Tejaswini Pol=
uri wrote:
>      >=A0 =A0 =A0 >=A0 =A0 Hi Ben,
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 This is regarding the add map issue I have bee=
n discussing.
>      Posting
>      >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 issue again to remind.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 Case 1 : remove and add map.
>      >=A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'show maps'
>      >=A0 =A0 =A0 >=A0 =A0 name=A0=A0=A0 sysfs uuid
>      >=A0 =A0 =A0 >=A0 =A0 dmpath0 dm-0=A0 1IET_00010001
>      >=A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'remove ma=
p dmpath0'
>      >=A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'show maps'
>      >=A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'add map d=
mpath0'
>      >=A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'show maps'
>      >=A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~#
>      >=A0 =A0 =A0 >=A0 =A0 Once a map is removed, we are able to add it o=
nly using
>      #multipath=A0
>      >=A0 =A0 =A0 >=A0 =A0 command and not using multipathd tools.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 I have fixed the problem with two approaches. =
I would like
>      you to
>      >=A0 =A0 =A0 review
>      >=A0 =A0 =A0 >=A0 =A0 the same.
>      >=A0 =A0 =A0 >=A0 =A0 Patch1 : By making 'remove map dmpath0' to rem=
ove only the
>      map and
>      >=A0 =A0 =A0 not the
>      >=A0 =A0 =A0 >=A0 =A0 device. I have added extra functions discard_m=
ap and
>      dm_remove_map
>      >=A0 =A0 =A0 so as
>      >=A0 =A0 =A0 >=A0 =A0 to not interfere with the existing code.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 Patch 2: The approach you have suggested.By ge=
tting wwid
>      from the
>      >=A0 =A0 =A0 mapname
>      >=A0 =A0 =A0 >=A0 =A0 and doing coalesce_paths. I have just moved th=
e following
>      code in
>      >=A0 =A0 =A0 >=A0 =A0 ev_add_map to cli_add_map.
>      >
>      >=A0 =A0 =A0 This is the general idea we'd like to go with.=A0 Howev=
er, looking
>      at the
>      >=A0 =A0 =A0 latest upstream code, I don't think you should pull cod=
e in from
>      >=A0 =A0 =A0 ev_add_map() to cli_add_map() like your patch does. cli=
_add_map()
>      >=A0 =A0 =A0 already calls ev_add_map(), and ev_add_map() is certain=
ly able to
>      add
>      >=A0 =A0 =A0 the map if it doesn't already exist.
>      >
>      >=A0 =A0 =A0 You would just need to call it with
>      >
>      >=A0 =A0 =A0 ev_add_map(param, NULL, vecs);
>      >
>      >=A0 =A0 =A0 and ev_add_map() will happily create you a new multipat=
h device.=A0
>      All
>      >=A0 =A0 =A0 you need to do is make sure that all the functions that
>      ev_add_map()
>      >=A0 =A0 =A0 calls with alias can accept a NULL value there.
>      >
>      >=A0 =A0 =A0 This might not be the best way to go about this, howeve=
r.=A0 It
>      turns out
>      >=A0 =A0 =A0 that right now, even though ev_add_map() technically ha=
s the
>      ability to
>      >=A0 =A0 =A0 create new maps, nothing currently uses it, and it real=
ly doesn't
>      make
>      >=A0 =A0 =A0 sense for it to be there. Instead of just copying that =
code, you
>      could
>      >=A0 =A0 =A0 pull the map creation code out of ev_add_map() and add =
it to
>      >=A0 =A0 =A0 cli_add_map(), for those situations where the requested=
 device
>      doesn't
>      >=A0 =A0 =A0 already exist.
>      >
>      >=A0 =A0 =A0 But having the code in both cli_add_map() and ev_add_ma=
p() when
>      one
>      >=A0 =A0 =A0 already calls the other doesn't seem necessary.
>      >
>      >=A0 =A0 =A0 -Ben
>      >
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 r =3D get_refwwid(dev, DEV_DEVMAP, vecs->pathv=
ec,&refwwid);
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0 if (refwwid) {
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
r =3D coalesce_paths(vecs, NULL, refwwid,0);
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
dm_lib_release();
>      >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0 }
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 changed dev to param.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 I have tested the same in all 3 versions -0.4.=
8, 0.4.9 and
>      0.5.0.
>      >=A0 =A0 =A0 It would
>      >=A0 =A0 =A0 >=A0 =A0 be great if you can review the same so that it=
 doesn't cause
>      any
>      >=A0 =A0 =A0 extra
>      >=A0 =A0 =A0 >=A0 =A0 side effects.
>      >=A0 =A0 =A0 >=A0 =A0 I guess Patch2 is the way u have suggested me =
in the
>      previous mail.
>      >=A0 =A0 =A0 Please
>      >=A0 =A0 =A0 >=A0 =A0 review it and share your views.
>      >=A0 =A0 =A0 >=A0 =A0 Regards,
>      >=A0 =A0 =A0 >=A0 =A0 Tejaswini
>      >=A0 =A0 =A0 >=A0 =A0 On Fri, Jun 12, 2015 at 2:21 AM, Benjamin Marz=
inski
>      >=A0 =A0 =A0 >=A0 =A0 <[1][2][3]bmarzins@redhat.com> wrote:
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 On Wed, Jun 10, 2015 at 11:46:51AM +0530, =
Tejaswini Poluri
>      wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 We are testing multipath=
d tools with all the
>      possible
>      >=A0 =A0 =A0 options
>      >=A0 =A0 =A0 >=A0 =A0 =A0 and the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 following fails.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 Case 1 : remove and add =
map.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-generic-64:~# m=
ultipathd -k'show maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 name=A0=A0=A0 sysfs uuid
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 dmpath0 dm-0=A0 1IET_000=
10001
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-generic-64:~# m=
ultipathd -k'remove map
>      >=A0 =A0 =A0 dmpath0'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-generic-64:~# m=
ultipathd -k'show maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-generic-64:~# m=
ultipathd -k'add map
>      dmpath0'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-generic-64:~# m=
ultipathd -k'show maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-generic-64:~#
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 Once a map is removed, w=
e are able to add it
>      only using
>      >=A0 =A0 =A0 >=A0 =A0 =A0 #multipath=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 command and not using mu=
ltipathd tools.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 It is working the way it was desi=
gned, but possibly
>      it would
>      >=A0 =A0 =A0 make
>      >=A0 =A0 =A0 >=A0 =A0 =A0 sense
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 to change the design.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 You have mentioned that it would =
make sense to change
>      the
>      >=A0 =A0 =A0 design to
>      >=A0 =A0 =A0 >=A0 =A0 =A0 add
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 map. Are there plans to change th=
e design ?
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 I am trying to understand the cod=
e flow to change the
>      >=A0 =A0 =A0 design. Can
>      >=A0 =A0 =A0 >=A0 =A0 =A0 you
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 guide me if we should stop removi=
ng the device from
>      in the
>      >=A0 =A0 =A0 remove
>      >=A0 =A0 =A0 >=A0 =A0 =A0 map code
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 flow or start adding the device a=
nd the map in the
>      add map
>      >=A0 =A0 =A0 code
>      >=A0 =A0 =A0 >=A0 =A0 =A0 flow.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0have tried to understand the r=
emove map code flow of
>      >=A0 =A0 =A0 multipathd in
>      >=A0 =A0 =A0 >=A0 =A0 =A0 0.4.8
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 code.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 I think that we want multipath to actually=
 remove the map
>      >=A0 =A0 =A0 (instead of
>      >=A0 =A0 =A0 >=A0 =A0 =A0 just not monitoring it) when you call "rem=
ove map <map>".
>      We just
>      >=A0 =A0 =A0 want
>      >=A0 =A0 =A0 >=A0 =A0 =A0 "add map <map>" to try to create the map i=
f it doesn't
>      exist.=A0 To
>      >=A0 =A0 =A0 do
>      >=A0 =A0 =A0 >=A0 =A0 =A0 that, you would need to first firgure out =
what WWID is
>      associated
>      >=A0 =A0 =A0 with
>      >=A0 =A0 =A0 >=A0 =A0 =A0 <map>. Presumably, <map> could either be a=
n alias, wwid,
>      or even
>      >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 name of a path in the map. Once you found =
the map, you
>      would have
>      >=A0 =A0 =A0 to
>      >=A0 =A0 =A0 >=A0 =A0 =A0 call the code to create the map.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 Also, to answer your IRC question, no the =
0.4.8 code is
>      not still
>      >=A0 =A0 =A0 being
>      >=A0 =A0 =A0 >=A0 =A0 =A0 developed upstream.=A0 All upstream patche=
s only go against
>      the
>      >=A0 =A0 =A0 current
>      >=A0 =A0 =A0 >=A0 =A0 =A0 head. There are no other upstream branches.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 -Ben
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 ev_remove_map (char * devname, st=
ruct vectors * vecs)
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0 flush=
_map(mpp, vecs);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0 dm_flush_map(mpp->alias,
>      >=A0 =A0 =A0 DEFAULT_TARGET);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if
>      >=A0 =A0 =A0 (!dm_map_present(mapname))
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0 =A0=A0 =A0=A0 return 0;
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 if (dm_type(ma=
pname, type) <=3D 0)
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 return 1;
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 if (dm_remove_=
partmaps(mapname))
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 return 1;
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 if (dm_get_ope=
ncount(mapname)) {
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 condlog(2, "%s: map in use", mapname);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 return 1;
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 } =A0=A0=A0=A0=
=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 r =3D dm_simpl=
ecmd(DM_DEVICE_REMOVE, mapname);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 if (r) {
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 condlog(4, "multipath map %s removed",
>      >=A0 =A0 =A0 mapname);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 return
>      0;
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 }
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 orphan_paths(vecs->pathvec,
>      mpp);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 remove_map(mpp, vecs,
>      >=A0 =A0 =A0 stop_waiter_thread,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 1);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 Is removing this below line, the =
right step to stop
>      removing
>      >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 device ?
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 r =3D dm_simplecmd(DM_DEVICE_REMO=
VE, mapname);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 Regards,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 Tejaswini
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 On Mon, Jun 8, 2015 at 11:15 AM, =
Tejaswini Poluri
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 <[1][2][3][4]tejaswinipoluri3@gma=
il.com> wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 Thanks a lot Ben for the quic=
k and detailed reply.
>      I have
>      >=A0 =A0 =A0 been
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 struggling to understand and =
conclude the issues
>      with
>      >=A0 =A0 =A0 multipath
>      >=A0 =A0 =A0 >=A0 =A0 =A0 as I am
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 the only one working from my =
team. Your inputs help
>      me a
>      >=A0 =A0 =A0 lot.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 Thanks
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 again.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 Regards,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 Tejaswini
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 On Sat, Jun 6, 2015 at 3:36 A=
M, Benjamin Marzinski
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 <[2][3][4][5]bmarzins@redhat.=
com> wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 On Fri, Jun 05, 2015 at 0=
2:31:20PM +0530,
>      Tejaswini
>      >=A0 =A0 =A0 Poluri
>      >=A0 =A0 =A0 >=A0 =A0 =A0 wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Hii Ben,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 We are testing m=
ultipathd tools with all the
>      >=A0 =A0 =A0 possible
>      >=A0 =A0 =A0 >=A0 =A0 =A0 options and
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 following fails.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Case 1 : remove =
and add map.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic=
-64:~# multipathd -k'show
>      maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 name=A0=A0=A0 sy=
sfs uuid
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 dmpath0 dm-0=A0 =
1IET_00010001
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic=
-64:~# multipathd -k'remove
>      map
>      >=A0 =A0 =A0 dmpath0'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic=
-64:~# multipathd -k'show
>      maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic=
-64:~# multipathd -k'add map
>      >=A0 =A0 =A0 dmpath0'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic=
-64:~# multipathd -k'show
>      maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic=
-64:~#
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Once a map is re=
moved, we are able to add it
>      only
>      >=A0 =A0 =A0 using
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 #multipath=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 command and not =
using multipathd tools.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 It is working the way it =
was designed, but
>      possibly it
>      >=A0 =A0 =A0 would
>      >=A0 =A0 =A0 >=A0 =A0 =A0 make
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 sense
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 to change the design.=A0 =
The "remove map" command,
>      not
>      >=A0 =A0 =A0 only stops
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 multipathd from monitorin=
g the multipath device,
>      but it
>      >=A0 =A0 =A0 removes
>      >=A0 =A0 =A0 >=A0 =A0 =A0 it
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 from
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 the system as well.=A0 Th=
e "add map" command makes
>      >=A0 =A0 =A0 multipath
>      >=A0 =A0 =A0 >=A0 =A0 =A0 monitor an
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 already existing multipat=
h device that in wasn't
>      >=A0 =A0 =A0 previously
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 monitoring.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 These commands do this fo=
r historical reasons.=A0
>      >=A0 =A0 =A0 multipathd
>      >=A0 =A0 =A0 >=A0 =A0 =A0 wasn't
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 originally in charge of c=
reating multipath
>      devices,
>      >=A0 =A0 =A0 multipath
>      >=A0 =A0 =A0 >=A0 =A0 =A0 was.=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 Once
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 it had created the device=
, it ran
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 multipathd -k"add map <MA=
P>"
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 to make multipathd start =
monitoring it.=A0 However
>      things
>      >=A0 =A0 =A0 haven't
>      >=A0 =A0 =A0 >=A0 =A0 =A0 worked
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 this way since RHEL4, so =
possibly "add map"
>      should
>      >=A0 =A0 =A0 actually
>      >=A0 =A0 =A0 >=A0 =A0 =A0 create the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 device if it doesn't curr=
ently exist.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Case 2 : Active =
paths=A0 test case
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 # while true ; d=
o sleep 3 ; multipathd
>      -k'remove
>      >=A0 =A0 =A0 path sdb'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 ;
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 multipathd
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 -k'add path sdb'=
 ; multipathd -k'show maps
>      status'
>      >=A0 =A0 =A0 ; done
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 name failback qu=
eueing paths dm-st
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 dmpath0 - - 1 ac=
tive // It should be 2.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 This is simply a timing i=
ssue.=A0 What you are
>      seeing it
>      >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 number of
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 active paths.=A0 These ar=
e paths that the kernel
>      can use.
>      >=A0 =A0 =A0 The
>      >=A0 =A0 =A0 >=A0 =A0 =A0 "add path"
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 command doesn't update th=
e kernel state.=A0 This
>      happens
>      >=A0 =A0 =A0 later in
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 response
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 to the kernel reloading t=
he device table. So, in
>      a
>      >=A0 =A0 =A0 second or
>      >=A0 =A0 =A0 >=A0 =A0 =A0 two, this
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 will say 2, as expected.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 We would like to=
 know if the test cases are
>      valid
>      >=A0 =A0 =A0 and if
>      >=A0 =A0 =A0 >=A0 =A0 =A0 these
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 are bugs or
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 any design issue=
s.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Case 3 : Fail pa=
th and reinstate path
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic=
-64:~# multipathd -k"fail
>      path
>      >=A0 =A0 =A0 sdc";
>      >=A0 =A0 =A0 >=A0 =A0 =A0 multipathd
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 -k'reinstate pat=
h sdc'; multipathd -k"show
>      paths";
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 [ 396=
2.708523] device-mapper:
>      multipath:
>      >=A0 =A0 =A0 Failing path
>      >=A0 =A0 =A0 >=A0 =A0 =A0 8:32.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 hcil=
=A0=A0=A0 dev dev_t pri dm_st=A0=A0 chk_st=A0=A0
>      >=A0 =A0 =A0 next_check
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 4:0:0=
:1 sdc 8:32=A0 1=A0=A0 [active][faulty]
>      >=A0 =A0 =A0 ..........
>      >=A0 =A0 =A0 >=A0 =A0 =A0 1/20=A0=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 <=3D=3DCHECK
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 5:0:0=
:1 sdd 8:48=A0 1=A0=A0 [active][ready]=A0
>      >=A0 =A0 =A0 XX........
>      >=A0 =A0 =A0 >=A0 =A0 =A0 4/20
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 sdc path becomes=
 [active][ready] only after
>      the
>      >=A0 =A0 =A0 polling
>      >=A0 =A0 =A0 >=A0 =A0 =A0 interval
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 but not
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 immediately afte=
r the reinstate path
>      command.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 You have answere=
d that this is a design
>      issue. But
>      >=A0 =A0 =A0 we have
>      >=A0 =A0 =A0 >=A0 =A0 =A0 heard
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 from our
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 test team that t=
he same test case works in
>      RHEL6.
>      >=A0 =A0 =A0 Did you
>      >=A0 =A0 =A0 >=A0 =A0 =A0 observe
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 it?
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 I am also findin=
g that the test cases fail
>      because
>      >=A0 =A0 =A0 we are
>      >=A0 =A0 =A0 >=A0 =A0 =A0 trying
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 to do
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 multiple command=
s at one shot.=A0 Please share
>      your
>      >=A0 =A0 =A0 thoughts
>      >=A0 =A0 =A0 >=A0 =A0 =A0 so
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 that it
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 could help me in=
 debugging the issues
>      further.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 It's totally possible tha=
t the checker state is
>      >=A0 =A0 =A0 immediately
>      >=A0 =A0 =A0 >=A0 =A0 =A0 updated in
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 RHEL6.=A0 Like I said bef=
ore, what it currently
>      does,
>      >=A0 =A0 =A0 although
>      >=A0 =A0 =A0 >=A0 =A0 =A0 correct,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 is confusing, and perhaps=
 we need a different
>      checker
>      >=A0 =A0 =A0 state for
>      >=A0 =A0 =A0 >=A0 =A0 =A0 paths
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 where the "fail path" com=
mand has been used.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 -Ben
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Regards,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Tejaswini
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 On Tue, May 19, =
2015 at 5:37 PM, Tejaswini
>      Poluri
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 <[1][3][4][5][6]=
tejaswinipoluri3@gmail.com>
>      wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 Thanks a lot=
 Ben. I will look into it
>      more.=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 On Mon, May =
18, 2015 at 9:57 PM, Benjamin
>      >=A0 =A0 =A0 Marzinski
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 <[2][4][5][6=
][7]bmarzins@redhat.com>
>      wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 On Mon, =
May 18, 2015 at 02:09:27PM
>      +0530,
>      >=A0 =A0 =A0 Tejaswini
>      >=A0 =A0 =A0 >=A0 =A0 =A0 Poluri
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 Hii,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 We are trying to test multipath
>      setup in
>      >=A0 =A0 =A0 our
>      >=A0 =A0 =A0 >=A0 =A0 =A0 target and
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 tried the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 various
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 commands of multipathd demaon and
>      we find
>      >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 following
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 error:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 root@x86-generic-64:~# multipathd
>      -k"fail
>      >=A0 =A0 =A0 path
>      >=A0 =A0 =A0 >=A0 =A0 =A0 sdc";
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 multipathd
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 -k'reinstate path
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 sdc'; multipathd -k"show paths";
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 [ 3962.708523] device-mapper:
>      multipath:
>      >=A0 =A0 =A0 Failing
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 path=A08:32.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 hcil=A0 =A0 dev dev_t pri dm_st=A0
>      =A0chk_st=A0
>      >=A0 =A0 =A0 =A0next_check
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 4:0:0:1 sdc=A08:32=A0 1=A0
>      =A0[active][faulty]
>      >=A0 =A0 =A0 ..........
>      >=A0 =A0 =A0 >=A0 =A0 =A0 1/20=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 =A0 <<<=3D=3D=3D
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 CHECK
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 5:0:0:1 sdd=A08:48=A0 1=A0
>      =A0[active][ready]=A0
>      >=A0 =A0 =A0 XX........
>      >=A0 =A0 =A0 >=A0 =A0 =A0 4/20
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 sdc path becomes [active][ready]
>      only
>      >=A0 =A0 =A0 after the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 polling
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 interval
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 but not
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 immediately after the reinstate
>      path
>      >=A0 =A0 =A0 command.=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 I am observing this in latest
>      multipath
>      >=A0 =A0 =A0 tools in
>      >=A0 =A0 =A0 >=A0 =A0 =A0 ubuntu
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 machine
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 as well.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 Please let me know if its a known
>      issue or
>      >=A0 =A0 =A0 if I
>      >=A0 =A0 =A0 >=A0 =A0 =A0 am doing
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 somethin=
g wrong.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 Regards.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0=
 Tejaswini
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 the rein=
state command is supposed to
>      reinstate
>      >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 device
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 with the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 kernel, =
and it does that. The checker
>      state
>      >=A0 =A0 =A0 doesn't
>      >=A0 =A0 =A0 >=A0 =A0 =A0 change
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 until the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 next tim=
e that the path is checked.=A0 I
>      agree
>      >=A0 =A0 =A0 that it's
>      >=A0 =A0 =A0 >=A0 =A0 =A0 odd
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 that the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 check st=
ate switches to faulty as soon
>      as you
>      >=A0 =A0 =A0 fail the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 path,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 but it
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 doesn't =
switch back until the next check
>      after
>      >=A0 =A0 =A0 you
>      >=A0 =A0 =A0 >=A0 =A0 =A0 reinistate
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 it.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 The issu=
e is that multipathd needs to
>      override
>      >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 checker
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 output,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 so that =
a failed path won't be
>      immeditately
>      >=A0 =A0 =A0 >=A0 =A0 =A0 reinstated.=A0 Once
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 path com=
es back, multipathd wants to
>      record the
>      >=A0 =A0 =A0 switch
>      >=A0 =A0 =A0 >=A0 =A0 =A0 in the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 checker
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 thread, =
so that it can refresh path
>      information
>      >=A0 =A0 =A0 what
>      >=A0 =A0 =A0 >=A0 =A0 =A0 wasn't
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 automati=
cally done when the path was
>      >=A0 =A0 =A0 reinstated.=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 However, it
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 may make
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 more sen=
se to have a different checker
>      state
>      >=A0 =A0 =A0 for when
>      >=A0 =A0 =A0 >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 device is
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 in the f=
ailed state, so that it's
>      obvious that
>      >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 checker
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 state is
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 being ov=
erruled.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 -Ben
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 > --
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 > dm-dev=
el mailing list
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 > [3][5]=
[6][7][8]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0
>      [4][6][7][8][9]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 --
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 dm-devel=
 mailing list
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 [5][7][8=
][9][10]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0
>      [6][8][9][10][11]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 > References
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Visible links
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 1.
>      mailto:[9][10][11][12]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 2.
>      mailto:[10][11][12][13]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 3.
>      mailto:[11][12][13][14]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 4.
>      >=A0 =A0 =A0 >=A0 =A0 =A0
>      [12][13][14][15]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 5.
>      mailto:[13][14][15][16]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 6.
>      >=A0 =A0 =A0 >=A0 =A0 =A0
>      [14][15][16][17]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 > References
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 Visible links
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 1. mailto:[16][17][18]tejaswinipo=
luri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 2. mailto:[17][18][19]bmarzins@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 3. mailto:[18][19][20]tejaswinipo=
luri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 4. mailto:[19][20][21]bmarzins@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 5. mailto:[20][21][22]dm-devel@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 6.
>      [21][22][23]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 7. mailto:[22][23][24]dm-devel@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 8.
>      [23][24][25]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 9. mailto:[24][25][26]tejaswinipo=
luri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A010. mailto:[25][26][27]bmarzins@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A011. mailto:[26][27][28]dm-devel@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A012.
>      [27][28][29]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A013. mailto:[28][29][30]dm-devel@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A014.
>      [29][30][31]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 > References
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 Visible links
>      >=A0 =A0 =A0 >=A0 =A0 1. mailto:[31][32]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 2. mailto:[32][33]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 3. mailto:[33][34]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 4. mailto:[34][35]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 5. mailto:[35][36]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 6. mailto:[36][37]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 7. [37][38]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 8. mailto:[38][39]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 9. [39][40]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A010. mailto:[40][41]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A011. mailto:[41][42]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A012. mailto:[42][43]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A013. [43][44]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A014. mailto:[44][45]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A015. [45][46]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A016. mailto:[46][47]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A017. mailto:[47][48]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A018. mailto:[48][49]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A019. mailto:[49][50]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A020. mailto:[50][51]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A021. [51][52]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A022. mailto:[52][53]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A023. [53][54]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A024. mailto:[54][55]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A025. mailto:[55][56]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A026. mailto:[56][57]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A027. [57][58]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A028. mailto:[58][59]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A029. [59][60]https://www.redhat.com/mailman/list=
info/dm-devel
>      >
>      > References
>      >
>      >=A0 =A0 Visible links
>      >=A0 =A0 1. mailto:[61]bmarzins@redhat.com
>      >=A0 =A0 2. mailto:[62]bmarzins@redhat.com
>      >=A0 =A0 3. mailto:[63]tejaswinipoluri3@gmail.com
>      >=A0 =A0 4. mailto:[64]bmarzins@redhat.com
>      >=A0 =A0 5. mailto:[65]tejaswinipoluri3@gmail.com
>      >=A0 =A0 6. mailto:[66]bmarzins@redhat.com
>      >=A0 =A0 7. mailto:[67]dm-devel@redhat.com
>      >=A0 =A0 8. [68]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 9. mailto:[69]dm-devel@redhat.com
>      >=A0 =A010. [70]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A011. mailto:[71]tejaswinipoluri3@gmail.com
>      >=A0 =A012. mailto:[72]bmarzins@redhat.com
>      >=A0 =A013. mailto:[73]dm-devel@redhat.com
>      >=A0 =A014. [74]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A015. mailto:[75]dm-devel@redhat.com
>      >=A0 =A016. [76]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A017. mailto:[77]tejaswinipoluri3@gmail.com
>      >=A0 =A018. mailto:[78]bmarzins@redhat.com
>      >=A0 =A019. mailto:[79]tejaswinipoluri3@gmail.com
>      >=A0 =A020. mailto:[80]bmarzins@redhat.com
>      >=A0 =A021. mailto:[81]dm-devel@redhat.com
>      >=A0 =A022. [82]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A023. mailto:[83]dm-devel@redhat.com
>      >=A0 =A024. [84]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A025. mailto:[85]tejaswinipoluri3@gmail.com
>      >=A0 =A026. mailto:[86]bmarzins@redhat.com
>      >=A0 =A027. mailto:[87]dm-devel@redhat.com
>      >=A0 =A028. [88]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A029. mailto:[89]dm-devel@redhat.com
>      >=A0 =A030. [90]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A031. mailto:[91]bmarzins@redhat.com
>      >=A0 =A032. mailto:[92]tejaswinipoluri3@gmail.com
>      >=A0 =A033. mailto:[93]bmarzins@redhat.com
>      >=A0 =A034. mailto:[94]tejaswinipoluri3@gmail.com
>      >=A0 =A035. mailto:[95]bmarzins@redhat.com
>      >=A0 =A036. mailto:[96]dm-devel@redhat.com
>      >=A0 =A037. [97]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A038. mailto:[98]dm-devel@redhat.com
>      >=A0 =A039. [99]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A040. mailto:[100]tejaswinipoluri3@gmail.com
>      >=A0 =A041. mailto:[101]bmarzins@redhat.com
>      >=A0 =A042. mailto:[102]dm-devel@redhat.com
>      >=A0 =A043. [103]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A044. mailto:[104]dm-devel@redhat.com
>      >=A0 =A045. [105]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A046. mailto:[106]tejaswinipoluri3@gmail.com
>      >=A0 =A047. mailto:[107]bmarzins@redhat.com
>      >=A0 =A048. mailto:[108]tejaswinipoluri3@gmail.com
>      >=A0 =A049. mailto:[109]bmarzins@redhat.com
>      >=A0 =A050. mailto:[110]dm-devel@redhat.com
>      >=A0 =A051. [111]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A052. mailto:[112]dm-devel@redhat.com
>      >=A0 =A053. [113]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A054. mailto:[114]tejaswinipoluri3@gmail.com
>      >=A0 =A055. mailto:[115]bmarzins@redhat.com
>      >=A0 =A056. mailto:[116]dm-devel@redhat.com
>      >=A0 =A057. [117]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A058. mailto:[118]dm-devel@redhat.com
>      >=A0 =A059. [119]https://www.redhat.com/mailman/listinfo/dm-devel
> =

> References
> =

>    Visible links
>    1. mailto:bmarzins@redhat.com
>    2. mailto:bmarzins@redhat.com
>    3. mailto:bmarzins@redhat.com
>    4. mailto:tejaswinipoluri3@gmail.com
>    5. mailto:bmarzins@redhat.com
>    6. mailto:tejaswinipoluri3@gmail.com
>    7. mailto:bmarzins@redhat.com
>    8. mailto:dm-devel@redhat.com
>    9. https://www.redhat.com/mailman/listinfo/dm-devel
>   10. mailto:dm-devel@redhat.com
>   11. https://www.redhat.com/mailman/listinfo/dm-devel
>   12. mailto:tejaswinipoluri3@gmail.com
>   13. mailto:bmarzins@redhat.com
>   14. mailto:dm-devel@redhat.com
>   15. https://www.redhat.com/mailman/listinfo/dm-devel
>   16. mailto:dm-devel@redhat.com
>   17. https://www.redhat.com/mailman/listinfo/dm-devel
>   18. mailto:tejaswinipoluri3@gmail.com
>   19. mailto:bmarzins@redhat.com
>   20. mailto:tejaswinipoluri3@gmail.com
>   21. mailto:bmarzins@redhat.com
>   22. mailto:dm-devel@redhat.com
>   23. https://www.redhat.com/mailman/listinfo/dm-devel
>   24. mailto:dm-devel@redhat.com
>   25. https://www.redhat.com/mailman/listinfo/dm-devel
>   26. mailto:tejaswinipoluri3@gmail.com
>   27. mailto:bmarzins@redhat.com
>   28. mailto:dm-devel@redhat.com
>   29. https://www.redhat.com/mailman/listinfo/dm-devel
>   30. mailto:dm-devel@redhat.com
>   31. https://www.redhat.com/mailman/listinfo/dm-devel
>   32. mailto:bmarzins@redhat.com
>   33. mailto:tejaswinipoluri3@gmail.com
>   34. mailto:bmarzins@redhat.com
>   35. mailto:tejaswinipoluri3@gmail.com
>   36. mailto:bmarzins@redhat.com
>   37. mailto:dm-devel@redhat.com
>   38. https://www.redhat.com/mailman/listinfo/dm-devel
>   39. mailto:dm-devel@redhat.com
>   40. https://www.redhat.com/mailman/listinfo/dm-devel
>   41. mailto:tejaswinipoluri3@gmail.com
>   42. mailto:bmarzins@redhat.com
>   43. mailto:dm-devel@redhat.com
>   44. https://www.redhat.com/mailman/listinfo/dm-devel
>   45. mailto:dm-devel@redhat.com
>   46. https://www.redhat.com/mailman/listinfo/dm-devel
>   47. mailto:tejaswinipoluri3@gmail.com
>   48. mailto:bmarzins@redhat.com
>   49. mailto:tejaswinipoluri3@gmail.com
>   50. mailto:bmarzins@redhat.com
>   51. mailto:dm-devel@redhat.com
>   52. https://www.redhat.com/mailman/listinfo/dm-devel
>   53. mailto:dm-devel@redhat.com
>   54. https://www.redhat.com/mailman/listinfo/dm-devel
>   55. mailto:tejaswinipoluri3@gmail.com
>   56. mailto:bmarzins@redhat.com
>   57. mailto:dm-devel@redhat.com
>   58. https://www.redhat.com/mailman/listinfo/dm-devel
>   59. mailto:dm-devel@redhat.com
>   60. https://www.redhat.com/mailman/listinfo/dm-devel
>   61. mailto:bmarzins@redhat.com
>   62. mailto:bmarzins@redhat.com
>   63. mailto:tejaswinipoluri3@gmail.com
>   64. mailto:bmarzins@redhat.com
>   65. mailto:tejaswinipoluri3@gmail.com
>   66. mailto:bmarzins@redhat.com
>   67. mailto:dm-devel@redhat.com
>   68. https://www.redhat.com/mailman/listinfo/dm-devel
>   69. mailto:dm-devel@redhat.com
>   70. https://www.redhat.com/mailman/listinfo/dm-devel
>   71. mailto:tejaswinipoluri3@gmail.com
>   72. mailto:bmarzins@redhat.com
>   73. mailto:dm-devel@redhat.com
>   74. https://www.redhat.com/mailman/listinfo/dm-devel
>   75. mailto:dm-devel@redhat.com
>   76. https://www.redhat.com/mailman/listinfo/dm-devel
>   77. mailto:tejaswinipoluri3@gmail.com
>   78. mailto:bmarzins@redhat.com
>   79. mailto:tejaswinipoluri3@gmail.com
>   80. mailto:bmarzins@redhat.com
>   81. mailto:dm-devel@redhat.com
>   82. https://www.redhat.com/mailman/listinfo/dm-devel
>   83. mailto:dm-devel@redhat.com
>   84. https://www.redhat.com/mailman/listinfo/dm-devel
>   85. mailto:tejaswinipoluri3@gmail.com
>   86. mailto:bmarzins@redhat.com
>   87. mailto:dm-devel@redhat.com
>   88. https://www.redhat.com/mailman/listinfo/dm-devel
>   89. mailto:dm-devel@redhat.com
>   90. https://www.redhat.com/mailman/listinfo/dm-devel
>   91. mailto:bmarzins@redhat.com
>   92. mailto:tejaswinipoluri3@gmail.com
>   93. mailto:bmarzins@redhat.com
>   94. mailto:tejaswinipoluri3@gmail.com
>   95. mailto:bmarzins@redhat.com
>   96. mailto:dm-devel@redhat.com
>   97. https://www.redhat.com/mailman/listinfo/dm-devel
>   98. mailto:dm-devel@redhat.com
>   99. https://www.redhat.com/mailman/listinfo/dm-devel
>  100. mailto:tejaswinipoluri3@gmail.com
>  101. mailto:bmarzins@redhat.com
>  102. mailto:dm-devel@redhat.com
>  103. https://www.redhat.com/mailman/listinfo/dm-devel
>  104. mailto:dm-devel@redhat.com
>  105. https://www.redhat.com/mailman/listinfo/dm-devel
>  106. mailto:tejaswinipoluri3@gmail.com
>  107. mailto:bmarzins@redhat.com
>  108. mailto:tejaswinipoluri3@gmail.com
>  109. mailto:bmarzins@redhat.com
>  110. mailto:dm-devel@redhat.com
>  111. https://www.redhat.com/mailman/listinfo/dm-devel
>  112. mailto:dm-devel@redhat.com
>  113. https://www.redhat.com/mailman/listinfo/dm-devel
>  114. mailto:tejaswinipoluri3@gmail.com
>  115. mailto:bmarzins@redhat.com
>  116. mailto:dm-devel@redhat.com
>  117. https://www.redhat.com/mailman/listinfo/dm-devel
>  118. mailto:dm-devel@redhat.com
>  119. https://www.redhat.com/mailman/listinfo/dm-devel
