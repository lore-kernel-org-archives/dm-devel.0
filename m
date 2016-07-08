From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] multipathd: fix waiter_attr resource leak
Date: Fri, 8 Jul 2016 14:33:14 -0500
Message-ID: <20160708193314.GJ8095@octiron.msp.redhat.com>
References: <OF23BCA109.0BE2FFED-ON48257FE8.0023BAD2-48257FE8.002CA989@zte.com.cn>
	<CABr-GndMYzjsQrpvi8vNrD9AYUzLO7KmSFOkaOE-Mb4t+O-p5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABr-GndMYzjsQrpvi8vNrD9AYUzLO7KmSFOkaOE-Mb4t+O-p5Q@mail.gmail.com>
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
Cc: zhang.kai16@zte.com.cn, device-mapper development <dm-devel@redhat.com>, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

On Fri, Jul 08, 2016 at 09:59:18AM +0200, Christophe Varoqui wrote:

ACK

-Ben


>    Ben, Hannes, I'd appreciate your ack on this patch.
>    Thanks.
>    On Wed, Jul 6, 2016 at 10:08 AM, <[1]zhang.kai16@zte.com.cn> wrote:
> =

>      As a global variable waiter_attr of thread attribute was set up in t=
he
>      daemon,
>      however,it hasn't been destroyed when the daemon exited.
>      We need deinitialize waiter_attr.
>      =A0
>      ---
>      multipathd/main.c | 3 +++
>      1 file changed, 3 insertions(+)
> =

>      diff --git a/multipathd/main.c b/multipathd/main.c
>      index b86374f..09c5485 100644
>      --- a/multipathd/main.c
>      +++ b/multipathd/main.c
>      @@ -2317,6 +2317,9 @@ child (void * param)
>      =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0conf =3D NULL;
>      =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0udev_unref(udev);
>      =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0udev =3D NULL;
>      +
>      + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pthread_attr_destroy(&waiter_attr);
>      +
>      #ifdef _DEBUG_
>      =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dbg_free_final(NULL);
>      #endif
>      --
>      1.9.1
> =

>  --------------------------------------------------------
>  ZTE Information Security Notice: The information contained in this mail =
(and any attachment transmitted herewith) is privileged and confidential an=
d is intended for the exclusive use of the addressee(s).  If you are not an=
 intended recipient, any disclosure, reproduction, distribution or other di=
ssemination or use of the information contained is strictly prohibited.  If=
 you have received this mail in error, please delete it and notify us immed=
iately.
> =

> =

>      --
>      dm-devel mailing list
>      [2]dm-devel@redhat.com
>      [3]https://www.redhat.com/mailman/listinfo/dm-devel
> =

> References
> =

>    Visible links
>    1. mailto:zhang.kai16@zte.com.cn
>    2. mailto:dm-devel@redhat.com
>    3. https://www.redhat.com/mailman/listinfo/dm-devel

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
