From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] libmultipath: Allow discovery of USB devices
Date: Wed, 23 Sep 2020 00:34:45 +0200
Message-ID: <df42a8a5ed7ecd27cc6d30a5561e1cc716d27033.camel@suse.com>
References: <AM0PR09MB289726B5423506E7A0CBFA47FE3B0@AM0PR09MB2897.eurprd09.prod.outlook.com>
	<42aa1aaf935927e169e27e035fe307fd8181f9a6.camel@suse.com>
	<20200922222726.GC11108@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200922222726.GC11108@octiron.msp.redhat.com>
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
Cc: Frank Meinl <frank.meinl@live.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 2020-09-22 at 17:27 -0500, Benjamin Marzinski wrote:
> On Tue, Sep 22, 2020 at 09:59:36PM +0200, Martin Wilck wrote:
> > On Tue, 2020-09-22 at 20:34 +0200, Frank Meinl wrote:
> > > This change adds a new configuration option allow_usb_devices. It
> > > is
> > > disabled by default, so that the behavior of existing setups is
> > > not
> > > changed. If enabled (via multipath.conf), USB devices will be
> > > found
> > > during device discovery and can be used for multipath setups.
> > > 
> > > Without this option, multipath currently ignores all USB drives,
> > > which
> > > is convenient for most users. (refer also to commit 51957eb)
> > > 
> > > However, it can be beneficial to use the multipath dm-module even
> > > if
> > > there is only a single path to an USB attached storage. In
> > > combination
> > > with the option 'queue_if_no_path', such a setup survives a
> > > temporary
> > > device disconnect without any severe consequences for the running
> > > applications. All I/O is queued until the device reappears.
> > 
> > Hm. So you want to use multipath just to enable queueing?
> > I wonder if that can't be achieved some other way; multipath seems
> > to
> > be quite big hammer for this nail. Anyway, I don't think this would
> > hurt us, so I don't have good reasons to reject it.
> > 
> > Waiting for others' opinions.
> 
> I've actually seen other cases where people are using multipath on
> single path devices just for the queuing, and when I thought about
> it, I
> realized that it makes sense. Multipath works with devices as they
> are,
> instead of needing special metadata, like lvm devices. People often
> realize that they need this after the device is already set up. Plus,
> multipath already deals with devices that have partitions or logical
> volumes on top of them. It's also easy to configure exactly how you
> want
> queueing to work. This use case might be a small nail, but it is a
> nail,
> and multipath is a reasonable tool to get the job done.
> 
> It doesn't seem too hard to write a dm target that would queue and
> retry
> IO at some configurable interval, for some configurable number of
> times,
> when it failed. But you would also need to copy the work for getting
> the
> device, and any partitons on it, to autoassemble after the frist time
> it's set up and to make sure other layers use this device instead of
> the
> underlying device. Or, people can just use multipath.

Ok. So Frank, please just clarify the remaining minor points. You may
actually want to put (a short version of) this motivation in the man
page.

Regards,
Martin
