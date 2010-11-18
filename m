From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath: add find_multipaths feature.
Date: Thu, 18 Nov 2010 11:21:09 -0600
Message-ID: <20101118172109.GY13763@ether.msp.redhat.com>
References: <20101116232546.GU13763@ether.msp.redhat.com>
	<1289951475.3861.6.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1289951475.3861.6.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 17, 2010 at 12:51:15AM +0100, Christophe Varoqui wrote:
> On mar., 2010-11-16 at 17:25 -0600, Benjamin Marzinski wrote:
> > This adds a new default feature, find_multipaths. When this is set to yes,
> > multipath will no longer try to create multipath devices using every
> > non-blacklisted device. Instead, it will only create a device when one of
> > three conditions are met.
> > 
> > 1. Three are at least two non-blacklisted paths with the same wwid
> > 2. The user manually forces the creation, by specifying a device with the
> >    multipath command.
> > 3. A path has the same wwid as a multipath device that was previously crreated
> >    (even if that multipath device doesn't currently exist).
> 
> I'm confused. A blacklist/whitelist system may be hard to configure
> properly but the rules are simple. I fear this new rule set will
> increase confusion.
> 
> Could you elaborate on what problems this new rule set is trying to
> address ?

The request was to have multipath do the right thing by default for the
common setups, without needing anyone to edit the config file by hand
(which is frequently done wrong). In this case, if you have a
multipath.conf file that just sets find_multipaths, multipath will
automatically create multipath devices for all the LUNs that have
multiple paths, and (assuming they use the right storage devices)
autoconfigure them correctly.  Users only need to use the blacklist if
they have a LUN with multiple paths to it, but don't want in multipathed
for some reason.

Condition 1 takes care of the common case, where multipath notices that
two devices are just paths to the same LUN, and creates a multipath
device.

Condition 2 is mostly for testing.

Condition 3 means that after a multipath device has been created once, in
the future, it will be created right away, even if only one path is
currently active.

There's an added benefit in keeping the list of multipathed wwids.  I'll
shortly be sending a patch that adds a multipath option to check if a
path belongs to a multipath device, which it does by checking this file.
This allows things like udev to find out as soon as a path appears that
it will be multipathed, which lets us avoid races where something else
opens the device before multipathd can.

-Ben
> 
> Best regards,
> -- 
> Christophe Varoqui <christophe.varoqui@opensvc.com>
> OpenSVC
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
