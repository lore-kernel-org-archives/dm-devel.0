From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 09/10] add disable_changed_wwids option
Date: Fri, 4 Nov 2016 10:32:40 -0500
Message-ID: <20161104153240.GF1972@octiron.msp.redhat.com>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
	<1477709726-5442-10-git-send-email-bmarzins@redhat.com>
	<55d8a18c-5c35-5d84-3b4a-557075aaa69d@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <55d8a18c-5c35-5d84-3b4a-557075aaa69d@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Oct 30, 2016 at 02:54:14PM +0100, Hannes Reinecke wrote:
> On 10/29/2016 04:55 AM, Benjamin Marzinski wrote:
> >If a LUN on a storage device gets remapped while in-use by multipath,
> >it's possible that the multipath device will continue writing to this
> >new LUN, causing corruption.  This is not multipath's fault (users
> >should go remapping in-use LUNs), but it's possible for multipath to
> >detect this and disable IO to the device. If disable_changed_wwids
> >is set to "yes", multipathd will detect when a LUN changes wwids when it
> >receives the uevent for this, and will disable access to the device
> >until the LUN is mapped back.
> >
> >Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >---
> > libmultipath/config.c    |  1 +
> > libmultipath/config.h    |  1 +
> > libmultipath/defaults.h  |  1 +
> > libmultipath/dict.c      |  4 ++++
> > libmultipath/discovery.c | 15 +++++++--------
> > libmultipath/discovery.h |  1 +
> > libmultipath/structs.h   |  1 +
> > multipathd/main.c        | 32 ++++++++++++++++++++++++++++++++
> > 8 files changed, 48 insertions(+), 8 deletions(-)
> >
> Hmm. Not sure if the really buys us anything. By the time we process the
> uevent it might already be too late, and I/O might already have been writ=
ten
> to that device.
> I do agree on the warning, though.

I have taken some pains to try to explain this short-coming to the
customer who filed this bugzilla. The good news is that in practice, the
device ususally goes down when you are remapping the LUN, and you
disable the device before it ever comes back.  In my testing, I wasn't
able to actually ever write to the wrong device with
disable_changed_wwids enabled, but I do agree that you have the
potential to race here.

-Ben

> =

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
