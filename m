From: Tejaswini Poluri <tejaswinipoluri3@gmail.com>
Subject: Re: reinstate path not working
Date: Fri, 26 Jun 2015 12:21:48 +0530
Message-ID: <CAH=b03uPbi4XAFPGNQxjmsyGN2HRWUef0BSEE+HPsVhGwnXhVg@mail.gmail.com>
References: <CAH=b03uWBZrOpVtAvifGmJxR83iNcGp5Q1KBzQBcpmsOwvpW=w@mail.gmail.com>
	<20150518162747.GE8491@octiron.msp.redhat.com>
	<CAH=b03t3QGuHM_x-eQTGZRkpYsAmOT4yMRCPQhp-smWM6ZXRhw@mail.gmail.com>
	<CAH=b03v=haA-5A=Vj1EhDVnhDePAZ5u=UaWdhW7zQxGcS8hV2Q@mail.gmail.com>
	<20150605220649.GD2754@octiron.msp.redhat.com>
	<CAH=b03vRNbV0oFze-s__SMb8cDJh5VYQ3uS9OpMhHoRxZhBN=w@mail.gmail.com>
	<CAH=b03tj_EZvAh5v1OG3jhubyhQnkaN=gJsGVsjrjJMQm990zQ@mail.gmail.com>
	<20150611205149.GA1409@octiron.msp.redhat.com>
	<CAH=b03trc-vMz_O0z5Qr7bSL9R+cgFG3pZfmhFufASaUMQO=qw@mail.gmail.com>
	<20150625230244.GN1409@octiron.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8532293781481804452=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150625230244.GN1409@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8532293781481804452==
Content-Type: multipart/alternative; boundary=047d7b3a9ba28aed730519662c53

--047d7b3a9ba28aed730519662c53
Content-Type: text/plain; charset=UTF-8

Yes I agree that having the same code in both cli_add_map() and ev_add_map
is not necessary. Hence I would suggest removing get_refwwid() code from
ev_add_map as it is not being used by anyone.

ev_add_map(param, NULL, vecs) would create the multipath device by using
the get_refwwid() code and but all the functions above it like
(dm_get_minor, dm_get_major and dm_mapname) would fail and it wouldn't
enter any of the other code in ev_add_map like
1.dm_map_present,
2.add_map_without_path
3. sync_map_state
which are responsible for registering the map and displaying it.

So, I think moving the below code from ev_add_map to cli_add_map should be
a good idea right.

r = get_refwwid(dev, DEV_DEVMAP, vecs->pathvec,&refwwid);
>
>            if (refwwid) {
>                    r = coalesce_paths(vecs, NULL, refwwid,0);
>                    dm_lib_release();
>            }

What do u think?


Regards,
Tejaswini


