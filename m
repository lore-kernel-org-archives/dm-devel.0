From: Lucas Brasilino <lucas.brasilino@gmail.com>
Subject: Re: rdac priority checker changing priorities
Date: Tue, 5 May 2009 14:59:39 -0300
Message-ID: <9ad205140905051059n4f472961lc16d0816f5f9330e@mail.gmail.com>
References: <9ad205140904291534j4cc1a71aq3b4a0e308f1687bd@mail.gmail.com>
	<49F9443E.7040109@suse.de> <1241114743.11905.13.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1241114743.11905.13.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Well, maybe it's a newbie opinion, but looks like that's easier if
each path has a
'fixed value' priority, isn't it ? I've made a little code here that retu=
rns
a choosen fixed value to paths and everything goes fine.....

regards
Lucas Brasilino

2009/4/30 Chandra Seetharaman <sekharan@us.ibm.com>:
> Hannes,
>
> I think we need to revisit the priority value we provide for preferred
> path(4) relative to active path (2) and non-preferred(1).
>
> Consider the following scenario:
>
> Access to a lun thru 2 preferred and 2 non-preferred path. Lets call
> path group with preferred paths as pg1 and with non-preferred paths as
> pg2.
>
> Initially pg1 has priority of 8 and pg2 has priority of 2. pg1 is chose=
n
> and I/O goes thru pg1, all good.
>
> Both the paths in pg1 fails, pg2 has been made the active path group an=
d
> I/O is sent thru that path and since it became "active", its priority
> raises to 6 ( 2 path times (active + non-preferred)).
>
> When one of the paths in pg1 comes back, one would expect the failback
> to happen. It doesn't happen as pg1's priority (4) is smaller than that
> of pg2 (6). Which is not correct.
>
> We can do the same exercise with more than 4 paths also, like 6, 8 etc.=
,
> and the results are worse.
>
> So, IMO we need to give the disproportionately large number for
> preferred path w.r.t active and non-preferred. What do you think ?
>
> chandra
>
>
>
> On Thu, 2009-04-30 at 08:25 +0200, Hannes Reinecke wrote:
>> Hi Lucas,
>>
>> Lucas Brasilino wrote:
>> > Hi
>> >
>> > I don't know if I'm misundertanding something. I've got an DS4700 an=
d I'm
>> > switching from RDAC[1] to multipath, since it's natively supported i=
n
>> > the distribution I use
>> > here (SLES 10 SP2).
>> >
>> > Since RDAC[1] works perfect, I'm trying to use 'rdac' priority in mu=
ltipath.
>> >
>> > My /etc/multiconf.conf is quite tiny, since I'm building it step-by-=
step :-) :
>> >
>> > blacklist {
>> > =A0 =A0 devnode "^sda[0-9]*"
>> > }
>> >
>> > defaults {
>> > =A0 =A0 user_friendly_names =A0 =A0 yes
>> > =A0 =A0 prio =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdac
>> > =A0 =A0 path_checker =A0 =A0 =A0 =A0 =A0 =A0tur
>> > }
>> >
>> > multipaths {
>> > =A0 =A0 multipath {
>> > =A0 =A0 =A0 =A0 =A0 =A0 wwid =A0 =A03600a0b8000327b900000107549f8522=
4
>> > =A0 =A0 =A0 =A0 =A0 =A0 alias =A0 mpath0
>> > =A0 =A0 }
>> > }
>> >
>> > I think that using 'prio rdac' makes multipath to use 'mpath_prio_rd=
ac' tool.
>> >
>> > =A0# multipath -v2 -ll
>> > mpath0 (3600a0b8000327b900000107549f85224) dm-0 IBM,1814 =A0 =A0 =A0=
FAStT
>> > [size=3D140G][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
>> > \_ round-robin 0 [prio=3D6][active]
>> > =A0\_ 9:0:0:0 =A0sdb 8:16 =A0[active][ready]
>> > \_ round-robin 0 [prio=3D1][enabled]
>> > =A0\_ 10:0:0:0 sdc 8:32 =A0[active][ghost]
>> >
>> > So the first path has priority 6, as I can confirm:
>> >
>> > # mpath_prio_rdac /dev/sdb
>> > 6
>> > # mpath_prio_rdac /dev/sdc
>> > 1
>> >
>> > After the first path (prio=3D6) failure I get:
>> >
>> > # multipath -v2 -ll
>> > sdb: rdac prio: inquiry command indicates error
>> > mpath0 (3600a0b8000327b900000107549f85224) dm-0 IBM,1814 =A0 =A0 =A0=
FAStT
>> > [size=3D140G][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
>> > \_ round-robin 0 [prio=3D0][enabled]
>> > =A0\_ 9:0:0:0 =A0sdb 8:16 =A0[failed][faulty]
>> > \_ round-robin 0 [prio=3D1][enabled]
>> > =A0\_ 10:0:0:0 sdc 8:32 =A0[active][ghost]
>> >
>> > Ok.. working great, activating the second path. But after the faulty
>> > path is restored:
>> >
>> > # multipath -v2 -ll
>> > mpath0 (3600a0b8000327b900000107549f85224) dm-0 IBM,1814 =A0 =A0 =A0=
FAStT
>> > [size=3D140G][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
>> > \_ round-robin 0 [prio=3D2][enabled]
>> > =A0\_ 9:0:0:0 =A0sdb 8:16 =A0[active][ghost]
>> > \_ round-robin 0 [prio=3D5][active]
>> > =A0\_ 10:0:0:0 sdc 8:32 =A0[active][ready]
>> >
>> > Second path is now priority!!! And of course does not fails back! By
>> > the way, my LUN is configured in
>> > DS4700 in sort a way that the first path *is* the path to preferred =
controller.
>> >
>> > I think path priorities should not change. If so first path goes bac=
k
>> > to 'active' status.
>> > Am I misunderstanding something ? Or messing things up?
>> >
>> You are using an old version of multipathing for SLES10 SP2.
>> This had a bug triggering priority inversion on RDAC.
>> Please update to the latest version.
>>
>> Cheers,
>>
>> Hannes
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
