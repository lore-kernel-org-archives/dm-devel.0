From: Tejaswini Poluri <tejaswinipoluri3@gmail.com>
Subject: Re: reinstate path not working
Date: Tue, 30 Jun 2015 11:22:37 +0530
Message-ID: <CAH=b03sF=a8DbbspoxNYkzJaBDSCxV-sG6b4W0rN1GAxJtKDhg@mail.gmail.com>
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
	<20150629192012.GO1409@octiron.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2216121049492845943=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150629192012.GO1409@octiron.msp.redhat.com>
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

--===============2216121049492845943==
Content-Type: multipart/alternative; boundary=001a11c2edbe45aa5e0519b5d0c0

--001a11c2edbe45aa5e0519b5d0c0
Content-Type: text/plain; charset=UTF-8

Thanks Ben. So should I push the code to the upstream and get an approval?


Regards,
Tejaswini

On Tue, Jun 30, 2015 at 12:50 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Fri, Jun 26, 2015 at 12:21:48PM +0530, Tejaswini Poluri wrote:
> >    Yes I agree that having the same code in both cli_add_map() and
> ev_add_map
> >    is not necessary. Hence I would suggest removing get_refwwid() code
> from
> >    ev_add_map as it is not being used by anyone.
> >
> >    ev_add_map(param, NULL, vecs) would create the multipath device by
> using
> >    the get_refwwid() code and but all the functions above it like
> >    (dm_get_minor, dm_get_major and dm_mapname) would fail and it wouldn't
> >    enter any of the other code in ev_add_map like
> >    1.dm_map_present,
> >    2.add_map_without_path
> >    3. sync_map_state
> >    which are responsible for registering the map and displaying it.
> >
> >    So, I think moving the below code from ev_add_map to cli_add_map
> should be
> >    a good idea right.
> >
> >    r = get_refwwid(dev, DEV_DEVMAP, vecs->pathvec,&refwwid);
> >    >
> >    >            if (refwwid) {
> >    >                    r = coalesce_paths(vecs, NULL, refwwid,0);
> >    >                    dm_lib_release();
> >    >            }
> >    What do u think?
>
> I agree. We aren't using the code in ev_add_map, so it's presence there
> is simply confusing.
>
> -Ben
>
> >
> >    Regards,
> >    Tejaswini
> >    On Fri, Jun 26, 2015 at 4:32 AM, Benjamin Marzinski
> >    <[1]bmarzins@redhat.com> wrote:
> >
> >      On Tue, Jun 23, 2015 at 03:48:26PM +0530, Tejaswini Poluri wrote:
> >      >    Hi Ben,
> >      >
> >      >    This is regarding the add map issue I have been discussing.
> Posting
> >      the
> >      >    issue again to remind.
> >      >
> >      >    Case 1 : remove and add map.
> >      >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >    name    sysfs uuid
> >      >    dmpath0 dm-0  1IET_00010001
> >      >    root@x86-generic-64:~# multipathd -k'remove map dmpath0'
> >      >    ok
> >      >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >    root@x86-generic-64:~# multipathd -k'add map dmpath0'
> >      >    ok
> >      >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >    root@x86-generic-64:~#
> >      >    Once a map is removed, we are able to add it only using
> #multipath
> >      >    command and not using multipathd tools.
> >      >
> >      >    I have fixed the problem with two approaches. I would like you
> to
> >      review
> >      >    the same.
> >      >    Patch1 : By making 'remove map dmpath0' to remove only the map
> and
> >      not the
> >      >    device. I have added extra functions discard_map and
> dm_remove_map
> >      so as
> >      >    to not interfere with the existing code.
> >      >
> >      >    Patch 2: The approach you have suggested.By getting wwid from
> the
> >      mapname
> >      >    and doing coalesce_paths. I have just moved the following code
> in
> >      >    ev_add_map to cli_add_map.
> >
> >      This is the general idea we'd like to go with.  However, looking at
> the
> >      latest upstream code, I don't think you should pull code in from
> >      ev_add_map() to cli_add_map() like your patch does. cli_add_map()
> >      already calls ev_add_map(), and ev_add_map() is certainly able to
> add
> >      the map if it doesn't already exist.
> >
> >      You would just need to call it with
> >
> >      ev_add_map(param, NULL, vecs);
> >
> >      and ev_add_map() will happily create you a new multipath device.
> All
> >      you need to do is make sure that all the functions that ev_add_map()
> >      calls with alias can accept a NULL value there.
> >
> >      This might not be the best way to go about this, however.  It turns
> out
> >      that right now, even though ev_add_map() technically has the
> ability to
> >      create new maps, nothing currently uses it, and it really doesn't
> make
> >      sense for it to be there. Instead of just copying that code, you
> could
> >      pull the map creation code out of ev_add_map() and add it to
> >      cli_add_map(), for those situations where the requested device
> doesn't
> >      already exist.
> >
> >      But having the code in both cli_add_map() and ev_add_map() when one
> >      already calls the other doesn't seem necessary.
> >
> >      -Ben
> >
> >      >
> >      >    r = get_refwwid(dev, DEV_DEVMAP, vecs->pathvec,&refwwid);
> >      >
> >      >            if (refwwid) {
> >      >                    r = coalesce_paths(vecs, NULL, refwwid,0);
> >      >                    dm_lib_release();
> >      >            }
> >      >
> >      >    changed dev to param.
> >      >
> >      >    I have tested the same in all 3 versions -0.4.8, 0.4.9 and
> 0.5.0.
> >      It would
> >      >    be great if you can review the same so that it doesn't cause
> any
> >      extra
> >      >    side effects.
> >      >    I guess Patch2 is the way u have suggested me in the previous
> mail.
> >      Please
> >      >    review it and share your views.
> >      >    Regards,
> >      >    Tejaswini
> >      >    On Fri, Jun 12, 2015 at 2:21 AM, Benjamin Marzinski
> >      >    <[1][2]bmarzins@redhat.com> wrote:
> >      >
> >      >      On Wed, Jun 10, 2015 at 11:46:51AM +0530, Tejaswini Poluri
> wrote:
> >      >      >
> >      >      >    >    We are testing multipathd tools with all the
> possible
> >      options
> >      >      and the
> >      >      >    >    following fails.
> >      >      >    >
> >      >      >    >    Case 1 : remove and add map.
> >      >      >    >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >      >    >    name    sysfs uuid
> >      >      >    >    dmpath0 dm-0  1IET_00010001
> >      >      >    >    root@x86-generic-64:~# multipathd -k'remove map
> >      dmpath0'
> >      >      >    >    ok
> >      >      >    >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >      >    >    root@x86-generic-64:~# multipathd -k'add map
> dmpath0'
> >      >      >    >    ok
> >      >      >    >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >      >    >    root@x86-generic-64:~#
> >      >      >    >    Once a map is removed, we are able to add it only
> using
> >      >      #multipath
> >      >      >    >    command and not using multipathd tools.
> >      >      >
> >      >      >    It is working the way it was designed, but possibly it
> would
> >      make
> >      >      sense
> >      >      >    to change the design.
> >      >      >
> >      >      >    You have mentioned that it would make sense to change
> the
> >      design to
> >      >      add
> >      >      >    map. Are there plans to change the design ?
> >      >      >    I am trying to understand the code flow to change the
> >      design. Can
> >      >      you
> >      >      >    guide me if we should stop removing the device from in
> the
> >      remove
> >      >      map code
> >      >      >    flow or start adding the device and the map in the add
> map
> >      code
> >      >      flow.
> >      >      >
> >      >      >     have tried to understand the remove map code flow of
> >      multipathd in
> >      >      0.4.8
> >      >      >    code.
> >      >
> >      >      I think that we want multipath to actually remove the map
> >      (instead of
> >      >      just not monitoring it) when you call "remove map <map>". We
> just
> >      want
> >      >      "add map <map>" to try to create the map if it doesn't
> exist.  To
> >      do
> >      >      that, you would need to first firgure out what WWID is
> associated
> >      with
> >      >      <map>. Presumably, <map> could either be an alias, wwid, or
> even
> >      the
> >      >      name of a path in the map. Once you found the map, you would
> have
> >      to
> >      >      call the code to create the map.
> >      >
> >      >      Also, to answer your IRC question, no the 0.4.8 code is not
> still
> >      being
> >      >      developed upstream.  All upstream patches only go against the
> >      current
> >      >      head. There are no other upstream branches.
> >      >
> >      >      -Ben
> >      >      >
> >      >      >    ev_remove_map (char * devname, struct vectors * vecs)
> >      >      >
> >      >      >              flush_map(mpp, vecs);
> >      >      >
> >      >      >                           dm_flush_map(mpp->alias,
> >      DEFAULT_TARGET);
> >      >      >
> >      >      >                                     if
> >      (!dm_map_present(mapname))
> >      >      >
> >      >      >                                            return 0;
> >      >      >
> >      >      >           if (dm_type(mapname, type) <= 0)
> >      >      >
> >      >      >                   return 1;
> >      >      >
> >      >      >           if (dm_remove_partmaps(mapname))
> >      >      >
> >      >      >                   return 1;
> >      >      >
> >      >      >           if (dm_get_opencount(mapname)) {
> >      >      >
> >      >      >                   condlog(2, "%s: map in use", mapname);
> >      >      >
> >      >      >                   return 1;
> >      >      >
> >      >      >           }
> >      >      >
> >      >      >           r = dm_simplecmd(DM_DEVICE_REMOVE, mapname);
> >      >      >
> >      >      >           if (r) {
> >      >      >
> >      >      >                   condlog(4, "multipath map %s removed",
> >      mapname);
> >      >      >
> >      >      >                                                  return 0;
> >      >      >
> >      >      >                                           }
> >      >      >
> >      >      >
> >      >      >
> >      >      >                            orphan_paths(vecs->pathvec,
> mpp);
> >      >      >
> >      >      >                            remove_map(mpp, vecs,
> >      stop_waiter_thread,
> >      >      1);
> >      >      >
> >      >      >    Is removing this below line, the right step to stop
> removing
> >      the
> >      >      device ?
> >      >      >    r = dm_simplecmd(DM_DEVICE_REMOVE, mapname);
> >      >      >
> >      >      >    Regards,
> >      >      >
> >      >      >    Tejaswini
> >      >      >
> >      >      >    On Mon, Jun 8, 2015 at 11:15 AM, Tejaswini Poluri
> >      >      >    <[1][2][3]tejaswinipoluri3@gmail.com> wrote:
> >      >      >
> >      >      >      Thanks a lot Ben for the quick and detailed reply. I
> have
> >      been
> >      >      >      struggling to understand and conclude the issues with
> >      multipath
> >      >      as I am
> >      >      >      the only one working from my team. Your inputs help
> me a
> >      lot.
> >      >      Thanks
> >      >      >      again.
> >      >      >      Regards,
> >      >      >      Tejaswini
> >      >      >      On Sat, Jun 6, 2015 at 3:36 AM, Benjamin Marzinski
> >      >      >      <[2][3][4]bmarzins@redhat.com> wrote:
> >      >      >
> >      >      >        On Fri, Jun 05, 2015 at 02:31:20PM +0530, Tejaswini
> >      Poluri
> >      >      wrote:
> >      >      >        >    Hii Ben,
> >      >      >        >
> >      >      >        >    We are testing multipathd tools with all the
> >      possible
> >      >      options and
> >      >      >        the
> >      >      >        >    following fails.
> >      >      >        >
> >      >      >        >    Case 1 : remove and add map.
> >      >      >        >    root@x86-generic-64:~# multipathd -k'show
> maps'
> >      >      >        >    name    sysfs uuid
> >      >      >        >    dmpath0 dm-0  1IET_00010001
> >      >      >        >    root@x86-generic-64:~# multipathd -k'remove
> map
> >      dmpath0'
> >      >      >        >    ok
> >      >      >        >    root@x86-generic-64:~# multipathd -k'show
> maps'
> >      >      >        >    root@x86-generic-64:~# multipathd -k'add map
> >      dmpath0'
> >      >      >        >    ok
> >      >      >        >    root@x86-generic-64:~# multipathd -k'show
> maps'
> >      >      >        >    root@x86-generic-64:~#
> >      >      >        >    Once a map is removed, we are able to add it
> only
> >      using
> >      >      >        #multipath
> >      >      >        >    command and not using multipathd tools.
> >      >      >
> >      >      >        It is working the way it was designed, but possibly
> it
> >      would
> >      >      make
> >      >      >        sense
> >      >      >        to change the design.  The "remove map" command, not
> >      only stops
> >      >      >        multipathd from monitoring the multipath device,
> but it
> >      removes
> >      >      it
> >      >      >        from
> >      >      >        the system as well.  The "add map" command makes
> >      multipath
> >      >      monitor an
> >      >      >        already existing multipath device that in wasn't
> >      previously
> >      >      >        monitoring.
> >      >      >        These commands do this for historical reasons.
> >      multipathd
> >      >      wasn't
> >      >      >        originally in charge of creating multipath devices,
> >      multipath
> >      >      was.
> >      >      >        Once
> >      >      >        it had created the device, it ran
> >      >      >
> >      >      >        multipathd -k"add map <MAP>"
> >      >      >
> >      >      >        to make multipathd start monitoring it.  However
> things
> >      haven't
> >      >      worked
> >      >      >        this way since RHEL4, so possibly "add map" should
> >      actually
> >      >      create the
> >      >      >        device if it doesn't currently exist.
> >      >      >        >    Case 2 : Active paths  test case
> >      >      >        >    # while true ; do sleep 3 ; multipathd
> -k'remove
> >      path sdb'
> >      >      ;
> >      >      >        multipathd
> >      >      >        >    -k'add path sdb' ; multipathd -k'show maps
> status'
> >      ; done
> >      >      >        >    ok
> >      >      >        >    ok
> >      >      >        >    name failback queueing paths dm-st
> >      >      >        >    dmpath0 - - 1 active // It should be 2.
> >      >      >
> >      >      >        This is simply a timing issue.  What you are seeing
> it
> >      the
> >      >      number of
> >      >      >        active paths.  These are paths that the kernel can
> use.
> >      The
> >      >      "add path"
> >      >      >        command doesn't update the kernel state.  This
> happens
> >      later in
> >      >      >        response
> >      >      >        to the kernel reloading the device table. So, in a
> >      second or
> >      >      two, this
> >      >      >        will say 2, as expected.
> >      >      >
> >      >      >        >    We would like to know if the test cases are
> valid
> >      and if
> >      >      these
> >      >      >        are bugs or
> >      >      >        >    any design issues.
> >      >      >        >
> >      >      >        >    Case 3 : Fail path and reinstate path
> >      >      >        >    root@x86-generic-64:~# multipathd -k"fail path
> >      sdc";
> >      >      multipathd
> >      >      >        >    -k'reinstate path sdc'; multipathd -k"show
> paths";
> >      >      >        >    >    [ 3962.708523] device-mapper: multipath:
> >      Failing path
> >      >      8:32.
> >      >      >        >    >    ok
> >      >      >        >    >    ok
> >      >      >        >    >    hcil    dev dev_t pri dm_st   chk_st
> >      next_check
> >      >      >        >    >    4:0:0:1 sdc 8:32  1   [active][faulty]
> >      ..........
> >      >      1/20
> >      >      >        <==CHECK
> >      >      >        >    >    5:0:0:1 sdd 8:48  1   [active][ready]
> >      XX........
> >      >      4/20
> >      >      >        >    sdc path becomes [active][ready] only after the
> >      polling
> >      >      interval
> >      >      >        but not
> >      >      >        >    immediately after the reinstate path command.
> >      >      >        >    You have answered that this is a design issue.
> But
> >      we have
> >      >      heard
> >      >      >        from our
> >      >      >        >    test team that the same test case works in
> RHEL6.
> >      Did you
> >      >      observe
> >      >      >        it?
> >      >      >        >    I am also finding that the test cases fail
> because
> >      we are
> >      >      trying
> >      >      >        to do
> >      >      >        >    multiple commands at one shot.  Please share
> your
> >      thoughts
> >      >      so
> >      >      >        that it
> >      >      >        >    could help me in debugging the issues further.
> >      >      >        >
> >      >      >
> >      >      >        It's totally possible that the checker state is
> >      immediately
> >      >      updated in
> >      >      >        RHEL6.  Like I said before, what it currently does,
> >      although
> >      >      correct,
> >      >      >        is confusing, and perhaps we need a different
> checker
> >      state for
> >      >      paths
> >      >      >        where the "fail path" command has been used.
> >      >      >
> >      >      >        -Ben
> >      >      >        >    Regards,
> >      >      >        >    Tejaswini
> >      >      >        >    On Tue, May 19, 2015 at 5:37 PM, Tejaswini
> Poluri
> >      >      >        >    <[1][3][4][5]tejaswinipoluri3@gmail.com>
> wrote:
> >      >      >        >
> >      >      >        >      Thanks a lot Ben. I will look into it more.
> >      >      >        >      On Mon, May 18, 2015 at 9:57 PM, Benjamin
> >      Marzinski
> >      >      >        >      <[2][4][5][6]bmarzins@redhat.com> wrote:
> >      >      >        >
> >      >      >        >        On Mon, May 18, 2015 at 02:09:27PM +0530,
> >      Tejaswini
> >      >      Poluri
> >      >      >        wrote:
> >      >      >        >        >    Hii,
> >      >      >        >        >    We are trying to test multipath setup
> in
> >      our
> >      >      target and
> >      >      >        tried the
> >      >      >        >        various
> >      >      >        >        >    commands of multipathd demaon and we
> find
> >      the
> >      >      following
> >      >      >        error:
> >      >      >        >        >    root@x86-generic-64:~# multipathd
> -k"fail
> >      path
> >      >      sdc";
> >      >      >        multipathd
> >      >      >        >        >    -k'reinstate path
> >      >      >        >        >    sdc'; multipathd -k"show paths";
> >      >      >        >        >    [ 3962.708523] device-mapper:
> multipath:
> >      Failing
> >      >      >        path 8:32.
> >      >      >        >        >    ok
> >      >      >        >        >    ok
> >      >      >        >        >    hcil    dev dev_t pri dm_st   chk_st
> >       next_check
> >      >      >        >        >    4:0:0:1 sdc 8:32  1   [active][faulty]
> >      ..........
> >      >      1/20
> >      >      >          <<<===
> >      >      >        >        CHECK
> >      >      >        >        >    5:0:0:1 sdd 8:48  1   [active][ready]
> >      XX........
> >      >      4/20
> >      >      >        >        >    sdc path becomes [active][ready] only
> >      after the
> >      >      polling
> >      >      >        interval
> >      >      >        >        but not
> >      >      >        >        >    immediately after the reinstate path
> >      command.
> >      >      >        >        >    I am observing this in latest
> multipath
> >      tools in
> >      >      ubuntu
> >      >      >        machine
> >      >      >        >        as well.
> >      >      >        >        >    Please let me know if its a known
> issue or
> >      if I
> >      >      am doing
> >      >      >        >        something wrong.
> >      >      >        >        >    Regards.
> >      >      >        >        >    Tejaswini
> >      >      >        >
> >      >      >        >        the reinstate command is supposed to
> reinstate
> >      the
> >      >      device
> >      >      >        with the
> >      >      >        >        kernel, and it does that. The checker state
> >      doesn't
> >      >      change
> >      >      >        until the
> >      >      >        >        next time that the path is checked.  I
> agree
> >      that it's
> >      >      odd
> >      >      >        that the
> >      >      >        >        check state switches to faulty as soon as
> you
> >      fail the
> >      >      path,
> >      >      >        but it
> >      >      >        >        doesn't switch back until the next check
> after
> >      you
> >      >      reinistate
> >      >      >        it.
> >      >      >        >
> >      >      >        >        The issue is that multipathd needs to
> override
> >      the
> >      >      checker
> >      >      >        output,
> >      >      >        >        so that a failed path won't be immeditately
> >      >      reinstated.  Once
> >      >      >        the
> >      >      >        >        path comes back, multipathd wants to
> record the
> >      switch
> >      >      in the
> >      >      >        checker
> >      >      >        >        thread, so that it can refresh path
> information
> >      what
> >      >      wasn't
> >      >      >        >        automatically done when the path was
> >      reinstated.
> >      >      However, it
> >      >      >        may make
> >      >      >        >        more sense to have a different checker
> state
> >      for when
> >      >      the
> >      >      >        device is
> >      >      >        >        in the failed state, so that it's obvious
> that
> >      the
> >      >      checker
> >      >      >        state is
> >      >      >        >        being overruled.
> >      >      >        >
> >      >      >        >        -Ben
> >      >      >        >
> >      >      >        >        > --
> >      >      >        >        > dm-devel mailing list
> >      >      >        >        > [3][5][6][7]dm-devel@redhat.com
> >      >      >        >        >
> >      >      [4][6][7][8]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >        >
> >      >      >        >        --
> >      >      >        >        dm-devel mailing list
> >      >      >        >        [5][7][8][9]dm-devel@redhat.com
> >      >      >        >
> >      >      [6][8][9][10]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >        >
> >      >      >        > References
> >      >      >        >
> >      >      >        >    Visible links
> >      >      >        >    1. mailto:[9][10][11]
> tejaswinipoluri3@gmail.com
> >      >      >        >    2. mailto:[10][11][12]bmarzins@redhat.com
> >      >      >        >    3. mailto:[11][12][13]dm-devel@redhat.com
> >      >      >        >    4.
> >      >      [12][13][14]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >        >    5. mailto:[13][14][15]dm-devel@redhat.com
> >      >      >        >    6.
> >      >      [14][15][16]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >
> >      >      > References
> >      >      >
> >      >      >    Visible links
> >      >      >    1. mailto:[16][17]tejaswinipoluri3@gmail.com
> >      >      >    2. mailto:[17][18]bmarzins@redhat.com
> >      >      >    3. mailto:[18][19]tejaswinipoluri3@gmail.com
> >      >      >    4. mailto:[19][20]bmarzins@redhat.com
> >      >      >    5. mailto:[20][21]dm-devel@redhat.com
> >      >      >    6. [21][22]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >    7. mailto:[22][23]dm-devel@redhat.com
> >      >      >    8. [23][24]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >    9. mailto:[24][25]tejaswinipoluri3@gmail.com
> >      >      >   10. mailto:[25][26]bmarzins@redhat.com
> >      >      >   11. mailto:[26][27]dm-devel@redhat.com
> >      >      >   12. [27][28]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   13. mailto:[28][29]dm-devel@redhat.com
> >      >      >   14. [29][30]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >
> >      > References
> >      >
> >      >    Visible links
> >      >    1. mailto:[31]bmarzins@redhat.com
> >      >    2. mailto:[32]tejaswinipoluri3@gmail.com
> >      >    3. mailto:[33]bmarzins@redhat.com
> >      >    4. mailto:[34]tejaswinipoluri3@gmail.com
> >      >    5. mailto:[35]bmarzins@redhat.com
> >      >    6. mailto:[36]dm-devel@redhat.com
> >      >    7. [37]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >    8. mailto:[38]dm-devel@redhat.com
> >      >    9. [39]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   10. mailto:[40]tejaswinipoluri3@gmail.com
> >      >   11. mailto:[41]bmarzins@redhat.com
> >      >   12. mailto:[42]dm-devel@redhat.com
> >      >   13. [43]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   14. mailto:[44]dm-devel@redhat.com
> >      >   15. [45]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   16. mailto:[46]tejaswinipoluri3@gmail.com
> >      >   17. mailto:[47]bmarzins@redhat.com
> >      >   18. mailto:[48]tejaswinipoluri3@gmail.com
> >      >   19. mailto:[49]bmarzins@redhat.com
> >      >   20. mailto:[50]dm-devel@redhat.com
> >      >   21. [51]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   22. mailto:[52]dm-devel@redhat.com
> >      >   23. [53]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   24. mailto:[54]tejaswinipoluri3@gmail.com
> >      >   25. mailto:[55]bmarzins@redhat.com
> >      >   26. mailto:[56]dm-devel@redhat.com
> >      >   27. [57]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   28. mailto:[58]dm-devel@redhat.com
> >      >   29. [59]https://www.redhat.com/mailman/listinfo/dm-devel
> >
> > References
> >
> >    Visible links
> >    1. mailto:bmarzins@redhat.com
> >    2. mailto:bmarzins@redhat.com
> >    3. mailto:tejaswinipoluri3@gmail.com
> >    4. mailto:bmarzins@redhat.com
> >    5. mailto:tejaswinipoluri3@gmail.com
> >    6. mailto:bmarzins@redhat.com
> >    7. mailto:dm-devel@redhat.com
> >    8. https://www.redhat.com/mailman/listinfo/dm-devel
> >    9. mailto:dm-devel@redhat.com
> >   10. https://www.redhat.com/mailman/listinfo/dm-devel
> >   11. mailto:tejaswinipoluri3@gmail.com
> >   12. mailto:bmarzins@redhat.com
> >   13. mailto:dm-devel@redhat.com
> >   14. https://www.redhat.com/mailman/listinfo/dm-devel
> >   15. mailto:dm-devel@redhat.com
> >   16. https://www.redhat.com/mailman/listinfo/dm-devel
> >   17. mailto:tejaswinipoluri3@gmail.com
> >   18. mailto:bmarzins@redhat.com
> >   19. mailto:tejaswinipoluri3@gmail.com
> >   20. mailto:bmarzins@redhat.com
> >   21. mailto:dm-devel@redhat.com
> >   22. https://www.redhat.com/mailman/listinfo/dm-devel
> >   23. mailto:dm-devel@redhat.com
> >   24. https://www.redhat.com/mailman/listinfo/dm-devel
> >   25. mailto:tejaswinipoluri3@gmail.com
> >   26. mailto:bmarzins@redhat.com
> >   27. mailto:dm-devel@redhat.com
> >   28. https://www.redhat.com/mailman/listinfo/dm-devel
> >   29. mailto:dm-devel@redhat.com
> >   30. https://www.redhat.com/mailman/listinfo/dm-devel
> >   31. mailto:bmarzins@redhat.com
> >   32. mailto:tejaswinipoluri3@gmail.com
> >   33. mailto:bmarzins@redhat.com
> >   34. mailto:tejaswinipoluri3@gmail.com
> >   35. mailto:bmarzins@redhat.com
> >   36. mailto:dm-devel@redhat.com
> >   37. https://www.redhat.com/mailman/listinfo/dm-devel
> >   38. mailto:dm-devel@redhat.com
> >   39. https://www.redhat.com/mailman/listinfo/dm-devel
> >   40. mailto:tejaswinipoluri3@gmail.com
> >   41. mailto:bmarzins@redhat.com
> >   42. mailto:dm-devel@redhat.com
> >   43. https://www.redhat.com/mailman/listinfo/dm-devel
> >   44. mailto:dm-devel@redhat.com
> >   45. https://www.redhat.com/mailman/listinfo/dm-devel
> >   46. mailto:tejaswinipoluri3@gmail.com
> >   47. mailto:bmarzins@redhat.com
> >   48. mailto:tejaswinipoluri3@gmail.com
> >   49. mailto:bmarzins@redhat.com
> >   50. mailto:dm-devel@redhat.com
> >   51. https://www.redhat.com/mailman/listinfo/dm-devel
> >   52. mailto:dm-devel@redhat.com
> >   53. https://www.redhat.com/mailman/listinfo/dm-devel
> >   54. mailto:tejaswinipoluri3@gmail.com
> >   55. mailto:bmarzins@redhat.com
> >   56. mailto:dm-devel@redhat.com
> >   57. https://www.redhat.com/mailman/listinfo/dm-devel
> >   58. mailto:dm-devel@redhat.com
> >   59. https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a11c2edbe45aa5e0519b5d0c0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+VGhhbmtzIEJlbi4gU28gc2hvdWxkIEkgcHVzaCB0aGUgY29kZSB0byB0
aGUgdXBzdHJlYW0gYW5kIGdldCBhbiBhcHByb3ZhbD88ZGl2Pjxicj48L2Rpdj48ZGl2Pjxicj48
L2Rpdj48ZGl2PlJlZ2FyZHMsPC9kaXY+PGRpdj5UZWphc3dpbmk8L2Rpdj48L2Rpdj48ZGl2IGNs
YXNzPSJnbWFpbF9leHRyYSI+PGJyPjxkaXYgY2xhc3M9ImdtYWlsX3F1b3RlIj5PbiBUdWUsIEp1
biAzMCwgMjAxNSBhdCAxMjo1MCBBTSwgQmVuamFtaW4gTWFyemluc2tpIDxzcGFuIGRpcj0ibHRy
Ij4mbHQ7PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iIHRhcmdldD0iX2JsYW5r
Ij5ibWFyemluc0ByZWRoYXQuY29tPC9hPiZndDs8L3NwYW4+IHdyb3RlOjxicj48YmxvY2txdW90
ZSBjbGFzcz0iZ21haWxfcXVvdGUiIHN0eWxlPSJtYXJnaW46MCAwIDAgLjhleDtib3JkZXItbGVm
dDoxcHggI2NjYyBzb2xpZDtwYWRkaW5nLWxlZnQ6MWV4Ij48c3BhbiBjbGFzcz0iIj5PbiBGcmks
IEp1biAyNiwgMjAxNSBhdCAxMjoyMTo0OFBNICswNTMwLCBUZWphc3dpbmkgUG9sdXJpIHdyb3Rl
Ojxicj4NCiZndDvCoCDCoCBZZXMgSSBhZ3JlZSB0aGF0IGhhdmluZyB0aGUgc2FtZSBjb2RlIGlu
IGJvdGggY2xpX2FkZF9tYXAoKSBhbmQgZXZfYWRkX21hcDxicj4NCiZndDvCoCDCoCBpcyBub3Qg
bmVjZXNzYXJ5LiBIZW5jZSBJIHdvdWxkIHN1Z2dlc3QgcmVtb3ZpbmcgZ2V0X3JlZnd3aWQoKSBj
b2RlIGZyb208YnI+DQomZ3Q7wqAgwqAgZXZfYWRkX21hcCBhcyBpdCBpcyBub3QgYmVpbmcgdXNl
ZCBieSBhbnlvbmUuPGJyPg0KJmd0Ozxicj4NCiZndDvCoCDCoCBldl9hZGRfbWFwKHBhcmFtLCBO
VUxMLCB2ZWNzKSB3b3VsZCBjcmVhdGUgdGhlIG11bHRpcGF0aCBkZXZpY2UgYnkgdXNpbmc8YnI+
DQomZ3Q7wqAgwqAgdGhlIGdldF9yZWZ3d2lkKCkgY29kZSBhbmQgYnV0IGFsbCB0aGUgZnVuY3Rp
b25zIGFib3ZlIGl0IGxpa2U8YnI+DQomZ3Q7wqAgwqAgKGRtX2dldF9taW5vciwgZG1fZ2V0X21h
am9yIGFuZCBkbV9tYXBuYW1lKSB3b3VsZCBmYWlsIGFuZCBpdCB3b3VsZG4mIzM5O3Q8YnI+DQom
Z3Q7wqAgwqAgZW50ZXIgYW55IG9mIHRoZSBvdGhlciBjb2RlIGluIGV2X2FkZF9tYXAgbGlrZTxi
cj4NCiZndDvCoCDCoCAxLmRtX21hcF9wcmVzZW50LDxicj4NCiZndDvCoCDCoCAyLmFkZF9tYXBf
d2l0aG91dF9wYXRoPGJyPg0KJmd0O8KgIMKgIDMuIHN5bmNfbWFwX3N0YXRlPGJyPg0KJmd0O8Kg
IMKgIHdoaWNoIGFyZSByZXNwb25zaWJsZSBmb3IgcmVnaXN0ZXJpbmcgdGhlIG1hcCBhbmQgZGlz
cGxheWluZyBpdC48YnI+DQomZ3Q7PGJyPg0KJmd0O8KgIMKgIFNvLCBJIHRoaW5rIG1vdmluZyB0
aGUgYmVsb3cgY29kZSBmcm9tIGV2X2FkZF9tYXAgdG8gY2xpX2FkZF9tYXAgc2hvdWxkIGJlPGJy
Pg0KJmd0O8KgIMKgIGEgZ29vZCBpZGVhIHJpZ2h0Ljxicj4NCiZndDs8YnI+DQomZ3Q7wqAgwqAg
ciA9IGdldF9yZWZ3d2lkKGRldiwgREVWX0RFVk1BUCwgdmVjcy0mZ3Q7cGF0aHZlYywmYW1wO3Jl
Znd3aWQpOzxicj4NCiZndDvCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgICZndDvCoCDCoCDCoMKg
wqDCoMKgwqDCoCBpZiAocmVmd3dpZCkgezxicj4NCiZndDvCoCDCoCAmZ3Q7wqAgwqAgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHIgPSBjb2FsZXNjZV9wYXRocyh2ZWNzLCBOVUxMLCBy
ZWZ3d2lkLDApOzxicj4NCiZndDvCoCDCoCAmZ3Q7wqAgwqAgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGRtX2xpYl9yZWxlYXNlKCk7PGJyPg0KJmd0O8KgIMKgICZndDvCoCDCoCDCoMKg
wqDCoMKgwqDCoCB9PGJyPg0KJmd0O8KgIMKgIFdoYXQgZG8gdSB0aGluaz88YnI+DQo8YnI+DQo8
L3NwYW4+SSBhZ3JlZS4gV2UgYXJlbiYjMzk7dCB1c2luZyB0aGUgY29kZSBpbiBldl9hZGRfbWFw
LCBzbyBpdCYjMzk7cyBwcmVzZW5jZSB0aGVyZTxicj4NCmlzIHNpbXBseSBjb25mdXNpbmcuPGJy
Pg0KPGJyPg0KLUJlbjxicj4NCjxzcGFuIGNsYXNzPSIiPjxicj4NCiZndDs8YnI+DQomZ3Q7wqAg
wqAgUmVnYXJkcyw8YnI+DQomZ3Q7wqAgwqAgVGVqYXN3aW5pPGJyPg0KJmd0O8KgIMKgIE9uIEZy
aSwgSnVuIDI2LCAyMDE1IGF0IDQ6MzIgQU0sIEJlbmphbWluIE1hcnppbnNraTxicj4NCjwvc3Bh
bj48ZGl2PjxkaXYgY2xhc3M9Img1Ij4mZ3Q7wqAgwqAgJmx0O1sxXTxhIGhyZWY9Im1haWx0bzpi
bWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPiZndDsgd3JvdGU6PGJy
Pg0KJmd0Ozxicj4NCiZndDvCoCDCoCDCoCBPbiBUdWUsIEp1biAyMywgMjAxNSBhdCAwMzo0ODoy
NlBNICswNTMwLCBUZWphc3dpbmkgUG9sdXJpIHdyb3RlOjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgSGkgQmVuLDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCBUaGlzIGlzIHJlZ2FyZGluZyB0aGUgYWRkIG1hcCBpc3N1ZSBJIGhhdmUgYmVlbiBk
aXNjdXNzaW5nLiBQb3N0aW5nPGJyPg0KJmd0O8KgIMKgIMKgIHRoZTxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgaXNzdWUgYWdhaW4gdG8gcmVtaW5kLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCBDYXNlIDEgOiByZW1vdmUgYW5kIGFkZCBtYXAu
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCByb290QHg4Ni1nZW5lcmljLTY0On4jIG11bHRp
cGF0aGQgLWsmIzM5O3Nob3cgbWFwcyYjMzk7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCBu
YW1lwqDCoMKgIHN5c2ZzIHV1aWQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIGRtcGF0aDAg
ZG0tMMKgIDFJRVRfMDAwMTAwMDE8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIHJvb3RAeDg2
LWdlbmVyaWMtNjQ6fiMgbXVsdGlwYXRoZCAtayYjMzk7cmVtb3ZlIG1hcCBkbXBhdGgwJiMzOTs8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIG9rPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCByb290QHg4Ni1nZW5lcmljLTY0On4jIG11bHRpcGF0aGQgLWsmIzM5O3Nob3cgbWFwcyYjMzk7
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCByb290QHg4Ni1nZW5lcmljLTY0On4jIG11bHRp
cGF0aGQgLWsmIzM5O2FkZCBtYXAgZG1wYXRoMCYjMzk7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCBvazxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgcm9vdEB4ODYtZ2VuZXJpYy02NDp+
IyBtdWx0aXBhdGhkIC1rJiMzOTtzaG93IG1hcHMmIzM5Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgcm9vdEB4ODYtZ2VuZXJpYy02NDp+Izxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
T25jZSBhIG1hcCBpcyByZW1vdmVkLCB3ZSBhcmUgYWJsZSB0byBhZGQgaXQgb25seSB1c2luZyAj
bXVsdGlwYXRowqA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIGNvbW1hbmQgYW5kIG5vdCB1
c2luZyBtdWx0aXBhdGhkIHRvb2xzLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCBJIGhhdmUgZml4ZWQgdGhlIHByb2JsZW0gd2l0aCB0d28gYXBwcm9h
Y2hlcy4gSSB3b3VsZCBsaWtlIHlvdSB0bzxicj4NCiZndDvCoCDCoCDCoCByZXZpZXc8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIHRoZSBzYW1lLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgUGF0Y2gxIDogQnkgbWFraW5nICYjMzk7cmVtb3ZlIG1hcCBkbXBhdGgwJiMzOTsgdG8gcmVt
b3ZlIG9ubHkgdGhlIG1hcCBhbmQ8YnI+DQomZ3Q7wqAgwqAgwqAgbm90IHRoZTxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgZGV2aWNlLiBJIGhhdmUgYWRkZWQgZXh0cmEgZnVuY3Rpb25zIGRp
c2NhcmRfbWFwIGFuZCBkbV9yZW1vdmVfbWFwPGJyPg0KJmd0O8KgIMKgIMKgIHNvIGFzPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCB0byBub3QgaW50ZXJmZXJlIHdpdGggdGhlIGV4aXN0aW5n
IGNvZGUuPGJyPg0KJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IFBhdGNoIDI6IFRoZSBhcHByb2FjaCB5b3UgaGF2ZSBzdWdnZXN0ZWQuQnkgZ2V0dGluZyB3d2lk
IGZyb20gdGhlPGJyPg0KJmd0O8KgIMKgIMKgIG1hcG5hbWU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIGFuZCBkb2luZyBjb2FsZXNjZV9wYXRocy4gSSBoYXZlIGp1c3QgbW92ZWQgdGhlIGZv
bGxvd2luZyBjb2RlIGluPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCBldl9hZGRfbWFwIHRv
IGNsaV9hZGRfbWFwLjxicj4NCiZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgVGhpcyBpcyB0aGUgZ2Vu
ZXJhbCBpZGVhIHdlJiMzOTtkIGxpa2UgdG8gZ28gd2l0aC7CoCBIb3dldmVyLCBsb29raW5nIGF0
IHRoZTxicj4NCiZndDvCoCDCoCDCoCBsYXRlc3QgdXBzdHJlYW0gY29kZSwgSSBkb24mIzM5O3Qg
dGhpbmsgeW91IHNob3VsZCBwdWxsIGNvZGUgaW4gZnJvbTxicj4NCiZndDvCoCDCoCDCoCBldl9h
ZGRfbWFwKCkgdG8gY2xpX2FkZF9tYXAoKSBsaWtlIHlvdXIgcGF0Y2ggZG9lcy4gY2xpX2FkZF9t
YXAoKTxicj4NCiZndDvCoCDCoCDCoCBhbHJlYWR5IGNhbGxzIGV2X2FkZF9tYXAoKSwgYW5kIGV2
X2FkZF9tYXAoKSBpcyBjZXJ0YWlubHkgYWJsZSB0byBhZGQ8YnI+DQomZ3Q7wqAgwqAgwqAgdGhl
IG1hcCBpZiBpdCBkb2VzbiYjMzk7dCBhbHJlYWR5IGV4aXN0Ljxicj4NCiZndDs8YnI+DQomZ3Q7
wqAgwqAgwqAgWW91IHdvdWxkIGp1c3QgbmVlZCB0byBjYWxsIGl0IHdpdGg8YnI+DQomZ3Q7PGJy
Pg0KJmd0O8KgIMKgIMKgIGV2X2FkZF9tYXAocGFyYW0sIE5VTEwsIHZlY3MpOzxicj4NCiZndDs8
YnI+DQomZ3Q7wqAgwqAgwqAgYW5kIGV2X2FkZF9tYXAoKSB3aWxsIGhhcHBpbHkgY3JlYXRlIHlv
dSBhIG5ldyBtdWx0aXBhdGggZGV2aWNlLsKgIEFsbDxicj4NCiZndDvCoCDCoCDCoCB5b3UgbmVl
ZCB0byBkbyBpcyBtYWtlIHN1cmUgdGhhdCBhbGwgdGhlIGZ1bmN0aW9ucyB0aGF0IGV2X2FkZF9t
YXAoKTxicj4NCiZndDvCoCDCoCDCoCBjYWxscyB3aXRoIGFsaWFzIGNhbiBhY2NlcHQgYSBOVUxM
IHZhbHVlIHRoZXJlLjxicj4NCiZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgVGhpcyBtaWdodCBub3Qg
YmUgdGhlIGJlc3Qgd2F5IHRvIGdvIGFib3V0IHRoaXMsIGhvd2V2ZXIuwqAgSXQgdHVybnMgb3V0
PGJyPg0KJmd0O8KgIMKgIMKgIHRoYXQgcmlnaHQgbm93LCBldmVuIHRob3VnaCBldl9hZGRfbWFw
KCkgdGVjaG5pY2FsbHkgaGFzIHRoZSBhYmlsaXR5IHRvPGJyPg0KJmd0O8KgIMKgIMKgIGNyZWF0
ZSBuZXcgbWFwcywgbm90aGluZyBjdXJyZW50bHkgdXNlcyBpdCwgYW5kIGl0IHJlYWxseSBkb2Vz
biYjMzk7dCBtYWtlPGJyPg0KJmd0O8KgIMKgIMKgIHNlbnNlIGZvciBpdCB0byBiZSB0aGVyZS4g
SW5zdGVhZCBvZiBqdXN0IGNvcHlpbmcgdGhhdCBjb2RlLCB5b3UgY291bGQ8YnI+DQomZ3Q7wqAg
wqAgwqAgcHVsbCB0aGUgbWFwIGNyZWF0aW9uIGNvZGUgb3V0IG9mIGV2X2FkZF9tYXAoKSBhbmQg
YWRkIGl0IHRvPGJyPg0KJmd0O8KgIMKgIMKgIGNsaV9hZGRfbWFwKCksIGZvciB0aG9zZSBzaXR1
YXRpb25zIHdoZXJlIHRoZSByZXF1ZXN0ZWQgZGV2aWNlIGRvZXNuJiMzOTt0PGJyPg0KJmd0O8Kg
IMKgIMKgIGFscmVhZHkgZXhpc3QuPGJyPg0KJmd0Ozxicj4NCiZndDvCoCDCoCDCoCBCdXQgaGF2
aW5nIHRoZSBjb2RlIGluIGJvdGggY2xpX2FkZF9tYXAoKSBhbmQgZXZfYWRkX21hcCgpIHdoZW4g
b25lPGJyPg0KJmd0O8KgIMKgIMKgIGFscmVhZHkgY2FsbHMgdGhlIG90aGVyIGRvZXNuJiMzOTt0
IHNlZW0gbmVjZXNzYXJ5Ljxicj4NCiZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgLUJlbjxicj4NCiZn
dDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgciA9
IGdldF9yZWZ3d2lkKGRldiwgREVWX0RFVk1BUCwgdmVjcy0mZ3Q7cGF0aHZlYywmYW1wO3JlZnd3
aWQpOzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oMKgwqDCoMKgwqDCoCBpZiAocmVmd3dpZCkgezxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHIgPSBjb2FsZXNjZV9wYXRocyh2ZWNzLCBO
VUxMLCByZWZ3d2lkLDApOzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGRtX2xpYl9yZWxlYXNlKCk7PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoMKgwqDCoMKgwqDCoCB9PGJyPg0KJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIGNoYW5nZWQgZGV2IHRvIHBhcmFtLjxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCBJIGhhdmUgdGVzdGVkIHRoZSBzYW1l
IGluIGFsbCAzIHZlcnNpb25zIC0wLjQuOCwgMC40LjkgYW5kIDAuNS4wLjxicj4NCiZndDvCoCDC
oCDCoCBJdCB3b3VsZDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgYmUgZ3JlYXQgaWYgeW91
IGNhbiByZXZpZXcgdGhlIHNhbWUgc28gdGhhdCBpdCBkb2VzbiYjMzk7dCBjYXVzZSBhbnk8YnI+
DQomZ3Q7wqAgwqAgwqAgZXh0cmE8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIHNpZGUgZWZm
ZWN0cy48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIEkgZ3Vlc3MgUGF0Y2gyIGlzIHRoZSB3
YXkgdSBoYXZlIHN1Z2dlc3RlZCBtZSBpbiB0aGUgcHJldmlvdXMgbWFpbC48YnI+DQomZ3Q7wqAg
wqAgwqAgUGxlYXNlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCByZXZpZXcgaXQgYW5kIHNo
YXJlIHlvdXIgdmlld3MuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCBSZWdhcmRzLDxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgVGVqYXN3aW5pPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCBPbiBGcmksIEp1biAxMiwgMjAxNSBhdCAyOjIxIEFNLCBCZW5qYW1pbiBNYXJ6aW5za2k8
YnI+DQo8L2Rpdj48L2Rpdj48ZGl2PjxkaXYgY2xhc3M9Img1Ij4mZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgICZsdDtbMV1bMl08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnpp
bnNAcmVkaGF0LmNvbTwvYT4mZ3Q7IHdyb3RlOjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBPbiBXZWQsIEp1biAxMCwgMjAxNSBhdCAxMTo0Njo1
MUFNICswNTMwLCBUZWphc3dpbmkgUG9sdXJpIHdyb3RlOjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgJmd0O8KgIMKgIFdlIGFyZSB0ZXN0aW5nIG11bHRpcGF0aGQgdG9vbHMgd2l0aCBh
bGwgdGhlIHBvc3NpYmxlPGJyPg0KJmd0O8KgIMKgIMKgIG9wdGlvbnM8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIGFuZCB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCAmZ3Q7wqAgwqAgZm9sbG93aW5nIGZhaWxzLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCAmZ3Q7wqAgwqAgQ2FzZSAxIDogcmVtb3ZlIGFuZCBhZGQgbWFwLjxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgICZndDvCoCDCoCByb290QHg4Ni1nZW5lcmlj
LTY0On4jIG11bHRpcGF0aGQgLWsmIzM5O3Nob3cgbWFwcyYjMzk7PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgJmd0O8KgIMKgIG5hbWXCoMKgwqAgc3lzZnMgdXVpZDxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgICZndDvCoCDCoCBkbXBhdGgw
IGRtLTDCoCAxSUVUXzAwMDEwMDAxPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgJmd0O8KgIMKgIHJvb3RAeDg2LWdlbmVyaWMtNjQ6fiMgbXVsdGlwYXRoZCAtayYjMzk7
cmVtb3ZlIG1hcDxicj4NCiZndDvCoCDCoCDCoCBkbXBhdGgwJiMzOTs8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCAmZ3Q7wqAgwqAgb2s8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCAmZ3Q7wqAgwqAgcm9vdEB4ODYtZ2VuZXJpYy02NDp+IyBt
dWx0aXBhdGhkIC1rJiMzOTtzaG93IG1hcHMmIzM5Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgICZndDvCoCDCoCByb290QHg4Ni1nZW5lcmljLTY0On4jIG11bHRpcGF0
aGQgLWsmIzM5O2FkZCBtYXAgZG1wYXRoMCYjMzk7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgJmd0O8KgIMKgIG9rPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgJmd0O8KgIMKgIHJvb3RAeDg2LWdlbmVyaWMtNjQ6fiMgbXVsdGlwYXRoZCAt
ayYjMzk7c2hvdyBtYXBzJiMzOTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCAmZ3Q7wqAgwqAgcm9vdEB4ODYtZ2VuZXJpYy02NDp+Izxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgICZndDvCoCDCoCBPbmNlIGEgbWFwIGlzIHJlbW92ZWQsIHdl
IGFyZSBhYmxlIHRvIGFkZCBpdCBvbmx5IHVzaW5nPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAjbXVsdGlwYXRowqA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCAmZ3Q7wqAgwqAgY29tbWFuZCBhbmQgbm90IHVzaW5nIG11bHRpcGF0aGQgdG9vbHMuPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgSXQgaXMgd29ya2luZyB0aGUgd2F5IGl0IHdhcyBkZXNpZ25lZCwgYnV0
IHBvc3NpYmx5IGl0IHdvdWxkPGJyPg0KJmd0O8KgIMKgIMKgIG1ha2U8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIHNlbnNlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgdG8gY2hhbmdlIHRoZSBkZXNpZ24uPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgWW91IGhhdmUg
bWVudGlvbmVkIHRoYXQgaXQgd291bGQgbWFrZSBzZW5zZSB0byBjaGFuZ2UgdGhlPGJyPg0KJmd0
O8KgIMKgIMKgIGRlc2lnbiB0bzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgYWRkPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgbWFwLiBBcmUgdGhlcmUgcGxh
bnMgdG8gY2hhbmdlIHRoZSBkZXNpZ24gPzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIEkgYW0gdHJ5aW5nIHRvIHVuZGVyc3RhbmQgdGhlIGNvZGUgZmxvdyB0byBjaGFu
Z2UgdGhlPGJyPg0KJmd0O8KgIMKgIMKgIGRlc2lnbi4gQ2FuPGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCB5b3U8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBn
dWlkZSBtZSBpZiB3ZSBzaG91bGQgc3RvcCByZW1vdmluZyB0aGUgZGV2aWNlIGZyb20gaW4gdGhl
PGJyPg0KJmd0O8KgIMKgIMKgIHJlbW92ZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
bWFwIGNvZGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBmbG93IG9y
IHN0YXJ0IGFkZGluZyB0aGUgZGV2aWNlIGFuZCB0aGUgbWFwIGluIHRoZSBhZGQgbWFwPGJyPg0K
Jmd0O8KgIMKgIMKgIGNvZGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGZsb3cuPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqBoYXZlIHRyaWVkIHRvIHVuZGVyc3RhbmQgdGhlIHJlbW92ZSBt
YXAgY29kZSBmbG93IG9mPGJyPg0KJmd0O8KgIMKgIMKgIG11bHRpcGF0aGQgaW48YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIDAuNC44PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgY29kZS48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgSSB0aGluayB0aGF0IHdlIHdhbnQgbXVsdGlwYXRoIHRvIGFjdHVhbGx5
IHJlbW92ZSB0aGUgbWFwPGJyPg0KJmd0O8KgIMKgIMKgIChpbnN0ZWFkIG9mPGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCBqdXN0IG5vdCBtb25pdG9yaW5nIGl0KSB3aGVuIHlvdSBjYWxs
ICZxdW90O3JlbW92ZSBtYXAgJmx0O21hcCZndDsmcXVvdDsuIFdlIGp1c3Q8YnI+DQomZ3Q7wqAg
wqAgwqAgd2FudDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJnF1b3Q7YWRkIG1hcCAm
bHQ7bWFwJmd0OyZxdW90OyB0byB0cnkgdG8gY3JlYXRlIHRoZSBtYXAgaWYgaXQgZG9lc24mIzM5
O3QgZXhpc3QuwqAgVG88YnI+DQomZ3Q7wqAgwqAgwqAgZG88YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgIHRoYXQsIHlvdSB3b3VsZCBuZWVkIHRvIGZpcnN0IGZpcmd1cmUgb3V0IHdoYXQg
V1dJRCBpcyBhc3NvY2lhdGVkPGJyPg0KJmd0O8KgIMKgIMKgIHdpdGg8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZsdDttYXAmZ3Q7LiBQcmVzdW1hYmx5LCAmbHQ7bWFwJmd0OyBjb3Vs
ZCBlaXRoZXIgYmUgYW4gYWxpYXMsIHd3aWQsIG9yIGV2ZW48YnI+DQomZ3Q7wqAgwqAgwqAgdGhl
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBuYW1lIG9mIGEgcGF0aCBpbiB0aGUgbWFw
LiBPbmNlIHlvdSBmb3VuZCB0aGUgbWFwLCB5b3Ugd291bGQgaGF2ZTxicj4NCiZndDvCoCDCoCDC
oCB0bzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgY2FsbCB0aGUgY29kZSB0byBjcmVh
dGUgdGhlIG1hcC48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgQWxzbywgdG8gYW5zd2VyIHlvdXIgSVJDIHF1ZXN0aW9uLCBubyB0aGUgMC40Ljgg
Y29kZSBpcyBub3Qgc3RpbGw8YnI+DQomZ3Q7wqAgwqAgwqAgYmVpbmc8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIGRldmVsb3BlZCB1cHN0cmVhbS7CoCBBbGwgdXBzdHJlYW0gcGF0Y2hl
cyBvbmx5IGdvIGFnYWluc3QgdGhlPGJyPg0KJmd0O8KgIMKgIMKgIGN1cnJlbnQ8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGhlYWQuIFRoZXJlIGFyZSBubyBvdGhlciB1cHN0cmVhbSBi
cmFuY2hlcy48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgLUJlbjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIGV2X3JlbW92ZV9tYXAgKGNoYXIgKiBkZXZu
YW1lLCBzdHJ1Y3QgdmVjdG9ycyAqIHZlY3MpPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqDCoMKgwqDC
oMKgwqDCoMKgIGZsdXNoX21hcChtcHAsIHZlY3MpOzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgwqDCoMKgwqDCoMKgwqAgZG1fZmx1c2hfbWFwKG1wcC0m
Z3Q7YWxpYXMsPGJyPg0KJmd0O8KgIMKgIMKgIERFRkFVTFRfVEFSR0VUKTs8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGlmPGJyPg0KJmd0O8KgIMKgIMKgICghZG1fbWFwX3ByZXNlbnQobWFw
bmFtZSkpPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoMKgIMKgwqAgwqDCoCByZXR1cm4gMDs8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoMKgwqDCoMKgwqAgaWYgKGRtX3R5cGUobWFwbmFtZSwgdHlwZSkgJmx0Oz0g
MCk8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVy
biAxOzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoCBpZiAoZG1fcmVtb3ZlX3BhcnRt
YXBzKG1hcG5hbWUpKTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgcmV0dXJuIDE7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqDCoMKgwqDCoMKgIGlmIChkbV9n
ZXRfb3BlbmNvdW50KG1hcG5hbWUpKSB7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBjb25kbG9nKDIsICZxdW90OyVzOiBtYXAgaW4gdXNlJnF1b3Q7LCBt
YXBuYW1lKTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHJldHVybiAxOzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoCB9IMKgwqDCoMKgwqA8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoMKgwqDCoMKgwqAgciA9IGRtX3NpbXBsZWNtZChETV9ERVZJ
Q0VfUkVNT1ZFLCBtYXBuYW1lKTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoMKgwqDCoMKgwqAgaWYg
KHIpIHs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNv
bmRsb2coNCwgJnF1b3Q7bXVsdGlwYXRoIG1hcCAlcyByZW1vdmVkJnF1b3Q7LDxicj4NCiZndDvC
oCDCoCDCoCBtYXBuYW1lKTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIMKgwqDCoCDCoMKgwqAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgcmV0dXJuIDA7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCB9PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG9ycGhhbl9wYXRocyh2ZWNz
LSZndDtwYXRodmVjLCBtcHApOzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVtb3ZlX21hcChtcHAsIHZlY3MsPGJyPg0K
Jmd0O8KgIMKgIMKgIHN0b3Bfd2FpdGVyX3RocmVhZCw8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgIDEpOzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIElzIHJlbW92aW5nIHRoaXMgYmVsb3cgbGlu
ZSwgdGhlIHJpZ2h0IHN0ZXAgdG8gc3RvcCByZW1vdmluZzxicj4NCiZndDvCoCDCoCDCoCB0aGU8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGRldmljZSA/PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgciA9IGRtX3NpbXBsZWNtZChETV9ERVZJQ0VfUkVNT1ZF
LCBtYXBuYW1lKTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBSZWdhcmRzLDxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIFRlamFzd2luaTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIE9uIE1vbiwgSnVuIDgsIDIwMTUgYXQg
MTE6MTUgQU0sIFRlamFzd2luaSBQb2x1cmk8YnI+DQo8L2Rpdj48L2Rpdj48c3BhbiBjbGFzcz0i
Ij4mZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCAmbHQ7WzFdWzJdWzNdPGEgaHJl
Zj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdt
YWlsLmNvbTwvYT4mZ3Q7IHdyb3RlOjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIFRoYW5rcyBhIGxv
dCBCZW4gZm9yIHRoZSBxdWljayBhbmQgZGV0YWlsZWQgcmVwbHkuIEkgaGF2ZTxicj4NCiZndDvC
oCDCoCDCoCBiZWVuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
c3RydWdnbGluZyB0byB1bmRlcnN0YW5kIGFuZCBjb25jbHVkZSB0aGUgaXNzdWVzIHdpdGg8YnI+
DQomZ3Q7wqAgwqAgwqAgbXVsdGlwYXRoPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBh
cyBJIGFtPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgdGhlIG9u
bHkgb25lIHdvcmtpbmcgZnJvbSBteSB0ZWFtLiBZb3VyIGlucHV0cyBoZWxwIG1lIGE8YnI+DQom
Z3Q7wqAgwqAgwqAgbG90Ljxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgVGhhbmtzPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgYWdhaW4uPGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgUmVnYXJkcyw8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBUZWphc3dpbmk8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBPbiBTYXQsIEp1biA2LCAyMDE1IGF0IDM6MzYg
QU0sIEJlbmphbWluIE1hcnppbnNraTxicj4NCjwvc3Bhbj48ZGl2PjxkaXYgY2xhc3M9Img1Ij4m
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmbHQ7WzJdWzNdWzRdPGEgaHJl
Zj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+Jmd0
OyB3cm90ZTo8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBPbiBGcmksIEp1biAwNSwgMjAxNSBh
dCAwMjozMToyMFBNICswNTMwLCBUZWphc3dpbmk8YnI+DQomZ3Q7wqAgwqAgwqAgUG9sdXJpPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB3cm90ZTo8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgSGlpIEJlbiw8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIFdlIGFyZSB0ZXN0aW5nIG11
bHRpcGF0aGQgdG9vbHMgd2l0aCBhbGwgdGhlPGJyPg0KJmd0O8KgIMKgIMKgIHBvc3NpYmxlPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBvcHRpb25zIGFuZDxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBmb2xsb3dpbmcgZmFpbHMuPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0Ozxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBDYXNlIDEgOiBy
ZW1vdmUgYW5kIGFkZCBtYXAuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgwqAgJmd0O8KgIMKgIHJvb3RAeDg2LWdlbmVyaWMtNjQ6fiMgbXVsdGlwYXRoZCAtayYj
Mzk7c2hvdyBtYXBzJiMzOTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCDCoCAmZ3Q7wqAgwqAgbmFtZcKgwqDCoCBzeXNmcyB1dWlkPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIGRtcGF0aDAgZG0tMMKgIDFJ
RVRfMDAwMTAwMDE8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDC
oCAmZ3Q7wqAgwqAgcm9vdEB4ODYtZ2VuZXJpYy02NDp+IyBtdWx0aXBhdGhkIC1rJiMzOTtyZW1v
dmUgbWFwPGJyPg0KJmd0O8KgIMKgIMKgIGRtcGF0aDAmIzM5Ozxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBvazxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCByb290QHg4Ni1nZW5lcmlj
LTY0On4jIG11bHRpcGF0aGQgLWsmIzM5O3Nob3cgbWFwcyYjMzk7PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIHJvb3RAeDg2LWdlbmVyaWMt
NjQ6fiMgbXVsdGlwYXRoZCAtayYjMzk7YWRkIG1hcDxicj4NCiZndDvCoCDCoCDCoCBkbXBhdGgw
JiMzOTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7
wqAgwqAgb2s8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAm
Z3Q7wqAgwqAgcm9vdEB4ODYtZ2VuZXJpYy02NDp+IyBtdWx0aXBhdGhkIC1rJiMzOTtzaG93IG1h
cHMmIzM5Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZn
dDvCoCDCoCByb290QHg4Ni1nZW5lcmljLTY0On4jPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIE9uY2UgYSBtYXAgaXMgcmVtb3ZlZCwgd2Ug
YXJlIGFibGUgdG8gYWRkIGl0IG9ubHk8YnI+DQomZ3Q7wqAgwqAgwqAgdXNpbmc8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAjbXVsdGlwYXRowqA8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgY29tbWFu
ZCBhbmQgbm90IHVzaW5nIG11bHRpcGF0aGQgdG9vbHMuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
wqAgSXQgaXMgd29ya2luZyB0aGUgd2F5IGl0IHdhcyBkZXNpZ25lZCwgYnV0IHBvc3NpYmx5IGl0
PGJyPg0KJmd0O8KgIMKgIMKgIHdvdWxkPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBt
YWtlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgc2Vuc2U8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCB0byBjaGFuZ2Ug
dGhlIGRlc2lnbi7CoCBUaGUgJnF1b3Q7cmVtb3ZlIG1hcCZxdW90OyBjb21tYW5kLCBub3Q8YnI+
DQomZ3Q7wqAgwqAgwqAgb25seSBzdG9wczxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgIG11bHRpcGF0aGQgZnJvbSBtb25pdG9yaW5nIHRoZSBtdWx0aXBhdGgg
ZGV2aWNlLCBidXQgaXQ8YnI+DQomZ3Q7wqAgwqAgwqAgcmVtb3Zlczxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgaXQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCDCoCBmcm9tPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
wqAgdGhlIHN5c3RlbSBhcyB3ZWxsLsKgIFRoZSAmcXVvdDthZGQgbWFwJnF1b3Q7IGNvbW1hbmQg
bWFrZXM8YnI+DQomZ3Q7wqAgwqAgwqAgbXVsdGlwYXRoPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCBtb25pdG9yIGFuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgwqAgYWxyZWFkeSBleGlzdGluZyBtdWx0aXBhdGggZGV2aWNlIHRoYXQgaW4gd2FzbiYj
Mzk7dDxicj4NCiZndDvCoCDCoCDCoCBwcmV2aW91c2x5PGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgbW9uaXRvcmluZy48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBUaGVzZSBjb21tYW5kcyBkbyB0aGlzIGZvciBoaXN0
b3JpY2FsIHJlYXNvbnMuwqA8YnI+DQomZ3Q7wqAgwqAgwqAgbXVsdGlwYXRoZDxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgd2FzbiYjMzk7dDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgIMKgIG9yaWdpbmFsbHkgaW4gY2hhcmdlIG9mIGNyZWF0aW5nIG11
bHRpcGF0aCBkZXZpY2VzLDxicj4NCiZndDvCoCDCoCDCoCBtdWx0aXBhdGg8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgIHdhcy7CoDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgIE9uY2U8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCDCoCBpdCBoYWQgY3JlYXRlZCB0aGUgZGV2aWNlLCBpdCByYW48YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCDCoCBtdWx0aXBhdGhkIC1rJnF1b3Q7YWRkIG1hcCAmbHQ7TUFQJmd0OyZxdW90
Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIHRvIG1ha2UgbXVsdGlwYXRoZCBzdGFydCBtb25p
dG9yaW5nIGl0LsKgIEhvd2V2ZXIgdGhpbmdzPGJyPg0KJmd0O8KgIMKgIMKgIGhhdmVuJiMzOTt0
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB3b3JrZWQ8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCB0aGlzIHdheSBzaW5jZSBSSEVMNCwgc28gcG9z
c2libHkgJnF1b3Q7YWRkIG1hcCZxdW90OyBzaG91bGQ8YnI+DQomZ3Q7wqAgwqAgwqAgYWN0dWFs
bHk8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGNyZWF0ZSB0aGU8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBkZXZpY2UgaWYgaXQgZG9lc24mIzM5
O3QgY3VycmVudGx5IGV4aXN0Ljxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgIMKgICZndDvCoCDCoCBDYXNlIDIgOiBBY3RpdmUgcGF0aHPCoCB0ZXN0IGNhc2U8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgIyB3
aGlsZSB0cnVlIDsgZG8gc2xlZXAgMyA7IG11bHRpcGF0aGQgLWsmIzM5O3JlbW92ZTxicj4NCiZn
dDvCoCDCoCDCoCBwYXRoIHNkYiYjMzk7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCA7
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgbXVsdGlwYXRo
ZDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDC
oCAtayYjMzk7YWRkIHBhdGggc2RiJiMzOTsgOyBtdWx0aXBhdGhkIC1rJiMzOTtzaG93IG1hcHMg
c3RhdHVzJiMzOTs8YnI+DQomZ3Q7wqAgwqAgwqAgOyBkb25lPGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIG9rPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIG9rPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIG5hbWUgZmFpbGJhY2sg
cXVldWVpbmcgcGF0aHMgZG0tc3Q8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCDCoCAmZ3Q7wqAgwqAgZG1wYXRoMCAtIC0gMSBhY3RpdmUgLy8gSXQgc2hvdWxkIGJl
IDIuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgVGhpcyBpcyBzaW1wbHkgYSB0aW1pbmcgaXNz
dWUuwqAgV2hhdCB5b3UgYXJlIHNlZWluZyBpdDxicj4NCiZndDvCoCDCoCDCoCB0aGU8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG51bWJlciBvZjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGFjdGl2ZSBwYXRocy7CoCBUaGVzZSBhcmUgcGF0aHMg
dGhhdCB0aGUga2VybmVsIGNhbiB1c2UuPGJyPg0KJmd0O8KgIMKgIMKgIFRoZTxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJnF1b3Q7YWRkIHBhdGgmcXVvdDs8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBjb21tYW5kIGRvZXNuJiMzOTt0IHVwZGF0
ZSB0aGUga2VybmVsIHN0YXRlLsKgIFRoaXMgaGFwcGVuczxicj4NCiZndDvCoCDCoCDCoCBsYXRl
ciBpbjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIHJlc3Bv
bnNlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgdG8gdGhl
IGtlcm5lbCByZWxvYWRpbmcgdGhlIGRldmljZSB0YWJsZS4gU28sIGluIGE8YnI+DQomZ3Q7wqAg
wqAgwqAgc2Vjb25kIG9yPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB0d28sIHRoaXM8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCB3aWxsIHNheSAy
LCBhcyBleHBlY3RlZC48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgV2Ugd291
bGQgbGlrZSB0byBrbm93IGlmIHRoZSB0ZXN0IGNhc2VzIGFyZSB2YWxpZDxicj4NCiZndDvCoCDC
oCDCoCBhbmQgaWY8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHRoZXNlPGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgYXJlIGJ1Z3Mgb3I8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgYW55IGRl
c2lnbiBpc3N1ZXMuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
wqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZn
dDvCoCDCoCBDYXNlIDMgOiBGYWlsIHBhdGggYW5kIHJlaW5zdGF0ZSBwYXRoPGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIHJvb3RAeDg2LWdl
bmVyaWMtNjQ6fiMgbXVsdGlwYXRoZCAtayZxdW90O2ZhaWwgcGF0aDxicj4NCiZndDvCoCDCoCDC
oCBzZGMmcXVvdDs7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBtdWx0aXBhdGhkPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIC1r
JiMzOTtyZWluc3RhdGUgcGF0aCBzZGMmIzM5OzsgbXVsdGlwYXRoZCAtayZxdW90O3Nob3cgcGF0
aHMmcXVvdDs7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAg
Jmd0O8KgIMKgICZndDvCoMKgwqAgWyAzOTYyLjcwODUyM10gZGV2aWNlLW1hcHBlcjogbXVsdGlw
YXRoOjxicj4NCiZndDvCoCDCoCDCoCBGYWlsaW5nIHBhdGg8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgIDg6MzIuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgwqAgJmd0O8KgIMKgICZndDvCoMKgwqAgb2s8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgJmd0O8KgwqDCoCBvazxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCAmZ3Q7wqDCoMKgIGhj
aWzCoMKgwqAgZGV2IGRldl90IHByaSBkbV9zdMKgwqAgY2hrX3N0wqDCoDxicj4NCiZndDvCoCDC
oCDCoCBuZXh0X2NoZWNrPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgwqAgJmd0O8KgIMKgICZndDvCoMKgwqAgNDowOjA6MSBzZGMgODozMsKgIDHCoMKgIFthY3Rp
dmVdW2ZhdWx0eV08YnI+DQomZ3Q7wqAgwqAgwqAgLi4uLi4uLi4uLjxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgMS8yMMKgwqA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCDCoCAmbHQ7PT1DSEVDSzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCAmZ3Q7wqDCoMKgIDU6MDowOjEgc2RkIDg6NDjCoCAx
wqDCoCBbYWN0aXZlXVtyZWFkeV3CoDxicj4NCiZndDvCoCDCoCDCoCBYWC4uLi4uLi4uPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCA0LzIwPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIHNkYyBwYXRoIGJlY29tZXMgW2FjdGl2ZV1b
cmVhZHldIG9ubHkgYWZ0ZXIgdGhlPGJyPg0KJmd0O8KgIMKgIMKgIHBvbGxpbmc8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGludGVydmFsPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgwqAgYnV0IG5vdDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBpbW1lZGlhdGVseSBhZnRlciB0aGUgcmVpbnN0
YXRlIHBhdGggY29tbWFuZC48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCDCoCAmZ3Q7wqAgwqAgWW91IGhhdmUgYW5zd2VyZWQgdGhhdCB0aGlzIGlzIGEgZGVzaWdu
IGlzc3VlLiBCdXQ8YnI+DQomZ3Q7wqAgwqAgwqAgd2UgaGF2ZTxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgaGVhcmQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCDCoCBmcm9tIG91cjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIMKgICZndDvCoCDCoCB0ZXN0IHRlYW0gdGhhdCB0aGUgc2FtZSB0ZXN0IGNhc2Ugd29ya3Mg
aW4gUkhFTDYuPGJyPg0KJmd0O8KgIMKgIMKgIERpZCB5b3U8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgIG9ic2VydmU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCDCoCBpdD88YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDC
oCAmZ3Q7wqAgwqAgSSBhbSBhbHNvIGZpbmRpbmcgdGhhdCB0aGUgdGVzdCBjYXNlcyBmYWlsIGJl
Y2F1c2U8YnI+DQomZ3Q7wqAgwqAgwqAgd2UgYXJlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCB0cnlpbmc8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDC
oCB0byBkbzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZn
dDvCoCDCoCBtdWx0aXBsZSBjb21tYW5kcyBhdCBvbmUgc2hvdC7CoCBQbGVhc2Ugc2hhcmUgeW91
cjxicj4NCiZndDvCoCDCoCDCoCB0aG91Z2h0czxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgc288YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCB0aGF0
IGl0PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8Kg
IMKgIGNvdWxkIGhlbHAgbWUgaW4gZGVidWdnaW5nIHRoZSBpc3N1ZXMgZnVydGhlci48YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgwqAgSXQmIzM5O3MgdG90YWxseSBwb3NzaWJsZSB0aGF0IHRoZSBjaGVja2Vy
IHN0YXRlIGlzPGJyPg0KJmd0O8KgIMKgIMKgIGltbWVkaWF0ZWx5PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCB1cGRhdGVkIGluPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgwqAgUkhFTDYuwqAgTGlrZSBJIHNhaWQgYmVmb3JlLCB3aGF0IGl0IGN1cnJl
bnRseSBkb2VzLDxicj4NCiZndDvCoCDCoCDCoCBhbHRob3VnaDxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgY29ycmVjdCw8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCDCoCBpcyBjb25mdXNpbmcsIGFuZCBwZXJoYXBzIHdlIG5lZWQgYSBkaWZmZXJlbnQg
Y2hlY2tlcjxicj4NCiZndDvCoCDCoCDCoCBzdGF0ZSBmb3I8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgIHBhdGhzPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgwqAgd2hlcmUgdGhlICZxdW90O2ZhaWwgcGF0aCZxdW90OyBjb21tYW5kIGhhcyBiZWVuIHVz
ZWQuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgLUJlbjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBSZWdhcmRzLDxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBUZWphc3dpbmk8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgT24g
VHVlLCBNYXkgMTksIDIwMTUgYXQgNTozNyBQTSwgVGVqYXN3aW5pIFBvbHVyaTxicj4NCjwvZGl2
PjwvZGl2PjxzcGFuIGNsYXNzPSIiPiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIMKgICZndDvCoCDCoCAmbHQ7WzFdWzNdWzRdWzVdPGEgaHJlZj0ibWFpbHRvOnRlamFzd2lu
aXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT4mZ3Q7IHdy
b3RlOjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDs8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgVGhhbmtzIGEgbG90IEJlbi4gSSB3aWxsIGxvb2sgaW50byBpdCBtb3JlLsKgPGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIE9uIE1v
biwgTWF5IDE4LCAyMDE1IGF0IDk6NTcgUE0sIEJlbmphbWluPGJyPg0KJmd0O8KgIMKgIMKgIE1h
cnppbnNraTxicj4NCjwvc3Bhbj48ZGl2PjxkaXYgY2xhc3M9Img1Ij4mZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmx0O1syXVs0XVs1XVs2XTxh
IGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9h
PiZndDsgd3JvdGU6PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
wqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZn
dDvCoCDCoCDCoCDCoCBPbiBNb24sIE1heSAxOCwgMjAxNSBhdCAwMjowOToyN1BNICswNTMwLDxi
cj4NCiZndDvCoCDCoCDCoCBUZWphc3dpbmk8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IFBvbHVyaTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIHdy
b3RlOjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvC
oCDCoCDCoCDCoCAmZ3Q7wqAgwqAgSGlpLDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgV2UgYXJlIHRyeWluZyB0
byB0ZXN0IG11bHRpcGF0aCBzZXR1cCBpbjxicj4NCiZndDvCoCDCoCDCoCBvdXI8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHRhcmdldCBhbmQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCB0cmllZCB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgdmFyaW91czxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7
wqAgwqAgY29tbWFuZHMgb2YgbXVsdGlwYXRoZCBkZW1hb24gYW5kIHdlIGZpbmQ8YnI+DQomZ3Q7
wqAgwqAgwqAgdGhlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBmb2xsb3dpbmc8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBlcnJvcjo8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAg
Jmd0O8KgIMKgIHJvb3RAeDg2LWdlbmVyaWMtNjQ6fiMgbXVsdGlwYXRoZCAtayZxdW90O2ZhaWw8
YnI+DQomZ3Q7wqAgwqAgwqAgcGF0aDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgc2Rj
JnF1b3Q7Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIG11
bHRpcGF0aGQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIC1rJiMzOTtyZWluc3RhdGUgcGF0aDxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7
wqAgwqAgc2RjJiMzOTs7IG11bHRpcGF0aGQgLWsmcXVvdDtzaG93IHBhdGhzJnF1b3Q7Ozxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDC
oCAmZ3Q7wqAgwqAgWyAzOTYyLjcwODUyM10gZGV2aWNlLW1hcHBlcjogbXVsdGlwYXRoOjxicj4N
CiZndDvCoCDCoCDCoCBGYWlsaW5nPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgwqAgcGF0aMKgODozMi48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIG9rPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDC
oCBvazxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvC
oCDCoCDCoCDCoCAmZ3Q7wqAgwqAgaGNpbMKgIMKgIGRldiBkZXZfdCBwcmkgZG1fc3TCoCDCoGNo
a19zdMKgPGJyPg0KJmd0O8KgIMKgIMKgIMKgbmV4dF9jaGVjazxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgNDow
OjA6MSBzZGPCoDg6MzLCoCAxwqAgwqBbYWN0aXZlXVtmYXVsdHldPGJyPg0KJmd0O8KgIMKgIMKg
IC4uLi4uLi4uLi48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIDEvMjDCoDxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIMKgICZsdDsmbHQ7Jmx0Oz09
PTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDC
oCDCoCDCoCBDSEVDSzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgNTowOjA6MSBzZGTCoDg6NDjCoCAxwqAgwqBb
YWN0aXZlXVtyZWFkeV3CoDxicj4NCiZndDvCoCDCoCDCoCBYWC4uLi4uLi4uPGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCA0LzIwPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBzZGMgcGF0aCBiZWNvbWVz
IFthY3RpdmVdW3JlYWR5XSBvbmx5PGJyPg0KJmd0O8KgIMKgIMKgIGFmdGVyIHRoZTxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgcG9sbGluZzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgIMKgIGludGVydmFsPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGJ1dCBub3Q8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8Kg
IMKgIGltbWVkaWF0ZWx5IGFmdGVyIHRoZSByZWluc3RhdGUgcGF0aDxicj4NCiZndDvCoCDCoCDC
oCBjb21tYW5kLsKgPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
wqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBJIGFtIG9ic2VydmluZyB0aGlzIGluIGxhdGVz
dCBtdWx0aXBhdGg8YnI+DQomZ3Q7wqAgwqAgwqAgdG9vbHMgaW48YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIHVidW50dTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgIMKgIG1hY2hpbmU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgYXMgd2VsbC48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIFBsZWFzZSBs
ZXQgbWUga25vdyBpZiBpdHMgYSBrbm93biBpc3N1ZSBvcjxicj4NCiZndDvCoCDCoCDCoCBpZiBJ
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBhbSBkb2luZzxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBzb21ldGhpbmcg
d3JvbmcuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0
O8KgIMKgIMKgIMKgICZndDvCoCDCoCBSZWdhcmRzLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgVGVqYXN3aW5p
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0Ozxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDC
oCB0aGUgcmVpbnN0YXRlIGNvbW1hbmQgaXMgc3VwcG9zZWQgdG8gcmVpbnN0YXRlPGJyPg0KJmd0
O8KgIMKgIMKgIHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgZGV2aWNlPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgd2l0aCB0aGU8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAg
a2VybmVsLCBhbmQgaXQgZG9lcyB0aGF0LiBUaGUgY2hlY2tlciBzdGF0ZTxicj4NCiZndDvCoCDC
oCDCoCBkb2VzbiYjMzk7dDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgY2hhbmdlPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgdW50aWwgdGhlPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKg
IMKgIG5leHQgdGltZSB0aGF0IHRoZSBwYXRoIGlzIGNoZWNrZWQuwqAgSSBhZ3JlZTxicj4NCiZn
dDvCoCDCoCDCoCB0aGF0IGl0JiMzOTtzPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBv
ZGQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCB0aGF0IHRo
ZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDC
oCDCoCDCoCBjaGVjayBzdGF0ZSBzd2l0Y2hlcyB0byBmYXVsdHkgYXMgc29vbiBhcyB5b3U8YnI+
DQomZ3Q7wqAgwqAgwqAgZmFpbCB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHBh
dGgsPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgYnV0IGl0
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKg
IMKgIMKgIGRvZXNuJiMzOTt0IHN3aXRjaCBiYWNrIHVudGlsIHRoZSBuZXh0IGNoZWNrIGFmdGVy
PGJyPg0KJmd0O8KgIMKgIMKgIHlvdTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgcmVp
bmlzdGF0ZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGl0
Ljxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDs8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
wqAgVGhlIGlzc3VlIGlzIHRoYXQgbXVsdGlwYXRoZCBuZWVkcyB0byBvdmVycmlkZTxicj4NCiZn
dDvCoCDCoCDCoCB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGNoZWNrZXI8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBvdXRwdXQsPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKg
IHNvIHRoYXQgYSBmYWlsZWQgcGF0aCB3b24mIzM5O3QgYmUgaW1tZWRpdGF0ZWx5PGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCByZWluc3RhdGVkLsKgIE9uY2U8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgcGF0aCBjb21lcyBiYWNr
LCBtdWx0aXBhdGhkIHdhbnRzIHRvIHJlY29yZCB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAgc3dpdGNo
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBpbiB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBjaGVja2VyPGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIHRocmVhZCwgc28gdGhh
dCBpdCBjYW4gcmVmcmVzaCBwYXRoIGluZm9ybWF0aW9uPGJyPg0KJmd0O8KgIMKgIMKgIHdoYXQ8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHdhc24mIzM5O3Q8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgYXV0b21hdGlj
YWxseSBkb25lIHdoZW4gdGhlIHBhdGggd2FzPGJyPg0KJmd0O8KgIMKgIMKgIHJlaW5zdGF0ZWQu
wqA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIEhvd2V2ZXIsIGl0PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgbWF5IG1ha2U8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgbW9yZSBz
ZW5zZSB0byBoYXZlIGEgZGlmZmVyZW50IGNoZWNrZXIgc3RhdGU8YnI+DQomZ3Q7wqAgwqAgwqAg
Zm9yIHdoZW48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHRoZTxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGRldmljZSBpczxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBpbiB0aGUg
ZmFpbGVkIHN0YXRlLCBzbyB0aGF0IGl0JiMzOTtzIG9idmlvdXMgdGhhdDxicj4NCiZndDvCoCDC
oCDCoCB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGNoZWNrZXI8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBzdGF0ZSBpczxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBiZWlu
ZyBvdmVycnVsZWQuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
wqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZn
dDvCoCDCoCDCoCDCoCAtQmVuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7IC0tPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDsgZG0tZGV2ZWwgbWFpbGluZyBs
aXN0PGJyPg0KPC9kaXY+PC9kaXY+Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDsgWzNdWzVdWzZdWzddPGEgaHJlZj0ibWFpbHRvOmRt
LWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDs8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIFs0XVs2XVs3XVs4XTxhIGhyZWY9Imh0dHBzOi8v
d3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVy
IiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgwqAgLS08YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgZG0tZGV2ZWwgbWFpbGluZyBsaXN0PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIFs1XVs3
XVs4XVs5XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRo
YXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKg
ICZndDvCoCDCoCDCoCDCoDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgWzZdWzhdWzld
WzEwXTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7IFJlZmVyZW5jZXM8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIFZpc2libGUgbGlua3M8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgMS4gbWFpbHRvOls5
XVsxMF1bMTFdPGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWph
c3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgMi4gbWFpbHRvOlsxMF1bMTFdWzEyXTxhIGhyZWY9
Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCAzLiBt
YWlsdG86WzExXVsxMl1bMTNdPGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRt
LWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgwqAgJmd0O8KgIMKgIDQuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBb
MTJdWzEzXVsxNF08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgNS4gbWFpbHRvOlsxM11b
MTRdWzE1XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRo
YXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKg
ICZndDvCoCDCoCA2Ljxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgWzE0XVsxNV1bMTZd
PGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
IiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7IFJlZmVyZW5jZXM8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCBWaXNpYmxlIGxpbmtzPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgMS4gbWFpbHRvOlsxNl1bMTddPGEgaHJlZj0ibWFpbHRvOnRlamFz
d2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCAyLiBtYWlsdG86WzE3XVsxOF08
YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwv
YT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCAzLiBtYWlsdG86WzE4
XVsxOV08YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2lu
aXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIDQuIG1haWx0bzpbMTldWzIwXTxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQu
Y29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIDUuIG1haWx0bzpbMjBdWzIxXTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEBy
ZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIDYuIFsyMV1bMjJdPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0i
X2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8
L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgNy4gbWFpbHRvOlsy
Ml1bMjNdPGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhh
dC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgOC4gWzIz
XVsyNF08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCA5LiBtYWlsdG86WzI0XVsyNV08YSBocmVmPSJtYWlsdG86dGVq
YXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTAuIG1haWx0bzpbMjVdWzI2
XTxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29t
PC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTEuIG1haWx0bzpb
MjZdWzI3XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRo
YXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTIuIFsy
N11bMjhdPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAxMy4gbWFpbHRvOlsyOF1bMjldPGEgaHJlZj0ibWFpbHRvOmRt
LWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAxNC4gWzI5XVszMF08YSBocmVmPSJodHRwczovL3d3
dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIg
dGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
IFJlZmVyZW5jZXM8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgVmlzaWJsZSBsaW5rczxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgMS4gbWFpbHRv
OlszMV08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0
LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDIuIG1haWx0bzpbMzJdPGEgaHJl
Zj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdt
YWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDMuIG1haWx0bzpbMzNdPGEg
aHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCA0LiBtYWlsdG86WzM0XTxhIGhyZWY9Im1haWx0
bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208
L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCA1LiBtYWlsdG86WzM1XTxhIGhyZWY9Im1h
aWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgNi4gbWFpbHRvOlszNl08YSBocmVmPSJtYWlsdG86ZG0tZGV2
ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIDcuIFszN108YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBz
Oi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIDguIG1haWx0bzpbMzhdPGEgaHJlZj0ibWFpbHRvOmRtLWRldmVs
QHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCA5LiBbMzldPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczov
L3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoDEwLiBtYWlsdG86WzQwXTxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlw
b2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoDExLiBtYWlsdG86WzQxXTxhIGhyZWY9Im1haWx0bzpibWFyemlu
c0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAxMi4gbWFpbHRvOls0Ml08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNv
bSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTMu
IFs0M108YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgMTQuIG1haWx0bzpbNDRdPGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20i
PmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDE1LiBb
NDVdPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQu
Y29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoDE2LiBtYWlsdG86WzQ2XTxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWls
LmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoDE3LiBtYWlsdG86WzQ3XTxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29t
Ij5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAxOC4g
bWFpbHRvOls0OF08YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRl
amFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAx
OS4gbWFpbHRvOls0OV08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnpp
bnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMjAuIG1haWx0bzpb
NTBdPGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5j
b208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDIxLiBbNTFdPGEgaHJlZj0iaHR0cHM6
Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJy
ZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDIyLiBtYWlsdG86WzUy
XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29t
PC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAyMy4gWzUzXTxhIGhyZWY9Imh0dHBzOi8v
d3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVy
IiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAyNC4gbWFpbHRvOls1NF08
YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVy
aTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAyNS4gbWFpbHRvOls1
NV08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNv
bTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMjYuIG1haWx0bzpbNTZdPGEgaHJlZj0i
bWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoDI3LiBbNTddPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0i
X2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8
L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDI4LiBtYWlsdG86WzU4XTxhIGhyZWY9Im1h
aWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAyOS4gWzU5XTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9i
bGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9h
Pjxicj4NCjxzcGFuIGNsYXNzPSIiPiZndDs8YnI+DQomZ3Q7IFJlZmVyZW5jZXM8YnI+DQomZ3Q7
PGJyPg0KJmd0O8KgIMKgIFZpc2libGUgbGlua3M8YnI+DQomZ3Q7wqAgwqAgMS4gbWFpbHRvOjxh
IGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9h
Pjxicj4NCjwvc3Bhbj48c3BhbiBjbGFzcz0iIj4mZ3Q7wqAgwqAgMi4gbWFpbHRvOjxhIGhyZWY9
Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4N
CiZndDvCoCDCoCAzLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21h
aWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgNC4g
bWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRo
YXQuY29tPC9hPjxicj4NCjwvc3Bhbj4mZ3Q7wqAgwqAgNS4gbWFpbHRvOjxhIGhyZWY9Im1haWx0
bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208
L2E+PGJyPg0KJmd0O8KgIMKgIDYuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVk
aGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQo8c3BhbiBjbGFzcz0iIj4mZ3Q7
wqAgwqAgNy4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1k
ZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCA4LiA8YSBocmVmPSJodHRwczovL3d3
dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIg
dGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbDwvYT48YnI+DQo8L3NwYW4+Jmd0O8KgIMKgIDkuIG1haWx0bzo8YSBocmVmPSJtYWls
dG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7
wqAgwqAxMC4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgMTEu
IG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFz
d2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoDEyLiBtYWlsdG86PGEgaHJl
Zj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJy
Pg0KPHNwYW4gY2xhc3M9IiI+Jmd0O8KgIMKgMTMuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0t
ZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAx
NC4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQu
Y29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KPC9zcGFuPiZndDvCoCDCoDE1
LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJl
ZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgMTYuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9
Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
PC9hPjxicj4NCiZndDvCoCDCoDE3LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBv
bHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7
wqAgwqAxOC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFy
emluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDE5LiBtYWlsdG86PGEgaHJlZj0ibWFp
bHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNv
bTwvYT48YnI+DQomZ3Q7wqAgwqAyMC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0By
ZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDIxLiBtYWls
dG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5j
b208L2E+PGJyPg0KJmd0O8KgIMKgMjIuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFu
ayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxi
cj4NCiZndDvCoCDCoDIzLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5j
b20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgMjQuIDxhIGhyZWY9Imh0
dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3Jl
ZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoDI1LiBtYWlsdG86PGEgaHJlZj0ibWFp
bHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNv
bTwvYT48YnI+DQomZ3Q7wqAgwqAyNi4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0By
ZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDI3LiBtYWls
dG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5j
b208L2E+PGJyPg0KJmd0O8KgIMKgMjguIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFu
ayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxi
cj4NCiZndDvCoCDCoDI5LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5j
b20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgMzAuIDxhIGhyZWY9Imh0
dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3Jl
ZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoDMxLiBtYWlsdG86PGEgaHJlZj0ibWFp
bHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0
O8KgIMKgMzIuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5j
b20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoDMzLiBtYWls
dG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5j
b208L2E+PGJyPg0KJmd0O8KgIMKgMzQuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5p
cG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZn
dDvCoCDCoDM1LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJt
YXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgMzYuIG1haWx0bzo8YSBocmVmPSJt
YWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQom
Z3Q7wqAgwqAzNy4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3
dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKg
MzguIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxA
cmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAzOS4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdl
dD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWw8L2E+PGJyPg0KJmd0O8KgIMKgNDAuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5p
cG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZn
dDvCoCDCoDQxLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJt
YXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgNDIuIG1haWx0bzo8YSBocmVmPSJt
YWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQom
Z3Q7wqAgwqA0My4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3
dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKg
NDQuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxA
cmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA0NS4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdl
dD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWw8L2E+PGJyPg0KJmd0O8KgIMKgNDYuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5p
cG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZn
dDvCoCDCoDQ3LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJt
YXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgNDguIG1haWx0bzo8YSBocmVmPSJt
YWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwu
Y29tPC9hPjxicj4NCiZndDvCoCDCoDQ5LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5z
QHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgNTAuIG1h
aWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0
LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA1MS4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2Js
YW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+
PGJyPg0KJmd0O8KgIMKgNTIuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0
LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA1My4gPGEgaHJlZj0i
aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5v
cmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgNTQuIG1haWx0bzo8YSBocmVmPSJt
YWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwu
Y29tPC9hPjxicj4NCiZndDvCoCDCoDU1LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5z
QHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgNTYuIG1h
aWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0
LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA1Ny4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2Js
YW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+
PGJyPg0KJmd0O8KgIMKgNTguIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0
LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA1OS4gPGEgaHJlZj0i
aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5v
cmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KPC9ibG9ja3F1b3RlPjwvZGl2Pjxicj48L2Rpdj4N
Cg==
--001a11c2edbe45aa5e0519b5d0c0--


--===============2216121049492845943==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2216121049492845943==--
