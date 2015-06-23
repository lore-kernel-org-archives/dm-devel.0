From: Tejaswini Poluri <tejaswinipoluri3@gmail.com>
Subject: Re: reinstate path not working
Date: Tue, 23 Jun 2015 15:48:26 +0530
Message-ID: <CAH=b03trc-vMz_O0z5Qr7bSL9R+cgFG3pZfmhFufASaUMQO=qw@mail.gmail.com>
References: <CAH=b03uWBZrOpVtAvifGmJxR83iNcGp5Q1KBzQBcpmsOwvpW=w@mail.gmail.com>
	<20150518162747.GE8491@octiron.msp.redhat.com>
	<CAH=b03t3QGuHM_x-eQTGZRkpYsAmOT4yMRCPQhp-smWM6ZXRhw@mail.gmail.com>
	<CAH=b03v=haA-5A=Vj1EhDVnhDePAZ5u=UaWdhW7zQxGcS8hV2Q@mail.gmail.com>
	<20150605220649.GD2754@octiron.msp.redhat.com>
	<CAH=b03vRNbV0oFze-s__SMb8cDJh5VYQ3uS9OpMhHoRxZhBN=w@mail.gmail.com>
	<CAH=b03tj_EZvAh5v1OG3jhubyhQnkaN=gJsGVsjrjJMQm990zQ@mail.gmail.com>
	<20150611205149.GA1409@octiron.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11c2f82c0f5e4d05192cb674
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150611205149.GA1409@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--001a11c2f82c0f5e4d05192cb674
Content-Type: multipart/alternative; boundary=001a11c2f82c0f5e4605192cb672

--001a11c2f82c0f5e4605192cb672
Content-Type: text/plain; charset=UTF-8

Hi Ben,

This is regarding the add map issue I have been discussing. Posting the
issue again to remind.

*Case 1 : remove and add map.*
root@x86-generic-64:~# multipathd -k'show maps'
name    sysfs uuid
dmpath0 dm-0  1IET_00010001
root@x86-generic-64:~# multipathd -k'remove map dmpath0'
ok
root@x86-generic-64:~# multipathd -k'show maps'
root@x86-generic-64:~# multipathd -k'add map dmpath0'
ok
root@x86-generic-64:~# multipathd -k'show maps'
root@x86-generic-64:~#
Once a map is removed, we are able to add it only using #multipath  command
and not using multipathd tools.

I have fixed the problem with two approaches. I would like you to review
the same.
*Patch1* : By making 'remove map dmpath0' to remove only the map and not
the device. I have added extra functions discard_map and dm_remove_map so
as to not interfere with the existing code.

*Patch 2*: The approach you have suggested.By getting wwid from the mapname
and doing coalesce_paths. I have just moved the following code in
ev_add_map to cli_add_map.

r = get_refwwid(dev, DEV_DEVMAP, vecs->pathvec,&refwwid);

        if (refwwid) {
                r = coalesce_paths(vecs, NULL, refwwid,0);
                dm_lib_release();
        }

changed dev to param.

I have tested the same in all 3 versions -0.4.8, 0.4.9 and 0.5.0. It would
be great if you can review the same so that it doesn't cause any extra side
effects.

I guess Patch2 is the way u have suggested me in the previous mail. Please
review it and share your views.

Regards,
Tejaswini