On Fri, Jun 26, 2015 at 4:32 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Tue, Jun 23, 2015 at 03:48:26PM +0530, Tejaswini Poluri wrote:
> >    Hi Ben,
> >
> >    This is regarding the add map issue I have been discussing. Posting
> the
> >    issue again to remind.
> >
> >    Case 1 : remove and add map.
> >    root@x86-generic-64:~# multipathd -k'show maps'
> >    name    sysfs uuid
> >    dmpath0 dm-0  1IET_00010001
> >    root@x86-generic-64:~# multipathd -k'remove map dmpath0'
> >    ok
> >    root@x86-generic-64:~# multipathd -k'show maps'
> >    root@x86-generic-64:~# multipathd -k'add map dmpath0'
> >    ok
> >    root@x86-generic-64:~# multipathd -k'show maps'
> >    root@x86-generic-64:~#
> >    Once a map is removed, we are able to add it only using #multipath
> >    command and not using multipathd tools.
> >
> >    I have fixed the problem with two approaches. I would like you to
> review
> >    the same.
> >    Patch1 : By making 'remove map dmpath0' to remove only the map and
> not the
> >    device. I have added extra functions discard_map and dm_remove_map so
> as
> >    to not interfere with the existing code.
> >
> >    Patch 2: The approach you have suggested.By getting wwid from the
> mapname
> >    and doing coalesce_paths. I have just moved the following code in
> >    ev_add_map to cli_add_map.
>
> This is the general idea we'd like to go with.  However, looking at the
> latest upstream code, I don't think you should pull code in from
> ev_add_map() to cli_add_map() like your patch does. cli_add_map()
> already calls ev_add_map(), and ev_add_map() is certainly able to add
> the map if it doesn't already exist.
>
> You would just need to call it with
>
> ev_add_map(param, NULL, vecs);
>
> and ev_add_map() will happily create you a new multipath device.  All
> you need to do is make sure that all the functions that ev_add_map()
> calls with alias can accept a NULL value there.
>
> This might not be the best way to go about this, however.  It turns out
> that right now, even though ev_add_map() technically has the ability to
> create new maps, nothing currently uses it, and it really doesn't make
> sense for it to be there. Instead of just copying that code, you could
> pull the map creation code out of ev_add_map() and add it to
> cli_add_map(), for those situations where the requested device doesn't
> already exist.
>
> But having the code in both cli_add_map() and ev_add_map() when one
> already calls the other doesn't seem necessary.
>
> -Ben
>
>
> >
> >    r = get_refwwid(dev, DEV_DEVMAP, vecs->pathvec,&refwwid);
> >
> >            if (refwwid) {
> >                    r = coalesce_paths(vecs, NULL, refwwid,0);
> >                    dm_lib_release();
> >            }
> >
> >    changed dev to param.
> >
> >    I have tested the same in all 3 versions -0.4.8, 0.4.9 and 0.5.0. It
> would
> >    be great if you can review the same so that it doesn't cause any extra
> >    side effects.
> >    I guess Patch2 is the way u have suggested me in the previous mail.
> Please
> >    review it and share your views.
> >    Regards,
> >    Tejaswini
> >    On Fri, Jun 12, 2015 at 2:21 AM, Benjamin Marzinski
> >    <[1]bmarzins@redhat.com> wrote:
> >
> >      On Wed, Jun 10, 2015 at 11:46:51AM +0530, Tejaswini Poluri wrote:
> >      >
> >      >    >    We are testing multipathd tools with all the possible
> options
> >      and the
> >      >    >    following fails.
> >      >    >
> >      >    >    Case 1 : remove and add map.
> >      >    >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >    >    name    sysfs uuid
> >      >    >    dmpath0 dm-0  1IET_00010001
> >      >    >    root@x86-generic-64:~# multipathd -k'remove map dmpath0'
> >      >    >    ok
> >      >    >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >    >    root@x86-generic-64:~# multipathd -k'add map dmpath0'
> >      >    >    ok
> >      >    >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >    >    root@x86-generic-64:~#
> >      >    >    Once a map is removed, we are able to add it only using
> >      #multipath
> >      >    >    command and not using multipathd tools.
> >      >
> >      >    It is working the way it was designed, but possibly it would
> make
> >      sense
> >      >    to change the design.
> >      >
> >      >    You have mentioned that it would make sense to change the
> design to
> >      add
> >      >    map. Are there plans to change the design ?
> >      >    I am trying to understand the code flow to change the design.
> Can
> >      you
> >      >    guide me if we should stop removing the device from in the
> remove
> >      map code
> >      >    flow or start adding the device and the map in the add map code
> >      flow.
> >      >
> >      >     have tried to understand the remove map code flow of
> multipathd in
> >      0.4.8
> >      >    code.
> >
> >      I think that we want multipath to actually remove the map (instead
> of
> >      just not monitoring it) when you call "remove map <map>". We just
> want
> >      "add map <map>" to try to create the map if it doesn't exist.  To do
> >      that, you would need to first firgure out what WWID is associated
> with
> >      <map>. Presumably, <map> could either be an alias, wwid, or even the
> >      name of a path in the map. Once you found the map, you would have to
> >      call the code to create the map.
> >
> >      Also, to answer your IRC question, no the 0.4.8 code is not still
> being
> >      developed upstream.  All upstream patches only go against the
> current
> >      head. There are no other upstream branches.
> >
> >      -Ben
> >      >
> >      >    ev_remove_map (char * devname, struct vectors * vecs)
> >      >
> >      >              flush_map(mpp, vecs);
> >      >
> >      >                           dm_flush_map(mpp->alias,
> DEFAULT_TARGET);
> >      >
> >      >                                     if (!dm_map_present(mapname))
> >      >
> >      >                                            return 0;
> >      >
> >      >           if (dm_type(mapname, type) <= 0)
> >      >
> >      >                   return 1;
> >      >
> >      >           if (dm_remove_partmaps(mapname))
> >      >
> >      >                   return 1;
> >      >
> >      >           if (dm_get_opencount(mapname)) {
> >      >
> >      >                   condlog(2, "%s: map in use", mapname);
> >      >
> >      >                   return 1;
> >      >
> >      >           }
> >      >
> >      >           r = dm_simplecmd(DM_DEVICE_REMOVE, mapname);
> >      >
> >      >           if (r) {
> >      >
> >      >                   condlog(4, "multipath map %s removed", mapname);
> >      >
> >      >                                                  return 0;
> >      >
> >      >                                           }
> >      >
> >      >
> >      >
> >      >                            orphan_paths(vecs->pathvec, mpp);
> >      >
> >      >                            remove_map(mpp, vecs,
> stop_waiter_thread,
> >      1);
> >      >
> >      >    Is removing this below line, the right step to stop removing
> the
> >      device ?
> >      >    r = dm_simplecmd(DM_DEVICE_REMOVE, mapname);
> >      >
> >      >    Regards,
> >      >
> >      >    Tejaswini
> >      >
> >      >    On Mon, Jun 8, 2015 at 11:15 AM, Tejaswini Poluri
> >      >    <[1][2]tejaswinipoluri3@gmail.com> wrote:
> >      >
> >      >      Thanks a lot Ben for the quick and detailed reply. I have
> been
> >      >      struggling to understand and conclude the issues with
> multipath
> >      as I am
> >      >      the only one working from my team. Your inputs help me a lot.
> >      Thanks
> >      >      again.
> >      >      Regards,
> >      >      Tejaswini
> >      >      On Sat, Jun 6, 2015 at 3:36 AM, Benjamin Marzinski
> >      >      <[2][3]bmarzins@redhat.com> wrote:
> >      >
> >      >        On Fri, Jun 05, 2015 at 02:31:20PM +0530, Tejaswini Poluri
> >      wrote:
> >      >        >    Hii Ben,
> >      >        >
> >      >        >    We are testing multipathd tools with all the possible
> >      options and
> >      >        the
> >      >        >    following fails.
> >      >        >
> >      >        >    Case 1 : remove and add map.
> >      >        >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >        >    name    sysfs uuid
> >      >        >    dmpath0 dm-0  1IET_00010001
> >      >        >    root@x86-generic-64:~# multipathd -k'remove map
> dmpath0'
> >      >        >    ok
> >      >        >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >        >    root@x86-generic-64:~# multipathd -k'add map dmpath0'
> >      >        >    ok
> >      >        >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >        >    root@x86-generic-64:~#
> >      >        >    Once a map is removed, we are able to add it only
> using
> >      >        #multipath
> >      >        >    command and not using multipathd tools.
> >      >
> >      >        It is working the way it was designed, but possibly it
> would
> >      make
> >      >        sense
> >      >        to change the design.  The "remove map" command, not only
> stops
> >      >        multipathd from monitoring the multipath device, but it
> removes
> >      it
> >      >        from
> >      >        the system as well.  The "add map" command makes multipath
> >      monitor an
> >      >        already existing multipath device that in wasn't previously
> >      >        monitoring.
> >      >        These commands do this for historical reasons.  multipathd
> >      wasn't
> >      >        originally in charge of creating multipath devices,
> multipath
> >      was.
> >      >        Once
> >      >        it had created the device, it ran
> >      >
> >      >        multipathd -k"add map <MAP>"
> >      >
> >      >        to make multipathd start monitoring it.  However things
> haven't
> >      worked
> >      >        this way since RHEL4, so possibly "add map" should actually
> >      create the
> >      >        device if it doesn't currently exist.
> >      >        >    Case 2 : Active paths  test case
> >      >        >    # while true ; do sleep 3 ; multipathd -k'remove path
> sdb'
> >      ;
> >      >        multipathd
> >      >        >    -k'add path sdb' ; multipathd -k'show maps status' ;
> done
> >      >        >    ok
> >      >        >    ok
> >      >        >    name failback queueing paths dm-st
> >      >        >    dmpath0 - - 1 active // It should be 2.
> >      >
> >      >        This is simply a timing issue.  What you are seeing it the
> >      number of
> >      >        active paths.  These are paths that the kernel can use. The
> >      "add path"
> >      >        command doesn't update the kernel state.  This happens
> later in
> >      >        response
> >      >        to the kernel reloading the device table. So, in a second
> or
> >      two, this
> >      >        will say 2, as expected.
> >      >
> >      >        >    We would like to know if the test cases are valid and
> if
> >      these
> >      >        are bugs or
> >      >        >    any design issues.
> >      >        >
> >      >        >    Case 3 : Fail path and reinstate path
> >      >        >    root@x86-generic-64:~# multipathd -k"fail path sdc";
> >      multipathd
> >      >        >    -k'reinstate path sdc'; multipathd -k"show paths";
> >      >        >    >    [ 3962.708523] device-mapper: multipath: Failing
> path
> >      8:32.
> >      >        >    >    ok
> >      >        >    >    ok
> >      >        >    >    hcil    dev dev_t pri dm_st   chk_st   next_check
> >      >        >    >    4:0:0:1 sdc 8:32  1   [active][faulty] ..........
> >      1/20
> >      >        <==CHECK
> >      >        >    >    5:0:0:1 sdd 8:48  1   [active][ready]  XX........
> >      4/20
> >      >        >    sdc path becomes [active][ready] only after the
> polling
> >      interval
> >      >        but not
> >      >        >    immediately after the reinstate path command.
> >      >        >    You have answered that this is a design issue. But we
> have
> >      heard
> >      >        from our
> >      >        >    test team that the same test case works in RHEL6. Did
> you
> >      observe
> >      >        it?
> >      >        >    I am also finding that the test cases fail because we
> are
> >      trying
> >      >        to do
> >      >        >    multiple commands at one shot.  Please share your
> thoughts
> >      so
> >      >        that it
> >      >        >    could help me in debugging the issues further.
> >      >        >
> >      >
> >      >        It's totally possible that the checker state is immediately
> >      updated in
> >      >        RHEL6.  Like I said before, what it currently does,
> although
> >      correct,
> >      >        is confusing, and perhaps we need a different checker
> state for
> >      paths
> >      >        where the "fail path" command has been used.
> >      >
> >      >        -Ben
> >      >        >    Regards,
> >      >        >    Tejaswini
> >      >        >    On Tue, May 19, 2015 at 5:37 PM, Tejaswini Poluri
> >      >        >    <[1][3][4]tejaswinipoluri3@gmail.com> wrote:
> >      >        >
> >      >        >      Thanks a lot Ben. I will look into it more.
> >      >        >      On Mon, May 18, 2015 at 9:57 PM, Benjamin Marzinski
> >      >        >      <[2][4][5]bmarzins@redhat.com> wrote:
> >      >        >
> >      >        >        On Mon, May 18, 2015 at 02:09:27PM +0530,
> Tejaswini
> >      Poluri
> >      >        wrote:
> >      >        >        >    Hii,
> >      >        >        >    We are trying to test multipath setup in our
> >      target and
> >      >        tried the
> >      >        >        various
> >      >        >        >    commands of multipathd demaon and we find the
> >      following
> >      >        error:
> >      >        >        >    root@x86-generic-64:~# multipathd -k"fail
> path
> >      sdc";
> >      >        multipathd
> >      >        >        >    -k'reinstate path
> >      >        >        >    sdc'; multipathd -k"show paths";
> >      >        >        >    [ 3962.708523] device-mapper: multipath:
> Failing
> >      >        path 8:32.
> >      >        >        >    ok
> >      >        >        >    ok
> >      >        >        >    hcil    dev dev_t pri dm_st   chk_st
>  next_check
> >      >        >        >    4:0:0:1 sdc 8:32  1   [active][faulty]
> ..........
> >      1/20
> >      >          <<<===
> >      >        >        CHECK
> >      >        >        >    5:0:0:1 sdd 8:48  1   [active][ready]
> XX........
> >      4/20
> >      >        >        >    sdc path becomes [active][ready] only after
> the
> >      polling
> >      >        interval
> >      >        >        but not
> >      >        >        >    immediately after the reinstate path
> command.
> >      >        >        >    I am observing this in latest multipath
> tools in
> >      ubuntu
> >      >        machine
> >      >        >        as well.
> >      >        >        >    Please let me know if its a known issue or
> if I
> >      am doing
> >      >        >        something wrong.
> >      >        >        >    Regards.
> >      >        >        >    Tejaswini
> >      >        >
> >      >        >        the reinstate command is supposed to reinstate the
> >      device
> >      >        with the
> >      >        >        kernel, and it does that. The checker state
> doesn't
> >      change
> >      >        until the
> >      >        >        next time that the path is checked.  I agree that
> it's
> >      odd
> >      >        that the
> >      >        >        check state switches to faulty as soon as you
> fail the
> >      path,
> >      >        but it
> >      >        >        doesn't switch back until the next check after you
> >      reinistate
> >      >        it.
> >      >        >
> >      >        >        The issue is that multipathd needs to override the
> >      checker
> >      >        output,
> >      >        >        so that a failed path won't be immeditately
> >      reinstated.  Once
> >      >        the
> >      >        >        path comes back, multipathd wants to record the
> switch
> >      in the
> >      >        checker
> >      >        >        thread, so that it can refresh path information
> what
> >      wasn't
> >      >        >        automatically done when the path was reinstated.
> >      However, it
> >      >        may make
> >      >        >        more sense to have a different checker state for
> when
> >      the
> >      >        device is
> >      >        >        in the failed state, so that it's obvious that the
> >      checker
> >      >        state is
> >      >        >        being overruled.
> >      >        >
> >      >        >        -Ben
> >      >        >
> >      >        >        > --
> >      >        >        > dm-devel mailing list
> >      >        >        > [3][5][6]dm-devel@redhat.com
> >      >        >        >
> >      [4][6][7]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >        >
> >      >        >        --
> >      >        >        dm-devel mailing list
> >      >        >        [5][7][8]dm-devel@redhat.com
> >      >        >
> >      [6][8][9]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >        >
> >      >        > References
> >      >        >
> >      >        >    Visible links
> >      >        >    1. mailto:[9][10]tejaswinipoluri3@gmail.com
> >      >        >    2. mailto:[10][11]bmarzins@redhat.com
> >      >        >    3. mailto:[11][12]dm-devel@redhat.com
> >      >        >    4.
> >      [12][13]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >        >    5. mailto:[13][14]dm-devel@redhat.com
> >      >        >    6.
> >      [14][15]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >
> >      > References
> >      >
> >      >    Visible links
> >      >    1. mailto:[16]tejaswinipoluri3@gmail.com
> >      >    2. mailto:[17]bmarzins@redhat.com
> >      >    3. mailto:[18]tejaswinipoluri3@gmail.com
> >      >    4. mailto:[19]bmarzins@redhat.com
> >      >    5. mailto:[20]dm-devel@redhat.com
> >      >    6. [21]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >    7. mailto:[22]dm-devel@redhat.com
> >      >    8. [23]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >    9. mailto:[24]tejaswinipoluri3@gmail.com
> >      >   10. mailto:[25]bmarzins@redhat.com
> >      >   11. mailto:[26]dm-devel@redhat.com
> >      >   12. [27]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   13. mailto:[28]dm-devel@redhat.com
> >      >   14. [29]https://www.redhat.com/mailman/listinfo/dm-devel
> >
> > References
> >
> >    Visible links
> >    1. mailto:bmarzins@redhat.com
> >    2. mailto:tejaswinipoluri3@gmail.com
> >    3. mailto:bmarzins@redhat.com
> >    4. mailto:tejaswinipoluri3@gmail.com
> >    5. mailto:bmarzins@redhat.com
> >    6. mailto:dm-devel@redhat.com
> >    7. https://www.redhat.com/mailman/listinfo/dm-devel
> >    8. mailto:dm-devel@redhat.com
> >    9. https://www.redhat.com/mailman/listinfo/dm-devel
> >   10. mailto:tejaswinipoluri3@gmail.com
> >   11. mailto:bmarzins@redhat.com
> >   12. mailto:dm-devel@redhat.com
> >   13. https://www.redhat.com/mailman/listinfo/dm-devel
> >   14. mailto:dm-devel@redhat.com
> >   15. https://www.redhat.com/mailman/listinfo/dm-devel
> >   16. mailto:tejaswinipoluri3@gmail.com
> >   17. mailto:bmarzins@redhat.com
> >   18. mailto:tejaswinipoluri3@gmail.com
> >   19. mailto:bmarzins@redhat.com
> >   20. mailto:dm-devel@redhat.com
> >   21. https://www.redhat.com/mailman/listinfo/dm-devel
> >   22. mailto:dm-devel@redhat.com
> >   23. https://www.redhat.com/mailman/listinfo/dm-devel
> >   24. mailto:tejaswinipoluri3@gmail.com
> >   25. mailto:bmarzins@redhat.com
> >   26. mailto:dm-devel@redhat.com
> >   27. https://www.redhat.com/mailman/listinfo/dm-devel
> >   28. mailto:dm-devel@redhat.com
> >   29. https://www.redhat.com/mailman/listinfo/dm-devel
>
>
>
>

