From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: RFC: I/O bandwidth controller
Date: Fri, 08 Aug 2008 19:05:12 +0900 (JST)
Message-ID: <20080808.190512.183028839.ryov@valinux.co.jp>
References: <20080808.152119.43521725.taka@valinux.co.jp>
	<20080808.162024.189720323.ryov@valinux.co.jp>
	<1218183056.17648.6.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <1218183056.17648.6.camel@sebastian.kern.oss.ntt.co.jp>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: fernando@oss.ntt.co.jp
Cc: yoshikawa.takuya@oss.ntt.co.jp, xen-devel@lists.xensource.com, uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com, taka@valinux.co.jp, dm-devel@redhat.com, agk@sourceware.org, virtualization@lists.linux-foundation.org, ngupta@google.com, righi.andrea@gmail.com
List-Id: dm-devel.ids

Hi Fernando,

> > > >   - Implement a block layer resource controller. dm-ioband is a working
> > > > solution and feature rich but its dependency on the dm infrastructure is
> > > > likely to find opposition (the dm layer does not handle barriers
> > > > properly and the maximum size of I/O requests can be limited in some
> > > > cases). In such a case, we could either try to build a standalone
> > > > resource controller based on dm-ioband (which would probably hook into
> > > > generic_make_request) or try to come up with something new.
> > > 
> > > I doubt about the maximum size of I/O requests problem. You can't avoid
> > > this problem as far as you use device mapper modules with such a bad
> > > manner, even if the controller is implemented as a stand-alone controller.
> > > There is no limitation if you only use dm-ioband without any other device
> > > mapper modules.
> > 
> > The following is a part of source code where the limitation comes from.
> > 
> > dm-table.c: dm_set_device_limits()
> >         /*
> >          * Check if merge fn is supported.
> >          * If not we'll force DM to use PAGE_SIZE or
> >          * smaller I/O, just to be safe.
> >          */
> > 
> >         if (q->merge_bvec_fn && !ti->type->merge)
> >                 rs->max_sectors =
> >                         min_not_zero(rs->max_sectors,
> >                                      (unsigned int) (PAGE_SIZE >> 9));
> > 
> > As far as I can find, In 2.6.27-rc1-mm1, Only some software RAID
> > drivers and pktcdvd driver define merge_bvec_fn().
> 
> Yup, exactly. The implication of this is that we may see a drop in
> performance in some RAID configurations.

The current device-mapper introduces a bvec merge function for device
mapper devices. IMHO, the limitation goes away once we implement this
in dm-ioband. Am I right, Alasdair?

Thanks,
Ryo Tsuruta
