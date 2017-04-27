From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [BUG] multipath-tools: missing internal values
 (multipath -t)
Date: Thu, 27 Apr 2017 16:47:04 -0500
Message-ID: <20170427214704.GW19236@octiron.msp.redhat.com>
References: <5a9ce04c-3996-9f88-1682-822b0d7b9e65@gmail.com>
	<20170425184224.GV19236@octiron.msp.redhat.com>
	<CABr-Gnd_6OnfOGrdyW2SYftoT6V+-V7RAANCBsVncVLgxtEuKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABr-Gnd_6OnfOGrdyW2SYftoT6V+-V7RAANCBsVncVLgxtEuKg@mail.gmail.com>
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

On Thu, Apr 27, 2017 at 09:10:09AM +0200, Christophe Varoqui wrote:
>    Hi,
>    The config outputed should be usable, so a comment could be printed for
>    the keywords you suggest printing <undef> as the default for.
>    Example:
>    #=A0no_path_retry <comment explaining the contextual default behaviour>
>    or simply
>    # no_path_retry <contextual, see man page>

Makes sense.

Thanks
-Ben

>    On Tue, Apr 25, 2017 at 8:42 PM, Benjamin Marzinski
>    <[1]bmarzins@redhat.com> wrote:
> =

>      On Tue, Apr 25, 2017 at 04:26:06PM +0200, Xose Vazquez Perez wrote:
>      > Hi,
>      >
>      > These values:
> =

>      What do you think of these?
>      > no_path_retry
> =

>      The default if no_path_retry is set is to use the features line to
>      determine what to do when there are no paths. we could have it
>      print something like
> =

>      no_path_retry <undef>
> =

>      > dev_loss_tmo
> =

>      The default here is to keep whatever the sysfs value currently is. We
>      could print
> =

>      dev_loss_tmo <undef>
> =

>      or
> =

>      dev_loss_tmo <sysfs>
> =

>      or something else. I'm open to ideas.
> =

>      > reservation_key
> =

>      The default here is nothing
> =

>      reservation_key <undef>
> =

>      probably makes the most sense
> =

>      > partition_delimite
> =

>      The default here is an empty string
> =

>      partition_delm ""
> =

>      is probably the right answer.
> =

>      > delay_watch_checks
>      > delay_wait_checks
> =

>      These clearly have well defined default values and should be set.
> =

>      -Ben
>      > are missing from the "defaults section" of multipath -t output.
>      > --
>      > dm-devel mailing list
>      > [2]dm-devel@redhat.com
>      > [3]https://www.redhat.com/mailman/listinfo/dm-devel
> =

>      --
>      dm-devel mailing list
>      [4]dm-devel@redhat.com
>      [5]https://www.redhat.com/mailman/listinfo/dm-devel
> =

> References
> =

>    Visible links
>    1. mailto:bmarzins@redhat.com
>    2. mailto:dm-devel@redhat.com
>    3. https://www.redhat.com/mailman/listinfo/dm-devel
>    4. mailto:dm-devel@redhat.com
>    5. https://www.redhat.com/mailman/listinfo/dm-devel
