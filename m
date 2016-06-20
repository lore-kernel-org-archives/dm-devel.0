From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: Missing patches
Date: Mon, 20 Jun 2016 13:35:04 +0200
Message-ID: <CABr-Gndm2Mm1wfrmviHLdcaz0_X9o+k062Ggf4rg6w=6PDOXaA@mail.gmail.com>
References: <CABr-GncjECgjZp6aXEYLtn8UPu5pCFiw9asNaSWaZO4WGB+KVw@mail.gmail.com>
	<231be53b-9202-0232-5eb8-7763d33c82a8@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8640871675636649197=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <231be53b-9202-0232-5eb8-7763d33c82a8@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8640871675636649197==
Content-Type: multipart/alternative; boundary=001a114b157487075f0535b418cb

--001a114b157487075f0535b418cb
Content-Type: text/plain; charset=UTF-8

Thanks, I really missing the Apple controller family patch.

For "replace spaces with tabs in defaults.h" I was deferring, in doubt :
seems to be a coding style issue. Is the tabbed format agreed on with other
maintainers ? I wouldn't want to go in a patch-revert loop over this ;)

I deferred the RDAC border patch, waiting for responses to you RFC. The
one-liner "border" patch will be folded into the real patch resulting from
the argument.

Thanks,
Christophe



On Mon, Jun 20, 2016 at 1:06 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> On 06/20/2016 09:35 AM, Christophe Varoqui wrote:
>
> > I went through the patch backlog since June 4th and merged your work.
>
> These three are missing:
> https://patchwork.kernel.org/project/dm-devel/list/?submitter=3680
>
> - "[1/2] multipath-tools: replace spaces with tabs in defaults.h"
> - "multipath-tools: fix up Apple controller family"
> - "multipath-tools: RDAC border", this was more a RFC than a real patch.
>
> And "[06/10] multipath-tools: new email address for Srinivas Ramani"
> was applied, and it was waiting ACK from Srinivas. But it's up to you.
>
> I thought you were using patchwork to handle your queue.
>

--001a114b157487075f0535b418cb
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks, I really missing the Apple controller family patch=
.<div><br></div><div>For &quot;<span style=3D"font-size:19.2px">replace spa=
ces with tabs in defaults.h</span>&quot; I was deferring, in doubt : seems =
to be a coding style issue. Is the tabbed format agreed on with other maint=
ainers ? I wouldn&#39;t want to go in a patch-revert loop over this ;)</div=
><div><br></div><div>I deferred the RDAC border patch, waiting for response=
s to you RFC. The one-liner &quot;border&quot; patch will be folded into th=
e real patch resulting from the argument.</div><div><br></div><div>Thanks,<=
/div><div>Christophe</div><div><br></div><div><br></div></div><div class=3D=
"gmail_extra"><br><div class=3D"gmail_quote">On Mon, Jun 20, 2016 at 1:06 P=
M, Xose Vazquez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@=
gmail.com" target=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<b=
r><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:=
1px #ccc solid;padding-left:1ex">On 06/20/2016 09:35 AM, Christophe Varoqui=
 wrote:<br>
<br>
&gt; I went through the patch backlog since June 4th and merged your work.<=
br>
<br>
These three are missing:<br>
<a href=3D"https://patchwork.kernel.org/project/dm-devel/list/?submitter=3D=
3680" rel=3D"noreferrer" target=3D"_blank">https://patchwork.kernel.org/pro=
ject/dm-devel/list/?submitter=3D3680</a><br>
<br>
- &quot;[1/2] multipath-tools: replace spaces with tabs in defaults.h&quot;=
<br>
- &quot;multipath-tools: fix up Apple controller family&quot;<br>
- &quot;multipath-tools: RDAC border&quot;, this was more a RFC than a real=
 patch.<br>
<br>
And &quot;[06/10] multipath-tools: new email address for Srinivas Ramani&qu=
ot;<br>
was applied, and it was waiting ACK from Srinivas. But it&#39;s up to you.<=
br>
<br>
I thought you were using patchwork to handle your queue.<br>
</blockquote></div><br></div>

--001a114b157487075f0535b418cb--


--===============8640871675636649197==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8640871675636649197==--
