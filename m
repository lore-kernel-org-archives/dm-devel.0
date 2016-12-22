From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: Re: deterministic io throughput in multipath
Date: Thu, 22 Dec 2016 05:39:36 +0000
Message-ID: <0df0f2cc11584ced9242a57b6457fa5d@BRMWP-EXMB12.corp.brocade.com>
References: <1649d4b8538d4b4cb1efacdfe8cf31eb@BRMWP-EXMB12.corp.brocade.com>
	<20161221160940.GG19659@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161221160940.GG19659@octiron.msp.redhat.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Ben,

Thanks for the reply.
I will look into this parameters will do the internal testing and let you k=
now the results.

Regards,
Muneendra.

-----Original Message-----
From: Benjamin Marzinski [mailto:bmarzins@redhat.com] =

Sent: Wednesday, December 21, 2016 9:40 PM
To: Muneendra Kumar M <mmandala@Brocade.com>
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] deterministic io throughput in multipath

Have you looked into the delay_watch_checks and delay_wait_checks configura=
tion parameters?  The idea behind them is to minimize the use of paths that=
 are intermittently failing.

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

>    [1]https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.c=
om_archives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=3DDgIDAw&c=3DIL_XqQW=
OjubgfqINi2jTzg&r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3DvfwpVp6=
e1KXtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo_Uj7MRu=
52hG3MKzM&e=3D .
> =

>    Can you please go through the design and send the comments to us.
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
>    1. =

> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.com_ar
> chives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=3DDgIDAw&c=3DIL_XqQWOjub
> gfqINi2jTzg&r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3DvfwpVp6e1K
> XtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo_Uj7MRu
> 52hG3MKzM&e=3D

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.com_ma
> ilman_listinfo_dm-2Ddevel&d=3DDgIDAw&c=3DIL_XqQWOjubgfqINi2jTzg&r=3DE3ftc=
47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3DvfwpVp6e1KXtRA0ctwHYJ7cDmPsLi2C1=
L9pox7uexsY&s=3DUyE46dXOrNTbPz_TVGtpoHl3J3h_n0uYhI4TI-PgyWg&e=3D
