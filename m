From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: reinstate path not working
Date: Fri, 10 Jul 2015 11:06:45 -0500
Message-ID: <20150710160645.GR1409@octiron.msp.redhat.com>
References: <CAH=b03vRNbV0oFze-s__SMb8cDJh5VYQ3uS9OpMhHoRxZhBN=w@mail.gmail.com>
	<CAH=b03tj_EZvAh5v1OG3jhubyhQnkaN=gJsGVsjrjJMQm990zQ@mail.gmail.com>
	<20150611205149.GA1409@octiron.msp.redhat.com>
	<CAH=b03trc-vMz_O0z5Qr7bSL9R+cgFG3pZfmhFufASaUMQO=qw@mail.gmail.com>
	<20150625230244.GN1409@octiron.msp.redhat.com>
	<CAH=b03uPbi4XAFPGNQxjmsyGN2HRWUef0BSEE+HPsVhGwnXhVg@mail.gmail.com>
	<20150629192012.GO1409@octiron.msp.redhat.com>
	<CAH=b03sF=a8DbbspoxNYkzJaBDSCxV-sG6b4W0rN1GAxJtKDhg@mail.gmail.com>
	<20150706174515.GP1409@octiron.msp.redhat.com>
	<CAH=b03t0YgQu3ku+OjPfYYD5JGPRBWV6fK7Vibf2gRjPL-OyaQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAH=b03t0YgQu3ku+OjPfYYD5JGPRBWV6fK7Vibf2gRjPL-OyaQ@mail.gmail.com>
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

On Wed, Jul 08, 2015 at 05:31:26PM +0530, Tejaswini Poluri wrote:
>    Thanks a lot.=A0
>    Can you guide me how to push upstream for the approval. Which branch
>    should I push to? Any list of testcases I should perform before I could
>    push?

All you do is post it to dm-devel.  I think it's easier for Christophe
to pull the patches in, if you post them directly in the email. "git
format-patch" and "git send-email" make this a lot faster.

Please do whatever testing you feel is appropriate before posting.

About the patches specifically: In cli_add_map(), wouldn't it make more
sense to only do the coalesce_paths() if dm_mapname() fails. If it
succeeds you clearly already have an existing map, so you don't need to
create one.

-Ben

>    I have created the following two patches. PFA=A0
>    Regards,
>    Tejaswini
>    On Mon, Jul 6, 2015 at 11:15 PM, Benjamin Marzinski
>    <[1]bmarzins@redhat.com> wrote:
> =

>      On Tue, Jun 30, 2015 at 11:22:37AM +0530, Tejaswini Poluri wrote:
>      >=A0 =A0 Thanks Ben. So should I push the code to the upstream and g=
et an
>      approval?
>      >=A0 =A0 Regards,
> =

>      Yes. Thanks!
> =

>      -Ben
>      >=A0 =A0 Tejaswini
>      >=A0 =A0 On Tue, Jun 30, 2015 at 12:50 AM, Benjamin Marzinski
>      >=A0 =A0 <[1][2]bmarzins@redhat.com> wrote:
>      >
>      >=A0 =A0 =A0 On Fri, Jun 26, 2015 at 12:21:48PM +0530, Tejaswini Pol=
uri wrote:
>      >=A0 =A0 =A0 >=A0 =A0 Yes I agree that having the same code in both =
cli_add_map()
>      and
>      >=A0 =A0 =A0 ev_add_map
>      >=A0 =A0 =A0 >=A0 =A0 is not necessary. Hence I would suggest removi=
ng
>      get_refwwid() code
>      >=A0 =A0 =A0 from
>      >=A0 =A0 =A0 >=A0 =A0 ev_add_map as it is not being used by anyone.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 ev_add_map(param, NULL, vecs) would create the=
 multipath
>      device by
>      >=A0 =A0 =A0 using
>      >=A0 =A0 =A0 >=A0 =A0 the get_refwwid() code and but all the functio=
ns above it
>      like
>      >=A0 =A0 =A0 >=A0 =A0 (dm_get_minor, dm_get_major and dm_mapname) wo=
uld fail and
>      it
>      >=A0 =A0 =A0 wouldn't
>      >=A0 =A0 =A0 >=A0 =A0 enter any of the other code in ev_add_map like
>      >=A0 =A0 =A0 >=A0 =A0 1.dm_map_present,
>      >=A0 =A0 =A0 >=A0 =A0 2.add_map_without_path
>      >=A0 =A0 =A0 >=A0 =A0 3. sync_map_state
>      >=A0 =A0 =A0 >=A0 =A0 which are responsible for registering the map =
and displaying
>      it.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 So, I think moving the below code from ev_add_=
map to
>      cli_add_map
>      >=A0 =A0 =A0 should be
>      >=A0 =A0 =A0 >=A0 =A0 a good idea right.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 r =3D get_refwwid(dev, DEV_DEVMAP, vecs->pathv=
ec,&refwwid);
>      >=A0 =A0 =A0 >=A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0 if (refwwid) {
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 r =3D coalesce_paths(vecs, NULL,
>      refwwid,0);
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 dm_lib_release();
>      >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0 }
>      >=A0 =A0 =A0 >=A0 =A0 What do u think?
>      >
>      >=A0 =A0 =A0 I agree. We aren't using the code in ev_add_map, so it'=
s presence
>      there
>      >=A0 =A0 =A0 is simply confusing.
>      >
>      >=A0 =A0 =A0 -Ben
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 Regards,
>      >=A0 =A0 =A0 >=A0 =A0 Tejaswini
>      >=A0 =A0 =A0 >=A0 =A0 On Fri, Jun 26, 2015 at 4:32 AM, Benjamin Marz=
inski
>      >=A0 =A0 =A0 >=A0 =A0 <[1][2][3]bmarzins@redhat.com> wrote:
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 On Tue, Jun 23, 2015 at 03:48:26PM +0530, =
Tejaswini Poluri
>      wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 Hi Ben,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 This is regarding the add map iss=
ue I have been
>      discussing.
>      >=A0 =A0 =A0 Posting
>      >=A0 =A0 =A0 >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 issue again to remind.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 Case 1 : remove and add map.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd=
 -k'show maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 name=A0=A0=A0 sysfs uuid
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 dmpath0 dm-0=A0 1IET_00010001
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd=
 -k'remove map
>      dmpath0'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd=
 -k'show maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd=
 -k'add map dmpath0'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd=
 -k'show maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~#
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 Once a map is removed, we are abl=
e to add it only
>      using
>      >=A0 =A0 =A0 #multipath=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 command and not using multipathd =
tools.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 I have fixed the problem with two=
 approaches. I would
>      like
>      >=A0 =A0 =A0 you to
>      >=A0 =A0 =A0 >=A0 =A0 =A0 review
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 the same.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 Patch1 : By making 'remove map dm=
path0' to remove
>      only the
>      >=A0 =A0 =A0 map and
>      >=A0 =A0 =A0 >=A0 =A0 =A0 not the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 device. I have added extra functi=
ons discard_map and
>      >=A0 =A0 =A0 dm_remove_map
>      >=A0 =A0 =A0 >=A0 =A0 =A0 so as
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 to not interfere with the existin=
g code.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 Patch 2: The approach you have su=
ggested.By getting
>      wwid
>      >=A0 =A0 =A0 from the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 mapname
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 and doing coalesce_paths. I have =
just moved the
>      following
>      >=A0 =A0 =A0 code in
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 ev_add_map to cli_add_map.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 This is the general idea we'd like to go w=
ith.=A0 However,
>      looking
>      >=A0 =A0 =A0 at the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 latest upstream code, I don't think you sh=
ould pull code
>      in from
>      >=A0 =A0 =A0 >=A0 =A0 =A0 ev_add_map() to cli_add_map() like your pa=
tch does.
>      cli_add_map()
>      >=A0 =A0 =A0 >=A0 =A0 =A0 already calls ev_add_map(), and ev_add_map=
() is certainly
>      able to
>      >=A0 =A0 =A0 add
>      >=A0 =A0 =A0 >=A0 =A0 =A0 the map if it doesn't already exist.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 You would just need to call it with
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 ev_add_map(param, NULL, vecs);
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 and ev_add_map() will happily create you a=
 new multipath