On Fri, Jun 12, 2015 at 2:21 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Wed, Jun 10, 2015 at 11:46:51AM +0530, Tejaswini Poluri wrote:
> >
> >    >    We are testing multipathd tools with all the possible options
> and the
> >    >    following fails.
> >    >
> >    >    Case 1 : remove and add map.
> >    >    root@x86-generic-64:~# multipathd -k'show maps'
> >    >    name    sysfs uuid
> >    >    dmpath0 dm-0  1IET_00010001
> >    >    root@x86-generic-64:~# multipathd -k'remove map dmpath0'
> >    >    ok
> >    >    root@x86-generic-64:~# multipathd -k'show maps'
> >    >    root@x86-generic-64:~# multipathd -k'add map dmpath0'
> >    >    ok
> >    >    root@x86-generic-64:~# multipathd -k'show maps'
> >    >    root@x86-generic-64:~#
> >    >    Once a map is removed, we are able to add it only using
> #multipath
> >    >    command and not using multipathd tools.
> >
> >    It is working the way it was designed, but possibly it would make
> sense
> >    to change the design.
> >
> >    You have mentioned that it would make sense to change the design to
> add
> >    map. Are there plans to change the design ?
> >    I am trying to understand the code flow to change the design. Can you
> >    guide me if we should stop removing the device from in the remove map
> code
> >    flow or start adding the device and the map in the add map code flow.
> >
> >     have tried to understand the remove map code flow of multipathd in
> 0.4.8
> >    code.
>
> I think that we want multipath to actually remove the map (instead of
> just not monitoring it) when you call "remove map <map>". We just want
> "add map <map>" to try to create the map if it doesn't exist.  To do
> that, you would need to first firgure out what WWID is associated with
> <map>. Presumably, <map> could either be an alias, wwid, or even the
> name of a path in the map. Once you found the map, you would have to
> call the code to create the map.
>
> Also, to answer your IRC question, no the 0.4.8 code is not still being
> developed upstream.  All upstream patches only go against the current
> head. There are no other upstream branches.
>
> -Ben
> >
> >    ev_remove_map (char * devname, struct vectors * vecs)
> >
> >              flush_map(mpp, vecs);
> >
> >                           dm_flush_map(mpp->alias, DEFAULT_TARGET);
> >
> >                                     if (!dm_map_present(mapname))
> >
> >                                            return 0;
> >
> >           if (dm_type(mapname, type) <= 0)
> >
> >                   return 1;
> >
> >           if (dm_remove_partmaps(mapname))
> >
> >                   return 1;
> >
> >           if (dm_get_opencount(mapname)) {
> >
> >                   condlog(2, "%s: map in use", mapname);
> >
> >                   return 1;
> >
> >           }
> >
> >           r = dm_simplecmd(DM_DEVICE_REMOVE, mapname);
> >
> >           if (r) {
> >
> >                   condlog(4, "multipath map %s removed", mapname);
> >
> >                                                  return 0;
> >
> >                                           }
> >
> >
> >
> >                            orphan_paths(vecs->pathvec, mpp);
> >
> >                            remove_map(mpp, vecs, stop_waiter_thread, 1);
> >
> >    Is removing this below line, the right step to stop removing the
> device ?
> >    r = dm_simplecmd(DM_DEVICE_REMOVE, mapname);
> >
> >    Regards,
> >
> >    Tejaswini
> >
> >    On Mon, Jun 8, 2015 at 11:15 AM, Tejaswini Poluri
> >    <[1]tejaswinipoluri3@gmail.com> wrote:
> >
> >      Thanks a lot Ben for the quick and detailed reply. I have been
> >      struggling to understand and conclude the issues with multipath as
> I am
> >      the only one working from my team. Your inputs help me a lot. Thanks
> >      again.
> >      Regards,
> >      Tejaswini
> >      On Sat, Jun 6, 2015 at 3:36 AM, Benjamin Marzinski
> >      <[2]bmarzins@redhat.com> wrote:
> >
> >        On Fri, Jun 05, 2015 at 02:31:20PM +0530, Tejaswini Poluri wrote:
> >        >    Hii Ben,
> >        >
> >        >    We are testing multipathd tools with all the possible
> options and
> >        the
> >        >    following fails.
> >        >
> >        >    Case 1 : remove and add map.
> >        >    root@x86-generic-64:~# multipathd -k'show maps'
> >        >    name    sysfs uuid
> >        >    dmpath0 dm-0  1IET_00010001
> >        >    root@x86-generic-64:~# multipathd -k'remove map dmpath0'
> >        >    ok
> >        >    root@x86-generic-64:~# multipathd -k'show maps'
> >        >    root@x86-generic-64:~# multipathd -k'add map dmpath0'
> >        >    ok
> >        >    root@x86-generic-64:~# multipathd -k'show maps'
> >        >    root@x86-generic-64:~#
> >        >    Once a map is removed, we are able to add it only using
> >        #multipath
> >        >    command and not using multipathd tools.
> >
> >        It is working the way it was designed, but possibly it would make
> >        sense
> >        to change the design.  The "remove map" command, not only stops
> >        multipathd from monitoring the multipath device, but it removes it
> >        from
> >        the system as well.  The "add map" command makes multipath
> monitor an
> >        already existing multipath device that in wasn't previously
> >        monitoring.
> >        These commands do this for historical reasons.  multipathd wasn't
> >        originally in charge of creating multipath devices, multipath
> was.
> >        Once
> >        it had created the device, it ran
> >
> >        multipathd -k"add map <MAP>"
> >
> >        to make multipathd start monitoring it.  However things haven't
> worked
> >        this way since RHEL4, so possibly "add map" should actually
> create the
> >        device if it doesn't currently exist.
> >        >    Case 2 : Active paths  test case
> >        >    # while true ; do sleep 3 ; multipathd -k'remove path sdb' ;
> >        multipathd
> >        >    -k'add path sdb' ; multipathd -k'show maps status' ; done
> >        >    ok
> >        >    ok
> >        >    name failback queueing paths dm-st
> >        >    dmpath0 - - 1 active // It should be 2.
> >
> >        This is simply a timing issue.  What you are seeing it the number
> of
> >        active paths.  These are paths that the kernel can use. The "add
> path"
> >        command doesn't update the kernel state.  This happens later in
> >        response
> >        to the kernel reloading the device table. So, in a second or two,
> this
> >        will say 2, as expected.
> >
> >        >    We would like to know if the test cases are valid and if
> these
> >        are bugs or
> >        >    any design issues.
> >        >
> >        >    Case 3 : Fail path and reinstate path
> >        >    root@x86-generic-64:~# multipathd -k"fail path sdc";
> multipathd
> >        >    -k'reinstate path sdc'; multipathd -k"show paths";
> >        >    >    [ 3962.708523] device-mapper: multipath: Failing path
> 8:32.
> >        >    >    ok
> >        >    >    ok
> >        >    >    hcil    dev dev_t pri dm_st   chk_st   next_check
> >        >    >    4:0:0:1 sdc 8:32  1   [active][faulty] .......... 1/20
> >        <==CHECK
> >        >    >    5:0:0:1 sdd 8:48  1   [active][ready]  XX........ 4/20
> >        >    sdc path becomes [active][ready] only after the polling
> interval
> >        but not
> >        >    immediately after the reinstate path command.
> >        >    You have answered that this is a design issue. But we have
> heard
> >        from our
> >        >    test team that the same test case works in RHEL6. Did you
> observe
> >        it?
> >        >    I am also finding that the test cases fail because we are
> trying
> >        to do
> >        >    multiple commands at one shot.  Please share your thoughts so
> >        that it
> >        >    could help me in debugging the issues further.
> >        >
> >
> >        It's totally possible that the checker state is immediately
> updated in
> >        RHEL6.  Like I said before, what it currently does, although
> correct,
> >        is confusing, and perhaps we need a different checker state for
> paths
> >        where the "fail path" command has been used.
> >
> >        -Ben
> >        >    Regards,
> >        >    Tejaswini
> >        >    On Tue, May 19, 2015 at 5:37 PM, Tejaswini Poluri
> >        >    <[1][3]tejaswinipoluri3@gmail.com> wrote:
> >        >
> >        >      Thanks a lot Ben. I will look into it more.
> >        >      On Mon, May 18, 2015 at 9:57 PM, Benjamin Marzinski
> >        >      <[2][4]bmarzins@redhat.com> wrote:
> >        >
> >        >        On Mon, May 18, 2015 at 02:09:27PM +0530, Tejaswini
> Poluri
> >        wrote:
> >        >        >    Hii,
> >        >        >    We are trying to test multipath setup in our target
> and
> >        tried the
> >        >        various
> >        >        >    commands of multipathd demaon and we find the
> following
> >        error:
> >        >        >    root@x86-generic-64:~# multipathd -k"fail path
> sdc";
> >        multipathd
> >        >        >    -k'reinstate path
> >        >        >    sdc'; multipathd -k"show paths";
> >        >        >    [ 3962.708523] device-mapper: multipath: Failing
> >        path 8:32.
> >        >        >    ok
> >        >        >    ok
> >        >        >    hcil    dev dev_t pri dm_st   chk_st   next_check
> >        >        >    4:0:0:1 sdc 8:32  1   [active][faulty] ..........
> 1/20
> >          <<<===
> >        >        CHECK
> >        >        >    5:0:0:1 sdd 8:48  1   [active][ready]  XX........
> 4/20
> >        >        >    sdc path becomes [active][ready] only after the
> polling
> >        interval
> >        >        but not
> >        >        >    immediately after the reinstate path command.
> >        >        >    I am observing this in latest multipath tools in
> ubuntu
> >        machine
> >        >        as well.
> >        >        >    Please let me know if its a known issue or if I am
> doing
> >        >        something wrong.
> >        >        >    Regards.
> >        >        >    Tejaswini
> >        >
> >        >        the reinstate command is supposed to reinstate the device
> >        with the
> >        >        kernel, and it does that. The checker state doesn't
> change
> >        until the
> >        >        next time that the path is checked.  I agree that it's
> odd
> >        that the
> >        >        check state switches to faulty as soon as you fail the
> path,
> >        but it
> >        >        doesn't switch back until the next check after you
> reinistate
> >        it.
> >        >
> >        >        The issue is that multipathd needs to override the
> checker
> >        output,
> >        >        so that a failed path won't be immeditately reinstated.
> Once
> >        the
> >        >        path comes back, multipathd wants to record the switch
> in the
> >        checker
> >        >        thread, so that it can refresh path information what
> wasn't
> >        >        automatically done when the path was reinstated.
> However, it
> >        may make
> >        >        more sense to have a different checker state for when the
> >        device is
> >        >        in the failed state, so that it's obvious that the
> checker
> >        state is
> >        >        being overruled.
> >        >
> >        >        -Ben
> >        >
> >        >        > --
> >        >        > dm-devel mailing list
> >        >        > [3][5]dm-devel@redhat.com
> >        >        > [4][6]https://www.redhat.com/mailman/listinfo/dm-devel
> >        >
> >        >        --
> >        >        dm-devel mailing list
> >        >        [5][7]dm-devel@redhat.com
> >        >        [6][8]https://www.redhat.com/mailman/listinfo/dm-devel
> >        >
> >        > References
> >        >
> >        >    Visible links
> >        >    1. mailto:[9]tejaswinipoluri3@gmail.com
> >        >    2. mailto:[10]bmarzins@redhat.com
> >        >    3. mailto:[11]dm-devel@redhat.com
> >        >    4. [12]https://www.redhat.com/mailman/listinfo/dm-devel
> >        >    5. mailto:[13]dm-devel@redhat.com
> >        >    6. [14]https://www.redhat.com/mailman/listinfo/dm-devel
> >
> > References
> >
> >    Visible links
> >    1. mailto:tejaswinipoluri3@gmail.com
> >    2. mailto:bmarzins@redhat.com
> >    3. mailto:tejaswinipoluri3@gmail.com
> >    4. mailto:bmarzins@redhat.com
> >    5. mailto:dm-devel@redhat.com
> >    6. https://www.redhat.com/mailman/listinfo/dm-devel
> >    7. mailto:dm-devel@redhat.com
> >    8. https://www.redhat.com/mailman/listinfo/dm-devel
> >    9. mailto:tejaswinipoluri3@gmail.com
> >   10. mailto:bmarzins@redhat.com
> >   11. mailto:dm-devel@redhat.com
> >   12. https://www.redhat.com/mailman/listinfo/dm-devel
> >   13. mailto:dm-devel@redhat.com
> >   14. https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a11c2f82c0f5e4605192cb672
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Ben, <br><br></div><div>This is regarding the add =
map issue I have been discussing. Posting the issue again to remind.<br><br=
><b>Case 1 : remove and add map.</b><br>root@x86-generic-64:~# multipathd -=
k&#39;show maps&#39;<br>name=C2=A0=C2=A0=C2=A0 sysfs uuid<br>dmpath0 dm-0=
=C2=A0 1IET_00010001<br>root@x86-generic-64:~# multipathd -k&#39;remove map=
 dmpath0&#39;<br>ok<br>root@x86-generic-64:~# multipathd -k&#39;show maps&#=
