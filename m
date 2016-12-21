From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: deterministic io throughput in multipath
Date: Wed, 21 Dec 2016 10:09:40 -0600
Message-ID: <20161221160940.GG19659@octiron.msp.redhat.com>
References: <1649d4b8538d4b4cb1efacdfe8cf31eb@BRMWP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1649d4b8538d4b4cb1efacdfe8cf31eb@BRMWP-EXMB12.corp.brocade.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Muneendra Kumar M <mmandala@Brocade.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Have you looked into the delay_watch_checks and delay_wait_checks
configuration parameters?  The idea behind them is to minimize the use
of paths that are intermittently failing.

-Ben

On Mon, Dec 19, 2016 at 11:50:36AM +0000, Muneendra Kumar M wrote:
>    Customers using Linux host (mostly RHEL host) using a SAN network for
>    block storage, complain the Linux multipath stack is not resilient to
>    handle non-deterministic storage network behaviors. This has caused ma=
ny
>    customer move away to non-linux based servers. The intent of the below
>    patch and the prevailing issues are given below. With the below design=
 we
>    are seeing the Linux multipath stack becoming resilient to such network
>    issues. We hope by getting this patch accepted will help in more Linux
>    server adoption that use SAN network.
> =

>    I have already sent the design details to the community in a different
>    mail chain and the details are available in the below link.
> =

>    [1]https://www.redhat.com/archives/dm-devel/2016-December/msg00122.htm=
l.
> =

>    Can you please go through the design and send the comments to us. =A0
> =

>    =A0
> =

>    Regards,
> =

>    Muneendra.
> =

>    =A0
> =

>    =A0
> =

> References
> =

>    Visible links
>    1. https://www.redhat.com/archives/dm-devel/2016-December/msg00122.html

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
