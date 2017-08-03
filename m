From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v4 00/11] multipath-tools:
 no_path_retry/queue_if_no_path/hwhandler logic
Date: Thu, 3 Aug 2017 08:36:10 +0200
Message-ID: <CABr-Gnd17UcGvSxAOR-s8YqNU3+3tNqGe6JzaxBEewWF0VLBbg@mail.gmail.com>
References: <20170622145913.23714-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3177314558516719407=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170622145913.23714-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

--===============3177314558516719407==
Content-Type: multipart/alternative; boundary="001a113ca11aa5421f0555d39822"

--001a113ca11aa5421f0555d39822
Content-Type: text/plain; charset="UTF-8"

Patch 1 to 9 are now merged.


On Thu, Jun 22, 2017 at 4:59 PM, Martin Wilck <mwilck@suse.com> wrote:

> This patch set attempts to sanitize the logic used for consistently
> handling
> options that can be set both via the "features" string and explicit
> multipath.conf
> options. This is most prominently "no_path_retry" vs. "queue_if_no_path",
> but also
> "retain_attached_hw_handler" vs. the feature of the same name.
>
> The logic this patch set follows is:
>  - If "no_path_retry" is set to any value, "queue_if_no_path" is ignored
>    (this is the case nowadays for almost all "real" storage arrays, thanks
> to hwtable).
>  - Otherwise, if "queue_if_no_path" is set, treat it like "no_path_retry
> queue".
>
> ... likewise for "retain_attached_hw_handler".
>
> In the long run, we should get rid of the "features" settings duplicating
> configuration options altogether; the patch set prepares this by printing
> warning messages.
>
> The logic is implemented in the new function reconcile_features_with_
> options,
> which is called from both select_features() and merge_hwe(). In
> setup_map(),
> we need to call select_features() after select_no_path_retry() to make
> this work.
> The actual feature setting for device-mapper is made in assemble_map(), the
> patch set also fixes the logic there.
>
> The patch set documents the behavior in the man page, and adds some more
> man page fixes.
>
> By skipping superfluous default initializations in load_config(), the
> log messages for the respective config settings become more appropriate.
>
> The logic for setting hardware handler is also improved. Since kernel 4.3,
> "retain_attached_hw_handler yes" is implicitly set by the kernel, and
> setting
> the hardware handler from user space is only possible in special
> situations.
> Acknowledge that in multipathd, and don't try to set or unset either this
> feature or the hwhandler attribute itself if it's doomed to fail.
>
> Review and comments are highly welcome.
>
> Changes wrt v1:
>   - Suggestions from Ben Marzinski:
>     * Made sure "multipathd show config" still works (1/8).
>     * Fixed logging for default setting of "max_sectors" (1/8)
>     * Consistent internal treatment of mp->features (3/8, 4/8)
>     * Fixed whitespace error (6/8)
>     * Added deprecated warnings (8/8)
>   - Made sure the same logic is used in propsel.c and config.c by
>     calling the same function (3/8, 4/8)
>   - Added deprecated warnings (8/8)
>
> Changes wrt v2:
>  - Added Acked-by:/Reviewed-by: tags
>  - 1/11: clarify comment in select_max_sectors_kb (Hannes Reinecke)
>  - 3/11: call select_retain_hwhandler before select_features
>  - 8/11: don't suggest using retain_attached_hw_handler in log msg
>  - 9/11, 10/11, 11/11: new
>
> Changes wrt v3:
>  - Added Reviewed-by: tags (kept Ben's Ack in 4/11 although patch slightly
> changed)
>  - 4/11: use a buffer on stack rather than malloc (Hannes Reinecke)
>  - 10/11: Simplify by checking dh_state only in select_handler (Hannes
> Reinecke)
>
> Martin Wilck (11):
>   libmultipath: load_config: skip setting unnecessary defaults
>   libmultipath: add/remove_feature: use const char* for feature
>   libmultipath: clarify option conflicts for "features"
>   libmultipath: merge_hwe: fix queue_if_no_path logic
>   libmultipath: assemble_map: fix queue_if_no_path logic
>   multipath.conf.5: document no_path_retry vs. queue_if_no_path
>   multipath.conf.5: Remove ??? and other minor fixes
>   libmultipath: add deprecated warning for some features settings
>   libmultipath: retain_attached_hw_handler obsolete with 4.3+
>   libmultipath: don't try to set hwhandler if it is retained
>   libmultipath: don't [un]set queue_if_no_path after domap
>
>  libmultipath/config.c      |  31 +++---------
>  libmultipath/configure.c   |  28 ++++-------
>  libmultipath/dict.c        |  11 +++--
>  libmultipath/dmparser.c    |   8 +--
>  libmultipath/propsel.c     | 121 ++++++++++++++++++++++++++++++
> +++++++++------
>  libmultipath/propsel.h     |   3 ++
>  libmultipath/structs.c     |  30 +++++------
>  libmultipath/structs.h     |   4 +-
>  libmultipath/util.c        |  36 ++++++++++++++
>  libmultipath/util.h        |   2 +
>  multipath/multipath.conf.5 |  67 +++++++++++++++----------
>  11 files changed, 231 insertions(+), 110 deletions(-)
>
> --
> 2.13.1
>
>

