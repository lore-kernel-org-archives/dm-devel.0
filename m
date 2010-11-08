From: Lars Marowsky-Bree <lmb@novell.com>
Subject: Re: RFC: multipath IO multiplex
Date: Mon, 8 Nov 2010 12:50:28 +0100
Message-ID: <20101108115028.GH16210@suse.de>
References: <20101105183946.GG25992@suse.de> <20101106053203.7e4ef435@notabene>
	<20101106115102.GF10171@agk-dp.fab.redhat.com>
	<20101106165743.GE30809@suse.de>
	<1289125849.2821.5.camel@Nokia-N900-42-11>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1289125849.2821.5.camel@Nokia-N900-42-11>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>, device-mapper development <dm-devel@redhat.com>, Neil Brown <neilb@suse.de>
List-Id: dm-devel.ids

On 2010-11-07T11:30:49, Christophe Varoqui <christophe.varoqui@gmail.com> w=
rote:

> Wouldn't it practical to bypass mpio completely on submit your io to the =
paths instead ?

Yes - and no.

Yes: I could do that, and send my IO down all paths via async IO. It was
actually the first direction I looked into, however I abandoned it after
a while (see below). And yes, it's the first thing everyone recommends
;-)

No: It would mean I'd have to query multipathd for every IO, to learn
which devices currently are active and linked to the right storage. (The
idea of hooking into udev myself or scanning partitions seems a bit of a
non-starter.) Alternatively, I could probably try and monitor the
mapping for changes, but then would have to parse that syntax. Not to
mention I'd have to handle my own partitioning, LVM mapping, etc too.

So, it seems somewhat inefficient and inelegant.

I think handling this at the dm-multipath level is cleaner; similarly
how we handle network bonding (which incidentally has a broadcast mode
too), instead of requiring every application to go out and open N
independent channels.


Regards,
    Lars

-- =

Architect Storage/HA, OPS Engineering, Novell, Inc.
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde
