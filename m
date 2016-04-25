From: Peter Volkov <peter.volkov@gmail.com>
Subject: Re: multipath-0.5.0 still provides broken udev rules
Date: Mon, 25 Apr 2016 17:15:52 +0300
Message-ID: <CAE+k_gLwVH86kF+W4yA4m-09AtWT5FSnVMp7zQgeriQ8kxc5Nw@mail.gmail.com>
References: <CAE+k_g+Eh3H1EAiJ0jm7P-efGbOOwpWRtYmvXyR9qhhHtefV7g@mail.gmail.com>
	<571DF852.6030604@redhat.com>
	<CAE+k_gKQcx+QR9bfEp1Wy8BawD14L2G5O0Yw-d0=CffBHqYbrA@mail.gmail.com>
	<571E0E7A.4050703@redhat.com>
	<CABr-GnfxOKz8gxDju20Hx3T9Tn74Zz9FhjF1dBk8weEBJMOmLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6812695830172173415=="
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

--===============6812695830172173415==
Content-Type: multipart/alternative; boundary=001a11469950934daf05314fd1f5

--001a11469950934daf05314fd1f5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 25, 2016 at 3:56 PM, Christophe Varoqui <
christophe.varoqui@opensvc.com> wrote:

> Distributors can't be asked to agree on a common udev ruleset.
>

Of course, there is no pressure on downstream distributor on what
configuration/udev rules should be used. Yet it's always good to have
upstream hand for such things. Lot's of packages
(lvm/systemd/networkmanager/...) come with an upstream suggested udev
rules. Should we avoid use of that udev rules? I don't think so.

Ben, Hannes, Xos=C3=A9, Peter are you ok with my deleting the udev rules ex=
ample
> ?
>

Since these rules are broken it good idea to drop this file to avoid
confusion. Yet it's good idea to document some general ideas of what needs
to be done with udev to setup fully working multipath configuration.

--
Peter.

--001a11469950934daf05314fd1f5
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On M=
on, Apr 25, 2016 at 3:56 PM, Christophe Varoqui <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:christophe.varoqui@opensvc.com" target=3D"_blank">christophe.v=
aroqui@opensvc.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quot=
e" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-colo=
r:rgb(204,204,204);border-left-style:solid;padding-left:1ex"><div>Distribut=
ors can&#39;t be asked to agree on a common udev ruleset.</div></blockquote=
><div><br></div><div>Of course, there is no pressure on downstream distribu=
tor on what configuration/udev rules should be used. Yet it&#39;s always go=
od to have upstream hand for such things. Lot&#39;s of packages (lvm/system=
d/networkmanager/...) come with an upstream suggested udev rules. Should we=
 avoid use of that udev rules? I don&#39;t think so.</div><div><br></div><b=
lockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-le=
ft-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;pad=
ding-left:1ex"><div>Ben, Hannes, Xos=C3=A9, Peter are you ok with my deleti=
ng the udev rules example ?</div><div></div></blockquote></div><br>Since th=
ese rules are broken it good idea to drop this file to avoid confusion. Yet=
 it&#39;s good idea to document some general ideas of what needs to be done=
 with udev to setup fully working multipath configuration.<br clear=3D"all"=
><div><div class=3D"gmail_signature"><br>--<br>Peter.</div></div>
</div></div>

--001a11469950934daf05314fd1f5--


--===============6812695830172173415==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6812695830172173415==--
