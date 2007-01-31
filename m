From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Weird discrepancy between /dev/mapper/* and /dev/dm-*
	devices breaks lilo
Date: Wed, 31 Jan 2007 15:10:59 +0000
Message-ID: <20070131151059.GC21980@agk.surrey.redhat.com>
References: <20070131104737.GA29370@bee.dooz.org>
	<20070131110010.GA29662@bee.dooz.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070131110010.GA29662@bee.dooz.org>
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

On Wed, Jan 31, 2007 at 12:00:10PM +0100, Lo=EFc Minier wrote:
>  supposed to call something like "dmsetup info" on the
>  major/minor of dm-1 to translate this into a device mapper
>  "device_name"?  E.g.:

That would work.

>  Or is the device-mapper code supposed to accept device names from /dev
>  as parameters?
=20
It does not do that at the moment.  Perhaps there's a case for adding
inode->device number conversions to dmsetup: You're the first person to s=
uggest
this.

Alasdair
--=20
agk@redhat.com
