From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: vplex and multipath-tools
Date: Sun, 31 Jul 2016 11:09:43 +0200
Message-ID: <CABr-Gnf46abnFE=d7m2vrPOspGbo9-t84LAniZ2x0UAiYeY5kw@mail.gmail.com>
References: <CABr-GneNEdgredZQo1z92z3bjeP65Jyq63L20UP9ojwXMNESgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5436858881687770275=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GneNEdgredZQo1z92z3bjeP65Jyq63L20UP9ojwXMNESgg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Edward Goggin, EMC" <egoggin@emc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5436858881687770275==
Content-Type: multipart/alternative; boundary=001a114109ce2a51f40538ead821

--001a114109ce2a51f40538ead821
Content-Type: text/plain; charset=UTF-8

I realized the weightedpath prioritizer now has the "wwn" keyword that
makes it fit for the job.

Please disregard my request.

Regards,
Christophe

On Sat, Jul 23, 2016 at 5:46 PM, Christophe Varoqui <
christophe.varoqui@opensvc.com> wrote:

> Hi Ed,
>
> does EMC have a specific prioritizer to select the local head in a vplex
> cross-connect setup ?
>
> If not, would it be useful to develop one ? ... or does a particular setup
> in multipath.conf suffices (not resorting to the weightedpath prioritizer,
> which is not easy to deploy site-wise) ?
>
> If you are no longer the appropriate person to answer, please route me ...
>
> Thanks,
> Christophe Varoqui
>
>

--001a114109ce2a51f40538ead821
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I realized the weightedpath prioritizer now has the &quot;=
wwn&quot; keyword that makes it fit for the job.<div><br></div><div>Please =
disregard my request.</div><div><br></div><div>Regards,</div><div>Christoph=
e</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On S=
at, Jul 23, 2016 at 5:46 PM, Christophe Varoqui <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:christophe.varoqui@opensvc.com" target=3D"_blank">christophe.v=
aroqui@opensvc.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quot=
e" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">=
<div dir=3D"ltr">Hi Ed,<div><br></div><div>does EMC have a specific priorit=
izer to select the local head in a vplex cross-connect setup ?</div><div><b=
r></div><div>If not, would it be useful to develop one ? ... or does a part=
icular setup in multipath.conf suffices (not resorting to the weightedpath =
prioritizer, which is not easy to deploy site-wise) ?</div><div><br></div><=
div>If you are no longer the appropriate person to answer, please route me =
...</div><div><br></div><div>Thanks,</div><div>Christophe Varoqui</div><div=
><br></div></div>
</blockquote></div><br></div>

--001a114109ce2a51f40538ead821--


--===============5436858881687770275==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5436858881687770275==--