>      device.=A0
>      >=A0 =A0 =A0 All
>      >=A0 =A0 =A0 >=A0 =A0 =A0 you need to do is make sure that all the f=
unctions that
>      >=A0 =A0 =A0 ev_add_map()
>      >=A0 =A0 =A0 >=A0 =A0 =A0 calls with alias can accept a NULL value t=
here.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 This might not be the best way to go about=
 this, however.=A0
>      It
>      >=A0 =A0 =A0 turns out
>      >=A0 =A0 =A0 >=A0 =A0 =A0 that right now, even though ev_add_map() t=
echnically has
>      the
>      >=A0 =A0 =A0 ability to
>      >=A0 =A0 =A0 >=A0 =A0 =A0 create new maps, nothing currently uses it=
, and it really
>      doesn't
>      >=A0 =A0 =A0 make
>      >=A0 =A0 =A0 >=A0 =A0 =A0 sense for it to be there. Instead of just =
copying that
>      code, you
>      >=A0 =A0 =A0 could
>      >=A0 =A0 =A0 >=A0 =A0 =A0 pull the map creation code out of ev_add_m=
ap() and add it
>      to
>      >=A0 =A0 =A0 >=A0 =A0 =A0 cli_add_map(), for those situations where =
the requested
>      device
>      >=A0 =A0 =A0 doesn't
>      >=A0 =A0 =A0 >=A0 =A0 =A0 already exist.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 But having the code in both cli_add_map() =
and ev_add_map()
>      when
>      >=A0 =A0 =A0 one
>      >=A0 =A0 =A0 >=A0 =A0 =A0 already calls the other doesn't seem neces=
sary.
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 -Ben
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 r =3D get_refwwid(dev, DEV_DEVMAP,
>      vecs->pathvec,&refwwid);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0 if (refwwid=
) {
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 r =3D coalesce_paths(vecs, NULL,
>      refwwid,0);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 dm_lib_release();
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0 }
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 changed dev to param.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 I have tested the same in all 3 v=
ersions -0.4.8,
>      0.4.9 and
>      >=A0 =A0 =A0 0.5.0.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 It would
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 be great if you can review the sa=
me so that it
>      doesn't cause
>      >=A0 =A0 =A0 any
>      >=A0 =A0 =A0 >=A0 =A0 =A0 extra
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 side effects.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 I guess Patch2 is the way u have =
suggested me in the
>      >=A0 =A0 =A0 previous mail.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 Please
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 review it and share your views.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 Regards,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 Tejaswini
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 On Fri, Jun 12, 2015 at 2:21 AM, =
Benjamin Marzinski
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 <[1][2][3][4]bmarzins@redhat.com>=
 wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 On Wed, Jun 10, 2015 at 11:46=
:51AM +0530, Tejaswini
>      Poluri
>      >=A0 =A0 =A0 wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 We are test=
ing multipathd tools with all
>      the
>      >=A0 =A0 =A0 possible
>      >=A0 =A0 =A0 >=A0 =A0 =A0 options
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 and the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 following f=
ails.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 Case 1 : re=
move and add map.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-ge=
neric-64:~# multipathd -k'show
>      maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 name=A0=A0=
=A0 sysfs uuid
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 dmpath0 dm-=
0=A0 1IET_00010001
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-ge=
neric-64:~# multipathd
>      -k'remove map
>      >=A0 =A0 =A0 >=A0 =A0 =A0 dmpath0'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-ge=
neric-64:~# multipathd -k'show
>      maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-ge=
neric-64:~# multipathd -k'add
>      map
>      >=A0 =A0 =A0 dmpath0'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-ge=
neric-64:~# multipathd -k'show
>      maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 root@x86-ge=
neric-64:~#
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 Once a map =
is removed, we are able to add
>      it
>      >=A0 =A0 =A0 only using
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 #multipath=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 >=A0 =A0 command and=
 not using multipathd tools.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 It is working the wa=
y it was designed, but
>      possibly
>      >=A0 =A0 =A0 it would
>      >=A0 =A0 =A0 >=A0 =A0 =A0 make
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 sense
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 to change the design.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 You have mentioned t=
hat it would make sense to
>      change
>      >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 design to
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 add
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 map. Are there plans=
 to change the design ?
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 I am trying to under=
stand the code flow to
>      change the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 design. Can
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 you
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 guide me if we shoul=
d stop removing the device
>      from
>      >=A0 =A0 =A0 in the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 remove
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 map code
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 flow or start adding=
 the device and the map in
>      the
>      >=A0 =A0 =A0 add map
>      >=A0 =A0 =A0 >=A0 =A0 =A0 code
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 flow.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0have tried to und=
erstand the remove map code
>      flow of
>      >=A0 =A0 =A0 >=A0 =A0 =A0 multipathd in
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 0.4.8
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 code.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 I think that we want multipat=
h to actually remove
>      the map
>      >=A0 =A0 =A0 >=A0 =A0 =A0 (instead of
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 just not monitoring it) when =
you call "remove map
>      <map>".
>      >=A0 =A0 =A0 We just
>      >=A0 =A0 =A0 >=A0 =A0 =A0 want
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 "add map <map>" to try to cre=
ate the map if it
>      doesn't
>      >=A0 =A0 =A0 exist.=A0 To
>      >=A0 =A0 =A0 >=A0 =A0 =A0 do
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 that, you would need to first=
 firgure out what WWID
>      is
>      >=A0 =A0 =A0 associated
>      >=A0 =A0 =A0 >=A0 =A0 =A0 with
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 <map>. Presumably, <map> coul=
d either be an alias,
>      wwid,
>      >=A0 =A0 =A0 or even
>      >=A0 =A0 =A0 >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 name of a path in the map. On=
ce you found the map,
>      you
>      >=A0 =A0 =A0 would have
>      >=A0 =A0 =A0 >=A0 =A0 =A0 to
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 call the code to create the m=
ap.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 Also, to answer your IRC ques=
tion, no the 0.4.8
>      code is
>      >=A0 =A0 =A0 not still
>      >=A0 =A0 =A0 >=A0 =A0 =A0 being
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 developed upstream.=A0 All up=
stream patches only go
>      against
>      >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 current
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 head. There are no other upst=
ream branches.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 -Ben
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 ev_remove_map (char =
* devname, struct vectors
>      * vecs)
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=
=A0=A0=A0 flush_map(mpp, vecs);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0
>      dm_flush_map(mpp->alias,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 DEFAULT_TARGET);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 if
>      >=A0 =A0 =A0 >=A0 =A0 =A0 (!dm_map_present(mapname))
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0 =A0=A0 =A0=
=A0 return
>      0;
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 i=
f (dm_type(mapname, type) <=3D 0)
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 i=
f (dm_remove_partmaps(mapname))
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 i=
f (dm_get_opencount(mapname)) {
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 condlog(2, "%s: map in use",
>      mapname);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 }=
 =A0=A0=A0=A0=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 r=
 =3D dm_simplecmd(DM_DEVICE_REMOVE,
>      mapname);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0 i=
f (r) {
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 condlog(4, "multipath map %s
>      removed",
>      >=A0 =A0 =A0 >=A0 =A0 =A0 mapname);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
>      return
>      >=A0 =A0 =A0 0;
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 }
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
>      orphan_paths(vecs->pathvec,
>      >=A0 =A0 =A0 mpp);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 remove_map(mpp, vecs,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 stop_waiter_thread,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 1);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 Is removing this bel=
ow line, the right step to
>      stop
>      >=A0 =A0 =A0 removing
>      >=A0 =A0 =A0 >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 device ?
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 r =3D dm_simplecmd(D=
M_DEVICE_REMOVE, mapname);
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 Regards,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 Tejaswini
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 On Mon, Jun 8, 2015 =
at 11:15 AM, Tejaswini
>      Poluri
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 <[1][2][3][4][5]teja=
swinipoluri3@gmail.com>
>      wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 Thanks a lot Ben=
 for the quick and detailed
