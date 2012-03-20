From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] dm-table: delayed cleanup for
	dm_table_destroy()
Date: Tue, 20 Mar 2012 16:35:52 +0100
Message-ID: <4F68A3D8.40005@suse.de>
References: <1332172428-35948-1-git-send-email-hare@suse.de>
	<1332172428-35948-2-git-send-email-hare@suse.de>
	<1332172428-35948-3-git-send-email-hare@suse.de>
	<1332172428-35948-4-git-send-email-hare@suse.de>
	<Pine.LNX.4.64.1203191714090.10651@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1203191714090.10651@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Mikulas,

On 03/19/2012 10:45 PM, Mikulas Patocka wrote:
> Hi Hannes
> =

> I wouldn't do this. This behavior actually existed in kernels <=3D 2.6.28.
> And it caused trouble.
> =

> The problems are these:
> =

> Some code may hold a spinlock and call dm_table_put. Currently, =

> dm_table_put just decrements the counter and the cleanup is done =

> synchronously in dm_table_destroy. With your patch, cleanup would be done =

> in dm_table_put --- you call a target destructor (which may sleep) in a =

> non-sleeping context.
> =

> Some code may hold a mutex and call dm_table_put. If you call a target =

> destructor from dm_table_put and it takes the same mutex, it deadlocks.
> =

> Currently, when dm_table_destroy exits, it is guaranteed that the table i=
s =

> destroyed and all target destructors have been called. With your patch, =

> dm_table_destroy may exit and the table could be still alive because of =

> some other reference. This may cause leaked references to some other file=
s =

> or devices. For example, suppose that the user has a device mapper device =

> "dm" that redirects requests to "/dev/sda". The user assumes that if he =

> runs "dmsetup remove dm" and this command returns, "/dev/sda" will not be =

> open. Your patch breaks this assumption.
> =

Hmm. Yes, true.

> Look at the commit "d58168763f74d1edbc296d7038c60efe6493fdd4" in 2.6.29 =

> --- I was actually removing the old-style reference counting (that is =

> functionally equivalent to what your patch does) because of these three =

> problems. The old code really caused a crash although it happened very =

> rarely.
> =

Ah. That'll explain it.
The actual problem I'm trying to track down is that I'm seeing an
excessive duration for the 'resume' dm ioctl after a table update.
I've got reports where the ioctl can take up to several seconds.
Which (as this is multipath) causes an extremely erratic behaviour.

And the 'msleep' here is one of the obvious culprits.

But I'll continue debugging, maybe I'll find something else.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
