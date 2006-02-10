From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Support HDIO_GETGEO on device-mapper volumes
Date: Fri, 10 Feb 2006 20:27:28 +0000
Message-ID: <62b0912f0602101227q719e712bq40da5b2f0c5422c5@mail.gmail.com>
References: <43EBEDD0.60608@us.ibm.com>
	<20060210145348.GA12173@agk.surrey.redhat.com>
	<43ECAD5B.9070308@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43ECAD5B.9070308@cfl.rr.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Phillip Susi wrote:
> Yes, I think this could also be fixed on grub's end.  It seems that
> fdisk assumes usable default values for the geometry but grub has
> different defaults that cause it problems.  I think that the defaults
> could be modified in grub so that it will work when HDIO_GETGEO fails.

It would be better to make the decision once and for all, in one place.

It would be even better for the HDIO_GETGEO call to return the same
geometry that the BIOS uses, so that Grub is handed numbers that
actually mean *something*.

When 'dmraid' has assembled an array, it should find the matching BIOS
drive in /proc/bios/int13_dev* and then it should tell device-mapper
to present that geometry to whomever asks via HDIO_GETGEO.

And while we're at it, <some component> should do the same for eg.
/dev/hd?.  It's very annoying trying to fix up a harddrive's partition
table when the numbers you see in Linux is different to the numbers
you'll see when rebooting into DOS, or Windows XP, or whatever it is
that's on the disk you're trying to fix.
