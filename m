From: Tejaswini Poluri <tejaswinipoluri3@gmail.com>
Subject: Re: reinstate path not working
Date: Wed, 8 Jul 2015 17:31:26 +0530
Message-ID: <CAH=b03t0YgQu3ku+OjPfYYD5JGPRBWV6fK7Vibf2gRjPL-OyaQ@mail.gmail.com>
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
	<20150706174515.GP1409@octiron.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1140fee6fb09b5051a5be5d4
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150706174515.GP1409@octiron.msp.redhat.com>
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

--001a1140fee6fb09b5051a5be5d4
Content-Type: multipart/alternative; boundary=001a1140fee6fb09af051a5be5d2

--001a1140fee6fb09af051a5be5d2
Content-Type: text/plain; charset=UTF-8

Thanks a lot.
Can you guide me how to push upstream for the approval. Which branch should
I push to? Any list of testcases I should perform before I could push?

I have created the following two patches. PFA

Regards,
Tejaswini

On Mon, Jul 6, 2015 at 11:15 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Tue, Jun 30, 2015 at 11:22:37AM +0530, Tejaswini Poluri wrote:
> >    Thanks Ben. So should I push the code to the upstream and get an
> approval?
> >    Regards,
>
> Yes. Thanks!
>
> -Ben
>
> >    Tejaswini
> >    On Tue, Jun 30, 2015 at 12:50 AM, Benjamin Marzinski
> >    <[1]bmarzins@redhat.com> wrote:
> >
> >      On Fri, Jun 26, 2015 at 12:21:48PM +0530, Tejaswini Poluri wrote:
> >      >    Yes I agree that having the same code in both cli_add_map() and
> >      ev_add_map
> >      >    is not necessary. Hence I would suggest removing get_refwwid()
> code
> >      from
> >      >    ev_add_map as it is not being used by anyone.
> >      >
> >      >    ev_add_map(param, NULL, vecs) would create the multipath
> device by
> >      using
> >      >    the get_refwwid() code and but all the functions above it like
> >      >    (dm_get_minor, dm_get_major and dm_mapname) would fail and it
> >      wouldn't
> >      >    enter any of the other code in ev_add_map like
> >      >    1.dm_map_present,
> >      >    2.add_map_without_path
> >      >    3. sync_map_state
> >      >    which are responsible for registering the map and displaying
> it.
> >      >
> >      >    So, I think moving the below code from ev_add_map to
> cli_add_map
> >      should be
> >      >    a good idea right.
> >      >
> >      >    r = get_refwwid(dev, DEV_DEVMAP, vecs->pathvec,&refwwid);
> >      >    >
> >      >    >            if (refwwid) {
> >      >    >                    r = coalesce_paths(vecs, NULL, refwwid,0);
> >      >    >                    dm_lib_release();
> >      >    >            }
> >      >    What do u think?
> >
> >      I agree. We aren't using the code in ev_add_map, so it's presence
> there
> >      is simply confusing.
> >
> >      -Ben
> >      >
> >      >    Regards,
> >      >    Tejaswini
> >      >    On Fri, Jun 26, 2015 at 4:32 AM, Benjamin Marzinski
> >      >    <[1][2]bmarzins@redhat.com> wrote:
> >      >
> >      >      On Tue, Jun 23, 2015 at 03:48:26PM +0530, Tejaswini Poluri
> wrote:
> >      >      >    Hi Ben,
> >      >      >
> >      >      >    This is regarding the add map issue I have been
> discussing.
> >      Posting
> >      >      the
> >      >      >    issue again to remind.
> >      >      >
> >      >      >    Case 1 : remove and add map.
> >      >      >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >      >    name    sysfs uuid
> >      >      >    dmpath0 dm-0  1IET_00010001
> >      >      >    root@x86-generic-64:~# multipathd -k'remove map
> dmpath0'
> >      >      >    ok
> >      >      >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >      >    root@x86-generic-64:~# multipathd -k'add map dmpath0'
> >      >      >    ok
> >      >      >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >      >    root@x86-generic-64:~#
> >      >      >    Once a map is removed, we are able to add it only using
> >      #multipath
> >      >      >    command and not using multipathd tools.
> >      >      >
> >      >      >    I have fixed the problem with two approaches. I would
> like
> >      you to
> >      >      review
> >      >      >    the same.
> >      >      >    Patch1 : By making 'remove map dmpath0' to remove only
> the
> >      map and
> >      >      not the
> >      >      >    device. I have added extra functions discard_map and
> >      dm_remove_map
> >      >      so as
> >      >      >    to not interfere with the existing code.
> >      >      >
> >      >      >    Patch 2: The approach you have suggested.By getting wwid
> >      from the
> >      >      mapname
> >      >      >    and doing coalesce_paths. I have just moved the
> following
> >      code in
> >      >      >    ev_add_map to cli_add_map.
> >      >
> >      >      This is the general idea we'd like to go with.  However,
> looking
> >      at the
> >      >      latest upstream code, I don't think you should pull code in
> from
> >      >      ev_add_map() to cli_add_map() like your patch does.
> cli_add_map()
> >      >      already calls ev_add_map(), and ev_add_map() is certainly
> able to
> >      add
> >      >      the map if it doesn't already exist.
> >      >
> >      >      You would just need to call it with
> >      >
> >      >      ev_add_map(param, NULL, vecs);
> >      >
> >      >      and ev_add_map() will happily create you a new multipath
> device.
> >      All
> >      >      you need to do is make sure that all the functions that
> >      ev_add_map()
> >      >      calls with alias can accept a NULL value there.
> >      >
> >      >      This might not be the best way to go about this, however.  It
> >      turns out
> >      >      that right now, even though ev_add_map() technically has the
> >      ability to
> >      >      create new maps, nothing currently uses it, and it really
> doesn't
> >      make
> >      >      sense for it to be there. Instead of just copying that code,
> you
> >      could
> >      >      pull the map creation code out of ev_add_map() and add it to
> >      >      cli_add_map(), for those situations where the requested
> device
> >      doesn't
> >      >      already exist.
> >      >
> >      >      But having the code in both cli_add_map() and ev_add_map()
> when
> >      one
> >      >      already calls the other doesn't seem necessary.
> >      >
> >      >      -Ben
> >      >
> >      >      >
> >      >      >    r = get_refwwid(dev, DEV_DEVMAP,
> vecs->pathvec,&refwwid);
> >      >      >
> >      >      >            if (refwwid) {
> >      >      >                    r = coalesce_paths(vecs, NULL,
> refwwid,0);
> >      >      >                    dm_lib_release();
> >      >      >            }
> >      >      >
> >      >      >    changed dev to param.
> >      >      >
> >      >      >    I have tested the same in all 3 versions -0.4.8, 0.4.9
> and
> >      0.5.0.
> >      >      It would
> >      >      >    be great if you can review the same so that it doesn't
> cause
> >      any
> >      >      extra
> >      >      >    side effects.
> >      >      >    I guess Patch2 is the way u have suggested me in the
> >      previous mail.
> >      >      Please
> >      >      >    review it and share your views.
> >      >      >    Regards,
> >      >      >    Tejaswini
> >      >      >    On Fri, Jun 12, 2015 at 2:21 AM, Benjamin Marzinski
> >      >      >    <[1][2][3]bmarzins@redhat.com> wrote:
> >      >      >
> >      >      >      On Wed, Jun 10, 2015 at 11:46:51AM +0530, Tejaswini
> Poluri
> >      wrote:
> >      >      >      >
> >      >      >      >    >    We are testing multipathd tools with all the
> >      possible
> >      >      options
> >      >      >      and the
> >      >      >      >    >    following fails.
> >      >      >      >    >
> >      >      >      >    >    Case 1 : remove and add map.
> >      >      >      >    >    root@x86-generic-64:~# multipathd -k'show
> maps'
> >      >      >      >    >    name    sysfs uuid
> >      >      >      >    >    dmpath0 dm-0  1IET_00010001
> >      >      >      >    >    root@x86-generic-64:~# multipathd
> -k'remove map
> >      >      dmpath0'
> >      >      >      >    >    ok
> >      >      >      >    >    root@x86-generic-64:~# multipathd -k'show
> maps'
> >      >      >      >    >    root@x86-generic-64:~# multipathd -k'add
> map
> >      dmpath0'
> >      >      >      >    >    ok
> >      >      >      >    >    root@x86-generic-64:~# multipathd -k'show
> maps'
> >      >      >      >    >    root@x86-generic-64:~#
> >      >      >      >    >    Once a map is removed, we are able to add it
> >      only using
> >      >      >      #multipath
> >      >      >      >    >    command and not using multipathd tools.
> >      >      >      >
> >      >      >      >    It is working the way it was designed, but
> possibly
> >      it would
> >      >      make
> >      >      >      sense
> >      >      >      >    to change the design.
> >      >      >      >
> >      >      >      >    You have mentioned that it would make sense to
> change
> >      the
> >      >      design to
> >      >      >      add
> >      >      >      >    map. Are there plans to change the design ?
> >      >      >      >    I am trying to understand the code flow to
> change the
> >      >      design. Can
> >      >      >      you
> >      >      >      >    guide me if we should stop removing the device
> from
> >      in the
> >      >      remove
> >      >      >      map code
> >      >      >      >    flow or start adding the device and the map in
> the
> >      add map
> >      >      code
> >      >      >      flow.
> >      >      >      >
> >      >      >      >     have tried to understand the remove map code
> flow of
> >      >      multipathd in
> >      >      >      0.4.8
> >      >      >      >    code.
> >      >      >
> >      >      >      I think that we want multipath to actually remove the
> map
> >      >      (instead of
> >      >      >      just not monitoring it) when you call "remove map
> <map>".
> >      We just
> >      >      want
> >      >      >      "add map <map>" to try to create the map if it doesn't
> >      exist.  To
> >      >      do
> >      >      >      that, you would need to first firgure out what WWID is
> >      associated
> >      >      with
> >      >      >      <map>. Presumably, <map> could either be an alias,
> wwid,
> >      or even
> >      >      the
> >      >      >      name of a path in the map. Once you found the map, you
> >      would have
> >      >      to
> >      >      >      call the code to create the map.
> >      >      >
> >      >      >      Also, to answer your IRC question, no the 0.4.8 code
> is
> >      not still
> >      >      being
> >      >      >      developed upstream.  All upstream patches only go
> against
> >      the
> >      >      current
> >      >      >      head. There are no other upstream branches.
> >      >      >
> >      >      >      -Ben
> >      >      >      >
> >      >      >      >    ev_remove_map (char * devname, struct vectors *
> vecs)
> >      >      >      >
> >      >      >      >              flush_map(mpp, vecs);
> >      >      >      >
> >      >      >      >                           dm_flush_map(mpp->alias,
> >      >      DEFAULT_TARGET);
> >      >      >      >
> >      >      >      >                                     if
> >      >      (!dm_map_present(mapname))
> >      >      >      >
> >      >      >      >                                            return 0;
> >      >      >      >
> >      >      >      >           if (dm_type(mapname, type) <= 0)
> >      >      >      >
> >      >      >      >                   return 1;
> >      >      >      >
> >      >      >      >           if (dm_remove_partmaps(mapname))
> >      >      >      >
> >      >      >      >                   return 1;
> >      >      >      >
> >      >      >      >           if (dm_get_opencount(mapname)) {
> >      >      >      >
> >      >      >      >                   condlog(2, "%s: map in use",
> mapname);
> >      >      >      >
> >      >      >      >                   return 1;
> >      >      >      >
> >      >      >      >           }
> >      >      >      >
> >      >      >      >           r = dm_simplecmd(DM_DEVICE_REMOVE,
> mapname);
> >      >      >      >
> >      >      >      >           if (r) {
> >      >      >      >
> >      >      >      >                   condlog(4, "multipath map %s
> removed",
> >      >      mapname);
> >      >      >      >
> >      >      >      >
> return
> >      0;
> >      >      >      >
> >      >      >      >                                           }
> >      >      >      >
> >      >      >      >
> >      >      >      >
> >      >      >      >
> orphan_paths(vecs->pathvec,
> >      mpp);
> >      >      >      >
> >      >      >      >                            remove_map(mpp, vecs,
> >      >      stop_waiter_thread,
> >      >      >      1);
> >      >      >      >
> >      >      >      >    Is removing this below line, the right step to
> stop
> >      removing
> >      >      the
> >      >      >      device ?
> >      >      >      >    r = dm_simplecmd(DM_DEVICE_REMOVE, mapname);
> >      >      >      >
> >      >      >      >    Regards,
> >      >      >      >
> >      >      >      >    Tejaswini
> >      >      >      >
> >      >      >      >    On Mon, Jun 8, 2015 at 11:15 AM, Tejaswini Poluri
> >      >      >      >    <[1][2][3][4]tejaswinipoluri3@gmail.com> wrote:
> >      >      >      >
> >      >      >      >      Thanks a lot Ben for the quick and detailed
> reply.
> >      I have
> >      >      been
> >      >      >      >      struggling to understand and conclude the
> issues
> >      with
> >      >      multipath
> >      >      >      as I am
> >      >      >      >      the only one working from my team. Your inputs
> help
> >      me a
> >      >      lot.
> >      >      >      Thanks
> >      >      >      >      again.
> >      >      >      >      Regards,
> >      >      >      >      Tejaswini
> >      >      >      >      On Sat, Jun 6, 2015 at 3:36 AM, Benjamin
> Marzinski
> >      >      >      >      <[2][3][4][5]bmarzins@redhat.com> wrote:
> >      >      >      >
> >      >      >      >        On Fri, Jun 05, 2015 at 02:31:20PM +0530,
> >      Tejaswini
> >      >      Poluri
> >      >      >      wrote:
> >      >      >      >        >    Hii Ben,
> >      >      >      >        >
> >      >      >      >        >    We are testing multipathd tools with
> all the
> >      >      possible
> >      >      >      options and
> >      >      >      >        the
> >      >      >      >        >    following fails.
> >      >      >      >        >
> >      >      >      >        >    Case 1 : remove and add map.
> >      >      >      >        >    root@x86-generic-64:~# multipathd
> -k'show
> >      maps'
> >      >      >      >        >    name    sysfs uuid
> >      >      >      >        >    dmpath0 dm-0  1IET_00010001
> >      >      >      >        >    root@x86-generic-64:~# multipathd
> -k'remove
> >      map
> >      >      dmpath0'
> >      >      >      >        >    ok
> >      >      >      >        >    root@x86-generic-64:~# multipathd
> -k'show
> >      maps'
> >      >      >      >        >    root@x86-generic-64:~# multipathd
> -k'add map
> >      >      dmpath0'
> >      >      >      >        >    ok
> >      >      >      >        >    root@x86-generic-64:~# multipathd
> -k'show
> >      maps'
> >      >      >      >        >    root@x86-generic-64:~#
> >      >      >      >        >    Once a map is removed, we are able to
> add it
> >      only
> >      >      using
> >      >      >      >        #multipath
> >      >      >      >        >    command and not using multipathd tools.
> >      >      >      >
> >      >      >      >        It is working the way it was designed, but
> >      possibly it
> >      >      would
> >      >      >      make
> >      >      >      >        sense
> >      >      >      >        to change the design.  The "remove map"
> command,
> >      not
> >      >      only stops
> >      >      >      >        multipathd from monitoring the multipath
> device,
> >      but it
> >      >      removes
> >      >      >      it
> >      >      >      >        from
> >      >      >      >        the system as well.  The "add map" command
> makes
> >      >      multipath
> >      >      >      monitor an
> >      >      >      >        already existing multipath device that in
> wasn't
> >      >      previously
> >      >      >      >        monitoring.
> >      >      >      >        These commands do this for historical
> reasons.
> >      >      multipathd
> >      >      >      wasn't
> >      >      >      >        originally in charge of creating multipath
> >      devices,
> >      >      multipath
> >      >      >      was.
> >      >      >      >        Once
> >      >      >      >        it had created the device, it ran
> >      >      >      >
> >      >      >      >        multipathd -k"add map <MAP>"
> >      >      >      >
> >      >      >      >        to make multipathd start monitoring it.
> However
> >      things
> >      >      haven't
> >      >      >      worked
> >      >      >      >        this way since RHEL4, so possibly "add map"
> >      should
> >      >      actually
> >      >      >      create the
> >      >      >      >        device if it doesn't currently exist.
> >      >      >      >        >    Case 2 : Active paths  test case
> >      >      >      >        >    # while true ; do sleep 3 ; multipathd
> >      -k'remove
> >      >      path sdb'
> >      >      >      ;
> >      >      >      >        multipathd
> >      >      >      >        >    -k'add path sdb' ; multipathd -k'show
> maps
> >      status'
> >      >      ; done
> >      >      >      >        >    ok
> >      >      >      >        >    ok
> >      >      >      >        >    name failback queueing paths dm-st
> >      >      >      >        >    dmpath0 - - 1 active // It should be 2.
> >      >      >      >
> >      >      >      >        This is simply a timing issue.  What you are
> >      seeing it
> >      >      the
> >      >      >      number of
> >      >      >      >        active paths.  These are paths that the
> kernel
> >      can use.
> >      >      The
> >      >      >      "add path"
> >      >      >      >        command doesn't update the kernel state.
> This
> >      happens
> >      >      later in
> >      >      >      >        response
> >      >      >      >        to the kernel reloading the device table.
> So, in
> >      a
> >      >      second or
> >      >      >      two, this
> >      >      >      >        will say 2, as expected.
> >      >      >      >
> >      >      >      >        >    We would like to know if the test cases
> are
> >      valid
> >      >      and if
> >      >      >      these
> >      >      >      >        are bugs or
> >      >      >      >        >    any design issues.
> >      >      >      >        >
> >      >      >      >        >    Case 3 : Fail path and reinstate path
> >      >      >      >        >    root@x86-generic-64:~# multipathd
> -k"fail
> >      path
> >      >      sdc";
> >      >      >      multipathd
> >      >      >      >        >    -k'reinstate path sdc'; multipathd
> -k"show
> >      paths";
> >      >      >      >        >    >    [ 3962.708523] device-mapper:
> >      multipath:
> >      >      Failing path
> >      >      >      8:32.
> >      >      >      >        >    >    ok
> >      >      >      >        >    >    ok
> >      >      >      >        >    >    hcil    dev dev_t pri dm_st
> chk_st
> >      >      next_check
> >      >      >      >        >    >    4:0:0:1 sdc 8:32  1
> [active][faulty]
> >      >      ..........
> >      >      >      1/20
> >      >      >      >        <==CHECK
> >      >      >      >        >    >    5:0:0:1 sdd 8:48  1
> [active][ready]
> >      >      XX........
> >      >      >      4/20
> >      >      >      >        >    sdc path becomes [active][ready] only
> after
> >      the
> >      >      polling
> >      >      >      interval
> >      >      >      >        but not
> >      >      >      >        >    immediately after the reinstate path
> >      command.
> >      >      >      >        >    You have answered that this is a design
> >      issue. But
> >      >      we have
> >      >      >      heard
> >      >      >      >        from our
> >      >      >      >        >    test team that the same test case works
> in
> >      RHEL6.
> >      >      Did you
> >      >      >      observe
> >      >      >      >        it?
> >      >      >      >        >    I am also finding that the test cases
> fail
> >      because
> >      >      we are
> >      >      >      trying
> >      >      >      >        to do
> >      >      >      >        >    multiple commands at one shot.  Please
> share
> >      your
> >      >      thoughts
> >      >      >      so
> >      >      >      >        that it
> >      >      >      >        >    could help me in debugging the issues
> >      further.
> >      >      >      >        >
> >      >      >      >
> >      >      >      >        It's totally possible that the checker state
> is
> >      >      immediately
> >      >      >      updated in
> >      >      >      >        RHEL6.  Like I said before, what it currently
> >      does,
> >      >      although
> >      >      >      correct,
> >      >      >      >        is confusing, and perhaps we need a different
> >      checker
> >      >      state for
> >      >      >      paths
> >      >      >      >        where the "fail path" command has been used.
> >      >      >      >
> >      >      >      >        -Ben
> >      >      >      >        >    Regards,
> >      >      >      >        >    Tejaswini
> >      >      >      >        >    On Tue, May 19, 2015 at 5:37 PM,
> Tejaswini
> >      Poluri
> >      >      >      >        >    <[1][3][4][5][6]
> tejaswinipoluri3@gmail.com>
> >      wrote:
> >      >      >      >        >
> >      >      >      >        >      Thanks a lot Ben. I will look into it
> >      more.
> >      >      >      >        >      On Mon, May 18, 2015 at 9:57 PM,
> Benjamin
> >      >      Marzinski
> >      >      >      >        >      <[2][4][5][6][7]bmarzins@redhat.com>
> >      wrote:
> >      >      >      >        >
> >      >      >      >        >        On Mon, May 18, 2015 at 02:09:27PM
> >      +0530,
> >      >      Tejaswini
> >      >      >      Poluri
> >      >      >      >        wrote:
> >      >      >      >        >        >    Hii,
> >      >      >      >        >        >    We are trying to test multipath
> >      setup in
> >      >      our
> >      >      >      target and
> >      >      >      >        tried the
> >      >      >      >        >        various
> >      >      >      >        >        >    commands of multipathd demaon
> and
> >      we find
> >      >      the
> >      >      >      following
> >      >      >      >        error:
> >      >      >      >        >        >    root@x86-generic-64:~#
> multipathd
> >      -k"fail
> >      >      path
> >      >      >      sdc";
> >      >      >      >        multipathd
> >      >      >      >        >        >    -k'reinstate path
> >      >      >      >        >        >    sdc'; multipathd -k"show
> paths";
> >      >      >      >        >        >    [ 3962.708523] device-mapper:
> >      multipath:
> >      >      Failing
> >      >      >      >        path 8:32.
> >      >      >      >        >        >    ok
> >      >      >      >        >        >    ok
> >      >      >      >        >        >    hcil    dev dev_t pri dm_st
> >       chk_st
> >      >       next_check
> >      >      >      >        >        >    4:0:0:1 sdc 8:32  1
> >       [active][faulty]
> >      >      ..........
> >      >      >      1/20
> >      >      >      >          <<<===
> >      >      >      >        >        CHECK
> >      >      >      >        >        >    5:0:0:1 sdd 8:48  1
> >       [active][ready]
> >      >      XX........
> >      >      >      4/20
> >      >      >      >        >        >    sdc path becomes
> [active][ready]
> >      only
> >      >      after the
> >      >      >      polling
> >      >      >      >        interval
> >      >      >      >        >        but not
> >      >      >      >        >        >    immediately after the reinstate
> >      path
> >      >      command.
> >      >      >      >        >        >    I am observing this in latest
> >      multipath
> >      >      tools in
> >      >      >      ubuntu
> >      >      >      >        machine
> >      >      >      >        >        as well.
> >      >      >      >        >        >    Please let me know if its a
> known
> >      issue or
> >      >      if I
> >      >      >      am doing
> >      >      >      >        >        something wrong.
> >      >      >      >        >        >    Regards.
> >      >      >      >        >        >    Tejaswini
> >      >      >      >        >
> >      >      >      >        >        the reinstate command is supposed to
> >      reinstate
> >      >      the
> >      >      >      device
> >      >      >      >        with the
> >      >      >      >        >        kernel, and it does that. The
> checker
> >      state
> >      >      doesn't
> >      >      >      change
> >      >      >      >        until the
> >      >      >      >        >        next time that the path is
> checked.  I
> >      agree
> >      >      that it's
> >      >      >      odd
> >      >      >      >        that the
> >      >      >      >        >        check state switches to faulty as
> soon
> >      as you
> >      >      fail the
> >      >      >      path,
> >      >      >      >        but it
> >      >      >      >        >        doesn't switch back until the next
> check
> >      after
> >      >      you
> >      >      >      reinistate
> >      >      >      >        it.
> >      >      >      >        >
> >      >      >      >        >        The issue is that multipathd needs
> to
> >      override
> >      >      the
> >      >      >      checker
> >      >      >      >        output,
> >      >      >      >        >        so that a failed path won't be
> >      immeditately
> >      >      >      reinstated.  Once
> >      >      >      >        the
> >      >      >      >        >        path comes back, multipathd wants to
> >      record the
> >      >      switch
> >      >      >      in the
> >      >      >      >        checker
> >      >      >      >        >        thread, so that it can refresh path
> >      information
> >      >      what
> >      >      >      wasn't
> >      >      >      >        >        automatically done when the path was
> >      >      reinstated.
> >      >      >      However, it
> >      >      >      >        may make
> >      >      >      >        >        more sense to have a different
> checker
> >      state
> >      >      for when
> >      >      >      the
> >      >      >      >        device is
> >      >      >      >        >        in the failed state, so that it's
> >      obvious that
> >      >      the
> >      >      >      checker
> >      >      >      >        state is
> >      >      >      >        >        being overruled.
> >      >      >      >        >
> >      >      >      >        >        -Ben
> >      >      >      >        >
> >      >      >      >        >        > --
> >      >      >      >        >        > dm-devel mailing list
> >      >      >      >        >        > [3][5][6][7][8]
> dm-devel@redhat.com
> >      >      >      >        >        >
> >      >      >
> >      [4][6][7][8][9]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >        >
> >      >      >      >        >        --
> >      >      >      >        >        dm-devel mailing list
> >      >      >      >        >        [5][7][8][9][10]dm-devel@redhat.com
> >      >      >      >        >
> >      >      >
> >      [6][8][9][10][11]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >        >
> >      >      >      >        > References
> >      >      >      >        >
> >      >      >      >        >    Visible links
> >      >      >      >        >    1.
> >      mailto:[9][10][11][12]tejaswinipoluri3@gmail.com
> >      >      >      >        >    2.
> >      mailto:[10][11][12][13]bmarzins@redhat.com
> >      >      >      >        >    3.
> >      mailto:[11][12][13][14]dm-devel@redhat.com
> >      >      >      >        >    4.
> >      >      >
> >      [12][13][14][15]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >        >    5.
> >      mailto:[13][14][15][16]dm-devel@redhat.com
> >      >      >      >        >    6.
> >      >      >
> >      [14][15][16][17]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >
> >      >      >      > References
> >      >      >      >
> >      >      >      >    Visible links
> >      >      >      >    1. mailto:[16][17][18]tejaswinipoluri3@gmail.com
> >      >      >      >    2. mailto:[17][18][19]bmarzins@redhat.com
> >      >      >      >    3. mailto:[18][19][20]tejaswinipoluri3@gmail.com
> >      >      >      >    4. mailto:[19][20][21]bmarzins@redhat.com
> >      >      >      >    5. mailto:[20][21][22]dm-devel@redhat.com
> >      >      >      >    6.
> >      [21][22][23]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >    7. mailto:[22][23][24]dm-devel@redhat.com
> >      >      >      >    8.
> >      [23][24][25]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >    9. mailto:[24][25][26]tejaswinipoluri3@gmail.com
> >      >      >      >   10. mailto:[25][26][27]bmarzins@redhat.com
> >      >      >      >   11. mailto:[26][27][28]dm-devel@redhat.com
> >      >      >      >   12.
> >      [27][28][29]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >   13. mailto:[28][29][30]dm-devel@redhat.com
> >      >      >      >   14.
> >      [29][30][31]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >
> >      >      > References
> >      >      >
> >      >      >    Visible links
> >      >      >    1. mailto:[31][32]bmarzins@redhat.com
> >      >      >    2. mailto:[32][33]tejaswinipoluri3@gmail.com
> >      >      >    3. mailto:[33][34]bmarzins@redhat.com
> >      >      >    4. mailto:[34][35]tejaswinipoluri3@gmail.com
> >      >      >    5. mailto:[35][36]bmarzins@redhat.com
> >      >      >    6. mailto:[36][37]dm-devel@redhat.com
> >      >      >    7. [37][38]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >    8. mailto:[38][39]dm-devel@redhat.com
> >      >      >    9. [39][40]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   10. mailto:[40][41]tejaswinipoluri3@gmail.com
> >      >      >   11. mailto:[41][42]bmarzins@redhat.com
> >      >      >   12. mailto:[42][43]dm-devel@redhat.com
> >      >      >   13. [43][44]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   14. mailto:[44][45]dm-devel@redhat.com
> >      >      >   15. [45][46]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   16. mailto:[46][47]tejaswinipoluri3@gmail.com
> >      >      >   17. mailto:[47][48]bmarzins@redhat.com
> >      >      >   18. mailto:[48][49]tejaswinipoluri3@gmail.com
> >      >      >   19. mailto:[49][50]bmarzins@redhat.com
> >      >      >   20. mailto:[50][51]dm-devel@redhat.com
> >      >      >   21. [51][52]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   22. mailto:[52][53]dm-devel@redhat.com
> >      >      >   23. [53][54]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   24. mailto:[54][55]tejaswinipoluri3@gmail.com
> >      >      >   25. mailto:[55][56]bmarzins@redhat.com
> >      >      >   26. mailto:[56][57]dm-devel@redhat.com
> >      >      >   27. [57][58]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   28. mailto:[58][59]dm-devel@redhat.com
> >      >      >   29. [59][60]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >
> >      > References
> >      >
> >      >    Visible links
> >      >    1. mailto:[61]bmarzins@redhat.com
> >      >    2. mailto:[62]bmarzins@redhat.com
> >      >    3. mailto:[63]tejaswinipoluri3@gmail.com
> >      >    4. mailto:[64]bmarzins@redhat.com
> >      >    5. mailto:[65]tejaswinipoluri3@gmail.com
> >      >    6. mailto:[66]bmarzins@redhat.com
> >      >    7. mailto:[67]dm-devel@redhat.com
> >      >    8. [68]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >    9. mailto:[69]dm-devel@redhat.com
> >      >   10. [70]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   11. mailto:[71]tejaswinipoluri3@gmail.com
> >      >   12. mailto:[72]bmarzins@redhat.com
> >      >   13. mailto:[73]dm-devel@redhat.com
> >      >   14. [74]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   15. mailto:[75]dm-devel@redhat.com
> >      >   16. [76]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   17. mailto:[77]tejaswinipoluri3@gmail.com
> >      >   18. mailto:[78]bmarzins@redhat.com
> >      >   19. mailto:[79]tejaswinipoluri3@gmail.com
> >      >   20. mailto:[80]bmarzins@redhat.com
> >      >   21. mailto:[81]dm-devel@redhat.com
> >      >   22. [82]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   23. mailto:[83]dm-devel@redhat.com
> >      >   24. [84]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   25. mailto:[85]tejaswinipoluri3@gmail.com
> >      >   26. mailto:[86]bmarzins@redhat.com
> >      >   27. mailto:[87]dm-devel@redhat.com
> >      >   28. [88]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   29. mailto:[89]dm-devel@redhat.com
> >      >   30. [90]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   31. mailto:[91]bmarzins@redhat.com
> >      >   32. mailto:[92]tejaswinipoluri3@gmail.com
> >      >   33. mailto:[93]bmarzins@redhat.com
> >      >   34. mailto:[94]tejaswinipoluri3@gmail.com
> >      >   35. mailto:[95]bmarzins@redhat.com
> >      >   36. mailto:[96]dm-devel@redhat.com
> >      >   37. [97]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   38. mailto:[98]dm-devel@redhat.com
> >      >   39. [99]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   40. mailto:[100]tejaswinipoluri3@gmail.com
> >      >   41. mailto:[101]bmarzins@redhat.com
> >      >   42. mailto:[102]dm-devel@redhat.com
> >      >   43. [103]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   44. mailto:[104]dm-devel@redhat.com
> >      >   45. [105]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   46. mailto:[106]tejaswinipoluri3@gmail.com
> >      >   47. mailto:[107]bmarzins@redhat.com
> >      >   48. mailto:[108]tejaswinipoluri3@gmail.com
> >      >   49. mailto:[109]bmarzins@redhat.com
> >      >   50. mailto:[110]dm-devel@redhat.com
> >      >   51. [111]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   52. mailto:[112]dm-devel@redhat.com
> >      >   53. [113]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   54. mailto:[114]tejaswinipoluri3@gmail.com
> >      >   55. mailto:[115]bmarzins@redhat.com
> >      >   56. mailto:[116]dm-devel@redhat.com
> >      >   57. [117]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   58. mailto:[118]dm-devel@redhat.com
> >      >   59. [119]https://www.redhat.com/mailman/listinfo/dm-devel
> >
> > References
> >
> >    Visible links
> >    1. mailto:bmarzins@redhat.com
> >    2. mailto:bmarzins@redhat.com
> >    3. mailto:bmarzins@redhat.com
> >    4. mailto:tejaswinipoluri3@gmail.com
> >    5. mailto:bmarzins@redhat.com
> >    6. mailto:tejaswinipoluri3@gmail.com
> >    7. mailto:bmarzins@redhat.com
> >    8. mailto:dm-devel@redhat.com
> >    9. https://www.redhat.com/mailman/listinfo/dm-devel
> >   10. mailto:dm-devel@redhat.com
> >   11. https://www.redhat.com/mailman/listinfo/dm-devel
> >   12. mailto:tejaswinipoluri3@gmail.com
> >   13. mailto:bmarzins@redhat.com
> >   14. mailto:dm-devel@redhat.com
> >   15. https://www.redhat.com/mailman/listinfo/dm-devel
> >   16. mailto:dm-devel@redhat.com
> >   17. https://www.redhat.com/mailman/listinfo/dm-devel
> >   18. mailto:tejaswinipoluri3@gmail.com
> >   19. mailto:bmarzins@redhat.com
> >   20. mailto:tejaswinipoluri3@gmail.com
> >   21. mailto:bmarzins@redhat.com
> >   22. mailto:dm-devel@redhat.com
> >   23. https://www.redhat.com/mailman/listinfo/dm-devel
> >   24. mailto:dm-devel@redhat.com
> >   25. https://www.redhat.com/mailman/listinfo/dm-devel
> >   26. mailto:tejaswinipoluri3@gmail.com
> >   27. mailto:bmarzins@redhat.com
> >   28. mailto:dm-devel@redhat.com
> >   29. https://www.redhat.com/mailman/listinfo/dm-devel
> >   30. mailto:dm-devel@redhat.com
> >   31. https://www.redhat.com/mailman/listinfo/dm-devel
> >   32. mailto:bmarzins@redhat.com
> >   33. mailto:tejaswinipoluri3@gmail.com
> >   34. mailto:bmarzins@redhat.com
> >   35. mailto:tejaswinipoluri3@gmail.com
> >   36. mailto:bmarzins@redhat.com
> >   37. mailto:dm-devel@redhat.com
> >   38. https://www.redhat.com/mailman/listinfo/dm-devel
> >   39. mailto:dm-devel@redhat.com
> >   40. https://www.redhat.com/mailman/listinfo/dm-devel
> >   41. mailto:tejaswinipoluri3@gmail.com
> >   42. mailto:bmarzins@redhat.com
> >   43. mailto:dm-devel@redhat.com
> >   44. https://www.redhat.com/mailman/listinfo/dm-devel
> >   45. mailto:dm-devel@redhat.com
> >   46. https://www.redhat.com/mailman/listinfo/dm-devel
> >   47. mailto:tejaswinipoluri3@gmail.com
> >   48. mailto:bmarzins@redhat.com
> >   49. mailto:tejaswinipoluri3@gmail.com
> >   50. mailto:bmarzins@redhat.com
> >   51. mailto:dm-devel@redhat.com
> >   52. https://www.redhat.com/mailman/listinfo/dm-devel
> >   53. mailto:dm-devel@redhat.com
> >   54. https://www.redhat.com/mailman/listinfo/dm-devel
> >   55. mailto:tejaswinipoluri3@gmail.com
> >   56. mailto:bmarzins@redhat.com
> >   57. mailto:dm-devel@redhat.com
> >   58. https://www.redhat.com/mailman/listinfo/dm-devel
> >   59. mailto:dm-devel@redhat.com
> >   60. https://www.redhat.com/mailman/listinfo/dm-devel
> >   61. mailto:bmarzins@redhat.com
> >   62. mailto:bmarzins@redhat.com
> >   63. mailto:tejaswinipoluri3@gmail.com
> >   64. mailto:bmarzins@redhat.com
> >   65. mailto:tejaswinipoluri3@gmail.com
> >   66. mailto:bmarzins@redhat.com
> >   67. mailto:dm-devel@redhat.com
> >   68. https://www.redhat.com/mailman/listinfo/dm-devel
> >   69. mailto:dm-devel@redhat.com
> >   70. https://www.redhat.com/mailman/listinfo/dm-devel
> >   71. mailto:tejaswinipoluri3@gmail.com
> >   72. mailto:bmarzins@redhat.com
> >   73. mailto:dm-devel@redhat.com
> >   74. https://www.redhat.com/mailman/listinfo/dm-devel
> >   75. mailto:dm-devel@redhat.com
> >   76. https://www.redhat.com/mailman/listinfo/dm-devel
> >   77. mailto:tejaswinipoluri3@gmail.com
> >   78. mailto:bmarzins@redhat.com
> >   79. mailto:tejaswinipoluri3@gmail.com
> >   80. mailto:bmarzins@redhat.com
> >   81. mailto:dm-devel@redhat.com
> >   82. https://www.redhat.com/mailman/listinfo/dm-devel
> >   83. mailto:dm-devel@redhat.com
> >   84. https://www.redhat.com/mailman/listinfo/dm-devel
> >   85. mailto:tejaswinipoluri3@gmail.com
> >   86. mailto:bmarzins@redhat.com
> >   87. mailto:dm-devel@redhat.com
> >   88. https://www.redhat.com/mailman/listinfo/dm-devel
> >   89. mailto:dm-devel@redhat.com
> >   90. https://www.redhat.com/mailman/listinfo/dm-devel
> >   91. mailto:bmarzins@redhat.com
> >   92. mailto:tejaswinipoluri3@gmail.com
> >   93. mailto:bmarzins@redhat.com
> >   94. mailto:tejaswinipoluri3@gmail.com
> >   95. mailto:bmarzins@redhat.com
> >   96. mailto:dm-devel@redhat.com
> >   97. https://www.redhat.com/mailman/listinfo/dm-devel
> >   98. mailto:dm-devel@redhat.com
> >   99. https://www.redhat.com/mailman/listinfo/dm-devel
> >  100. mailto:tejaswinipoluri3@gmail.com
> >  101. mailto:bmarzins@redhat.com
> >  102. mailto:dm-devel@redhat.com
> >  103. https://www.redhat.com/mailman/listinfo/dm-devel
> >  104. mailto:dm-devel@redhat.com
> >  105. https://www.redhat.com/mailman/listinfo/dm-devel
> >  106. mailto:tejaswinipoluri3@gmail.com
> >  107. mailto:bmarzins@redhat.com
> >  108. mailto:tejaswinipoluri3@gmail.com
> >  109. mailto:bmarzins@redhat.com
> >  110. mailto:dm-devel@redhat.com
> >  111. https://www.redhat.com/mailman/listinfo/dm-devel
> >  112. mailto:dm-devel@redhat.com
> >  113. https://www.redhat.com/mailman/listinfo/dm-devel
> >  114. mailto:tejaswinipoluri3@gmail.com
> >  115. mailto:bmarzins@redhat.com
> >  116. mailto:dm-devel@redhat.com
> >  117. https://www.redhat.com/mailman/listinfo/dm-devel
> >  118. mailto:dm-devel@redhat.com
> >  119. https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a1140fee6fb09af051a5be5d2
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+PGRpdj5UaGFua3MgYSBsb3QuwqA8L2Rpdj5DYW4geW91IGd1aWRlIG1l
IGhvdyB0byBwdXNoIHVwc3RyZWFtIGZvciB0aGUgYXBwcm92YWwuIFdoaWNoIGJyYW5jaCBzaG91
bGQgSSBwdXNoIHRvPyBBbnkgbGlzdCBvZiB0ZXN0Y2FzZXMgSSBzaG91bGQgcGVyZm9ybSBiZWZv
cmUgSSBjb3VsZCBwdXNoPzxkaXY+PGJyPjwvZGl2PjxkaXY+SSBoYXZlIGNyZWF0ZWQgdGhlIGZv
bGxvd2luZyB0d28gcGF0Y2hlcy4gUEZBwqA8L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PlJlZ2Fy
ZHMsPC9kaXY+PGRpdj5UZWphc3dpbmk8L2Rpdj48L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9leHRy
YSI+PGJyPjxkaXYgY2xhc3M9ImdtYWlsX3F1b3RlIj5PbiBNb24sIEp1bCA2LCAyMDE1IGF0IDEx
OjE1IFBNLCBCZW5qYW1pbiBNYXJ6aW5za2kgPHNwYW4gZGlyPSJsdHIiPiZsdDs8YSBocmVmPSJt
YWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSIgdGFyZ2V0PSJfYmxhbmsiPmJtYXJ6aW5zQHJlZGhh
dC5jb208L2E+Jmd0Ozwvc3Bhbj4gd3JvdGU6PGJyPjxibG9ja3F1b3RlIGNsYXNzPSJnbWFpbF9x
dW90ZSIgc3R5bGU9Im1hcmdpbjowIDAgMCAuOGV4O2JvcmRlci1sZWZ0OjFweCAjY2NjIHNvbGlk
O3BhZGRpbmctbGVmdDoxZXgiPjxzcGFuIGNsYXNzPSIiPk9uIFR1ZSwgSnVuIDMwLCAyMDE1IGF0
IDExOjIyOjM3QU0gKzA1MzAsIFRlamFzd2luaSBQb2x1cmkgd3JvdGU6PGJyPg0KJmd0O8KgIMKg
IFRoYW5rcyBCZW4uIFNvIHNob3VsZCBJIHB1c2ggdGhlIGNvZGUgdG8gdGhlIHVwc3RyZWFtIGFu
ZCBnZXQgYW4gYXBwcm92YWw/PGJyPg0KJmd0O8KgIMKgIFJlZ2FyZHMsPGJyPg0KPGJyPg0KPC9z
cGFuPlllcy4gVGhhbmtzITxicj4NCjxicj4NCi1CZW48YnI+DQo8c3BhbiBjbGFzcz0iIj48YnI+
DQomZ3Q7wqAgwqAgVGVqYXN3aW5pPGJyPg0KJmd0O8KgIMKgIE9uIFR1ZSwgSnVuIDMwLCAyMDE1
IGF0IDEyOjUwIEFNLCBCZW5qYW1pbiBNYXJ6aW5za2k8YnI+DQo8L3NwYW4+PGRpdj48ZGl2IGNs
YXNzPSJoNSI+Jmd0O8KgIMKgICZsdDtbMV08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0
LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT4mZ3Q7IHdyb3RlOjxicj4NCiZndDs8YnI+DQom
Z3Q7wqAgwqAgwqAgT24gRnJpLCBKdW4gMjYsIDIwMTUgYXQgMTI6MjE6NDhQTSArMDUzMCwgVGVq
YXN3aW5pIFBvbHVyaSB3cm90ZTo8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIFllcyBJIGFn
cmVlIHRoYXQgaGF2aW5nIHRoZSBzYW1lIGNvZGUgaW4gYm90aCBjbGlfYWRkX21hcCgpIGFuZDxi
cj4NCiZndDvCoCDCoCDCoCBldl9hZGRfbWFwPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCBp
cyBub3QgbmVjZXNzYXJ5LiBIZW5jZSBJIHdvdWxkIHN1Z2dlc3QgcmVtb3ZpbmcgZ2V0X3JlZnd3
aWQoKSBjb2RlPGJyPg0KJmd0O8KgIMKgIMKgIGZyb208YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIGV2X2FkZF9tYXAgYXMgaXQgaXMgbm90IGJlaW5nIHVzZWQgYnkgYW55b25lLjxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCBldl9hZGRfbWFwKHBh
cmFtLCBOVUxMLCB2ZWNzKSB3b3VsZCBjcmVhdGUgdGhlIG11bHRpcGF0aCBkZXZpY2UgYnk8YnI+
DQomZ3Q7wqAgwqAgwqAgdXNpbmc8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIHRoZSBnZXRf
cmVmd3dpZCgpIGNvZGUgYW5kIGJ1dCBhbGwgdGhlIGZ1bmN0aW9ucyBhYm92ZSBpdCBsaWtlPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCAoZG1fZ2V0X21pbm9yLCBkbV9nZXRfbWFqb3IgYW5k
IGRtX21hcG5hbWUpIHdvdWxkIGZhaWwgYW5kIGl0PGJyPg0KJmd0O8KgIMKgIMKgIHdvdWxkbiYj
Mzk7dDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgZW50ZXIgYW55IG9mIHRoZSBvdGhlciBj
b2RlIGluIGV2X2FkZF9tYXAgbGlrZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgMS5kbV9t
YXBfcHJlc2VudCw8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDIuYWRkX21hcF93aXRob3V0
X3BhdGg8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDMuIHN5bmNfbWFwX3N0YXRlPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCB3aGljaCBhcmUgcmVzcG9uc2libGUgZm9yIHJlZ2lzdGVy
aW5nIHRoZSBtYXAgYW5kIGRpc3BsYXlpbmcgaXQuPGJyPg0KJmd0O8KgIMKgIMKgICZndDs8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIFNvLCBJIHRoaW5rIG1vdmluZyB0aGUgYmVsb3cgY29k
ZSBmcm9tIGV2X2FkZF9tYXAgdG8gY2xpX2FkZF9tYXA8YnI+DQomZ3Q7wqAgwqAgwqAgc2hvdWxk
IGJlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCBhIGdvb2QgaWRlYSByaWdodC48YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgciA9IGdldF9yZWZ3
d2lkKGRldiwgREVWX0RFVk1BUCwgdmVjcy0mZ3Q7cGF0aHZlYywmYW1wO3JlZnd3aWQpOzxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
Jmd0O8KgIMKgIMKgwqDCoMKgwqDCoMKgIGlmIChyZWZ3d2lkKSB7PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCAmZ3Q7wqAgwqAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHIgPSBj
b2FsZXNjZV9wYXRocyh2ZWNzLCBOVUxMLCByZWZ3d2lkLDApOzxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkbV9saWJf
cmVsZWFzZSgpOzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKg
wqDCoMKgIH08YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIFdoYXQgZG8gdSB0aGluaz88YnI+
DQomZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgIEkgYWdyZWUuIFdlIGFyZW4mIzM5O3QgdXNpbmcgdGhl
IGNvZGUgaW4gZXZfYWRkX21hcCwgc28gaXQmIzM5O3MgcHJlc2VuY2UgdGhlcmU8YnI+DQomZ3Q7
wqAgwqAgwqAgaXMgc2ltcGx5IGNvbmZ1c2luZy48YnI+DQomZ3Q7PGJyPg0KJmd0O8KgIMKgIMKg
IC1CZW48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
UmVnYXJkcyw8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIFRlamFzd2luaTxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgT24gRnJpLCBKdW4gMjYsIDIwMTUgYXQgNDozMiBBTSwgQmVuamFt
aW4gTWFyemluc2tpPGJyPg0KPC9kaXY+PC9kaXY+PGRpdj48ZGl2IGNsYXNzPSJoNSI+Jmd0O8Kg
IMKgIMKgICZndDvCoCDCoCAmbHQ7WzFdWzJdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhh
dC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+Jmd0OyB3cm90ZTo8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgT24gVHVlLCBKdW4gMjMsIDIw
MTUgYXQgMDM6NDg6MjZQTSArMDUzMCwgVGVqYXN3aW5pIFBvbHVyaSB3cm90ZTo8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBIaSBCZW4sPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgVGhpcyBpcyByZWdhcmRpbmcgdGhlIGFkZCBtYXAgaXNzdWUgSSBoYXZlIGJlZW4gZGlzY3Vz
c2luZy48YnI+DQomZ3Q7wqAgwqAgwqAgUG9zdGluZzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgdGhlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgaXNzdWUg
YWdhaW4gdG8gcmVtaW5kLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIENhc2UgMSA6IHJlbW92ZSBhbmQg
YWRkIG1hcC48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCByb290QHg4
Ni1nZW5lcmljLTY0On4jIG11bHRpcGF0aGQgLWsmIzM5O3Nob3cgbWFwcyYjMzk7PGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgbmFtZcKgwqDCoCBzeXNmcyB1dWlkPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgZG1wYXRoMCBkbS0wwqAgMUlF
VF8wMDAxMDAwMTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIHJvb3RA
eDg2LWdlbmVyaWMtNjQ6fiMgbXVsdGlwYXRoZCAtayYjMzk7cmVtb3ZlIG1hcCBkbXBhdGgwJiMz
OTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBvazxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIHJvb3RAeDg2LWdlbmVyaWMtNjQ6fiMgbXVs
dGlwYXRoZCAtayYjMzk7c2hvdyBtYXBzJiMzOTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCByb290QHg4Ni1nZW5lcmljLTY0On4jIG11bHRpcGF0aGQgLWsmIzM5O2Fk
ZCBtYXAgZG1wYXRoMCYjMzk7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgb2s8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCByb290QHg4Ni1n
ZW5lcmljLTY0On4jIG11bHRpcGF0aGQgLWsmIzM5O3Nob3cgbWFwcyYjMzk7PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgcm9vdEB4ODYtZ2VuZXJpYy02NDp+Izxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIE9uY2UgYSBtYXAgaXMgcmVtb3Zl
ZCwgd2UgYXJlIGFibGUgdG8gYWRkIGl0IG9ubHkgdXNpbmc8YnI+DQomZ3Q7wqAgwqAgwqAgI211
bHRpcGF0aMKgPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgY29tbWFu
ZCBhbmQgbm90IHVzaW5nIG11bHRpcGF0aGQgdG9vbHMuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgSSBo
YXZlIGZpeGVkIHRoZSBwcm9ibGVtIHdpdGggdHdvIGFwcHJvYWNoZXMuIEkgd291bGQgbGlrZTxi
cj4NCiZndDvCoCDCoCDCoCB5b3UgdG88YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHJl
dmlldzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIHRoZSBzYW1lLjxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIFBhdGNoMSA6IEJ5IG1ha2lu
ZyAmIzM5O3JlbW92ZSBtYXAgZG1wYXRoMCYjMzk7IHRvIHJlbW92ZSBvbmx5IHRoZTxicj4NCiZn
dDvCoCDCoCDCoCBtYXAgYW5kPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBub3QgdGhl
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgZGV2aWNlLiBJIGhhdmUg
YWRkZWQgZXh0cmEgZnVuY3Rpb25zIGRpc2NhcmRfbWFwIGFuZDxicj4NCiZndDvCoCDCoCDCoCBk
bV9yZW1vdmVfbWFwPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBzbyBhczxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIHRvIG5vdCBpbnRlcmZlcmUgd2l0aCB0
aGUgZXhpc3RpbmcgY29kZS48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBQYXRjaCAyOiBUaGUgYXBwcm9h
Y2ggeW91IGhhdmUgc3VnZ2VzdGVkLkJ5IGdldHRpbmcgd3dpZDxicj4NCiZndDvCoCDCoCDCoCBm
cm9tIHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgbWFwbmFtZTxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIGFuZCBkb2luZyBjb2FsZXNjZV9wYXRocy4g
SSBoYXZlIGp1c3QgbW92ZWQgdGhlIGZvbGxvd2luZzxicj4NCiZndDvCoCDCoCDCoCBjb2RlIGlu
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgZXZfYWRkX21hcCB0byBj
bGlfYWRkX21hcC48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgVGhpcyBpcyB0aGUgZ2VuZXJhbCBpZGVhIHdlJiMzOTtkIGxpa2UgdG8gZ28gd2l0
aC7CoCBIb3dldmVyLCBsb29raW5nPGJyPg0KJmd0O8KgIMKgIMKgIGF0IHRoZTxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgbGF0ZXN0IHVwc3RyZWFtIGNvZGUsIEkgZG9uJiMzOTt0IHRo
aW5rIHlvdSBzaG91bGQgcHVsbCBjb2RlIGluIGZyb208YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgIGV2X2FkZF9tYXAoKSB0byBjbGlfYWRkX21hcCgpIGxpa2UgeW91ciBwYXRjaCBkb2Vz
LiBjbGlfYWRkX21hcCgpPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBhbHJlYWR5IGNh
bGxzIGV2X2FkZF9tYXAoKSwgYW5kIGV2X2FkZF9tYXAoKSBpcyBjZXJ0YWlubHkgYWJsZSB0bzxi
cj4NCiZndDvCoCDCoCDCoCBhZGQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHRoZSBt
YXAgaWYgaXQgZG9lc24mIzM5O3QgYWxyZWFkeSBleGlzdC48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgWW91IHdvdWxkIGp1c3QgbmVlZCB0byBj
YWxsIGl0IHdpdGg8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgZXZfYWRkX21hcChwYXJhbSwgTlVMTCwgdmVjcyk7PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGFuZCBldl9hZGRfbWFwKCkgd2ls
bCBoYXBwaWx5IGNyZWF0ZSB5b3UgYSBuZXcgbXVsdGlwYXRoIGRldmljZS7CoDxicj4NCiZndDvC
oCDCoCDCoCBBbGw8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHlvdSBuZWVkIHRvIGRv
IGlzIG1ha2Ugc3VyZSB0aGF0IGFsbCB0aGUgZnVuY3Rpb25zIHRoYXQ8YnI+DQomZ3Q7wqAgwqAg
wqAgZXZfYWRkX21hcCgpPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBjYWxscyB3aXRo
IGFsaWFzIGNhbiBhY2NlcHQgYSBOVUxMIHZhbHVlIHRoZXJlLjxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBUaGlzIG1pZ2h0IG5vdCBiZSB0aGUg
YmVzdCB3YXkgdG8gZ28gYWJvdXQgdGhpcywgaG93ZXZlci7CoCBJdDxicj4NCiZndDvCoCDCoCDC
oCB0dXJucyBvdXQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHRoYXQgcmlnaHQgbm93
LCBldmVuIHRob3VnaCBldl9hZGRfbWFwKCkgdGVjaG5pY2FsbHkgaGFzIHRoZTxicj4NCiZndDvC
oCDCoCDCoCBhYmlsaXR5IHRvPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBjcmVhdGUg
bmV3IG1hcHMsIG5vdGhpbmcgY3VycmVudGx5IHVzZXMgaXQsIGFuZCBpdCByZWFsbHkgZG9lc24m
IzM5O3Q8YnI+DQomZ3Q7wqAgwqAgwqAgbWFrZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgc2Vuc2UgZm9yIGl0IHRvIGJlIHRoZXJlLiBJbnN0ZWFkIG9mIGp1c3QgY29weWluZyB0aGF0
IGNvZGUsIHlvdTxicj4NCiZndDvCoCDCoCDCoCBjb3VsZDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgcHVsbCB0aGUgbWFwIGNyZWF0aW9uIGNvZGUgb3V0IG9mIGV2X2FkZF9tYXAoKSBh
bmQgYWRkIGl0IHRvPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBjbGlfYWRkX21hcCgp
LCBmb3IgdGhvc2Ugc2l0dWF0aW9ucyB3aGVyZSB0aGUgcmVxdWVzdGVkIGRldmljZTxicj4NCiZn
dDvCoCDCoCDCoCBkb2VzbiYjMzk7dDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgYWxy
ZWFkeSBleGlzdC48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgQnV0IGhhdmluZyB0aGUgY29kZSBpbiBib3RoIGNsaV9hZGRfbWFwKCkgYW5kIGV2
X2FkZF9tYXAoKSB3aGVuPGJyPg0KJmd0O8KgIMKgIMKgIG9uZTxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgYWxyZWFkeSBjYWxscyB0aGUgb3RoZXIgZG9lc24mIzM5O3Qgc2VlbSBuZWNl
c3NhcnkuPGJyPg0KJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIC1CZW48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIHIgPSBn
ZXRfcmVmd3dpZChkZXYsIERFVl9ERVZNQVAsIHZlY3MtJmd0O3BhdGh2ZWMsJmFtcDtyZWZ3d2lk
KTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoMKgwqDCoMKgwqDCoCBpZiAocmVmd3dpZCkgezxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCByID0gY29hbGVzY2VfcGF0aHModmVjcywgTlVMTCwgcmVmd3dpZCwwKTs8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgZG1fbGliX3JlbGVhc2UoKTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoMKgwqDCoMKgwqDCoCB9PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgY2hhbmdl
ZCBkZXYgdG8gcGFyYW0uPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgSSBoYXZlIHRlc3RlZCB0aGUgc2Ft
ZSBpbiBhbGwgMyB2ZXJzaW9ucyAtMC40LjgsIDAuNC45IGFuZDxicj4NCiZndDvCoCDCoCDCoCAw
LjUuMC48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIEl0IHdvdWxkPGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgYmUgZ3JlYXQgaWYgeW91IGNhbiByZXZpZXcg
dGhlIHNhbWUgc28gdGhhdCBpdCBkb2VzbiYjMzk7dCBjYXVzZTxicj4NCiZndDvCoCDCoCDCoCBh
bnk8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGV4dHJhPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgc2lkZSBlZmZlY3RzLjxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIEkgZ3Vlc3MgUGF0Y2gyIGlzIHRoZSB3YXkgdSBoYXZlIHN1
Z2dlc3RlZCBtZSBpbiB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAgcHJldmlvdXMgbWFpbC48YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIFBsZWFzZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIHJldmlldyBpdCBhbmQgc2hhcmUgeW91ciB2aWV3cy48YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBSZWdhcmRzLDxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIFRlamFzd2luaTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIE9uIEZyaSwgSnVuIDEyLCAyMDE1IGF0IDI6MjEgQU0sIEJlbmph
bWluIE1hcnppbnNraTxicj4NCjwvZGl2PjwvZGl2PjxkaXY+PGRpdiBjbGFzcz0iaDUiPiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgICZsdDtbMV1bMl1bM108YSBocmVmPSJtYWls
dG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT4mZ3Q7IHdyb3Rl
Ojxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIE9uIFdlZCwgSnVuIDEwLCAyMDE1IGF0IDExOjQ2OjUx
QU0gKzA1MzAsIFRlamFzd2luaSBQb2x1cmk8YnI+DQomZ3Q7wqAgwqAgwqAgd3JvdGU6PGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgICZndDvC
oCDCoCBXZSBhcmUgdGVzdGluZyBtdWx0aXBhdGhkIHRvb2xzIHdpdGggYWxsIHRoZTxicj4NCiZn
dDvCoCDCoCDCoCBwb3NzaWJsZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgb3B0aW9u
czxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGFuZCB0aGU8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgJmd0O8Kg
IMKgIGZvbGxvd2luZyBmYWlscy48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCAmZ3Q7wqAgwqAgQ2FzZSAxIDogcmVtb3ZlIGFuZCBhZGQgbWFw
Ljxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCAm
Z3Q7wqAgwqAgcm9vdEB4ODYtZ2VuZXJpYy02NDp+IyBtdWx0aXBhdGhkIC1rJiMzOTtzaG93IG1h
cHMmIzM5Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCAmZ3Q7wqAgwqAgbmFtZcKgwqDCoCBzeXNmcyB1dWlkPGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgICZndDvCoCDCoCBkbXBhdGgwIGRtLTDC
oCAxSUVUXzAwMDEwMDAxPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgICZndDvCoCDCoCByb290QHg4Ni1nZW5lcmljLTY0On4jIG11bHRpcGF0aGQg
LWsmIzM5O3JlbW92ZSBtYXA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGRtcGF0aDAm
IzM5Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCAmZ3Q7wqAgwqAgb2s8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgJmd0O8KgIMKgIHJvb3RAeDg2LWdlbmVyaWMtNjQ6fiMgbXVsdGlwYXRoZCAt
ayYjMzk7c2hvdyBtYXBzJiMzOTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgJmd0O8KgIMKgIHJvb3RAeDg2LWdlbmVyaWMtNjQ6fiMgbXVsdGlw
YXRoZCAtayYjMzk7YWRkIG1hcDxicj4NCiZndDvCoCDCoCDCoCBkbXBhdGgwJiMzOTs8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgJmd0O8KgIMKg
IG9rPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
ICZndDvCoCDCoCByb290QHg4Ni1nZW5lcmljLTY0On4jIG11bHRpcGF0aGQgLWsmIzM5O3Nob3cg
bWFwcyYjMzk7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgICZndDvCoCDCoCByb290QHg4Ni1nZW5lcmljLTY0On4jPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgICZndDvCoCDCoCBPbmNlIGEgbWFw
IGlzIHJlbW92ZWQsIHdlIGFyZSBhYmxlIHRvIGFkZCBpdDxicj4NCiZndDvCoCDCoCDCoCBvbmx5
IHVzaW5nPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgI211bHRp
cGF0aMKgPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgICZndDvCoCDCoCBjb21tYW5kIGFuZCBub3QgdXNpbmcgbXVsdGlwYXRoZCB0b29scy48YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIEl0IGlzIHdvcmtpbmcg
dGhlIHdheSBpdCB3YXMgZGVzaWduZWQsIGJ1dCBwb3NzaWJseTxicj4NCiZndDvCoCDCoCDCoCBp
dCB3b3VsZDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgbWFrZTxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHNlbnNlPGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIHRvIGNoYW5nZSB0aGUgZGVzaWduLjxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgWW91IGhhdmUgbWVu
dGlvbmVkIHRoYXQgaXQgd291bGQgbWFrZSBzZW5zZSB0byBjaGFuZ2U8YnI+DQomZ3Q7wqAgwqAg
wqAgdGhlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBkZXNpZ24gdG88YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBhZGQ8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgbWFwLiBBcmUgdGhlcmUgcGxhbnMg
dG8gY2hhbmdlIHRoZSBkZXNpZ24gPzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCBJIGFtIHRyeWluZyB0byB1bmRlcnN0YW5kIHRoZSBjb2RlIGZs
b3cgdG8gY2hhbmdlIHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgZGVzaWduLiBD
YW48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB5b3U8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgZ3VpZGUgbWUg
aWYgd2Ugc2hvdWxkIHN0b3AgcmVtb3ZpbmcgdGhlIGRldmljZSBmcm9tPGJyPg0KJmd0O8KgIMKg
IMKgIGluIHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgcmVtb3ZlPGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgbWFwIGNvZGU8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgZmxvdyBvciBzdGFydCBh
ZGRpbmcgdGhlIGRldmljZSBhbmQgdGhlIG1hcCBpbiB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAgYWRk
IG1hcDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgY29kZTxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGZsb3cuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoGhhdmUgdHJpZWQgdG8gdW5kZXJzdGFuZCB0aGUgcmVt
b3ZlIG1hcCBjb2RlIGZsb3cgb2Y8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG11bHRp
cGF0aGQgaW48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAwLjQu
ODxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBj
b2RlLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIEkgdGhpbmsgdGhhdCB3ZSB3YW50IG11bHRpcGF0
aCB0byBhY3R1YWxseSByZW1vdmUgdGhlIG1hcDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgKGluc3RlYWQgb2Y8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCBqdXN0IG5vdCBtb25pdG9yaW5nIGl0KSB3aGVuIHlvdSBjYWxsICZxdW90O3JlbW92ZSBtYXAg
Jmx0O21hcCZndDsmcXVvdDsuPGJyPg0KJmd0O8KgIMKgIMKgIFdlIGp1c3Q8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgIHdhbnQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmcXVvdDthZGQgbWFwICZsdDttYXAmZ3Q7JnF1b3Q7IHRvIHRyeSB0byBjcmVh
dGUgdGhlIG1hcCBpZiBpdCBkb2VzbiYjMzk7dDxicj4NCiZndDvCoCDCoCDCoCBleGlzdC7CoCBU
bzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgZG88YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCB0aGF0LCB5b3Ugd291bGQgbmVlZCB0byBmaXJzdCBmaXJn
dXJlIG91dCB3aGF0IFdXSUQgaXM8YnI+DQomZ3Q7wqAgwqAgwqAgYXNzb2NpYXRlZDxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgd2l0aDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZsdDttYXAmZ3Q7LiBQcmVzdW1hYmx5LCAmbHQ7bWFwJmd0OyBjb3Vs
ZCBlaXRoZXIgYmUgYW4gYWxpYXMsIHd3aWQsPGJyPg0KJmd0O8KgIMKgIMKgIG9yIGV2ZW48YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgIG5hbWUgb2YgYSBwYXRoIGluIHRoZSBtYXAuIE9uY2UgeW91IGZv
dW5kIHRoZSBtYXAsIHlvdTxicj4NCiZndDvCoCDCoCDCoCB3b3VsZCBoYXZlPGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCB0bzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgIGNhbGwgdGhlIGNvZGUgdG8gY3JlYXRlIHRoZSBtYXAuPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgQWxzbywgdG8gYW5zd2VyIHlvdXIgSVJDIHF1ZXN0aW9uLCBubyB0aGUgMC40Ljgg
Y29kZSBpczxicj4NCiZndDvCoCDCoCDCoCBub3Qgc3RpbGw8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgIGJlaW5nPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgZGV2ZWxvcGVkIHVwc3RyZWFtLsKgIEFsbCB1cHN0cmVhbSBwYXRjaGVzIG9ubHkgZ28gYWdh
aW5zdDxicj4NCiZndDvCoCDCoCDCoCB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IGN1cnJlbnQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBoZWFk
LiBUaGVyZSBhcmUgbm8gb3RoZXIgdXBzdHJlYW0gYnJhbmNoZXMuPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgLUJlbjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
ZXZfcmVtb3ZlX21hcCAoY2hhciAqIGRldm5hbWUsIHN0cnVjdCB2ZWN0b3JzICogdmVjcyk8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoMKg
wqDCoCBmbHVzaF9tYXAobXBwLCB2ZWNzKTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgwqDCoMKgwqDCoMKg
wqAgZG1fZmx1c2hfbWFwKG1wcC0mZ3Q7YWxpYXMsPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCBERUZBVUxUX1RBUkdFVCk7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGlmPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAoIWRt
X21hcF9wcmVzZW50KG1hcG5hbWUpKTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoMKgIMKgwqAgwqDCoCByZXR1cm4gMDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoCBpZiAoZG1fdHlwZShtYXBuYW1lLCB0
eXBlKSAmbHQ7PSAwKTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gMTs8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoCBpZiAoZG1fcmVtb3Zl
X3BhcnRtYXBzKG1hcG5hbWUpKTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gMTs8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoCBpZiAoZG1f
Z2V0X29wZW5jb3VudChtYXBuYW1lKSkgezxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb25kbG9nKDIsICZx
dW90OyVzOiBtYXAgaW4gdXNlJnF1b3Q7LCBtYXBuYW1lKTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0
dXJuIDE7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoMKg
wqDCoMKgwqAgfSDCoMKgwqDCoMKgPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoMKgwqDCoMKgwqAgciA9IGRtX3NpbXBsZWNtZChETV9ERVZJQ0VfUkVNT1ZF
LCBtYXBuYW1lKTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgwqDCoMKgwqDCoCBpZiAocikgezxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb25kbG9nKDQsICZxdW90
O211bHRpcGF0aCBtYXAgJXMgcmVtb3ZlZCZxdW90Oyw8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgIG1hcG5hbWUpOzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCDCoMKgwqAgwqDCoMKgIMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybjxicj4NCiZndDvCoCDC
oCDCoCAwOzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCB9PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBvcnBoYW5fcGF0
aHModmVjcy0mZ3Q7cGF0aHZlYyw8YnI+DQomZ3Q7wqAgwqAgwqAgbXBwKTs8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVtb3ZlX21hcChtcHAsIHZlY3MsPGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCBzdG9wX3dhaXRlcl90aHJlYWQsPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgMSk7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCBJcyByZW1vdmluZyB0aGlzIGJlbG93IGxpbmUsIHRoZSByaWdo
dCBzdGVwIHRvIHN0b3A8YnI+DQomZ3Q7wqAgwqAgwqAgcmVtb3Zpbmc8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgIGRldmljZSA/PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIHIgPSBkbV9zaW1wbGVjbWQoRE1fREVWSUNFX1JFTU9WRSwgbWFwbmFtZSk7
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBSZWdhcmRzLDxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgVGVqYXN3aW5pPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBPbiBNb24sIEp1biA4
LCAyMDE1IGF0IDExOjE1IEFNLCBUZWphc3dpbmkgUG9sdXJpPGJyPg0KPC9kaXY+PC9kaXY+PHNw
YW4gY2xhc3M9IiI+Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgICZsdDtbMV1bMl1bM11bNF08YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFp
bC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPiZndDsgd3JvdGU6PGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBUaGFua3MgYSBsb3QgQmVu
IGZvciB0aGUgcXVpY2sgYW5kIGRldGFpbGVkIHJlcGx5Ljxicj4NCiZndDvCoCDCoCDCoCBJIGhh
dmU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGJlZW48YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgc3RydWdnbGluZyB0byB1bmRl
cnN0YW5kIGFuZCBjb25jbHVkZSB0aGUgaXNzdWVzPGJyPg0KJmd0O8KgIMKgIMKgIHdpdGg8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG11bHRpcGF0aDxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGFzIEkgYW08YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgdGhlIG9ubHkgb25lIHdvcmtpbmcgZnJv
bSBteSB0ZWFtLiBZb3VyIGlucHV0cyBoZWxwPGJyPg0KJmd0O8KgIMKgIMKgIG1lIGE8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGxvdC48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCBUaGFua3M8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgYWdhaW4uPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIFJlZ2FyZHMsPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIFRlamFzd2luaTxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBPbiBTYXQs
IEp1biA2LCAyMDE1IGF0IDM6MzYgQU0sIEJlbmphbWluIE1hcnppbnNraTxicj4NCjwvc3Bhbj48
ZGl2PjxkaXYgY2xhc3M9Img1Ij4mZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmx0O1syXVszXVs0XVs1XTxhIGhyZWY9Im1haWx0bzpibWFyemluc0By
ZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPiZndDsgd3JvdGU6PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBPbiBGcmksIEp1biAwNSwg
MjAxNSBhdCAwMjozMToyMFBNICswNTMwLDxicj4NCiZndDvCoCDCoCDCoCBUZWphc3dpbmk8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIFBvbHVyaTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHdyb3RlOjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgSGlpIEJlbiw8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0
Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCDCoCAmZ3Q7wqAgwqAgV2UgYXJlIHRlc3RpbmcgbXVsdGlwYXRoZCB0b29scyB3aXRoIGFsbCB0
aGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHBvc3NpYmxlPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgb3B0aW9ucyBhbmQ8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgdGhlPGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvC
oCDCoCBmb2xsb3dpbmcgZmFpbHMuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIENhc2UgMSA6IHJlbW92
ZSBhbmQgYWRkIG1hcC48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIHJvb3RAeDg2LWdlbmVyaWMtNjQ6fiMgbXVsdGlw
YXRoZCAtayYjMzk7c2hvdzxicj4NCiZndDvCoCDCoCDCoCBtYXBzJiMzOTs8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKg
IG5hbWXCoMKgwqAgc3lzZnMgdXVpZDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgZG1wYXRoMCBkbS0wwqAgMUlFVF8w
MDAxMDAwMTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCDCoCAmZ3Q7wqAgwqAgcm9vdEB4ODYtZ2VuZXJpYy02NDp+IyBtdWx0aXBhdGhkIC1r
JiMzOTtyZW1vdmU8YnI+DQomZ3Q7wqAgwqAgwqAgbWFwPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCBkbXBhdGgwJiMzOTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIG9rPGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCByb290QHg4
Ni1nZW5lcmljLTY0On4jIG11bHRpcGF0aGQgLWsmIzM5O3Nob3c8YnI+DQomZ3Q7wqAgwqAgwqAg
bWFwcyYjMzk7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgIMKgICZndDvCoCDCoCByb290QHg4Ni1nZW5lcmljLTY0On4jIG11bHRpcGF0aGQg
LWsmIzM5O2FkZCBtYXA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGRtcGF0aDAmIzM5
Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCDCoCAmZ3Q7wqAgwqAgb2s8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIHJvb3RAeDg2LWdlbmVyaWMtNjQ6fiMgbXVs
dGlwYXRoZCAtayYjMzk7c2hvdzxicj4NCiZndDvCoCDCoCDCoCBtYXBzJiMzOTs8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8Kg
IMKgIHJvb3RAeDg2LWdlbmVyaWMtNjQ6fiM8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIE9uY2UgYSBtYXAgaXMgcmVt
b3ZlZCwgd2UgYXJlIGFibGUgdG8gYWRkIGl0PGJyPg0KJmd0O8KgIMKgIMKgIG9ubHk8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHVzaW5nPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICNtdWx0aXBhdGjCoDxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAg
wqAgY29tbWFuZCBhbmQgbm90IHVzaW5nIG11bHRpcGF0aGQgdG9vbHMuPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBJdCBpcyB3b3JraW5nIHRoZSB3
YXkgaXQgd2FzIGRlc2lnbmVkLCBidXQ8YnI+DQomZ3Q7wqAgwqAgwqAgcG9zc2libHkgaXQ8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHdvdWxkPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgbWFrZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBzZW5zZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCB0byBjaGFuZ2UgdGhlIGRlc2ln
bi7CoCBUaGUgJnF1b3Q7cmVtb3ZlIG1hcCZxdW90OyBjb21tYW5kLDxicj4NCiZndDvCoCDCoCDC
oCBub3Q8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG9ubHkgc3RvcHM8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgbXVsdGlw
YXRoZCBmcm9tIG1vbml0b3JpbmcgdGhlIG11bHRpcGF0aCBkZXZpY2UsPGJyPg0KJmd0O8KgIMKg
IMKgIGJ1dCBpdDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgcmVtb3Zlczxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGl0PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGZyb208YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgdGhlIHN5
c3RlbSBhcyB3ZWxsLsKgIFRoZSAmcXVvdDthZGQgbWFwJnF1b3Q7IGNvbW1hbmQgbWFrZXM8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG11bHRpcGF0aDxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG1vbml0b3IgYW48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgYWxyZWFkeSBleGlzdGluZyBt
dWx0aXBhdGggZGV2aWNlIHRoYXQgaW4gd2FzbiYjMzk7dDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgcHJldmlvdXNseTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCBtb25pdG9yaW5nLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBUaGVzZSBjb21tYW5kcyBkbyB0
aGlzIGZvciBoaXN0b3JpY2FsIHJlYXNvbnMuwqA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIG11bHRpcGF0aGQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCB3YXNuJiMzOTt0PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgIG9yaWdpbmFsbHkgaW4gY2hhcmdlIG9mIGNyZWF0aW5nIG11bHRpcGF0
aDxicj4NCiZndDvCoCDCoCDCoCBkZXZpY2VzLDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgbXVsdGlwYXRoPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
d2FzLsKgPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgIMKgIE9uY2U8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgwqAgaXQgaGFkIGNyZWF0ZWQgdGhlIGRldmljZSwgaXQgcmFuPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBtdWx0aXBhdGhk
IC1rJnF1b3Q7YWRkIG1hcCAmbHQ7TUFQJmd0OyZxdW90Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgdG8gbWFrZSBtdWx0aXBhdGhkIHN0YXJ0IG1v
bml0b3JpbmcgaXQuwqAgSG93ZXZlcjxicj4NCiZndDvCoCDCoCDCoCB0aGluZ3M8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGhhdmVuJiMzOTt0PGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgd29ya2VkPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIHRoaXMgd2F5IHNpbmNlIFJIRUw0LCBzbyBw
b3NzaWJseSAmcXVvdDthZGQgbWFwJnF1b3Q7PGJyPg0KJmd0O8KgIMKgIMKgIHNob3VsZDxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgYWN0dWFsbHk8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCBjcmVhdGUgdGhlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGRldmljZSBpZiBpdCBkb2VzbiYj
Mzk7dCBjdXJyZW50bHkgZXhpc3QuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBDYXNlIDIgOiBBY3RpdmUgcGF0aHPC
oCB0ZXN0IGNhc2U8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgICMgd2hpbGUgdHJ1ZSA7IGRvIHNsZWVwIDMgOyBtdWx0
aXBhdGhkPGJyPg0KJmd0O8KgIMKgIMKgIC1rJiMzOTtyZW1vdmU8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIHBhdGggc2RiJiMzOTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCA7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIMKgIG11bHRpcGF0aGQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIC1rJiMzOTthZGQgcGF0
aCBzZGImIzM5OyA7IG11bHRpcGF0aGQgLWsmIzM5O3Nob3cgbWFwczxicj4NCiZndDvCoCDCoCDC
oCBzdGF0dXMmIzM5Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgOyBkb25lPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZn
dDvCoCDCoCBvazxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgb2s8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIG5hbWUgZmFpbGJhY2sgcXVl
dWVpbmcgcGF0aHMgZG0tc3Q8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIGRtcGF0aDAgLSAtIDEgYWN0aXZlIC8vIEl0
IHNob3VsZCBiZSAyLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgwqAgVGhpcyBpcyBzaW1wbHkgYSB0aW1pbmcgaXNzdWUuwqAgV2hhdCB5b3UgYXJlPGJy
Pg0KJmd0O8KgIMKgIMKgIHNlZWluZyBpdDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
dGhlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgbnVtYmVyIG9m
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IMKgIGFjdGl2ZSBwYXRocy7CoCBUaGVzZSBhcmUgcGF0aHMgdGhhdCB0aGUga2VybmVsPGJyPg0K
Jmd0O8KgIMKgIMKgIGNhbiB1c2UuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBUaGU8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmcXVvdDthZGQgcGF0
aCZxdW90Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCDCoCBjb21tYW5kIGRvZXNuJiMzOTt0IHVwZGF0ZSB0aGUga2VybmVsIHN0YXRlLsKg
IFRoaXM8YnI+DQomZ3Q7wqAgwqAgwqAgaGFwcGVuczxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgbGF0ZXIgaW48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgwqAgcmVzcG9uc2U8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgdG8gdGhlIGtlcm5lbCByZWxvYWRpbmcgdGhl
IGRldmljZSB0YWJsZS4gU28sIGluPGJyPg0KJmd0O8KgIMKgIMKgIGE8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIHNlY29uZCBvcjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIHR3bywgdGhpczxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCB3aWxsIHNheSAyLCBhcyBleHBlY3RlZC48YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBX
ZSB3b3VsZCBsaWtlIHRvIGtub3cgaWYgdGhlIHRlc3QgY2FzZXMgYXJlPGJyPg0KJmd0O8KgIMKg
IMKgIHZhbGlkPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBhbmQgaWY8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB0aGVzZTxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBhcmUgYnVncyBvcjxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDC
oCAmZ3Q7wqAgwqAgYW55IGRlc2lnbiBpc3N1ZXMuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIENhc2Ug
MyA6IEZhaWwgcGF0aCBhbmQgcmVpbnN0YXRlIHBhdGg8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIHJvb3RAeDg2LWdl
bmVyaWMtNjQ6fiMgbXVsdGlwYXRoZCAtayZxdW90O2ZhaWw8YnI+DQomZ3Q7wqAgwqAgwqAgcGF0
aDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgc2RjJnF1b3Q7Ozxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG11bHRpcGF0aGQ8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIC1r
JiMzOTtyZWluc3RhdGUgcGF0aCBzZGMmIzM5OzsgbXVsdGlwYXRoZCAtayZxdW90O3Nob3c8YnI+
DQomZ3Q7wqAgwqAgwqAgcGF0aHMmcXVvdDs7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCAmZ3Q7wqDCoMKgIFsgMzk2
Mi43MDg1MjNdIGRldmljZS1tYXBwZXI6PGJyPg0KJmd0O8KgIMKgIMKgIG11bHRpcGF0aDo8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIEZhaWxpbmcgcGF0aDxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIDg6MzIuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCAmZ3Q7wqDCoMKg
IG9rPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIMKgICZndDvCoCDCoCAmZ3Q7wqDCoMKgIG9rPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCAmZ3Q7wqDCoMKgIGhj
aWzCoMKgwqAgZGV2IGRldl90IHByaSBkbV9zdMKgwqAgY2hrX3N0wqDCoDxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgbmV4dF9jaGVjazxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgJmd0O8KgwqDCoCA0OjA6
MDoxIHNkYyA4OjMywqAgMcKgwqAgW2FjdGl2ZV1bZmF1bHR5XTxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgLi4uLi4uLi4uLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgIDEvMjDCoMKgPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgIMKgICZsdDs9PUNIRUNLPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCAmZ3Q7wqDCoMKg
IDU6MDowOjEgc2RkIDg6NDjCoCAxwqDCoCBbYWN0aXZlXVtyZWFkeV3CoDxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgWFguLi4uLi4uLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIDQvMjA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIHNkYyBwYXRoIGJlY29tZXMgW2FjdGl2
ZV1bcmVhZHldIG9ubHkgYWZ0ZXI8YnI+DQomZ3Q7wqAgwqAgwqAgdGhlPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCBwb2xsaW5nPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgaW50ZXJ2YWw8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgYnV0IG5vdDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgaW1tZWRpYXRlbHkg
YWZ0ZXIgdGhlIHJlaW5zdGF0ZSBwYXRoPGJyPg0KJmd0O8KgIMKgIMKgIGNvbW1hbmQuPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZn
dDvCoCDCoCBZb3UgaGF2ZSBhbnN3ZXJlZCB0aGF0IHRoaXMgaXMgYSBkZXNpZ248YnI+DQomZ3Q7
wqAgwqAgwqAgaXNzdWUuIEJ1dDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgd2UgaGF2
ZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGhlYXJkPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGZy
b20gb3VyPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgIMKgICZndDvCoCDCoCB0ZXN0IHRlYW0gdGhhdCB0aGUgc2FtZSB0ZXN0IGNhc2Ugd29y
a3MgaW48YnI+DQomZ3Q7wqAgwqAgwqAgUkhFTDYuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCBEaWQgeW91PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
b2JzZXJ2ZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCDCoCBpdD88YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIEkgYW0gYWxzbyBmaW5kaW5nIHRoYXQgdGhlIHRl
c3QgY2FzZXMgZmFpbDxicj4NCiZndDvCoCDCoCDCoCBiZWNhdXNlPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCB3ZSBhcmU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCB0cnlpbmc8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgwqAgdG8gZG88YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIG11bHRpcGxlIGNvbW1hbmRzIGF0
IG9uZSBzaG90LsKgIFBsZWFzZSBzaGFyZTxicj4NCiZndDvCoCDCoCDCoCB5b3VyPGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCB0aG91Z2h0czxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgIHNvPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIHRoYXQgaXQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIGNvdWxkIGhlbHAg
bWUgaW4gZGVidWdnaW5nIHRoZSBpc3N1ZXM8YnI+DQomZ3Q7wqAgwqAgwqAgZnVydGhlci48YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAg
Jmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAg
SXQmIzM5O3MgdG90YWxseSBwb3NzaWJsZSB0aGF0IHRoZSBjaGVja2VyIHN0YXRlIGlzPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBpbW1lZGlhdGVseTxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHVwZGF0ZWQgaW48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgUkhFTDYuwqAgTGlrZSBJIHNh
aWQgYmVmb3JlLCB3aGF0IGl0IGN1cnJlbnRseTxicj4NCiZndDvCoCDCoCDCoCBkb2VzLDxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgYWx0aG91Z2g8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCBjb3JyZWN0LDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBpcyBjb25mdXNpbmcsIGFuZCBwZXJo
YXBzIHdlIG5lZWQgYSBkaWZmZXJlbnQ8YnI+DQomZ3Q7wqAgwqAgwqAgY2hlY2tlcjxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgc3RhdGUgZm9yPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgcGF0aHM8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgd2hlcmUgdGhlICZxdW90O2ZhaWwgcGF0aCZx
dW90OyBjb21tYW5kIGhhcyBiZWVuIHVzZWQuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCAtQmVuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBSZWdhcmRzLDxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7
wqAgwqAgVGVqYXN3aW5pPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBPbiBUdWUsIE1heSAxOSwgMjAxNSBhdCA1OjM3
IFBNLCBUZWphc3dpbmk8YnI+DQomZ3Q7wqAgwqAgwqAgUG9sdXJpPGJyPg0KPC9kaXY+PC9kaXY+
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZn
dDvCoCDCoCAmbHQ7WzFdWzNdWzRdWzVdWzZdPGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVy
aTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT4mZ3Q7PGJyPg0KPHNw
YW4gY2xhc3M9IiI+Jmd0O8KgIMKgIMKgIHdyb3RlOjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCBU
aGFua3MgYSBsb3QgQmVuLiBJIHdpbGwgbG9vayBpbnRvIGl0PGJyPg0KJmd0O8KgIMKgIMKgIG1v
cmUuwqA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIE9uIE1vbiwgTWF5IDE4LCAyMDE1IGF0IDk6NTcgUE0sIEJl
bmphbWluPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBNYXJ6aW5za2k8YnI+DQo8L3Nw
YW4+Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKg
ICZndDvCoCDCoCDCoCAmbHQ7WzJdWzRdWzVdWzZdWzddPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5z
QHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+Jmd0Ozxicj4NCjxkaXY+PGRpdiBj
bGFzcz0iaDUiPiZndDvCoCDCoCDCoCB3cm90ZTo8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAg
T24gTW9uLCBNYXkgMTgsIDIwMTUgYXQgMDI6MDk6MjdQTTxicj4NCiZndDvCoCDCoCDCoCArMDUz
MCw8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIFRlamFzd2luaTxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIFBvbHVyaTxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCB3cm90ZTo8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8Kg
IMKgIMKgIMKgICZndDvCoCDCoCBIaWksPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgV2Ug
YXJlIHRyeWluZyB0byB0ZXN0IG11bHRpcGF0aDxicj4NCiZndDvCoCDCoCDCoCBzZXR1cCBpbjxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgb3VyPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgdGFyZ2V0IGFuZDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCB0cmllZCB0aGU8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKg
IMKgIMKgIHZhcmlvdXM8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBjb21tYW5kcyBvZiBt
dWx0aXBhdGhkIGRlbWFvbiBhbmQ8YnI+DQomZ3Q7wqAgwqAgwqAgd2UgZmluZDxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgdGhlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgZm9sbG93aW5nPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGVycm9yOjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8Kg
IMKgIHJvb3RAeDg2LWdlbmVyaWMtNjQ6fiMgbXVsdGlwYXRoZDxicj4NCiZndDvCoCDCoCDCoCAt
ayZxdW90O2ZhaWw8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHBhdGg8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBzZGMmcXVvdDs7PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIG11bHRpcGF0
aGQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCAtayYjMzk7cmVpbnN0YXRlIHBhdGg8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBzZGMmIzM5OzsgbXVsdGlwYXRoZCAtayZxdW90O3No
b3cgcGF0aHMmcXVvdDs7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgWyAzOTYyLjcwODUy
M10gZGV2aWNlLW1hcHBlcjo8YnI+DQomZ3Q7wqAgwqAgwqAgbXVsdGlwYXRoOjxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgRmFpbGluZzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBwYXRowqA4OjMyLjxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgwqAgJmd0O8KgIMKgIG9rPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgb2s8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0
O8KgIMKgIMKgIMKgICZndDvCoCDCoCBoY2lswqAgwqAgZGV2IGRldl90IHByaSBkbV9zdMKgPGJy
Pg0KJmd0O8KgIMKgIMKgIMKgY2hrX3N0wqA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IMKgbmV4dF9jaGVjazxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIDQ6MDowOjEgc2RjwqA4
OjMywqAgMcKgPGJyPg0KJmd0O8KgIMKgIMKgIMKgW2FjdGl2ZV1bZmF1bHR5XTxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgLi4uLi4uLi4uLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgIDEvMjDCoDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCDCoCAmbHQ7Jmx0OyZsdDs9PT08YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8Kg
IMKgIMKgIMKgIENIRUNLPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgNTowOjA6MSBzZGTC
oDg6NDjCoCAxwqA8YnI+DQomZ3Q7wqAgwqAgwqAgwqBbYWN0aXZlXVtyZWFkeV3CoDxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgWFguLi4uLi4uLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIDQvMjA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBz
ZGMgcGF0aCBiZWNvbWVzIFthY3RpdmVdW3JlYWR5XTxicj4NCiZndDvCoCDCoCDCoCBvbmx5PGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBhZnRlciB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBwb2xsaW5nPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGludGVydmFsPGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDC
oCDCoCDCoCBidXQgbm90PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgaW1tZWRpYXRlbHkg
YWZ0ZXIgdGhlIHJlaW5zdGF0ZTxicj4NCiZndDvCoCDCoCDCoCBwYXRoPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCBjb21tYW5kLsKgPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAg
SSBhbSBvYnNlcnZpbmcgdGhpcyBpbiBsYXRlc3Q8YnI+DQomZ3Q7wqAgwqAgwqAgbXVsdGlwYXRo
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB0b29scyBpbjxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHVidW50dTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBtYWNoaW5lPGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDC
oCDCoCDCoCBhcyB3ZWxsLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIFBsZWFzZSBsZXQg
bWUga25vdyBpZiBpdHMgYSBrbm93bjxicj4NCiZndDvCoCDCoCDCoCBpc3N1ZSBvcjxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgaWYgSTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIGFtIGRvaW5nPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBzb21ldGhpbmcgd3Jv
bmcuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgUmVnYXJkcy48YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKg
IMKgICZndDvCoCDCoCBUZWphc3dpbmk8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgdGhlIHJl
aW5zdGF0ZSBjb21tYW5kIGlzIHN1cHBvc2VkIHRvPGJyPg0KJmd0O8KgIMKgIMKgIHJlaW5zdGF0
ZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgdGhlPGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgZGV2aWNlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIHdpdGggdGhlPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDC
oCDCoCBrZXJuZWwsIGFuZCBpdCBkb2VzIHRoYXQuIFRoZSBjaGVja2VyPGJyPg0KJmd0O8KgIMKg
IMKgIHN0YXRlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBkb2VzbiYjMzk7dDxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGNoYW5nZTxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCB1bnRpbCB0
aGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgwqAgJmd0O8KgIMKgIMKgIMKgIG5leHQgdGltZSB0aGF0IHRoZSBwYXRoIGlzIGNoZWNrZWQu
wqAgSTxicj4NCiZndDvCoCDCoCDCoCBhZ3JlZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgdGhhdCBpdCYjMzk7czxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIG9kZDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCDCoCB0aGF0IHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgY2hlY2sgc3RhdGUgc3dpdGNo
ZXMgdG8gZmF1bHR5IGFzIHNvb248YnI+DQomZ3Q7wqAgwqAgwqAgYXMgeW91PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCBmYWlsIHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIHBhdGgsPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGJ1dCBpdDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgZG9lc24m
IzM5O3Qgc3dpdGNoIGJhY2sgdW50aWwgdGhlIG5leHQgY2hlY2s8YnI+DQomZ3Q7wqAgwqAgwqAg
YWZ0ZXI8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHlvdTxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHJlaW5pc3RhdGU8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgaXQuPGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDs8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgIFRoZSBpc3N1ZSBpcyB0aGF0IG11bHRpcGF0aGQgbmVlZHMgdG88YnI+
DQomZ3Q7wqAgwqAgwqAgb3ZlcnJpZGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHRo
ZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGNoZWNrZXI8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAg
b3V0cHV0LDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgc28gdGhhdCBhIGZhaWxlZCBwYXRoIHdvbiYjMzk7
dCBiZTxicj4NCiZndDvCoCDCoCDCoCBpbW1lZGl0YXRlbHk8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCByZWluc3RhdGVkLsKgIE9uY2U8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgdGhlPGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvC
oCDCoCDCoCDCoCBwYXRoIGNvbWVzIGJhY2ssIG11bHRpcGF0aGQgd2FudHMgdG88YnI+DQomZ3Q7
wqAgwqAgwqAgcmVjb3JkIHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgc3dpdGNo
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgaW4gdGhlPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGNo
ZWNrZXI8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIHRocmVhZCwgc28gdGhhdCBpdCBjYW4gcmVmcmVzaCBw
YXRoPGJyPg0KJmd0O8KgIMKgIMKgIGluZm9ybWF0aW9uPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCB3aGF0PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
d2FzbiYjMzk7dDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgYXV0b21hdGljYWxseSBkb25lIHdoZW4gdGhl
IHBhdGggd2FzPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCByZWluc3RhdGVkLsKgPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgSG93ZXZlciwgaXQ8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAg
bWF5IG1ha2U8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIG1vcmUgc2Vuc2UgdG8gaGF2ZSBhIGRpZmZlcmVu
dCBjaGVja2VyPGJyPg0KJmd0O8KgIMKgIMKgIHN0YXRlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCBmb3Igd2hlbjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCDCoCBkZXZpY2UgaXM8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGluIHRoZSBmYWlsZWQgc3Rh
dGUsIHNvIHRoYXQgaXQmIzM5O3M8YnI+DQomZ3Q7wqAgwqAgwqAgb2J2aW91cyB0aGF0PGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCBjaGVja2VyPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIHN0YXRlIGlzPGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBi
ZWluZyBvdmVycnVsZWQuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIC1CZW48YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0Ozxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgwqAgJmd0OyAtLTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0OyBkbS1kZXZl
bCBtYWlsaW5nIGxpc3Q8YnI+DQo8L2Rpdj48L2Rpdj4mZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDsgWzNdWzVd
WzZdWzddWzhdPGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJl
ZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqA8YnI+DQomZ3Q7wqAgwqAgwqAgWzRdWzZdWzddWzhdWzld
PGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
IiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKg
IC0tPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCBkbS1kZXZlbCBtYWlsaW5nIGxpc3Q8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKg
IMKgIMKgIFs1XVs3XVs4XVs5XVsxMF08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNv
bSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgPGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqA8YnI+DQomZ3Q7wqAgwqAgwqAgWzZdWzhd
WzldWzEwXVsxMV08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0Ozxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7
IFJlZmVyZW5jZXM8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgVmlzaWJsZSBsaW5rczxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAg
wqAgMS48YnI+DQomZ3Q7wqAgwqAgwqAgbWFpbHRvOls5XVsxMF1bMTFdWzEyXTxhIGhyZWY9Im1h
aWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5j
b208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgIMKgICZndDvCoCDCoCAyLjxicj4NCiZndDvCoCDCoCDCoCBtYWlsdG86WzEwXVsxMV1b
MTJdWzEzXTxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRo
YXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgMy48YnI+DQomZ3Q7wqAgwqAgwqAgbWFpbHRvOlsxMV1b
MTJdWzEzXVsxNF08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxA
cmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIDQuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqA8YnI+DQomZ3Q7wqAgwqAgwqAgWzEyXVsxM11bMTRdWzE1XTxhIGhy
ZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVs
PSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWls
bWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgNS48YnI+DQomZ3Q7wqAgwqAg
wqAgbWFpbHRvOlsxM11bMTRdWzE1XVsxNl08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0
LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIDYuPGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqA8YnI+DQomZ3Q7wqAgwqAgwqAgWzE0XVsx
NV1bMTZdWzE3XTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cu
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7IFJlZmVyZW5jZXM8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIFZpc2libGUgbGlua3M8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgMS4gbWFpbHRvOlsxNl1bMTddWzE4
XTxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9s
dXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIDIuIG1haWx0bzpbMTddWzE4XVsxOV08YSBocmVmPSJtYWlsdG86Ym1h
cnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgMy4gbWFpbHRvOlsxOF1bMTld
WzIwXTxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5p
cG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIDQuIG1haWx0bzpbMTldWzIwXVsyMV08YSBocmVmPSJtYWlsdG86
Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgNS4gbWFpbHRvOlsyMF1b
MjFdWzIyXTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRo
YXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCA2Ljxicj4NCiZndDvCoCDCoCDCoCBbMjFdWzIyXVsyM108YSBocmVmPSJodHRwczov
L3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJl
ciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgNy4gbWFpbHRvOlsyMl1bMjNdWzI0XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZl
bEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCA4Ljxicj4NCiZndDvCoCDCoCDCoCBb
MjNdWzI0XVsyNV08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgOS4gbWFpbHRvOlsyNF1bMjVd
WzI2XTxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5p
cG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgMTAuIG1haWx0bzpbMjVdWzI2XVsyN108YSBocmVmPSJtYWlsdG86
Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAxMS4gbWFpbHRvOlsyNl1b
MjddWzI4XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRo
YXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoDEyLjxicj4NCiZndDvCoCDCoCDCoCBbMjddWzI4XVsyOV08YSBocmVmPSJodHRwczov
L3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJl
ciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAxMy4gbWFpbHRvOlsyOF1bMjldWzMwXTxhIGhyZWY9Im1haWx0bzpkbS1kZXZl
bEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoDE0Ljxicj4NCiZndDvCoCDCoCDCoCBb
MjldWzMwXVszMV08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDsg
UmVmZXJlbmNlczxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIFZpc2libGUgbGlua3M8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCAxLiBtYWlsdG86WzMxXVszMl08YSBocmVmPSJt
YWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCAyLiBtYWlsdG86WzMyXVszM108YSBo
cmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNA
Z21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDMu
IG1haWx0bzpbMzNdWzM0XTxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFy
emluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIDQuIG1haWx0bzpbMzRdWzM1XTxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdt
YWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgNS4gbWFpbHRvOlszNV1bMzZdPGEgaHJlZj0ibWFpbHRv
OmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgNi4gbWFpbHRvOlszNl1bMzddPGEgaHJlZj0i
bWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgNy4gWzM3XVszOF08YSBocmVmPSJo
dHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9y
ZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCA4LiBtYWlsdG86WzM4XVszOV08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNv
bSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCA5LiBbMzldWzQwXTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFp
bG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+
aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTAuIG1haWx0bzpbNDBdWzQxXTxh
IGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJp
M0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAx
MS4gbWFpbHRvOls0MV1bNDJdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJt
YXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAxMi4gbWFpbHRvOls0Ml1bNDNdPGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5j
b20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAxMy4gWzQzXVs0NF08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsi
Pmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoDE0LiBtYWlsdG86WzQ0XVs0NV08
YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwv
YT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoDE1LiBbNDVdWzQ2XTxh
IGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIg
cmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgMTYuIG1haWx0bzpbNDZdWzQ3XTxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlw
b2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAxNy4gbWFpbHRvOls0N11bNDhdPGEgaHJl
Zj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAxOC4gbWFpbHRvOls0OF1bNDld
PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1
cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oDE5LiBtYWlsdG86WzQ5XVs1MF08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+
Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoDIwLiBtYWlsdG86WzUwXVs1MV08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0
LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoDIxLiBbNTFdWzUyXTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFu
ayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMjIuIG1haWx0bzpbNTJdWzUz
XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29t
PC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMjMuIFs1M11bNTRd
PGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
IiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAyNC4gbWFpbHRvOls1NF1bNTVdPGEgaHJlZj0ibWFpbHRvOnRlamFzd2lu
aXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoDI1LiBtYWlsdG86WzU1XVs1Nl08YSBo
cmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoDI2LiBtYWlsdG86WzU2XVs1
N108YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNv
bTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoDI3LiBbNTddWzU4
XTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgMjguIG1haWx0bzpbNThdWzU5XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZl
bEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgMjkuIFs1OV1bNjBdPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdl
dD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0OyBSZWZl
cmVuY2VzPGJyPg0KJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IFZpc2libGUgbGlua3M8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDEuIG1haWx0bzpbNjFd
PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208
L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCAyLiBtYWlsdG86WzYyXTxhIGhyZWY9Im1h
aWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgMy4gbWFpbHRvOls2M108YSBocmVmPSJtYWlsdG86dGVqYXN3
aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgNC4gbWFpbHRvOls2NF08YSBocmVmPSJtYWlsdG86Ym1h
cnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIDUuIG1haWx0bzpbNjVdPGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVy
aTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIDYuIG1haWx0bzpbNjZdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJl
ZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCA3LiBtYWlsdG86WzY3XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5k
bS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgOC4gWzY4
XTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgOS4gbWFpbHRvOls2OV08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0t
ZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTAuIFs3MF08
YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwi
IHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
MTEuIG1haWx0bzpbNzFdPGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29t
Ij50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgMTIuIG1haWx0bzpbNzJdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJt
YXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDEzLiBtYWls
dG86WzczXTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRo
YXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAxNC4gWzc0XTxhIGhyZWY9Imh0
dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3Jl
ZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAxNS4gbWFpbHRv
Ols3NV08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0
LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTYuIFs3Nl08YSBocmVmPSJodHRw
czovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZl
cnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTcuIG1haWx0bzpb
NzddPGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlw
b2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTguIG1haWx0
bzpbNzhdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhh
dC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDE5LiBtYWlsdG86Wzc5XTxhIGhy
ZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0Bn
bWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDIwLiBtYWlsdG86WzgwXTxh
IGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9h
Pjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAyMS4gbWFpbHRvOls4MV08YSBocmVmPSJtYWls
dG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgMjIuIFs4Ml08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxh
bmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMjMuIG1haWx0bzpbODNdPGEgaHJlZj0ibWFpbHRv
OmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoDI0LiBbODRdPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5r
Ij5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDI1LiBtYWlsdG86Wzg1XTxhIGhyZWY9Im1haWx0bzp0
ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDI2LiBtYWlsdG86Wzg2XTxhIGhyZWY9Im1haWx0
bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAyNy4gbWFpbHRvOls4N108YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxA
cmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgMjguIFs4OF08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8v
d3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgMjkuIG1haWx0bzpbODldPGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJl
ZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoDMwLiBbOTBdPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3
dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoDMxLiBtYWlsdG86WzkxXTxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRo
YXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAzMi4gbWFpbHRvOls5Ml08YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5j
b20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAzMy4gbWFpbHRvOls5M108YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+
Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMzQuIG1h
aWx0bzpbOTRdPGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWph
c3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMzUu
IG1haWx0bzpbOTVdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5z
QHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDM2LiBtYWlsdG86Wzk2
XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29t
PC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAzNy4gWzk3XTxhIGhyZWY9Imh0dHBzOi8v
d3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVy
IiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAzOC4gbWFpbHRvOls5OF08
YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwv
YT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMzkuIFs5OV08YSBocmVmPSJodHRwczovL3d3
dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIg
dGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNDAuIG1haWx0bzpbMTAwXTxh
IGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJp
M0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDQxLiBtYWlsdG86WzEw
MV08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNv
bTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNDIuIG1haWx0bzpbMTAyXTxhIGhyZWY9
Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqA0My4gWzEwM108YSBocmVmPSJodHRwczovL3d3dy5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0
PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNDQuIG1haWx0bzpbMTA0XTxhIGhyZWY9
Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqA0NS4gWzEwNV08YSBocmVmPSJodHRwczovL3d3dy5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0
PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNDYuIG1haWx0bzpbMTA2XTxhIGhyZWY9
Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFp
bC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDQ3LiBtYWlsdG86WzEwN108YSBo
cmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNDguIG1haWx0bzpbMTA4XTxhIGhyZWY9Im1haWx0
bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208
L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDQ5LiBtYWlsdG86WzEwOV08YSBocmVmPSJt
YWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgNTAuIG1haWx0bzpbMTEwXTxhIGhyZWY9Im1haWx0bzpkbS1k
ZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqA1MS4gWzExMV08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0
dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgNTIuIG1haWx0bzpbMTEyXTxhIGhyZWY9Im1haWx0bzpkbS1k
ZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqA1My4gWzExM108YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0
dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgNTQuIG1haWx0bzpbMTE0XTxhIGhyZWY9Im1haWx0bzp0ZWph
c3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDU1LiBtYWlsdG86WzExNV08YSBocmVmPSJtYWlsdG86
Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgNTYuIG1haWx0bzpbMTE2XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEBy
ZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqA1Ny4gWzExN108YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8v
d3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgNTguIG1haWx0bzpbMTE4XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEBy
ZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqA1OS4gWzExOV08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8v
d3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQo8c3BhbiBj
bGFzcz0iIj4mZ3Q7PGJyPg0KJmd0OyBSZWZlcmVuY2VzPGJyPg0KJmd0Ozxicj4NCiZndDvCoCDC
oCBWaXNpYmxlIGxpbmtzPGJyPg0KJmd0O8KgIMKgIDEuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86
Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAg
wqAgMi4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemlu
c0ByZWRoYXQuY29tPC9hPjxicj4NCjwvc3Bhbj48c3BhbiBjbGFzcz0iIj4mZ3Q7wqAgwqAgMy4g
bWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRo
YXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCA0LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOnRlamFz
d2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+
DQomZ3Q7wqAgwqAgNS4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29t
Ij5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCjwvc3Bhbj4mZ3Q7wqAgwqAgNi4gbWFpbHRv
OjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9s
dXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIDcuIG1haWx0bzo8YSBocmVmPSJtYWls
dG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQo8c3Bh
biBjbGFzcz0iIj4mZ3Q7wqAgwqAgOC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEBy
ZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCA5LiA8YSBo
cmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJl
bD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFp
bG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQo8L3NwYW4+Jmd0O8KgIMKgMTAuIG1haWx0
bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNv
bTwvYT48YnI+DQomZ3Q7wqAgwqAxMS4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5r
Ij5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJy
Pg0KJmd0O8KgIMKgMTIuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0Bn
bWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoDEz
LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJl
ZGhhdC5jb208L2E+PGJyPg0KPHNwYW4gY2xhc3M9IiI+Jmd0O8KgIMKgMTQuIG1haWx0bzo8YSBo
cmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48
YnI+DQomZ3Q7wqAgwqAxNS4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRw
czovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KPC9z
cGFuPiZndDvCoCDCoDE2LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5j
b20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgMTcuIDxhIGhyZWY9Imh0
dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3Jl
ZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCjxzcGFuIGNsYXNzPSIiPiZndDvCoCDCoDE4LiBtYWls
dG86PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlw
b2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAxOS4gbWFpbHRvOjxhIGhyZWY9Im1h
aWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCjwv
c3Bhbj4mZ3Q7wqAgwqAyMC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkz
QGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKg
MjEuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNA
cmVkaGF0LmNvbTwvYT48YnI+DQo8c3BhbiBjbGFzcz0iIj4mZ3Q7wqAgwqAyMi4gbWFpbHRvOjxh
IGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9h
Pjxicj4NCiZndDvCoCDCoDIzLiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0
dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQo8
L3NwYW4+Jmd0O8KgIMKgMjQuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0
LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAyNS4gPGEgaHJlZj0i
aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5v
cmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgMjYuIG1haWx0bzo8YSBocmVmPSJt
YWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwu
Y29tPC9hPjxicj4NCiZndDvCoCDCoDI3LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5z
QHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KPHNwYW4gY2xhc3M9IiI+
Jmd0O8KgIMKgMjguIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+
ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAyOS4gPGEgaHJlZj0iaHR0cHM6
Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJy
ZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWw8L2E+PGJyPg0KPC9zcGFuPiZndDvCoCDCoDMwLiBtYWlsdG86PGEgaHJlZj0i
bWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0K
Jmd0O8KgIMKgMzEuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93
d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDC
oDMyLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5z
QHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgMzMuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86
dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9h
Pjxicj4NCiZndDvCoCDCoDM0LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhh
dC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgMzUuIG1haWx0bzo8
YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVy
aTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoDM2LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRv
OmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8Kg
IMKgMzcuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2
ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAzOC4gPGEgaHJlZj0iaHR0cHM6Ly93d3cu
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRh
cmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgMzkuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2
ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA0MC4g
PGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
IiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgNDEuIG1haWx0bzo8
YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVy
aTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoDQyLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRv
OmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8Kg
IMKgNDMuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2
ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA0NC4gPGEgaHJlZj0iaHR0cHM6Ly93d3cu
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRh
cmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgNDUuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2
ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA0Ni4g
PGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
IiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgNDcuIG1haWx0bzo8
YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVy
aTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoDQ4LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRv
OmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8Kg
IMKgNDkuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20i
PnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoDUwLiBtYWlsdG86
PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208
L2E+PGJyPg0KJmd0O8KgIMKgNTEuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVk
aGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA1Mi4gPGEgaHJl
Zj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9
Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgNTMuIG1haWx0bzo8YSBocmVm
PSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+
DQomZ3Q7wqAgwqA1NC4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczov
L3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8Kg
IMKgNTUuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20i
PnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoDU2LiBtYWlsdG86
PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208
L2E+PGJyPg0KJmd0O8KgIMKgNTcuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVk
aGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA1OC4gPGEgaHJl
Zj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9
Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgNTkuIG1haWx0bzo8YSBocmVm
PSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+
DQomZ3Q7wqAgwqA2MC4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczov
L3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8Kg
IMKgNjEuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnpp
bnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA2Mi4gbWFpbHRvOjxhIGhyZWY9Im1haWx0
bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvC
oCDCoDYzLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29t
Ij50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA2NC4gbWFpbHRv
OjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29t
PC9hPjxicj4NCiZndDvCoCDCoDY1LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBv
bHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7
wqAgwqA2Ni4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFy
emluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDY3LiBtYWlsdG86PGEgaHJlZj0ibWFp
bHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0
O8KgIMKgNjguIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cu
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoDY5
LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJl
ZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgNzAuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9
Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
PC9hPjxicj4NCiZndDvCoCDCoDcxLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBv
bHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7
wqAgwqA3Mi4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFy
emluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDczLiBtYWlsdG86PGEgaHJlZj0ibWFp
bHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0
O8KgIMKgNzQuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cu
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoDc1
LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJl
ZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgNzYuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9
Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
PC9hPjxicj4NCiZndDvCoCDCoDc3LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBv
bHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7
wqAgwqA3OC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFy
emluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDc5LiBtYWlsdG86PGEgaHJlZj0ibWFp
bHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNv
bTwvYT48YnI+DQomZ3Q7wqAgwqA4MC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0By
ZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDgxLiBtYWls
dG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5j
b208L2E+PGJyPg0KJmd0O8KgIMKgODIuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFu
ayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxi
cj4NCiZndDvCoCDCoDgzLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5j
b20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgODQuIDxhIGhyZWY9Imh0
dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3Jl
ZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoDg1LiBtYWlsdG86PGEgaHJlZj0ibWFp
bHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNv
bTwvYT48YnI+DQomZ3Q7wqAgwqA4Ni4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0By
ZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDg3LiBtYWls
dG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5j
b208L2E+PGJyPg0KJmd0O8KgIMKgODguIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFu
ayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxi
cj4NCiZndDvCoCDCoDg5LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5j
b20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgOTAuIDxhIGhyZWY9Imh0
dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3Jl
ZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoDkxLiBtYWlsdG86PGEgaHJlZj0ibWFp
bHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0
O8KgIMKgOTIuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5j
b20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoDkzLiBtYWls
dG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5j
b208L2E+PGJyPg0KJmd0O8KgIMKgOTQuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5p
cG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZn
dDvCoCDCoDk1LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJt
YXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgOTYuIG1haWx0bzo8YSBocmVmPSJt
YWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQom
Z3Q7wqAgwqA5Ny4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3
dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKg
OTguIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxA
cmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA5OS4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdl
dD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWw8L2E+PGJyPg0KJmd0O8KgIDEwMC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlw
b2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0
O8KgIDEwMS4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFy
emluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCAxMDIuIG1haWx0bzo8YSBocmVmPSJtYWls
dG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7
wqAgMTAzLiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgMTA0LiBt
YWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhh
dC5jb208L2E+PGJyPg0KJmd0O8KgIDEwNS4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2Js
YW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+
PGJyPg0KJmd0O8KgIDEwNi4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkz
QGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIDEw
Ny4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0By
ZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCAxMDguIG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVq
YXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxi
cj4NCiZndDvCoCAxMDkuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNv
bSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgMTEwLiBtYWlsdG86PGEgaHJl
Zj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJy
Pg0KJmd0O8KgIDExMS4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczov
L3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8Kg
IDExMi4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZl
bEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCAxMTMuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJn
ZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVsPC9hPjxicj4NCiZndDvCoCAxMTQuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5p
cG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZn
dDvCoCAxMTUuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1h
cnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgMTE2LiBtYWlsdG86PGEgaHJlZj0ibWFp
bHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0
O8KgIDExNy4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIDExOC4g
bWFpbHRvOjxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRo
YXQuY29tPC9hPjxicj4NCiZndDvCoCAxMTkuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9i
bGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9h
Pjxicj4NCjwvYmxvY2txdW90ZT48L2Rpdj48YnI+PC9kaXY+DQo=
--001a1140fee6fb09af051a5be5d2--

