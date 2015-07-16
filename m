From: Tejaswini Poluri <tejaswinipoluri3@gmail.com>
Subject: Re: reinstate path not working
Date: Thu, 16 Jul 2015 16:07:10 +0530
Message-ID: <CAH=b03spLZwK_Ew72QNLueSg4M+bPFm9MiRVuJGyLYxttGwjQA@mail.gmail.com>
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
	<20150710160645.GR1409@octiron.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4457993821994707407=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150710160645.GR1409@octiron.msp.redhat.com>
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

--===============4457993821994707407==
Content-Type: multipart/alternative; boundary=001a113ec94e62f6f1051afba718

--001a113ec94e62f6f1051afba718
Content-Type: text/plain; charset=UTF-8

Thanks a lot for the inputs. Sorry for the delay in updating (Got struck
with other issues)

Here is the cli_add_map function with the suggested changes and it seems to
work fine. Please have a look and suggest your inputs.

int
cli_add_map (void * v, char ** reply, int * len, void * data)
{
        struct vectors * vecs = (struct vectors *)data;
        char * param = get_keyparam(v, MAP);
        int major, minor;
        char dev_path[PATH_SIZE];
        char *alias;
        int rc;
        char *refwwid;
        param = convert_dev(param, 0);
        condlog(2, "%s: add map (operator)", param);

if (filter_wwid(conf->blist_wwid, conf->elist_wwid, param, NULL)>0)       {
                *reply = strdup("blacklisted\n");
                *len = strlen(*reply) + 1;
                condlog(2, "%s: map blacklisted", param);
                return 0;
 }

mapname:
        minor = dm_get_minor(param);
        if (minor < 0) {
                condlog(2, "%s: not a device mapper table", param);
                //return 0;
        }
        major = dm_get_major(param);
        if (major < 0) {
                condlog(2, "%s: not a device mapper table", param);
                //return 0;
        }
        sprintf(dev_path,"dm-%d", minor);
        alias = dm_mapname(major, minor);
        if (!alias) {
                condlog(2, "%s: mapname not found for %d:%d",
                        param, major, minor);
                rc = get_refwwid(param, DEV_DEVMAP, vecs->pathvec,
&refwwid);
                if (refwwid) {
                        condlog(2, "%s: add map (operator)", refwwid);
                        if(coalesce_paths(vecs, NULL, refwwid, 0))
                                condlog(2, "%s: coalesce-paths failed",
param);
                       dm_lib_release();
                }
                goto mapname;

                //return 0;
        }
        rc = ev_add_map(dev_path, alias, vecs);
        FREE(alias);
        FREE(refwwid);
        return rc;
}

Regards,
Tejaswini


