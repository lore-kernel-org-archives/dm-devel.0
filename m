From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: multipath-tools 0.7.4 failure to remove device
Date: Wed, 17 Jan 2018 12:45:30 -0600
Message-ID: <20180117184530.GS5638@octiron.msp.redhat.com>
References: <20180112083833.apsybil4ux4d2y32@jak-x230>
	<1515789339.3409.33.camel@suse.com>
	<20180112214700.ljxlypo5nar6oh3m@jak-x230>
	<1515795481.9139.8.camel@suse.com>
	<20180115154424.fcjuudt7phxrks6q@jak-x230>
	<1516032730.5699.38.camel@suse.com>
	<20180115162658.wlccxhlaq56byykg@jak-x230>
	<1516034784.5699.44.camel@suse.com>
	<20180116202946.GO5638@octiron.msp.redhat.com>
	<20180117093842.ywogyfsztihwaie7@jak-x230>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180117093842.ywogyfsztihwaie7@jak-x230>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Julian Andres Klode <julian.klode@canonical.com>
Cc: Guan Junxiong <guanjunxiong@huawei.com>, Martin Wilck <mwilck@suse.com>, development mailing list <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 17, 2018 at 10:38:42AM +0100, Julian Andres Klode wrote:
> On Tue, Jan 16, 2018 at 02:30:46PM -0600, Benjamin Marzinski wrote:
> > 
> > RedHat also removes your patches to force ignore_wwids off and imply -n
> > 
> > 64e27ec066a001012f44550f095c93443e91d845
> > ffbb886a8a16cb063d669cd76a1e656fd3ec8c4b
> 
> I only see you reverting the former, in  
> 
>   0013-RH-trigger-change-uevent-on-new-device-creation.patch
> 

Oops. It appears that the other patch got lost in the shuffle of
converting over to the new git repo, and rebasing, and since nothing
uses -i anymore, its absence was never noticed.

I suppose that sort of undercuts my argument that we need to keep -i
working the way I orginally envisioned.

Thanks for noticing.

> 
> > As a side note, RedHat also adds code to automatically fire off a change
> > uevent on all the path devices on the first time a multipath device is
> > created, so that all the path devices get correctly claimed by multipath
> > after the fact, on the first create. It's currently part of the same
> > patch that reverts the two commits listed above, but I have no problem
> > with posting it as a seperate patch. I obviously have no problem with
> > reverting those two commits upstream either. But I don't feel horribly
> > burdened with carrying them as RedHat patches.
> 
> I like that patch, that sounds like a good idea.

I'll post this as an RFC, and we can sort it out along with the other
patches.

-Ben

> 
> -- 
> debian developer - deb.li/jak | jak-linux.org - free software dev
> ubuntu core developer                              i speak de, en