--001a113ca11aa5421f0555d39822
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Patch 1 to 9 are now merged.<div><br></div></div><div clas=
s=3D"gmail_extra"><br><div class=3D"gmail_quote">On Thu, Jun 22, 2017 at 4:=
59 PM, Martin Wilck <span dir=3D"ltr">&lt;<a href=3D"mailto:mwilck@suse.com=
" target=3D"_blank">mwilck@suse.com</a>&gt;</span> wrote:<br><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;p=
adding-left:1ex">This patch set attempts to sanitize the logic used for con=
sistently handling<br>
options that can be set both via the &quot;features&quot; string and explic=
it multipath.conf<br>
options. This is most prominently &quot;no_path_retry&quot; vs. &quot;queue=
_if_no_path&quot;, but also<br>
&quot;retain_attached_hw_handler&quot; vs. the feature of the same name.<br=
>
<br>
The logic this patch set follows is:<br>
=C2=A0- If &quot;no_path_retry&quot; is set to any value, &quot;queue_if_no=
_path&quot; is ignored<br>
=C2=A0 =C2=A0(this is the case nowadays for almost all &quot;real&quot; sto=
rage arrays, thanks to hwtable).<br>
=C2=A0- Otherwise, if &quot;queue_if_no_path&quot; is set, treat it like &q=
uot;no_path_retry queue&quot;.<br>
<br>
... likewise for &quot;retain_attached_hw_handler&quot;.<br>
<br>
In the long run, we should get rid of the &quot;features&quot; settings dup=
licating<br>
configuration options altogether; the patch set prepares this by printing<b=
r>
warning messages.<br>
<br>
The logic is implemented in the new function reconcile_features_with_<wbr>o=
ptions,<br>
which is called from both select_features() and merge_hwe(). In setup_map()=
,<br>
we need to call select_features() after select_no_path_retry() to make this=
 work.<br>
The actual feature setting for device-mapper is made in assemble_map(), the=
<br>
patch set also fixes the logic there.<br>
<br>
The patch set documents the behavior in the man page, and adds some more<br=
>
man page fixes.<br>
<br>
By skipping superfluous default initializations in load_config(), the<br>
log messages for the respective config settings become more appropriate.<br=
>
<br>
The logic for setting hardware handler is also improved. Since kernel 4.3,<=
br>
&quot;retain_attached_hw_handler yes&quot; is implicitly set by the kernel,=
 and setting<br>
