From: Hannes Reinecke <hare@suse.de>
Subject: Re: Multipathd on Opensuse 11.4 x64 buffer overwflow
 when starting with -D args too
Date: Wed, 06 Jul 2011 08:34:22 +0200
Message-ID: <4E1401EE.7050703@suse.de>
References: <4E137232.8030603@libero.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4E137232.8030603@libero.it>
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
Cc: Roberto Giordani <r.giordani@libero.it>
List-Id: dm-devel.ids

On 07/05/2011 10:21 PM, Roberto Giordani wrote:
> Hello,
> as described on Bug 693131
>
> the
>
> +ARGS=3D"-d&>/dev/null&"
>
> workaround doesn't work for me. :-(
>
> I've tried to build the last multipath.tools 0.4.9 on Opensuse 11.4 x64
> and the build seems ok, but after run
> multipathd the system hang for few seconds and than fails.
>
> I've tried to build RPMs too, but I have received an error when try to
> use library on /lib and not on /lib64.
> Changing the path on the Makefile I've  receive another error.
>
> Could someone help me, because on opensuse 11.2 and 11.3 the multipath
> works fine.
>
Sorry for this, but I've been pretty busy lately with a new release =

coming on etc.

Most of my outstanding patches have been pushed upstream. =

Unfortunately I've found some more issues in the meantime, which =

still have to be pushed.

I'll see to have it fixed up.

Meanwhile you could try my multipath-tools git tree at

git://git.kernel.org/pub/scm/linux/kernel/git/hare/multipath-tools.git
branch sles11-sp2

That should work on 11.4, too.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
