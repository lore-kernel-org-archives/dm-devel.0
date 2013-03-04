From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Chicken and egg problem with multipath-tools
Date: Mon, 04 Mar 2013 10:54:15 +0000
Message-ID: <51347D57.9000908@redhat.com>
References: <1362220999.44153.YahooMailClassic@web126202.mail.ne1.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>
Cc: "Andrei B." <andrixnet@yahoo.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/02/2013 10:43 AM, Andrei B. wrote:
> Hi,
> 
> I've been trying to install multipath-tools on a couple of linux
> servers with FC storage that I work with. They run Linux
> Slackware. I've built from source, created an installable package
> (Slackware style) and deployed it.
> 
> I have discovered the following problem (chicken and egg style):
> 
> - multipathd, AFAIK, should start before LVM, because if several
> volumes need be assembled by LVM, they should exist before LVM
> starts.

The daemon is not required to discovery paths; just call "multipath"
in the initramfs or early userspace to create mapped devices. Start
the daemon later when you have writable root/var (or hack around it as
I mentioned in my other reply).

> - multipathd, AFAIK, should start before any service that has it's
> data stored on the remote storage.

No need usually. There is a small window where a path failure during
boot will not be recoverable however in over five years supporting
distros using this approach I've never seen that happen in practice
(the timing is tight - it must be after mapping the device but before
userspace gets going and it must require the daemon to intervene to
reinstate paths to carry on).

> I am not familiar [enough] with the inner workings of the startup
> sequence on redhat/debian like systems. Slackware's startup
> sequence is much simpler and I placed multipathd in file rc.S
> (which is the first one called by init) right before LVM.

Call multipath instead. Then start multipathd after your LVM devices
are up and /var is writable.

Regards,
Bryn.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlE0fVcACgkQ6YSQoMYUY96cnQCeI/AYeKvu36kpdefUeLT4mNvw
1ycAoNQlgCK2D+fyHOjrEsPilzWMz+sn
=qWjC
-----END PGP SIGNATURE-----
