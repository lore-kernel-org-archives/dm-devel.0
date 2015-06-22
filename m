From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: multipathd removing DM devices that don't belong to
	it
Date: Mon, 22 Jun 2015 11:04:38 -0500
Message-ID: <20150622160438.GL1409@octiron.msp.redhat.com>
References: <DM2PR11MB0335E7DB799EB58FD218AC62D5A70@DM2PR11MB0335.namprd11.prod.outlook.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <DM2PR11MB0335E7DB799EB58FD218AC62D5A70@DM2PR11MB0335.namprd11.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 16, 2015 at 10:02:23PM +0000, Artem Danielov wrote:
>    Hello,
> =

>    Looking for an advice on whether this is an expected behavior or a bug.
> =

>    device-mapper-multipath-0.4.9-77.el7.x86_64
> =

>    =A0
> =

>    When multipathd service starts it will remove any DM devices with
>    multipath target, even if the underlying devices are blacklisted.
> =

>    We are trying to use dmsetup directly =A0to implement custom multipath
>    management logic separate from multipathd. But unfortunately if multip=
athd
>    is present and enabled it removes DM devices with multipath target tha=
t we
>    create.
> =

>    =A0
> =

>    Is this a bug?

I don't know if I'd call it a bug. It is certainly how multipath is
designed to work.  The issue is this.  When you start multipathd up do a
reconfigure.  It doesn't know if the configuration has changed. So, if
there are devices configured and it doesn't think they should be, it
assumes that you've changed your configuration, and you'd like it to use
your current configuration, which means removing devices that no longer
are allowed.

I don't see any way of making this work, without adding a section to the
multipath.conf file to ignore devices with certain wwids entirely (which
is different from blacklisting them).

-Ben

> =

>    =A0
> =

>    Thanks for your help!
> =

>    =A0
> =

>    Artem Danielov | Chief Technology Officer | FlashGrid Inc. |
>    [1]artem@flashgrid.io | +1-503-568-5249
> =

>    =A0
> =

> References
> =

>    Visible links
>    1. mailto:artem@flashgrid.io

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
