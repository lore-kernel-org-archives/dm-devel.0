From: Levy_Jerome@emc.com
Subject: Re: LSF: Multipathing and path checking question
Date: Mon, 20 Apr 2009 12:25:23 -0400
Message-ID: <6416EE16C1AF1E4C86882867E4DD0FF60522BB1E@CORPUSMX40B.corp.emc.com>
References: <20090420160041.527A76198AB@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20090420160041.527A76198AB@hormel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Just a note or two:

> My proposal is to handle this in several stages:
>=20
> - path fails
> -> Send out netlink event
> -> start dev_loss_tmo and fast_fail_io timer
> -> fast_fail_io timer triggers: Abort all oustanding I/O with
>   DID_TRANSPORT_DISRUPTED, return DID_TRANSPORT_FAILFAST for
>   any future I/O, and send out netlink event.
> -> dev_loss_tmo timer triggers: Remove sdev and cleanup rport.
>   netlink event is sent implicitely by removing the sdev.
>
> Multipath would then interact with this sequence by:
>=20
> - Upon receiving 'path failed' event: mark path as 'ghost' or
'blocked',
>   ie no I/O is currently possible and will be queued (no path switch
yet).
> - Upon receiving 'fast_fail_io' event: switch paths and resubmit
queued I/Os
> - Upon receiving 'path removed' event: remove path from internal
structures,
  update multipath maps etc.

This makes perfect sense to me. Are we going to allow the end-user to
modify
those timers (not sure that's a good idea...)?

> The time between 'path failed' and 'fast_fail_io triggers' would then
be
> able to capture any jitter / intermittent failures. Between=20
> 'fast_fail_io triggers' and 'path removed' the path would be held in
some
> sort of 'limbo' in case it comes back again, eg for maintenance/SP
update
> etc. And we can even increase this one to rather long timespans (eg
hours)
> to give the admin enough time for a manual intervention.

> I still like this proposal as it makes multipath interaction far
cleaner.
> And we can do away with path checkers completely here.

All true. Although I think the "long" timespans might be best measured
in=20
minutes (say, default to 5 minutes) and should be configurable. It
probably isn't=20
a good idea to leave that path dead for a very long time as a rule, even
if=20
it's possible to do so. Maybe even some sort of userland override would
be=20
worthwhile for scheduled maintenance?


Regards, Jerry