--047d7b3a9ba28aed730519662c53
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Yes I agree that having the same code in both cli_add=
_map() and ev_add_map is not necessary. Hence I would suggest removing get_=
refwwid() code from ev_add_map as it is not being used by anyone.<br><br>ev=
_add_map(param, NULL, vecs) would create the multipath device by using the =
get_refwwid() code and but all the functions above it like (dm_get_minor, d=
m_get_major and dm_mapname) would fail and it wouldn&#39;t enter any of the=
 other code in ev_add_map like <br>1.dm_map_present, <br>2.add_map_without_=
path<br></div><div>3. sync_map_state<br></div><div>which are responsible fo=
r registering the map and displaying it.<br><br></div><div>So, I think movi=
ng the below code from ev_add_map to cli_add_map should be a good idea righ=
t.<br><br><span class=3D"im">r =3D get_refwwid(dev, DEV_DEVMAP, vecs-&gt;pa=
thvec,&amp;refwwid);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (refwwid) {=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r =3D coalesce_paths(vecs, NULL, refwwid,=
0);<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dm_lib_release();<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }</span><br></=
div><div><br></div><div>What do u think?<br><br><br></div><div>Regards,<br>=
</div><div>Tejaswini<br></div><div><br></div></div><div class=3D"gmail_extr=
a"><br><div class=3D"gmail_quote">On Fri, Jun 26, 2015 at 4:32 AM, Benjamin=
 Marzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" tar=
