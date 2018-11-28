From: Martin Wilck <mwilck@suse.de>
Subject: Re: Disconcerting observation with multipathd's dmevent
	polling code
Date: Wed, 28 Nov 2018 20:35:05 +0100
Message-ID: <ba0eac644bd0c426aab650c02eec9017047c6802.camel@suse.de>
References: <9f372197ec112f97298641e223d2e5e6a5e1b33a.camel@suse.de>
	<6fab77be-763c-4de0-a312-de112e7d1c0a@suse.de>
	<82f6c1b983936a2de4a3f1663f2886cf636460f3.camel@suse.de>
	<20181127201333.GD5077@octiron.msp.redhat.com>
	<b3608cce3000a34787d5c252d2dcb8fb6775ba42.camel@suse.de>
	<20181128165714.GI5077@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181128165714.GI5077@octiron.msp.redhat.com>
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
Cc: dm-devel mailing list <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2018-11-28 at 10:57 -0600, Benjamin Marzinski wrote:
> On Wed, Nov 28, 2018 at 10:31:02AM +0100, Martin Wilck wrote:
> > 
> > If "remove" uevents is most important, what if we created an
> > additional
> > monitor for "kernel" uevents in multipathd? Those should be just as
> > reliable as dmevents, and for removal, we don't need the udev rule
> > processing. Having ACTION==remove and the KERNEL name should be
> > sufficient. This would obviously not work for "change" or "add"
> > events.
> 
> That would certainly help, but again, I would contend that it's not
> as
> reliable as devmapper. From the netlink man page
> 
> "However, reliable transmissions from kernel to user are impossible
> in
> any case. The kernel can't send a netlink message if the socket
> buffer
> is full: the message will be dropped and the kernel and the user-
> space
> process will no longer have the same view of kernel state. It is up
> to
> the application to detect when this happens (via the ENOBUFS error
> returned by recvmsg(2)) and resynchronize."
> 
> In this case, we would need to rescan everything on ENOBUFS, but at
> least we would get a notification.

By running the uevent listener with RT priority and using a suitably
large receive buffer, we should be able to reduce the likelihood of
this happening such that it doesn't really matter anymore. In real OOM
situations, multipathd is pretty much hosed anyway. multipathd hasn't
been written with resilience against memory pressure in mind.

But for the time being, I'm fine with your dm_is_mpath patch.

Thanks
Martin