On Fri, Jul 10, 2015 at 9:36 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Wed, Jul 08, 2015 at 05:31:26PM +0530, Tejaswini Poluri wrote:
> >    Thanks a lot.
> >    Can you guide me how to push upstream for the approval. Which branch
> >    should I push to? Any list of testcases I should perform before I
> could
> >    push?
>
> All you do is post it to dm-devel.  I think it's easier for Christophe
> to pull the patches in, if you post them directly in the email. "git
> format-patch" and "git send-email" make this a lot faster.
>
> Please do whatever testing you feel is appropriate before posting.
>
> About the patches specifically: In cli_add_map(), wouldn't it make more
> sense to only do the coalesce_paths() if dm_mapname() fails. If it
> succeeds you clearly already have an existing map, so you don't need to
> create one.
>
> -Ben
>
> >    I have created the following two patches. PFA
> >    Regards,
> >    Tejaswini
> >    On Mon, Jul 6, 2015 at 11:15 PM, Benjamin Marzinski
> >    <[1]bmarzins@redhat.com> wrote:
> >
> >      On Tue, Jun 30, 2015 at 11:22:37AM +0530, Tejaswini Poluri wrote:
> >      >    Thanks Ben. So should I push the code to the upstream and get
> an
> >      approval?
> >      >    Regards,
> >
> >      Yes. Thanks!
> >
> >      -Ben
> >      >    Tejaswini
> >      >    On Tue, Jun 30, 2015 at 12:50 AM, Benjamin Marzinski
> >      >    <[1][2]bmarzins@redhat.com> wrote:
> >      >
> >      >      On Fri, Jun 26, 2015 at 12:21:48PM +0530, Tejaswini Poluri
> wrote:
> >      >      >    Yes I agree that having the same code in both
> cli_add_map()
> >      and
> >      >      ev_add_map
> >      >      >    is not necessary. Hence I would suggest removing
> >      get_refwwid() code
> >      >      from
> >      >      >    ev_add_map as it is not being used by anyone.
> >      >      >
> >      >      >    ev_add_map(param, NULL, vecs) would create the multipath
> >      device by
> >      >      using
> >      >      >    the get_refwwid() code and but all the functions above
> it
> >      like
> >      >      >    (dm_get_minor, dm_get_major and dm_mapname) would fail
> and
> >      it
> >      >      wouldn't
> >      >      >    enter any of the other code in ev_add_map like
> >      >      >    1.dm_map_present,
> >      >      >    2.add_map_without_path
> >      >      >    3. sync_map_state
> >      >      >    which are responsible for registering the map and
> displaying
> >      it.
> >      >      >
> >      >      >    So, I think moving the below code from ev_add_map to
> >      cli_add_map
> >      >      should be
> >      >      >    a good idea right.
> >      >      >
> >      >      >    r = get_refwwid(dev, DEV_DEVMAP,
> vecs->pathvec,&refwwid);
> >      >      >    >
> >      >      >    >            if (refwwid) {
> >      >      >    >                    r = coalesce_paths(vecs, NULL,
> >      refwwid,0);
> >      >      >    >                    dm_lib_release();
> >      >      >    >            }
> >      >      >    What do u think?
> >      >
> >      >      I agree. We aren't using the code in ev_add_map, so it's
> presence
> >      there
> >      >      is simply confusing.
> >      >
> >      >      -Ben
> >      >      >
> >      >      >    Regards,
> >      >      >    Tejaswini
> >      >      >    On Fri, Jun 26, 2015 at 4:32 AM, Benjamin Marzinski
> >      >      >    <[1][2][3]bmarzins@redhat.com> wrote:
> >      >      >
> >      >      >      On Tue, Jun 23, 2015 at 03:48:26PM +0530, Tejaswini
> Poluri
> >      wrote:
> >      >      >      >    Hi Ben,
> >      >      >      >
> >      >      >      >    This is regarding the add map issue I have been
> >      discussing.
> >      >      Posting
> >      >      >      the
> >      >      >      >    issue again to remind.
> >      >      >      >
> >      >      >      >    Case 1 : remove and add map.
> >      >      >      >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >      >      >    name    sysfs uuid
> >      >      >      >    dmpath0 dm-0  1IET_00010001
> >      >      >      >    root@x86-generic-64:~# multipathd -k'remove map
> >      dmpath0'
> >      >      >      >    ok
> >      >      >      >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >      >      >    root@x86-generic-64:~# multipathd -k'add map
> dmpath0'
> >      >      >      >    ok
> >      >      >      >    root@x86-generic-64:~# multipathd -k'show maps'
> >      >      >      >    root@x86-generic-64:~#
> >      >      >      >    Once a map is removed, we are able to add it only
> >      using
> >      >      #multipath
> >      >      >      >    command and not using multipathd tools.
> >      >      >      >
> >      >      >      >    I have fixed the problem with two approaches. I
> would
> >      like
> >      >      you to
> >      >      >      review
> >      >      >      >    the same.
> >      >      >      >    Patch1 : By making 'remove map dmpath0' to remove
> >      only the
> >      >      map and
> >      >      >      not the
> >      >      >      >    device. I have added extra functions discard_map
> and
> >      >      dm_remove_map
> >      >      >      so as
> >      >      >      >    to not interfere with the existing code.
> >      >      >      >
> >      >      >      >    Patch 2: The approach you have suggested.By
> getting
> >      wwid
> >      >      from the
> >      >      >      mapname
> >      >      >      >    and doing coalesce_paths. I have just moved the
> >      following
> >      >      code in
> >      >      >      >    ev_add_map to cli_add_map.
> >      >      >
> >      >      >      This is the general idea we'd like to go with.
> However,
> >      looking
> >      >      at the
> >      >      >      latest upstream code, I don't think you should pull
> code
> >      in from
> >      >      >      ev_add_map() to cli_add_map() like your patch does.
> >      cli_add_map()
> >      >      >      already calls ev_add_map(), and ev_add_map() is
> certainly
> >      able to
> >      >      add
> >      >      >      the map if it doesn't already exist.
> >      >      >
> >      >      >      You would just need to call it with
> >      >      >
> >      >      >      ev_add_map(param, NULL, vecs);
> >      >      >
> >      >      >      and ev_add_map() will happily create you a new
> multipath
> >      device.
> >      >      All
> >      >      >      you need to do is make sure that all the functions
> that
> >      >      ev_add_map()
> >      >      >      calls with alias can accept a NULL value there.
> >      >      >
> >      >      >      This might not be the best way to go about this,
> however.
> >      It
> >      >      turns out
> >      >      >      that right now, even though ev_add_map() technically
> has
> >      the
> >      >      ability to
> >      >      >      create new maps, nothing currently uses it, and it
> really
> >      doesn't
> >      >      make
> >      >      >      sense for it to be there. Instead of just copying that
> >      code, you
> >      >      could
> >      >      >      pull the map creation code out of ev_add_map() and
> add it
> >      to
> >      >      >      cli_add_map(), for those situations where the
> requested
> >      device
> >      >      doesn't
> >      >      >      already exist.
> >      >      >
> >      >      >      But having the code in both cli_add_map() and
> ev_add_map()
> >      when
> >      >      one
> >      >      >      already calls the other doesn't seem necessary.
> >      >      >
> >      >      >      -Ben
> >      >      >
> >      >      >      >
> >      >      >      >    r = get_refwwid(dev, DEV_DEVMAP,
> >      vecs->pathvec,&refwwid);
> >      >      >      >
> >      >      >      >            if (refwwid) {
> >      >      >      >                    r = coalesce_paths(vecs, NULL,
> >      refwwid,0);
> >      >      >      >                    dm_lib_release();
> >      >      >      >            }
> >      >      >      >
> >      >      >      >    changed dev to param.
> >      >      >      >
> >      >      >      >    I have tested the same in all 3 versions -0.4.8,
> >      0.4.9 and
> >      >      0.5.0.
> >      >      >      It would
> >      >      >      >    be great if you can review the same so that it
> >      doesn't cause
> >      >      any
> >      >      >      extra
> >      >      >      >    side effects.
> >      >      >      >    I guess Patch2 is the way u have suggested me in
> the
> >      >      previous mail.
> >      >      >      Please
> >      >      >      >    review it and share your views.
> >      >      >      >    Regards,
> >      >      >      >    Tejaswini
> >      >      >      >    On Fri, Jun 12, 2015 at 2:21 AM, Benjamin
> Marzinski
> >      >      >      >    <[1][2][3][4]bmarzins@redhat.com> wrote:
> >      >      >      >
> >      >      >      >      On Wed, Jun 10, 2015 at 11:46:51AM +0530,
> Tejaswini
> >      Poluri
> >      >      wrote:
> >      >      >      >      >
> >      >      >      >      >    >    We are testing multipathd tools with
> all
> >      the
> >      >      possible
> >      >      >      options
> >      >      >      >      and the
> >      >      >      >      >    >    following fails.
> >      >      >      >      >    >
> >      >      >      >      >    >    Case 1 : remove and add map.
> >      >      >      >      >    >    root@x86-generic-64:~# multipathd
> -k'show
> >      maps'
> >      >      >      >      >    >    name    sysfs uuid
> >      >      >      >      >    >    dmpath0 dm-0  1IET_00010001
> >      >      >      >      >    >    root@x86-generic-64:~# multipathd
> >      -k'remove map
> >      >      >      dmpath0'
> >      >      >      >      >    >    ok
> >      >      >      >      >    >    root@x86-generic-64:~# multipathd
> -k'show
> >      maps'
> >      >      >      >      >    >    root@x86-generic-64:~# multipathd
> -k'add
> >      map
> >      >      dmpath0'
> >      >      >      >      >    >    ok
> >      >      >      >      >    >    root@x86-generic-64:~# multipathd
> -k'show
> >      maps'
> >      >      >      >      >    >    root@x86-generic-64:~#
> >      >      >      >      >    >    Once a map is removed, we are able
> to add
> >      it
> >      >      only using
> >      >      >      >      #multipath
> >      >      >      >      >    >    command and not using multipathd
> tools.
> >      >      >      >      >
> >      >      >      >      >    It is working the way it was designed, but
> >      possibly
> >      >      it would
> >      >      >      make
> >      >      >      >      sense
> >      >      >      >      >    to change the design.
> >      >      >      >      >
> >      >      >      >      >    You have mentioned that it would make
> sense to
> >      change
> >      >      the
> >      >      >      design to
> >      >      >      >      add
> >      >      >      >      >    map. Are there plans to change the design
> ?
> >      >      >      >      >    I am trying to understand the code flow to
> >      change the
> >      >      >      design. Can
> >      >      >      >      you
> >      >      >      >      >    guide me if we should stop removing the
> device
> >      from
> >      >      in the
> >      >      >      remove
> >      >      >      >      map code
> >      >      >      >      >    flow or start adding the device and the
> map in
> >      the
> >      >      add map
> >      >      >      code
> >      >      >      >      flow.
> >      >      >      >      >
> >      >      >      >      >     have tried to understand the remove map
> code
> >      flow of
> >      >      >      multipathd in
> >      >      >      >      0.4.8
> >      >      >      >      >    code.
> >      >      >      >
> >      >      >      >      I think that we want multipath to actually
> remove
> >      the map
> >      >      >      (instead of
> >      >      >      >      just not monitoring it) when you call "remove
> map
> >      <map>".
> >      >      We just
> >      >      >      want
> >      >      >      >      "add map <map>" to try to create the map if it
> >      doesn't
> >      >      exist.  To
> >      >      >      do
> >      >      >      >      that, you would need to first firgure out what
> WWID
> >      is
> >      >      associated
> >      >      >      with
> >      >      >      >      <map>. Presumably, <map> could either be an
> alias,
> >      wwid,
> >      >      or even
> >      >      >      the
> >      >      >      >      name of a path in the map. Once you found the
> map,
> >      you
> >      >      would have
> >      >      >      to
> >      >      >      >      call the code to create the map.
> >      >      >      >
> >      >      >      >      Also, to answer your IRC question, no the 0.4.8
> >      code is
> >      >      not still
> >      >      >      being
> >      >      >      >      developed upstream.  All upstream patches only
> go
> >      against
> >      >      the
> >      >      >      current
> >      >      >      >      head. There are no other upstream branches.
> >      >      >      >
> >      >      >      >      -Ben
> >      >      >      >      >
> >      >      >      >      >    ev_remove_map (char * devname, struct
> vectors
> >      * vecs)
> >      >      >      >      >
> >      >      >      >      >              flush_map(mpp, vecs);
> >      >      >      >      >
> >      >      >      >      >
> >      dm_flush_map(mpp->alias,
> >      >      >      DEFAULT_TARGET);
> >      >      >      >      >
> >      >      >      >      >                                     if
> >      >      >      (!dm_map_present(mapname))
> >      >      >      >      >
> >      >      >      >      >
> return
> >      0;
> >      >      >      >      >
> >      >      >      >      >           if (dm_type(mapname, type) <= 0)
> >      >      >      >      >
> >      >      >      >      >                   return 1;
> >      >      >      >      >
> >      >      >      >      >           if (dm_remove_partmaps(mapname))
> >      >      >      >      >
> >      >      >      >      >                   return 1;
> >      >      >      >      >
> >      >      >      >      >           if (dm_get_opencount(mapname)) {
> >      >      >      >      >
> >      >      >      >      >                   condlog(2, "%s: map in
> use",
> >      mapname);
> >      >      >      >      >
> >      >      >      >      >                   return 1;
> >      >      >      >      >
> >      >      >      >      >           }
> >      >      >      >      >
> >      >      >      >      >           r = dm_simplecmd(DM_DEVICE_REMOVE,
> >      mapname);
> >      >      >      >      >
> >      >      >      >      >           if (r) {
> >      >      >      >      >
> >      >      >      >      >                   condlog(4, "multipath map
> %s
> >      removed",
> >      >      >      mapname);
> >      >      >      >      >
> >      >      >      >      >
>
> >      return
> >      >      0;
> >      >      >      >      >
> >      >      >      >      >                                           }
> >      >      >      >      >
> >      >      >      >      >
> >      >      >      >      >
> >      >      >      >      >
> >      orphan_paths(vecs->pathvec,
> >      >      mpp);
> >      >      >      >      >
> >      >      >      >      >                            remove_map(mpp,
> vecs,
> >      >      >      stop_waiter_thread,
> >      >      >      >      1);
> >      >      >      >      >
> >      >      >      >      >    Is removing this below line, the right
> step to
> >      stop
> >      >      removing
> >      >      >      the
> >      >      >      >      device ?
> >      >      >      >      >    r = dm_simplecmd(DM_DEVICE_REMOVE,
> mapname);
> >      >      >      >      >
> >      >      >      >      >    Regards,
> >      >      >      >      >
> >      >      >      >      >    Tejaswini
> >      >      >      >      >
> >      >      >      >      >    On Mon, Jun 8, 2015 at 11:15 AM, Tejaswini
> >      Poluri
> >      >      >      >      >    <[1][2][3][4][5]
> tejaswinipoluri3@gmail.com>
> >      wrote:
> >      >      >      >      >
> >      >      >      >      >      Thanks a lot Ben for the quick and
> detailed
> >      reply.
> >      >      I have
> >      >      >      been
> >      >      >      >      >      struggling to understand and conclude
> the
> >      issues
> >      >      with
> >      >      >      multipath
> >      >      >      >      as I am
> >      >      >      >      >      the only one working from my team. Your
> >      inputs help
> >      >      me a
> >      >      >      lot.
> >      >      >      >      Thanks
> >      >      >      >      >      again.
> >      >      >      >      >      Regards,
> >      >      >      >      >      Tejaswini
> >      >      >      >      >      On Sat, Jun 6, 2015 at 3:36 AM, Benjamin
> >      Marzinski
> >      >      >      >      >      <[2][3][4][5][6]bmarzins@redhat.com>
> wrote:
> >      >      >      >      >
> >      >      >      >      >        On Fri, Jun 05, 2015 at 02:31:20PM
> +0530,
> >      >      Tejaswini
> >      >      >      Poluri
> >      >      >      >      wrote:
> >      >      >      >      >        >    Hii Ben,
> >      >      >      >      >        >
> >      >      >      >      >        >    We are testing multipathd tools
> with
> >      all the
> >      >      >      possible
> >      >      >      >      options and
> >      >      >      >      >        the
> >      >      >      >      >        >    following fails.
> >      >      >      >      >        >
> >      >      >      >      >        >    Case 1 : remove and add map.
> >      >      >      >      >        >    root@x86-generic-64:~#
> multipathd
> >      -k'show
> >      >      maps'
> >      >      >      >      >        >    name    sysfs uuid
> >      >      >      >      >        >    dmpath0 dm-0  1IET_00010001
> >      >      >      >      >        >    root@x86-generic-64:~#
> multipathd
> >      -k'remove
> >      >      map
> >      >      >      dmpath0'
> >      >      >      >      >        >    ok
> >      >      >      >      >        >    root@x86-generic-64:~#
> multipathd
> >      -k'show
> >      >      maps'
> >      >      >      >      >        >    root@x86-generic-64:~#
> multipathd
> >      -k'add map
> >      >      >      dmpath0'
> >      >      >      >      >        >    ok
> >      >      >      >      >        >    root@x86-generic-64:~#
> multipathd
> >      -k'show
> >      >      maps'
> >      >      >      >      >        >    root@x86-generic-64:~#
> >      >      >      >      >        >    Once a map is removed, we are
> able to
> >      add it
> >      >      only
> >      >      >      using
> >      >      >      >      >        #multipath
> >      >      >      >      >        >    command and not using multipathd
> >      tools.
> >      >      >      >      >
> >      >      >      >      >        It is working the way it was
> designed, but
> >      >      possibly it
> >      >      >      would
> >      >      >      >      make
> >      >      >      >      >        sense
> >      >      >      >      >        to change the design.  The "remove
> map"
> >      command,
> >      >      not
> >      >      >      only stops
> >      >      >      >      >        multipathd from monitoring the
> multipath
> >      device,
> >      >      but it
> >      >      >      removes
> >      >      >      >      it
> >      >      >      >      >        from
> >      >      >      >      >        the system as well.  The "add map"
> command
> >      makes
> >      >      >      multipath
> >      >      >      >      monitor an
> >      >      >      >      >        already existing multipath device
> that in
> >      wasn't
> >      >      >      previously
> >      >      >      >      >        monitoring.
> >      >      >      >      >        These commands do this for historical
> >      reasons.
> >      >      >      multipathd
> >      >      >      >      wasn't
> >      >      >      >      >        originally in charge of creating
> multipath
> >      >      devices,
> >      >      >      multipath
> >      >      >      >      was.
> >      >      >      >      >        Once
> >      >      >      >      >        it had created the device, it ran
> >      >      >      >      >
> >      >      >      >      >        multipathd -k"add map <MAP>"
> >      >      >      >      >
> >      >      >      >      >        to make multipathd start monitoring
> it.
> >      However
> >      >      things
> >      >      >      haven't
> >      >      >      >      worked
> >      >      >      >      >        this way since RHEL4, so possibly "add
> >      map"
> >      >      should
> >      >      >      actually
> >      >      >      >      create the
> >      >      >      >      >        device if it doesn't currently exist.
> >      >      >      >      >        >    Case 2 : Active paths  test case
> >      >      >      >      >        >    # while true ; do sleep 3 ;
> >      multipathd
> >      >      -k'remove
> >      >      >      path sdb'
> >      >      >      >      ;
> >      >      >      >      >        multipathd
> >      >      >      >      >        >    -k'add path sdb' ; multipathd
> -k'show
> >      maps
> >      >      status'
> >      >      >      ; done
> >      >      >      >      >        >    ok
> >      >      >      >      >        >    ok
> >      >      >      >      >        >    name failback queueing paths
> dm-st
> >      >      >      >      >        >    dmpath0 - - 1 active // It
> should be
> >      2.
> >      >      >      >      >
> >      >      >      >      >        This is simply a timing issue.  What
> you
> >      are
> >      >      seeing it
> >      >      >      the
> >      >      >      >      number of
> >      >      >      >      >        active paths.  These are paths that
> the
> >      kernel
> >      >      can use.
> >      >      >      The
> >      >      >      >      "add path"
> >      >      >      >      >        command doesn't update the kernel
> state.
> >      This
> >      >      happens
> >      >      >      later in
> >      >      >      >      >        response
> >      >      >      >      >        to the kernel reloading the device
> table.
> >      So, in
> >      >      a
> >      >      >      second or
> >      >      >      >      two, this
> >      >      >      >      >        will say 2, as expected.
> >      >      >      >      >
> >      >      >      >      >        >    We would like to know if the test
> >      cases are
> >      >      valid
> >      >      >      and if
> >      >      >      >      these
> >      >      >      >      >        are bugs or
> >      >      >      >      >        >    any design issues.
> >      >      >      >      >        >
> >      >      >      >      >        >    Case 3 : Fail path and reinstate
> path
> >      >      >      >      >        >    root@x86-generic-64:~#
> multipathd
> >      -k"fail
> >      >      path
> >      >      >      sdc";
> >      >      >      >      multipathd
> >      >      >      >      >        >    -k'reinstate path sdc';
> multipathd
> >      -k"show
> >      >      paths";
> >      >      >      >      >        >    >    [ 3962.708523]
> device-mapper:
> >      >      multipath:
> >      >      >      Failing path
> >      >      >      >      8:32.
> >      >      >      >      >        >    >    ok
> >      >      >      >      >        >    >    ok
> >      >      >      >      >        >    >    hcil    dev dev_t pri
> dm_st
> >      chk_st
> >      >      >      next_check
> >      >      >      >      >        >    >    4:0:0:1 sdc 8:32  1
> >      [active][faulty]
> >      >      >      ..........
> >      >      >      >      1/20
> >      >      >      >      >        <==CHECK
> >      >      >      >      >        >    >    5:0:0:1 sdd 8:48  1
> >      [active][ready]
> >      >      >      XX........
> >      >      >      >      4/20
> >      >      >      >      >        >    sdc path becomes [active][ready]
> only
> >      after
> >      >      the
> >      >      >      polling
> >      >      >      >      interval
> >      >      >      >      >        but not
> >      >      >      >      >        >    immediately after the reinstate
> path
> >      >      command.
> >      >      >      >      >        >    You have answered that this is a
> >      design
> >      >      issue. But
> >      >      >      we have
> >      >      >      >      heard
> >      >      >      >      >        from our
> >      >      >      >      >        >    test team that the same test case
> >      works in
> >      >      RHEL6.
> >      >      >      Did you
> >      >      >      >      observe
> >      >      >      >      >        it?
> >      >      >      >      >        >    I am also finding that the test
> cases
> >      fail
> >      >      because
> >      >      >      we are
> >      >      >      >      trying
> >      >      >      >      >        to do
> >      >      >      >      >        >    multiple commands at one shot.
> >      Please share
> >      >      your
> >      >      >      thoughts
> >      >      >      >      so
> >      >      >      >      >        that it
> >      >      >      >      >        >    could help me in debugging the
> issues
> >      >      further.
> >      >      >      >      >        >
> >      >      >      >      >
> >      >      >      >      >        It's totally possible that the checker
> >      state is
> >      >      >      immediately
> >      >      >      >      updated in
> >      >      >      >      >        RHEL6.  Like I said before, what it
> >      currently
> >      >      does,
> >      >      >      although
> >      >      >      >      correct,
> >      >      >      >      >        is confusing, and perhaps we need a
> >      different
> >      >      checker
> >      >      >      state for
> >      >      >      >      paths
> >      >      >      >      >        where the "fail path" command has been
> >      used.
> >      >      >      >      >
> >      >      >      >      >        -Ben
> >      >      >      >      >        >    Regards,
> >      >      >      >      >        >    Tejaswini
> >      >      >      >      >        >    On Tue, May 19, 2015 at 5:37 PM,
> >      Tejaswini
> >      >      Poluri
> >      >      >      >      >        >
> >      <[1][3][4][5][6][7]tejaswinipoluri3@gmail.com>
> >      >      wrote:
> >      >      >      >      >        >
> >      >      >      >      >        >      Thanks a lot Ben. I will look
> into
> >      it
> >      >      more.
> >      >      >      >      >        >      On Mon, May 18, 2015 at 9:57
> PM,
> >      Benjamin
> >      >      >      Marzinski
> >      >      >      >      >        >
> >      <[2][4][5][6][7][8]bmarzins@redhat.com>
> >      >      wrote:
> >      >      >      >      >        >
> >      >      >      >      >        >        On Mon, May 18, 2015 at
> >      02:09:27PM
> >      >      +0530,
> >      >      >      Tejaswini
> >      >      >      >      Poluri
> >      >      >      >      >        wrote:
> >      >      >      >      >        >        >    Hii,
> >      >      >      >      >        >        >    We are trying to test
> >      multipath
> >      >      setup in
> >      >      >      our
> >      >      >      >      target and
> >      >      >      >      >        tried the
> >      >      >      >      >        >        various
> >      >      >      >      >        >        >    commands of multipathd
> >      demaon and
> >      >      we find
> >      >      >      the
> >      >      >      >      following
> >      >      >      >      >        error:
> >      >      >      >      >        >        >    root@x86-generic-64:~#
> >      multipathd
> >      >      -k"fail
> >      >      >      path
> >      >      >      >      sdc";
> >      >      >      >      >        multipathd
> >      >      >      >      >        >        >    -k'reinstate path
> >      >      >      >      >        >        >    sdc'; multipathd -k"show
> >      paths";
> >      >      >      >      >        >        >    [ 3962.708523]
> >      device-mapper:
> >      >      multipath:
> >      >      >      Failing
> >      >      >      >      >        path 8:32.
> >      >      >      >      >        >        >    ok
> >      >      >      >      >        >        >    ok
> >      >      >      >      >        >        >    hcil    dev dev_t pri
> dm_st
> >      >       chk_st
> >      >      >       next_check
> >      >      >      >      >        >        >    4:0:0:1 sdc 8:32  1
> >      >       [active][faulty]
> >      >      >      ..........
> >      >      >      >      1/20
> >      >      >      >      >          <<<===
> >      >      >      >      >        >        CHECK
> >      >      >      >      >        >        >    5:0:0:1 sdd 8:48  1
> >      >       [active][ready]
> >      >      >      XX........
> >      >      >      >      4/20
> >      >      >      >      >        >        >    sdc path becomes
> >      [active][ready]
> >      >      only
> >      >      >      after the
> >      >      >      >      polling
> >      >      >      >      >        interval
> >      >      >      >      >        >        but not
> >      >      >      >      >        >        >    immediately after the
> >      reinstate
> >      >      path
> >      >      >      command.
> >      >      >      >      >        >        >    I am observing this in
> >      latest
> >      >      multipath
> >      >      >      tools in
> >      >      >      >      ubuntu
> >      >      >      >      >        machine
> >      >      >      >      >        >        as well.
> >      >      >      >      >        >        >    Please let me know if
> its a
> >      known
> >      >      issue or
> >      >      >      if I
> >      >      >      >      am doing
> >      >      >      >      >        >        something wrong.
> >      >      >      >      >        >        >    Regards.
> >      >      >      >      >        >        >    Tejaswini
> >      >      >      >      >        >
> >      >      >      >      >        >        the reinstate command is
> supposed
> >      to
> >      >      reinstate
> >      >      >      the
> >      >      >      >      device
> >      >      >      >      >        with the
> >      >      >      >      >        >        kernel, and it does that. The
> >      checker
> >      >      state
> >      >      >      doesn't
> >      >      >      >      change
> >      >      >      >      >        until the
> >      >      >      >      >        >        next time that the path is
> >      checked.  I
> >      >      agree
> >      >      >      that it's
> >      >      >      >      odd
> >      >      >      >      >        that the
> >      >      >      >      >        >        check state switches to
> faulty as
> >      soon
> >      >      as you
> >      >      >      fail the
> >      >      >      >      path,
> >      >      >      >      >        but it
> >      >      >      >      >        >        doesn't switch back until the
> >      next check
> >      >      after
> >      >      >      you
> >      >      >      >      reinistate
> >      >      >      >      >        it.
> >      >      >      >      >        >
> >      >      >      >      >        >        The issue is that multipathd
> >      needs to
> >      >      override
> >      >      >      the
> >      >      >      >      checker
> >      >      >      >      >        output,
> >      >      >      >      >        >        so that a failed path won't
> be
> >      >      immeditately
> >      >      >      >      reinstated.  Once
> >      >      >      >      >        the
> >      >      >      >      >        >        path comes back, multipathd
> wants
> >      to
> >      >      record the
> >      >      >      switch
> >      >      >      >      in the
> >      >      >      >      >        checker
> >      >      >      >      >        >        thread, so that it can
> refresh
> >      path
> >      >      information
> >      >      >      what
> >      >      >      >      wasn't
> >      >      >      >      >        >        automatically done when the
> path
> >      was
> >      >      >      reinstated.
> >      >      >      >      However, it
> >      >      >      >      >        may make
> >      >      >      >      >        >        more sense to have a
> different
> >      checker
> >      >      state
> >      >      >      for when
> >      >      >      >      the
> >      >      >      >      >        device is
> >      >      >      >      >        >        in the failed state, so that
> it's
> >      >      obvious that
> >      >      >      the
> >      >      >      >      checker
> >      >      >      >      >        state is
> >      >      >      >      >        >        being overruled.
> >      >      >      >      >        >
> >      >      >      >      >        >        -Ben
> >      >      >      >      >        >
> >      >      >      >      >        >        > --
> >      >      >      >      >        >        > dm-devel mailing list
> >      >      >      >      >        >        >
> >      [3][5][6][7][8][9]dm-devel@redhat.com
> >      >      >      >      >        >        >
> >      >      >      >
> >      >
> >      [4][6][7][8][9][10]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >      >        >
> >      >      >      >      >        >        --
> >      >      >      >      >        >        dm-devel mailing list
> >      >      >      >      >        >
> >      [5][7][8][9][10][11]dm-devel@redhat.com
> >      >      >      >      >        >
> >      >      >      >
> >      >
> >      [6][8][9][10][11][12]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >      >        >
> >      >      >      >      >        > References
> >      >      >      >      >        >
> >      >      >      >      >        >    Visible links
> >      >      >      >      >        >    1.
> >      >      mailto:[9][10][11][12][13]tejaswinipoluri3@gmail.com
> >      >      >      >      >        >    2.
> >      >      mailto:[10][11][12][13][14]bmarzins@redhat.com
> >      >      >      >      >        >    3.
> >      >      mailto:[11][12][13][14][15]dm-devel@redhat.com
> >      >      >      >      >        >    4.
> >      >      >      >
> >      >
> >      [12][13][14][15][16]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >      >        >    5.
> >      >      mailto:[13][14][15][16][17]dm-devel@redhat.com
> >      >      >      >      >        >    6.
> >      >      >      >
> >      >
> >      [14][15][16][17][18]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >      >
> >      >      >      >      > References
> >      >      >      >      >
> >      >      >      >      >    Visible links
> >      >      >      >      >    1.
> >      mailto:[16][17][18][19]tejaswinipoluri3@gmail.com
> >      >      >      >      >    2. mailto:[17][18][19][20]
> bmarzins@redhat.com
> >      >      >      >      >    3.
> >      mailto:[18][19][20][21]tejaswinipoluri3@gmail.com
> >      >      >      >      >    4. mailto:[19][20][21][22]
> bmarzins@redhat.com
> >      >      >      >      >    5. mailto:[20][21][22][23]
> dm-devel@redhat.com
> >      >      >      >      >    6.
> >      >      [21][22][23][24]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >      >    7. mailto:[22][23][24][25]
> dm-devel@redhat.com
> >      >      >      >      >    8.
> >      >      [23][24][25][26]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >      >    9.
> >      mailto:[24][25][26][27]tejaswinipoluri3@gmail.com
> >      >      >      >      >   10. mailto:[25][26][27][28]
> bmarzins@redhat.com
> >      >      >      >      >   11. mailto:[26][27][28][29]
> dm-devel@redhat.com
> >      >      >      >      >   12.
> >      >      [27][28][29][30]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >      >   13. mailto:[28][29][30][31]
> dm-devel@redhat.com
> >      >      >      >      >   14.
> >      >      [29][30][31][32]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >
> >      >      >      > References
> >      >      >      >
> >      >      >      >    Visible links
> >      >      >      >    1. mailto:[31][32][33]bmarzins@redhat.com
> >      >      >      >    2. mailto:[32][33][34]tejaswinipoluri3@gmail.com
> >      >      >      >    3. mailto:[33][34][35]bmarzins@redhat.com
> >      >      >      >    4. mailto:[34][35][36]tejaswinipoluri3@gmail.com
> >      >      >      >    5. mailto:[35][36][37]bmarzins@redhat.com
> >      >      >      >    6. mailto:[36][37][38]dm-devel@redhat.com
> >      >      >      >    7.
> >      [37][38][39]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >    8. mailto:[38][39][40]dm-devel@redhat.com
> >      >      >      >    9.
> >      [39][40][41]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >   10. mailto:[40][41][42]tejaswinipoluri3@gmail.com
> >      >      >      >   11. mailto:[41][42][43]bmarzins@redhat.com
> >      >      >      >   12. mailto:[42][43][44]dm-devel@redhat.com
> >      >      >      >   13.
> >      [43][44][45]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >   14. mailto:[44][45][46]dm-devel@redhat.com
> >      >      >      >   15.
> >      [45][46][47]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >   16. mailto:[46][47][48]tejaswinipoluri3@gmail.com
> >      >      >      >   17. mailto:[47][48][49]bmarzins@redhat.com
> >      >      >      >   18. mailto:[48][49][50]tejaswinipoluri3@gmail.com
> >      >      >      >   19. mailto:[49][50][51]bmarzins@redhat.com
> >      >      >      >   20. mailto:[50][51][52]dm-devel@redhat.com
> >      >      >      >   21.
> >      [51][52][53]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >   22. mailto:[52][53][54]dm-devel@redhat.com
> >      >      >      >   23.
> >      [53][54][55]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >   24. mailto:[54][55][56]tejaswinipoluri3@gmail.com
> >      >      >      >   25. mailto:[55][56][57]bmarzins@redhat.com
> >      >      >      >   26. mailto:[56][57][58]dm-devel@redhat.com
> >      >      >      >   27.
> >      [57][58][59]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >      >   28. mailto:[58][59][60]dm-devel@redhat.com
> >      >      >      >   29.
> >      [59][60][61]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >
> >      >      > References
> >      >      >
> >      >      >    Visible links
> >      >      >    1. mailto:[61][62]bmarzins@redhat.com
> >      >      >    2. mailto:[62][63]bmarzins@redhat.com
> >      >      >    3. mailto:[63][64]tejaswinipoluri3@gmail.com
> >      >      >    4. mailto:[64][65]bmarzins@redhat.com
> >      >      >    5. mailto:[65][66]tejaswinipoluri3@gmail.com
> >      >      >    6. mailto:[66][67]bmarzins@redhat.com
> >      >      >    7. mailto:[67][68]dm-devel@redhat.com
> >      >      >    8. [68][69]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >    9. mailto:[69][70]dm-devel@redhat.com
> >      >      >   10. [70][71]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   11. mailto:[71][72]tejaswinipoluri3@gmail.com
> >      >      >   12. mailto:[72][73]bmarzins@redhat.com
> >      >      >   13. mailto:[73][74]dm-devel@redhat.com
> >      >      >   14. [74][75]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   15. mailto:[75][76]dm-devel@redhat.com
> >      >      >   16. [76][77]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   17. mailto:[77][78]tejaswinipoluri3@gmail.com
> >      >      >   18. mailto:[78][79]bmarzins@redhat.com
> >      >      >   19. mailto:[79][80]tejaswinipoluri3@gmail.com
> >      >      >   20. mailto:[80][81]bmarzins@redhat.com
> >      >      >   21. mailto:[81][82]dm-devel@redhat.com
> >      >      >   22. [82][83]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   23. mailto:[83][84]dm-devel@redhat.com
> >      >      >   24. [84][85]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   25. mailto:[85][86]tejaswinipoluri3@gmail.com
> >      >      >   26. mailto:[86][87]bmarzins@redhat.com
> >      >      >   27. mailto:[87][88]dm-devel@redhat.com
> >      >      >   28. [88][89]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   29. mailto:[89][90]dm-devel@redhat.com
> >      >      >   30. [90][91]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   31. mailto:[91][92]bmarzins@redhat.com
> >      >      >   32. mailto:[92][93]tejaswinipoluri3@gmail.com
> >      >      >   33. mailto:[93][94]bmarzins@redhat.com
> >      >      >   34. mailto:[94][95]tejaswinipoluri3@gmail.com
> >      >      >   35. mailto:[95][96]bmarzins@redhat.com
> >      >      >   36. mailto:[96][97]dm-devel@redhat.com
> >      >      >   37. [97][98]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   38. mailto:[98][99]dm-devel@redhat.com
> >      >      >   39. [99][100]
> https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   40. mailto:[100][101]tejaswinipoluri3@gmail.com
> >      >      >   41. mailto:[101][102]bmarzins@redhat.com
> >      >      >   42. mailto:[102][103]dm-devel@redhat.com
> >      >      >   43.
> >      [103][104]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   44. mailto:[104][105]dm-devel@redhat.com
> >      >      >   45.
> >      [105][106]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   46. mailto:[106][107]tejaswinipoluri3@gmail.com
> >      >      >   47. mailto:[107][108]bmarzins@redhat.com
> >      >      >   48. mailto:[108][109]tejaswinipoluri3@gmail.com
> >      >      >   49. mailto:[109][110]bmarzins@redhat.com
> >      >      >   50. mailto:[110][111]dm-devel@redhat.com
> >      >      >   51.
> >      [111][112]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   52. mailto:[112][113]dm-devel@redhat.com
> >      >      >   53.
> >      [113][114]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   54. mailto:[114][115]tejaswinipoluri3@gmail.com
> >      >      >   55. mailto:[115][116]bmarzins@redhat.com
> >      >      >   56. mailto:[116][117]dm-devel@redhat.com
> >      >      >   57.
> >      [117][118]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >      >   58. mailto:[118][119]dm-devel@redhat.com
> >      >      >   59.
> >      [119][120]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >
> >      > References
> >      >
> >      >    Visible links
> >      >    1. mailto:[121]bmarzins@redhat.com
> >      >    2. mailto:[122]bmarzins@redhat.com
> >      >    3. mailto:[123]bmarzins@redhat.com
> >      >    4. mailto:[124]tejaswinipoluri3@gmail.com
> >      >    5. mailto:[125]bmarzins@redhat.com
> >      >    6. mailto:[126]tejaswinipoluri3@gmail.com
> >      >    7. mailto:[127]bmarzins@redhat.com
> >      >    8. mailto:[128]dm-devel@redhat.com
> >      >    9. [129]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   10. mailto:[130]dm-devel@redhat.com
> >      >   11. [131]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   12. mailto:[132]tejaswinipoluri3@gmail.com
> >      >   13. mailto:[133]bmarzins@redhat.com
> >      >   14. mailto:[134]dm-devel@redhat.com
> >      >   15. [135]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   16. mailto:[136]dm-devel@redhat.com
> >      >   17. [137]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   18. mailto:[138]tejaswinipoluri3@gmail.com
> >      >   19. mailto:[139]bmarzins@redhat.com
> >      >   20. mailto:[140]tejaswinipoluri3@gmail.com
> >      >   21. mailto:[141]bmarzins@redhat.com
> >      >   22. mailto:[142]dm-devel@redhat.com
> >      >   23. [143]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   24. mailto:[144]dm-devel@redhat.com
> >      >   25. [145]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   26. mailto:[146]tejaswinipoluri3@gmail.com
> >      >   27. mailto:[147]bmarzins@redhat.com
> >      >   28. mailto:[148]dm-devel@redhat.com
> >      >   29. [149]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   30. mailto:[150]dm-devel@redhat.com
> >      >   31. [151]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   32. mailto:[152]bmarzins@redhat.com
> >      >   33. mailto:[153]tejaswinipoluri3@gmail.com
> >      >   34. mailto:[154]bmarzins@redhat.com
> >      >   35. mailto:[155]tejaswinipoluri3@gmail.com
> >      >   36. mailto:[156]bmarzins@redhat.com
> >      >   37. mailto:[157]dm-devel@redhat.com
> >      >   38. [158]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   39. mailto:[159]dm-devel@redhat.com
> >      >   40. [160]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   41. mailto:[161]tejaswinipoluri3@gmail.com
> >      >   42. mailto:[162]bmarzins@redhat.com
> >      >   43. mailto:[163]dm-devel@redhat.com
> >      >   44. [164]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   45. mailto:[165]dm-devel@redhat.com
> >      >   46. [166]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   47. mailto:[167]tejaswinipoluri3@gmail.com
> >      >   48. mailto:[168]bmarzins@redhat.com
> >      >   49. mailto:[169]tejaswinipoluri3@gmail.com
> >      >   50. mailto:[170]bmarzins@redhat.com
> >      >   51. mailto:[171]dm-devel@redhat.com
> >      >   52. [172]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   53. mailto:[173]dm-devel@redhat.com
> >      >   54. [174]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   55. mailto:[175]tejaswinipoluri3@gmail.com
> >      >   56. mailto:[176]bmarzins@redhat.com
> >      >   57. mailto:[177]dm-devel@redhat.com
> >      >   58. [178]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   59. mailto:[179]dm-devel@redhat.com
> >      >   60. [180]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   61. mailto:[181]bmarzins@redhat.com
> >      >   62. mailto:[182]bmarzins@redhat.com
> >      >   63. mailto:[183]tejaswinipoluri3@gmail.com
> >      >   64. mailto:[184]bmarzins@redhat.com
> >      >   65. mailto:[185]tejaswinipoluri3@gmail.com
> >      >   66. mailto:[186]bmarzins@redhat.com
> >      >   67. mailto:[187]dm-devel@redhat.com
> >      >   68. [188]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   69. mailto:[189]dm-devel@redhat.com
> >      >   70. [190]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   71. mailto:[191]tejaswinipoluri3@gmail.com
> >      >   72. mailto:[192]bmarzins@redhat.com
> >      >   73. mailto:[193]dm-devel@redhat.com
> >      >   74. [194]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   75. mailto:[195]dm-devel@redhat.com
> >      >   76. [196]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   77. mailto:[197]tejaswinipoluri3@gmail.com
> >      >   78. mailto:[198]bmarzins@redhat.com
> >      >   79. mailto:[199]tejaswinipoluri3@gmail.com
> >      >   80. mailto:[200]bmarzins@redhat.com
> >      >   81. mailto:[201]dm-devel@redhat.com
> >      >   82. [202]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   83. mailto:[203]dm-devel@redhat.com
> >      >   84. [204]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   85. mailto:[205]tejaswinipoluri3@gmail.com
> >      >   86. mailto:[206]bmarzins@redhat.com
> >      >   87. mailto:[207]dm-devel@redhat.com
> >      >   88. [208]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   89. mailto:[209]dm-devel@redhat.com
> >      >   90. [210]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   91. mailto:[211]bmarzins@redhat.com
> >      >   92. mailto:[212]tejaswinipoluri3@gmail.com
> >      >   93. mailto:[213]bmarzins@redhat.com
> >      >   94. mailto:[214]tejaswinipoluri3@gmail.com
> >      >   95. mailto:[215]bmarzins@redhat.com
> >      >   96. mailto:[216]dm-devel@redhat.com
> >      >   97. [217]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >   98. mailto:[218]dm-devel@redhat.com
> >      >   99. [219]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >  100. mailto:[220]tejaswinipoluri3@gmail.com
> >      >  101. mailto:[221]bmarzins@redhat.com
> >      >  102. mailto:[222]dm-devel@redhat.com
> >      >  103. [223]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >  104. mailto:[224]dm-devel@redhat.com
> >      >  105. [225]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >  106. mailto:[226]tejaswinipoluri3@gmail.com
> >      >  107. mailto:[227]bmarzins@redhat.com
> >      >  108. mailto:[228]tejaswinipoluri3@gmail.com
> >      >  109. mailto:[229]bmarzins@redhat.com
> >      >  110. mailto:[230]dm-devel@redhat.com
> >      >  111. [231]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >  112. mailto:[232]dm-devel@redhat.com
> >      >  113. [233]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >  114. mailto:[234]tejaswinipoluri3@gmail.com
> >      >  115. mailto:[235]bmarzins@redhat.com
> >      >  116. mailto:[236]dm-devel@redhat.com
> >      >  117. [237]https://www.redhat.com/mailman/listinfo/dm-devel
> >      >  118. mailto:[238]dm-devel@redhat.com
> >      >  119. [239]https://www.redhat.com/mailman/listinfo/dm-devel
> >
> > References
> >
> >    Visible links
> >    1. mailto:bmarzins@redhat.com
> >    2. mailto:bmarzins@redhat.com
> >    3. mailto:bmarzins@redhat.com
> >    4. mailto:bmarzins@redhat.com
> >    5. mailto:tejaswinipoluri3@gmail.com
> >    6. mailto:bmarzins@redhat.com
> >    7. mailto:tejaswinipoluri3@gmail.com
> >    8. mailto:bmarzins@redhat.com
> >    9. mailto:dm-devel@redhat.com
> >   10. https://www.redhat.com/mailman/listinfo/dm-devel
> >   11. mailto:dm-devel@redhat.com
> >   12. https://www.redhat.com/mailman/listinfo/dm-devel
> >   13. mailto:tejaswinipoluri3@gmail.com
> >   14. mailto:bmarzins@redhat.com
> >   15. mailto:dm-devel@redhat.com
> >   16. https://www.redhat.com/mailman/listinfo/dm-devel
> >   17. mailto:dm-devel@redhat.com
> >   18. https://www.redhat.com/mailman/listinfo/dm-devel
> >   19. mailto:tejaswinipoluri3@gmail.com
> >   20. mailto:bmarzins@redhat.com
> >   21. mailto:tejaswinipoluri3@gmail.com
> >   22. mailto:bmarzins@redhat.com
> >   23. mailto:dm-devel@redhat.com
> >   24. https://www.redhat.com/mailman/listinfo/dm-devel
> >   25. mailto:dm-devel@redhat.com
> >   26. https://www.redhat.com/mailman/listinfo/dm-devel
> >   27. mailto:tejaswinipoluri3@gmail.com
> >   28. mailto:bmarzins@redhat.com
> >   29. mailto:dm-devel@redhat.com
> >   30. https://www.redhat.com/mailman/listinfo/dm-devel
> >   31. mailto:dm-devel@redhat.com
> >   32. https://www.redhat.com/mailman/listinfo/dm-devel
> >   33. mailto:bmarzins@redhat.com
> >   34. mailto:tejaswinipoluri3@gmail.com
> >   35. mailto:bmarzins@redhat.com
> >   36. mailto:tejaswinipoluri3@gmail.com
> >   37. mailto:bmarzins@redhat.com
> >   38. mailto:dm-devel@redhat.com
> >   39. https://www.redhat.com/mailman/listinfo/dm-devel
> >   40. mailto:dm-devel@redhat.com
> >   41. https://www.redhat.com/mailman/listinfo/dm-devel
> >   42. mailto:tejaswinipoluri3@gmail.com
> >   43. mailto:bmarzins@redhat.com
> >   44. mailto:dm-devel@redhat.com
> >   45. https://www.redhat.com/mailman/listinfo/dm-devel
> >   46. mailto:dm-devel@redhat.com
> >   47. https://www.redhat.com/mailman/listinfo/dm-devel
> >   48. mailto:tejaswinipoluri3@gmail.com
> >   49. mailto:bmarzins@redhat.com
> >   50. mailto:tejaswinipoluri3@gmail.com
> >   51. mailto:bmarzins@redhat.com
> >   52. mailto:dm-devel@redhat.com
> >   53. https://www.redhat.com/mailman/listinfo/dm-devel
> >   54. mailto:dm-devel@redhat.com
> >   55. https://www.redhat.com/mailman/listinfo/dm-devel
> >   56. mailto:tejaswinipoluri3@gmail.com
> >   57. mailto:bmarzins@redhat.com
> >   58. mailto:dm-devel@redhat.com
> >   59. https://www.redhat.com/mailman/listinfo/dm-devel
> >   60. mailto:dm-devel@redhat.com
> >   61. https://www.redhat.com/mailman/listinfo/dm-devel
> >   62. mailto:bmarzins@redhat.com
> >   63. mailto:bmarzins@redhat.com
> >   64. mailto:tejaswinipoluri3@gmail.com
> >   65. mailto:bmarzins@redhat.com
> >   66. mailto:tejaswinipoluri3@gmail.com
> >   67. mailto:bmarzins@redhat.com
> >   68. mailto:dm-devel@redhat.com
> >   69. https://www.redhat.com/mailman/listinfo/dm-devel
> >   70. mailto:dm-devel@redhat.com
> >   71. https://www.redhat.com/mailman/listinfo/dm-devel
> >   72. mailto:tejaswinipoluri3@gmail.com
> >   73. mailto:bmarzins@redhat.com
> >   74. mailto:dm-devel@redhat.com
> >   75. https://www.redhat.com/mailman/listinfo/dm-devel
> >   76. mailto:dm-devel@redhat.com
> >   77. https://www.redhat.com/mailman/listinfo/dm-devel
> >   78. mailto:tejaswinipoluri3@gmail.com
> >   79. mailto:bmarzins@redhat.com
> >   80. mailto:tejaswinipoluri3@gmail.com
> >   81. mailto:bmarzins@redhat.com
> >   82. mailto:dm-devel@redhat.com
> >   83. https://www.redhat.com/mailman/listinfo/dm-devel
> >   84. mailto:dm-devel@redhat.com
> >   85. https://www.redhat.com/mailman/listinfo/dm-devel
> >   86. mailto:tejaswinipoluri3@gmail.com
> >   87. mailto:bmarzins@redhat.com
> >   88. mailto:dm-devel@redhat.com
> >   89. https://www.redhat.com/mailman/listinfo/dm-devel
> >   90. mailto:dm-devel@redhat.com
> >   91. https://www.redhat.com/mailman/listinfo/dm-devel
> >   92. mailto:bmarzins@redhat.com
> >   93. mailto:tejaswinipoluri3@gmail.com
> >   94. mailto:bmarzins@redhat.com
> >   95. mailto:tejaswinipoluri3@gmail.com
> >   96. mailto:bmarzins@redhat.com
> >   97. mailto:dm-devel@redhat.com
> >   98. https://www.redhat.com/mailman/listinfo/dm-devel
> >   99. mailto:dm-devel@redhat.com
> >  100. https://www.redhat.com/mailman/listinfo/dm-devel
> >  101. mailto:tejaswinipoluri3@gmail.com
> >  102. mailto:bmarzins@redhat.com
> >  103. mailto:dm-devel@redhat.com
> >  104. https://www.redhat.com/mailman/listinfo/dm-devel
> >  105. mailto:dm-devel@redhat.com
> >  106. https://www.redhat.com/mailman/listinfo/dm-devel
> >  107. mailto:tejaswinipoluri3@gmail.com
> >  108. mailto:bmarzins@redhat.com
> >  109. mailto:tejaswinipoluri3@gmail.com
> >  110. mailto:bmarzins@redhat.com
> >  111. mailto:dm-devel@redhat.com
> >  112. https://www.redhat.com/mailman/listinfo/dm-devel
> >  113. mailto:dm-devel@redhat.com
> >  114. https://www.redhat.com/mailman/listinfo/dm-devel
> >  115. mailto:tejaswinipoluri3@gmail.com
> >  116. mailto:bmarzins@redhat.com
> >  117. mailto:dm-devel@redhat.com
> >  118. https://www.redhat.com/mailman/listinfo/dm-devel
> >  119. mailto:dm-devel@redhat.com
> >  120. https://www.redhat.com/mailman/listinfo/dm-devel
> >  121. mailto:bmarzins@redhat.com
> >  122. mailto:bmarzins@redhat.com
> >  123. mailto:bmarzins@redhat.com
> >  124. mailto:tejaswinipoluri3@gmail.com
> >  125. mailto:bmarzins@redhat.com
> >  126. mailto:tejaswinipoluri3@gmail.com
> >  127. mailto:bmarzins@redhat.com
> >  128. mailto:dm-devel@redhat.com
> >  129. https://www.redhat.com/mailman/listinfo/dm-devel
> >  130. mailto:dm-devel@redhat.com
> >  131. https://www.redhat.com/mailman/listinfo/dm-devel
> >  132. mailto:tejaswinipoluri3@gmail.com
> >  133. mailto:bmarzins@redhat.com
> >  134. mailto:dm-devel@redhat.com
> >  135. https://www.redhat.com/mailman/listinfo/dm-devel
> >  136. mailto:dm-devel@redhat.com
> >  137. https://www.redhat.com/mailman/listinfo/dm-devel
> >  138. mailto:tejaswinipoluri3@gmail.com
> >  139. mailto:bmarzins@redhat.com
> >  140. mailto:tejaswinipoluri3@gmail.com
> >  141. mailto:bmarzins@redhat.com
> >  142. mailto:dm-devel@redhat.com
> >  143. https://www.redhat.com/mailman/listinfo/dm-devel
> >  144. mailto:dm-devel@redhat.com
> >  145. https://www.redhat.com/mailman/listinfo/dm-devel
> >  146. mailto:tejaswinipoluri3@gmail.com
> >  147. mailto:bmarzins@redhat.com
> >  148. mailto:dm-devel@redhat.com
> >  149. https://www.redhat.com/mailman/listinfo/dm-devel
> >  150. mailto:dm-devel@redhat.com
> >  151. https://www.redhat.com/mailman/listinfo/dm-devel
> >  152. mailto:bmarzins@redhat.com
> >  153. mailto:tejaswinipoluri3@gmail.com
> >  154. mailto:bmarzins@redhat.com
> >  155. mailto:tejaswinipoluri3@gmail.com
> >  156. mailto:bmarzins@redhat.com
> >  157. mailto:dm-devel@redhat.com
> >  158. https://www.redhat.com/mailman/listinfo/dm-devel
> >  159. mailto:dm-devel@redhat.com
> >  160. https://www.redhat.com/mailman/listinfo/dm-devel
> >  161. mailto:tejaswinipoluri3@gmail.com
> >  162. mailto:bmarzins@redhat.com
> >  163. mailto:dm-devel@redhat.com
> >  164. https://www.redhat.com/mailman/listinfo/dm-devel
> >  165. mailto:dm-devel@redhat.com
> >  166. https://www.redhat.com/mailman/listinfo/dm-devel
> >  167. mailto:tejaswinipoluri3@gmail.com
> >  168. mailto:bmarzins@redhat.com
> >  169. mailto:tejaswinipoluri3@gmail.com
> >  170. mailto:bmarzins@redhat.com
> >  171. mailto:dm-devel@redhat.com
> >  172. https://www.redhat.com/mailman/listinfo/dm-devel
> >  173. mailto:dm-devel@redhat.com
> >  174. https://www.redhat.com/mailman/listinfo/dm-devel
> >  175. mailto:tejaswinipoluri3@gmail.com
> >  176. mailto:bmarzins@redhat.com
> >  177. mailto:dm-devel@redhat.com
> >  178. https://www.redhat.com/mailman/listinfo/dm-devel
> >  179. mailto:dm-devel@redhat.com
> >  180. https://www.redhat.com/mailman/listinfo/dm-devel
> >  181. mailto:bmarzins@redhat.com
> >  182. mailto:bmarzins@redhat.com
> >  183. mailto:tejaswinipoluri3@gmail.com
> >  184. mailto:bmarzins@redhat.com
> >  185. mailto:tejaswinipoluri3@gmail.com
> >  186. mailto:bmarzins@redhat.com
> >  187. mailto:dm-devel@redhat.com
> >  188. https://www.redhat.com/mailman/listinfo/dm-devel
> >  189. mailto:dm-devel@redhat.com
> >  190. https://www.redhat.com/mailman/listinfo/dm-devel
> >  191. mailto:tejaswinipoluri3@gmail.com
> >  192. mailto:bmarzins@redhat.com
> >  193. mailto:dm-devel@redhat.com
> >  194. https://www.redhat.com/mailman/listinfo/dm-devel
> >  195. mailto:dm-devel@redhat.com
> >  196. https://www.redhat.com/mailman/listinfo/dm-devel
> >  197. mailto:tejaswinipoluri3@gmail.com
> >  198. mailto:bmarzins@redhat.com
> >  199. mailto:tejaswinipoluri3@gmail.com
> >  200. mailto:bmarzins@redhat.com
> >  201. mailto:dm-devel@redhat.com
> >  202. https://www.redhat.com/mailman/listinfo/dm-devel
> >  203. mailto:dm-devel@redhat.com
> >  204. https://www.redhat.com/mailman/listinfo/dm-devel
> >  205. mailto:tejaswinipoluri3@gmail.com
> >  206. mailto:bmarzins@redhat.com
> >  207. mailto:dm-devel@redhat.com
> >  208. https://www.redhat.com/mailman/listinfo/dm-devel
> >  209. mailto:dm-devel@redhat.com
> >  210. https://www.redhat.com/mailman/listinfo/dm-devel
> >  211. mailto:bmarzins@redhat.com
> >  212. mailto:tejaswinipoluri3@gmail.com
> >  213. mailto:bmarzins@redhat.com
> >  214. mailto:tejaswinipoluri3@gmail.com
> >  215. mailto:bmarzins@redhat.com
> >  216. mailto:dm-devel@redhat.com
> >  217. https://www.redhat.com/mailman/listinfo/dm-devel
> >  218. mailto:dm-devel@redhat.com
> >  219. https://www.redhat.com/mailman/listinfo/dm-devel
> >  220. mailto:tejaswinipoluri3@gmail.com
> >  221. mailto:bmarzins@redhat.com
> >  222. mailto:dm-devel@redhat.com
> >  223. https://www.redhat.com/mailman/listinfo/dm-devel
> >  224. mailto:dm-devel@redhat.com
> >  225. https://www.redhat.com/mailman/listinfo/dm-devel
> >  226. mailto:tejaswinipoluri3@gmail.com
> >  227. mailto:bmarzins@redhat.com
> >  228. mailto:tejaswinipoluri3@gmail.com
> >  229. mailto:bmarzins@redhat.com
> >  230. mailto:dm-devel@redhat.com
> >  231. https://www.redhat.com/mailman/listinfo/dm-devel
> >  232. mailto:dm-devel@redhat.com
> >  233. https://www.redhat.com/mailman/listinfo/dm-devel
> >  234. mailto:tejaswinipoluri3@gmail.com
> >  235. mailto:bmarzins@redhat.com
> >  236. mailto:dm-devel@redhat.com
> >  237. https://www.redhat.com/mailman/listinfo/dm-devel
> >  238. mailto:dm-devel@redhat.com
> >  239. https://www.redhat.com/mailman/listinfo/dm-devel
>
> > commit 79ab9090d3fbcdb5844478419135d1390cf548c2
> > Author: Tejaswini <tejaswinipoluri3@gmail.com>
> > Date:   Wed Jul 8 15:08:56 2015 +0530
> >
> >     multipathd: Fixing add map functionality
> >
> >     Add map feature of multipathd tools fails as the device
> >     is also been completely removed along with removing the map
> >     in the remove map code. So when add map is called we are
> >     creating the device again in kernel and doing add map
> >     using the coloasce_paths code.
> >
> >     Signed-off-by: Tejaswini Poluri <tpoluri@mvista.com>
> >
> > diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> > index dc96c45..c54c767 100644
> > --- a/multipathd/cli_handlers.c
> > +++ b/multipathd/cli_handlers.c
> > @@ -537,7 +537,7 @@ cli_add_map (void * v, char ** reply, int * len,
> void * data)
> >       char dev_path[PATH_SIZE];
> >       char *alias;
> >       int rc;
> > -
> > +     char *refwwid;
> >       param = convert_dev(param, 0);
> >       condlog(2, "%s: add map (operator)", param);
> >
> > @@ -547,6 +547,14 @@ cli_add_map (void * v, char ** reply, int * len,
> void * data)
> >               condlog(2, "%s: map blacklisted", param);
> >               return 0;
> >       }
> > +     rc = get_refwwid(param, DEV_DEVMAP, vecs->pathvec, &refwwid);
> > +
> > +        if (refwwid) {
> > +                condlog(2, "%s: add map (operator)", refwwid);
> > +                if(coalesce_paths(vecs, NULL, refwwid, 0))
> > +                     condlog(2, "%s: coalesce-paths failed", param);
> > +                dm_lib_release();
> > +        }
> >       minor = dm_get_minor(param);
> >       if (minor < 0) {
> >               condlog(2, "%s: not a device mapper table", param);
> > @@ -566,6 +574,7 @@ cli_add_map (void * v, char ** reply, int * len,
> void * data)
> >       }
> >       rc = ev_add_map(dev_path, alias, vecs);
> >       FREE(alias);
> > +     FREE(refwwid);
> >       return rc;
> >  }
> >
>
> > commit 910b4a82ec483b48eaf8b24eb3d7829273c690ed
> > Author: Tejaswini <tejaswinipoluri3@gmail.com>
> > Date:   Wed Jul 8 17:18:03 2015 +0530
> >
> >     multipathd: Disabled code that is not being used.
> >
> >     This part of the code is moved to cli_add_map and
> >     disabled here as it is not used by any function call
> >     here.
> >
> >     Signed-off-by: Tejaswini <tejaswinipoluri3@gmail.com>
> >
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index f876258..060237c 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -329,6 +329,8 @@ ev_add_map (char * dev, char * alias, struct vectors
> * vecs)
> >                       return 1;
> >               }
> >       }
> > +#if 0 /*Disabled as the code is not being used by anyone.
> > +     TODO:confirm that no feature requires this code*/
> >       r = get_refwwid(dev, DEV_DEVMAP, vecs->pathvec, &refwwid);
> >
> >       if (refwwid) {
> > @@ -344,6 +346,7 @@ ev_add_map (char * dev, char * alias, struct vectors
> * vecs)
> >               condlog(0, "%s: uev_add_map %s failed", alias, dev);
> >
> >       FREE(refwwid);
> > +#endif
> >       return r;
> >  }
> >
>
>