get=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pa=
dding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On Tue, Jun 23, 201=
5 at 03:48:26PM +0530, Tejaswini Poluri wrote:<br>
&gt;=C2=A0 =C2=A0 Hi Ben,<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 This is regarding the add map issue I have been discussin=
g. Posting the<br>
&gt;=C2=A0 =C2=A0 issue again to remind.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 Case 1 : remove and add map.<br>
&gt;=C2=A0 =C2=A0 root@x86-generic-64:~# multipathd -k&#39;show maps&#39;<b=
r>
&gt;=C2=A0 =C2=A0 name=C2=A0=C2=A0=C2=A0 sysfs uuid<br>
&gt;=C2=A0 =C2=A0 dmpath0 dm-0=C2=A0 1IET_00010001<br>
&gt;=C2=A0 =C2=A0 root@x86-generic-64:~# multipathd -k&#39;remove map dmpat=
h0&#39;<br>
&gt;=C2=A0 =C2=A0 ok<br>
&gt;=C2=A0 =C2=A0 root@x86-generic-64:~# multipathd -k&#39;show maps&#39;<b=
r>
&gt;=C2=A0 =C2=A0 root@x86-generic-64:~# multipathd -k&#39;add map dmpath0&=
#39;<br>
&gt;=C2=A0 =C2=A0 ok<br>
&gt;=C2=A0 =C2=A0 root@x86-generic-64:~# multipathd -k&#39;show maps&#39;<b=
r>
&gt;=C2=A0 =C2=A0 root@x86-generic-64:~#<br>
&gt;=C2=A0 =C2=A0 Once a map is removed, we are able to add it only using #=
multipath=C2=A0<br>
&gt;=C2=A0 =C2=A0 command and not using multipathd tools.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 I have fixed the problem with two approaches. I would lik=
e you to review<br>
&gt;=C2=A0 =C2=A0 the same.<br>
&gt;=C2=A0 =C2=A0 Patch1 : By making &#39;remove map dmpath0&#39; to remove=
 only the map and not the<br>
&gt;=C2=A0 =C2=A0 device. I have added extra functions discard_map and dm_r=
emove_map so as<br>
&gt;=C2=A0 =C2=A0 to not interfere with the existing code.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 Patch 2: The approach you have suggested.By getting wwid =
from the mapname<br>
&gt;=C2=A0 =C2=A0 and doing coalesce_paths. I have just moved the following=
 code in<br>