--001a1140fee6fb09b5051a5be5d4
Content-Type: text/x-patch; charset=US-ASCII; name="add_map.patch"
Content-Disposition: attachment; filename="add_map.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ibups2rh0

Y29tbWl0IDc5YWI5MDkwZDNmYmNkYjU4NDQ0Nzg0MTkxMzVkMTM5MGNmNTQ4YzIKQXV0aG9yOiBU
ZWphc3dpbmkgPHRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPgpEYXRlOiAgIFdlZCBKdWwgOCAx
NTowODo1NiAyMDE1ICswNTMwCgogICAgbXVsdGlwYXRoZDogRml4aW5nIGFkZCBtYXAgZnVuY3Rp
b25hbGl0eQogICAgCiAgICBBZGQgbWFwIGZlYXR1cmUgb2YgbXVsdGlwYXRoZCB0b29scyBmYWls
cyBhcyB0aGUgZGV2aWNlCiAgICBpcyBhbHNvIGJlZW4gY29tcGxldGVseSByZW1vdmVkIGFsb25n
IHdpdGggcmVtb3ZpbmcgdGhlIG1hcAogICAgaW4gdGhlIHJlbW92ZSBtYXAgY29kZS4gU28gd2hl
biBhZGQgbWFwIGlzIGNhbGxlZCB3ZSBhcmUKICAgIGNyZWF0aW5nIHRoZSBkZXZpY2UgYWdhaW4g
aW4ga2VybmVsIGFuZCBkb2luZyBhZGQgbWFwCiAgICB1c2luZyB0aGUgY29sb2FzY2VfcGF0aHMg
Y29kZS4KICAgIAogICAgU2lnbmVkLW9mZi1ieTogVGVqYXN3aW5pIFBvbHVyaSA8dHBvbHVyaUBt
dmlzdGEuY29tPgoKZGlmZiAtLWdpdCBhL211bHRpcGF0aGQvY2xpX2hhbmRsZXJzLmMgYi9tdWx0
aXBhdGhkL2NsaV9oYW5kbGVycy5jCmluZGV4IGRjOTZjNDUuLmM1NGM3NjcgMTAwNjQ0Ci0tLSBh
L211bHRpcGF0aGQvY2xpX2hhbmRsZXJzLmMKKysrIGIvbXVsdGlwYXRoZC9jbGlfaGFuZGxlcnMu
YwpAQCAtNTM3LDcgKzUzNyw3IEBAIGNsaV9hZGRfbWFwICh2b2lkICogdiwgY2hhciAqKiByZXBs
eSwgaW50ICogbGVuLCB2b2lkICogZGF0YSkKIAljaGFyIGRldl9wYXRoW1BBVEhfU0laRV07CiAJ
Y2hhciAqYWxpYXM7CiAJaW50IHJjOwotCisJY2hhciAqcmVmd3dpZDsKIAlwYXJhbSA9IGNvbnZl
cnRfZGV2KHBhcmFtLCAwKTsKIAljb25kbG9nKDIsICIlczogYWRkIG1hcCAob3BlcmF0b3IpIiwg
cGFyYW0pOwogCkBAIC01NDcsNiArNTQ3LDE0IEBAIGNsaV9hZGRfbWFwICh2b2lkICogdiwgY2hh
ciAqKiByZXBseSwgaW50ICogbGVuLCB2b2lkICogZGF0YSkKIAkJY29uZGxvZygyLCAiJXM6IG1h
cCBibGFja2xpc3RlZCIsIHBhcmFtKTsKIAkJcmV0dXJuIDA7CiAJfQorCXJjID0gZ2V0X3JlZnd3
aWQocGFyYW0sIERFVl9ERVZNQVAsIHZlY3MtPnBhdGh2ZWMsICZyZWZ3d2lkKTsKKworICAgICAg
ICBpZiAocmVmd3dpZCkgeworICAgICAgICAgICAgICAgIGNvbmRsb2coMiwgIiVzOiBhZGQgbWFw
IChvcGVyYXRvcikiLCByZWZ3d2lkKTsKKyAgICAgICAgICAgICAgICBpZihjb2FsZXNjZV9wYXRo
cyh2ZWNzLCBOVUxMLCByZWZ3d2lkLCAwKSkKKwkJCWNvbmRsb2coMiwgIiVzOiBjb2FsZXNjZS1w
YXRocyBmYWlsZWQiLCBwYXJhbSk7CisgICAgICAgICAgICAgICAgZG1fbGliX3JlbGVhc2UoKTsK
KyAgICAgICAgfQogCW1pbm9yID0gZG1fZ2V0X21pbm9yKHBhcmFtKTsKIAlpZiAobWlub3IgPCAw
KSB7CiAJCWNvbmRsb2coMiwgIiVzOiBub3QgYSBkZXZpY2UgbWFwcGVyIHRhYmxlIiwgcGFyYW0p
OwpAQCAtNTY2LDYgKzU3NCw3IEBAIGNsaV9hZGRfbWFwICh2b2lkICogdiwgY2hhciAqKiByZXBs
eSwgaW50ICogbGVuLCB2b2lkICogZGF0YSkKIAl9CiAJcmMgPSBldl9hZGRfbWFwKGRldl9wYXRo
LCBhbGlhcywgdmVjcyk7CiAJRlJFRShhbGlhcyk7CisJRlJFRShyZWZ3d2lkKTsKIAlyZXR1cm4g
cmM7CiB9CiAK
--001a1140fee6fb09b5051a5be5d4
Content-Type: text/x-patch; charset=US-ASCII; name="disable_code.patch"
Content-Disposition: attachment; filename="disable_code.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ibups7so1

