From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 0/6] Delete attributes with default values
Date: Wed, 13 Jul 2016 11:17:34 -0500
Message-ID: <20160713161734.GN8095@octiron.msp.redhat.com>
References: <1468022328-5905-1-git-send-email-xose.vazquez@gmail.com>
	<CABr-GncP-rzeXogT1EFZTtFrre2UUSV6i-AJ27GZ3mTvcxx-7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABr-GncP-rzeXogT1EFZTtFrre2UUSV6i-AJ27GZ3mTvcxx-7Q@mail.gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On Sat, Jul 09, 2016 at 10:17:05AM +0200, Christophe Varoqui wrote:
>    I'll wait for comments from distribution maintainers on this patchset.
>    Because, though we have already deleted the checker_name settings when
>    equal to the default value, it should be clear that with this patchset
>    changing a default may cause re-certification for all impacted devices.
>    This can be viewed as a problem for distributors.
>    Hannes, Ben, do you ack this patchset ? If not, what do we do the
>    checker_name settings, that I understood Hannes wanted to switch to TUR
>    anyway.

I'm fine with this.

-Ben

>    On Sat, Jul 9, 2016 at 1:58 AM, Xose Vazquez Perez
>    <[1]xose.vazquez@gmail.com> wrote:
> =

>      Xose Vazquez Perez (6):
>      =A0 multipath-tools: delete attributes with DEFAULT_* values in hwta=
ble.c
>      =A0 multipath-tools: delete prio_args attribute when it is equal to
>      default value
>      =A0 multipath-tools: delete no_path_retry attribute when it is equal=
 to
>      default value
>      =A0 multipath-tools: delete minio_rq attribute when it is equal to d=
efault
>      value
>      =A0 multipath-tools: delete fast_io_fail attribute when it is equal =
to
>      default value
>      =A0 multipath-tools: delete pgpolicy attribute when it is equal to d=
efault
>      value
> =

>      =A0libmultipath/hwtable.c | 226
>      -------------------------------------------------
>      =A01 file changed, 226 deletions(-)
> =

>      Cc: Christophe Varoqui <[2]christophe.varoqui@opensvc.com>
>      Cc: device-mapper development <[3]dm-devel@redhat.com>
>      Signed-off-by: Xose Vazquez Perez <[4]xose.vazquez@gmail.com>
> =

>      --
>      2.7.4
> =

> References
> =

>    Visible links
>    1. mailto:xose.vazquez@gmail.com
>    2. mailto:christophe.varoqui@opensvc.com
>    3. mailto:dm-devel@redhat.com
>    4. mailto:xose.vazquez@gmail.com

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
