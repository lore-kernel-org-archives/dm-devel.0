From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC PATCH 5/5] multipathd: RFC add new
	polling	dmevents waiter thread
Date: Tue, 13 Feb 2018 01:13:34 +0000
Message-ID: <20180213011334.GG16558@agk-dp.fab.redhat.com>
References: <1518239251-29392-1-git-send-email-bmarzins@redhat.com>
	<1518239251-29392-6-git-send-email-bmarzins@redhat.com>
	<1518292553.2937.44.camel@suse.com>
	<20180212231802.GA14513@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180212231802.GA14513@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On Mon, Feb 12, 2018 at 05:18:02PM -0600, Benjamin Marzinski wrote:
> It is the DM_EXISTS_FLAG. It's defined in libdm/ioctl/libdm-iface.c in
> the lvm2 source.  It is unconditionally set on all dm control ioctls
> from libdevmapper by _do_dm_ioctl() (also in libdm/ioctl/libdm-iface.c).
> I don't know the reason for this. I don't see anything that uses it in
> driver/md/dm-ioctl.c, and I see that line in the libdm source has a
> /* FIXME */ next to it. On the other hand, all I'm trying to do here is
> run the same ioctl that libdevmapper would if it supported this command,
> and there may well be a reason for it that I'm missing.
  
DM_EXISTS_FLAG indicates that the device the ioctl referenced exists.

If you performed certain queries and the device was not found, you
got a successful return but without this flag.

In the dim and distant past this flag was handled kernel-side.  Later,
we dropped it but left that userspace code emulating it.  The FIXMEs
were just saying that the library code could be cleaned up too one day.
  Ref. https://lwn.net/Articles/38512/

Alasdair
