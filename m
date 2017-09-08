From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 4/5] multipath: add alternate reservation_key
	method
Date: Fri, 8 Sep 2017 18:00:17 -0500
Message-ID: <20170908230017.GH3145@octiron.msp.redhat.com>
References: <1504896354-28181-1-git-send-email-bmarzins@redhat.com>
	<1504896354-28181-5-git-send-email-bmarzins@redhat.com>
	<1504906488.4585.31.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1504906488.4585.31.camel@suse.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 08, 2017 at 11:34:48PM +0200, Martin Wilck wrote:
> On Fri, 2017-09-08 at 13:45 -0500, Benjamin Marzinski wrote:
> > The scsi persistent reservation API doesn't force devices to
> > implement
> > any method to display the mapping from a reservation key to an I_T
> > Nexus
> > (the READ_FULL_STATUS action is an optional later addition, and a
> > number
> > of devices don't support it). To allow multipathd to determine the
> > correct reservation key for a device without support from the device
> > itself, it uses the reservation_key configuration option.
> > Unfortunately,
> > using this option forces the multipath configuration to be updated
> > whenever a new scsi registration key is used.  This isn't acceptable
> > to
> > some users, who want a static configuration file.
> > =

> > This patch provides an alternate method of setting the
> > reservation_key
> > for the multipath device. The reservation_key configuration option
> > now
> > also accepts the keyword "file". If this is used, multpath will look
> > in
> > the new prkeys file (by default "/etc/multipath/prkeys") for a line
> > with
> > the device wwid and it's associated reservation_key. Where a device's
> > reservation key comes from is tracked by the prkey_source variable,
> > which is set and read through the reservation_key dict.c functions.
> > =

> > There are also new multipathd commands to get, set, and unset the
> > mappings in the prkesy file. Currently,
> > =

> > "multipathd map $map setprkey key $key" sets the mapping
> > "multipathd map $map unsetprkey" unsets the mapping
> > "multipathd map $map getprkey" gets the current reservation_key for a
> > multipath device.
> > =

> > There is some lack of symmetry here where you are allowed to set and
> > unset mappings even for devices that aren't configured to use the
> > prkeys
> > file, but you will only get the mapping from the prkeys file for
> > devices
> > that are configured to use it. Otherwise you will get the mapping
> > from
> > multipath.conf. In other words, setprkey and unsetprkey return
> > success
> > but don't do anything useful unless a device is configured with
> > =

> > reservation_key file
> > =

> > but getprkey will return the device's current reservation_key
> > regardless
> > of where the key came from.
> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/Makefile     |   2 +-
> >  libmultipath/config.c     |   6 +-
> >  libmultipath/config.h     |   3 +
> >  libmultipath/defaults.h   |   1 +
> >  libmultipath/dict.c       |  67 +++++++++++++++----
> >  libmultipath/dict.h       |   2 +-
> >  libmultipath/prkey.c      | 166
> > ++++++++++++++++++++++++++++++++++++++++++++++
> >  libmultipath/prkey.h      |  19 ++++++
> >  libmultipath/propsel.c    |  31 +++++++--
> >  libmultipath/structs.h    |   7 ++
> >  multipathd/cli.c          |   8 +++
> >  multipathd/cli.h          |   8 +++
> >  multipathd/cli_handlers.c |  82 +++++++++++++++++++++++
> >  multipathd/cli_handlers.h |   3 +
> >  multipathd/main.c         |   3 +
> >  15 files changed, 388 insertions(+), 20 deletions(-)
> >  create mode 100644 libmultipath/prkey.c
> >  create mode 100644 libmultipath/prkey.h
> =

> Looks ok to me. I suppose you tested that parsing code for the key file.
> Reviewed-by: Martin Wilck <mwilck@suse.com>

Yeah. I tested it, both with and without using the prkeys file.
However, I may write up a unit test script for mpathpersist like
test-kpartx, just to allow automated testing of this stuff.

-Ben

> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