>      reply.
>      >=A0 =A0 =A0 I have
>      >=A0 =A0 =A0 >=A0 =A0 =A0 been
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 struggling to un=
derstand and conclude the
>      issues
>      >=A0 =A0 =A0 with
>      >=A0 =A0 =A0 >=A0 =A0 =A0 multipath
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 as I am
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 the only one wor=
king from my team. Your
>      inputs help
>      >=A0 =A0 =A0 me a
>      >=A0 =A0 =A0 >=A0 =A0 =A0 lot.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 Thanks
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 again.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 Regards,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 Tejaswini
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 On Sat, Jun 6, 2=
015 at 3:36 AM, Benjamin
>      Marzinski
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 <[2][3][4][5][6]=
bmarzins@redhat.com> wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 On Fri, Jun =
05, 2015 at 02:31:20PM +0530,
>      >=A0 =A0 =A0 Tejaswini
>      >=A0 =A0 =A0 >=A0 =A0 =A0 Poluri
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Hii=
 Ben,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 We =
are testing multipathd tools with
>      all the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 possible
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 options and
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 fol=
lowing fails.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Cas=
e 1 : remove and add map.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 roo=
t@x86-generic-64:~# multipathd
>      -k'show
>      >=A0 =A0 =A0 maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 nam=
e=A0=A0=A0 sysfs uuid
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 dmp=
ath0 dm-0=A0 1IET_00010001
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 roo=
t@x86-generic-64:~# multipathd
>      -k'remove
>      >=A0 =A0 =A0 map
>      >=A0 =A0 =A0 >=A0 =A0 =A0 dmpath0'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 roo=
t@x86-generic-64:~# multipathd
>      -k'show
>      >=A0 =A0 =A0 maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 roo=
t@x86-generic-64:~# multipathd
>      -k'add map
>      >=A0 =A0 =A0 >=A0 =A0 =A0 dmpath0'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 roo=
t@x86-generic-64:~# multipathd
>      -k'show
>      >=A0 =A0 =A0 maps'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 roo=
t@x86-generic-64:~#
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Onc=
e a map is removed, we are able to
>      add it
>      >=A0 =A0 =A0 only
>      >=A0 =A0 =A0 >=A0 =A0 =A0 using
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 #multipath=
=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 com=
mand and not using multipathd
>      tools.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 It is workin=
g the way it was designed, but
>      >=A0 =A0 =A0 possibly it
>      >=A0 =A0 =A0 >=A0 =A0 =A0 would
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 make
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 sense
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 to change th=
e design.=A0 The "remove map"
>      command,
>      >=A0 =A0 =A0 not
>      >=A0 =A0 =A0 >=A0 =A0 =A0 only stops
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 multipathd f=
rom monitoring the multipath
>      device,
>      >=A0 =A0 =A0 but it
>      >=A0 =A0 =A0 >=A0 =A0 =A0 removes
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 it
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 from
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 the system a=
s well.=A0 The "add map" command
>      makes
>      >=A0 =A0 =A0 >=A0 =A0 =A0 multipath
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 monitor an
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 already exis=
ting multipath device that in
>      wasn't
>      >=A0 =A0 =A0 >=A0 =A0 =A0 previously
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 monitoring.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 These comman=
ds do this for historical
>      reasons.=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 multipathd
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 wasn't
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 originally i=
n charge of creating multipath
>      >=A0 =A0 =A0 devices,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 multipath
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 was.=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 Once
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 it had creat=
ed the device, it ran
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 multipathd -=
k"add map <MAP>"
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 to make mult=
ipathd start monitoring it.=A0
>      However
>      >=A0 =A0 =A0 things
>      >=A0 =A0 =A0 >=A0 =A0 =A0 haven't
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 worked
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 this way sin=
ce RHEL4, so possibly "add
>      map"
>      >=A0 =A0 =A0 should
>      >=A0 =A0 =A0 >=A0 =A0 =A0 actually
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 create the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 device if it=
 doesn't currently exist.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Cas=
e 2 : Active paths=A0 test case
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 # w=
hile true ; do sleep 3 ;
>      multipathd
>      >=A0 =A0 =A0 -k'remove
>      >=A0 =A0 =A0 >=A0 =A0 =A0 path sdb'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 ;
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 multipathd
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 -k'=
add path sdb' ; multipathd -k'show
>      maps
>      >=A0 =A0 =A0 status'
>      >=A0 =A0 =A0 >=A0 =A0 =A0 ; done
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 nam=
e failback queueing paths dm-st
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 dmp=
ath0 - - 1 active // It should be
>      2.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 This is simp=
ly a timing issue.=A0 What you
>      are
>      >=A0 =A0 =A0 seeing it
>      >=A0 =A0 =A0 >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 number of
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 active paths=
.=A0 These are paths that the
>      kernel
>      >=A0 =A0 =A0 can use.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 The
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 "add path"
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 command does=
n't update the kernel state.=A0
>      This
>      >=A0 =A0 =A0 happens
>      >=A0 =A0 =A0 >=A0 =A0 =A0 later in
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 response
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 to the kerne=
l reloading the device table.
>      So, in
>      >=A0 =A0 =A0 a
>      >=A0 =A0 =A0 >=A0 =A0 =A0 second or
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 two, this
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 will say 2, =
as expected.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 We =
would like to know if the test
>      cases are
>      >=A0 =A0 =A0 valid
>      >=A0 =A0 =A0 >=A0 =A0 =A0 and if
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 these
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 are bugs or
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 any=
 design issues.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Cas=
e 3 : Fail path and reinstate path
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 roo=
t@x86-generic-64:~# multipathd
>      -k"fail
>      >=A0 =A0 =A0 path
>      >=A0 =A0 =A0 >=A0 =A0 =A0 sdc";
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 multipathd
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 -k'=
reinstate path sdc'; multipathd
>      -k"show
>      >=A0 =A0 =A0 paths";
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=
=A0=A0=A0 [ 3962.708523] device-mapper:
>      >=A0 =A0 =A0 multipath:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 Failing path
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 8:32.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=
=A0=A0=A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=
=A0=A0=A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=
=A0=A0=A0 hcil=A0=A0=A0 dev dev_t pri dm_st=A0=A0
>      chk_st=A0=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 next_check
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=
=A0=A0=A0 4:0:0:1 sdc 8:32=A0 1=A0=A0
>      [active][faulty]
>      >=A0 =A0 =A0 >=A0 =A0 =A0 ..........
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 1/20=A0=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 <=3D=3DCHECK
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 >=
=A0=A0=A0 5:0:0:1 sdd 8:48=A0 1=A0=A0
>      [active][ready]=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 XX........
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 4/20
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 sdc=
 path becomes [active][ready] only
