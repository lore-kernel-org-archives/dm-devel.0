From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: multipath-tools 0.7.4 failure to remove device
Date: Thu, 18 Jan 2018 09:22:03 -0600
Message-ID: <20180118152203.GW5638@octiron.msp.redhat.com>
References: <1515795481.9139.8.camel@suse.com>
	<20180115154424.fcjuudt7phxrks6q@jak-x230>
	<1516032730.5699.38.camel@suse.com>
	<20180115162658.wlccxhlaq56byykg@jak-x230>
	<1516034784.5699.44.camel@suse.com>
	<20180116202946.GO5638@octiron.msp.redhat.com>
	<1516149827.23203.68.camel@suse.com>
	<20180117183858.GR5638@octiron.msp.redhat.com>
	<20180118035003.GV5638@octiron.msp.redhat.com>
	<1516263062.4861.4.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1516263062.4861.4.camel@suse.com>
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

On Thu, Jan 18, 2018 at 09:11:02AM +0100, Martin Wilck wrote:
> On Wed, 2018-01-17 at 21:50 -0600, Benjamin Marzinski wrote:
> =

> > Now, I don't see how this could cause a boot to fail since this is a
> > new
> > device that isn't getting set up, but I really never test this,
> > because
> > when we create the initramfs in RedHat based distros, we edit the
> > multipath.conf file in it to blacklist all devices except those
> > needed
> > by the initramfs.
> =

> I'm a bit puzzled. It's against my personcal conviction that the
> blacklist must be the same between initrd and root FS. How do you
> prevent LVM or other layers grabbing blacklisted devices during
> initramfs processing, so that they can't be multipathed any more later?

lvm only assembles on the devices necessary to boot in the initramfs
also.

-Ben

> =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
