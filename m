From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: multipath-0.5.0 still provides broken udev rules
Date: Mon, 25 Apr 2016 12:38:38 -0500
Message-ID: <20160425173838.GE26117@octiron.msp.redhat.com>
References: <CAE+k_g+Eh3H1EAiJ0jm7P-efGbOOwpWRtYmvXyR9qhhHtefV7g@mail.gmail.com>
	<571DF852.6030604@redhat.com>
	<CAE+k_gKQcx+QR9bfEp1Wy8BawD14L2G5O0Yw-d0=CffBHqYbrA@mail.gmail.com>
	<571E0E7A.4050703@redhat.com>
	<CABr-GnfxOKz8gxDju20Hx3T9Tn74Zz9FhjF1dBk8weEBJMOmLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABr-GnfxOKz8gxDju20Hx3T9Tn74Zz9FhjF1dBk8weEBJMOmLg@mail.gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Peter Volkov <peter.volkov@gmail.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Mon, Apr 25, 2016 at 02:56:35PM +0200, Christophe Varoqui wrote:
>    Hi,
>    Those example udev rules are indeed unmaintained and should be removed=
 not
>    to confuse distributors.
>    Distributors can't be asked to agree on a common udev ruleset. Ben,
>    Hannes, Xos=E9, Peter are you ok with my deleting the udev rules examp=
le ?

I am personally fine with kpartx.rules being deleted. Red Hat doesn't
package it.

-Ben

>    Best regards,
>    On Mon, Apr 25, 2016 at 2:32 PM, Zdenek Kabelac <[1]zkabelac@redhat.co=
m>
>    wrote:
> =

>      On 25.4.2016 14:10, Peter Volkov wrote:
> =

>        On Mon, Apr 25, 2016 at 1:58 PM, Zdenek Kabelac
>        <[2]zkabelac@redhat.com
>        <mailto:[3]zkabelac@redhat.com>> wrote:
> =

>        =A0 =A0 On 25.4.2016 12:52, Peter Volkov wrote:
> =

>        =A0 =A0 =A0 =A0 There is a problem: udev does not create partition=
s for
>        multipath
>        =A0 =A0 =A0 =A0 devices in
>        =A0 =A0 =A0 =A0 case I use kpartx.rules provided with multipath so=
urces. I
>        found that udev
>        =A0 =A0 =A0 =A0 always go to kpartx_end after following line of ru=
les:
>        =A0 =A0 =A0 =A0 ENV{DM_TABLE_STATE}!=3D"LIVE", GOTO=3D"kpartx_end"
> =

>        =A0 =A0 Just curious - what would you want to do with inactive tab=
le???
> =

>        Actually don't understand what's this table and what's wrong with
>        that. There
>        is no traces of DM_TABLE_STATE variable in lvm2 sources. Yet there=
 is
>        such
>        variable in udev rules file that comes with multipath sources:
>        [4]http://git.opensvc.com/gitweb.cgi?p=3Dmultipath-tools/.git;a=3D=
blob;f=3Dkpartx/kpartx.rules;h=3D022361f907e873ac16fc75459b88af34b27576e5;h=
b=3DHEAD
> =

>      So you would need to figure out which rules would have set=A0
>      DM_TABLE_STATE before ?=A0 (I assume such have never existed...)
> =

>      In Fedora/RHEL=A0 these=A0 kpartx.rules are not packaged as they are=
 likely
>      some 'ancient' rules - IMHO=A0 most of that file is useless on today=
's
>      distros.
>      (Unsure about dm-wwn logic???)
> =

>      So it's rather question for upstream kpartx maintainer why these rul=
es
>      are not maintained in any way.
> =

>      Vars like DM_TABLE_STATE are simply not created by dm rules.
> =

>      kpartx rules comes from year 2007, while dm rules started to be
>      maintained in 2009 - that may explain few things as well...
> =

>        That's Gentoo. But I think any distro that uses whatever upstream
>        prepares
>        have this problem.
> =

>        =A0 =A0 Have you opened any bugzilla anywhere ?
> =

>        Not yet. I'd like to understand what needs to be done first.
> =

>      Likely Gentoo should not install obsoleted udev rules file.
> =

>      Regards
> =

>      Zdenek
>      PS: I could be wrong here - since I've nothing in common with multip=
ath,
>      so in such case - feel free to correct me....
> =

>      --
>      dm-devel mailing list
>      [5]dm-devel@redhat.com
>      [6]https://www.redhat.com/mailman/listinfo/dm-devel
> =

> References
> =

>    Visible links
>    1. mailto:zkabelac@redhat.com
>    2. mailto:zkabelac@redhat.com
>    3. mailto:zkabelac@redhat.com
>    4. http://git.opensvc.com/gitweb.cgi?p=3Dmultipath-tools/.git;a=3Dblob=
;f=3Dkpartx/kpartx.rules;h=3D022361f907e873ac16fc75459b88af34b27576e5;hb=3D=
HEAD
>    5. mailto:dm-devel@redhat.com
>    6. https://www.redhat.com/mailman/listinfo/dm-devel

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