>      after
>      >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 polling
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 interval
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 but not
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 imm=
ediately after the reinstate path
>      >=A0 =A0 =A0 command.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 You=
 have answered that this is a
>      design
>      >=A0 =A0 =A0 issue. But
>      >=A0 =A0 =A0 >=A0 =A0 =A0 we have
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 heard
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 from our
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 tes=
t team that the same test case
>      works in
>      >=A0 =A0 =A0 RHEL6.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 Did you
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 observe
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 it?
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 I a=
m also finding that the test cases
>      fail
>      >=A0 =A0 =A0 because
>      >=A0 =A0 =A0 >=A0 =A0 =A0 we are
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 trying
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 to do
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 mul=
tiple commands at one shot.=A0
>      Please share
>      >=A0 =A0 =A0 your
>      >=A0 =A0 =A0 >=A0 =A0 =A0 thoughts
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 so
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 that it
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 cou=
ld help me in debugging the issues
>      >=A0 =A0 =A0 further.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 It's totally=
 possible that the checker
>      state is
>      >=A0 =A0 =A0 >=A0 =A0 =A0 immediately
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 updated in
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 RHEL6.=A0 Li=
ke I said before, what it
>      currently
>      >=A0 =A0 =A0 does,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 although
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 correct,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 is confusing=
, and perhaps we need a
>      different
>      >=A0 =A0 =A0 checker
>      >=A0 =A0 =A0 >=A0 =A0 =A0 state for
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 paths
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 where the "f=
ail path" command has been
>      used.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 -Ben
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Reg=
ards,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Tej=
aswini
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 On =
Tue, May 19, 2015 at 5:37 PM,
>      Tejaswini
>      >=A0 =A0 =A0 Poluri
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0
>      <[1][3][4][5][6][7]tejaswinipoluri3@gmail.com>
>      >=A0 =A0 =A0 wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 Thanks a lot Ben. I will look into
>      it
>      >=A0 =A0 =A0 more.=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 On Mon, May 18, 2015 at 9:57 PM,
>      Benjamin
>      >=A0 =A0 =A0 >=A0 =A0 =A0 Marzinski
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0
>      <[2][4][5][6][7][8]bmarzins@redhat.com>
>      >=A0 =A0 =A0 wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 On Mon, May 18, 2015 at
>      02:09:27PM
>      >=A0 =A0 =A0 +0530,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 Tejaswini
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 Poluri
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 wrote:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 Hii,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 We are trying to test
>      multipath
>      >=A0 =A0 =A0 setup in
>      >=A0 =A0 =A0 >=A0 =A0 =A0 our
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 target and
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 tried the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 various
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 commands of multipathd
>      demaon and
>      >=A0 =A0 =A0 we find
>      >=A0 =A0 =A0 >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 following
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 error:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 root@x86-generic-64:~#
>      multipathd
>      >=A0 =A0 =A0 -k"fail
>      >=A0 =A0 =A0 >=A0 =A0 =A0 path
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 sdc";
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 multipathd
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 -k'reinstate path
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 sdc'; multipathd -k"show
>      paths";
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 [ 3962.708523]
>      device-mapper:
>      >=A0 =A0 =A0 multipath:
>      >=A0 =A0 =A0 >=A0 =A0 =A0 Failing
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 path=A08:32.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 hcil=A0 =A0 dev dev_t pri dm_st=A0
>      >=A0 =A0 =A0 =A0chk_st=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 =A0next_check
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 4:0:0:1 sdc=A08:32=A0 1=A0
>      >=A0 =A0 =A0 =A0[active][faulty]
>      >=A0 =A0 =A0 >=A0 =A0 =A0 ..........
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 1/20=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 =A0 <<<=3D=
=3D=3D
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 CHECK
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 5:0:0:1 sdd=A08:48=A0 1=A0
>      >=A0 =A0 =A0 =A0[active][ready]=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 XX........
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 4/20
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 sdc path becomes
>      [active][ready]
>      >=A0 =A0 =A0 only
>      >=A0 =A0 =A0 >=A0 =A0 =A0 after the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 polling
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 interval
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 but not
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 immediately after the
>      reinstate
>      >=A0 =A0 =A0 path
>      >=A0 =A0 =A0 >=A0 =A0 =A0 command.=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 I am observing this in
>      latest
>      >=A0 =A0 =A0 multipath
>      >=A0 =A0 =A0 >=A0 =A0 =A0 tools in
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 ubuntu
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 machine
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 as well.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 Please let me know if its a
>      known
>      >=A0 =A0 =A0 issue or
>      >=A0 =A0 =A0 >=A0 =A0 =A0 if I
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 am doing
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 something wrong.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 Regards.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >=A0 =A0 Tejaswini
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 the reinstate command is supposed
>      to
>      >=A0 =A0 =A0 reinstate
>      >=A0 =A0 =A0 >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 device
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 with the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 kernel, and it does that. The
>      checker
>      >=A0 =A0 =A0 state
>      >=A0 =A0 =A0 >=A0 =A0 =A0 doesn't
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 change
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 until the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 next time that the path is
>      checked.=A0 I
>      >=A0 =A0 =A0 agree
>      >=A0 =A0 =A0 >=A0 =A0 =A0 that it's
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 odd
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 that the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 check state switches to faulty as
>      soon
>      >=A0 =A0 =A0 as you
>      >=A0 =A0 =A0 >=A0 =A0 =A0 fail the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 path,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 but it
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 doesn't switch back until the
>      next check
>      >=A0 =A0 =A0 after
>      >=A0 =A0 =A0 >=A0 =A0 =A0 you
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 reinistate
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 it.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 The issue is that multipathd
>      needs to
>      >=A0 =A0 =A0 override
>      >=A0 =A0 =A0 >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 checker
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 output,
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 so that a failed path won't be
>      >=A0 =A0 =A0 immeditately
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 reinstated.=A0 Once
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 path comes back, multipathd wants
>      to
>      >=A0 =A0 =A0 record the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 switch
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 in the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 checker
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 thread, so that it can refresh
>      path
>      >=A0 =A0 =A0 information
>      >=A0 =A0 =A0 >=A0 =A0 =A0 what
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 wasn't
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 automatically done when the path
>      was
>      >=A0 =A0 =A0 >=A0 =A0 =A0 reinstated.=A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 However, it
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 may make
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 more sense to have a different
>      checker
>      >=A0 =A0 =A0 state
>      >=A0 =A0 =A0 >=A0 =A0 =A0 for when
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 device is
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 in the failed state, so that it's
>      >=A0 =A0 =A0 obvious that
>      >=A0 =A0 =A0 >=A0 =A0 =A0 the
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 checker
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 state is
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 being overruled.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 -Ben
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 > --
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 > dm-devel mailing list
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >
>      [3][5][6][7][8][9]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0
>      >=A0 =A0 =A0
>      [4][6][7][8][9][10]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 --
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0 dm-devel mailing list
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0
>      [5][7][8][9][10][11]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 =A0=
 =A0
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0
>      >=A0 =A0 =A0
>      [6][8][9][10][11][12]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 > References
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Vis=
ible links
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 1.
>      >=A0 =A0 =A0 mailto:[9][10][11][12][13]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 2.
>      >=A0 =A0 =A0 mailto:[10][11][12][13][14]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 3.
>      >=A0 =A0 =A0 mailto:[11][12][13][14][15]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 4.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0
>      >=A0 =A0 =A0
>      [12][13][14][15][16]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 5.
>      >=A0 =A0 =A0 mailto:[13][14][15][16][17]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 6.
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0
>      >=A0 =A0 =A0
>      [14][15][16][17][18]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 > References
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 Visible links
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 1.
>      mailto:[16][17][18][19]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 2. mailto:[17][18][1=
9][20]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 3.
>      mailto:[18][19][20][21]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 4. mailto:[19][20][2=
1][22]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 5. mailto:[20][21][2=
2][23]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 6.
>      >=A0 =A0 =A0 [21][22][23][24]https://www.redhat.com/mailman/listinfo=
/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 7. mailto:[22][23][2=
4][25]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 8.
>      >=A0 =A0 =A0 [23][24][25][26]https://www.redhat.com/mailman/listinfo=
/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 9.
>      mailto:[24][25][26][27]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A010. mailto:[25][26][2=
7][28]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A011. mailto:[26][27][2=
8][29]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A012.
>      >=A0 =A0 =A0 [27][28][29][30]https://www.redhat.com/mailman/listinfo=
/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A013. mailto:[28][29][3=
0][31]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A014.
>      >=A0 =A0 =A0 [29][30][31][32]https://www.redhat.com/mailman/listinfo=
/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 > References
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 Visible links
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 1. mailto:[31][32][33]bmarzins@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 2. mailto:[32][33][34]tejaswinipo=
luri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 3. mailto:[33][34][35]bmarzins@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 4. mailto:[34][35][36]tejaswinipo=
luri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 5. mailto:[35][36][37]bmarzins@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 6. mailto:[36][37][38]dm-devel@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 7.
>      [37][38][39]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 8. mailto:[38][39][40]dm-devel@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A0 9.
>      [39][40][41]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A010. mailto:[40][41][42]tejaswinipo=
luri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A011. mailto:[41][42][43]bmarzins@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A012. mailto:[42][43][44]dm-devel@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A013.
>      [43][44][45]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A014. mailto:[44][45][46]dm-devel@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A015.
>      [45][46][47]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A016. mailto:[46][47][48]tejaswinipo=
luri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A017. mailto:[47][48][49]bmarzins@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A018. mailto:[48][49][50]tejaswinipo=
luri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A019. mailto:[49][50][51]bmarzins@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A020. mailto:[50][51][52]dm-devel@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A021.
>      [51][52][53]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A022. mailto:[52][53][54]dm-devel@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A023.
>      [53][54][55]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A024. mailto:[54][55][56]tejaswinipo=
luri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A025. mailto:[55][56][57]bmarzins@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A026. mailto:[56][57][58]dm-devel@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A027.
>      [57][58][59]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A028. mailto:[58][59][60]dm-devel@re=
dhat.com
>      >=A0 =A0 =A0 >=A0 =A0 =A0 >=A0 =A029.
>      [59][60][61]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 > References
>      >=A0 =A0 =A0 >
>      >=A0 =A0 =A0 >=A0 =A0 Visible links
>      >=A0 =A0 =A0 >=A0 =A0 1. mailto:[61][62]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 2. mailto:[62][63]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 3. mailto:[63][64]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 4. mailto:[64][65]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 5. mailto:[65][66]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A0 6. mailto:[66][67]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 7. mailto:[67][68]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A0 8. [68][69]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A0 9. mailto:[69][70]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A010. [70][71]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A011. mailto:[71][72]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A012. mailto:[72][73]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A013. mailto:[73][74]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A014. [74][75]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A015. mailto:[75][76]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A016. [76][77]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A017. mailto:[77][78]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A018. mailto:[78][79]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A019. mailto:[79][80]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A020. mailto:[80][81]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A021. mailto:[81][82]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A022. [82][83]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A023. mailto:[83][84]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A024. [84][85]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A025. mailto:[85][86]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A026. mailto:[86][87]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A027. mailto:[87][88]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A028. [88][89]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A029. mailto:[89][90]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A030. [90][91]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A031. mailto:[91][92]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A032. mailto:[92][93]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A033. mailto:[93][94]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A034. mailto:[94][95]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A035. mailto:[95][96]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A036. mailto:[96][97]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A037. [97][98]https://www.redhat.com/mailman/list=
info/dm-devel
>      >=A0 =A0 =A0 >=A0 =A038. mailto:[98][99]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A039. [99][100]https://www.redhat.com/mailman/lis=
tinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A040. mailto:[100][101]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A041. mailto:[101][102]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A042. mailto:[102][103]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A043.
>      [103][104]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A044. mailto:[104][105]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A045.
>      [105][106]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A046. mailto:[106][107]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A047. mailto:[107][108]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A048. mailto:[108][109]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A049. mailto:[109][110]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A050. mailto:[110][111]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A051.
>      [111][112]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A052. mailto:[112][113]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A053.
>      [113][114]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A054. mailto:[114][115]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 >=A0 =A055. mailto:[115][116]bmarzins@redhat.com
>      >=A0 =A0 =A0 >=A0 =A056. mailto:[116][117]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A057.
>      [117][118]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 >=A0 =A058. mailto:[118][119]dm-devel@redhat.com
>      >=A0 =A0 =A0 >=A0 =A059.
>      [119][120]https://www.redhat.com/mailman/listinfo/dm-devel
>      >
>      > References
>      >
>      >=A0 =A0 Visible links
>      >=A0 =A0 1. mailto:[121]bmarzins@redhat.com
>      >=A0 =A0 2. mailto:[122]bmarzins@redhat.com
>      >=A0 =A0 3. mailto:[123]bmarzins@redhat.com
>      >=A0 =A0 4. mailto:[124]tejaswinipoluri3@gmail.com
>      >=A0 =A0 5. mailto:[125]bmarzins@redhat.com
>      >=A0 =A0 6. mailto:[126]tejaswinipoluri3@gmail.com
>      >=A0 =A0 7. mailto:[127]bmarzins@redhat.com
>      >=A0 =A0 8. mailto:[128]dm-devel@redhat.com
>      >=A0 =A0 9. [129]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A010. mailto:[130]dm-devel@redhat.com
>      >=A0 =A011. [131]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A012. mailto:[132]tejaswinipoluri3@gmail.com
>      >=A0 =A013. mailto:[133]bmarzins@redhat.com
>      >=A0 =A014. mailto:[134]dm-devel@redhat.com
>      >=A0 =A015. [135]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A016. mailto:[136]dm-devel@redhat.com
>      >=A0 =A017. [137]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A018. mailto:[138]tejaswinipoluri3@gmail.com
>      >=A0 =A019. mailto:[139]bmarzins@redhat.com
>      >=A0 =A020. mailto:[140]tejaswinipoluri3@gmail.com
>      >=A0 =A021. mailto:[141]bmarzins@redhat.com
>      >=A0 =A022. mailto:[142]dm-devel@redhat.com
>      >=A0 =A023. [143]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A024. mailto:[144]dm-devel@redhat.com
>      >=A0 =A025. [145]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A026. mailto:[146]tejaswinipoluri3@gmail.com
>      >=A0 =A027. mailto:[147]bmarzins@redhat.com
>      >=A0 =A028. mailto:[148]dm-devel@redhat.com
>      >=A0 =A029. [149]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A030. mailto:[150]dm-devel@redhat.com
>      >=A0 =A031. [151]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A032. mailto:[152]bmarzins@redhat.com
>      >=A0 =A033. mailto:[153]tejaswinipoluri3@gmail.com
>      >=A0 =A034. mailto:[154]bmarzins@redhat.com
>      >=A0 =A035. mailto:[155]tejaswinipoluri3@gmail.com
>      >=A0 =A036. mailto:[156]bmarzins@redhat.com
>      >=A0 =A037. mailto:[157]dm-devel@redhat.com
>      >=A0 =A038. [158]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A039. mailto:[159]dm-devel@redhat.com
>      >=A0 =A040. [160]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A041. mailto:[161]tejaswinipoluri3@gmail.com
>      >=A0 =A042. mailto:[162]bmarzins@redhat.com
>      >=A0 =A043. mailto:[163]dm-devel@redhat.com
>      >=A0 =A044. [164]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A045. mailto:[165]dm-devel@redhat.com
>      >=A0 =A046. [166]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A047. mailto:[167]tejaswinipoluri3@gmail.com
>      >=A0 =A048. mailto:[168]bmarzins@redhat.com
>      >=A0 =A049. mailto:[169]tejaswinipoluri3@gmail.com
>      >=A0 =A050. mailto:[170]bmarzins@redhat.com
>      >=A0 =A051. mailto:[171]dm-devel@redhat.com
>      >=A0 =A052. [172]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A053. mailto:[173]dm-devel@redhat.com
>      >=A0 =A054. [174]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A055. mailto:[175]tejaswinipoluri3@gmail.com
>      >=A0 =A056. mailto:[176]bmarzins@redhat.com
>      >=A0 =A057. mailto:[177]dm-devel@redhat.com
>      >=A0 =A058. [178]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A059. mailto:[179]dm-devel@redhat.com
>      >=A0 =A060. [180]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A061. mailto:[181]bmarzins@redhat.com
>      >=A0 =A062. mailto:[182]bmarzins@redhat.com
>      >=A0 =A063. mailto:[183]tejaswinipoluri3@gmail.com
>      >=A0 =A064. mailto:[184]bmarzins@redhat.com
>      >=A0 =A065. mailto:[185]tejaswinipoluri3@gmail.com
>      >=A0 =A066. mailto:[186]bmarzins@redhat.com
>      >=A0 =A067. mailto:[187]dm-devel@redhat.com
>      >=A0 =A068. [188]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A069. mailto:[189]dm-devel@redhat.com
>      >=A0 =A070. [190]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A071. mailto:[191]tejaswinipoluri3@gmail.com
>      >=A0 =A072. mailto:[192]bmarzins@redhat.com
>      >=A0 =A073. mailto:[193]dm-devel@redhat.com
>      >=A0 =A074. [194]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A075. mailto:[195]dm-devel@redhat.com
>      >=A0 =A076. [196]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A077. mailto:[197]tejaswinipoluri3@gmail.com
>      >=A0 =A078. mailto:[198]bmarzins@redhat.com
>      >=A0 =A079. mailto:[199]tejaswinipoluri3@gmail.com
>      >=A0 =A080. mailto:[200]bmarzins@redhat.com
>      >=A0 =A081. mailto:[201]dm-devel@redhat.com
>      >=A0 =A082. [202]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A083. mailto:[203]dm-devel@redhat.com
>      >=A0 =A084. [204]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A085. mailto:[205]tejaswinipoluri3@gmail.com
>      >=A0 =A086. mailto:[206]bmarzins@redhat.com
>      >=A0 =A087. mailto:[207]dm-devel@redhat.com
>      >=A0 =A088. [208]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A089. mailto:[209]dm-devel@redhat.com
>      >=A0 =A090. [210]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A091. mailto:[211]bmarzins@redhat.com
>      >=A0 =A092. mailto:[212]tejaswinipoluri3@gmail.com
>      >=A0 =A093. mailto:[213]bmarzins@redhat.com
>      >=A0 =A094. mailto:[214]tejaswinipoluri3@gmail.com
>      >=A0 =A095. mailto:[215]bmarzins@redhat.com
>      >=A0 =A096. mailto:[216]dm-devel@redhat.com
>      >=A0 =A097. [217]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A098. mailto:[218]dm-devel@redhat.com
>      >=A0 =A099. [219]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 100. mailto:[220]tejaswinipoluri3@gmail.com
>      >=A0 101. mailto:[221]bmarzins@redhat.com
>      >=A0 102. mailto:[222]dm-devel@redhat.com
>      >=A0 103. [223]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 104. mailto:[224]dm-devel@redhat.com
>      >=A0 105. [225]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 106. mailto:[226]tejaswinipoluri3@gmail.com
>      >=A0 107. mailto:[227]bmarzins@redhat.com
>      >=A0 108. mailto:[228]tejaswinipoluri3@gmail.com
>      >=A0 109. mailto:[229]bmarzins@redhat.com
>      >=A0 110. mailto:[230]dm-devel@redhat.com
>      >=A0 111. [231]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 112. mailto:[232]dm-devel@redhat.com
>      >=A0 113. [233]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 114. mailto:[234]tejaswinipoluri3@gmail.com
>      >=A0 115. mailto:[235]bmarzins@redhat.com
>      >=A0 116. mailto:[236]dm-devel@redhat.com
>      >=A0 117. [237]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 118. mailto:[238]dm-devel@redhat.com
>      >=A0 119. [239]https://www.redhat.com/mailman/listinfo/dm-devel
> =