&gt;=C2=A0 =C2=A0 ev_add_map to cli_add_map.<br>
<br>
</div></div>This is the general idea we&#39;d like to go with.=C2=A0 Howeve=
r, looking at the<br>
latest upstream code, I don&#39;t think you should pull code in from<br>
ev_add_map() to cli_add_map() like your patch does. cli_add_map()<br>
already calls ev_add_map(), and ev_add_map() is certainly able to add<br>
the map if it doesn&#39;t already exist.<br>
<br>
You would just need to call it with<br>
<br>
ev_add_map(param, NULL, vecs);<br>
<br>
and ev_add_map() will happily create you a new multipath device.=C2=A0 All<=
br>
you need to do is make sure that all the functions that ev_add_map()<br>
calls with alias can accept a NULL value there.<br>
<br>
This might not be the best way to go about this, however.=C2=A0 It turns ou=
t<br>
that right now, even though ev_add_map() technically has the ability to<br>
create new maps, nothing currently uses it, and it really doesn&#39;t make<=
br>
sense for it to be there. Instead of just copying that code, you could<br>
pull the map creation code out of ev_add_map() and add it to<br>
cli_add_map(), for those situations where the requested device doesn&#39;t<=
br>
already exist.<br>
<br>
But having the code in both cli_add_map() and ev_add_map() when one<br>
already calls the other doesn&#39;t seem necessary.<br>
<br>
-Ben<br>
<span class=3D""><br>
<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 r =3D get_refwwid(dev, DEV_DEVMAP, vecs-&gt;pathvec,&amp;=
refwwid);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (refwwid) {=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r =3D coalesce_paths(vecs, NULL, refwwid,=
0);<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dm_lib_release();<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 changed dev to param.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 I have tested the same in all 3 versions -0.4.8, 0.4.9 an=
d 0.5.0. It would<br>
&gt;=C2=A0 =C2=A0 be great if you can review the same so that it doesn&#39;=
t cause any extra<br>
&gt;=C2=A0 =C2=A0 side effects.<br>
&gt;=C2=A0 =C2=A0 I guess Patch2 is the way u have suggested me in the prev=
ious mail. Please<br>
&gt;=C2=A0 =C2=A0 review it and share your views.<br>
&gt;=C2=A0 =C2=A0 Regards,<br>
&gt;=C2=A0 =C2=A0 Tejaswini<br>
&gt;=C2=A0 =C2=A0 On Fri, Jun 12, 2015 at 2:21 AM, Benjamin Marzinski<br>
</span><div><div class=3D"h5">&gt;=C2=A0 =C2=A0 &lt;[1]<a href=3D"mailto:bm=
arzins@redhat.com">bmarzins@redhat.com</a>&gt; wrote:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 On Wed, Jun 10, 2015 at 11:46:51AM +0530, Tejaswin=
i Poluri wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 We are testing=
 multipathd tools with all the possible options<br>
&gt;=C2=A0 =C2=A0 =C2=A0 and the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 following fail=
s.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Case 1 : remov=
e and add map.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-gener=
ic-64:~# multipathd -k&#39;show maps&#39;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 name=C2=A0=C2=
=A0=C2=A0 sysfs uuid<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 dmpath0 dm-0=
=C2=A0 1IET_00010001<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-gener=
ic-64:~# multipathd -k&#39;remove map dmpath0&#39;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 ok<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-gener=
ic-64:~# multipathd -k&#39;show maps&#39;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-gener=
ic-64:~# multipathd -k&#39;add map dmpath0&#39;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 ok<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-gener=
ic-64:~# multipathd -k&#39;show maps&#39;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-gener=
ic-64:~#<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Once a map is =
removed, we are able to add it only using<br>
&gt;=C2=A0 =C2=A0 =C2=A0 #multipath=C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 command and no=
t using multipathd tools.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 It is working the way it was des=
igned, but possibly it would make<br>
&gt;=C2=A0 =C2=A0 =C2=A0 sense<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 to change the design.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 You have mentioned that it would=
 make sense to change the design to<br>
&gt;=C2=A0 =C2=A0 =C2=A0 add<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 map. Are there plans to change t=
he design ?<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 I am trying to understand the co=
de flow to change the design. Can<br>
&gt;=C2=A0 =C2=A0 =C2=A0 you<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 guide me if we should stop remov=
ing the device from in the remove<br>
&gt;=C2=A0 =C2=A0 =C2=A0 map code<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 flow or start adding the device =
and the map in the add map code<br>
&gt;=C2=A0 =C2=A0 =C2=A0 flow.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0have tried to understand t=
he remove map code flow of multipathd in<br>
&gt;=C2=A0 =C2=A0 =C2=A0 0.4.8<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 code.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 I think that we want multipath to actually remove =
the map (instead of<br>
&gt;=C2=A0 =C2=A0 =C2=A0 just not monitoring it) when you call &quot;remove=
 map &lt;map&gt;&quot;. We just want<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &quot;add map &lt;map&gt;&quot; to try to create t=
he map if it doesn&#39;t exist.=C2=A0 To do<br>
&gt;=C2=A0 =C2=A0 =C2=A0 that, you would need to first firgure out what WWI=
D is associated with<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &lt;map&gt;. Presumably, &lt;map&gt; could either =
be an alias, wwid, or even the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 name of a path in the map. Once you found the map,=
 you would have to<br>
&gt;=C2=A0 =C2=A0 =C2=A0 call the code to create the map.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 Also, to answer your IRC question, no the 0.4.8 co=
de is not still being<br>
&gt;=C2=A0 =C2=A0 =C2=A0 developed upstream.=C2=A0 All upstream patches onl=
y go against the current<br>
&gt;=C2=A0 =C2=A0 =C2=A0 head. There are no other upstream branches.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -Ben<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 ev_remove_map (char * devname, s=
truct vectors * vecs)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 flush_map(mpp, vecs);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 dm_flush_map(mpp-&gt;alias, DEFAULT_TARGET);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (!dm_map_present(mapname))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 =
return 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (dm_type(mapname, type) &lt;=3D 0)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (dm_remove_partmaps(mapname))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (dm_get_opencount(mapname)) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 condlog(2, &quot;%s:=
 map in use&quot;, mapname);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 } =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 r =3D dm_simplecmd(DM_DEVICE_REMOVE, mapname);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (r) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 condlog(4, &quot;mul=
tipath map %s removed&quot;, mapname);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 return 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 orphan_paths(vecs-&gt;pathvec, mpp);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 remove_map(mpp, vecs, stop_waiter_thread,=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 1);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Is removing this below line, the=
 right step to stop removing the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 device ?<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 r =3D dm_simplecmd(DM_DEVICE_REM=
OVE, mapname);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Regards,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Tejaswini<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 On Mon, Jun 8, 2015 at 11:15 AM,=
 Tejaswini Poluri<br>
