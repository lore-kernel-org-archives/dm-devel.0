From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: Problem with Multipath on Hitachi DF600F
Date: Mon, 23 Jul 2007 08:53:51 +0200
Message-ID: <OFF73D7EC4.A18418AA-ONC1257321.002737EB-C1257321.00276E77@de.ibm.com>
References: <Pine.LNX.4.61.0707201341270.2191@jimi.tabbweb.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.61.0707201341270.2191@jimi.tabbweb.com>
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

Probably there was a tiny window when no paths where available. Check=20
'multipath -l' whether it shows
"queue_if_no_path" somewhere. If not, look at the "no_path_retry" keyword=
=20
in multipath.conf.

Mit freundlichem Gru=DF / Regards,
Stefan Bader

SW Linux on zSeries Development
Stefan.Bader@de.ibm.com

IBM Deutschland Entwicklung GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Gesch=E4ftsf=FChrung: Herbert Kircher
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
-------------------------------------------------------------------------=
---------
  When all other means of communication fail, try words.

dm-devel-bounces@redhat.com wrote on 20.07.2007 20:03:36:

> Hello,
>=20
> We have a DF600F connected via 2 paths to a rhel5 server running=20
> device-mapper-multipath 0.4.7 from Red Hat. We are using pp_hds_modular=
=20
> v1.14 instead of mpath_prio_hds_modular that came with the package, as=20
it=20
> is only v1.12.
>=20
> When we disconnect a cable to an hba, the devices are all marked as=20
faulty=20
> and the other path is used and it recovers when the cable is=20
reconnected.=20
> However, on Tuesday the technician from Hitachi came to perform a=20
> microcode update. He first took controller 0 on the DF600F offline.=20
> multipath -ll reported the devices on that path as faulty and as active=
=20
> when the controller was back online. He then repeated the process with=20
> controller 1 and multipath also reported the devices on that path as=20
> faulty and then active when it was back online. But the postgresql=20
vacuum=20
> I was running during this time crashed with i/o errors and the=20
filesystem=20
> on the lvm2 volume was mounted in read-only mode.
>=20
> Below are the logs. The devices sdb, sdc, sdd and sde are on the=20
> controller 0 path and the devices sdf, sdg, sdh and sdi are on the=20
> controller 1 path. Any ideas why the multipathing
> didn't work?
>=20
> Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410003: load table=20
> [0 348200960 multipath 0 0 2 1 round-robin 0 1 1 8:48 1000 round-
> robin 0 1 1 8:112 1000]=20
> Jul 17 09:25:53 rhel5 kernel: device-mapper: multipath: Failing path=20
8:16.
> Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410004: load table=20
> [0 348205056 multipath 0 0 2 1 round-robin 0 1 1 8:128 1000 round-
> robin 0 1 1 8:64 1000]=20
> Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410001: event=20
> checker started=20
> Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410002: event=20
> checker started=20
> Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410003: event=20
> checker started=20
> Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410004: event=20
> checker started=20
> Jul 17 09:25:53 rhel5 multipathd: path checkers start up=20
> Jul 17 09:25:53 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:25:53 rhel5 multipathd: checker failed path 8:16 in map=20
> 1HITACHI_D60052410001=20
> Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410001: remaining=20
> active paths: 1=20
> Jul 17 09:25:53 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:25:53 rhel5 kernel: device-mapper: multipath: Failing path=20
8:32.
> Jul 17 09:25:53 rhel5 multipathd: checker failed path 8:32 in map=20
> 1HITACHI_D60052410002=20
> Jul 17 09:25:53 rhel5 kernel: device-mapper: multipath: Failing path=20
8:48.
> Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410002: remaining=20
> active paths: 1=20
> Jul 17 09:25:53 rhel5 kernel: device-mapper: multipath: Failing path=20
8:64.
> Jul 17 09:25:53 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:25:53 rhel5 multipathd: checker failed path 8:48 in map=20
> 1HITACHI_D60052410003=20
> Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410003: remaining=20
> active paths: 1=20
> Jul 17 09:25:53 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:25:53 rhel5 multipathd: checker failed path 8:64 in map=20
> 1HITACHI_D60052410004=20
> Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410004: remaining=20
> active paths: 1=20
> Jul 17 09:25:58 rhel5 multipathd: sdb: readsector0 checker reports path=
=20
is up=20
> Jul 17 09:25:58 rhel5 multipathd: 8:16: reinstated=20
> Jul 17 09:25:58 rhel5 multipathd: 1HITACHI_D60052410001: remaining=20
> active paths: 2=20
> Jul 17 09:25:58 rhel5 multipathd: sdc: readsector0 checker reports path=
=20
is up=20
> Jul 17 09:25:58 rhel5 multipathd: 8:32: reinstated=20
> Jul 17 09:25:58 rhel5 multipathd: 1HITACHI_D60052410002: remaining=20
> active paths: 2=20
> Jul 17 09:25:58 rhel5 multipathd: sdd: readsector0 checker reports path=
=20
is up=20
> Jul 17 09:25:58 rhel5 multipathd: 8:48: reinstated=20
> Jul 17 09:25:58 rhel5 multipathd: 1HITACHI_D60052410003: remaining=20
> active paths: 2=20
> Jul 17 09:25:58 rhel5 multipathd: sde: readsector0 checker reports path=
=20
is up=20
> Jul 17 09:25:58 rhel5 multipathd: 8:64: reinstated=20
> Jul 17 09:25:58 rhel5 multipathd: 1HITACHI_D60052410004: remaining=20
> active paths: 2=20
> Jul 17 09:26:34 rhel5 kernel: lpfc 0000:04:00.0: 0:1305 Link Down=20
> Event x2 received Data: x2 x20 x0
> Jul 17 09:26:35 rhel5 kernel: lpfc 0000:04:00.0: 0:1303 Link Up=20
> Event x3 received Data: x3 x1 x4 x1
> Jul 17 09:27:04 rhel5 kernel:  rport-1:0-0: blocked FC remote port=20
> time out: saving binding
> Jul 17 09:27:04 rhel5 kernel: lpfc 0000:04:00.0: 0:0203 Devloss=20
> timeout on WWPN 50:6:e:80:0:43:b8:91 NPort xe8 Data: x8 x7 x1
> Jul 17 09:27:04 rhel5 kernel: device-mapper: multipath: Failing path=20
8:16.
> Jul 17 09:27:04 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:04 rhel5 multipathd: checker failed path 8:16 in map=20
> 1HITACHI_D60052410001=20
> Jul 17 09:27:04 rhel5 multipathd: 1HITACHI_D60052410001: remaining=20
> active paths: 1=20
> Jul 17 09:27:04 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:04 rhel5 multipathd: checker failed path 8:32 in map=20
> 1HITACHI_D60052410002=20
> Jul 17 09:27:04 rhel5 kernel: device-mapper: multipath: Failing path=20
8:32.
> Jul 17 09:27:04 rhel5 multipathd: 1HITACHI_D60052410002: remaining=20
> active paths: 1=20
> Jul 17 09:27:04 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:04 rhel5 multipathd: checker failed path 8:48 in map=20
> 1HITACHI_D60052410003=20
> Jul 17 09:27:04 rhel5 kernel: device-mapper: multipath: Failing path=20
8:48.
> Jul 17 09:27:04 rhel5 multipathd: 1HITACHI_D60052410003: remaining=20
> active paths: 1=20
> Jul 17 09:27:04 rhel5 kernel: device-mapper: multipath: Failing path=20
8:64.
> Jul 17 09:27:09 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:09 rhel5 multipathd: checker failed path 8:64 in map=20
> 1HITACHI_D60052410004=20
> Jul 17 09:27:09 rhel5 multipathd: 1HITACHI_D60052410004: remaining=20
> active paths: 1=20
> Jul 17 09:27:09 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:09 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:09 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:09 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:14 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:14 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:14 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:14 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:18 rhel5 kernel: lpfc 0000:04:00.0: 0:1305 Link Down=20
> Event x4 received Data: x4 x20 x0
> Jul 17 09:27:19 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:19 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:19 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:19 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:24 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:24 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:24 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:24 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:29 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:29 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:29 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:29 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:34 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:34 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:34 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:34 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:39 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:39 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:39 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:39 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:43 rhel5 kernel: lpfc 0000:04:00.0: 0:1303 Link Up=20
> Event x5 received Data: x5 x1 x4 x1
> Jul 17 09:27:44 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:49 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:49 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:49 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:49 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:49 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:49 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:49 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:54 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:59 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:59 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:59 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:59 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:59 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:59 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:27:59 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:04 rhel5 kernel: lpfc 0000:04:00.0: 0:1305 Link Down=20
> Event x6 received Data: x6 x20 x0
> Jul 17 09:28:04 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:04 rhel5 kernel: lpfc 0000:04:00.0: 0:1303 Link Up=20
> Event x7 received Data: x7 x1 x4 x1
> Jul 17 09:28:07 rhel5 kernel: lpfc 0000:04:00.0: 0:1305 Link Down=20
> Event x8 received Data: x8 x20 x0
> Jul 17 09:28:08 rhel5 kernel: lpfc 0000:04:00.0: 0:1303 Link Up=20
> Event x9 received Data: x9 x1 x8 x1
> Jul 17 09:28:08 rhel5 kernel: lpfc 0000:04:00.0: 0:1305 Link Down=20
> Event xa received Data: xa x20 x0
> Jul 17 09:28:09 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:09 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:09 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:09 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:09 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:09 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:09 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:10 rhel5 kernel: lpfc 0000:04:00.0: 0:1303 Link Up=20
> Event xb received Data: xb x1 x4 x1
> Jul 17 09:28:14 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:19 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:19 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:19 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:19 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:19 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:19 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:19 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:24 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:24 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:24 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:24 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:24 rhel5 multipathd: sdh: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:24 rhel5 multipathd: checker failed path 8:112 in map=20
> 1HITACHI_D60052410003=20
> Jul 17 09:28:24 rhel5 multipathd: 1HITACHI_D60052410003: remaining=20
> active paths: 0=20
> Jul 17 09:28:24 rhel5 kernel: device-mapper: multipath: Failing path=20
8:112.
> Jul 17 09:28:24 rhel5 kernel: device-mapper: multipath: Failing path=20
8:128.
> Jul 17 09:28:24 rhel5 multipathd: sdi: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:24 rhel5 multipathd: checker failed path 8:128 in map=20
> 1HITACHI_D60052410004=20
> Jul 17 09:28:24 rhel5 multipathd: 1HITACHI_D60052410004: remaining=20
> active paths: 0=20
> Jul 17 09:28:24 rhel5 kernel: lpfc 0000:04:00.0: 0:1305 Link Down=20
> Event xc received Data: xc x20 x0
> Jul 17 09:28:29 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:29 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:29 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:29 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:29 rhel5 multipathd: sdh: readsector0 checker reports path=
=20
is up=20
> Jul 17 09:28:29 rhel5 multipathd: 8:112: reinstated=20
> Jul 17 09:28:29 rhel5 multipathd: 1HITACHI_D60052410003: remaining=20
> active paths: 1=20
> Jul 17 09:28:29 rhel5 multipathd: sdi: readsector0 checker reports path=
=20
is up=20
> Jul 17 09:28:29 rhel5 multipathd: 8:128: reinstated=20
> Jul 17 09:28:29 rhel5 multipathd: 1HITACHI_D60052410004: remaining=20
> active paths: 1=20
> Jul 17 09:28:34 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:39 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:39 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:39 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:39 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:39 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:39 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:39 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:44 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:44 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:44 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:44 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:49 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:49 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:49 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:49 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:54 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:54 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:54 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:54 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:59 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:59 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:59 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:28:59 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:29:04 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:29:04 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:29:04 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:29:04 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:29:09 rhel5 kernel: lpfc 0000:04:00.0: 0:1303 Link Up=20
> Event xd received Data: xd x1 x8 x2
> Jul 17 09:29:09 rhel5 multipathd: sdb: readsector0 checker reports=20
> path is down=20
> Jul 17 09:29:10 rhel5 multipathd: sdc: readsector0 checker reports=20
> path is down=20
> Jul 17 09:29:10 rhel5 multipathd: sdd: readsector0 checker reports=20
> path is down=20
> Jul 17 09:29:10 rhel5 multipathd: sde: readsector0 checker reports=20
> path is down=20
> Jul 17 09:29:15 rhel5 multipathd: sdb: readsector0 checker reports path=
=20
is up=20
> Jul 17 09:29:15 rhel5 multipathd: 8:16: reinstated=20
> Jul 17 09:29:15 rhel5 multipathd: 1HITACHI_D60052410001: remaining=20
> active paths: 2=20
> Jul 17 09:29:15 rhel5 multipathd: sdc: readsector0 checker reports path=
=20
is up=20
> Jul 17 09:29:15 rhel5 multipathd: 8:32: reinstated=20
> Jul 17 09:29:15 rhel5 multipathd: 1HITACHI_D60052410002: remaining=20
> active paths: 2=20
> Jul 17 09:29:15 rhel5 multipathd: sdd: readsector0 checker reports path=
=20
is up=20
> Jul 17 09:29:15 rhel5 multipathd: 8:48: reinstated=20
> Jul 17 09:29:15 rhel5 multipathd: 1HITACHI_D60052410003: remaining=20
> active paths: 2=20
> Jul 17 09:29:15 rhel5 multipathd: sde: readsector0 checker reports path=
=20
is up=20
> Jul 17 09:29:15 rhel5 multipathd: 8:64: reinstated=20
> Jul 17 09:29:15 rhel5 multipathd: 1HITACHI_D60052410004: remaining=20
> active paths: 2=20
> Jul 17 09:32:39 rhel5 kernel: lpfc 0000:05:00.0: 1:1305 Link Down=20
> Event x2 received Data: x2 x20 x0
> Jul 17 09:32:41 rhel5 kernel: lpfc 0000:05:00.0: 1:1303 Link Up=20
> Event x3 received Data: x3 x1 x4 x1
> Jul 17 09:33:09 rhel5 kernel:  rport-2:0-0: blocked FC remote port=20
> time out: saving binding
> Jul 17 09:33:09 rhel5 kernel: sd 2:0:0:1: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:09 rhel5 kernel: end_request: I/O error, dev sdf, sector=20
65184640
> Jul 17 09:33:09 rhel5 kernel: lpfc 0000:05:00.0: 1:0203 Devloss=20
> timeout on WWPN 50:6:e:80:0:43:b8:93 NPort xe2 Data: x8 x7 x1
> Jul 17 09:33:09 rhel5 kernel: sd 2:0:0:1: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:09 rhel5 kernel: end_request: I/O error, dev sdf, sector=20
65920
> Jul 17 09:33:09 rhel5 kernel: sd 2:0:0:1: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:09 rhel5 multipathd: sdf: readsector0 checker reports=20
> path is down=20
> Jul 17 09:33:09 rhel5 kernel: end_request: I/O error, dev sdf, sector=20
21410968
> Jul 17 09:33:09 rhel5 kernel: sd 2:0:0:1: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:09 rhel5 kernel: end_request: I/O error, dev sdf, sector=20
18297136
> Jul 17 09:33:09 rhel5 multipathd: checker failed path 8:80 in map=20
> 1HITACHI_D60052410001=20
> Jul 17 09:33:09 rhel5 kernel: Buffer I/O error on device dm-0,=20
> logical block 4574198
> Jul 17 09:33:09 rhel5 multipathd: 1HITACHI_D60052410001: remaining=20
> active paths: 1=20
> Jul 17 09:33:09 rhel5 kernel: lost page write due to I/O error on dm-0
> Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:1: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdf, sector=20
18300736
> Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0,=20
> logical block 4575096
> Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
> Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0,=20
> logical block 4575097
> Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
> Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0,=20
> logical block 4575098
> Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
> Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:1: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdf, sector=20
18300928
> Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0,=20
> logical block 4575152
> Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
> Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0,=20
> logical block 4575153
> Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
> Jul 17 09:33:10 rhel5 kernel: device-mapper: multipath: Failing path=20
8:80.
> Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:1: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdf, sector=20
18301184
> Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0,=20
> logical block 4575216
> Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
> Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0,=20
> logical block 4575217
> Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
> Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0,=20
> logical block 4575218
> Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
> Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0,=20
> logical block 4575219
> Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
> Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
66008
> Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
18300672
> Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
18300824
> Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
18300896
> Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:1: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdf, sector=20
66008
> Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
18300936
> Jul 17 09:33:10 rhel5 kernel: Aborting journal on device dm-0.
> Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
18301184
> Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
18301360
> Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
18301520
> Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
18334080
> Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:4: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdi, sector=20
19444000
> Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411072
> Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
65184640
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:4: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdi, sector=20
19449856
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:3: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdh, sector=20
19450272
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:1: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdf, sector=20
65184592
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
65184512
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:4: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdi, sector=20
19450368
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:3: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdh, sector=20
19449760
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:1: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdf, sector=20
65184464
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:11 rhel5 kernel: device-mapper: multipath: Failing path=20
8:96.
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:11 rhel5 kernel: device-mapper: multipath: Failing path=20
8:112.
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:11 rhel5 kernel: device-mapper: multipath: Failing path=20
8:128.
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code =3D=20
0x00010000
> Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector=20
21411096
> Jul 17 09:33:12 rhel5 kernel: ext3_abort called.
> Jul 17 09:33:12 rhel5 kernel: EXT3-fs error (device dm-0):=20
> ext3_journal_start_sb: Detected aborted journal
> Jul 17 09:33:12 rhel5 kernel: Remounting filesystem read-only
>=20
> The scsi and i/o errors repeat until the machine was rebooted when all=20
was=20
> fine again.
>=20
> Here is the contents of /etc/multipath.conf:
>=20
> # This is an example configuration file for device mapper multipath.
> # For a complete list of the default configuration values, see
> # /usr/share/doc/device-mapper-multipath-0.4.5/multipath.conf.defaults
> # For a list of configuration options with descriptions, see
> # /usr/share/doc/device-mapper-multipath-0.4.5/multipath.conf.annotated
>=20
>=20
> # Blacklist all devices by default. Remove this to enable multipathing
> # on the default devices.=20
> blacklist {
>          devnode "sda"
> }
>=20
> ## By default, devices with vendor =3D "IBM" and product =3D "S/390.*" =
are
> ## blacklisted. To enable mulitpathing on these devies, uncomment the
> ## following lines.
> #blacklist_exceptions {
> #   device {
> #      vendor   "IBM"
> #      product   "S/390.*"
> #   }
> #}
>=20
> ## Use user friendly names, instead of using WWIDs as names.
> defaults {
>     #user_friendly_names yes
> }
>=20
> devices {
>     device {
>        vendor                  "HITACHI"
>        product                 "DF.*"
>        path_grouping_policy    group_by_prio
>        prio_callout            "/sbin/pp_hds_modular %d"
>        path_checker            readsector0
>        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
>        failback                immediate
>        }
>     }
>=20
>=20
>=20
> Any help is appreciated.
>=20
> Thanks,
>=20
> Trevor
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
