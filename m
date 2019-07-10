From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: [PATCH 4/4] libmultipath: trigger uevents for
 partitions, too
Date: Wed, 10 Jul 2019 12:42:00 -0500
Message-ID: <CAAMCDeeiDbQfmF8NrOpy5MHjaX3AvbA7VytAeZSoDb0z9R17vg@mail.gmail.com>
References: <20190709073909.32112-1-martin.wilck@suse.com>
	<20190709073909.32112-5-martin.wilck@suse.com>
	<CAAMCDeeC31_C_4_CWXucmA2zeTvVqig3CsUmikfuuJA1V5YWRg@mail.gmail.com>
	<ba52db4bc532fe1f0ab4af0981c140eb4f339d68.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ba52db4bc532fe1f0ab4af0981c140eb4f339d68.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Jul 10, 2019 at 5:49 AM Martin Wilck <Martin.Wilck@suse.com> wrote:
>
> On Tue, 2019-07-09 at 11:40 -0500, Roger Heflin wrote:
> > We have an observed behavior as follows:
> >
> > When the host boots up, a uuid symbolic link is created pointing at
> > /dev/sda1 (device for /boot)
> >
> > Multipath starts up and creates an multipath device to manage
> > /dev/sda
> > and a udev rule deletes /dev/sda1 invalidating the symbolic link.
>
> I suppose you are talking about 68-del-part-nodes.rules. Note that the
> rules in this file can be deactivated by setting
> ENV{DONT_DEL_PART_NODES}="1" in an early udev rule.

The OS we have uses 62-multipath and does not have a global override like that.

I am looking at my notes on the issue and it was this:
rootvg gets started directly on /dev/sda2 and then multipath starts up
and attempts to mange it and deletes the partition on /dev/sda1
causing the by-uuid link to be invalid but multipath fails to create
the device with "map in use" because the lv's for rootvg are live on
/dev/sda2 directly.   So it does sound like your fix would would
correct this issue since on the multipath failure to manage it would
recreate the /dev/sda1 device.  There appears to be some race
condition in the initramfs/systemd where sometimes rootvg gets started
before multipath has managed the device causing the partition to be
deleted (we have multipath is the initramfs, and that was confirmed).
All of our other vg's dont have this issue as we are using the
rd.lvm.vg= such that only the rootvg gets turned on early.

>
> Also, the rule only removes partitions for devices that have been
> detected as being eligible for multipathing.
>
> > The symbolic link does not appear to get re-created to point to the
> > new multipath device which would lead one to suspect that there was
> > no
> > event happening for when the multipath device is created.
>
> That's very unlikely. You should verify that the multipath device (for
> sda) is created. My patch here relates only to the case where creating
> the multipath device *fails*.
>
?
>
> Maybe. I don't know enough details about your configuration to tell.
> But if this is a device that should not be multipathed, from my point
> of view, proper blacklisting via multipath.conf is the recommended way
> to handle this problem.
>
> You can also use "find_multipaths"; please check the documentation.
> Note also that since 0.7.8, blacklisting "by protocol" is possible,
> which makes it possible e.g. to blacklist local SATA disks with a
> simple statement.
>
We intentionally have find_multipaths set to allow a single path.  The
issue is on a number of VM and using multipath for everything allows
us to not have separate work instructions/scripts for VM's vs
physical, and also allows using multipath to use io retries to work
around short-term external vmhost and storage issues without having to
identify what nodes were affected and reboot them all (they just pause
and continue once the issue is fixed).  It is a very large environment
and things happen in the different sections of the environment and we
have been tweaking various configuration settings to result in less
trouble/more stability when things happen.   The environment has >5000
linux VM's and > 5000 physical linux hosts.

> Martin
>