> References
> =

>    Visible links
>    1. mailto:bmarzins@redhat.com
>    2. mailto:bmarzins@redhat.com
>    3. mailto:bmarzins@redhat.com
>    4. mailto:bmarzins@redhat.com
>    5. mailto:tejaswinipoluri3@gmail.com
>    6. mailto:bmarzins@redhat.com
>    7. mailto:tejaswinipoluri3@gmail.com
>    8. mailto:bmarzins@redhat.com
>    9. mailto:dm-devel@redhat.com
>   10. https://www.redhat.com/mailman/listinfo/dm-devel
>   11. mailto:dm-devel@redhat.com
>   12. https://www.redhat.com/mailman/listinfo/dm-devel
>   13. mailto:tejaswinipoluri3@gmail.com
>   14. mailto:bmarzins@redhat.com
>   15. mailto:dm-devel@redhat.com
>   16. https://www.redhat.com/mailman/listinfo/dm-devel
>   17. mailto:dm-devel@redhat.com
>   18. https://www.redhat.com/mailman/listinfo/dm-devel
>   19. mailto:tejaswinipoluri3@gmail.com
>   20. mailto:bmarzins@redhat.com
>   21. mailto:tejaswinipoluri3@gmail.com
>   22. mailto:bmarzins@redhat.com
>   23. mailto:dm-devel@redhat.com
>   24. https://www.redhat.com/mailman/listinfo/dm-devel
>   25. mailto:dm-devel@redhat.com
>   26. https://www.redhat.com/mailman/listinfo/dm-devel
>   27. mailto:tejaswinipoluri3@gmail.com
>   28. mailto:bmarzins@redhat.com
>   29. mailto:dm-devel@redhat.com
>   30. https://www.redhat.com/mailman/listinfo/dm-devel
>   31. mailto:dm-devel@redhat.com
>   32. https://www.redhat.com/mailman/listinfo/dm-devel
>   33. mailto:bmarzins@redhat.com
>   34. mailto:tejaswinipoluri3@gmail.com
>   35. mailto:bmarzins@redhat.com
>   36. mailto:tejaswinipoluri3@gmail.com
>   37. mailto:bmarzins@redhat.com
>   38. mailto:dm-devel@redhat.com
>   39. https://www.redhat.com/mailman/listinfo/dm-devel
>   40. mailto:dm-devel@redhat.com
>   41. https://www.redhat.com/mailman/listinfo/dm-devel
>   42. mailto:tejaswinipoluri3@gmail.com
>   43. mailto:bmarzins@redhat.com
>   44. mailto:dm-devel@redhat.com
>   45. https://www.redhat.com/mailman/listinfo/dm-devel
>   46. mailto:dm-devel@redhat.com
>   47. https://www.redhat.com/mailman/listinfo/dm-devel
>   48. mailto:tejaswinipoluri3@gmail.com
>   49. mailto:bmarzins@redhat.com
>   50. mailto:tejaswinipoluri3@gmail.com
>   51. mailto:bmarzins@redhat.com
>   52. mailto:dm-devel@redhat.com
>   53. https://www.redhat.com/mailman/listinfo/dm-devel
>   54. mailto:dm-devel@redhat.com
>   55. https://www.redhat.com/mailman/listinfo/dm-devel
>   56. mailto:tejaswinipoluri3@gmail.com
>   57. mailto:bmarzins@redhat.com
>   58. mailto:dm-devel@redhat.com
>   59. https://www.redhat.com/mailman/listinfo/dm-devel
>   60. mailto:dm-devel@redhat.com
>   61. https://www.redhat.com/mailman/listinfo/dm-devel
>   62. mailto:bmarzins@redhat.com
>   63. mailto:bmarzins@redhat.com
>   64. mailto:tejaswinipoluri3@gmail.com
>   65. mailto:bmarzins@redhat.com
>   66. mailto:tejaswinipoluri3@gmail.com
>   67. mailto:bmarzins@redhat.com
>   68. mailto:dm-devel@redhat.com
>   69. https://www.redhat.com/mailman/listinfo/dm-devel
>   70. mailto:dm-devel@redhat.com
>   71. https://www.redhat.com/mailman/listinfo/dm-devel
>   72. mailto:tejaswinipoluri3@gmail.com
>   73. mailto:bmarzins@redhat.com
>   74. mailto:dm-devel@redhat.com
>   75. https://www.redhat.com/mailman/listinfo/dm-devel
>   76. mailto:dm-devel@redhat.com
>   77. https://www.redhat.com/mailman/listinfo/dm-devel
>   78. mailto:tejaswinipoluri3@gmail.com
>   79. mailto:bmarzins@redhat.com
>   80. mailto:tejaswinipoluri3@gmail.com
>   81. mailto:bmarzins@redhat.com
>   82. mailto:dm-devel@redhat.com
>   83. https://www.redhat.com/mailman/listinfo/dm-devel
>   84. mailto:dm-devel@redhat.com
>   85. https://www.redhat.com/mailman/listinfo/dm-devel
>   86. mailto:tejaswinipoluri3@gmail.com
>   87. mailto:bmarzins@redhat.com
>   88. mailto:dm-devel@redhat.com
>   89. https://www.redhat.com/mailman/listinfo/dm-devel
>   90. mailto:dm-devel@redhat.com
>   91. https://www.redhat.com/mailman/listinfo/dm-devel
>   92. mailto:bmarzins@redhat.com
>   93. mailto:tejaswinipoluri3@gmail.com
>   94. mailto:bmarzins@redhat.com
>   95. mailto:tejaswinipoluri3@gmail.com
>   96. mailto:bmarzins@redhat.com
>   97. mailto:dm-devel@redhat.com
>   98. https://www.redhat.com/mailman/listinfo/dm-devel
>   99. mailto:dm-devel@redhat.com
>  100. https://www.redhat.com/mailman/listinfo/dm-devel
>  101. mailto:tejaswinipoluri3@gmail.com
>  102. mailto:bmarzins@redhat.com
>  103. mailto:dm-devel@redhat.com
>  104. https://www.redhat.com/mailman/listinfo/dm-devel
>  105. mailto:dm-devel@redhat.com
>  106. https://www.redhat.com/mailman/listinfo/dm-devel
>  107. mailto:tejaswinipoluri3@gmail.com
>  108. mailto:bmarzins@redhat.com
>  109. mailto:tejaswinipoluri3@gmail.com
>  110. mailto:bmarzins@redhat.com
>  111. mailto:dm-devel@redhat.com
>  112. https://www.redhat.com/mailman/listinfo/dm-devel
>  113. mailto:dm-devel@redhat.com
>  114. https://www.redhat.com/mailman/listinfo/dm-devel
>  115. mailto:tejaswinipoluri3@gmail.com
>  116. mailto:bmarzins@redhat.com
>  117. mailto:dm-devel@redhat.com
>  118. https://www.redhat.com/mailman/listinfo/dm-devel
>  119. mailto:dm-devel@redhat.com
>  120. https://www.redhat.com/mailman/listinfo/dm-devel
>  121. mailto:bmarzins@redhat.com
>  122. mailto:bmarzins@redhat.com
>  123. mailto:bmarzins@redhat.com
>  124. mailto:tejaswinipoluri3@gmail.com
>  125. mailto:bmarzins@redhat.com
>  126. mailto:tejaswinipoluri3@gmail.com
>  127. mailto:bmarzins@redhat.com
>  128. mailto:dm-devel@redhat.com
>  129. https://www.redhat.com/mailman/listinfo/dm-devel
>  130. mailto:dm-devel@redhat.com
>  131. https://www.redhat.com/mailman/listinfo/dm-devel
>  132. mailto:tejaswinipoluri3@gmail.com
>  133. mailto:bmarzins@redhat.com
>  134. mailto:dm-devel@redhat.com
>  135. https://www.redhat.com/mailman/listinfo/dm-devel
>  136. mailto:dm-devel@redhat.com
>  137. https://www.redhat.com/mailman/listinfo/dm-devel
>  138. mailto:tejaswinipoluri3@gmail.com
>  139. mailto:bmarzins@redhat.com
>  140. mailto:tejaswinipoluri3@gmail.com
>  141. mailto:bmarzins@redhat.com
>  142. mailto:dm-devel@redhat.com
>  143. https://www.redhat.com/mailman/listinfo/dm-devel
>  144. mailto:dm-devel@redhat.com
>  145. https://www.redhat.com/mailman/listinfo/dm-devel
>  146. mailto:tejaswinipoluri3@gmail.com
>  147. mailto:bmarzins@redhat.com
>  148. mailto:dm-devel@redhat.com
>  149. https://www.redhat.com/mailman/listinfo/dm-devel
>  150. mailto:dm-devel@redhat.com
>  151. https://www.redhat.com/mailman/listinfo/dm-devel
>  152. mailto:bmarzins@redhat.com
>  153. mailto:tejaswinipoluri3@gmail.com
>  154. mailto:bmarzins@redhat.com
>  155. mailto:tejaswinipoluri3@gmail.com
>  156. mailto:bmarzins@redhat.com
>  157. mailto:dm-devel@redhat.com
>  158. https://www.redhat.com/mailman/listinfo/dm-devel
>  159. mailto:dm-devel@redhat.com
>  160. https://www.redhat.com/mailman/listinfo/dm-devel
>  161. mailto:tejaswinipoluri3@gmail.com
>  162. mailto:bmarzins@redhat.com
>  163. mailto:dm-devel@redhat.com
>  164. https://www.redhat.com/mailman/listinfo/dm-devel
>  165. mailto:dm-devel@redhat.com
>  166. https://www.redhat.com/mailman/listinfo/dm-devel
>  167. mailto:tejaswinipoluri3@gmail.com
>  168. mailto:bmarzins@redhat.com
>  169. mailto:tejaswinipoluri3@gmail.com
>  170. mailto:bmarzins@redhat.com
>  171. mailto:dm-devel@redhat.com
>  172. https://www.redhat.com/mailman/listinfo/dm-devel
>  173. mailto:dm-devel@redhat.com
>  174. https://www.redhat.com/mailman/listinfo/dm-devel
>  175. mailto:tejaswinipoluri3@gmail.com
>  176. mailto:bmarzins@redhat.com
>  177. mailto:dm-devel@redhat.com
>  178. https://www.redhat.com/mailman/listinfo/dm-devel
>  179. mailto:dm-devel@redhat.com
>  180. https://www.redhat.com/mailman/listinfo/dm-devel
>  181. mailto:bmarzins@redhat.com
>  182. mailto:bmarzins@redhat.com
>  183. mailto:tejaswinipoluri3@gmail.com
>  184. mailto:bmarzins@redhat.com
>  185. mailto:tejaswinipoluri3@gmail.com
>  186. mailto:bmarzins@redhat.com
>  187. mailto:dm-devel@redhat.com
>  188. https://www.redhat.com/mailman/listinfo/dm-devel
>  189. mailto:dm-devel@redhat.com
>  190. https://www.redhat.com/mailman/listinfo/dm-devel
>  191. mailto:tejaswinipoluri3@gmail.com
>  192. mailto:bmarzins@redhat.com
>  193. mailto:dm-devel@redhat.com
>  194. https://www.redhat.com/mailman/listinfo/dm-devel
>  195. mailto:dm-devel@redhat.com
>  196. https://www.redhat.com/mailman/listinfo/dm-devel
>  197. mailto:tejaswinipoluri3@gmail.com
>  198. mailto:bmarzins@redhat.com
>  199. mailto:tejaswinipoluri3@gmail.com
>  200. mailto:bmarzins@redhat.com
>  201. mailto:dm-devel@redhat.com
>  202. https://www.redhat.com/mailman/listinfo/dm-devel
>  203. mailto:dm-devel@redhat.com
>  204. https://www.redhat.com/mailman/listinfo/dm-devel
>  205. mailto:tejaswinipoluri3@gmail.com
>  206. mailto:bmarzins@redhat.com
>  207. mailto:dm-devel@redhat.com
>  208. https://www.redhat.com/mailman/listinfo/dm-devel
>  209. mailto:dm-devel@redhat.com
>  210. https://www.redhat.com/mailman/listinfo/dm-devel
>  211. mailto:bmarzins@redhat.com
>  212. mailto:tejaswinipoluri3@gmail.com
>  213. mailto:bmarzins@redhat.com
>  214. mailto:tejaswinipoluri3@gmail.com
>  215. mailto:bmarzins@redhat.com
>  216. mailto:dm-devel@redhat.com
>  217. https://www.redhat.com/mailman/listinfo/dm-devel
>  218. mailto:dm-devel@redhat.com
>  219. https://www.redhat.com/mailman/listinfo/dm-devel
>  220. mailto:tejaswinipoluri3@gmail.com
>  221. mailto:bmarzins@redhat.com
>  222. mailto:dm-devel@redhat.com
>  223. https://www.redhat.com/mailman/listinfo/dm-devel
>  224. mailto:dm-devel@redhat.com
>  225. https://www.redhat.com/mailman/listinfo/dm-devel
>  226. mailto:tejaswinipoluri3@gmail.com
>  227. mailto:bmarzins@redhat.com
>  228. mailto:tejaswinipoluri3@gmail.com
>  229. mailto:bmarzins@redhat.com
>  230. mailto:dm-devel@redhat.com
>  231. https://www.redhat.com/mailman/listinfo/dm-devel
>  232. mailto:dm-devel@redhat.com
>  233. https://www.redhat.com/mailman/listinfo/dm-devel
>  234. mailto:tejaswinipoluri3@gmail.com
>  235. mailto:bmarzins@redhat.com
>  236. mailto:dm-devel@redhat.com
>  237. https://www.redhat.com/mailman/listinfo/dm-devel
>  238. mailto:dm-devel@redhat.com
>  239. https://www.redhat.com/mailman/listinfo/dm-devel

