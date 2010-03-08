From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] blkdev: fix merge_bvec_fn return value
 checks
Date: Mon, 8 Mar 2010 16:43:36 +1100
Message-ID: <20100308164336.707f74be@notabene.brown>
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org>
	<20100228184634.GI5768@kernel.dk> <874okyf4iw.fsf@openvz.org>
	<170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com>
	<87wrxtkzwu.fsf@openvz.org> <20100303191613.GB18480@redhat.com>
	<87lje9kx9i.fsf@openvz.org> <20100303200734.GW5768@kernel.dk>
	<20100304175921.GD3670@soda.linbit>
	<20100305173716.GQ27852@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

On Fri, 5 Mar 2010 17:37:16 +0000
Alasdair G Kergon <agk@redhat.com> wrote:

> On Thu, Mar 04, 2010 at 06:59:21PM +0100, Lars Ellenberg wrote:
> > +		/* Restricting max_sectors is not enough.
> > +		 * If someone uses bio_add_page to add 8 disjunct 512 byte
> > +		 * partial pages to a bio, it would succeed,
> > +		 * but could still cross a border of whatever restrictions
> > +		 * are below us (raid0 stripe boundary).  An attempted
> > +		 * bio_split would not succeed, because bi_vcnt is 8.
> > +		 * E.g. the xen io layer is known to trigger this.
> > +		 */
> 
> Sounds plausible.
> 
> Do you or anyone readingt his have example messages demonstrating the failure
> when this patch is not applied?

Yes.  This

   http://marc.info/?l=linux-raid&m=126672681521073&w=2

almost certainly refers to that problem.

NeilBrown


> 
> Alasdair.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
