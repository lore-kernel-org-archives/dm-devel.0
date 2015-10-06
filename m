From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] kpartx: use inode to identify loopback mounts
Date: Tue, 6 Oct 2015 09:14:21 +0200
Message-ID: <CABr-Gne3vN8zFY2Sb+h1hw=GRG6pNeLHGmnns3BcAWyTATYVrQ@mail.gmail.com>
References: <559A6D0B.5090602@f-secure.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4667451692980834284=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <559A6D0B.5090602@f-secure.com>
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
Cc: Risto Kankkunen <Risto.Kankkunen@f-secure.com>
List-Id: dm-devel.ids

--===============4667451692980834284==
Content-Type: multipart/alternative; boundary=001a1140209000287c05216a61b2

--001a1140209000287c05216a61b2
Content-Type: text/plain; charset=UTF-8

Applied, finally.
Thanks.

On Mon, Jul 6, 2015 at 1:56 PM, Risto Kankkunen <
risto.kankkunen@f-secure.com> wrote:

> This is a patch which I submitted to Launchpad (
> https://bugs.launchpad.net/ubuntu/+source/multipath-tools/+bug/1469143).
> I was told to submit it to this list instead.
>
> Currently kpartx doesn't work correctly with relative path names,
> hardlinks, symlinks or paths longer than 63 characters. This is because it
> tries to identify mounts by a non-unique name it gives to the mount. The
> loopinfo struct contains the device and inode information of the backing
> image, it is better to identify mounts by those.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a1140209000287c05216a61b2
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied, finally.<div>Thanks.</div></div><div class=3D"gma=
il_extra"><br><div class=3D"gmail_quote">On Mon, Jul 6, 2015 at 1:56 PM, Ri=
sto Kankkunen <span dir=3D"ltr">&lt;<a href=3D"mailto:risto.kankkunen@f-sec=
ure.com" target=3D"_blank">risto.kankkunen@f-secure.com</a>&gt;</span> wrot=
e:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-l=
eft:1px #ccc solid;padding-left:1ex">This is a patch which I submitted to L=
aunchpad (<a href=3D"https://bugs.launchpad.net/ubuntu/+source/multipath-to=
ols/+bug/1469143" rel=3D"noreferrer" target=3D"_blank">https://bugs.launchp=
ad.net/ubuntu/+source/multipath-tools/+bug/1469143</a>). I was told to subm=
it it to this list instead.<br>
<br>
Currently kpartx doesn&#39;t work correctly with relative path names, hardl=
inks, symlinks or paths longer than 63 characters. This is because it tries=
 to identify mounts by a non-unique name it gives to the mount. The loopinf=
o struct contains the device and inode information of the backing image, it=
 is better to identify mounts by those.<br>
<br>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br></blockquote></div><br></div>

--001a1140209000287c05216a61b2--


--===============4667451692980834284==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4667451692980834284==--