</div></div><span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &lt=
;[1][2]<a href=3D"mailto:tejaswinipoluri3@gmail.com">tejaswinipoluri3@gmail=
.com</a>&gt; wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 Thanks a lot Ben for the =
quick and detailed reply. I have been<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 struggling to understand =
and conclude the issues with multipath<br>
&gt;=C2=A0 =C2=A0 =C2=A0 as I am<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 the only one working from=
 my team. Your inputs help me a lot.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 Thanks<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 again.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 Regards,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 Tejaswini<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 On Sat, Jun 6, 2015 at 3:=
36 AM, Benjamin Marzinski<br>
</span><div><div class=3D"h5">&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 &lt;[2][3]<a href=3D"mailto:bmarzins@redhat.com">bmarzins@redhat.com=
</a>&gt; wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 On Fri, Jun 05, 20=
15 at 02:31:20PM +0530, Tejaswini Poluri<br>
&gt;=C2=A0 =C2=A0 =C2=A0 wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
Hii Ben,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
We are testing multipathd tools with all the possible<br>
&gt;=C2=A0 =C2=A0 =C2=A0 options and<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
following fails.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
Case 1 : remove and add map.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
root@x86-generic-64:~# multipathd -k&#39;show maps&#39;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
name=C2=A0=C2=A0=C2=A0 sysfs uuid<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
dmpath0 dm-0=C2=A0 1IET_00010001<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
root@x86-generic-64:~# multipathd -k&#39;remove map dmpath0&#39;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
ok<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
root@x86-generic-64:~# multipathd -k&#39;show maps&#39;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
root@x86-generic-64:~# multipathd -k&#39;add map dmpath0&#39;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
ok<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
root@x86-generic-64:~# multipathd -k&#39;show maps&#39;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
root@x86-generic-64:~#<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
Once a map is removed, we are able to add it only using<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 #multipath=C2=A0<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
command and not using multipathd tools.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 It is working the =
way it was designed, but possibly it would<br>
&gt;=C2=A0 =C2=A0 =C2=A0 make<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 sense<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 to change the desi=
gn.=C2=A0 The &quot;remove map&quot; command, not only stops<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 multipathd from mo=
nitoring the multipath device, but it removes<br>
&gt;=C2=A0 =C2=A0 =C2=A0 it<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 from<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 the system as well=
.=C2=A0 The &quot;add map&quot; command makes multipath<br>
&gt;=C2=A0 =C2=A0 =C2=A0 monitor an<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 already existing m=
ultipath device that in wasn&#39;t previously<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 monitoring.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 These commands do =
this for historical reasons.=C2=A0 multipathd<br>
&gt;=C2=A0 =C2=A0 =C2=A0 wasn&#39;t<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 originally in char=
ge of creating multipath devices, multipath<br>
&gt;=C2=A0 =C2=A0 =C2=A0 was.=C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 Once<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 it had created the=
 device, it ran<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 multipathd -k&quot=
;add map &lt;MAP&gt;&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 to make multipathd=
 start monitoring it.=C2=A0 However things haven&#39;t<br>