> commit 79ab9090d3fbcdb5844478419135d1390cf548c2
> Author: Tejaswini <tejaswinipoluri3@gmail.com>
> Date:   Wed Jul 8 15:08:56 2015 +0530
> =

>     multipathd: Fixing add map functionality
>     =

>     Add map feature of multipathd tools fails as the device
>     is also been completely removed along with removing the map
>     in the remove map code. So when add map is called we are
>     creating the device again in kernel and doing add map
>     using the coloasce_paths code.
>     =

>     Signed-off-by: Tejaswini Poluri <tpoluri@mvista.com>
> =

> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index dc96c45..c54c767 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -537,7 +537,7 @@ cli_add_map (void * v, char ** reply, int * len, void=
 * data)
>  	char dev_path[PATH_SIZE];
>  	char *alias;
>  	int rc;
> -
> +	char *refwwid;
>  	param =3D convert_dev(param, 0);
>  	condlog(2, "%s: add map (operator)", param);
>  =

> @@ -547,6 +547,14 @@ cli_add_map (void * v, char ** reply, int * len, voi=
d * data)
>  		condlog(2, "%s: map blacklisted", param);
>  		return 0;
>  	}
> +	rc =3D get_refwwid(param, DEV_DEVMAP, vecs->pathvec, &refwwid);
> +
> +        if (refwwid) {
> +                condlog(2, "%s: add map (operator)", refwwid);
> +                if(coalesce_paths(vecs, NULL, refwwid, 0))
> +			condlog(2, "%s: coalesce-paths failed", param);
> +                dm_lib_release();
> +        }
>  	minor =3D dm_get_minor(param);
>  	if (minor < 0) {
>  		condlog(2, "%s: not a device mapper table", param);
> @@ -566,6 +574,7 @@ cli_add_map (void * v, char ** reply, int * len, void=
 * data)
>  	}
>  	rc =3D ev_add_map(dev_path, alias, vecs);
>  	FREE(alias);
> +	FREE(refwwid);
>  	return rc;
>  }
>  =


