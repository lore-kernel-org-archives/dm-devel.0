From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: [BUG] multipath-tools: uuid has become meaningless
Date: Mon, 16 Aug 2010 15:56:34 -0700
Message-ID: <20100816225634.GA30302@us.ibm.com>
References: <20100719224528.GA23414@us.ibm.com>
	<1279604124.2841.5.camel@Nokia-N900-42-11>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1279604124.2841.5.camel@Nokia-N900-42-11>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Christophe Varoqui [christophe.varoqui@gmail.com] wrote:
>    >
>    > My thoughts on fixing this:
>    > 1. Technically nothing wrong. Live with it and make sure that device
>    >=A0 =A0 =A0  mapper's uuid are meaningless for user and fix 'multipat=
h -l' to
>    >=A0 =A0 =A0  not print uuid's.
> =

>    I don't like this one : the uuid is the communication medium with stor=
age
>    teams in big IT departement.
> =

>    > 2. Don't support user_friendly_names in initrd. Could be just docume=
nted
>    >=A0 =A0 =A0  or an option to multipath is added to ignore that featur=
e and that
>    >=A0 =A0 =A0  option is used in initrd calls!
> =

>    I let distributors comment on this one, but I guess it will replace a
>    confusion (a naming file in initrd the sysadmin have to keep in sync) =
by
>    another (root kparm not consistent with what you see on a booted syste=
m).
>    I personnaly agree that user_friendly_names disabled in initrd would b=
e a
>    safer confuser.
> =

>    > 3. We could rename the devices instead of reload -- really fixing th=
is!
>    >
> =

>    This one seems safe.

Sorry for the delay. I actually found another easier way to fix it!
Looks like the bindings file in initramfs and the active root file
system may not be in *sync* but not *inconsistent*. The problem happens
because the initramfs is mounted read/write, and multipath modifies
bindings file in memory at initramfs time that may become *inconsistent*
with the bindings file in the active root file system. =


The patch in a next mail will add an option to 'multipath' to not update
the bindings file. It will treat it as read-only, so devices that don't
have an entry in the bindings file will get WWID based names.

Thanks, Malahal.