39;<br>root@x86-generic-64:~# multipathd -k&#39;add map dmpath0&#39;<br>ok<=
br>root@x86-generic-64:~# multipathd -k&#39;show maps&#39;<br>root@x86-gene=
ric-64:~#<br>Once a map is removed, we are able to add it only using #multi=
path=C2=A0 command and not using multipathd tools. <br><br>I have fixed the=
 problem with two approaches. I would like you to review the same.<br></div=
><div><b>Patch1</b> : By making &#39;remove map dmpath0&#39; to remove only=
 the map and not the device. I have added extra functions discard_map and d=
m_remove_map so as to not interfere with the existing code.<br><br></div><d=
iv><b>Patch 2</b>: The approach you have suggested.By getting wwid from the=
 mapname and doing coalesce_paths. I have just moved the following code in =
ev_add_map to cli_add_map.<br><br>r =3D get_refwwid(dev, DEV_DEVMAP, vecs-&=
gt;pathvec,&amp;refwwid);<br><br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (refwwid) {<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r =3D coalesce_paths(vecs, NULL, refww=
id,0);<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 dm_lib_release();<br>=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 }<br><br></div><div>changed dev to param.<br><br></div><=
div>I have tested the same in all 3 versions -0.4.8, 0.4.9 and 0.5.0. It wo=
uld be great if you can review the same so that it doesn&#39;t cause any ex=
tra side effects.<br></div><div><br></div><div>I guess Patch2 is the way u =
have suggested me in the previous mail. Please review it and share your vie=
ws.<br></div><div><br></div><div>Regards,<br></div><div>Tejaswini<br></div>=
<div><br></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On=
 Fri, Jun 12, 2015 at 2:21 AM, Benjamin Marzinski <span dir=3D"ltr">&lt;<a =