> commit 910b4a82ec483b48eaf8b24eb3d7829273c690ed
> Author: Tejaswini <tejaswinipoluri3@gmail.com>
> Date:   Wed Jul 8 17:18:03 2015 +0530
> =

>     multipathd: Disabled code that is not being used.
>     =

>     This part of the code is moved to cli_add_map and
>     disabled here as it is not used by any function call
>     here.
>     =

>     Signed-off-by: Tejaswini <tejaswinipoluri3@gmail.com>
> =

> diff --git a/multipathd/main.c b/multipathd/main.c
> index f876258..060237c 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -329,6 +329,8 @@ ev_add_map (char * dev, char * alias, struct vectors =
* vecs)
>  			return 1;
>  		}
>  	}
> +#if 0 /*Disabled as the code is not being used by anyone.
> +	TODO:confirm that no feature requires this code*/
>  	r =3D get_refwwid(dev, DEV_DEVMAP, vecs->pathvec, &refwwid);
>  =

>  	if (refwwid) {
> @@ -344,6 +346,7 @@ ev_add_map (char * dev, char * alias, struct vectors =
* vecs)
>  		condlog(0, "%s: uev_add_map %s failed", alias, dev);
>  =

>  	FREE(refwwid);
> +#endif
>  	return r;
>  }
>  =
