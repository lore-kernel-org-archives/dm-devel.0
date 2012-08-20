From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH][RESEND] multipath: check if a device belongs
 to multipath
Date: Mon, 20 Aug 2012 19:50:31 +0200
Message-ID: <1345485031.12286.13.camel@lapoo.opensvc.com>
References: <20120727205524.GJ5299@ether.msp.redhat.com>
	<1345234390.12286.9.camel@lapoo.opensvc.com> <50322A59.5080209@suse.de>
	<20120820174301.GV5299@ether.msp.redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120820174301.GV5299@ether.msp.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On lun., 2012-08-20 at 12:43 -0500, Benjamin Marzinski wrote:
> On Mon, Aug 20, 2012 at 02:15:21PM +0200, Hannes Reinecke wrote:
> > On 08/17/2012 10:13 PM, Christophe Varoqui wrote:
> > > On ven., 2012-07-27 at 15:55 -0500, Benjamin Marzinski wrote:
> > >> This patch adds a new multipath option "-c", which checks if a device
> > >> belongs to multipath.  This can be done during the add uevent for the
> > >> device, before the multipath device has even been created.  This allows
> > >> udev to be able to handle multipath path devices differently.  To do
> > >> this multipath now keeps track of the wwids of all previously created
> > >> multipath devices in /etc/multipath/wwids. The file creating and
> > >> editting code from alias.[ch] has been split out into file.[ch]. When a
> > >> device is checked to see if it's a multipath path, it's wwid is
> > >> compared against the ones in the wwids file. Also, since the
> > >> uid_attribute may not have been added to the udev database entry for
> > >> the device if this is called in a udev rule, when using the "-c" option,
> > >> get_uid will now also check the process' envirionment variables for the
> > >> uid_attribute.
> > >>
> > > I'd like other distribution maintainers' comments on this one, as it
> > > impacts the multipath-tools intregration with udev.
> > > 
> > > Hannes ? Did you face the same issue with SuSE ? Did you solve it
> > > differently ?
> > > 
> > No; currently I didn't solve it at all, what with me being tied up
> > with customer issues :-(
> > 
> > But this is basically the approach I've discussed with Harald Hoyer
> > and Kay Sievers on how we should facilitate proper systemd integration.
> > 
> > The idea here is to have a udev rule calling 'multipath -c' via
> > PROGRAM, so that udev can detect if a device should've been handled
> > via multipath.
> > Which would allow any rules following that one to evaluate this
> > status and possibly skip the device.
> > 
> > So from that perspective the patch should be okay.
> > 
> > However, the one thing to note is this patch _again_ is using
> > hard-coded filenames under /etc, which really shouldn't happen.
> > We should be introducing a configuration file variable to set it.
> 
> I'll post a patch that adds a configuration parameter soon.
> 
> > 
> > > Ben, does this approach supersedes/extends the "complicated blacklisting
> > > scheme" you proposed earlier ?
> > > 
> > I sincerely hope so ...
> 
> actually, this is patch is what I though were the non-objectional parts
> to that patch.  I still think it's useful to be able to setup multipath
> so that instead of defaulting to use all the non-blacklisted LUNs, it
> just defaults to using the LUNs which actually have multiple paths. That
> patch didn't effect how the blacklisting code worked. Nor did it keep you
> from setting up multipath on single pathed LUNs. It just didn't default
> to setting up multipath devices on single pathed LUNs, if you had never
> set up a multipath device on that LUN before. 
> 
Ok fine. Do you prefer I merge the already submitted patch so that you
can submit an incremental patch for the cache file location or I wait
for your submitting a feature-complete patch ?

Thanks for the clarification.

cvaroqui,
OpenSVC