&gt;=C2=A0 =C2=A0 =C2=A0 worked<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 this way since RHE=
L4, so possibly &quot;add map&quot; should actually<br>
&gt;=C2=A0 =C2=A0 =C2=A0 create the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 device if it doesn=
&#39;t currently exist.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
Case 2 : Active paths=C2=A0 test case<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
# while true ; do sleep 3 ; multipathd -k&#39;remove path sdb&#39;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 ;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 multipathd<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
-k&#39;add path sdb&#39; ; multipathd -k&#39;show maps status&#39; ; done<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
ok<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
ok<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
name failback queueing paths dm-st<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
dmpath0 - - 1 active // It should be 2.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 This is simply a t=
iming issue.=C2=A0 What you are seeing it the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 number of<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 active paths.=C2=
=A0 These are paths that the kernel can use. The<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &quot;add path&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 command doesn&#39;=
t update the kernel state.=C2=A0 This happens later in<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 response<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 to the kernel relo=
ading the device table. So, in a second or<br>
&gt;=C2=A0 =C2=A0 =C2=A0 two, this<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 will say 2, as exp=
ected.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
We would like to know if the test cases are valid and if<br>
&gt;=C2=A0 =C2=A0 =C2=A0 these<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 are bugs or<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
any design issues.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
Case 3 : Fail path and reinstate path<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
root@x86-generic-64:~# multipathd -k&quot;fail path sdc&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 multipathd<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
-k&#39;reinstate path sdc&#39;; multipathd -k&quot;show paths&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
&gt;=C2=A0=C2=A0=C2=A0 [ 3962.708523] device-mapper: multipath: Failing pat=
h<br>
&gt;=C2=A0 =C2=A0 =C2=A0 8:32.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
&gt;=C2=A0=C2=A0=C2=A0 ok<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
&gt;=C2=A0=C2=A0=C2=A0 ok<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
&gt;=C2=A0=C2=A0=C2=A0 hcil=C2=A0=C2=A0=C2=A0 dev dev_t pri dm_st=C2=A0=C2=
=A0 chk_st=C2=A0=C2=A0 next_check<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
&gt;=C2=A0=C2=A0=C2=A0 4:0:0:1 sdc 8:32=C2=A0 1=C2=A0=C2=A0 [active][faulty=
] ..........<br>
&gt;=C2=A0 =C2=A0 =C2=A0 1/20=C2=A0=C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;=3D=3DCHECK<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
&gt;=C2=A0=C2=A0=C2=A0 5:0:0:1 sdd 8:48=C2=A0 1=C2=A0=C2=A0 [active][ready]=
=C2=A0 XX........<br>
&gt;=C2=A0 =C2=A0 =C2=A0 4/20<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
sdc path becomes [active][ready] only after the polling<br>
&gt;=C2=A0 =C2=A0 =C2=A0 interval<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 but not<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
immediately after the reinstate path command.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
You have answered that this is a design issue. But we have<br>
&gt;=C2=A0 =C2=A0 =C2=A0 heard<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 from our<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
test team that the same test case works in RHEL6. Did you<br>
&gt;=C2=A0 =C2=A0 =C2=A0 observe<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 it?<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
I am also finding that the test cases fail because we are<br>
&gt;=C2=A0 =C2=A0 =C2=A0 trying<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 to do<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
multiple commands at one shot.=C2=A0 Please share your thoughts<br>
&gt;=C2=A0 =C2=A0 =C2=A0 so<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 that it<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
could help me in debugging the issues further.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 It&#39;s totally p=
ossible that the checker state is immediately<br>
&gt;=C2=A0 =C2=A0 =C2=A0 updated in<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 RHEL6.=C2=A0 Like =
I said before, what it currently does, although<br>
&gt;=C2=A0 =C2=A0 =C2=A0 correct,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 is confusing, and =
perhaps we need a different checker state for<br>
&gt;=C2=A0 =C2=A0 =C2=A0 paths<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 where the &quot;fa=
il path&quot; command has been used.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 -Ben<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
Regards,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
Tejaswini<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
On Tue, May 19, 2015 at 5:37 PM, Tejaswini Poluri<br>
</div></div><span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 &gt;=C2=A0 =C2=A0 &lt;[1][3][4]<a href=3D"mailto:tejaswinipoluri=
3@gmail.com">tejaswinipoluri3@gmail.com</a>&gt; wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 Thanks a lot Ben. I will look into it more.=C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 On Mon, May 18, 2015 at 9:57 PM, Benjamin Marzinski<br>
</span><div><div class=3D"h5">&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 &lt;[2][4][5]<a href=3D"mailto:bmarz=
ins@redhat.com">bmarzins@redhat.com</a>&gt; wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 On Mon, May 18, 2015 at 02:09:27PM +0530, Tejaswini<br>
&gt;=C2=A0 =C2=A0 =C2=A0 Poluri<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Hii,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 We are trying to test multipath setup in ou=
r<br>
&gt;=C2=A0 =C2=A0 =C2=A0 target and<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 tried the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 various<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 commands of multipathd demaon and we find t=
he<br>
&gt;=C2=A0 =C2=A0 =C2=A0 following<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 error:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 root@x86-generic-64:~# multipathd -k&quot;f=
ail path<br>
&gt;=C2=A0 =C2=A0 =C2=A0 sdc&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 multipathd<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 -k&#39;reinstate path<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 sdc&#39;; multipathd -k&quot;show paths&quo=
t;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 [ 3962.708523] device-mapper: multipath: Fa=
iling<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 path=C2=A08:32.<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 ok<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 ok<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 hcil=C2=A0 =C2=A0 dev dev_t pri dm_st=C2=A0=
 =C2=A0chk_st=C2=A0 =C2=A0next_check<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 4:0:0:1 sdc=C2=A08:32=C2=A0 1=C2=A0 =C2=A0[=
active][faulty] ..........<br>
&gt;=C2=A0 =C2=A0 =C2=A0 1/20=C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;&lt;&lt=
;=3D=3D=3D<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 CHECK<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 5:0:0:1 sdd=C2=A08:48=C2=A0 1=C2=A0 =C2=A0[=
active][ready]=C2=A0 XX........<br>
&gt;=C2=A0 =C2=A0 =C2=A0 4/20<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 sdc path becomes [active][ready] only after=
 the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 polling<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 interval<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 but not<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 immediately after the reinstate path comman=
