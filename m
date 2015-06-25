From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: reinstate path not working
Date: Thu, 25 Jun 2015 18:02:44 -0500
Message-ID: <20150625230244.GN1409@octiron.msp.redhat.com>
References: <CAH=b03uWBZrOpVtAvifGmJxR83iNcGp5Q1KBzQBcpmsOwvpW=w@mail.gmail.com>
	<20150518162747.GE8491@octiron.msp.redhat.com>
	<CAH=b03t3QGuHM_x-eQTGZRkpYsAmOT4yMRCPQhp-smWM6ZXRhw@mail.gmail.com>
	<CAH=b03v=haA-5A=Vj1EhDVnhDePAZ5u=UaWdhW7zQxGcS8hV2Q@mail.gmail.com>
	<20150605220649.GD2754@octiron.msp.redhat.com>
	<CAH=b03vRNbV0oFze-s__SMb8cDJh5VYQ3uS9OpMhHoRxZhBN=w@mail.gmail.com>
	<CAH=b03tj_EZvAh5v1OG3jhubyhQnkaN=gJsGVsjrjJMQm990zQ@mail.gmail.com>
	<20150611205149.GA1409@octiron.msp.redhat.com>
	<CAH=b03trc-vMz_O0z5Qr7bSL9R+cgFG3pZfmhFufASaUMQO=qw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAH=b03trc-vMz_O0z5Qr7bSL9R+cgFG3pZfmhFufASaUMQO=qw@mail.gmail.com>
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

On Tue, Jun 23, 2015 at 03:48:26PM +0530, Tejaswini Poluri wrote:
>    Hi Ben,
> =

>    This is regarding the add map issue I have been discussing. Posting the
>    issue again to remind.
> =

>    Case 1 : remove and add map.
>    root@x86-generic-64:~# multipathd -k'show maps'
>    name=A0=A0=A0 sysfs uuid
>    dmpath0 dm-0=A0 1IET_00010001
>    root@x86-generic-64:~# multipathd -k'remove map dmpath0'
>    ok
>    root@x86-generic-64:~# multipathd -k'show maps'
>    root@x86-generic-64:~# multipathd -k'add map dmpath0'
>    ok
>    root@x86-generic-64:~# multipathd -k'show maps'
>    root@x86-generic-64:~#
>    Once a map is removed, we are able to add it only using #multipath=A0
>    command and not using multipathd tools.
> =

>    I have fixed the problem with two approaches. I would like you to revi=
ew
>    the same.
>    Patch1 : By making 'remove map dmpath0' to remove only the map and not=
 the
>    device. I have added extra functions discard_map and dm_remove_map so =
as
>    to not interfere with the existing code.
> =

>    Patch 2: The approach you have suggested.By getting wwid from the mapn=
ame
>    and doing coalesce_paths. I have just moved the following code in
>    ev_add_map to cli_add_map.

This is the general idea we'd like to go with.  However, looking at the
latest upstream code, I don't think you should pull code in from
ev_add_map() to cli_add_map() like your patch does. cli_add_map()
already calls ev_add_map(), and ev_add_map() is certainly able to add
the map if it doesn't already exist.

You would just need to call it with

ev_add_map(param, NULL, vecs);

and ev_add_map() will happily create you a new multipath device.  All
you need to do is make sure that all the functions that ev_add_map()
calls with alias can accept a NULL value there.

This might not be the best way to go about this, however.  It turns out
that right now, even though ev_add_map() technically has the ability to
create new maps, nothing currently uses it, and it really doesn't make
sense for it to be there. Instead of just copying that code, you could
pull the map creation code out of ev_add_map() and add it to
cli_add_map(), for those situations where the requested device doesn't
already exist.

But having the code in both cli_add_map() and ev_add_map() when one
already calls the other doesn't seem necessary.

-Ben


> =

>    r =3D get_refwwid(dev, DEV_DEVMAP, vecs->pathvec,&refwwid);
> =

>    =A0=A0=A0=A0=A0=A0=A0 if (refwwid) {
>    =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 r =3D coalesce_paths(vec=
s, NULL, refwwid,0);
>    =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dm_lib_release();
>    =A0=A0=A0=A0=A0=A0=A0 }
> =

