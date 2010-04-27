From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Status of dm integrity checksumming features
Date: Tue, 27 Apr 2010 20:01:29 +0300
Message-ID: <20100427170128.GX17817@reaktio.net>
References: <20100324163920.GM1878@reaktio.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100324163920.GM1878@reaktio.net>
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

On Wed, Mar 24, 2010 at 06:39:20PM +0200, Pasi K=E4rkk=E4inen wrote:
> Hello,
> =

> What's the current status of Linux device mapper integrity (checksumming)=
 features? =

> =

> iirc bio integrity extensions were integrated into Linux 2.6.27, but thos=
e are only
> usable for SCSI disks that provide 520-bytes per sector support and also =
have the =

> hardware support for verifying the checksums, correct? Or then you need t=
o have a HBA
> or RAID-adapter with integrity support..
> =

> (bio integrity patches: http://kerneltrap.org/mailarchive/linux-kernel/20=
08/6/7/2056354)
> =

> Is it possible to use 'normal' 512-bytes per sectors disks, and store the=
 checksums
> on them, and calculate/verify the checkcums in software in device mapper.=
. =

> this obviously gives you a bit less usable space, but would be suitable f=
or sw-raid scenarios. =

> =

> I guess that sounds pretty much like dm-csum:
> https://patchwork.kernel.org/patch/25245/
> =

> What's the status of all this nowadays? =

> =


Any comments about this? =


-- Pasi