the hardware handler from user space is only possible in special situations=
.<br>
Acknowledge that in multipathd, and don&#39;t try to set or unset either th=
is<br>
feature or the hwhandler attribute itself if it&#39;s doomed to fail.<br>
<br>
Review and comments are highly welcome.<br>
<br>
Changes wrt v1:<br>
=C2=A0 - Suggestions from Ben Marzinski:<br>
=C2=A0 =C2=A0 * Made sure &quot;multipathd show config&quot; still works (1=
/8).<br>
=C2=A0 =C2=A0 * Fixed logging for default setting of &quot;max_sectors&quot=
; (1/8)<br>
=C2=A0 =C2=A0 * Consistent internal treatment of mp-&gt;features (3/8, 4/8)=
<br>
=C2=A0 =C2=A0 * Fixed whitespace error (6/8)<br>
=C2=A0 =C2=A0 * Added deprecated warnings (8/8)<br>
=C2=A0 - Made sure the same logic is used in propsel.c and config.c by<br>
=C2=A0 =C2=A0 calling the same function (3/8, 4/8)<br>
=C2=A0 - Added deprecated warnings (8/8)<br>
<br>
Changes wrt v2:<br>
=C2=A0- Added Acked-by:/Reviewed-by: tags<br>
=C2=A0- 1/11: clarify comment in select_max_sectors_kb (Hannes Reinecke)<br=
>
=C2=A0- 3/11: call select_retain_hwhandler before select_features<br>
=C2=A0- 8/11: don&#39;t suggest using retain_attached_hw_handler in log msg=
<br>
=C2=A0- 9/11, 10/11, 11/11: new<br>
<br>
Changes wrt v3:<br>
=C2=A0- Added Reviewed-by: tags (kept Ben&#39;s Ack in 4/11 although patch =
slightly changed)<br>
=C2=A0- 4/11: use a buffer on stack rather than malloc (Hannes Reinecke)<br=
>
=C2=A0- 10/11: Simplify by checking dh_state only in select_handler (Hannes=
 Reinecke)<br>
<br>
Martin Wilck (11):<br>
=C2=A0 libmultipath: load_config: skip setting unnecessary defaults<br>
=C2=A0 libmultipath: add/remove_feature: use const char* for feature<br>
=C2=A0 libmultipath: clarify option conflicts for &quot;features&quot;<br>
=C2=A0 libmultipath: merge_hwe: fix queue_if_no_path logic<br>
=C2=A0 libmultipath: assemble_map: fix queue_if_no_path logic<br>
=C2=A0 multipath.conf.5: document no_path_retry vs. queue_if_no_path<br>
=C2=A0 multipath.conf.5: Remove ??? and other minor fixes<br>
=C2=A0 libmultipath: add deprecated warning for some features settings<br>
=C2=A0 libmultipath: retain_attached_hw_handler obsolete with 4.3+<br>
=C2=A0 libmultipath: don&#39;t try to set hwhandler if it is retained<br>
=C2=A0 libmultipath: don&#39;t [un]set queue_if_no_path after domap<br>
<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 31 +++---------<br>
=C2=A0libmultipath/configure.c=C2=A0 =C2=A0|=C2=A0 28 ++++-------<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 11 +++--<br>
=C2=A0libmultipath/dmparser.c=C2=A0 =C2=A0 |=C2=A0 =C2=A08 +--<br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0| 121 +++++++++++++++++++++=
+++++++++<wbr>+++++++++------<br>
=C2=A0libmultipath/propsel.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A03 ++<br>
=C2=A0libmultipath/structs.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 30 +++++------<br>
=C2=A0libmultipath/structs.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A04 +-<br>
=C2=A0libmultipath/util.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 36 +++++++++++=
+++<br>
=C2=A0libmultipath/util.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A02 +<br>
=C2=A0multipath/multipath.conf.5 |=C2=A0 67 +++++++++++++++----------<br>
=C2=A011 files changed, 231 insertions(+), 110 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.13.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a113ca11aa5421f0555d39822--


--===============3177314558516719407==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3177314558516719407==--