d.=C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 I am observing this in latest multipath too=
ls in<br>
&gt;=C2=A0 =C2=A0 =C2=A0 ubuntu<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 machine<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 as well.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Please let me know if its a known issue or =
if I<br>
&gt;=C2=A0 =C2=A0 =C2=A0 am doing<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 something wrong.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Regards.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Tejaswini<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 the reinstate command is supposed to reinstate the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 device<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 with the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 kernel, and it does that. The checker state doesn&#39;t<br>
&gt;=C2=A0 =C2=A0 =C2=A0 change<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 until the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 next time that the path is checked.=C2=A0 I agree that it&#39=
;s<br>
&gt;=C2=A0 =C2=A0 =C2=A0 odd<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 that the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 check state switches to faulty as soon as you fail the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 path,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 but it<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 doesn&#39;t switch back until the next check after you<br>
&gt;=C2=A0 =C2=A0 =C2=A0 reinistate<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 it.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 The issue is that multipathd needs to override the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 checker<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 output,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 so that a failed path won&#39;t be immeditately<br>
&gt;=C2=A0 =C2=A0 =C2=A0 reinstated.=C2=A0 Once<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 path comes back, multipathd wants to record the switch<br>
&gt;=C2=A0 =C2=A0 =C2=A0 in the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 checker<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 thread, so that it can refresh path information what<br>
&gt;=C2=A0 =C2=A0 =C2=A0 wasn&#39;t<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 automatically done when the path was reinstated.=C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 However, it<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 may make<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 more sense to have a different checker state for when<br>
&gt;=C2=A0 =C2=A0 =C2=A0 the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 device is<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 in the failed state, so that it&#39;s obvious that the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 checker<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 state is<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 being overruled.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 -Ben<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt; --<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt; dm-devel mailing list<br>
</div></div>&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt; [3][5][6]<a href=3D"mailto:dm-devel@redhat=
.com">dm-devel@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 [4][6][7]<a href=3D"https://www.redhat.com/mailman=
/listinfo/dm-devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat=
.com/mailman/listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 --<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 dm-devel mailing list<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 [5][7][8]<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redh=
at.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 [6][8][9]<a href=3D"https://www.redhat.com/mailman=
/listinfo/dm-devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat=
.com/mailman/listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt; References<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
Visible links<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
1. mailto:[9][10]<a href=3D"mailto:tejaswinipoluri3@gmail.com">tejaswinipol=
uri3@gmail.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
2. mailto:[10][11]<a href=3D"mailto:bmarzins@redhat.com">bmarzins@redhat.co=
m</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
3. mailto:[11][12]<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.co=
m</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
4.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 [12][13]<a href=3D"https://www.redhat.com/mailman/=
listinfo/dm-devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.=
com/mailman/listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
5. mailto:[13][14]<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.co=
m</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =
6.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 [14][15]<a href=3D"https://www.redhat.com/mailman/=
listinfo/dm-devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.=
com/mailman/listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; References<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 Visible links<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 1. mailto:[16]<a href=3D"mailto:=
tejaswinipoluri3@gmail.com">tejaswinipoluri3@gmail.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 2. mailto:[17]<a href=3D"mailto:=
bmarzins@redhat.com">bmarzins@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 3. mailto:[18]<a href=3D"mailto:=
tejaswinipoluri3@gmail.com">tejaswinipoluri3@gmail.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 4. mailto:[19]<a href=3D"mailto:=
bmarzins@redhat.com">bmarzins@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 5. mailto:[20]<a href=3D"mailto:=
dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 6. [21]<a href=3D"https://www.re=
dhat.com/mailman/listinfo/dm-devel" rel=3D"noreferrer" target=3D"_blank">ht=
tps://www.redhat.com/mailman/listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 7. mailto:[22]<a href=3D"mailto:=
dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 8. [23]<a href=3D"https://www.re=
dhat.com/mailman/listinfo/dm-devel" rel=3D"noreferrer" target=3D"_blank">ht=
tps://www.redhat.com/mailman/listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 9. mailto:[24]<a href=3D"mailto:=
tejaswinipoluri3@gmail.com">tejaswinipoluri3@gmail.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A010. mailto:[25]<a href=3D"mailto:=
bmarzins@redhat.com">bmarzins@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A011. mailto:[26]<a href=3D"mailto:=
dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A012. [27]<a href=3D"https://www.re=
dhat.com/mailman/listinfo/dm-devel" rel=3D"noreferrer" target=3D"_blank">ht=
tps://www.redhat.com/mailman/listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A013. mailto:[28]<a href=3D"mailto:=
dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A014. [29]<a href=3D"https://www.re=
dhat.com/mailman/listinfo/dm-devel" rel=3D"noreferrer" target=3D"_blank">ht=
tps://www.redhat.com/mailman/listinfo/dm-devel</a><br>
&gt;<br>
&gt; References<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 Visible links<br>
&gt;=C2=A0 =C2=A0 1. mailto:<a href=3D"mailto:bmarzins@redhat.com">bmarzins=
@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 2. mailto:<a href=3D"mailto:tejaswinipoluri3@gmail.com">t=
ejaswinipoluri3@gmail.com</a><br>
&gt;=C2=A0 =C2=A0 3. mailto:<a href=3D"mailto:bmarzins@redhat.com">bmarzins=
@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 4. mailto:<a href=3D"mailto:tejaswinipoluri3@gmail.com">t=
ejaswinipoluri3@gmail.com</a><br>
&gt;=C2=A0 =C2=A0 5. mailto:<a href=3D"mailto:bmarzins@redhat.com">bmarzins=
@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 6. mailto:<a href=3D"mailto:dm-devel@redhat.com">dm-devel=
@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 7. <a href=3D"https://www.redhat.com/mailman/listinfo/dm-=
devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/mailman/=
listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A0 8. mailto:<a href=3D"mailto:dm-devel@redhat.com">dm-devel=
@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 9. <a href=3D"https://www.redhat.com/mailman/listinfo/dm-=
devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/mailman/=
listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A010. mailto:<a href=3D"mailto:tejaswinipoluri3@gmail.com">t=
ejaswinipoluri3@gmail.com</a><br>
&gt;=C2=A0 =C2=A011. mailto:<a href=3D"mailto:bmarzins@redhat.com">bmarzins=
@redhat.com</a><br>
&gt;=C2=A0 =C2=A012. mailto:<a href=3D"mailto:dm-devel@redhat.com">dm-devel=
@redhat.com</a><br>
&gt;=C2=A0 =C2=A013. <a href=3D"https://www.redhat.com/mailman/listinfo/dm-=
devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/mailman/=
listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A014. mailto:<a href=3D"mailto:dm-devel@redhat.com">dm-devel=
@redhat.com</a><br>
&gt;=C2=A0 =C2=A015. <a href=3D"https://www.redhat.com/mailman/listinfo/dm-=
devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/mailman/=
listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A016. mailto:<a href=3D"mailto:tejaswinipoluri3@gmail.com">t=
ejaswinipoluri3@gmail.com</a><br>
&gt;=C2=A0 =C2=A017. mailto:<a href=3D"mailto:bmarzins@redhat.com">bmarzins=
@redhat.com</a><br>
&gt;=C2=A0 =C2=A018. mailto:<a href=3D"mailto:tejaswinipoluri3@gmail.com">t=
ejaswinipoluri3@gmail.com</a><br>
&gt;=C2=A0 =C2=A019. mailto:<a href=3D"mailto:bmarzins@redhat.com">bmarzins=
@redhat.com</a><br>
&gt;=C2=A0 =C2=A020. mailto:<a href=3D"mailto:dm-devel@redhat.com">dm-devel=
@redhat.com</a><br>
&gt;=C2=A0 =C2=A021. <a href=3D"https://www.redhat.com/mailman/listinfo/dm-=
devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/mailman/=
listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A022. mailto:<a href=3D"mailto:dm-devel@redhat.com">dm-devel=
@redhat.com</a><br>
&gt;=C2=A0 =C2=A023. <a href=3D"https://www.redhat.com/mailman/listinfo/dm-=
devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/mailman/=
listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A024. mailto:<a href=3D"mailto:tejaswinipoluri3@gmail.com">t=
ejaswinipoluri3@gmail.com</a><br>
&gt;=C2=A0 =C2=A025. mailto:<a href=3D"mailto:bmarzins@redhat.com">bmarzins=
@redhat.com</a><br>
&gt;=C2=A0 =C2=A026. mailto:<a href=3D"mailto:dm-devel@redhat.com">dm-devel=
@redhat.com</a><br>
&gt;=C2=A0 =C2=A027. <a href=3D"https://www.redhat.com/mailman/listinfo/dm-=
devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/mailman/=
listinfo/dm-devel</a><br>
&gt;=C2=A0 =C2=A028. mailto:<a href=3D"mailto:dm-devel@redhat.com">dm-devel=
@redhat.com</a><br>
&gt;=C2=A0 =C2=A029. <a href=3D"https://www.redhat.com/mailman/listinfo/dm-=
devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/mailman/=
listinfo/dm-devel</a><br>
<br>
<br>
<br>
</blockquote></div><br></div>

--047d7b3a9ba28aed730519662c53--


--===============8532293781481804452==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8532293781481804452==--