href=3D"mailto:bmarzins@redhat.com" target=3D"_blank">bmarzins@redhat.com</=
a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0=
 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div><div>On Wed, Ju=
n 10, 2015 at 11:46:51AM +0530, Tejaswini Poluri wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 We are testing multipathd tools with al=
l the possible options and the<br>
&gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 following fails.<br>
&gt;=C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Case 1 : remove and add map.<br>
&gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-generic-64:~# multipathd -k&#3=
9;show maps&#39;<br>
&gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 name=C2=A0=C2=A0=C2=A0 sysfs uuid<br>
&gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 dmpath0 dm-0=C2=A0 1IET_00010001<br>
&gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-generic-64:~# multipathd -k&#3=
9;remove map dmpath0&#39;<br>
&gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 ok<br>
&gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-generic-64:~# multipathd -k&#3=
9;show maps&#39;<br>
&gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-generic-64:~# multipathd -k&#3=
9;add map dmpath0&#39;<br>
&gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 ok<br>
&gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-generic-64:~# multipathd -k&#3=
9;show maps&#39;<br>
&gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-generic-64:~#<br>
&gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Once a map is removed, we are able to a=
dd it only using #multipath=C2=A0<br>
&gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 command and not using multipathd tools.=
<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 It is working the way it was designed, but possibly it wo=
uld make sense<br>
&gt;=C2=A0 =C2=A0 to change the design.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 You have mentioned that it would make sense to change the=
 design to add<br>
