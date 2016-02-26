From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH]multipath-tools: prevent unnecessary
 reinstate of stand-by paths with implicit tpgs mode and no active array
 paths.
Date: Fri, 26 Feb 2016 13:44:04 +0800
Message-ID: <56CFE624.4020403@suse.de>
References: <065E3B7B-8F7D-48D9-BCB9-DFE13F8F3923@nimblestorage.com>
	<20160225204953.GA2915@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160225204953.GA2915@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Shiva Krishna <Shiva.Krishna@nimblestorage.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 02/26/2016 04:49 AM, Benjamin Marzinski wrote:
> On Sat, Feb 20, 2016 at 08:23:29PM +0000, Shiva Krishna wrote:
> =

> I understand your problem, but this isn't the right patch to fix it. For
> one this check
> =

> +		if (newstate !=3D PATH_GHOST || pp->mpp->nr_active > 0 ||
> +		    pp->tpgs !=3D TPGS_IMPLICIT) {
> =

> is pretty problematic.  Every path that isn't alua or doesn't enable
> detect_prio will have pp->tpgs !=3D TPGS_IMPLICIT (because this will be
> zeroed out on path creation for all paths, and TPGS_IMPLICIT =3D=3D 0x1).=
 If
> you need special handling for PATH_GHOST, and you don't want to copy and
> modify an existing checker, then you should probably go with a config
> option to enable this on your device, perhaps ghost_is_standby.  Then
> you (and anyone else who needs this) can set that in your builtin device
> config, and you don't need to try to craft a complicated check to get
> this right.
> =

> Also, I see how this will stop the reinstate on the check after the
> kernel fails this path, but how about on the check after that?
> =

> That check that you added before reinstate only happens on the
> =

> if (newstate !=3D pp->state) {
> =

> branch. The next time you check the path, presumably newstate will equal
> pp->state and the code does
> =

>       else if (newstate =3D=3D PATH_UP || newstate =3D=3D PATH_GHOST) {
>                 if (pp->dmstate =3D=3D PSTATE_FAILED ||
>                     pp->dmstate =3D=3D PSTATE_UNDEF) {
>                         /* Clear IO errors */
>                         if (reinstate_path(pp, 0)) {
> =

> Won't you simply reinstate the path here? There are other places where
> the path can get reinstated as well.  Possibly a better option is to use
> your config option to check the return from (or perhpas in) get_state()
> and if it is PATH_GHOST, change it to a new state, say PATH_STANDBY.
> Now, if you do this, you will probably need to go through and add
> PATH_STANDBY to all the checks that look for PATH_DOWN or PATH_SHAKY, so
> that multipath is treating PATH_STANDBY like PATH_DOWN, but with a more
> helpful name.  In which case, you might just want to make the check a
> macro on inline function. And as long as you're doing that, you should
> add PATH_TIMEOUT to the check as well, so that it gets treated like
> PATH_DOWN, because currently it doesn't, which is broken.
> =

This is also my thinking.

Shiva is right, that we need to differentiate between standby paths
which can be switched to (eg if explicit ALUA is supported), and standby
paths which cannot be switched to (like in the above case).
So I would propose to introduce a new state for this (maybe indeed
PATH_STANDBY, but I'm not particular about that), and audit the code
paths to ensure it's handled correctly.

That would even allow us to run multipath on a standby cluster node
where _all_ paths in standby and we cannot switch to either, as we need
to wait for the node to become activated.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
