From: Luca Berra <bluca@comedia.it>
Subject: Re: Weird discrepancy between /dev/mapper/* and /dev/dm-*
	devices breaks lilo
Date: Wed, 31 Jan 2007 21:10:59 +0100
Message-ID: <20070131201058.GA29960@percy.comedia.it>
References: <20070131104737.GA29370@bee.dooz.org>
	<20070131150635.GB21980@agk.surrey.redhat.com>
	<20070131155429.GD27755@bee.dooz.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070131155429.GD27755@bee.dooz.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Wed, Jan 31, 2007 at 04:54:29PM +0100, Lo=EFc Minier wrote:
>On Wed, Jan 31, 2007, Alasdair G Kergon wrote:
>> Some distributions chose to configure udev to create /dev/dm-N inodes =
where
>> N is the minor number.  (I have always discouraged that as a recipe fo=
r
>> confusion: I believe that using configurable names is a better approac=
h.)

i tend to agree with Alasdair on the above point

> I seem to recall even RedHat or Fedora attempted to add these devices,
> but I suppose you know best.  The reasons why these were added in udev
> in Debian and Ubuntu are mentionned in http://bugs.debian.org/392623,
> but in short gnome-mount required this to work; perhaps this should be
> fixed in gnome-mount.  The details are in a comment of #401393 though:
>  <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D401393;msg=3D37>

I also looked at the patch to support LUKS into hal and i tought it was
badly written (forgot the gory details)

> (attaching the patch I mentionned in the preceding mail but forgot,
> sorry)

in any case i lost the argument, so i think that i will use your patch,
at least until grub2 gets support for the eye-candy gfxboot, then i hope
to toss lilo into oblivion.

Thanks for providing the patch,
L.

--=20
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