&gt;=C2=A0 =C2=A0 map. Are there plans to change the design ?<br>
&gt;=C2=A0 =C2=A0 I am trying to understand the code flow to change the des=
ign. Can you<br>
&gt;=C2=A0 =C2=A0 guide me if we should stop removing the device from in th=
e remove map code<br>
&gt;=C2=A0 =C2=A0 flow or start adding the device and the map in the add ma=
p code flow.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0have tried to understand the remove map code flow o=
f multipathd in 0.4.8<br>
&gt;=C2=A0 =C2=A0 code.<br>
<br>
</div></div>I think that we want multipath to actually remove the map (inst=
ead of<br>
just not monitoring it) when you call &quot;remove map &lt;map&gt;&quot;. W=
e just want<br>
&quot;add map &lt;map&gt;&quot; to try to create the map if it doesn&#39;t =
exist.=C2=A0 To do<br>
that, you would need to first firgure out what WWID is associated with<br>
&lt;map&gt;. Presumably, &lt;map&gt; could either be an alias, wwid, or eve=
n the<br>
name of a path in the map. Once you found the map, you would have to<br>
call the code to create the map.<br>
<br>
Also, to answer your IRC question, no the 0.4.8 code is not still being<br>
developed upstream.=C2=A0 All upstream patches only go against the current<=
br>
head. There are no other upstream branches.<br>
<br>
-Ben<br>
<span>&gt;<br>
&gt;=C2=A0 =C2=A0 ev_remove_map (char * devname, struct vectors * vecs)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fl=
ush_map(mpp, vecs);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dm_f=
lush_map(mpp-&gt;alias, DEFAULT_TARGET);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!dm_map_pr=
esent(mapname))<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 return 0;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (dm_type(mapname,=
 type) &lt;=3D 0)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 1;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (dm_remove_partma=
ps(mapname))<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 1;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (dm_get_opencount=
(mapname)) {<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 condlog(2, &quot;%s: map in use&quot;, mapname)=
;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 1;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } =C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r =3D dm_simplecmd(D=
M_DEVICE_REMOVE, mapname);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (r) {<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 condlog(4, &quot;multipath map %s removed&quot;=
, mapname);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 orphan_paths(vecs-&gt;pathvec, mpp);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 remove_map(mpp, vecs, stop_waiter_thread, 1);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 Is removing this below line, the right step to stop remov=
ing the device ?<br>
&gt;=C2=A0 =C2=A0 r =3D dm_simplecmd(DM_DEVICE_REMOVE, mapname);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 Regards,<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 Tejaswini<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 On Mon, Jun 8, 2015 at 11:15 AM, Tejaswini Poluri<br>
</span><span>&gt;=C2=A0 =C2=A0 &lt;[1]<a href=3D"mailto:tejaswinipoluri3@gm=
ail.com" target=3D"_blank">tejaswinipoluri3@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 Thanks a lot Ben for the quick and detailed reply.=
 I have been<br>
&gt;=C2=A0 =C2=A0 =C2=A0 struggling to understand and conclude the issues w=
ith multipath as I am<br>
&gt;=C2=A0 =C2=A0 =C2=A0 the only one working from my team. Your inputs hel=
p me a lot. Thanks<br>
&gt;=C2=A0 =C2=A0 =C2=A0 again.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 Regards,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 Tejaswini<br>
&gt;=C2=A0 =C2=A0 =C2=A0 On Sat, Jun 6, 2015 at 3:36 AM, Benjamin Marzinski=
<br>
</span><div><div>&gt;=C2=A0 =C2=A0 =C2=A0 &lt;[2]<a href=3D"mailto:bmarzins=
@redhat.com" target=3D"_blank">bmarzins@redhat.com</a>&gt; wrote:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 On Fri, Jun 05, 2015 at 02:31:20PM +0530, T=
ejaswini Poluri wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Hii Ben,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 We are testing multipathd=
 tools with all the possible options and<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 following fails.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Case 1 : remove and add m=
ap.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-generic-64:~# mu=
ltipathd -k&#39;show maps&#39;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 name=C2=A0=C2=A0=C2=A0 sy=
sfs uuid<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 dmpath0 dm-0=C2=A0 1IET_0=
0010001<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-generic-64:~# mu=
ltipathd -k&#39;remove map dmpath0&#39;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 ok<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-generic-64:~# mu=
ltipathd -k&#39;show maps&#39;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-generic-64:~# mu=
ltipathd -k&#39;add map dmpath0&#39;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 ok<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-generic-64:~# mu=
ltipathd -k&#39;show maps&#39;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-generic-64:~#<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Once a map is removed, we=
 are able to add it only using<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 #multipath=C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 command and not using mul=
tipathd tools.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 It is working the way it was designed, but =
possibly it would make<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 sense<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 to change the design.=C2=A0 The &quot;remov=
e map&quot; command, not only stops<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 multipathd from monitoring the multipath de=
vice, but it removes it<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 from<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 the system as well.=C2=A0 The &quot;add map=
&quot; command makes multipath monitor an<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 already existing multipath device that in w=
asn&#39;t previously<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 monitoring.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 These commands do this for historical reaso=
ns.=C2=A0 multipathd wasn&#39;t<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 originally in charge of creating multipath =
devices, multipath was.=C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 Once<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 it had created the device, it ran<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 multipathd -k&quot;add map &lt;MAP&gt;&quot=
;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 to make multipathd start monitoring it.=C2=
=A0 However things haven&#39;t worked<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 this way since RHEL4, so possibly &quot;add=
 map&quot; should actually create the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 device if it doesn&#39;t currently exist.<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Case 2 : Active paths=C2=
=A0 test case<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 # while true ; do sleep 3=
 ; multipathd -k&#39;remove path sdb&#39; ;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 multipathd<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 -k&#39;add path sdb&#39; =
; multipathd -k&#39;show maps status&#39; ; done<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 ok<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 ok<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 name failback queueing pa=
ths dm-st<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 dmpath0 - - 1 active // I=
t should be 2.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 This is simply a timing issue.=C2=A0 What y=
ou are seeing it the number of<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 active paths.=C2=A0 These are paths that th=
e kernel can use. The &quot;add path&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 command doesn&#39;t update the kernel state=
.=C2=A0 This happens later in<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 response<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 to the kernel reloading the device table. S=
o, in a second or two, this<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 will say 2, as expected.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 We would like to know if =
the test cases are valid and if these<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 are bugs or<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 any design issues.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Case 3 : Fail path and re=
instate path<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-generic-64:~# mu=
ltipathd -k&quot;fail path sdc&quot;; multipathd<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 -k&#39;reinstate path sdc=
&#39;; multipathd -k&quot;show paths&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0=C2=A0=C2=A0 [ =
3962.708523] device-mapper: multipath: Failing path 8:32.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0=C2=A0=C2=A0 ok=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0=C2=A0=C2=A0 ok=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0=C2=A0=C2=A0 hc=
il=C2=A0=C2=A0=C2=A0 dev dev_t pri dm_st=C2=A0=C2=A0 chk_st=C2=A0=C2=A0 nex=
t_check<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0=C2=A0=C2=A0 4:=
0:0:1 sdc 8:32=C2=A0 1=C2=A0=C2=A0 [active][faulty] .......... 1/20=C2=A0=
=C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;=3D=3DCHECK<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0=C2=A0=C2=A0 5:=
0:0:1 sdd 8:48=C2=A0 1=C2=A0=C2=A0 [active][ready]=C2=A0 XX........ 4/20<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 sdc path becomes [active]=
[ready] only after the polling interval<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 but not<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 immediately after the rei=
nstate path command.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 You have answered that th=
is is a design issue. But we have heard<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 from our<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 test team that the same t=
est case works in RHEL6. Did you observe<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 it?<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 I am also finding that th=
e test cases fail because we are trying<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 to do<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 multiple commands at one =
shot.=C2=A0 Please share your thoughts so<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 that it<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 could help me in debuggin=
g the issues further.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 It&#39;s totally possible that the checker =
state is immediately updated in<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 RHEL6.=C2=A0 Like I said before, what it cu=
rrently does, although correct,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 is confusing, and perhaps we need a differe=
nt checker state for paths<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 where the &quot;fail path&quot; command has=
 been used.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 -Ben<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Regards,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Tejaswini<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 On Tue, May 19, 2015 at 5=
:37 PM, Tejaswini Poluri<br>
</div></div><span>&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &lt;[1]=
[3]<a href=3D"mailto:tejaswinipoluri3@gmail.com" target=3D"_blank">tejaswin=
ipoluri3@gmail.com</a>&gt; wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 Thanks a lot Ben. =
I will look into it more.=C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 On Mon, May 18, 20=
15 at 9:57 PM, Benjamin Marzinski<br>
</span><div><div>&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 &=
lt;[2][4]<a href=3D"mailto:bmarzins@redhat.com" target=3D"_blank">bmarzins@=
redhat.com</a>&gt; wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 On Mon, May=
 18, 2015 at 02:09:27PM +0530, Tejaswini Poluri<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 Hii,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 We are trying to test multipath setup in our target and<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 tried the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 various<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 commands of multipathd demaon and we find the following<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 error:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 root@x86-generic-64:~# multipathd -k&quot;fail path sdc&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 multipathd<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 -k&#39;reinstate path<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 sdc&#39;; multipathd -k&quot;show paths&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 [ 3962.708523] device-mapper: multipath: Failing<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 path=C2=A08:32.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 ok<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 ok<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 hcil=C2=A0 =C2=A0 dev dev_t pri dm_st=C2=A0 =C2=A0chk_st=C2=A0 =C2=
