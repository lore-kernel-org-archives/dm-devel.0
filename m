From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 1/2] blkdev: fix merge_bvec_fn return value
 checks
Date: Fri, 5 Mar 2010 20:20:27 +0100
Message-ID: <20100305192027.GA24222@soda.linbit>
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org>
	<20100228184634.GI5768@kernel.dk> <874okyf4iw.fsf@openvz.org>
	<170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com>
	<87wrxtkzwu.fsf@openvz.org> <20100303191613.GB18480@redhat.com>
	<87lje9kx9i.fsf@openvz.org> <20100303200734.GW5768@kernel.dk>
	<20100304175921.GD3670@soda.linbit>
	<20100305173716.GQ27852@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100305173716.GQ27852@agk-dp.fab.redhat.com>
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

On Fri, Mar 05, 2010 at 05:37:16PM +0000, Alasdair G Kergon wrote:
> On Thu, Mar 04, 2010 at 06:59:21PM +0100, Lars Ellenberg wrote:
> > +		/* Restricting max_sectors is not enough.
> > +		 * If someone uses bio_add_page to add 8 disjunct 512 byte
> > +		 * partial pages to a bio, it would succeed,
> > +		 * but could still cross a border of whatever restrictions
> > +		 * are below us (raid0 stripe boundary).  An attempted
> > +		 * bio_split would not succeed, because bi_vcnt is 8.
> > +		 * E.g. the xen io layer is known to trigger this.
> > +		 */
> =

> Sounds plausible.
> =

> Do you or anyone readingt his have example messages demonstrating the fai=
lure
> when this patch is not applied?

This has been an issue said two years ago when using Xen VMs on DRBD cluste=
rs.
My original summary post once the issue was understood is
http://archives.free.net.ph/message/20080523.161104.054c63ef.html

(the gmane link therein seems to be broken now, is not really of
interesst here anyways, but, just in case, equivalent with
http://archives.free.net.ph/message/20080410.212155.d9e0243d.html)

Actual error messages looked like
kernel: drbd3: bio would need to, but cannot, be split: (vcnt=3D8,idx=3D0,s=
ize=3D4096,sector=3D13113083)
kernel: drbd3: bio would need to, but cannot, be split: (vcnt=3D8,idx=3D0,s=
ize=3D4096,sector=3D13113149)
kernel: drbd3: bio would need to, but cannot, be split: (vcnt=3D8,idx=3D0,s=
ize=3D4096,sector=3D13113215)

 bi_size is only 4k, but bi_vcnt is 8.

These had been submitted by Xen virtio on a typical VM image with the
legacy 63 sector offset into the first "partition".

You'd have the exact same issue (with slightly different error printk's)
on md raid0, or any other bio consumer with boundary restrictions not
having "generic" bio split logic, but directly using bio_split(),
as that does
	BUG_ON(bi->bi_vcnt !=3D 1);
	BUG_ON(bi->bi_idx !=3D 0);

-- =

: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD=AE and LINBIT=AE are registered trademarks of LINBIT, Austria.