Y29tbWl0IDkxMGI0YTgyZWM0ODNiNDhlYWY4YjI0ZWIzZDc4MjkyNzNjNjkwZWQKQXV0aG9yOiBU
ZWphc3dpbmkgPHRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPgpEYXRlOiAgIFdlZCBKdWwgOCAx
NzoxODowMyAyMDE1ICswNTMwCgogICAgbXVsdGlwYXRoZDogRGlzYWJsZWQgY29kZSB0aGF0IGlz
IG5vdCBiZWluZyB1c2VkLgogICAgCiAgICBUaGlzIHBhcnQgb2YgdGhlIGNvZGUgaXMgbW92ZWQg
dG8gY2xpX2FkZF9tYXAgYW5kCiAgICBkaXNhYmxlZCBoZXJlIGFzIGl0IGlzIG5vdCB1c2VkIGJ5
IGFueSBmdW5jdGlvbiBjYWxsCiAgICBoZXJlLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBUZWph
c3dpbmkgPHRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPgoKZGlmZiAtLWdpdCBhL211bHRpcGF0
aGQvbWFpbi5jIGIvbXVsdGlwYXRoZC9tYWluLmMKaW5kZXggZjg3NjI1OC4uMDYwMjM3YyAxMDA2
NDQKLS0tIGEvbXVsdGlwYXRoZC9tYWluLmMKKysrIGIvbXVsdGlwYXRoZC9tYWluLmMKQEAgLTMy
OSw2ICszMjksOCBAQCBldl9hZGRfbWFwIChjaGFyICogZGV2LCBjaGFyICogYWxpYXMsIHN0cnVj
dCB2ZWN0b3JzICogdmVjcykKIAkJCXJldHVybiAxOwogCQl9CiAJfQorI2lmIDAgLypEaXNhYmxl
ZCBhcyB0aGUgY29kZSBpcyBub3QgYmVpbmcgdXNlZCBieSBhbnlvbmUuCisJVE9ETzpjb25maXJt
IHRoYXQgbm8gZmVhdHVyZSByZXF1aXJlcyB0aGlzIGNvZGUqLwogCXIgPSBnZXRfcmVmd3dpZChk
ZXYsIERFVl9ERVZNQVAsIHZlY3MtPnBhdGh2ZWMsICZyZWZ3d2lkKTsKIAogCWlmIChyZWZ3d2lk
KSB7CkBAIC0zNDQsNiArMzQ2LDcgQEAgZXZfYWRkX21hcCAoY2hhciAqIGRldiwgY2hhciAqIGFs
aWFzLCBzdHJ1Y3QgdmVjdG9ycyAqIHZlY3MpCiAJCWNvbmRsb2coMCwgIiVzOiB1ZXZfYWRkX21h
cCAlcyBmYWlsZWQiLCBhbGlhcywgZGV2KTsKIAogCUZSRUUocmVmd3dpZCk7CisjZW5kaWYKIAly
ZXR1cm4gcjsKIH0KIAo=
--001a1140fee6fb09b5051a5be5d4
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--001a1140fee6fb09b5051a5be5d4--
