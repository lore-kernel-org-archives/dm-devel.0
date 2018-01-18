From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: multipath-tools 0.7.4 failure to remove device
Date: Wed, 17 Jan 2018 21:50:03 -0600
Message-ID: <20180118035003.GV5638@octiron.msp.redhat.com>
References: <1515789339.3409.33.camel@suse.com>
	<20180112214700.ljxlypo5nar6oh3m@jak-x230>
	<1515795481.9139.8.camel@suse.com>
	<20180115154424.fcjuudt7phxrks6q@jak-x230>
	<1516032730.5699.38.camel@suse.com>
	<20180115162658.wlccxhlaq56byykg@jak-x230>
	<1516034784.5699.44.camel@suse.com>
	<20180116202946.GO5638@octiron.msp.redhat.com>
	<1516149827.23203.68.camel@suse.com>
	<20180117183858.GR5638@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180117183858.GR5638@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: Julian Andres Klode <julian.klode@canonical.com>, Guan Junxiong <guanjunxiong@huawei.com>, development mailing list <dm-devel@redhat.com>
List-Id: dm-devel.ids

Just a bit more information about how RedHat works with multipath
claiming devices in a find_multipaths setup.

Clearly, if you have a multipathed root device, it should be in the
wwids file from the time of installation. So, multipath will
automatically claim it right away when "-i" isn't used. This should
always work fine. But like I mentioned, there is a race when new storage
is added. If that new storage is discovered in the initramfs, the race
can happen there during boot.

When -i isn't used in udev this race isn't as bad.  Usually multipathd
will lose the race to autoassemble on the device, since it can't start
until the second path has been discovered, and lvm/md can start right
away. This means that the wwid will never get in the wwids file, so
multipath will never claim any of the paths, and lvm/md will get
assembled on one path. However if multipathd wins the race and it's
close to a tie, there's a chance that lvm/md will be trying to
autoassemble on the device, and will fail because mutipath just did (or
possibly because the partition devices were removed out from under it).

Now, I don't see how this could cause a boot to fail since this is a new
device that isn't getting set up, but I really never test this, because
when we create the initramfs in RedHat based distros, we edit the
multipath.conf file in it to blacklist all devices except those needed
by the initramfs. This means that we never discover new devices in the
initramfs. In fact, we don't multipath any devices unnecessary for
booting in the initramfs. So, while I can't see a way for this new
device race to cause boot to fail when -i isn't used in udev, I must
admit that we just exclude that from ever happening, so I can't say for
certain that it would always work. Of course it's simple to avoid the
possibility of this race in the initramfs, even without editting
multipath.conf. You just start multipathd with -n in the initramfs.

-Ben
