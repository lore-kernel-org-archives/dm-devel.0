From: Hannes Reinecke <hare@suse.de>
Subject: Re: RFC: multipath IO multiplex
Date: Mon, 08 Nov 2010 13:42:10 +0100
Message-ID: <4CD7F022.2030701@suse.de>
References: <20101105183946.GG25992@suse.de>
	<20101106053203.7e4ef435@notabene>	<20101106115102.GF10171@agk-dp.fab.redhat.com>	<20101106165743.GE30809@suse.de>	<1289125849.2821.5.camel@Nokia-N900-42-11>	<20101108115028.GH16210@suse.de>	<20101108121208.GA15253@agk-dp.fab.redhat.com>
	<20101108121941.GK16210@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101108121941.GK16210@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Lars Marowsky-Bree <lmb@novell.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 11/08/2010 01:19 PM, Lars Marowsky-Bree wrote:
> On 2010-11-08T12:12:08, Alasdair G Kergon <agk@redhat.com> wrote:
> =

>>> I think handling this at the dm-multipath level is cleaner; similarly
>>> how we handle network bonding (which incidentally has a broadcast mode
>>> too), instead of requiring every application to go out and open N
>>> independent channels.
>> Or could it hook into the userspace multipath monitoring code which
>> already knows the state of the paths?
> =

> ... but not the translation (e.g., partitioning and logical volumes).
> But yes, getting notified by multipathd might also work. Though the code
> complexity in user-space arguably seems higher than handling it
> in-kernel.
> =

>> Well, I'm struggling to see anything clean, simple or generic about
>> a kernel-side solution here so far.  Seems like a lot of extra kernel
>> code for just one highly-specialised case: so far I'm unconvinced.
> =

> I wonder how other latency-sensitive IO handles multipath? Maybe they
> just haven't noticed yet they'd like a facility like this? ;-)
> =

> Also, Joel wanted to implement the heartbeating/poison pill mechanism
> itself in kernel space; clearly, that'd require such an in-kernel
> facility too, and could be shared between his code and mine.
> =

A really daft idea:
Can't you implement a separate path checker for this?
Basically a wrapper around the existing ones (or even a hook into
the existing infrastructure) which would write the poison pill if
requested? The path checker will be called for every path, so you
only have to worry about the checker interval. But I daresay you can
shorten it on request.
Then you can implement a CLI callout and set the magic poison pill
flag, which would trigger an immediate path re-check and the path
checker to write the poison pill itself.

Hmm?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