=A0next_check<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 4:0:0:1 sdc=C2=A08:32=C2=A0 1=C2=A0 =C2=A0[active][faulty] .........=
. 1/20=C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;&lt;&lt;=3D=3D=3D<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 CHECK<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 5:0:0:1 sdd=C2=A08:48=C2=A0 1=C2=A0 =C2=A0[active][ready]=C2=A0 XX..=
...... 4/20<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 sdc path becomes [active][ready] only after the polling<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 interval<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 but not<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 immediately after the reinstate path command.=C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 I am observing this in latest multipath tools in ubuntu<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 machine<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 as well.<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 Please let me know if its a known issue or if I am doing<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 something w=
rong.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 Regards.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =
=C2=A0 Tejaswini<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 the reinsta=
te command is supposed to reinstate the device<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 with the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 kernel, and=
 it does that. The checker state doesn&#39;t change<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 until the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 next time t=
hat the path is checked.=C2=A0 I agree that it&#39;s odd<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 that the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 check state=
 switches to faulty as soon as you fail the path,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 but it<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 doesn&#39;t=
 switch back until the next check after you reinistate<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 it.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 The issue i=
s that multipathd needs to override the checker<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 output,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 so that a f=
ailed path won&#39;t be immeditately reinstated.=C2=A0 Once<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 path comes =
back, multipathd wants to record the switch in the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 checker<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 thread, so =
that it can refresh path information what wasn&#39;t<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 automatical=
ly done when the path was reinstated.=C2=A0 However, it<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 may make<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 more sense =
to have a different checker state for when the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 device is<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 in the fail=
ed state, so that it&#39;s obvious that the checker<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 state is<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 being overr=
uled.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 -Ben<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt; --<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt; dm-dev=
el mailing list<br>
</div></div>&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 &gt; [3][5]<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-dev=
el@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt; [4][6]=
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 --<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 dm-devel ma=
iling list<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 [5][7]<a hr=
ef=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.com</a>=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 [6][8]<a hr=
ef=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"noreferrer" =
target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt; References<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Visible links<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 1. mailto:[9]<a href=3D"m=
ailto:tejaswinipoluri3@gmail.com" target=3D"_blank">tejaswinipoluri3@gmail.=
com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 2. mailto:[10]<a href=3D"=
mailto:bmarzins@redhat.com" target=3D"_blank">bmarzins@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 3. mailto:[11]<a href=3D"=
mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 4. [12]<a href=3D"https:/=
/www.redhat.com/mailman/listinfo/dm-devel" rel=3D"noreferrer" target=3D"_bl=
ank">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 5. mailto:[13]<a href=3D"=
mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 6. [14]<a href=3D"https:/=
/www.redhat.com/mailman/listinfo/dm-devel" rel=3D"noreferrer" target=3D"_bl=
ank">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
<span>&gt;<br>
&gt; References<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 Visible links<br>
&gt;=C2=A0 =C2=A0 1. mailto:<a href=3D"mailto:tejaswinipoluri3@gmail.com" t=
arget=3D"_blank">tejaswinipoluri3@gmail.com</a><br>
&gt;=C2=A0 =C2=A0 2. mailto:<a href=3D"mailto:bmarzins@redhat.com" target=
=3D"_blank">bmarzins@redhat.com</a><br>
</span>&gt;=C2=A0 =C2=A0 3. mailto:<a href=3D"mailto:tejaswinipoluri3@gmail=
.com" target=3D"_blank">tejaswinipoluri3@gmail.com</a><br>
&gt;=C2=A0 =C2=A0 4. mailto:<a href=3D"mailto:bmarzins@redhat.com" target=
=3D"_blank">bmarzins@redhat.com</a><br>
<span>&gt;=C2=A0 =C2=A0 5. mailto:<a href=3D"mailto:dm-devel@redhat.com" ta=
rget=3D"_blank">dm-devel@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 6. <a href=3D"https://www.redhat.com/mailman/listinfo/dm-=
devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/mailman/=
listinfo/dm-devel</a><br>
</span>&gt;=C2=A0 =C2=A0 7. mailto:<a href=3D"mailto:dm-devel@redhat.com" t=
arget=3D"_blank">dm-devel@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 8. <a href=3D"https://www.redhat.com/mailman/listinfo/dm-=
devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/mailman/=
listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A0 9. mailto:<a href=3D"mailto:tejaswinipoluri3@gmail.com" t=
arget=3D"_blank">tejaswinipoluri3@gmail.com</a><br>
&gt;=C2=A0 =C2=A010. mailto:<a href=3D"mailto:bmarzins@redhat.com" target=
=3D"_blank">bmarzins@redhat.com</a><br>
&gt;=C2=A0 =C2=A011. mailto:<a href=3D"mailto:dm-devel@redhat.com" target=
=3D"_blank">dm-devel@redhat.com</a><br>
&gt;=C2=A0 =C2=A012. <a href=3D"https://www.redhat.com/mailman/listinfo/dm-=
devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/mailman/=
listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A013. mailto:<a href=3D"mailto:dm-devel@redhat.com" target=
=3D"_blank">dm-devel@redhat.com</a><br>
&gt;=C2=A0 =C2=A014. <a href=3D"https://www.redhat.com/mailman/listinfo/dm-=
devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/mailman/=
listinfo/dm-devel</a><br>
</blockquote></div><br></div></div>

--001a11c2f82c0f5e4605192cb672--

--001a11c2f82c0f5e4d05192cb674
Content-Type: application/octet-stream; name="0.4.8_add_map_patch1"
Content-Disposition: attachment; filename="0.4.8_add_map_patch1"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ib96ejjj0

ZGlmZiAtcnVwIG11bHRpcGF0aC10b29sXzAuNC44Lm9yaWcvbGlibXVsdGlwYXRoL2Rldm1hcHBl
ci5jIG11bHRpcGF0aC10b29sXzAuNC44X2FkZF9tYXAvbGlibXVsdGlwYXRoL2Rldm1hcHBlci5j
Ci0tLSBtdWx0aXBhdGgtdG9vbF8wLjQuOC5vcmlnL2xpYm11bHRpcGF0aC9kZXZtYXBwZXIuYwky
MDE1LTA2LTE2IDEyOjQxOjQ1LjUxMzk5NDAwMCArMDUzMAorKysgbXVsdGlwYXRoLXRvb2xfMC40
LjhfYWRkX21hcC9saWJtdWx0aXBhdGgvZGV2bWFwcGVyLmMJMjAxNS0wNi0xOCAxMzowMDo0MC4z
MjEwNjAxNTIgKzA1MzAKQEAgLTUwMyw2ICs1MDMsMjcgQEAgZG1fZmx1c2hfbWFwIChjaGFyICog
bWFwbmFtZSwgY2hhciAqIHR5cAogfQogCiBleHRlcm4gaW50CitkbV9yZW1vdmVfbWFwIChjaGFy
ICogbWFwbmFtZSwgY2hhciAqIHR5cGUpCit7CisJY29uZGxvZygyLCAiJXMiLF9fZnVuY19fKTsK
KwlpZiAoIWRtX21hcF9wcmVzZW50KG1hcG5hbWUpKQorCQlyZXR1cm4gMDsKKworCWlmIChkbV90
eXBlKG1hcG5hbWUsIHR5cGUpIDw9IDApCisJCXJldHVybiAxOworCisJaWYgKGRtX3JlbW92ZV9w
YXJ0bWFwcyhtYXBuYW1lKSkKKwkJcmV0dXJuIDE7CisKKwlpZiAoZG1fZ2V0X29wZW5jb3VudCht
YXBuYW1lKSkgeworCQljb25kbG9nKDIsICIlczogbWFwIGluIHVzZSIsIG1hcG5hbWUpOworCQly
ZXR1cm4gMTsKKwl9CQorCWNvbmRsb2coNCwgIm11bHRpcGF0aCBtYXAgJXMgcmVtb3ZlZCIsIG1h
cG5hbWUpOworCQlyZXR1cm4gMDsKK30KKworZXh0ZXJuIGludAogZG1fZmx1c2hfbWFwcyAoY2hh
ciAqIHR5cGUpCiB7CiAJaW50IHIgPSAwOwpkaWZmIC1ydXAgbXVsdGlwYXRoLXRvb2xfMC40Ljgu
b3JpZy9saWJtdWx0aXBhdGgvZGV2bWFwcGVyLmggbXVsdGlwYXRoLXRvb2xfMC40LjhfYWRkX21h
cC9saWJtdWx0aXBhdGgvZGV2bWFwcGVyLmgKLS0tIG11bHRpcGF0aC10b29sXzAuNC44Lm9yaWcv
bGlibXVsdGlwYXRoL2Rldm1hcHBlci5oCTIwMTUtMDUtMTIgMTc6NTA6NDguNDg4MjkzMDAwICsw
NTMwCisrKyBtdWx0aXBhdGgtdG9vbF8wLjQuOF9hZGRfbWFwL2xpYm11bHRpcGF0aC9kZXZtYXBw
ZXIuaAkyMDE1LTA2LTE4IDExOjQ4OjQxLjkwODk1MDg3OCArMDUzMApAQCAtOCw2ICs4LDcgQEAg
aW50IGRtX2dldF9tYXAoY2hhciAqLCB1bnNpZ25lZCBsb25nIGxvbgogaW50IGRtX2dldF9zdGF0
dXMoY2hhciAqLCBjaGFyICopOwogaW50IGRtX3R5cGUoY2hhciAqLCBjaGFyICopOwogaW50IGRt
X2ZsdXNoX21hcCAoY2hhciAqLCBjaGFyICopOworaW50IGRtX3JlbW92ZV9tYXAgKGNoYXIgKiwg
Y2hhciAqKTsKIGludCBkbV9mbHVzaF9tYXBzIChjaGFyICopOwogaW50IGRtX2ZhaWxfcGF0aChj
aGFyICogbWFwbmFtZSwgY2hhciAqIHBhdGgpOwogaW50IGRtX3JlaW5zdGF0ZV9wYXRoKGNoYXIg
KiBtYXBuYW1lLCBjaGFyICogcGF0aCk7CmRpZmYgLXJ1cCBtdWx0aXBhdGgtdG9vbF8wLjQuOC5v
cmlnL211bHRpcGF0aGQvbWFpbi5jIG11bHRpcGF0aC10b29sXzAuNC44X2FkZF9tYXAvbXVsdGlw
YXRoZC9tYWluLmMKLS0tIG11bHRpcGF0aC10b29sXzAuNC44Lm9yaWcvbXVsdGlwYXRoZC9tYWlu
LmMJMjAxNS0wNS0xMiAxNzo1MDo0OC40OTYyOTMwMDAgKzA1MzAKKysrIG11bHRpcGF0aC10b29s
XzAuNC44X2FkZF9tYXAvbXVsdGlwYXRoZC9tYWluLmMJMjAxNS0wNi0xOCAxMzoxMTowMy45MTcw
NzU5MzIgKzA1MzAKQEAgLTE3NSw3ICsxNzUsMzEgQEAgc3luY19tYXBzX3N0YXRlKHZlY3RvciBt
cHZlYykKIAl2ZWN0b3JfZm9yZWFjaF9zbG90IChtcHZlYywgbXBwLCBpKQogCQlzeW5jX21hcF9z
dGF0ZShtcHApOwogfQorc3RhdGljIGludAorZGlzY2FyZF9tYXAoc3RydWN0IG11bHRpcGF0aCAq
IG1wcCwgc3RydWN0IHZlY3RvcnMgKiB2ZWNzKQoreworCS8qCisJICogY2xlYXIgcmVmZXJlbmNl
cyB0byB0aGlzIG1hcCBiZWZvcmUgZmx1c2hpbmcgc28gd2UgY2FuIGlnbm9yZQorCSAqIHRoZSBz
cHVyaW91cyB1ZXZlbnQgd2UgbWF5IGdlbmVyYXRlIHdpdGggdGhlIGRtX2ZsdXNoX21hcCBjYWxs
IGJlbG93CisJICovCisJaWYgKGRtX3JlbW92ZV9tYXAobXBwLT5hbGlhcywgREVGQVVMVF9UQVJH
RVQpKSB7CisJCS8qCisJCSAqIE1heSBub3QgcmVhbGx5IGJlIGFuIGVycm9yIC0tIGlmIHRoZSBt
YXAgd2FzIGFscmVhZHkgZmx1c2hlZAorCQkgKiBmcm9tIHRoZSBkZXZpY2UgbWFwcGVyIGJ5IGRt
c2V0dXAoOCkgZm9yIGluc3RhbmNlLgorCQkgKi8KKwkJY29uZGxvZygwLCAiJXM6IGNhbid0IGZs
dXNoIiwgbXBwLT5hbGlhcyk7CisJCXJldHVybiAxOworCX0KKwllbHNlIHsKKwkJZG1fbGliX3Jl
bGVhc2UoKTsKKwkJY29uZGxvZygzLCAiJXM6IGRldm1hcCByZW1vdmVkIiwgbXBwLT5hbGlhcyk7
CisJfQogCisJb3JwaGFuX3BhdGhzKHZlY3MtPnBhdGh2ZWMsIG1wcCk7CisJcmVtb3ZlX21hcCht
cHAsIHZlY3MsIHN0b3Bfd2FpdGVyX3RocmVhZCwgMSk7CisKKwlyZXR1cm4gMDsKK30KIHN0YXRp
YyBpbnQKIGZsdXNoX21hcChzdHJ1Y3QgbXVsdGlwYXRoICogbXBwLCBzdHJ1Y3QgdmVjdG9ycyAq
IHZlY3MpCiB7CkBAIC0yOTQsNyArMzE4LDggQEAgZXZfcmVtb3ZlX21hcCAoY2hhciAqIGRldm5h
bWUsIHN0cnVjdCB2ZQogCQkJZGV2bmFtZSk7CiAJCXJldHVybiAwOwogCX0KLQlmbHVzaF9tYXAo
bXBwLCB2ZWNzKTsKKwkvL2ZsdXNoX21hcChtcHAsIHZlY3MpOworCWRpc2NhcmRfbWFwKG1wcCwg
dmVjcyk7CiAKIAlyZXR1cm4gMDsKIH0K
--001a11c2f82c0f5e4d05192cb674
Content-Type: application/octet-stream; name="0.5.0_add_map_patch2"
Content-Disposition: attachment; filename="0.5.0_add_map_patch2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ib96fi9a1