>    changed dev to param.
> =

>    I have tested the same in all 3 versions -0.4.8, 0.4.9 and 0.5.0. It w=
ould
>    be great if you can review the same so that it doesn't cause any extra
>    side effects.
>    I guess Patch2 is the way u have suggested me in the previous mail. Pl=
ease
>    review it and share your views.
>    Regards,
>    Tejaswini
>    On Fri, Jun 12, 2015 at 2:21 AM, Benjamin Marzinski
>    <[1]bmarzins@redhat.com> wrote:
> =

>      On Wed, Jun 10, 2015 at 11:46:51AM +0530, Tejaswini Poluri wrote:
>      >=A0 =A0 =A0 =A0
>      >=A0 =A0 >=A0 =A0 We are testing multipathd tools with all the possi=
ble options
>      and the
>      >=A0 =A0 >=A0 =A0 following fails.
>      >=A0 =A0 >
>      >=A0 =A0 >=A0 =A0 Case 1 : remove and add map.
>      >=A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'show maps'
>      >=A0 =A0 >=A0 =A0 name=A0=A0=A0 sysfs uuid
>      >=A0 =A0 >=A0 =A0 dmpath0 dm-0=A0 1IET_00010001
>      >=A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'remove map dm=
path0'
>      >=A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'show maps'
>      >=A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'add map dmpat=
h0'
>      >=A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'show maps'
>      >=A0 =A0 >=A0 =A0 root@x86-generic-64:~#
>      >=A0 =A0 >=A0 =A0 Once a map is removed, we are able to add it only =
using
>      #multipath=A0
>      >=A0 =A0 >=A0 =A0 command and not using multipathd tools.
>      >
>      >=A0 =A0 It is working the way it was designed, but possibly it woul=
d make
>      sense
>      >=A0 =A0 to change the design.
>      >
>      >=A0 =A0 You have mentioned that it would make sense to change the d=
esign to
>      add
>      >=A0 =A0 map. Are there plans to change the design ?
>      >=A0 =A0 I am trying to understand the code flow to change the desig=
n. Can
>      you
>      >=A0 =A0 guide me if we should stop removing the device from in the =
remove
>      map code
>      >=A0 =A0 flow or start adding the device and the map in the add map =
code
>      flow.
>      >
>      >=A0 =A0 =A0have tried to understand the remove map code flow of mul=
tipathd in
>      0.4.8
>      >=A0 =A0 code.
> =

>      I think that we want multipath to actually remove the map (instead of
>      just not monitoring it) when you call "remove map <map>". We just wa=
nt
>      "add map <map>" to try to create the map if it doesn't exist.=A0 To =
do
>      that, you would need to first firgure out what WWID is associated wi=
th
>      <map>. Presumably, <map> could either be an alias, wwid, or even the
>      name of a path in the map. Once you found the map, you would have to
>      call the code to create the map.
> =

>      Also, to answer your IRC question, no the 0.4.8 code is not still be=
ing
>      developed upstream.=A0 All upstream patches only go against the curr=
ent
>      head. There are no other upstream branches.
> =

