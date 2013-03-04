From: Hannes Reinecke <hare@suse.de>
Subject: Re: Chicken and egg problem with multipath-tools
Date: Mon, 04 Mar 2013 07:54:41 +0100
Message-ID: <51344531.90705@suse.de>
References: <1362220999.44153.YahooMailClassic@web126202.mail.ne1.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1362220999.44153.YahooMailClassic@web126202.mail.ne1.yahoo.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On 03/02/2013 11:43 AM, Andrei B. wrote:
> Hi,
>
> I've been trying to install multipath-tools on a couple of linux servers =
with FC storage that I work with.
> They run Linux Slackware.
> I've built from source, created an installable package (Slackware style) =
and deployed it.
>
> I have discovered the following problem (chicken and egg style):
>
> - multipathd, AFAIK, should start before LVM, because if several volumes =
need be assembled by LVM,
 > they should exist before LVM starts.
> - multipathd, AFAIK, should start before any service that has it's data s=
tored on the remote storage.
>
> I am not familiar [enough] with the inner workings of the startup sequenc=
e on redhat/debian like systems.
> Slackware's startup sequence is much simpler and I placed multipathd in f=
ile rc.S (which is the first
 > one called by init) right before LVM.
>
> And here lies the chicken-egg problem. At this point, only the root files=
ystem is mounted and
 > it is mounted read-only. It is the correct and proper startup =

sequence in Slackware. Filesystems
 > are checked for errors after LVM starts and then root is =

remounted read-write and the rest
 > of the filesystems are mounted.
>
> The problem is that multipathd wants to create a PID file under /var (whi=
ch is at this time readonly).
 > This fails and multipathd fails to start.
> It took me a lot of testing and reboots until I managed to determine this=
 is the actual problem.
>
Hmm. Why? multipathd can happily live without a PID file; SUSE has =

been doing this for years (for precisely the same reason).
Check the SUSE init scripts.

> The stop-gap solution I have found, so far, is to load dm-multipath modul=
e and run multipath -v0
> before LVM, thus creating the multipath devices, then later, after the fi=
lesystems are remounted
 > rw, start multipathd.
>
Bah.
Just start multipathd without creating a pid file.
Then you can check if multipathd runs via the multipathd CLI.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
