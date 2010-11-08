From: Lars Marowsky-Bree <lmb@novell.com>
Subject: Re: RFC: multipath IO multiplex
Date: Mon, 8 Nov 2010 13:19:41 +0100
Message-ID: <20101108121941.GK16210@suse.de>
References: <20101105183946.GG25992@suse.de> <20101106053203.7e4ef435@notabene>
	<20101106115102.GF10171@agk-dp.fab.redhat.com>
	<20101106165743.GE30809@suse.de>
	<1289125849.2821.5.camel@Nokia-N900-42-11>
	<20101108115028.GH16210@suse.de>
	<20101108121208.GA15253@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20101108121208.GA15253@agk-dp.fab.redhat.com>
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

On 2010-11-08T12:12:08, Alasdair G Kergon <agk@redhat.com> wrote:

> > I think handling this at the dm-multipath level is cleaner; similarly
> > how we handle network bonding (which incidentally has a broadcast mode
> > too), instead of requiring every application to go out and open N
> > independent channels.
> Or could it hook into the userspace multipath monitoring code which
> already knows the state of the paths?

... but not the translation (e.g., partitioning and logical volumes).
But yes, getting notified by multipathd might also work. Though the code
complexity in user-space arguably seems higher than handling it
in-kernel.

> Well, I'm struggling to see anything clean, simple or generic about
> a kernel-side solution here so far.  Seems like a lot of extra kernel
> code for just one highly-specialised case: so far I'm unconvinced.

I wonder how other latency-sensitive IO handles multipath? Maybe they
just haven't noticed yet they'd like a facility like this? ;-)

Also, Joel wanted to implement the heartbeating/poison pill mechanism
itself in kernel space; clearly, that'd require such an in-kernel
facility too, and could be shared between his code and mine.


Regards,
    Lars

-- =

Architect Storage/HA, OPS Engineering, Novell, Inc.
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde
