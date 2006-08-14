From: Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] device-mapper core should use private bioset
Date: Mon, 14 Aug 2006 17:29:58 +0100
Message-ID: <20060814162958.GQ18633@agk.surrey.redhat.com>
References: <44E068EC.20906@de.ibm.com>
Reply-To: dm-crypt-4q3lyFh4P1g@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-crypt-return-1808-glkdd-dm-crypt=m.gmane.org-4q3lyFh4P1g@public.gmane.org>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-help-4q3lyFh4P1g@public.gmane.org>
List-Unsubscribe: <mailto:dm-crypt-unsubscribe-4q3lyFh4P1g@public.gmane.org>
List-Subscribe: <mailto:dm-crypt-subscribe-4q3lyFh4P1g@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <44E068EC.20906-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
To: Stefan Bader <Stefan.Bader-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>, dm-crypt-4q3lyFh4P1g@public.gmane.org
List-Id: dm-devel.ids

On Mon, Aug 14, 2006 at 02:13:32PM +0200, Stefan Bader wrote:
> I found a problem within device-mapper that occurs in low-mem
> situations. It was found using a mirror target but I think in theory it
> would hit any setup that stacks device-mapper devices (like LVM on top
> of multipath).

Several dm targets suffer from this.

Mempools are not yet used correctly everywhere in device-mapper: they
can get shared when devices are stacked, and some targets share them across
multiple instances.  I made fixing this one of the prerequisites for this
patch:
  md-dm-reduce-stack-usage-with-stacked-block-devices.patch
which in some cases makes people more likely to hit the problem.

There's been some progress on this recently with (unfinished) dm-crypt
patches at:
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
    (dm-crypt-move-io-to-workqueue.patch plus dependencies)

I'll add (the first part of) your patch to the mix as it's another required
piece of the jigsaw, thanks.

Alasdair
