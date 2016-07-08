From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: Subject: [PATCH 1/1] multipath-tools: fix dm- device
 filtering
Date: Fri, 8 Jul 2016 13:05:19 -0500
Message-ID: <20160708180518.GI8095@octiron.msp.redhat.com>
References: <CAAZtj82kfWDjnqLYbqi==BRGukYQXCV=mTR3hmD6XOiD-C3-0Q@mail.gmail.com>
	<CABr-Gnf_=7R7GTnJz_eamQEVtv=aEV7Zx3v2QGDRRj2u5NVuvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABr-Gnf_=7R7GTnJz_eamQEVtv=aEV7Zx3v2QGDRRj2u5NVuvw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Dragan Stancevic <dragan.stancevic@canonical.com>
List-Id: dm-devel.ids

On Fri, Jul 08, 2016 at 08:55:38AM +0200, Christophe Varoqui wrote:

ACK

-Ben

>    Hannes, Ben, do you ack this one ?
>    On Thu, Jun 23, 2016 at 11:06 PM, Dragan Stancevic
>    <[1]dragan.stancevic@canonical.com> wrote:
> =

>      Hi Christophe,
>      can you please take a look at the attached patch, we are seeing quit=
e a
>      few cases with the following errors:
>      failed to get udev uid: Invalid argument
>      failed to get sysfs uid: Invalid argument
>      failed to get sgio uid: No such file or directory
>      It causes a lot of confusion because the devices in question are in =
the
>      blacklist but aren't getting filtered. I don't know the code well
>      enough, but it seems that maybe there should be no condition in the
>      filtering and the code should just be:
>      if (dev && (filter_devnode(conf->blist_devnode, conf->elist_devnode,
>      dev) > 0)) {
>      But I went for smaller change option, by just allowing=A0DEV_UEVENT =
to
>      also be filtered.
>      What do you think?
>      Thanks.
> =

> References
> =

>    Visible links
>    1. mailto:dragan.stancevic@canonical.com

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
