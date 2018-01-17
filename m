From: Julian Andres Klode <julian.klode@canonical.com>
Subject: Re: multipath-tools 0.7.4 failure to remove device
Date: Wed, 17 Jan 2018 10:38:42 +0100
Message-ID: <20180117093842.ywogyfsztihwaie7@jak-x230>
References: <20180112083833.apsybil4ux4d2y32@jak-x230>
	<1515789339.3409.33.camel@suse.com>
	<20180112214700.ljxlypo5nar6oh3m@jak-x230>
	<1515795481.9139.8.camel@suse.com>
	<20180115154424.fcjuudt7phxrks6q@jak-x230>
	<1516032730.5699.38.camel@suse.com>
	<20180115162658.wlccxhlaq56byykg@jak-x230>
	<1516034784.5699.44.camel@suse.com>
	<20180116202946.GO5638@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180116202946.GO5638@octiron.msp.redhat.com>
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
Cc: Guan Junxiong <guanjunxiong@huawei.com>, Martin Wilck <mwilck@suse.com>, development mailing list <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Jan 16, 2018 at 02:30:46PM -0600, Benjamin Marzinski wrote:
> On Mon, Jan 15, 2018 at 05:46:24PM +0100, Martin Wilck wrote:
> > On Mon, 2018-01-15 at 17:26 +0100, Julian Andres Klode wrote:
> > > On Mon, Jan 15, 2018 at 05:12:10PM +0100, Martin Wilck wrote:
> > > > On Mon, 2018-01-15 at 16:44 +0100, Julian Andres Klode wrote:
> > > > > 
> > > > > It was your commit that made it imply -n that caused the test
> > > > > failure
> > > > > :)
> > > > > I understand your position on that, but reverted it for Ubuntu,
> > > > > because,
> > > > > while it might be somewhat broken, it's at least the same level
> > > > > of
> > > > > broken
> > > > > as before.
> > > > 
> > > > I'd like to understand that better. Why would this break boot?
> > > 
> > > Ah sorry for the confusion. It did not break boot. Having finding
> > > disabled would have "broken" boot. The problem I was talking about
> > > was that with finding enabled, no dm devices were generated, which
> > > it turned out, was not entirely true - you had to run multipath
> > > manually (due to your find implies -n commit). 
> > > 
> > > It seems to me that this would cause more issues in practice than
> > > just keeping the slightly race-y combination enabled. It's something
> > > to revisit after the ubuntu lts when then people have some time to
> > > adjust to that change.
> > 
> > I wouldn't call it "slightly race-y". With find_multipaths "on" and
> > "ignore_wwids" "off", "multipath -u" classifies every device as a
> > multipath device. So SYSTEMD_READY=0 will be set on each device. But
> > multipathd, which is responsible for actually setting up the map, will
> > honor "find_multipaths", and will not set up a map for a device it
> > finds only a single path for. So the device never appears in a state in
> > which systemd would be able to use it. Unless you've put in some other
> > magic, this is almost guaranteed to make your system unbootable in the
> > quite common case where people using multipath are running off a non-
> > multipathed local root disk.
> 
> RedHat also removes your patches to force ignore_wwids off and imply -n
> 
> 64e27ec066a001012f44550f095c93443e91d845
> ffbb886a8a16cb063d669cd76a1e656fd3ec8c4b

I only see you reverting the former, in  

  0013-RH-trigger-change-uevent-on-new-device-creation.patch


> As a side note, RedHat also adds code to automatically fire off a change
> uevent on all the path devices on the first time a multipath device is
> created, so that all the path devices get correctly claimed by multipath
> after the fact, on the first create. It's currently part of the same
> patch that reverts the two commits listed above, but I have no problem
> with posting it as a seperate patch. I obviously have no problem with
> reverting those two commits upstream either. But I don't feel horribly
> burdened with carrying them as RedHat patches.

I like that patch, that sounds like a good idea.

-- 
debian developer - deb.li/jak | jak-linux.org - free software dev
ubuntu core developer                              i speak de, en