--001a113ec94e62f6f1051afba718
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+VGhhbmtzIGEgbG90IGZvciB0aGUgaW5wdXRzLiBTb3JyeSBmb3IgdGhl
IGRlbGF5IGluIHVwZGF0aW5nIChHb3Qgc3RydWNrIHdpdGggb3RoZXIgaXNzdWVzKTxkaXY+PGJy
PjwvZGl2PjxkaXY+SGVyZSBpcyB0aGUgY2xpX2FkZF9tYXAgZnVuY3Rpb24gd2l0aCB0aGUgc3Vn
Z2VzdGVkIGNoYW5nZXMgYW5kIGl0IHNlZW1zIHRvIHdvcmsgZmluZS4gUGxlYXNlIGhhdmUgYSBs
b29rIGFuZCBzdWdnZXN0IHlvdXIgaW5wdXRzLjwvZGl2PjxkaXY+PGJyPjxmb250IHNpemU9IjEi
Pmk8c3BhbiBzdHlsZT0iZm9udC1mYW1pbHk6bW9ub3NwYWNlLG1vbm9zcGFjZSI+bnQ8YnI+Y2xp
X2FkZF9tYXAgKHZvaWQgKiB2LCBjaGFyICoqIHJlcGx5LCBpbnQgKiBsZW4sIHZvaWQgKiBkYXRh
KTxicj57PGJyPsKgwqDCoMKgwqDCoMKgIHN0cnVjdCB2ZWN0b3JzICogdmVjcyA9IChzdHJ1Y3Qg
dmVjdG9ycyAqKWRhdGE7PGJyPsKgwqDCoMKgwqDCoMKgIGNoYXIgKiBwYXJhbSA9IGdldF9rZXlw
YXJhbSh2LCBNQVApOzxicj7CoMKgwqDCoMKgwqDCoCBpbnQgbWFqb3IsIG1pbm9yOzxicj7CoMKg
wqDCoMKgwqDCoCBjaGFyIGRldl9wYXRoW1BBVEhfU0laRV07PGJyPsKgwqDCoMKgwqDCoMKgIGNo
YXIgKmFsaWFzOzxicj7CoMKgwqDCoMKgwqDCoCBpbnQgcmM7PGJyPsKgwqDCoMKgwqDCoMKgIGNo
YXIgKnJlZnd3aWQ7PGJyPsKgwqDCoMKgwqDCoMKgIHBhcmFtID0gY29udmVydF9kZXYocGFyYW0s
IDApOzxicj7CoMKgwqDCoMKgwqDCoCBjb25kbG9nKDIsICZxdW90OyVzOiBhZGQgbWFwIChvcGVy
YXRvcikmcXVvdDssIHBhcmFtKTs8YnI+PGJyPmlmIChmaWx0ZXJfd3dpZChjb25mLSZndDtibGlz
dF93d2lkLCBjb25mLSZndDtlbGlzdF93d2lkLCBwYXJhbSwgTlVMTCkmZ3Q7MCnCoMKgwqDCoMKg
wqAgezxicj7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKnJlcGx5ID0gc3RyZHVwKCZx
dW90O2JsYWNrbGlzdGVkXG4mcXVvdDspOzxicj7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgKmxlbiA9IHN0cmxlbigqcmVwbHkpICsgMTs8YnI+wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGNvbmRsb2coMiwgJnF1b3Q7JXM6IG1hcCBibGFja2xpc3RlZCZxdW90OywgcGFyYW0p
Ozxicj7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7PGJyPsKgfTxicj48
YnI+bWFwbmFtZTo8YnI+wqDCoMKgwqDCoMKgwqAgbWlub3IgPSBkbV9nZXRfbWlub3IocGFyYW0p
Ozxicj7CoMKgwqDCoMKgwqDCoCBpZiAobWlub3IgJmx0OyAwKSB7PGJyPsKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBjb25kbG9nKDIsICZxdW90OyVzOiBub3QgYSBkZXZpY2UgbWFwcGVy
IHRhYmxlJnF1b3Q7LCBwYXJhbSk7PGJyPsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAv
L3JldHVybiAwOzxicj7CoMKgwqDCoMKgwqDCoCB9PGJyPsKgwqDCoMKgwqDCoMKgIG1ham9yID0g
ZG1fZ2V0X21ham9yKHBhcmFtKTs8YnI+wqDCoMKgwqDCoMKgwqAgaWYgKG1ham9yICZsdDsgMCkg
ezxicj7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29uZGxvZygyLCAmcXVvdDslczog
bm90IGEgZGV2aWNlIG1hcHBlciB0YWJsZSZxdW90OywgcGFyYW0pOzxicj7CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgLy9yZXR1cm4gMDs8YnI+wqDCoMKgwqDCoMKgwqAgfTxicj7CoMKg
wqDCoMKgwqDCoCBzcHJpbnRmKGRldl9wYXRoLCZxdW90O2RtLSVkJnF1b3Q7LCBtaW5vcik7PGJy
PsKgwqDCoMKgwqDCoMKgIGFsaWFzID0gZG1fbWFwbmFtZShtYWpvciwgbWlub3IpOzxicj7CoMKg
wqDCoMKgwqDCoCBpZiAoIWFsaWFzKSB7PGJyPsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBjb25kbG9nKDIsICZxdW90OyVzOiBtYXBuYW1lIG5vdCBmb3VuZCBmb3IgJWQ6JWQmcXVvdDss
PGJyPsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcGFyYW0s
IG1ham9yLCBtaW5vcik7PGJyPsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByYyA9IGdl
dF9yZWZ3d2lkKHBhcmFtLCBERVZfREVWTUFQLCB2ZWNzLSZndDtwYXRodmVjLCAmYW1wO3JlZnd3
aWQpOzxicj7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHJlZnd3aWQpIHs8YnI+
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb25kbG9nKDIs
ICZxdW90OyVzOiBhZGQgbWFwIChvcGVyYXRvcikmcXVvdDssIHJlZnd3aWQpOzxicj7CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmKGNvYWxlc2NlX3BhdGhz
KHZlY3MsIE5VTEwsIHJlZnd3aWQsIDApKTxicj7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqA8L3NwYW4+PC9mb250PjxzcGFuIHN0eWxl
PSJmb250LWZhbWlseTptb25vc3BhY2UsbW9ub3NwYWNlIj48Zm9udCBzaXplPSIxIj7CoCBjb25k
bG9nKDIsICZxdW90OyVzOiBjb2FsZXNjZS1wYXRocyBmYWlsZWQmcXVvdDssIHBhcmFtKTs8YnI+
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZG1fbGliX3JlbGVh
c2UoKTs8YnI+wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH08YnI+wqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gbWFwbmFtZTs8YnI+PGJyPsKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAvL3JldHVybiAwOzxicj7CoMKgwqDCoMKgwqDCoCB9PGJyPsKgwqDCoMKg
wqDCoMKgIHJjID0gZXZfYWRkX21hcChkZXZfcGF0aCwgYWxpYXMsIHZlY3MpOzxicj7CoMKgwqDC
oMKgwqDCoCBGUkVFKGFsaWFzKTs8YnI+wqDCoMKgwqDCoMKgwqAgRlJFRShyZWZ3d2lkKTs8YnI+
wqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJjOzxicj59PC9mb250Pjxicj48YnI+PC9zcGFuPjwvZGl2
PjxkaXY+PHNwYW4gc3R5bGU9ImZvbnQtZmFtaWx5Om1vbm9zcGFjZSxtb25vc3BhY2UiPlJlZ2Fy
ZHMsPGJyPjwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuIHN0eWxlPSJmb250LWZhbWlseTptb25vc3Bh
Y2UsbW9ub3NwYWNlIj5UZWphc3dpbmk8YnI+PC9zcGFuPjwvZGl2PjxkaXY+PGJyPjwvZGl2Pjwv
ZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2V4dHJhIj48YnI+PGRpdiBjbGFzcz0iZ21haWxfcXVvdGUi
Pk9uIEZyaSwgSnVsIDEwLCAyMDE1IGF0IDk6MzYgUE0sIEJlbmphbWluIE1hcnppbnNraSA8c3Bh
biBkaXI9Imx0ciI+Jmx0OzxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIiB0YXJn
ZXQ9Il9ibGFuayI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT4mZ3Q7PC9zcGFuPiB3cm90ZTo8YnI+
PGJsb2NrcXVvdGUgY2xhc3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0ibWFyZ2luOjAgMCAwIC44ZXg7
Ym9yZGVyLWxlZnQ6MXB4ICNjY2Mgc29saWQ7cGFkZGluZy1sZWZ0OjFleCI+PHNwYW4gY2xhc3M9
IiI+T24gV2VkLCBKdWwgMDgsIDIwMTUgYXQgMDU6MzE6MjZQTSArMDUzMCwgVGVqYXN3aW5pIFBv
bHVyaSB3cm90ZTo8YnI+DQomZ3Q7wqAgwqAgVGhhbmtzIGEgbG90LsKgPGJyPg0KJmd0O8KgIMKg
IENhbiB5b3UgZ3VpZGUgbWUgaG93IHRvIHB1c2ggdXBzdHJlYW0gZm9yIHRoZSBhcHByb3ZhbC4g
V2hpY2ggYnJhbmNoPGJyPg0KJmd0O8KgIMKgIHNob3VsZCBJIHB1c2ggdG8/IEFueSBsaXN0IG9m
IHRlc3RjYXNlcyBJIHNob3VsZCBwZXJmb3JtIGJlZm9yZSBJIGNvdWxkPGJyPg0KJmd0O8KgIMKg
IHB1c2g/PGJyPg0KPGJyPg0KPC9zcGFuPkFsbCB5b3UgZG8gaXMgcG9zdCBpdCB0byBkbS1kZXZl
bC7CoCBJIHRoaW5rIGl0JiMzOTtzIGVhc2llciBmb3IgQ2hyaXN0b3BoZTxicj4NCnRvIHB1bGwg
dGhlIHBhdGNoZXMgaW4sIGlmIHlvdSBwb3N0IHRoZW0gZGlyZWN0bHkgaW4gdGhlIGVtYWlsLiAm
cXVvdDtnaXQ8YnI+DQpmb3JtYXQtcGF0Y2gmcXVvdDsgYW5kICZxdW90O2dpdCBzZW5kLWVtYWls
JnF1b3Q7IG1ha2UgdGhpcyBhIGxvdCBmYXN0ZXIuPGJyPg0KPGJyPg0KUGxlYXNlIGRvIHdoYXRl
dmVyIHRlc3RpbmcgeW91IGZlZWwgaXMgYXBwcm9wcmlhdGUgYmVmb3JlIHBvc3RpbmcuPGJyPg0K
PGJyPg0KQWJvdXQgdGhlIHBhdGNoZXMgc3BlY2lmaWNhbGx5OiBJbiBjbGlfYWRkX21hcCgpLCB3
b3VsZG4mIzM5O3QgaXQgbWFrZSBtb3JlPGJyPg0Kc2Vuc2UgdG8gb25seSBkbyB0aGUgY29hbGVz
Y2VfcGF0aHMoKSBpZiBkbV9tYXBuYW1lKCkgZmFpbHMuIElmIGl0PGJyPg0Kc3VjY2VlZHMgeW91
IGNsZWFybHkgYWxyZWFkeSBoYXZlIGFuIGV4aXN0aW5nIG1hcCwgc28geW91IGRvbiYjMzk7dCBu
ZWVkIHRvPGJyPg0KY3JlYXRlIG9uZS48YnI+DQo8YnI+DQotQmVuPGJyPg0KPHNwYW4gY2xhc3M9
IiI+PGJyPg0KJmd0O8KgIMKgIEkgaGF2ZSBjcmVhdGVkIHRoZSBmb2xsb3dpbmcgdHdvIHBhdGNo
ZXMuIFBGQcKgPGJyPg0KJmd0O8KgIMKgIFJlZ2FyZHMsPGJyPg0KJmd0O8KgIMKgIFRlamFzd2lu
aTxicj4NCiZndDvCoCDCoCBPbiBNb24sIEp1bCA2LCAyMDE1IGF0IDExOjE1IFBNLCBCZW5qYW1p
biBNYXJ6aW5za2k8YnI+DQo8L3NwYW4+PHNwYW4gY2xhc3M9IiI+Jmd0O8KgIMKgICZsdDtbMV08
YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwv
YT4mZ3Q7IHdyb3RlOjxicj4NCiZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgT24gVHVlLCBKdW4gMzAs
IDIwMTUgYXQgMTE6MjI6MzdBTSArMDUzMCwgVGVqYXN3aW5pIFBvbHVyaSB3cm90ZTo8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIFRoYW5rcyBCZW4uIFNvIHNob3VsZCBJIHB1c2ggdGhlIGNv
ZGUgdG8gdGhlIHVwc3RyZWFtIGFuZCBnZXQgYW48YnI+DQomZ3Q7wqAgwqAgwqAgYXBwcm92YWw/
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCBSZWdhcmRzLDxicj4NCiZndDs8YnI+DQomZ3Q7
wqAgwqAgwqAgWWVzLiBUaGFua3MhPGJyPg0KJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAtQmVuPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCBUZWphc3dpbmk8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIE9uIFR1ZSwgSnVuIDMwLCAyMDE1IGF0IDEyOjUwIEFNLCBCZW5qYW1pbiBNYXJ6aW5z
a2k8YnI+DQo8L3NwYW4+PGRpdj48ZGl2IGNsYXNzPSJoNSI+Jmd0O8KgIMKgIMKgICZndDvCoCDC
oCAmbHQ7WzFdWzJdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5z
QHJlZGhhdC5jb208L2E+Jmd0OyB3cm90ZTo8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgT24gRnJpLCBKdW4gMjYsIDIwMTUgYXQgMTI6MjE6NDhQ
TSArMDUzMCwgVGVqYXN3aW5pIFBvbHVyaSB3cm90ZTo8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCBZZXMgSSBhZ3JlZSB0aGF0IGhhdmluZyB0aGUgc2FtZSBjb2RlIGlu
IGJvdGggY2xpX2FkZF9tYXAoKTxicj4NCiZndDvCoCDCoCDCoCBhbmQ8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIGV2X2FkZF9tYXA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCBpcyBub3QgbmVjZXNzYXJ5LiBIZW5jZSBJIHdvdWxkIHN1Z2dlc3QgcmVtb3Zp
bmc8YnI+DQomZ3Q7wqAgwqAgwqAgZ2V0X3JlZnd3aWQoKSBjb2RlPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCBmcm9tPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgZXZfYWRkX21hcCBhcyBpdCBpcyBub3QgYmVpbmcgdXNlZCBieSBhbnlvbmUuPGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgZXZfYWRkX21hcChwYXJhbSwgTlVMTCwgdmVjcykgd291bGQgY3JlYXRlIHRo
ZSBtdWx0aXBhdGg8YnI+DQomZ3Q7wqAgwqAgwqAgZGV2aWNlIGJ5PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCB1c2luZzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIHRoZSBnZXRfcmVmd3dpZCgpIGNvZGUgYW5kIGJ1dCBhbGwgdGhlIGZ1bmN0aW9ucyBhYm92
ZSBpdDxicj4NCiZndDvCoCDCoCDCoCBsaWtlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgKGRtX2dldF9taW5vciwgZG1fZ2V0X21ham9yIGFuZCBkbV9tYXBuYW1lKSB3
b3VsZCBmYWlsIGFuZDxicj4NCiZndDvCoCDCoCDCoCBpdDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgd291bGRuJiMzOTt0PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgZW50ZXIgYW55IG9mIHRoZSBvdGhlciBjb2RlIGluIGV2X2FkZF9tYXAgbGlrZTxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDEuZG1fbWFwX3ByZXNlbnQsPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgMi5hZGRfbWFwX3dpdGhvdXRf
cGF0aDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDMuIHN5bmNfbWFw
X3N0YXRlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgd2hpY2ggYXJl
IHJlc3BvbnNpYmxlIGZvciByZWdpc3RlcmluZyB0aGUgbWFwIGFuZCBkaXNwbGF5aW5nPGJyPg0K
Jmd0O8KgIMKgIMKgIGl0Ljxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIFNvLCBJIHRoaW5rIG1vdmluZyB0
aGUgYmVsb3cgY29kZSBmcm9tIGV2X2FkZF9tYXAgdG88YnI+DQomZ3Q7wqAgwqAgwqAgY2xpX2Fk
ZF9tYXA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHNob3VsZCBiZTxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIGEgZ29vZCBpZGVhIHJpZ2h0Ljxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIHIgPSBnZXRfcmVmd3dpZChkZXYsIERFVl9ERVZNQVAsIHZlY3MtJmd0O3Bh
dGh2ZWMsJmFtcDtyZWZ3d2lkKTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgJmd0O8Kg
IMKgIMKgwqDCoMKgwqDCoMKgIGlmIChyZWZ3d2lkKSB7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCByID0gY29hbGVzY2VfcGF0aHModmVjcywgTlVMTCw8YnI+DQomZ3Q7wqAgwqAgwqAgcmVmd3dp
ZCwwKTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCAmZ3Q7wqAgwqAg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRtX2xpYl9yZWxlYXNlKCk7PGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoMKg
IH08YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBXaGF0IGRvIHUgdGhp
bms/PGJyPg0KJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IEkgYWdyZWUuIFdlIGFyZW4mIzM5O3QgdXNpbmcgdGhlIGNvZGUgaW4gZXZfYWRkX21hcCwgc28g
aXQmIzM5O3MgcHJlc2VuY2U8YnI+DQomZ3Q7wqAgwqAgwqAgdGhlcmU8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIGlzIHNpbXBseSBjb25mdXNpbmcuPGJyPg0KJmd0O8KgIMKgIMKgICZn
dDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIC1CZW48YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCBSZWdhcmRzLDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIFRlamFz
d2luaTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIE9uIEZyaSwgSnVu
IDI2LCAyMDE1IGF0IDQ6MzIgQU0sIEJlbmphbWluIE1hcnppbnNraTxicj4NCjwvZGl2PjwvZGl2
PjxkaXY+PGRpdiBjbGFzcz0iaDUiPiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
ICZsdDtbMV1bMl1bM108YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnpp
bnNAcmVkaGF0LmNvbTwvYT4mZ3Q7IHdyb3RlOjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIE9uIFR1
ZSwgSnVuIDIzLCAyMDE1IGF0IDAzOjQ4OjI2UE0gKzA1MzAsIFRlamFzd2luaSBQb2x1cmk8YnI+
DQomZ3Q7wqAgwqAgwqAgd3JvdGU6PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIEhpIEJlbiw8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIFRoaXMgaXMgcmVnYXJkaW5nIHRoZSBhZGQgbWFwIGlzc3VlIEkgaGF2
ZSBiZWVuPGJyPg0KJmd0O8KgIMKgIMKgIGRpc2N1c3NpbmcuPGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCBQb3N0aW5nPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgdGhlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIGlzc3VlIGFnYWluIHRvIHJlbWluZC48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIENhc2UgMSA6IHJlbW92ZSBhbmQgYWRkIG1hcC48YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgcm9vdEB4ODYtZ2Vu
ZXJpYy02NDp+IyBtdWx0aXBhdGhkIC1rJiMzOTtzaG93IG1hcHMmIzM5Ozxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBuYW1lwqDCoMKgIHN5c2Zz
IHV1aWQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgZG1wYXRoMCBkbS0wwqAgMUlFVF8wMDAxMDAwMTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCByb290QHg4Ni1nZW5lcmljLTY0On4jIG11bHRp
cGF0aGQgLWsmIzM5O3JlbW92ZSBtYXA8YnI+DQomZ3Q7wqAgwqAgwqAgZG1wYXRoMCYjMzk7PGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIG9rPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIHJvb3RA
eDg2LWdlbmVyaWMtNjQ6fiMgbXVsdGlwYXRoZCAtayYjMzk7c2hvdyBtYXBzJiMzOTs8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgcm9vdEB4ODYt
Z2VuZXJpYy02NDp+IyBtdWx0aXBhdGhkIC1rJiMzOTthZGQgbWFwIGRtcGF0aDAmIzM5Ozxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBvazxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCByb290QHg4
Ni1nZW5lcmljLTY0On4jIG11bHRpcGF0aGQgLWsmIzM5O3Nob3cgbWFwcyYjMzk7PGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIHJvb3RAeDg2LWdl
bmVyaWMtNjQ6fiM8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgT25jZSBhIG1hcCBpcyByZW1vdmVkLCB3ZSBhcmUgYWJsZSB0byBhZGQgaXQgb25s
eTxicj4NCiZndDvCoCDCoCDCoCB1c2luZzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
I211bHRpcGF0aMKgPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIGNvbW1hbmQgYW5kIG5vdCB1c2luZyBtdWx0aXBhdGhkIHRvb2xzLjxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgSSBoYXZlIGZpeGVkIHRoZSBw
cm9ibGVtIHdpdGggdHdvIGFwcHJvYWNoZXMuIEkgd291bGQ8YnI+DQomZ3Q7wqAgwqAgwqAgbGlr
ZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgeW91IHRvPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgcmV2aWV3PGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIHRoZSBzYW1lLjxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBQYXRjaDEgOiBCeSBtYWtpbmcg
JiMzOTtyZW1vdmUgbWFwIGRtcGF0aDAmIzM5OyB0byByZW1vdmU8YnI+DQomZ3Q7wqAgwqAgwqAg
b25seSB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG1hcCBhbmQ8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBub3QgdGhlPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIGRldmljZS4gSSBoYXZlIGFk
ZGVkIGV4dHJhIGZ1bmN0aW9ucyBkaXNjYXJkX21hcCBhbmQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgIGRtX3JlbW92ZV9tYXA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCBzbyBhczxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCB0byBub3QgaW50ZXJmZXJlIHdpdGggdGhlIGV4aXN0aW5nIGNvZGUuPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBQYXRjaCAyOiBUaGUg
YXBwcm9hY2ggeW91IGhhdmUgc3VnZ2VzdGVkLkJ5IGdldHRpbmc8YnI+DQomZ3Q7wqAgwqAgwqAg
d3dpZDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgZnJvbSB0aGU8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBtYXBuYW1lPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIGFuZCBkb2luZyBjb2FsZXNjZV9w
YXRocy4gSSBoYXZlIGp1c3QgbW92ZWQgdGhlPGJyPg0KJmd0O8KgIMKgIMKgIGZvbGxvd2luZzxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgY29kZSBpbjxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBldl9hZGRfbWFwIHRvIGNsaV9hZGRf
bWFwLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIFRoaXMgaXMgdGhlIGdlbmVyYWwgaWRlYSB3ZSYj
Mzk7ZCBsaWtlIHRvIGdvIHdpdGguwqAgSG93ZXZlciw8YnI+DQomZ3Q7wqAgwqAgwqAgbG9va2lu
Zzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgYXQgdGhlPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgbGF0ZXN0IHVwc3RyZWFtIGNvZGUsIEkgZG9uJiMz
OTt0IHRoaW5rIHlvdSBzaG91bGQgcHVsbCBjb2RlPGJyPg0KJmd0O8KgIMKgIMKgIGluIGZyb208
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBldl9hZGRfbWFwKCkg
dG8gY2xpX2FkZF9tYXAoKSBsaWtlIHlvdXIgcGF0Y2ggZG9lcy48YnI+DQomZ3Q7wqAgwqAgwqAg
Y2xpX2FkZF9tYXAoKTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IGFscmVhZHkgY2FsbHMgZXZfYWRkX21hcCgpLCBhbmQgZXZfYWRkX21hcCgpIGlzIGNlcnRhaW5s
eTxicj4NCiZndDvCoCDCoCDCoCBhYmxlIHRvPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCBhZGQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB0aGUgbWFw
IGlmIGl0IGRvZXNuJiMzOTt0IGFscmVhZHkgZXhpc3QuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
WW91IHdvdWxkIGp1c3QgbmVlZCB0byBjYWxsIGl0IHdpdGg8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCBldl9hZGRfbWFwKHBhcmFtLCBOVUxMLCB2ZWNzKTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBh
bmQgZXZfYWRkX21hcCgpIHdpbGwgaGFwcGlseSBjcmVhdGUgeW91IGEgbmV3IG11bHRpcGF0aDxi
cj4NCiZndDvCoCDCoCDCoCBkZXZpY2UuwqA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IEFsbDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHlvdSBuZWVk
IHRvIGRvIGlzIG1ha2Ugc3VyZSB0aGF0IGFsbCB0aGUgZnVuY3Rpb25zIHRoYXQ8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGV2X2FkZF9tYXAoKTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGNhbGxzIHdpdGggYWxpYXMgY2FuIGFjY2VwdCBhIE5VTEwg
dmFsdWUgdGhlcmUuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgVGhpcyBtaWdodCBub3QgYmUgdGhl
IGJlc3Qgd2F5IHRvIGdvIGFib3V0IHRoaXMsIGhvd2V2ZXIuwqA8YnI+DQomZ3Q7wqAgwqAgwqAg
SXQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHR1cm5zIG91dDxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHRoYXQgcmlnaHQgbm93LCBldmVuIHRob3Vn
aCBldl9hZGRfbWFwKCkgdGVjaG5pY2FsbHkgaGFzPGJyPg0KJmd0O8KgIMKgIMKgIHRoZTxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgYWJpbGl0eSB0bzxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGNyZWF0ZSBuZXcgbWFwcywgbm90aGluZyBjdXJyZW50
bHkgdXNlcyBpdCwgYW5kIGl0IHJlYWxseTxicj4NCiZndDvCoCDCoCDCoCBkb2VzbiYjMzk7dDxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgbWFrZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHNlbnNlIGZvciBpdCB0byBiZSB0aGVyZS4gSW5zdGVhZCBv
ZiBqdXN0IGNvcHlpbmcgdGhhdDxicj4NCiZndDvCoCDCoCDCoCBjb2RlLCB5b3U8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGNvdWxkPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgcHVsbCB0aGUgbWFwIGNyZWF0aW9uIGNvZGUgb3V0IG9mIGV2X2FkZF9t
YXAoKSBhbmQgYWRkIGl0PGJyPg0KJmd0O8KgIMKgIMKgIHRvPGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgY2xpX2FkZF9tYXAoKSwgZm9yIHRob3NlIHNpdHVhdGlv
bnMgd2hlcmUgdGhlIHJlcXVlc3RlZDxicj4NCiZndDvCoCDCoCDCoCBkZXZpY2U8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGRvZXNuJiMzOTt0PGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgYWxyZWFkeSBleGlzdC48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCBCdXQgaGF2aW5nIHRoZSBjb2RlIGluIGJvdGggY2xpX2FkZF9tYXAoKSBhbmQgZXZfYWRkX21h
cCgpPGJyPg0KJmd0O8KgIMKgIMKgIHdoZW48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IG9uZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGFscmVhZHkg
Y2FsbHMgdGhlIG90aGVyIGRvZXNuJiMzOTt0IHNlZW0gbmVjZXNzYXJ5Ljxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgIC1CZW48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIHIgPSBnZXRfcmVmd3dpZChk
ZXYsIERFVl9ERVZNQVAsPGJyPg0KJmd0O8KgIMKgIMKgIHZlY3MtJmd0O3BhdGh2ZWMsJmFtcDty
ZWZ3d2lkKTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
wqDCoMKgwqDCoMKgIGlmIChyZWZ3d2lkKSB7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBy
ID0gY29hbGVzY2VfcGF0aHModmVjcywgTlVMTCw8YnI+DQomZ3Q7wqAgwqAgwqAgcmVmd3dpZCww
KTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRtX2xpYl9yZWxlYXNlKCk7PGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDC
oMKgIH08YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIGNoYW5n
ZWQgZGV2IHRvIHBhcmFtLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgSSBoYXZlIHRlc3RlZCB0aGUgc2FtZSBpbiBhbGwgMyB2ZXJzaW9ucyAtMC40LjgsPGJy
Pg0KJmd0O8KgIMKgIMKgIDAuNC45IGFuZDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
MC41LjAuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgSXQgd291
bGQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
YmUgZ3JlYXQgaWYgeW91IGNhbiByZXZpZXcgdGhlIHNhbWUgc28gdGhhdCBpdDxicj4NCiZndDvC
oCDCoCDCoCBkb2VzbiYjMzk7dCBjYXVzZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
YW55PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgZXh0cmE8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgc2lkZSBl
ZmZlY3RzLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCBJIGd1ZXNzIFBhdGNoMiBpcyB0aGUgd2F5IHUgaGF2ZSBzdWdnZXN0ZWQgbWUgaW4gdGhl
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBwcmV2aW91cyBtYWlsLjxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIFBsZWFzZTxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCByZXZpZXcgaXQgYW5kIHNoYXJl
IHlvdXIgdmlld3MuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIFJlZ2FyZHMsPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIFRlamFzd2luaTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCBPbiBGcmksIEp1biAxMiwgMjAxNSBhdCAyOjIxIEFNLCBC
ZW5qYW1pbiBNYXJ6aW5za2k8YnI+DQo8L2Rpdj48L2Rpdj48ZGl2PjxkaXYgY2xhc3M9Img1Ij4m
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgJmx0O1sxXVsy
XVszXVs0XTxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRo
YXQuY29tPC9hPiZndDsgd3JvdGU6PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCBPbiBXZWQsIEp1biAxMCwgMjAxNSBhdCAxMTo0Njo1MUFNICswNTMwLCBU
ZWphc3dpbmk8YnI+DQomZ3Q7wqAgwqAgwqAgUG9sdXJpPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCB3cm90ZTo8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCAmZ3Q7wqAgwqAgV2UgYXJl
IHRlc3RpbmcgbXVsdGlwYXRoZCB0b29scyB3aXRoIGFsbDxicj4NCiZndDvCoCDCoCDCoCB0aGU8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHBvc3NpYmxlPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgb3B0aW9uczxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBhbmQgdGhlPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCAmZ3Q7
wqAgwqAgZm9sbG93aW5nIGZhaWxzLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgJmd0O8KgIMKg
IENhc2UgMSA6IHJlbW92ZSBhbmQgYWRkIG1hcC48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgICZndDvCoCDCoCByb290QHg4
Ni1nZW5lcmljLTY0On4jIG11bHRpcGF0aGQgLWsmIzM5O3Nob3c8YnI+DQomZ3Q7wqAgwqAgwqAg
bWFwcyYjMzk7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCAmZ3Q7wqAgwqAgbmFtZcKgwqDCoCBzeXNmcyB1dWlkPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCAmZ3Q7wqAgwqAgZG1wYXRoMCBkbS0wwqAgMUlFVF8wMDAxMDAwMTxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgJmd0
O8KgIMKgIHJvb3RAeDg2LWdlbmVyaWMtNjQ6fiMgbXVsdGlwYXRoZDxicj4NCiZndDvCoCDCoCDC
oCAtayYjMzk7cmVtb3ZlIG1hcDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgIGRtcGF0aDAmIzM5Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgJmd0O8KgIMKgIG9rPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCAmZ3Q7
wqAgwqAgcm9vdEB4ODYtZ2VuZXJpYy02NDp+IyBtdWx0aXBhdGhkIC1rJiMzOTtzaG93PGJyPg0K
Jmd0O8KgIMKgIMKgIG1hcHMmIzM5Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgJmd0O8KgIMKgIHJvb3RAeDg2LWdlbmVy
aWMtNjQ6fiMgbXVsdGlwYXRoZCAtayYjMzk7YWRkPGJyPg0KJmd0O8KgIMKgIMKgIG1hcDxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgZG1wYXRoMCYjMzk7PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCAmZ3Q7wqAg
wqAgb2s8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgICZndDvCoCDCoCByb290QHg4Ni1nZW5lcmljLTY0On4jIG11bHRpcGF0
aGQgLWsmIzM5O3Nob3c8YnI+DQomZ3Q7wqAgwqAgwqAgbWFwcyYjMzk7PGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCAmZ3Q7
wqAgwqAgcm9vdEB4ODYtZ2VuZXJpYy02NDp+Izxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgJmd0O8KgIMKgIE9uY2UgYSBt
YXAgaXMgcmVtb3ZlZCwgd2UgYXJlIGFibGUgdG8gYWRkPGJyPg0KJmd0O8KgIMKgIMKgIGl0PGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBvbmx5IHVzaW5nPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICNtdWx0aXBhdGjCoDxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgJmd0O8KgIMKgIGNvbW1hbmQgYW5kIG5vdCB1c2luZyBtdWx0aXBhdGhkIHRvb2xzLjxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCBJdCBpcyB3b3JraW5nIHRoZSB3YXkgaXQgd2FzIGRlc2lnbmVkLCBidXQ8
YnI+DQomZ3Q7wqAgwqAgwqAgcG9zc2libHk8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IGl0IHdvdWxkPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgbWFr
ZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCBzZW5zZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgdG8gY2hhbmdlIHRoZSBkZXNpZ24uPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIFlv
dSBoYXZlIG1lbnRpb25lZCB0aGF0IGl0IHdvdWxkIG1ha2Ugc2Vuc2UgdG88YnI+DQomZ3Q7wqAg
wqAgwqAgY2hhbmdlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB0aGU8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBkZXNpZ24gdG88YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgYWRkPGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCBtYXAuIEFyZSB0aGVyZSBwbGFucyB0byBjaGFuZ2UgdGhlIGRlc2lnbiA/PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBJ
IGFtIHRyeWluZyB0byB1bmRlcnN0YW5kIHRoZSBjb2RlIGZsb3cgdG88YnI+DQomZ3Q7wqAgwqAg
wqAgY2hhbmdlIHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IGRlc2lnbi4gQ2FuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIHlvdTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgZ3VpZGUgbWUgaWYgd2Ugc2hvdWxkIHN0b3AgcmVt
b3ZpbmcgdGhlIGRldmljZTxicj4NCiZndDvCoCDCoCDCoCBmcm9tPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCBpbiB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCByZW1vdmU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgbWFwIGNvZGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIGZsb3cgb3Igc3RhcnQgYWRkaW5nIHRo
ZSBkZXZpY2UgYW5kIHRoZSBtYXAgaW48YnI+DQomZ3Q7wqAgwqAgwqAgdGhlPGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCBhZGQgbWFwPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgY29kZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCBmbG93Ljxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoGhhdmUgdHJpZWQgdG8g
dW5kZXJzdGFuZCB0aGUgcmVtb3ZlIG1hcCBjb2RlPGJyPg0KJmd0O8KgIMKgIMKgIGZsb3cgb2Y8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBtdWx0aXBhdGhkIGlu
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IDAuNC44PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCBjb2RlLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgSSB0aGluayB0aGF0IHdlIHdhbnQgbXVsdGlwYXRoIHRvIGFjdHVhbGx5
IHJlbW92ZTxicj4NCiZndDvCoCDCoCDCoCB0aGUgbWFwPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgKGluc3RlYWQgb2Y8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAganVzdCBub3QgbW9uaXRvcmluZyBpdCkg
d2hlbiB5b3UgY2FsbCAmcXVvdDtyZW1vdmUgbWFwPGJyPg0KJmd0O8KgIMKgIMKgICZsdDttYXAm
Z3Q7JnF1b3Q7Ljxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgV2UganVzdDxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHdhbnQ8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJnF1b3Q7YWRkIG1hcCAm
bHQ7bWFwJmd0OyZxdW90OyB0byB0cnkgdG8gY3JlYXRlIHRoZSBtYXAgaWYgaXQ8YnI+DQomZ3Q7
wqAgwqAgwqAgZG9lc24mIzM5O3Q8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGV4aXN0
LsKgIFRvPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgZG88YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgdGhh
dCwgeW91IHdvdWxkIG5lZWQgdG8gZmlyc3QgZmlyZ3VyZSBvdXQgd2hhdCBXV0lEPGJyPg0KJmd0
O8KgIMKgIMKgIGlzPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBhc3NvY2lhdGVkPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgd2l0aDxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmbHQ7bWFwJmd0
Oy4gUHJlc3VtYWJseSwgJmx0O21hcCZndDsgY291bGQgZWl0aGVyIGJlIGFuIGFsaWFzLDxicj4N
CiZndDvCoCDCoCDCoCB3d2lkLDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgb3IgZXZl
bjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHRoZTxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBuYW1lIG9m
IGEgcGF0aCBpbiB0aGUgbWFwLiBPbmNlIHlvdSBmb3VuZCB0aGUgbWFwLDxicj4NCiZndDvCoCDC
oCDCoCB5b3U8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHdvdWxkIGhhdmU8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB0bzxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBjYWxsIHRoZSBjb2RlIHRv
IGNyZWF0ZSB0aGUgbWFwLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgQWxzbywgdG8gYW5zd2VyIHlvdXIgSVJDIHF1ZXN0aW9uLCBubyB0aGUgMC40Ljg8
YnI+DQomZ3Q7wqAgwqAgwqAgY29kZSBpczxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
bm90IHN0aWxsPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgYmVp
bmc8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgZGV2ZWxvcGVkIHVwc3RyZWFtLsKgIEFsbCB1cHN0cmVhbSBwYXRjaGVzIG9ubHkgZ288YnI+
DQomZ3Q7wqAgwqAgwqAgYWdhaW5zdDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgdGhl
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgY3VycmVudDxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBoZWFk
LiBUaGVyZSBhcmUgbm8gb3RoZXIgdXBzdHJlYW0gYnJhbmNoZXMuPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAtQmVuPGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIGV2X3Jl
bW92ZV9tYXAgKGNoYXIgKiBkZXZuYW1lLCBzdHJ1Y3QgdmVjdG9yczxicj4NCiZndDvCoCDCoCDC
oCAqIHZlY3MpPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoMKgwqDCoCBmbHVzaF9tYXAobXBw
LCB2ZWNzKTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCDCoMKg
wqDCoMKgwqDCoDxicj4NCiZndDvCoCDCoCDCoCBkbV9mbHVzaF9tYXAobXBwLSZndDthbGlhcyw8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBERUZBVUxUX1RBUkdF
VCk7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWY8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAoIWRtX21hcF9wcmVzZW50KG1hcG5hbWUpKTxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
wqAgwqDCoCDCoMKgIHJldHVybjxicj4NCiZndDvCoCDCoCDCoCAwOzxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oMKgwqDCoMKgwqAgaWYgKGRtX3R5cGUobWFwbmFtZSwgdHlwZSkgJmx0Oz0gMCk8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gMTs8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqDCoMKgwqDCoMKgIGlmIChkbV9yZW1vdmVfcGFydG1hcHMobWFwbmFtZSkpPGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDE7PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgwqDCoMKgwqDCoCBpZiAoZG1fZ2V0X29wZW5jb3VudChtYXBuYW1lKSkgezxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbmRsb2coMiwgJnF1b3Q7JXM6
IG1hcCBpbiB1c2UmcXVvdDssPGJyPg0KJmd0O8KgIMKgIMKgIG1hcG5hbWUpOzxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAxOzxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoMKgwqDCoMKgwqAgfSDCoMKgwqDCoMKgPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoCBy
ID0gZG1fc2ltcGxlY21kKERNX0RFVklDRV9SRU1PVkUsPGJyPg0KJmd0O8KgIMKgIMKgIG1hcG5h
bWUpOzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoMKgwqDCoMKgwqAgaWYgKHIpIHs8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb25kbG9nKDQsICZxdW90O211bHRpcGF0aCBt
YXAgJXM8YnI+DQomZ3Q7wqAgwqAgwqAgcmVtb3ZlZCZxdW90Oyw8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBtYXBuYW1lKTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCDCoMKgwqAgwqDCoMKgIMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgPGJyPg0KJmd0O8KgIMKgIMKgIHJldHVybjxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgMDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCB9PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqA8YnI+DQomZ3Q7wqAgwqAgwqAgb3JwaGFuX3Bh
dGhzKHZlY3MtJmd0O3BhdGh2ZWMsPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBtcHAp
Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHJlbW92ZV9tYXAobXBwLCB2ZWNzLDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIHN0b3Bfd2FpdGVyX3RocmVhZCw8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgMSk7PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIElz
IHJlbW92aW5nIHRoaXMgYmVsb3cgbGluZSwgdGhlIHJpZ2h0IHN0ZXAgdG88YnI+DQomZ3Q7wqAg
wqAgwqAgc3RvcDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgcmVtb3Zpbmc8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB0aGU8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgZGV2aWNlID88YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIHIgPSBkbV9zaW1wbGVjbWQoRE1fREVWSUNFX1JFTU9WRSwgbWFwbmFtZSk7PGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIFJlZ2FyZHMsPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIFRlamFzd2luaTxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBP
biBNb24sIEp1biA4LCAyMDE1IGF0IDExOjE1IEFNLCBUZWphc3dpbmk8YnI+DQomZ3Q7wqAgwqAg
wqAgUG9sdXJpPGJyPg0KPC9kaXY+PC9kaXY+Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCAmbHQ7WzFdWzJdWzNdWzRdWzVdPGEgaHJl
Zj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdt
YWlsLmNvbTwvYT4mZ3Q7PGJyPg0KPHNwYW4gY2xhc3M9IiI+Jmd0O8KgIMKgIMKgIHdyb3RlOjxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCBUaGFua3MgYSBsb3QgQmVuIGZvciB0aGUgcXVpY2sgYW5kIGRldGFp
bGVkPGJyPg0KJmd0O8KgIMKgIMKgIHJlcGx5Ljxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgSSBoYXZlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgYmVl
bjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgc3RydWdnbGluZyB0byB1bmRlcnN0YW5kIGFuZCBjb25jbHVkZSB0aGU8
YnI+DQomZ3Q7wqAgwqAgwqAgaXNzdWVzPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB3
aXRoPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgbXVsdGlwYXRo
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IGFzIEkgYW08YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHRoZSBvbmx5IG9uZSB3b3JraW5nIGZyb20gbXkgdGVhbS4g
WW91cjxicj4NCiZndDvCoCDCoCDCoCBpbnB1dHMgaGVscDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgbWUgYTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IGxvdC48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgVGhhbmtzPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBhZ2Fpbi48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIFJlZ2FyZHMsPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCBUZWphc3dpbmk8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIE9uIFNhdCwgSnVuIDYsIDIwMTUgYXQg
MzozNiBBTSwgQmVuamFtaW48YnI+DQomZ3Q7wqAgwqAgwqAgTWFyemluc2tpPGJyPg0KPC9zcGFu
PjxkaXY+PGRpdiBjbGFzcz0iaDUiPiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmx0O1syXVszXVs0XVs1XVs2XTxhIGhyZWY9
Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPiZndDsg
d3JvdGU6PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIE9uIEZyaSwgSnVuIDA1LCAyMDE1IGF0IDAyOjMx
OjIwUE0gKzA1MzAsPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBUZWphc3dpbmk8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBQb2x1cmk8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgd3JvdGU6PGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgSGlpIEJlbiw8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDs8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgIMKgICZndDvCoCDCoCBXZSBhcmUgdGVzdGluZyBtdWx0aXBhdGhkIHRvb2xzIHdp
dGg8YnI+DQomZ3Q7wqAgwqAgwqAgYWxsIHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIHBvc3NpYmxlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG9wdGlvbnMgYW5kPGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCB0aGU8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBmb2xsb3dpbmcgZmFpbHMuPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDC
oCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgQ2FzZSAxIDogcmVtb3ZlIGFuZCBhZGQg
bWFwLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIHJvb3RAeDg2LWdlbmVyaWMtNjQ6fiMgbXVs
dGlwYXRoZDxicj4NCiZndDvCoCDCoCDCoCAtayYjMzk7c2hvdzxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgbWFwcyYjMzk7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgbmFtZcKgwqDC
oCBzeXNmcyB1dWlkPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgZG1wYXRoMCBkbS0wwqAgMUlF
VF8wMDAxMDAwMTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIHJvb3RAeDg2LWdlbmVyaWMtNjQ6
fiMgbXVsdGlwYXRoZDxicj4NCiZndDvCoCDCoCDCoCAtayYjMzk7cmVtb3ZlPGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCBtYXA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCBkbXBhdGgwJiMzOTs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBvazxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgwqAgJmd0O8KgIMKgIHJvb3RAeDg2LWdlbmVyaWMtNjQ6fiMgbXVsdGlwYXRoZDxi
cj4NCiZndDvCoCDCoCDCoCAtayYjMzk7c2hvdzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgbWFwcyYjMzk7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgcm9vdEB4ODYtZ2VuZXJpYy02
NDp+IyBtdWx0aXBhdGhkPGJyPg0KJmd0O8KgIMKgIMKgIC1rJiMzOTthZGQgbWFwPGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgZG1wYXRoMCYjMzk7PGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCDCoCAmZ3Q7wqAgwqAgb2s8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCByb290QHg4Ni1n
ZW5lcmljLTY0On4jIG11bHRpcGF0aGQ8YnI+DQomZ3Q7wqAgwqAgwqAgLWsmIzM5O3Nob3c8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG1hcHMmIzM5Ozxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0
O8KgIMKgIHJvb3RAeDg2LWdlbmVyaWMtNjQ6fiM8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBP
bmNlIGEgbWFwIGlzIHJlbW92ZWQsIHdlIGFyZSBhYmxlIHRvPGJyPg0KJmd0O8KgIMKgIMKgIGFk
ZCBpdDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgb25seTxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHVzaW5nPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAjbXVsdGlw
YXRowqA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBjb21tYW5kIGFuZCBub3QgdXNpbmcgbXVs
dGlwYXRoZDxicj4NCiZndDvCoCDCoCDCoCB0b29scy48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgSXQg
aXMgd29ya2luZyB0aGUgd2F5IGl0IHdhcyBkZXNpZ25lZCwgYnV0PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCBwb3NzaWJseSBpdDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIHdvdWxkPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgIG1ha2U8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIHNlbnNlPGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCDCoCB0byBjaGFuZ2UgdGhlIGRlc2lnbi7CoCBUaGUgJnF1b3Q7cmVtb3ZlIG1hcCZxdW90Ozxi
cj4NCiZndDvCoCDCoCDCoCBjb21tYW5kLDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
bm90PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgb25seSBzdG9w
czxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgwqAgbXVsdGlwYXRoZCBmcm9tIG1vbml0b3JpbmcgdGhlIG11bHRpcGF0
aDxicj4NCiZndDvCoCDCoCDCoCBkZXZpY2UsPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCBidXQgaXQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCByZW1v
dmVzPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIGl0PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCBmcm9tPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCB0aGUgc3lzdGVtIGFz
IHdlbGwuwqAgVGhlICZxdW90O2FkZCBtYXAmcXVvdDsgY29tbWFuZDxicj4NCiZndDvCoCDCoCDC
oCBtYWtlczxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG11bHRp
cGF0aDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCBtb25pdG9yIGFuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBhbHJlYWR5IGV4aXN0aW5nIG11bHRpcGF0
aCBkZXZpY2UgdGhhdCBpbjxicj4NCiZndDvCoCDCoCDCoCB3YXNuJiMzOTt0PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgcHJldmlvdXNseTxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
wqAgbW9uaXRvcmluZy48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIFRoZXNlIGNvbW1hbmRzIGRvIHRoaXMgZm9y
IGhpc3RvcmljYWw8YnI+DQomZ3Q7wqAgwqAgwqAgcmVhc29ucy7CoDxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG11bHRpcGF0aGQ8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgd2FzbiYjMzk7dDxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgwqAgb3JpZ2luYWxseSBpbiBjaGFyZ2Ugb2YgY3JlYXRpbmcgbXVsdGlwYXRoPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBkZXZpY2VzLDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG11bHRpcGF0aDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB3YXMuwqA8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIE9u
Y2U8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIMKgIGl0IGhhZCBjcmVhdGVkIHRoZSBkZXZpY2UsIGl0IHJhbjxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCDCoCBtdWx0aXBhdGhkIC1rJnF1b3Q7YWRkIG1hcCAmbHQ7TUFQJmd0OyZx
dW90Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCB0byBtYWtlIG11bHRpcGF0aGQgc3RhcnQgbW9uaXRv
cmluZyBpdC7CoDxicj4NCiZndDvCoCDCoCDCoCBIb3dldmVyPGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCB0aGluZ3M8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCBoYXZlbiYjMzk7dDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCB3b3JrZWQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIHRoaXMgd2F5IHNpbmNlIFJI
RUw0LCBzbyBwb3NzaWJseSAmcXVvdDthZGQ8YnI+DQomZ3Q7wqAgwqAgwqAgbWFwJnF1b3Q7PGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBzaG91bGQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCBhY3R1YWxseTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBjcmVhdGUgdGhlPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDC
oCBkZXZpY2UgaWYgaXQgZG9lc24mIzM5O3QgY3VycmVudGx5IGV4aXN0Ljxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
wqAgJmd0O8KgIMKgIENhc2UgMiA6IEFjdGl2ZSBwYXRoc8KgIHRlc3QgY2FzZTxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgwqAgJmd0O8KgIMKgICMgd2hpbGUgdHJ1ZSA7IGRvIHNsZWVwIDMgOzxicj4NCiZndDvCoCDC
oCDCoCBtdWx0aXBhdGhkPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAtayYjMzk7cmVt
b3ZlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgcGF0aCBzZGIm
IzM5Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCA7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCBtdWx0aXBhdGhkPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAg
wqAgLWsmIzM5O2FkZCBwYXRoIHNkYiYjMzk7IDsgbXVsdGlwYXRoZCAtayYjMzk7c2hvdzxicj4N
CiZndDvCoCDCoCDCoCBtYXBzPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBzdGF0dXMm
IzM5Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIDsgZG9uZTxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIG9rPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgb2s8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBuYW1lIGZhaWxiYWNrIHF1ZXVlaW5nIHBhdGhzIGRt
LXN0PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgZG1wYXRoMCAtIC0gMSBhY3RpdmUgLy8gSXQg
c2hvdWxkIGJlPGJyPg0KJmd0O8KgIMKgIMKgIDIuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIFRoaXMg
aXMgc2ltcGx5IGEgdGltaW5nIGlzc3VlLsKgIFdoYXQgeW91PGJyPg0KJmd0O8KgIMKgIMKgIGFy
ZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgc2VlaW5nIGl0PGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgdGhlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG51bWJlciBvZjxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
wqAgYWN0aXZlIHBhdGhzLsKgIFRoZXNlIGFyZSBwYXRocyB0aGF0IHRoZTxicj4NCiZndDvCoCDC
oCDCoCBrZXJuZWw8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGNhbiB1c2UuPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgVGhlPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZxdW90O2FkZCBwYXRo
JnF1b3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCBjb21tYW5kIGRvZXNuJiMzOTt0IHVwZGF0ZSB0aGUga2Vy
bmVsIHN0YXRlLsKgPGJyPg0KJmd0O8KgIMKgIMKgIFRoaXM8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgIGhhcHBlbnM8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCBsYXRlciBpbjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgcmVzcG9uc2U8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIHRv
IHRoZSBrZXJuZWwgcmVsb2FkaW5nIHRoZSBkZXZpY2UgdGFibGUuPGJyPg0KJmd0O8KgIMKgIMKg
IFNvLCBpbjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgYTxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHNlY29uZCBvcjxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB0d28sIHRoaXM8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIMKgIHdpbGwgc2F5IDIsIGFzIGV4cGVjdGVkLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7
wqAgwqAgV2Ugd291bGQgbGlrZSB0byBrbm93IGlmIHRoZSB0ZXN0PGJyPg0KJmd0O8KgIMKgIMKg
IGNhc2VzIGFyZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgdmFsaWQ8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBhbmQgaWY8YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgdGhlc2U8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIMKgIGFyZSBidWdzIG9yPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgYW55IGRlc2lnbiBp
c3N1ZXMuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgQ2Fz
ZSAzIDogRmFpbCBwYXRoIGFuZCByZWluc3RhdGUgcGF0aDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8Kg
IMKgIHJvb3RAeDg2LWdlbmVyaWMtNjQ6fiMgbXVsdGlwYXRoZDxicj4NCiZndDvCoCDCoCDCoCAt
ayZxdW90O2ZhaWw8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHBhdGg8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBzZGMmcXVvdDs7PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG11bHRpcGF0aGQ8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCAtayYjMzk7cmVpbnN0YXRlIHBhdGggc2RjJiMzOTs7
IG11bHRpcGF0aGQ8YnI+DQomZ3Q7wqAgwqAgwqAgLWsmcXVvdDtzaG93PGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCBwYXRocyZxdW90Ozs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCAm
Z3Q7wqDCoMKgIFsgMzk2Mi43MDg1MjNdIGRldmljZS1tYXBwZXI6PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCBtdWx0aXBhdGg6PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgRmFpbGluZyBwYXRoPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIDg6MzIuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAg
Jmd0O8KgwqDCoCBvazxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgICZndDvCoMKgwqAgb2s8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgIMKgICZndDvCoCDCoCAmZ3Q7wqDCoMKgIGhjaWzCoMKgwqAgZGV2IGRldl90IHBy
aSBkbV9zdMKgwqA8YnI+DQomZ3Q7wqAgwqAgwqAgY2hrX3N0wqDCoDxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG5leHRfY2hlY2s8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZn
dDvCoCDCoCAmZ3Q7wqDCoMKgIDQ6MDowOjEgc2RjIDg6MzLCoCAxwqDCoDxicj4NCiZndDvCoCDC
oCDCoCBbYWN0aXZlXVtmYXVsdHldPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgLi4uLi4uLi4uLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAxLzIwwqDCoDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmx0Oz09Q0hFQ0s8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCAmZ3Q7wqDCoMKgIDU6MDowOjEgc2RkIDg6NDjCoCAx
wqDCoDxicj4NCiZndDvCoCDCoCDCoCBbYWN0aXZlXVtyZWFkeV3CoDxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIFhYLi4uLi4uLi48YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgNC8yMDxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
wqAgJmd0O8KgIMKgIHNkYyBwYXRoIGJlY29tZXMgW2FjdGl2ZV1bcmVhZHldIG9ubHk8YnI+DQom
Z3Q7wqAgwqAgwqAgYWZ0ZXI8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHRoZTxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHBvbGxpbmc8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgaW50ZXJ2YWw8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgIGJ1dCBub3Q8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBpbW1lZGlh
dGVseSBhZnRlciB0aGUgcmVpbnN0YXRlIHBhdGg8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIGNvbW1hbmQuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgWW91IGhhdmUgYW5zd2VyZWQg
dGhhdCB0aGlzIGlzIGE8YnI+DQomZ3Q7wqAgwqAgwqAgZGVzaWduPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCBpc3N1ZS4gQnV0PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgd2UgaGF2ZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCBoZWFyZDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgZnJvbSBvdXI8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgIMKgICZndDvCoCDCoCB0ZXN0IHRlYW0gdGhhdCB0aGUgc2FtZSB0ZXN0IGNhc2U8YnI+
DQomZ3Q7wqAgwqAgwqAgd29ya3MgaW48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIFJI
RUw2Ljxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIERpZCB5b3U8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
b2JzZXJ2ZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgaXQ/PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgSSBh
bSBhbHNvIGZpbmRpbmcgdGhhdCB0aGUgdGVzdCBjYXNlczxicj4NCiZndDvCoCDCoCDCoCBmYWls
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBiZWNhdXNlPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgd2UgYXJlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHRyeWluZzxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAg
dG8gZG88YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBtdWx0aXBsZSBjb21tYW5kcyBhdCBvbmUg
c2hvdC7CoDxicj4NCiZndDvCoCDCoCDCoCBQbGVhc2Ugc2hhcmU8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIHlvdXI8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCB0aG91Z2h0czxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCBzbzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgdGhhdCBpdDxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAg
Jmd0O8KgIMKgIGNvdWxkIGhlbHAgbWUgaW4gZGVidWdnaW5nIHRoZSBpc3N1ZXM8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGZ1cnRoZXIuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7PGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgIEl0JiMzOTtzIHRvdGFsbHkgcG9zc2libGUgdGhhdCB0aGUgY2hlY2tl
cjxicj4NCiZndDvCoCDCoCDCoCBzdGF0ZSBpczxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIGltbWVkaWF0ZWx5PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHVwZGF0ZWQgaW48YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIFJI
RUw2LsKgIExpa2UgSSBzYWlkIGJlZm9yZSwgd2hhdCBpdDxicj4NCiZndDvCoCDCoCDCoCBjdXJy
ZW50bHk8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGRvZXMsPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgYWx0aG91Z2g8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgY29ycmVjdCw8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIMKgIGlzIGNvbmZ1c2luZywgYW5kIHBlcmhhcHMgd2UgbmVlZCBhPGJyPg0KJmd0O8KgIMKg
IMKgIGRpZmZlcmVudDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgY2hlY2tlcjxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHN0YXRlIGZvcjxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBwYXRoczxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgwqAgd2hlcmUgdGhlICZxdW90O2ZhaWwgcGF0aCZxdW90OyBjb21tYW5kIGhh
cyBiZWVuPGJyPg0KJmd0O8KgIMKgIMKgIHVzZWQuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIC1CZW48
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBSZWdhcmRzLDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8Kg
IMKgIFRlamFzd2luaTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIE9uIFR1ZSwgTWF5IDE5LCAy
MDE1IGF0IDU6MzcgUE0sPGJyPg0KJmd0O8KgIMKgIMKgIFRlamFzd2luaTxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgUG9sdXJpPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqA8YnI+DQo8
L2Rpdj48L2Rpdj4mZ3Q7wqAgwqAgwqAgJmx0O1sxXVszXVs0XVs1XVs2XVs3XTxhIGhyZWY9Im1h
aWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5j
b208L2E+Jmd0Ozxicj4NCjxzcGFuIGNsYXNzPSIiPiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
d3JvdGU6PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
VGhhbmtzIGEgbG90IEJlbi4gSSB3aWxsIGxvb2sgaW50bzxicj4NCiZndDvCoCDCoCDCoCBpdDxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgbW9yZS7CoDxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0
O8KgIMKgIMKgIE9uIE1vbiwgTWF5IDE4LCAyMDE1IGF0IDk6NTcgUE0sPGJyPg0KJmd0O8KgIMKg
IMKgIEJlbmphbWluPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
TWFyemluc2tpPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqA8YnI+DQo8L3NwYW4+Jmd0O8Kg
IMKgIMKgICZsdDtbMl1bNF1bNV1bNl1bN11bOF08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVk
aGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT4mZ3Q7PGJyPg0KPGRpdj48ZGl2IGNsYXNz
PSJoNSI+Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB3cm90ZTo8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZn
dDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBPbiBNb24sIE1heSAxOCwgMjAxNSBh
dDxicj4NCiZndDvCoCDCoCDCoCAwMjowOToyN1BNPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCArMDUzMCw8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBU
ZWphc3dpbmk8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgUG9sdXJpPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCB3cm90ZTo8YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZn
dDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgSGlpLDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKg
IMKgICZndDvCoCDCoCBXZSBhcmUgdHJ5aW5nIHRvIHRlc3Q8YnI+DQomZ3Q7wqAgwqAgwqAgbXVs
dGlwYXRoPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBzZXR1cCBpbjxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG91cjxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB0YXJnZXQgYW5kPGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCDCoCB0cmllZCB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCB2YXJpb3Vz
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIGNvbW1hbmRzIG9mIG11
bHRpcGF0aGQ8YnI+DQomZ3Q7wqAgwqAgwqAgZGVtYW9uIGFuZDxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgd2UgZmluZDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgIHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCBmb2xsb3dpbmc8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGVycm9yOjxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
wqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCByb290QHg4Ni1nZW5lcmljLTY0On4jPGJyPg0K
Jmd0O8KgIMKgIMKgIG11bHRpcGF0aGQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIC1r
JnF1b3Q7ZmFpbDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHBh
dGg8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgc2RjJnF1b3Q7Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgbXVsdGlwYXRoZDxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCAtayYjMzk7cmVpbnN0YXRlIHBhdGg8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgc2RjJiMzOTs7IG11bHRpcGF0aGQgLWsm
cXVvdDtzaG93PGJyPg0KJmd0O8KgIMKgIMKgIHBhdGhzJnF1b3Q7Ozxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBbIDM5NjIuNzA4NTIzXTxicj4NCiZndDvCoCDCoCDC
oCBkZXZpY2UtbWFwcGVyOjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgbXVsdGlwYXRo
Ojxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIEZhaWxpbmc8YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgIMKgIHBhdGjCoDg6MzIuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAg
Jmd0O8KgIMKgIG9rPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIG9r
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIGhjaWzCoCDCoCBkZXYg
ZGV2X3QgcHJpIGRtX3N0wqA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgY2hrX3N0
wqA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoG5leHRfY2hl
Y2s8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgNDowOjA6MSBzZGPC
oDg6MzLCoCAxwqA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgW2FjdGl2ZV1bZmF1
bHR5XTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIC4uLi4uLi4u
Li48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgMS8yMMKgPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCDCoCAmbHQ7Jmx0OyZsdDs9PT08YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IMKgICZndDvCoCDCoCDCoCDCoCBDSEVDSzxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKg
ICZndDvCoCDCoCA1OjA6MDoxIHNkZMKgODo0OMKgIDHCoDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgwqBbYWN0aXZlXVtyZWFkeV3CoDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIFhYLi4uLi4uLi48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgNC8yMDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKg
IMKgIMKgICZndDvCoCDCoCBzZGMgcGF0aCBiZWNvbWVzPGJyPg0KJmd0O8KgIMKgIMKgIFthY3Rp
dmVdW3JlYWR5XTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgb25seTxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGFmdGVyIHRoZTxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBwb2xsaW5nPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCDCoCBpbnRlcnZhbDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGJ1dCBu
b3Q8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgaW1tZWRpYXRlbHkg
YWZ0ZXIgdGhlPGJyPg0KJmd0O8KgIMKgIMKgIHJlaW5zdGF0ZTxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgcGF0aDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIGNvbW1hbmQuwqA8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAg
SSBhbSBvYnNlcnZpbmcgdGhpcyBpbjxicj4NCiZndDvCoCDCoCDCoCBsYXRlc3Q8YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG11bHRpcGF0aDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgIHRvb2xzIGluPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHVidW50dTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgbWFjaGlu
ZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGFzIHdlbGwuPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIFBsZWFzZSBsZXQgbWUga25vdyBpZiBpdHMgYTxi
cj4NCiZndDvCoCDCoCDCoCBrbm93bjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgaXNz
dWUgb3I8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBpZiBJPGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGFt
IGRvaW5nPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgc29tZXRoaW5nIHdyb25nLjxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBSZWdhcmRzLjxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBUZWphc3dpbmk8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCB0aGUgcmVpbnN0YXRlIGNv
bW1hbmQgaXMgc3VwcG9zZWQ8YnI+DQomZ3Q7wqAgwqAgwqAgdG88YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIHJlaW5zdGF0ZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgIHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCBkZXZpY2U8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIHdpdGggdGhlPGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgwqAga2VybmVsLCBhbmQgaXQgZG9lcyB0aGF0LiBUaGU8YnI+DQom
Z3Q7wqAgwqAgwqAgY2hlY2tlcjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgc3RhdGU8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBkb2VzbiYjMzk7dDxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBj
aGFuZ2U8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgIMKgIHVudGlsIHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKg
IMKgIMKgIG5leHQgdGltZSB0aGF0IHRoZSBwYXRoIGlzPGJyPg0KJmd0O8KgIMKgIMKgIGNoZWNr
ZWQuwqAgSTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgYWdyZWU8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB0aGF0IGl0JiMzOTtzPGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG9kZDxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgwqAgdGhhdCB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBjaGVjayBz
dGF0ZSBzd2l0Y2hlcyB0byBmYXVsdHkgYXM8YnI+DQomZ3Q7wqAgwqAgwqAgc29vbjxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgYXMgeW91PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgZmFpbCB0aGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgcGF0aCw8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGJ1dCBpdDxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGRvZXNuJiMzOTt0IHN3aXRjaCBiYWNrIHVu
dGlsIHRoZTxicj4NCiZndDvCoCDCoCDCoCBuZXh0IGNoZWNrPGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCBhZnRlcjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIHlvdTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCByZWluaXN0YXRlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBpdC48YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZn
dDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBUaGUgaXNzdWUgaXMgdGhhdCBtdWx0
aXBhdGhkPGJyPg0KJmd0O8KgIMKgIMKgIG5lZWRzIHRvPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCBvdmVycmlkZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCBjaGVja2VyPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBvdXRwdXQsPGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgwqAgc28gdGhhdCBhIGZhaWxlZCBwYXRoIHdvbiYjMzk7dCBiZTxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgaW1tZWRpdGF0ZWx5PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHJlaW5zdGF0ZWQuwqAgT25jZTxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgwqAgdGhlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgcGF0aCBj
b21lcyBiYWNrLCBtdWx0aXBhdGhkIHdhbnRzPGJyPg0KJmd0O8KgIMKgIMKgIHRvPGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCByZWNvcmQgdGhlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgc3dpdGNoPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIGluIHRoZTxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgY2hlY2tl
cjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIHRocmVhZCwgc28gdGhhdCBpdCBjYW4g
cmVmcmVzaDxicj4NCiZndDvCoCDCoCDCoCBwYXRoPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCBpbmZvcm1hdGlvbjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgIHdoYXQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgd2FzbiYjMzk7dDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIGF1dG9t
YXRpY2FsbHkgZG9uZSB3aGVuIHRoZSBwYXRoPGJyPg0KJmd0O8KgIMKgIMKgIHdhczxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHJlaW5zdGF0ZWQuwqA8YnI+DQom
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgSG93ZXZl
ciwgaXQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgIMKgIG1heSBtYWtlPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgwqAgbW9yZSBzZW5zZSB0byBoYXZlIGEgZGlmZmVyZW50PGJyPg0KJmd0O8KgIMKgIMKgIGNo
ZWNrZXI8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIHN0YXRlPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgZm9yIHdoZW48YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgdGhlPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDC
oCBkZXZpY2UgaXM8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCDCoCDCoCBpbiB0aGUgZmFpbGVk
IHN0YXRlLCBzbyB0aGF0IGl0JiMzOTtzPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBv
YnZpb3VzIHRoYXQ8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCB0
aGU8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgY2hlY2tlcjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgc3RhdGUgaXM8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvC
oCDCoCDCoCDCoCBiZWluZyBvdmVycnVsZWQuPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgLUJlbjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0Ozxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDsgLS08YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDC
oCDCoCDCoCAmZ3Q7IGRtLWRldmVsIG1haWxpbmcgbGlzdDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8Kg
IMKgIMKgIMKgICZndDs8YnI+DQo8L2Rpdj48L2Rpdj4mZ3Q7wqAgwqAgwqAgWzNdWzVdWzZdWzdd
WzhdWzldPGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhh
dC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0Ozxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoDxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqA8YnI+DQomZ3Q7wqAgwqAgwqAgWzRdWzZdWzddWzhdWzldWzEw
XTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0Ozxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgIC0tPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgwqAgZG0tZGV2ZWwgbWFpbGluZyBsaXN0PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
wqA8YnI+DQomZ3Q7wqAgwqAgwqAgWzVdWzddWzhdWzldWzEwXVsxMV08YSBocmVmPSJtYWlsdG86
ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
IMKgICZndDvCoCDCoCDCoCDCoDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqA8YnI+DQom
Z3Q7wqAgwqAgwqAgWzZdWzhdWzldWzEwXVsxMV1bMTJdPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdl
dD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7IFJlZmVyZW5j
ZXM8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCBWaXNpYmxl
IGxpbmtzPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAgMS48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgIG1haWx0bzpbOV1bMTBdWzExXVsxMl1bMTNdPGEgaHJlZj0ibWFpbHRvOnRlamFz
d2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgIMKgICZndDvCoCDCoCAyLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
bWFpbHRvOlsxMF1bMTFdWzEyXVsxM11bMTRdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhh
dC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCDCoCAmZ3Q7wqAgwqAg
My48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIG1haWx0bzpbMTFdWzEyXVsxM11bMTRd
WzE1XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQu
Y29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIDQuPGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgPGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoDxicj4NCiZndDvCoCDCoCDCoCBbMTJdWzEzXVsxNF1bMTVdWzE2XTxhIGhyZWY9
Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJu
b3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgwqAgJmd0O8KgIMKgIDUuPGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCBtYWlsdG86WzEzXVsxNF1bMTVdWzE2XVsxN108YSBo
cmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgIMKgICZndDvCoCDCoCA2Ljxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoDxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAg
wqA8YnI+DQomZ3Q7wqAgwqAgwqAgWzE0XVsxNV1bMTZdWzE3XVsxOF08YSBocmVmPSJodHRwczov
L3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJl
ciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7IFJlZmVyZW5jZXM8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0Ozxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgVmlzaWJs
ZSBsaW5rczxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgMS48YnI+DQomZ3Q7wqAgwqAgwqAgbWFpbHRvOlsxNl1bMTddWzE4
XVsxOV08YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2lu
aXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgMi4gbWFpbHRvOlsxN11bMThdWzE5XVsy
MF08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNv
bTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIDMuPGJyPg0KJmd0O8KgIMKgIMKgIG1haWx0bzpbMThdWzE5XVsyMF1b
MjFdPGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlw
b2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDQuIG1haWx0bzpbMTldWzIwXVsyMV1bMjJd
PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208
L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCA1LiBtYWlsdG86WzIwXVsyMV1bMjJdWzIzXTxhIGhyZWY9Im1haWx0bzpk
bS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgNi48
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgIFsyMV1bMjJdWzIzXVsyNF08YSBocmVmPSJo
dHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9y
ZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDcuIG1haWx0bzpbMjJdWzIzXVsyNF1bMjVd
PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208
L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCA4Ljxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgWzIzXVsyNF1b
MjVdWzI2XTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgOS48YnI+DQom
Z3Q7wqAgwqAgwqAgbWFpbHRvOlsyNF1bMjVdWzI2XVsyN108YSBocmVmPSJtYWlsdG86dGVqYXN3
aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAxMC4gbWFpbHRvOlsyNV1bMjZdWzI3XVsyOF08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNA
cmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTEuIG1haWx0bzpb
MjZdWzI3XVsyOF1bMjldPGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRl
dmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoDEyLjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgWzI3XVsyOF1bMjldWzMwXTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFp
bG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+
aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAxMy4gbWFpbHRvOlsyOF1bMjldWzMwXVszMV08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxA
cmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTQuPGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCBbMjldWzMwXVszMV1bMzJdPGEgaHJlZj0iaHR0cHM6Ly93
d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIi
IHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0Ozxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDsgUmVm
ZXJlbmNlczxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgVmlz
aWJsZSBsaW5rczxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCAxLiBtYWlsdG86WzMxXVszMl1bMzNdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJl
ZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDIuIG1haWx0bzpbMzJdWzMzXVszNF08YSBo
cmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNA
Z21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCAzLiBtYWlsdG86WzMzXVszNF1bMzVdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5z
QHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDQuIG1haWx0bzpbMzRdWzM1XVszNl08
YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVy
aTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoCA1LiBtYWlsdG86WzM1XVszNl1bMzddPGEgaHJlZj0ibWFpbHRvOmJtYXJ6
aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDYuIG1haWx0bzpbMzZdWzM3XVsz
OF08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNv
bTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgNy48YnI+DQomZ3Q7wqAgwqAgwqAgWzM3XVszOF1bMzldPGEgaHJlZj0iaHR0cHM6Ly93d3cu
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRh
cmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIDguIG1haWx0bzpbMzhdWzM5XVs0MF08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVk
aGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgOS48YnI+DQomZ3Q7wqAgwqAgwqAgWzM5XVs0
MF1bNDFdPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTAuIG1haWx0bzpbNDBdWzQxXVs0Ml08
YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVy
aTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoDExLiBtYWlsdG86WzQxXVs0Ml1bNDNdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6
aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTIuIG1haWx0bzpbNDJdWzQzXVs0
NF08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNv
bTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAxMy48YnI+DQomZ3Q7wqAgwqAgwqAgWzQzXVs0NF1bNDVdPGEgaHJlZj0iaHR0cHM6Ly93d3cu
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRh
cmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgMTQuIG1haWx0bzpbNDRdWzQ1XVs0Nl08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVk
aGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAxNS48YnI+DQomZ3Q7wqAgwqAgwqAgWzQ1XVs0
Nl1bNDddPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTYuIG1haWx0bzpbNDZdWzQ3XVs0OF08
YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVy
aTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
IMKgICZndDvCoCDCoDE3LiBtYWlsdG86WzQ3XVs0OF1bNDldPGEgaHJlZj0ibWFpbHRvOmJtYXJ6
aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTguIG1haWx0bzpbNDhdWzQ5XVs1
MF08YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBv
bHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoDE5LiBtYWlsdG86WzQ5XVs1MF1bNTFdPGEgaHJlZj0ibWFpbHRvOmJt
YXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMjAuIG1haWx0bzpbNTBdWzUx
XVs1Ml08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0
LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAyMS48YnI+DQomZ3Q7wqAgwqAgwqAgWzUxXVs1Ml1bNTNdPGEgaHJlZj0iaHR0cHM6Ly93
d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIi
IHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgMjIuIG1haWx0bzpbNTJdWzUzXVs1NF08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxA
cmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAyMy48YnI+DQomZ3Q7wqAgwqAgwqAgWzUz
XVs1NF1bNTVdPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMjQuIG1haWx0bzpbNTRdWzU1XVs1
Nl08YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBv
bHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoDI1LiBtYWlsdG86WzU1XVs1Nl1bNTddPGEgaHJlZj0ibWFpbHRvOmJt
YXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMjYuIG1haWx0bzpbNTZdWzU3
XVs1OF08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0
LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAyNy48YnI+DQomZ3Q7wqAgwqAgwqAgWzU3XVs1OF1bNTldPGEgaHJlZj0iaHR0cHM6Ly93
d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIi
IHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgMjguIG1haWx0bzpbNThdWzU5XVs2MF08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxA
cmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAyOS48YnI+DQomZ3Q7wqAgwqAgwqAgWzU5
XVs2MF1bNjFdPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7IFJl
ZmVyZW5jZXM8YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDs8YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoCBWaXNpYmxlIGxpbmtzPGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgMS4gbWFpbHRvOls2MV1bNjJdPGEgaHJlZj0ibWFp
bHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgMi4gbWFpbHRvOls2Ml1bNjNdPGEgaHJl
Zj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgMy4gbWFpbHRvOls2M11bNjRd
PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1
cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oCA0LiBtYWlsdG86WzY0XVs2NV08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+
Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCA1LiBtYWlsdG86WzY1XVs2Nl08YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJp
M0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDYuIG1haWx0bzpbNjZdWzY3XTxhIGhyZWY9Im1h
aWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDcuIG1haWx0bzpbNjddWzY4XTxhIGhy
ZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxi
cj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDguIFs2OF1bNjldPGEgaHJl
Zj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9
Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAm
Z3Q7wqAgwqAgOS4gbWFpbHRvOls2OV1bNzBdPGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhh
dC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAxMC4gWzcwXVs3MV08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxh
bmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoDExLiBtYWlsdG86WzcxXVs3
Ml08YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBv
bHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgMTIuIG1haWx0bzpbNzJdWzczXTxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29t
Ij5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgMTMuIG1haWx0bzpbNzNdWzc0XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRo
YXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAgwqAgJmd0O8KgIMKgMTQuIFs3NF1bNzVdPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2Js
YW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAxNS4gbWFpbHRvOls3NV1b
NzZdPGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5j
b208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAxNi4gWzc2XVs3
N108YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgIMKgICZndDvCoCDCoDE3LiBtYWlsdG86Wzc3XVs3OF08YSBocmVmPSJtYWlsdG86dGVqYXN3
aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTguIG1haWx0bzpbNzhdWzc5XTxh
IGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9h
Pjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTkuIG1haWx0bzpbNzld
WzgwXTxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5p
cG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAyMC4gbWFpbHRvOls4MF1bODFdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5j
b20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAyMS4gbWFpbHRvOls4MV1bODJdPGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJl
ZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAyMi4gWzgyXVs4M108YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQu
Y29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJf
YmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwv
YT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoDIzLiBtYWlsdG86Wzgz
XVs4NF08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0
LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoDI0LiBbODRd
Wzg1XTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgMjUuIG1haWx0bzpbODVdWzg2XTxhIGhyZWY9Im1haWx0bzp0ZWph
c3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAyNi4gbWFpbHRvOls4Nl1bODdd
PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208
L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAyNy4gbWFpbHRvOls4
N11bODhdPGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhh
dC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAyOC4gWzg4
XVs4OV08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgIMKgICZndDvCoCDCoDI5LiBtYWlsdG86Wzg5XVs5MF08YSBocmVmPSJtYWlsdG86ZG0t
ZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoDMwLiBbOTBdWzkxXTxhIGhyZWY9Imh0dHBzOi8vd3d3
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0
YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMzEuIG1h
aWx0bzpbOTFdWzkyXTxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemlu
c0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
MzIuIG1haWx0bzpbOTJdWzkzXTxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWls
LmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAzMy4gbWFpbHRvOls5M11bOTRdPGEgaHJlZj0ibWFpbHRvOmJt
YXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAzNC4gbWFpbHRvOls5NF1bOTVdPGEgaHJlZj0ibWFp
bHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNv
bTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoDM1LiBtYWlsdG86
Wzk1XVs5Nl08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVk
aGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoDM2LiBt
YWlsdG86Wzk2XVs5N108YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2
ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDC
oDM3LiBbOTddWzk4XTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93
d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMzguIG1haWx0bzpbOThdWzk5XTxhIGhyZWY9Im1h
aWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMzkuIFs5OV1bMTAwXTxhIGhyZWY9Imh0
dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3Jl
ZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgNDAuIG1haWx0bzpbMTAwXVsxMDFdPGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNA
Z21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoDQxLiBtYWlsdG86WzEwMV1bMTAyXTxhIGhyZWY9Im1h
aWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZn
dDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNDIuIG1haWx0bzpbMTAyXVsxMDNdPGEg
aHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqA0My48YnI+DQomZ3Q7wqAg
wqAgwqAgWzEwM11bMTA0XTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6
Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNDQuIG1haWx0bzpbMTA0XVsxMDVdPGEgaHJl
Zj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqA0NS48YnI+DQomZ3Q7wqAgwqAg
wqAgWzEwNV1bMTA2XTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93
d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNDYuIG1haWx0bzpbMTA2XVsxMDddPGEgaHJlZj0i
bWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWls
LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoDQ3LiBtYWls
dG86WzEwN11bMTA4XTxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemlu
c0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
NDguIG1haWx0bzpbMTA4XVsxMDldPGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21h
aWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAg
Jmd0O8KgIMKgIMKgICZndDvCoCDCoDQ5LiBtYWlsdG86WzEwOV1bMTEwXTxhIGhyZWY9Im1haWx0
bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNTAuIG1haWx0bzpbMTEwXVsxMTFdPGEgaHJl
Zj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqA1MS48YnI+DQomZ3Q7wqAgwqAg
wqAgWzExMV1bMTEyXTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93
d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNTIuIG1haWx0bzpbMTEyXVsxMTNdPGEgaHJlZj0i
bWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAgwqA1My48YnI+DQomZ3Q7wqAgwqAgwqAg
WzExM11bMTE0XTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cu
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNTQuIG1haWx0bzpbMTE0XVsxMTVdPGEgaHJlZj0ibWFp
bHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNv
bTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIMKgICZndDvCoCDCoDU1LiBtYWlsdG86
WzExNV1bMTE2XTxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0By
ZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNTYu
IG1haWx0bzpbMTE2XVsxMTddPGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRt
LWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqA1Ny48YnI+DQomZ3Q7wqAgwqAgwqAgWzExN11bMTE4XTxhIGhyZWY9Imh0dHBzOi8vd3d3
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0
YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNTguIG1h
aWx0bzpbMTE4XVsxMTldPGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRl
dmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqA1OS48YnI+DQomZ3Q7wqAgwqAgwqAgWzExOV1bMTIwXTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJn
ZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVsPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDsgUmVm
ZXJlbmNlczxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCBWaXNpYmxlIGxpbmtzPGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoCAxLiBtYWlsdG86WzEy
MV08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNv
bTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDIuIG1haWx0bzpbMTIyXTxhIGhyZWY9
Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAgMy4gbWFpbHRvOlsxMjNdPGEgaHJlZj0ibWFpbHRvOmJt
YXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoCA0LiBtYWlsdG86WzEyNF08YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9s
dXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqAgNS4gbWFpbHRvOlsxMjVdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5z
QHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoCA2LiBtYWlsdG86WzEyNl08YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0Bn
bWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqAgNy4gbWFpbHRvOlsxMjddPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhh
dC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oCA4LiBtYWlsdG86WzEyOF08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0t
ZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgIDkuIFsxMjld
PGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
IiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oDEwLiBtYWlsdG86WzEzMF08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0t
ZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTEuIFsxMzFd
PGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
IiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oDEyLiBtYWlsdG86WzEzMl08YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5j
b20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqAxMy4gbWFpbHRvOlsxMzNdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20i
PmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDE0LiBt
YWlsdG86WzEzNF08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxA
cmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTUuIFsxMzVdPGEgaHJl
Zj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9
Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDE2LiBt
YWlsdG86WzEzNl08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxA
cmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMTcuIFsxMzddPGEgaHJl
Zj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9
Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDE4LiBt
YWlsdG86WzEzOF08YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRl
amFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAx
OS4gbWFpbHRvOlsxMzldPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6
aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDIwLiBtYWlsdG86
WzE0MF08YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2lu
aXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAyMS4gbWFp
bHRvOlsxNDFdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJl
ZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDIyLiBtYWlsdG86WzE0Ml08
YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwv
YT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMjMuIFsxNDNdPGEgaHJlZj0iaHR0cHM6Ly93
d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIi
IHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDI0LiBtYWlsdG86WzE0NF08
YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwv
YT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMjUuIFsxNDVdPGEgaHJlZj0iaHR0cHM6Ly93
d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIi
IHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDI2LiBtYWlsdG86WzE0Nl08
YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVy
aTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqAyNy4gbWFpbHRvOlsx
NDddPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5j
b208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDI4LiBtYWlsdG86WzE0OF08YSBocmVm
PSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMjkuIFsxNDldPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdl
dD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDMwLiBtYWlsdG86WzE1MF08YSBocmVm
PSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMzEuIFsxNTFdPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdl
dD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDMyLiBtYWlsdG86WzE1Ml08YSBocmVm
PSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgMzMuIG1haWx0bzpbMTUzXTxhIGhyZWY9Im1haWx0bzp0
ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDM0LiBtYWlsdG86WzE1NF08YSBocmVmPSJtYWls
dG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7
wqAgwqAgwqAgJmd0O8KgIMKgMzUuIG1haWx0bzpbMTU1XTxhIGhyZWY9Im1haWx0bzp0ZWphc3dp
bmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0K
Jmd0O8KgIMKgIMKgICZndDvCoCDCoDM2LiBtYWlsdG86WzE1Nl08YSBocmVmPSJtYWlsdG86Ym1h
cnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgMzcuIG1haWx0bzpbMTU3XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRo
YXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqAzOC4gWzE1OF08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgMzkuIG1haWx0bzpbMTU5XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRo
YXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAg
wqA0MC4gWzE2MF08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIMKgNDEuIG1haWx0bzpbMTYxXTxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1
cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCDCoDQyLiBtYWlsdG86WzE2Ml08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNA
cmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgNDMuIG1haWx0bzpbMTYzXTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29t
Ij5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqA0NC4g
WzE2NF08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgNDUuIG1haWx0bzpbMTY1XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29t
Ij5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqA0Ni4g
WzE2Nl08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0
O8KgIMKgNDcuIG1haWx0bzpbMTY3XTxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdt
YWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKg
ICZndDvCoCDCoDQ4LiBtYWlsdG86WzE2OF08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0
LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKg
NDkuIG1haWx0bzpbMTY5XTxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNv
bSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCDCoDUwLiBtYWlsdG86WzE3MF08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+
Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNTEuIG1h
aWx0bzpbMTcxXTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEBy
ZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqA1Mi4gWzE3Ml08YSBocmVm
PSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0i
bm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNTMuIG1h
aWx0bzpbMTczXTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEBy
ZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqA1NC4gWzE3NF08YSBocmVm
PSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0i
bm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNTUuIG1h
aWx0bzpbMTc1XTxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVq
YXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDU2
LiBtYWlsdG86WzE3Nl08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnpp
bnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNTcuIG1haWx0bzpb
MTc3XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQu
Y29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqA1OC4gWzE3OF08YSBocmVmPSJodHRw
czovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZl
cnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNTkuIG1haWx0bzpb
MTc5XTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQu
Y29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqA2MC4gWzE4MF08YSBocmVmPSJodHRw
czovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZl
cnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNjEuIG1haWx0bzpb
MTgxXTxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQu
Y29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqA2Mi4gbWFpbHRvOlsxODJdPGEgaHJl
Zj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJy
Pg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDYzLiBtYWlsdG86WzE4M108YSBocmVmPSJtYWlsdG86
dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9h
Pjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqA2NC4gbWFpbHRvOlsxODRdPGEgaHJlZj0ibWFp
bHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0
O8KgIMKgIMKgICZndDvCoCDCoDY1LiBtYWlsdG86WzE4NV08YSBocmVmPSJtYWlsdG86dGVqYXN3
aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4N
CiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqA2Ni4gbWFpbHRvOlsxODZdPGEgaHJlZj0ibWFpbHRvOmJt
YXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoDY3LiBtYWlsdG86WzE4N108YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVk
aGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgNjguIFsxODhdPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3
dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoDY5LiBtYWlsdG86WzE4OV08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVk
aGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IMKgNzAuIFsxOTBdPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3
dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKg
IMKgICZndDvCoCDCoDcxLiBtYWlsdG86WzE5MV08YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9s
dXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvC
oCDCoCDCoCAmZ3Q7wqAgwqA3Mi4gbWFpbHRvOlsxOTJdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5z
QHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoDczLiBtYWlsdG86WzE5M108YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNv
bSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNzQu
IFsxOTRdPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoDc1LiBtYWlsdG86WzE5NV08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNv
bSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgNzYu
IFsxOTZdPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCDCoDc3LiBtYWlsdG86WzE5N108YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0Bn
bWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDC
oCAmZ3Q7wqAgwqA3OC4gbWFpbHRvOlsxOThdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhh
dC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDC
oDc5LiBtYWlsdG86WzE5OV08YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5j
b20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgwqA4MC4gbWFpbHRvOlsyMDBdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20i
PmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDgxLiBt
YWlsdG86WzIwMV08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxA
cmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgODIuIFsyMDJdPGEgaHJl
Zj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9
Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDgzLiBt
YWlsdG86WzIwM108YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxA
cmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgODQuIFsyMDRdPGEgaHJl
Zj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9
Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDg1LiBt
YWlsdG86WzIwNV08YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRl
amFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgwqA4
Ni4gbWFpbHRvOlsyMDZdPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6
aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDg3LiBtYWlsdG86
WzIwN108YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0
LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgODguIFsyMDhdPGEgaHJlZj0iaHR0
cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVm
ZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDg5LiBtYWlsdG86
WzIwOV08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0
LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgOTAuIFsyMTBdPGEgaHJlZj0iaHR0
cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVm
ZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDkxLiBtYWlsdG86
WzIxMV08YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0
LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgOTIuIG1haWx0bzpbMjEyXTxhIGhy
ZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0Bn
bWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDkzLiBtYWlsdG86WzIxM108
YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwv
YT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgOTQuIG1haWx0bzpbMjE0XTxhIGhyZWY9Im1h
aWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5j
b208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCDCoDk1LiBtYWlsdG86WzIxNV08YSBocmVm
PSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgOTYuIG1haWx0bzpbMjE2XTxhIGhyZWY9Im1haWx0bzpk
bS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqA5Ny4gWzIxN108YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsi
Pmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIMKgOTguIG1haWx0bzpbMjE4XTxhIGhyZWY9Im1haWx0bzpk
bS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgwqA5OS4gWzIxOV08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsi
Pmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+
DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIDEwMC4gbWFpbHRvOlsyMjBdPGEgaHJlZj0ibWFpbHRvOnRl
amFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48
YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIDEwMS4gbWFpbHRvOlsyMjFdPGEgaHJlZj0ibWFpbHRv
OmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8Kg
IMKgIMKgICZndDvCoCAxMDIuIG1haWx0bzpbMjIyXTxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEBy
ZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7
wqAgMTAzLiBbMjIzXTxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93
d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDC
oCDCoCAmZ3Q7wqAgMTA0LiBtYWlsdG86WzIyNF08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVk
aGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8Kg
IDEwNS4gWzIyNV08YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAg
wqAgJmd0O8KgIDEwNi4gbWFpbHRvOlsyMjZdPGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVy
aTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAg
wqAgwqAgJmd0O8KgIDEwNy4gbWFpbHRvOlsyMjddPGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJl
ZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvC
oCAxMDguIG1haWx0bzpbMjI4XTxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWls
LmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZn
dDvCoCAxMDkuIG1haWx0bzpbMjI5XTxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29t
Ij5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgMTEwLiBt
YWlsdG86WzIzMF08YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxA
cmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIDExMS4gWzIzMV08YSBocmVm
PSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0i
bm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIDExMi4gbWFp
bHRvOlsyMzJdPGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJl
ZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCAxMTMuIFsyMzNdPGEgaHJlZj0i
aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5v
cmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCAxMTQuIG1haWx0
bzpbMjM0XTxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3
aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCAxMTUuIG1h
aWx0bzpbMjM1XTxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0By
ZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoCDCoCAmZ3Q7wqAgMTE2LiBtYWlsdG86WzIzNl08
YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwv
YT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIDExNy4gWzIzN108YSBocmVmPSJodHRwczovL3d3
dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIg
dGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqAgwqAgJmd0O8KgIDExOC4gbWFpbHRvOlsyMzhdPGEg
aHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+
PGJyPg0KJmd0O8KgIMKgIMKgICZndDvCoCAxMTkuIFsyMzldPGEgaHJlZj0iaHR0cHM6Ly93d3cu
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRh
cmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWw8L2E+PGJyPg0KPHNwYW4gY2xhc3M9IiI+Jmd0Ozxicj4NCiZndDsgUmVmZXJlbmNlczxi
cj4NCiZndDs8YnI+DQomZ3Q7wqAgwqAgVmlzaWJsZSBsaW5rczxicj4NCiZndDvCoCDCoCAxLiBt
YWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhh
dC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIDIuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86Ym1hcnpp
bnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAgMy4g
bWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRo
YXQuY29tPC9hPjxicj4NCjwvc3Bhbj48c3BhbiBjbGFzcz0iIj4mZ3Q7wqAgwqAgNC4gbWFpbHRv
OjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29t
PC9hPjxicj4NCiZndDvCoCDCoCA1LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBv
bHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7
wqAgwqAgNi4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFy
emluc0ByZWRoYXQuY29tPC9hPjxicj4NCjwvc3Bhbj4mZ3Q7wqAgwqAgNy4gbWFpbHRvOjxhIGhy
ZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0Bn
bWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgIDguIG1haWx0bzo8YSBocmVmPSJtYWlsdG86Ym1h
cnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQo8c3BhbiBjbGFz
cz0iIj4mZ3Q7wqAgwqAgOS4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQu
Y29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDEwLiA8YSBocmVmPSJo
dHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9y
ZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQo8L3NwYW4+PHNwYW4gY2xhc3M9IiI+Jmd0O8KgIMKg
MTEuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxA
cmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAxMi4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdl
dD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWw8L2E+PGJyPg0KPC9zcGFuPiZndDvCoCDCoDEzLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOnRl
amFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48
YnI+DQomZ3Q7wqAgwqAxNC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQu
Y29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCjxzcGFuIGNsYXNzPSIiPiZndDvCoCDC
oDE1LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVs
QHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgMTYuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJn
ZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVsPC9hPjxicj4NCjwvc3Bhbj4mZ3Q7wqAgwqAxNy4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpk
bS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDC
oDE4LiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQo8c3BhbiBjbGFzcz0iIj4m
Z3Q7wqAgwqAxOS4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWls
LmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgMjAuIG1h
aWx0bzo8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0
LmNvbTwvYT48YnI+DQo8L3NwYW4+Jmd0O8KgIMKgMjEuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86
dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9h
Pjxicj4NCiZndDvCoCDCoDIyLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhh
dC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KPHNwYW4gY2xhc3M9IiI+Jmd0O8Kg
IMKgMjMuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2
ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAyNC4gPGEgaHJlZj0iaHR0cHM6Ly93d3cu
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRh
cmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWw8L2E+PGJyPg0KPC9zcGFuPiZndDvCoCDCoDI1LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRv
OmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8Kg
IMKgMjYuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoDI3LiBt
YWlsdG86PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dp
bmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAyOC4gbWFpbHRvOjxhIGhyZWY9
Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4N
CjxzcGFuIGNsYXNzPSIiPiZndDvCoCDCoDI5LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRl
dmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgMzAu
IDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCjwvc3Bhbj4mZ3Q7wqAgwqAzMS4g
bWFpbHRvOjxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRo
YXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDMyLiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQu
Y29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJf
YmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwv
YT48YnI+DQo8c3BhbiBjbGFzcz0iIj4mZ3Q7wqAgwqAzMy4gbWFpbHRvOjxhIGhyZWY9Im1haWx0
bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvC
oCDCoDM0LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29t
Ij50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgwqAzNS4gbWFpbHRv
OjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29t
PC9hPjxicj4NCjwvc3Bhbj4mZ3Q7wqAgwqAzNi4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0ZWph
c3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJy
Pg0KJmd0O8KgIMKgMzcuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNv
bSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQo8c3BhbiBjbGFzcz0iIj4mZ3Q7wqAgwqAz
OC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEBy
ZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDM5LiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0
PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bDwvYT48YnI+DQo8L3NwYW4+Jmd0O8KgIMKgNDAuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0t
ZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA0
MS4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQu
Y29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIMKgNDIuIG1haWx0
bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBv
bHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDCoDQzLiBtYWlsdG86PGEgaHJlZj0ibWFp
bHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KPHNw
YW4gY2xhc3M9IiI+Jmd0O8KgIMKgNDQuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxA
cmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA0NS4gPGEg
aHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiBy
ZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KPC9zcGFuPiZndDvCoCDCoDQ2LiBtYWls
dG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5j
b208L2E+PGJyPg0KJmd0O8KgIMKgNDcuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFu
ayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxi
cj4NCjxzcGFuIGNsYXNzPSIiPiZndDvCoCDCoDQ4LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOnRl
amFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48
YnI+DQomZ3Q7wqAgwqA0OS4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQu
Y29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCjwvc3Bhbj4mZ3Q7wqAgwqA1MC4gbWFp
bHRvOjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5p
cG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgNTEuIG1haWx0bzo8YSBocmVmPSJt
YWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQo8
c3BhbiBjbGFzcz0iIj4mZ3Q7wqAgwqA1Mi4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpkbS1kZXZl
bEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDUzLiA8
YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwi
IHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQo8L3NwYW4+Jmd0O8KgIMKgNTQuIG1h
aWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0
LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA1NS4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2Js
YW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+
PGJyPg0KJmd0O8KgIMKgNTYuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJp
M0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCDC
oDU3LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5z
QHJlZGhhdC5jb208L2E+PGJyPg0KPHNwYW4gY2xhc3M9IiI+Jmd0O8KgIMKgNTguIG1haWx0bzo8
YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwv
YT48YnI+DQomZ3Q7wqAgwqA1OS4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWls
bWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5o
dHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0K
PC9zcGFuPiZndDvCoCDCoDYwLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhh
dC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgNjEuIDxhIGhyZWY9
Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJu
b3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoDYyLiBtYWlsdG86PGEgaHJlZj0i
bWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0K
Jmd0O8KgIMKgNjMuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+
Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA2NC4gbWFpbHRvOjxhIGhyZWY9
Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFp
bC5jb208L2E+PGJyPg0KJmd0O8KgIMKgNjUuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86Ym1hcnpp
bnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA2Ni4g
bWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3
aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgNjcuIG1haWx0bzo8YSBocmVm
PSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+
DQomZ3Q7wqAgwqA2OC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29t
Ij5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDY5LiA8YSBocmVmPSJodHRw
czovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZl
cnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqA3MC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0
bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvC
oCDCoDcxLiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqA3Mi4g
bWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3
aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgNzMuIG1haWx0bzo8YSBocmVm
PSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+
DQomZ3Q7wqAgwqA3NC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29t
Ij5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDc1LiA8YSBocmVmPSJodHRw
czovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZl
cnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqA3Ni4gbWFpbHRvOjxhIGhyZWY9Im1haWx0
bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvC
oCDCoDc3LiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqA3OC4g
bWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3
aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgNzkuIG1haWx0bzo8YSBocmVm
PSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+
DQomZ3Q7wqAgwqA4MC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdt
YWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgODEu
IG1haWx0bzo8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVk
aGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA4Mi4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpkbS1k
ZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDgz
LiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqA4NC4gbWFpbHRv
OjxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29t
PC9hPjxicj4NCiZndDvCoCDCoDg1LiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsi
Pmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+
DQomZ3Q7wqAgwqA4Ni4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdt
YWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIMKgODcu
IG1haWx0bzo8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVk
aGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA4OC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpkbS1k
ZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDg5
LiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgwqA5MC4gbWFpbHRv
OjxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29t
PC9hPjxicj4NCiZndDvCoCDCoDkxLiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsi
Pmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+
DQomZ3Q7wqAgwqA5Mi4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29t
Ij5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDkzLiBtYWlsdG86PGEgaHJl
Zj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdt
YWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA5NC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFy
emluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCDCoDk1
LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWph
c3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgwqA5Ni4gbWFpbHRvOjxhIGhy
ZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxi
cj4NCiZndDvCoCDCoDk3LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5j
b20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIMKgOTguIDxhIGhyZWY9Imh0
dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3Jl
ZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCDCoDk5LiBtYWlsdG86PGEgaHJlZj0ibWFp
bHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0
O8KgIDEwMC4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIDEwMS4g
bWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3
aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIDEwMi4gbWFpbHRvOjxhIGhyZWY9
Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4N
CiZndDvCoCAxMDMuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+
ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgMTA0LiA8YSBocmVmPSJodHRwczov
L3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJl
ciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgMTA1LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRt
LWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIDEw
Ni4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQu
Y29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIDEwNy4gbWFpbHRv
OjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9s
dXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIDEwOC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0
bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvC
oCAxMDkuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20i
PnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCAxMTAuIG1haWx0bzo8
YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwv
YT48YnI+DQomZ3Q7wqAgMTExLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhh
dC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIDExMi4gPGEgaHJlZj0i
aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5v
cmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIDExMy4gbWFpbHRvOjxhIGhyZWY9Im1h
aWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZn
dDvCoCAxMTQuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cu
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCAxMTUu
IG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFz
d2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCAxMTYuIG1haWx0bzo8YSBocmVm
PSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+
DQomZ3Q7wqAgMTE3LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20i
PmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIDExOC4gPGEgaHJlZj0iaHR0cHM6
Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJy
ZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIDExOS4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpk
bS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCAx
MjAuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCAxMjEuIG1haWx0
bzo8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNv
bTwvYT48YnI+DQomZ3Q7wqAgMTIyLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJl
ZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIDEyMy4gbWFpbHRv
OjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29t
PC9hPjxicj4NCiZndDvCoCAxMjQuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9s
dXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvC
oCAxMjUuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnpp
bnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgMTI2LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRv
OnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwv
YT48YnI+DQomZ3Q7wqAgMTI3LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhh
dC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIDEyOC4gbWFpbHRvOjxh
IGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9h
Pjxicj4NCiZndDvCoCAxMjkuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0
cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZn
dDvCoCAxMzAuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0t
ZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgMTMxLiA8YSBocmVmPSJodHRwczovL3d3
dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIg
dGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgMTMyLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOnRlamFz
d2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+
DQomZ3Q7wqAgMTMzLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20i
PmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIDEzNC4gbWFpbHRvOjxhIGhyZWY9
Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4N
CiZndDvCoCAxMzUuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93
d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCAx
MzYuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxA
cmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgMTM3LiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0
PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bDwvYT48YnI+DQomZ3Q7wqAgMTM4LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBv
bHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7
wqAgMTM5LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6
aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIDE0MC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0
bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208
L2E+PGJyPg0KJmd0O8KgIDE0MS4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRo
YXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCAxNDIuIG1haWx0bzo8
YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwv
YT48YnI+DQomZ3Q7wqAgMTQzLiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0
dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQom
Z3Q7wqAgMTQ0LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRt
LWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIDE0NS4gPGEgaHJlZj0iaHR0cHM6Ly93
d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIi
IHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIDE0Ni4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0ZWph
c3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJy
Pg0KJmd0O8KgIDE0Ny4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29t
Ij5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCAxNDguIG1haWx0bzo8YSBocmVm
PSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+
DQomZ3Q7wqAgMTQ5LiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8v
d3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAg
MTUwLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVs
QHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIDE1MS4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdl
dD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWw8L2E+PGJyPg0KJmd0O8KgIDE1Mi4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0By
ZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCAxNTMuIG1haWx0
bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBv
bHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCAxNTQuIG1haWx0bzo8YSBocmVmPSJtYWls
dG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7
wqAgMTU1LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29t
Ij50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgMTU2LiBtYWlsdG86
PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208
L2E+PGJyPg0KJmd0O8KgIDE1Ny4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRo
YXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCAxNTguIDxhIGhyZWY9
Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJu
b3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCAxNTkuIG1haWx0bzo8YSBocmVmPSJt
YWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQom
Z3Q7wqAgMTYwLiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgMTYx
LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWph
c3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgMTYyLiBtYWlsdG86PGEgaHJl
Zj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJy
Pg0KJmd0O8KgIDE2My4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29t
Ij5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCAxNjQuIDxhIGhyZWY9Imh0dHBz
Oi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVy
cmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCAxNjUuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86
ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAg
MTY2LiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgMTY3LiBtYWls
dG86PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlw
b2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgMTY4LiBtYWlsdG86PGEgaHJlZj0ibWFp
bHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0
O8KgIDE2OS4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNv
bSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIDE3MC4gbWFpbHRv
OjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29t
PC9hPjxicj4NCiZndDvCoCAxNzEuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVk
aGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgMTcyLiA8YSBocmVm
PSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0i
bm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgMTczLiBtYWlsdG86PGEgaHJlZj0i
bWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0K
Jmd0O8KgIDE3NC4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3
dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIDE3
NS4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVq
YXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIDE3Ni4gbWFpbHRvOjxhIGhy
ZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxi
cj4NCiZndDvCoCAxNzcuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNv
bSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgMTc4LiA8YSBocmVmPSJodHRw
czovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZl
cnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgMTc5LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRv
OmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8Kg
IDE4MC4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIDE4MS4gbWFp
bHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQu
Y29tPC9hPjxicj4NCiZndDvCoCAxODIuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNA
cmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgMTgzLiBtYWls
dG86PGEgaHJlZj0ibWFpbHRvOnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlw
b2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQomZ3Q7wqAgMTg0LiBtYWlsdG86PGEgaHJlZj0ibWFp
bHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0
O8KgIDE4NS4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNv
bSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIDE4Ni4gbWFpbHRv
OjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29t
PC9hPjxicj4NCiZndDvCoCAxODcuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVk
aGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgMTg4LiA8YSBocmVm
PSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0i
bm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgMTg5LiBtYWlsdG86PGEgaHJlZj0i
bWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0K
Jmd0O8KgIDE5MC4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3
dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIDE5
MS4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVq
YXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIDE5Mi4gbWFpbHRvOjxhIGhy
ZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxi
cj4NCiZndDvCoCAxOTMuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNv
bSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgMTk0LiA8YSBocmVmPSJodHRw
czovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZl
cnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7wqAgMTk1LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRv
OmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8Kg
IDE5Ni4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIDE5Ny4gbWFp
bHRvOjxhIGhyZWY9Im1haWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5p
cG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0KJmd0O8KgIDE5OC4gbWFpbHRvOjxhIGhyZWY9Im1h
aWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZn
dDvCoCAxOTkuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5j
b20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCAyMDAuIG1haWx0
bzo8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNv
bTwvYT48YnI+DQomZ3Q7wqAgMjAxLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJl
ZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIDIwMi4gPGEgaHJl
Zj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9
Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIDIwMy4gbWFpbHRvOjxhIGhyZWY9
Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4N
CiZndDvCoCAyMDQuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93
d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCAy
MDUuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRl
amFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPjxicj4NCiZndDvCoCAyMDYuIG1haWx0bzo8YSBo
cmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48
YnI+DQomZ3Q7wqAgMjA3LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5j
b20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIDIwOC4gPGEgaHJlZj0iaHR0
cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVm
ZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIDIwOS4gbWFpbHRvOjxhIGhyZWY9Im1haWx0
bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvC
oCAyMTAuIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCAyMTEuIG1h
aWx0bzo8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0
LmNvbTwvYT48YnI+DQomZ3Q7wqAgMjEyLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOnRlamFzd2lu
aXBvbHVyaTNAZ21haWwuY29tIj50ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbTwvYT48YnI+DQom
Z3Q7wqAgMjEzLiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJt
YXJ6aW5zQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIDIxNC4gbWFpbHRvOjxhIGhyZWY9Im1h
aWx0bzp0ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5j
b208L2E+PGJyPg0KJmd0O8KgIDIxNS4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0By
ZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCAyMTYuIG1haWx0
bzo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNv
bTwvYT48YnI+DQomZ3Q7wqAgMjE3LiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsi
Pmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+
DQomZ3Q7wqAgMjE4LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20i
PmRtLWRldmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIDIxOS4gPGEgaHJlZj0iaHR0cHM6
Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJy
ZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIDIyMC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0
ZWphc3dpbmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+
PGJyPg0KJmd0O8KgIDIyMS4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQu
Y29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCAyMjIuIG1haWx0bzo8YSBo
cmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48
YnI+DQomZ3Q7wqAgMjIzLiA8YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBz
Oi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQomZ3Q7
wqAgMjI0LiBtYWlsdG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRl
dmVsQHJlZGhhdC5jb208L2E+PGJyPg0KJmd0O8KgIDIyNS4gPGEgaHJlZj0iaHR0cHM6Ly93d3cu
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRh
cmdldD0iX2JsYW5rIj5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWw8L2E+PGJyPg0KJmd0O8KgIDIyNi4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzp0ZWphc3dp
bmlwb2x1cmkzQGdtYWlsLmNvbSI+dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb208L2E+PGJyPg0K
Jmd0O8KgIDIyNy4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5i
bWFyemluc0ByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCAyMjguIG1haWx0bzo8YSBocmVmPSJt
YWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwu
Y29tPC9hPjxicj4NCiZndDvCoCAyMjkuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNA
cmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgMjMwLiBtYWls
dG86PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5j
b208L2E+PGJyPg0KJmd0O8KgIDIzMS4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5r
Ij5odHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJy
Pg0KJmd0O8KgIDIzMi4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29t
Ij5kbS1kZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCAyMzMuIDxhIGhyZWY9Imh0dHBz
Oi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVy
cmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsPC9hPjxicj4NCiZndDvCoCAyMzQuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86
dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9h
Pjxicj4NCiZndDvCoCAyMzUuIG1haWx0bzo8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0
LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT48YnI+DQomZ3Q7wqAgMjM2LiBtYWlsdG86PGEg
aHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+
PGJyPg0KJmd0O8KgIDIzNy4gPGEgaHJlZj0iaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVsIiByZWw9Im5vcmVmZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRw
czovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw8L2E+PGJyPg0KJmd0
O8KgIDIzOC4gbWFpbHRvOjxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1k
ZXZlbEByZWRoYXQuY29tPC9hPjxicj4NCiZndDvCoCAyMzkuIDxhIGhyZWY9Imh0dHBzOi8vd3d3
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbCIgcmVsPSJub3JlZmVycmVyIiB0
YXJnZXQ9Il9ibGFuayI+aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsPC9hPjxicj4NCjxicj4NCiZndDsgY29tbWl0IDc5YWI5MDkwZDNmYmNkYjU4NDQ0Nzg0
MTkxMzVkMTM5MGNmNTQ4YzI8YnI+DQomZ3Q7IEF1dGhvcjogVGVqYXN3aW5pICZsdDs8YSBocmVm
PSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21h
aWwuY29tPC9hPiZndDs8YnI+DQomZ3Q7IERhdGU6wqAgwqBXZWQgSnVsIDggMTU6MDg6NTYgMjAx
NSArMDUzMDxicj4NCiZndDs8YnI+DQomZ3Q7wqAgwqAgwqBtdWx0aXBhdGhkOiBGaXhpbmcgYWRk
IG1hcCBmdW5jdGlvbmFsaXR5PGJyPg0KJmd0Ozxicj4NCiZndDvCoCDCoCDCoEFkZCBtYXAgZmVh
dHVyZSBvZiBtdWx0aXBhdGhkIHRvb2xzIGZhaWxzIGFzIHRoZSBkZXZpY2U8YnI+DQomZ3Q7wqAg
wqAgwqBpcyBhbHNvIGJlZW4gY29tcGxldGVseSByZW1vdmVkIGFsb25nIHdpdGggcmVtb3Zpbmcg
dGhlIG1hcDxicj4NCiZndDvCoCDCoCDCoGluIHRoZSByZW1vdmUgbWFwIGNvZGUuIFNvIHdoZW4g
YWRkIG1hcCBpcyBjYWxsZWQgd2UgYXJlPGJyPg0KJmd0O8KgIMKgIMKgY3JlYXRpbmcgdGhlIGRl
dmljZSBhZ2FpbiBpbiBrZXJuZWwgYW5kIGRvaW5nIGFkZCBtYXA8YnI+DQomZ3Q7wqAgwqAgwqB1
c2luZyB0aGUgY29sb2FzY2VfcGF0aHMgY29kZS48YnI+DQomZ3Q7PGJyPg0KJmd0O8KgIMKgIMKg
U2lnbmVkLW9mZi1ieTogVGVqYXN3aW5pIFBvbHVyaSAmbHQ7PGEgaHJlZj0ibWFpbHRvOnRwb2x1
cmlAbXZpc3RhLmNvbSI+dHBvbHVyaUBtdmlzdGEuY29tPC9hPiZndDs8YnI+DQomZ3Q7PGJyPg0K
Jmd0OyBkaWZmIC0tZ2l0IGEvbXVsdGlwYXRoZC9jbGlfaGFuZGxlcnMuYyBiL211bHRpcGF0aGQv
Y2xpX2hhbmRsZXJzLmM8YnI+DQomZ3Q7IGluZGV4IGRjOTZjNDUuLmM1NGM3NjcgMTAwNjQ0PGJy
Pg0KJmd0OyAtLS0gYS9tdWx0aXBhdGhkL2NsaV9oYW5kbGVycy5jPGJyPg0KJmd0OyArKysgYi9t
dWx0aXBhdGhkL2NsaV9oYW5kbGVycy5jPGJyPg0KJmd0OyBAQCAtNTM3LDcgKzUzNyw3IEBAIGNs
aV9hZGRfbWFwICh2b2lkICogdiwgY2hhciAqKiByZXBseSwgaW50ICogbGVuLCB2b2lkICogZGF0
YSk8YnI+DQomZ3Q7wqAgwqAgwqAgwqBjaGFyIGRldl9wYXRoW1BBVEhfU0laRV07PGJyPg0KJmd0
O8KgIMKgIMKgIMKgY2hhciAqYWxpYXM7PGJyPg0KJmd0O8KgIMKgIMKgIMKgaW50IHJjOzxicj4N
CiZndDsgLTxicj4NCiZndDsgK8KgIMKgIMKgY2hhciAqcmVmd3dpZDs8YnI+DQomZ3Q7wqAgwqAg
wqAgwqBwYXJhbSA9IGNvbnZlcnRfZGV2KHBhcmFtLCAwKTs8YnI+DQomZ3Q7wqAgwqAgwqAgwqBj
b25kbG9nKDIsICZxdW90OyVzOiBhZGQgbWFwIChvcGVyYXRvcikmcXVvdDssIHBhcmFtKTs8YnI+
DQomZ3Q7PGJyPg0KJmd0OyBAQCAtNTQ3LDYgKzU0NywxNCBAQCBjbGlfYWRkX21hcCAodm9pZCAq
IHYsIGNoYXIgKiogcmVwbHksIGludCAqIGxlbiwgdm9pZCAqIGRhdGEpPGJyPg0KJmd0O8KgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgY29uZGxvZygyLCAmcXVvdDslczogbWFwIGJsYWNrbGlzdGVkJnF1
b3Q7LCBwYXJhbSk7PGJyPg0KJmd0O8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJuIDA7PGJy
Pg0KJmd0O8KgIMKgIMKgIMKgfTxicj4NCiZndDsgK8KgIMKgIMKgcmMgPSBnZXRfcmVmd3dpZChw
YXJhbSwgREVWX0RFVk1BUCwgdmVjcy0mZ3Q7cGF0aHZlYywgJmFtcDtyZWZ3d2lkKTs8YnI+DQom
Z3Q7ICs8YnI+DQomZ3Q7ICvCoCDCoCDCoCDCoCBpZiAocmVmd3dpZCkgezxicj4NCiZndDsgK8Kg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNvbmRsb2coMiwgJnF1b3Q7JXM6IGFkZCBtYXAgKG9wZXJh
dG9yKSZxdW90OywgcmVmd3dpZCk7PGJyPg0KJmd0OyArwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
aWYoY29hbGVzY2VfcGF0aHModmVjcywgTlVMTCwgcmVmd3dpZCwgMCkpPGJyPg0KJmd0OyArwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9nKDIsICZxdW90OyVzOiBjb2FsZXNj
ZS1wYXRocyBmYWlsZWQmcXVvdDssIHBhcmFtKTs8YnI+DQomZ3Q7ICvCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCBkbV9saWJfcmVsZWFzZSgpOzxicj4NCiZndDsgK8KgIMKgIMKgIMKgIH08YnI+DQom
Z3Q7wqAgwqAgwqAgwqBtaW5vciA9IGRtX2dldF9taW5vcihwYXJhbSk7PGJyPg0KJmd0O8KgIMKg
IMKgIMKgaWYgKG1pbm9yICZsdDsgMCkgezxicj4NCiZndDvCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oGNvbmRsb2coMiwgJnF1b3Q7JXM6IG5vdCBhIGRldmljZSBtYXBwZXIgdGFibGUmcXVvdDssIHBh
cmFtKTs8YnI+DQomZ3Q7IEBAIC01NjYsNiArNTc0LDcgQEAgY2xpX2FkZF9tYXAgKHZvaWQgKiB2
LCBjaGFyICoqIHJlcGx5LCBpbnQgKiBsZW4sIHZvaWQgKiBkYXRhKTxicj4NCiZndDvCoCDCoCDC
oCDCoH08YnI+DQomZ3Q7wqAgwqAgwqAgwqByYyA9IGV2X2FkZF9tYXAoZGV2X3BhdGgsIGFsaWFz
LCB2ZWNzKTs8YnI+DQomZ3Q7wqAgwqAgwqAgwqBGUkVFKGFsaWFzKTs8YnI+DQomZ3Q7ICvCoCDC
oCDCoEZSRUUocmVmd3dpZCk7PGJyPg0KJmd0O8KgIMKgIMKgIMKgcmV0dXJuIHJjOzxicj4NCiZn
dDvCoCB9PGJyPg0KJmd0Ozxicj4NCjxicj4NCiZndDsgY29tbWl0IDkxMGI0YTgyZWM0ODNiNDhl
YWY4YjI0ZWIzZDc4MjkyNzNjNjkwZWQ8YnI+DQomZ3Q7IEF1dGhvcjogVGVqYXN3aW5pICZsdDs8
YSBocmVmPSJtYWlsdG86dGVqYXN3aW5pcG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVy
aTNAZ21haWwuY29tPC9hPiZndDs8YnI+DQomZ3Q7IERhdGU6wqAgwqBXZWQgSnVsIDggMTc6MTg6
MDMgMjAxNSArMDUzMDxicj4NCiZndDs8YnI+DQomZ3Q7wqAgwqAgwqBtdWx0aXBhdGhkOiBEaXNh
YmxlZCBjb2RlIHRoYXQgaXMgbm90IGJlaW5nIHVzZWQuPGJyPg0KJmd0Ozxicj4NCiZndDvCoCDC
oCDCoFRoaXMgcGFydCBvZiB0aGUgY29kZSBpcyBtb3ZlZCB0byBjbGlfYWRkX21hcCBhbmQ8YnI+
DQomZ3Q7wqAgwqAgwqBkaXNhYmxlZCBoZXJlIGFzIGl0IGlzIG5vdCB1c2VkIGJ5IGFueSBmdW5j
dGlvbiBjYWxsPGJyPg0KJmd0O8KgIMKgIMKgaGVyZS48YnI+DQomZ3Q7PGJyPg0KJmd0O8KgIMKg
IMKgU2lnbmVkLW9mZi1ieTogVGVqYXN3aW5pICZsdDs8YSBocmVmPSJtYWlsdG86dGVqYXN3aW5p
cG9sdXJpM0BnbWFpbC5jb20iPnRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPC9hPiZndDs8YnI+
DQomZ3Q7PGJyPg0KJmd0OyBkaWZmIC0tZ2l0IGEvbXVsdGlwYXRoZC9tYWluLmMgYi9tdWx0aXBh
dGhkL21haW4uYzxicj4NCiZndDsgaW5kZXggZjg3NjI1OC4uMDYwMjM3YyAxMDA2NDQ8YnI+DQom
Z3Q7IC0tLSBhL211bHRpcGF0aGQvbWFpbi5jPGJyPg0KJmd0OyArKysgYi9tdWx0aXBhdGhkL21h
aW4uYzxicj4NCiZndDsgQEAgLTMyOSw2ICszMjksOCBAQCBldl9hZGRfbWFwIChjaGFyICogZGV2
LCBjaGFyICogYWxpYXMsIHN0cnVjdCB2ZWN0b3JzICogdmVjcyk8YnI+DQomZ3Q7wqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByZXR1cm4gMTs8YnI+DQomZ3Q7wqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqB9PGJyPg0KJmd0O8KgIMKgIMKgIMKgfTxicj4NCiZndDsgKyNpZiAwIC8qRGlz
YWJsZWQgYXMgdGhlIGNvZGUgaXMgbm90IGJlaW5nIHVzZWQgYnkgYW55b25lLjxicj4NCiZndDsg
K8KgIMKgIMKgVE9ETzpjb25maXJtIHRoYXQgbm8gZmVhdHVyZSByZXF1aXJlcyB0aGlzIGNvZGUq
Lzxicj4NCjxzcGFuIGNsYXNzPSIiPiZndDvCoCDCoCDCoCDCoHIgPSBnZXRfcmVmd3dpZChkZXYs
IERFVl9ERVZNQVAsIHZlY3MtJmd0O3BhdGh2ZWMsICZhbXA7cmVmd3dpZCk7PGJyPg0KJmd0Ozxi
cj4NCiZndDvCoCDCoCDCoCDCoGlmIChyZWZ3d2lkKSB7PGJyPg0KPC9zcGFuPiZndDsgQEAgLTM0
NCw2ICszNDYsNyBAQCBldl9hZGRfbWFwIChjaGFyICogZGV2LCBjaGFyICogYWxpYXMsIHN0cnVj
dCB2ZWN0b3JzICogdmVjcyk8YnI+DQomZ3Q7wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9n
KDAsICZxdW90OyVzOiB1ZXZfYWRkX21hcCAlcyBmYWlsZWQmcXVvdDssIGFsaWFzLCBkZXYpOzxi
cj4NCiZndDs8YnI+DQomZ3Q7wqAgwqAgwqAgwqBGUkVFKHJlZnd3aWQpOzxicj4NCiZndDsgKyNl
bmRpZjxicj4NCiZndDvCoCDCoCDCoCDCoHJldHVybiByOzxicj4NCiZndDvCoCB9PGJyPg0KJmd0
Ozxicj4NCjxicj4NCjwvYmxvY2txdW90ZT48L2Rpdj48YnI+PC9kaXY+DQo=
--001a113ec94e62f6f1051afba718--


--===============4457993821994707407==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4457993821994707407==--