>      -Ben
>      >
>      >=A0 =A0 ev_remove_map (char * devname, struct vectors * vecs)
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0 flush_map(mpp, vecs);
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=
=A0=A0 dm_flush_map(mpp->alias, DEFAULT_TARGET);
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!dm_map_present(mapname))
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0=A0 =A0=A0 =A0=A0 return 0;
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0 if (dm_type(mapname, type) <=3D 0)
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0 if (dm_remove_partmaps(mapname))
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0 if (dm_get_opencount(mapname)) {
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 condlog(2, "%s: =
map in use", mapname);
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0 } =A0=A0=A0=A0=A0
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0 r =3D dm_simplecmd(DM_DEVICE_REMOVE, map=
name);
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0 if (r) {
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 condlog(4, "mult=
ipath map %s removed", mapname);
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=
=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 retu=
rn 0;
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>      >
>      >=A0 =A0 =A0
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 orphan_paths(vecs->pathvec, mpp);
>      >
>      >=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 remove_map(mpp, vecs, stop_waiter_thread,
>      1);
>      >
>      >=A0 =A0 Is removing this below line, the right step to stop removin=
g the
>      device ?
>      >=A0 =A0 r =3D dm_simplecmd(DM_DEVICE_REMOVE, mapname);
>      >
>      >=A0 =A0 Regards,
>      >
>      >=A0 =A0 Tejaswini
>      >
>      >=A0 =A0 On Mon, Jun 8, 2015 at 11:15 AM, Tejaswini Poluri
>      >=A0 =A0 <[1][2]tejaswinipoluri3@gmail.com> wrote:
>      >
>      >=A0 =A0 =A0 Thanks a lot Ben for the quick and detailed reply. I ha=
ve been
>      >=A0 =A0 =A0 struggling to understand and conclude the issues with m=
ultipath
>      as I am
>      >=A0 =A0 =A0 the only one working from my team. Your inputs help me =
a lot.
>      Thanks
>      >=A0 =A0 =A0 again.
>      >=A0 =A0 =A0 Regards,
>      >=A0 =A0 =A0 Tejaswini
>      >=A0 =A0 =A0 On Sat, Jun 6, 2015 at 3:36 AM, Benjamin Marzinski
>      >=A0 =A0 =A0 <[2][3]bmarzins@redhat.com> wrote:
>      >
>      >=A0 =A0 =A0 =A0 On Fri, Jun 05, 2015 at 02:31:20PM +0530, Tejaswini=
 Poluri
>      wrote:
>      >=A0 =A0 =A0 =A0 >=A0 =A0 Hii Ben,
>      >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 =A0 >=A0 =A0 We are testing multipathd tools with all t=
he possible
>      options and
>      >=A0 =A0 =A0 =A0 the
>      >=A0 =A0 =A0 =A0 >=A0 =A0 following fails.
>      >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 =A0 >=A0 =A0 Case 1 : remove and add map.
>      >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'show =
maps'
>      >=A0 =A0 =A0 =A0 >=A0 =A0 name=A0=A0=A0 sysfs uuid
>      >=A0 =A0 =A0 =A0 >=A0 =A0 dmpath0 dm-0=A0 1IET_00010001
>      >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'remov=
e map dmpath0'
>      >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'show =
maps'
>      >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'add m=
ap dmpath0'
>      >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k'show =
maps'
>      >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~#
>      >=A0 =A0 =A0 =A0 >=A0 =A0 Once a map is removed, we are able to add =
it only using
>      >=A0 =A0 =A0 =A0 #multipath=A0
>      >=A0 =A0 =A0 =A0 >=A0 =A0 command and not using multipathd tools.
>      >
>      >=A0 =A0 =A0 =A0 It is working the way it was designed, but possibly=
 it would
>      make
>      >=A0 =A0 =A0 =A0 sense
>      >=A0 =A0 =A0 =A0 to change the design.=A0 The "remove map" command, =
not only stops
>      >=A0 =A0 =A0 =A0 multipathd from monitoring the multipath device, bu=
t it removes
>      it
>      >=A0 =A0 =A0 =A0 from
>      >=A0 =A0 =A0 =A0 the system as well.=A0 The "add map" command makes =
multipath
>      monitor an
>      >=A0 =A0 =A0 =A0 already existing multipath device that in wasn't pr=
eviously
>      >=A0 =A0 =A0 =A0 monitoring.
>      >=A0 =A0 =A0 =A0 These commands do this for historical reasons.=A0 m=
ultipathd
>      wasn't
>      >=A0 =A0 =A0 =A0 originally in charge of creating multipath devices,=
 multipath
>      was.=A0
>      >=A0 =A0 =A0 =A0 Once
>      >=A0 =A0 =A0 =A0 it had created the device, it ran
>      >
>      >=A0 =A0 =A0 =A0 multipathd -k"add map <MAP>"
>      >
>      >=A0 =A0 =A0 =A0 to make multipathd start monitoring it.=A0 However =
things haven't
>      worked
>      >=A0 =A0 =A0 =A0 this way since RHEL4, so possibly "add map" should =
actually
>      create the
>      >=A0 =A0 =A0 =A0 device if it doesn't currently exist.
>      >=A0 =A0 =A0 =A0 >=A0 =A0 Case 2 : Active paths=A0 test case
>      >=A0 =A0 =A0 =A0 >=A0 =A0 # while true ; do sleep 3 ; multipathd -k'=
remove path sdb'
>      ;
>      >=A0 =A0 =A0 =A0 multipathd
>      >=A0 =A0 =A0 =A0 >=A0 =A0 -k'add path sdb' ; multipathd -k'show maps=
 status' ; done
>      >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 =A0 >=A0 =A0 name failback queueing paths dm-st
>      >=A0 =A0 =A0 =A0 >=A0 =A0 dmpath0 - - 1 active // It should be 2.
>      >
>      >=A0 =A0 =A0 =A0 This is simply a timing issue.=A0 What you are seei=
ng it the
>      number of
>      >=A0 =A0 =A0 =A0 active paths.=A0 These are paths that the kernel ca=
n use. The
>      "add path"
>      >=A0 =A0 =A0 =A0 command doesn't update the kernel state.=A0 This ha=
ppens later in
>      >=A0 =A0 =A0 =A0 response
>      >=A0 =A0 =A0 =A0 to the kernel reloading the device table. So, in a =
second or
>      two, this
>      >=A0 =A0 =A0 =A0 will say 2, as expected.
>      >
>      >=A0 =A0 =A0 =A0 >=A0 =A0 We would like to know if the test cases ar=
e valid and if
>      these
>      >=A0 =A0 =A0 =A0 are bugs or
>      >=A0 =A0 =A0 =A0 >=A0 =A0 any design issues.
>      >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 =A0 >=A0 =A0 Case 3 : Fail path and reinstate path
>      >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# multipathd -k"fail =
path sdc";
>      multipathd
>      >=A0 =A0 =A0 =A0 >=A0 =A0 -k'reinstate path sdc'; multipathd -k"show=
 paths";
>      >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 [ 3962.708523] device-mapper: m=
ultipath: Failing path
>      8:32.
>      >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 ok
>      >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 ok
>      >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 hcil=A0=A0=A0 dev dev_t pri dm_=
st=A0=A0 chk_st=A0=A0 next_check
>      >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 4:0:0:1 sdc 8:32=A0 1=A0=A0 [ac=
tive][faulty] ..........
>      1/20=A0=A0
>      >=A0 =A0 =A0 =A0 <=3D=3DCHECK
>      >=A0 =A0 =A0 =A0 >=A0 =A0 >=A0=A0=A0 5:0:0:1 sdd 8:48=A0 1=A0=A0 [ac=
tive][ready]=A0 XX........
>      4/20
>      >=A0 =A0 =A0 =A0 >=A0 =A0 sdc path becomes [active][ready] only afte=
r the polling
>      interval
>      >=A0 =A0 =A0 =A0 but not
>      >=A0 =A0 =A0 =A0 >=A0 =A0 immediately after the reinstate path comma=
nd.
>      >=A0 =A0 =A0 =A0 >=A0 =A0 You have answered that this is a design is=
sue. But we have
>      heard
>      >=A0 =A0 =A0 =A0 from our
>      >=A0 =A0 =A0 =A0 >=A0 =A0 test team that the same test case works in=
 RHEL6. Did you
>      observe
>      >=A0 =A0 =A0 =A0 it?
>      >=A0 =A0 =A0 =A0 >=A0 =A0 I am also finding that the test cases fail=
 because we are
>      trying
>      >=A0 =A0 =A0 =A0 to do
>      >=A0 =A0 =A0 =A0 >=A0 =A0 multiple commands at one shot.=A0 Please s=
hare your thoughts
>      so
>      >=A0 =A0 =A0 =A0 that it
>      >=A0 =A0 =A0 =A0 >=A0 =A0 could help me in debugging the issues furt=
her.
>      >=A0 =A0 =A0 =A0 >
>      >
>      >=A0 =A0 =A0 =A0 It's totally possible that the checker state is imm=
ediately
>      updated in
>      >=A0 =A0 =A0 =A0 RHEL6.=A0 Like I said before, what it currently doe=
s, although
>      correct,
>      >=A0 =A0 =A0 =A0 is confusing, and perhaps we need a different check=
er state for
>      paths
>      >=A0 =A0 =A0 =A0 where the "fail path" command has been used.
>      >
>      >=A0 =A0 =A0 =A0 -Ben
>      >=A0 =A0 =A0 =A0 >=A0 =A0 Regards,
>      >=A0 =A0 =A0 =A0 >=A0 =A0 Tejaswini
>      >=A0 =A0 =A0 =A0 >=A0 =A0 On Tue, May 19, 2015 at 5:37 PM, Tejaswini=
 Poluri
>      >=A0 =A0 =A0 =A0 >=A0 =A0 <[1][3][4]tejaswinipoluri3@gmail.com> wrot=
e:
>      >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 Thanks a lot Ben. I will look into it =
more.=A0
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 On Mon, May 18, 2015 at 9:57 PM, Benja=
min Marzinski
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 <[2][4][5]bmarzins@redhat.com> wrote:
>      >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 On Mon, May 18, 2015 at 02:09:27PM=
 +0530, Tejaswini
>      Poluri
>      >=A0 =A0 =A0 =A0 wrote:
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Hii,
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 We are trying to test mul=
tipath setup in our
>      target and
>      >=A0 =A0 =A0 =A0 tried the
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 various
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 commands of multipathd de=
maon and we find the
>      following
>      >=A0 =A0 =A0 =A0 error:
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 root@x86-generic-64:~# mu=
ltipathd -k"fail path
>      sdc";
>      >=A0 =A0 =A0 =A0 multipathd
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 -k'reinstate path
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 sdc'; multipathd -k"show =
paths";
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 [ 3962.708523] device-map=
per: multipath: Failing
>      >=A0 =A0 =A0 =A0 path=A08:32.
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 ok
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 hcil=A0 =A0 dev dev_t pri=
 dm_st=A0 =A0chk_st=A0 =A0next_check
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 4:0:0:1 sdc=A08:32=A0 1=
=A0 =A0[active][faulty] ..........
>      1/20=A0
>      >=A0 =A0 =A0 =A0 =A0 <<<=3D=3D=3D
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 CHECK
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 5:0:0:1 sdd=A08:48=A0 1=
=A0 =A0[active][ready]=A0 XX........
>      4/20
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 sdc path becomes [active]=
[ready] only after the
>      polling
>      >=A0 =A0 =A0 =A0 interval
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 but not
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 immediately after the rei=
nstate path command.=A0
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 I am observing this in la=
test multipath tools in
>      ubuntu
>      >=A0 =A0 =A0 =A0 machine
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 as well.
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Please let me know if its=
 a known issue or if I
>      am doing
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 something wrong.
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Regards.
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >=A0 =A0 Tejaswini
>      >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 the reinstate command is supposed =
to reinstate the
>      device
>      >=A0 =A0 =A0 =A0 with the
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 kernel, and it does that. The chec=
ker state doesn't
>      change
>      >=A0 =A0 =A0 =A0 until the
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 next time that the path is checked=
.=A0 I agree that it's
>      odd
>      >=A0 =A0 =A0 =A0 that the
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 check state switches to faulty as =
soon as you fail the
>      path,
>      >=A0 =A0 =A0 =A0 but it
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 doesn't switch back until the next=
 check after you
>      reinistate
>      >=A0 =A0 =A0 =A0 it.
>      >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 The issue is that multipathd needs=
 to override the
>      checker
>      >=A0 =A0 =A0 =A0 output,
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 so that a failed path won't be imm=
editately
>      reinstated.=A0 Once
>      >=A0 =A0 =A0 =A0 the
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 path comes back, multipathd wants =
to record the switch
>      in the
>      >=A0 =A0 =A0 =A0 checker
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 thread, so that it can refresh pat=
h information what
>      wasn't
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 automatically done when the path w=
as reinstated.=A0
>      However, it
>      >=A0 =A0 =A0 =A0 may make
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 more sense to have a different che=
cker state for when
>      the
>      >=A0 =A0 =A0 =A0 device is
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 in the failed state, so that it's =
obvious that the
>      checker
>      >=A0 =A0 =A0 =A0 state is
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 being overruled.
>      >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 -Ben
>      >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 > --
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 > dm-devel mailing list
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 > [3][5][6]dm-devel@redhat.com
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 >
>      [4][6][7]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 --
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 dm-devel mailing list
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0 [5][7][8]dm-devel@redhat.com
>      >=A0 =A0 =A0 =A0 >=A0 =A0 =A0 =A0
>      [6][8][9]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 =A0 > References
>      >=A0 =A0 =A0 =A0 >
>      >=A0 =A0 =A0 =A0 >=A0 =A0 Visible links
>      >=A0 =A0 =A0 =A0 >=A0 =A0 1. mailto:[9][10]tejaswinipoluri3@gmail.com
>      >=A0 =A0 =A0 =A0 >=A0 =A0 2. mailto:[10][11]bmarzins@redhat.com
>      >=A0 =A0 =A0 =A0 >=A0 =A0 3. mailto:[11][12]dm-devel@redhat.com
>      >=A0 =A0 =A0 =A0 >=A0 =A0 4.
>      [12][13]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 =A0 =A0 >=A0 =A0 5. mailto:[13][14]dm-devel@redhat.com
>      >=A0 =A0 =A0 =A0 >=A0 =A0 6.
>      [14][15]https://www.redhat.com/mailman/listinfo/dm-devel
>      >
>      > References
>      >
>      >=A0 =A0 Visible links
>      >=A0 =A0 1. mailto:[16]tejaswinipoluri3@gmail.com
>      >=A0 =A0 2. mailto:[17]bmarzins@redhat.com
>      >=A0 =A0 3. mailto:[18]tejaswinipoluri3@gmail.com
>      >=A0 =A0 4. mailto:[19]bmarzins@redhat.com
>      >=A0 =A0 5. mailto:[20]dm-devel@redhat.com
>      >=A0 =A0 6. [21]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 7. mailto:[22]dm-devel@redhat.com
>      >=A0 =A0 8. [23]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A0 9. mailto:[24]tejaswinipoluri3@gmail.com
>      >=A0 =A010. mailto:[25]bmarzins@redhat.com
>      >=A0 =A011. mailto:[26]dm-devel@redhat.com
>      >=A0 =A012. [27]https://www.redhat.com/mailman/listinfo/dm-devel
>      >=A0 =A013. mailto:[28]dm-devel@redhat.com
>      >=A0 =A014. [29]https://www.redhat.com/mailman/listinfo/dm-devel
> =

> References
> =

>    Visible links
>    1. mailto:bmarzins@redhat.com
>    2. mailto:tejaswinipoluri3@gmail.com
>    3. mailto:bmarzins@redhat.com
>    4. mailto:tejaswinipoluri3@gmail.com
>    5. mailto:bmarzins@redhat.com
>    6. mailto:dm-devel@redhat.com
>    7. https://www.redhat.com/mailman/listinfo/dm-devel
>    8. mailto:dm-devel@redhat.com
>    9. https://www.redhat.com/mailman/listinfo/dm-devel
>   10. mailto:tejaswinipoluri3@gmail.com
>   11. mailto:bmarzins@redhat.com
>   12. mailto:dm-devel@redhat.com
>   13. https://www.redhat.com/mailman/listinfo/dm-devel
>   14. mailto:dm-devel@redhat.com
>   15. https://www.redhat.com/mailman/listinfo/dm-devel
>   16. mailto:tejaswinipoluri3@gmail.com
>   17. mailto:bmarzins@redhat.com
>   18. mailto:tejaswinipoluri3@gmail.com
>   19. mailto:bmarzins@redhat.com
>   20. mailto:dm-devel@redhat.com
>   21. https://www.redhat.com/mailman/listinfo/dm-devel
>   22. mailto:dm-devel@redhat.com
>   23. https://www.redhat.com/mailman/listinfo/dm-devel
>   24. mailto:tejaswinipoluri3@gmail.com
>   25. mailto:bmarzins@redhat.com
>   26. mailto:dm-devel@redhat.com
>   27. https://www.redhat.com/mailman/listinfo/dm-devel
>   28. mailto:dm-devel@redhat.com
>   29. https://www.redhat.com/mailman/listinfo/dm-devel