ZGlmZiAtLWdpdCBhL211bHRpcGF0aGQvY2xpX2hhbmRsZXJzLmMgYi9tdWx0aXBhdGhkL2NsaV9o
YW5kbGVycy5jCmluZGV4IGRjOTZjNDUuLmI1M2ZlMDMgMTAwNjQ0Ci0tLSBhL211bHRpcGF0aGQv
Y2xpX2hhbmRsZXJzLmMKKysrIGIvbXVsdGlwYXRoZC9jbGlfaGFuZGxlcnMuYwpAQCAtNTM3LDcg
KzUzNyw3IEBAIGNsaV9hZGRfbWFwICh2b2lkICogdiwgY2hhciAqKiByZXBseSwgaW50ICogbGVu
LCB2b2lkICogZGF0YSkKIAljaGFyIGRldl9wYXRoW1BBVEhfU0laRV07CiAJY2hhciAqYWxpYXM7
CiAJaW50IHJjOwotCisJY2hhciAqcmVmd3dpZDsKIAlwYXJhbSA9IGNvbnZlcnRfZGV2KHBhcmFt
LCAwKTsKIAljb25kbG9nKDIsICIlczogYWRkIG1hcCAob3BlcmF0b3IpIiwgcGFyYW0pOwogCkBA
IC01NDcsNiArNTQ3LDE0IEBAIGNsaV9hZGRfbWFwICh2b2lkICogdiwgY2hhciAqKiByZXBseSwg
aW50ICogbGVuLCB2b2lkICogZGF0YSkKIAkJY29uZGxvZygyLCAiJXM6IG1hcCBibGFja2xpc3Rl
ZCIsIHBhcmFtKTsKIAkJcmV0dXJuIDA7CiAJfQorCXJjID0gZ2V0X3JlZnd3aWQocGFyYW0sIERF
Vl9ERVZNQVAsIHZlY3MtPnBhdGh2ZWMsICZyZWZ3d2lkKTsKKworICAgICAgICBpZiAocmVmd3dp
ZCkgeworICAgICAgICAgICAgICAgIGNvbmRsb2coMiwgIiVzOiBhZGQgbWFwIChvcGVyYXRvciki
LCByZWZ3d2lkKTsKKyAgICAgICAgICAgICAgICBpZihjb2FsZXNjZV9wYXRocyh2ZWNzLCBOVUxM
LCByZWZ3d2lkLCAwKSkKKwkJCWNvbmRsb2coMiwgIiVzOiBjb2FsZXNjZS1wYXRocyBmYWlsZWQi
LCBwYXJhbSk7CisgICAgICAgICAgICAgICAgZG1fbGliX3JlbGVhc2UoKTsKKyAgICAgICAgfQog
CW1pbm9yID0gZG1fZ2V0X21pbm9yKHBhcmFtKTsKIAlpZiAobWlub3IgPCAwKSB7CiAJCWNvbmRs
b2coMiwgIiVzOiBub3QgYSBkZXZpY2UgbWFwcGVyIHRhYmxlIiwgcGFyYW0pOwo=
--001a11c2f82c0f5e4d05192cb674
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--001a11c2f82c0f5e4d05192cb674--
