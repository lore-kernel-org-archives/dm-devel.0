From: =?iso-8859-1?Q?Lo=EFc?= Minier <lool+redhat@via.ecp.fr>
Subject: Re: Weird discrepancy between /dev/mapper/* and /dev/dm-*
	devices breaks lilo
Date: Wed, 31 Jan 2007 16:47:32 +0100
Message-ID: <20070131154732.GC27755@bee.dooz.org>
References: <20070131104737.GA29370@bee.dooz.org>
	<20070131110010.GA29662@bee.dooz.org>
	<20070131151059.GC21980@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070131151059.GC21980@agk.surrey.redhat.com>
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

On Wed, Jan 31, 2007, Alasdair G Kergon wrote:
> >  Or is the device-mapper code supposed to accept device names from /d=
ev
> >  as parameters?
> It does not do that at the moment.  Perhaps there's a case for adding
> inode->device number conversions to dmsetup: You're the first person
> to suggest this.

 Ok; lilo isn't calling the dmsetup command, but uses libdevmapper
 directly, so even if you add support for any /dev device name in
 dmsetup, it wont help lilo.  Hence, I've changed the problematic dm
 task call to use major/minor instead of the name (see attached patch)
 and will wait for feedback from users as I don't have such a setup.

 So, thanks for clarifying this!  I'm not sure it would be a good idea
 to accept device mapper names as well as /dev names in dmsetup as I
 think this would confuse things.  I personally like it that dmsetup
 reflects what the ioctl accepts, nothing more, nothing less.


PS: I was wrong when saying that the code is in a Debian specific patch,
the patch is only historic and the problematic code is in the lilo
mainline
--=20
Lo=EFc Minier <lool@dooz.org>
