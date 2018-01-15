From: Julian Andres Klode <julian.klode@canonical.com>
Subject: Re: multipath-tools 0.7.4 failure to remove device
Date: Mon, 15 Jan 2018 17:26:58 +0100
Message-ID: <20180115162658.wlccxhlaq56byykg@jak-x230>
References: <20180112083833.apsybil4ux4d2y32@jak-x230>
	<1515789339.3409.33.camel@suse.com>
	<20180112214700.ljxlypo5nar6oh3m@jak-x230>
	<1515795481.9139.8.camel@suse.com>
	<20180115154424.fcjuudt7phxrks6q@jak-x230>
	<1516032730.5699.38.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1516032730.5699.38.camel@suse.com>
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
Cc: Device-mapper development mailing list <dm-devel@redhat.com>, Guan Junxiong <guanjunxiong@huawei.com>
List-Id: dm-devel.ids

On Mon, Jan 15, 2018 at 05:12:10PM +0100, Martin Wilck wrote:
> On Mon, 2018-01-15 at 16:44 +0100, Julian Andres Klode wrote:
> > 
> > It was your commit that made it imply -n that caused the test failure
> > :)
> > I understand your position on that, but reverted it for Ubuntu,
> > because,
> > while it might be somewhat broken, it's at least the same level of
> > broken
> > as before.
> 
> I'd like to understand that better. Why would this break boot?

Ah sorry for the confusion. It did not break boot. Having finding
disabled would have "broken" boot. The problem I was talking about
was that with finding enabled, no dm devices were generated, which
it turned out, was not entirely true - you had to run multipath
manually (due to your find implies -n commit). 

It seems to me that this would cause more issues in practice than
just keeping the slightly race-y combination enabled. It's something
to revisit after the ubuntu lts when then people have some time to
adjust to that change.

-- 
debian developer - deb.li/jak | jak-linux.org - free software dev
ubuntu core developer                              i speak de, en
