From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 4/4] libmultipath: trigger uevents for
 partitions, too
Date: Wed, 10 Jul 2019 20:48:08 +0000
Message-ID: <d0ac134ae894884f7bbadb3449b11ab2a9867092.camel@suse.com>
References: <20190709073909.32112-1-martin.wilck@suse.com>
	<20190709073909.32112-5-martin.wilck@suse.com>
	<CAAMCDeeC31_C_4_CWXucmA2zeTvVqig3CsUmikfuuJA1V5YWRg@mail.gmail.com>
	<ba52db4bc532fe1f0ab4af0981c140eb4f339d68.camel@suse.com>
	<CAAMCDeeiDbQfmF8NrOpy5MHjaX3AvbA7VytAeZSoDb0z9R17vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAMCDeeiDbQfmF8NrOpy5MHjaX3AvbA7VytAeZSoDb0z9R17vg@mail.gmail.com>
Content-Language: en-US
Content-ID: <541A032FF8465C4F94F947B676A7A4FF@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "rogerheflin@gmail.com" <rogerheflin@gmail.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2019-07-10 at 12:42 -0500, Roger Heflin wrote:
> 
> The OS we have uses 62-multipath and does not have a global override
> like that.
> 
> I am looking at my notes on the issue and it was this:
> rootvg gets started directly on /dev/sda2 and then multipath starts
> up
> and attempts to mange it and deletes the partition on /dev/sda1
> causing the by-uuid link to be invalid but multipath fails to create
> the device with "map in use" because the lv's for rootvg are live on
> /dev/sda2 directly.   So it does sound like your fix would would
> correct this issue since on the multipath failure to manage it would
> recreate the /dev/sda1 device.  

Yes, it's certainly worth a try. This is the case the patch was made
for. You must make sure that your distro contains the commits it builds
upon (c5023200, e5d3c3a0). All this is fairly recent stuff.

> There appears to be some race
> condition in the initramfs/systemd where sometimes rootvg gets
> started
> before multipath has managed the device causing the partition to be
> deleted (we have multipath is the initramfs, and that was confirmed).

That should never happen. The multipath udev rules set SYSTEMD_READY=0
on the devices, thus lvm must refrain from grabbing them. Maybe
multipath_component_detection is off in your LVM2 setup?

> All of our other vg's dont have this issue as we are using the
> rd.lvm.vg= such that only the rootvg gets turned on early.
> 
> > Also, the rule only removes partitions for devices that have been
> > detected as being eligible for multipathing.
> > 
> > > The symbolic link does not appear to get re-created to point to
> > > the
> > > new multipath device which would lead one to suspect that there
> > > was
> > > no
> > > event happening for when the multipath device is created.
> > 
> > That's very unlikely. You should verify that the multipath device
> > (for
> > sda) is created. My patch here relates only to the case where
> > creating
> > the multipath device *fails*.
> > 
> ?
> > Maybe. I don't know enough details about your configuration to
> > tell.
> > But if this is a device that should not be multipathed, from my
> > point
> > of view, proper blacklisting via multipath.conf is the recommended
> > way
> > to handle this problem.
> > 
> > You can also use "find_multipaths"; please check the documentation.
> > Note also that since 0.7.8, blacklisting "by protocol" is possible,
> > which makes it possible e.g. to blacklist local SATA disks with a
> > simple statement.
> > 
> We intentionally have find_multipaths set to allow a single path. 

But the map which is causing the problem does have multiple paths, if I
understand correctly? Not all past versions of multipath-tools behaved
consistently with "find_multipaths yes"; if you have such a version,
that might even explain the race you were talking about. But this is
speculation. The behavior depends on which commits exactly are in your
code base.

Anyway, I can't say much about it without knowing all the details. It
seems that you should contact your distro vendor.

Martin
