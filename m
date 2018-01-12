From: Julian Andres Klode <julian.klode@canonical.com>
Subject: Re: multipath-tools 0.7.4 failure to remove device
Date: Fri, 12 Jan 2018 23:26:36 +0100
Message-ID: <20180112222636.ndvpaax7g2h5wmne@jak-x230>
References: <20180112083833.apsybil4ux4d2y32@jak-x230>
	<1515789339.3409.33.camel@suse.com>
	<20180112214700.ljxlypo5nar6oh3m@jak-x230>
	<1515795481.9139.8.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1515795481.9139.8.camel@suse.com>
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

On Fri, Jan 12, 2018 at 11:18:01PM +0100, Martin Wilck wrote:
> On Fri, 2018-01-12 at 22:47 +0100, Julian Andres Klode wrote:
> > 
> > I don't know actually, I'm just updating the package :) 
> 
> The feature needs to be enabled explicitly, so indeed you weren't using
> it.
> 
> > >I can say that
> > the tests were run with default configuration, normally we run with
> > DEFAULT_FIND_MULTIPATHS but that does not work yet with 0.7.4 - no
> > dm-0 device seems to get created in this test case (some systems
> > without
> > multipath were broken 2.5 years ago just by installing it because it
> > took over non-multipath devices, hence the option was enabled; might
> > not even be needed anymore).
> 
> That's still the default behavior if find_multipaths is off. And
> actually, I don't know what's wrong with that. If you don't like it,
> blacklist your root device. All you need to make sure is that multipath
> settings in the initrd and in the booted system are the same.
> 
> "find_multipaths" is not a silver bullet to kill off multipath-related
> boot problems. It has advantages and disadvantages, depending on the
> use case. Anyway, I'm not aware of general problems with it in the
> later multipath versions.

I'll try to give it a bisect since the test works in 0.6.4 and not in
0.7.4. It's going to be painful :)

> 
> Btw, one thing you should be aware of is that udev rule files and
> systemd service files have changed. That requires also dracut changes
> that are not in upstream dracut yet.

We don't use dracut, we use initramfs-tools, but yes, I have to update
the hooks for that too.

-- 
debian developer - deb.li/jak | jak-linux.org - free software dev
ubuntu core developer                              i speak de, en
