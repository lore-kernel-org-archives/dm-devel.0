From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/4] multipath-tools: Ceph rbd support
Date: Fri, 8 Jul 2016 10:15:29 +0200
Message-ID: <CABr-Gnc34cJ9oRB4J=0Rv1jgZ_Cr=uvMHwHAy_49XHGuBy33XQ@mail.gmail.com>
References: <1467706353-16878-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0127965105313055380=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467706353-16878-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <mchristi@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0127965105313055380==
Content-Type: multipart/alternative; boundary=001a11410840df1d7b05371b67c2

--001a11410840df1d7b05371b67c2
Content-Type: text/plain; charset=UTF-8

Hi Mike,

this patchset was broken by the resync with hannes rcu v2 branch.
Can you rebase it in the light of the changes to the conf pointer access
applied in dbd9ad6f0e555707335ec71e1c5bec1723e02f79 ?

Thanks.

On Tue, Jul 5, 2016 at 10:12 AM, Mike Christie <mchristi@redhat.com> wrote:

> The following patches add Ceph rbd support for handling
> blacklisted devices. This does not support features like
> multibus.
>
> My specific use is for exporting rbd images through multiple
> LIO instances. In this case, we have one rbd instance that
> has the exclusive lock and send WRITE requests. If that host
> becomes unreachable, then another host will grab the lock,
> and blacklist the original host to prevent it from sending stale
> IO (when blacklisted IO will be failed by the OSD).
>
> To recover from this, this patchset adds a repair() callout
> to the checker. If the path is in the PATH_DOWN state this
> callout can be used to fix it up. For my case, I am remapping
> the device to flush stale IO and cleanup the old lock,
> and then unblacklisting myself.
>
>
>

--001a11410840df1d7b05371b67c2
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Mike,<div><br></div><div>this patchset was broken by th=
e resync with hannes rcu v2 branch.</div><div>Can you rebase it in the ligh=
t of the changes to the conf pointer access applied in=C2=A0dbd9ad6f0e55570=
7335ec71e1c5bec1723e02f79 ?</div><div><br></div><div>Thanks.</div></div><di=
v class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue, Jul 5, 2016 =
at 10:12 AM, Mike Christie <span dir=3D"ltr">&lt;<a href=3D"mailto:mchristi=
@redhat.com" target=3D"_blank">mchristi@redhat.com</a>&gt;</span> wrote:<br=
><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1=
px #ccc solid;padding-left:1ex">The following patches add Ceph rbd support =
for handling<br>
blacklisted devices. This does not support features like<br>
multibus.<br>
<br>
My specific use is for exporting rbd images through multiple<br>
LIO instances. In this case, we have one rbd instance that<br>
has the exclusive lock and send WRITE requests. If that host<br>
becomes unreachable, then another host will grab the lock,<br>
and blacklist the original host to prevent it from sending stale<br>
IO (when blacklisted IO will be failed by the OSD).<br>
<br>
To recover from this, this patchset adds a repair() callout<br>
to the checker. If the path is in the PATH_DOWN state this<br>
callout can be used to fix it up. For my case, I am remapping<br>
the device to flush stale IO and cleanup the old lock,<br>
and then unblacklisting myself.<br>
<br>
<br>
</blockquote></div><br></div>

--001a11410840df1d7b05371b67c2--


--===============0127965105313055380==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0127965105313055380==--
