From: Hannes Reinecke <hare@suse.de>
Subject: Re: dd to a striped device with 9 disks gets much lower
 throughput when oflag=direct used
Date: Fri, 27 Jan 2012 07:54:47 +0100
Message-ID: <4F224A37.2090308@suse.de>
References: <CACyXjPzWjBz0=btbL0Gx_qoxRQs7wy9m=dY1--xL29uszTpmFA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CACyXjPzWjBz0=btbL0Gx_qoxRQs7wy9m=dY1--xL29uszTpmFA@mail.gmail.com>
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
List-Id: dm-devel.ids

On 01/27/2012 02:06 AM, Richard Sharpe wrote:
> Hi,
> =

> Perhaps I am doing something stupid, but I would like to understand
> why there is a difference in the following situation.
> =

> I have defined a stripe device thusly:
> =

>      "echo 0 17560535040 striped 9 8 /dev/sdd 0 /dev/sde 0 /dev/sdf 0
> /dev/sdg 0 /dev/sdh 0 /dev/sdi 0 /dev/sdj 0 /dev/sdk 0 /dev/sdl 0 |
> dmsetup create stripe_dev"
> =

> Then is did the following:
> =

>     dd if=3D/dev/zero of=3D/dev/mapper/stripe_dev bs=3D262144 count=3D100=
0000
> =

> and I got 880 MB/s
> =

> However, when I changed that command to:
> =

>     dd if=3D/dev/zero of=3D/dev/mapper/stripe_dev bs=3D262144 count=3D100=
0000
> oflag=3Ddirect
> =

> I get 210 MB/s reliably.
> =

> The system in question is a 16 core (probably two CPUs) Intel Xeon
> E5620 @2.40Ghz with 64GB of memory and 12 7200PRM SATA drives
> connected to an LSI SAS controller but set up as a JBOD of 12 drives.
> =

> Why do I see such a big performance difference? Does writing to the
> device also use the page cache if I don't specify DIRECT IO?
> =

Yes. All I/O using read/write calls is going via the pagecache.
The only way to circumvent this is to use DIRECT_IO.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
