From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 5/5] multipath-tools: hwtable housekeeping
Date: Mon, 1 Aug 2016 08:55:39 +0200
Message-ID: <CABr-GncVdtP5P0+Wu3ed+M22SBpUHhEH7Pd+YWo3=6ZKcA1Kfw@mail.gmail.com>
References: <1469233752-11708-1-git-send-email-xose.vazquez@gmail.com>
	<1469233752-11708-5-git-send-email-xose.vazquez@gmail.com>
	<CABr-Gnfo1zGZRJSnd=gBKFFpww2f_GOdMk2t-Gx_rxybD3C=rw@mail.gmail.com>
	<cb83cdfc-e721-7477-8722-716c445f6b55@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4469798692661949204=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cb83cdfc-e721-7477-8722-716c445f6b55@gmail.com>
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

--===============4469798692661949204==
Content-Type: multipart/alternative; boundary=001a11402e649885580538fd162e

--001a11402e649885580538fd162e
Content-Type: text/plain; charset=UTF-8

Yes, I'll take care of the revert to "failover" as the default path
grouping policy.
Indeed, you can postpone your pending patch rebasing to this incoming
commit.

The website update is done.

Thanks,
Christophe.

On Sun, Jul 31, 2016 at 11:59 PM, Xose Vazquez Perez <xose.vazquez@gmail.com
> wrote:

> On 07/31/2016 10:55 AM, Christophe Varoqui wrote:
>
> > The "change default failback from manual to immediate" patch is
> > reverted, as requested by Hannes.
>
> Hannes asked also to revert: 1234de2486211995be3193205387c08c6f682f91
> "change default path_grouping_policy from failover to group_by_prio"
>
>
> And a minimalist request, could you remove just this link from the
> front-page? :
>
> http://christophe.varoqui.free.fr/multipath-tools/multipath-tools-0.5.0.tar.bz2
> Some distributions are monitoring upstream projects to detect new
> releases. And they are getting outdated/wrong information.
>
> Thank you.
>

--001a11402e649885580538fd162e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Yes, I&#39;ll take care of the revert to &quot;failover&qu=
ot; as the default path grouping policy.<div>Indeed, you can postpone your =
pending patch rebasing to this incoming commit.</div><div><br></div><div>Th=
e website update is done.</div><div><br></div><div>Thanks,</div><div>Christ=
ophe.</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">=
On Sun, Jul 31, 2016 at 11:59 PM, Xose Vazquez Perez <span dir=3D"ltr">&lt;=
<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xose.vazquez@gm=
ail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=
=3D"">On 07/31/2016 10:55 AM, Christophe Varoqui wrote:<br>
<br>
&gt; The &quot;change default failback from manual to immediate&quot; patch=
 is<br>
&gt; reverted, as requested by Hannes.<br>
<br>
</span>Hannes asked also to revert: 1234de2486211995be3193205387c08c6f682f9=
1<br>
&quot;change default path_grouping_policy from failover to group_by_prio&qu=
ot;<br>
<br>
<br>
And a minimalist request, could you remove just this link from the front-pa=
ge? :<br>
<a href=3D"http://christophe.varoqui.free.fr/multipath-tools/multipath-tool=
s-0.5.0.tar.bz2" rel=3D"noreferrer" target=3D"_blank">http://christophe.var=
oqui.free.fr/multipath-tools/multipath-tools-0.5.0.tar.bz2</a><br>
Some distributions are monitoring upstream projects to detect new<br>
releases. And they are getting outdated/wrong information.<br>
<br>
Thank you.<br>
</blockquote></div><br></div>

--001a11402e649885580538fd162e--


--===============4469798692661949204==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4469798692661949204==--
