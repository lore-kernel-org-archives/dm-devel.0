From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: check sysfs path state for
	NVMe/NVMf
Date: Thu, 3 Aug 2017 09:23:13 +0200
Message-ID: <CABr-Gnc-1j+6BbS232XejiFrqYTGADv-E8HYrUVYtAy8fpO2Hg@mail.gmail.com>
References: <1501205323-13440-1-git-send-email-guanjunxiong@huawei.com>
	<66209fe7-9ed4-d269-5102-5a97a3c58854@suse.de>
	<87413531-8abe-a279-dd97-0d49e56984b6@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8348666851852511121=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87413531-8abe-a279-dd97-0d49e56984b6@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Guan Junxiong <guanjunxiong@huawei.com>
Cc: Zou Ming <zouming.zouming@huawei.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Yang Feng <philip.yang@huawei.com>, shenhong09@huawei.com, device-mapper development <dm-devel@redhat.com>, hege09@huawei.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

--===============8348666851852511121==
Content-Type: multipart/alternative; boundary="001a113d5f8aef1c020555d440fa"

--001a113d5f8aef1c020555d440fa
Content-Type: text/plain; charset="UTF-8"

Merged.
Thanks.

On Fri, Jul 28, 2017 at 8:54 AM, Guan Junxiong <guanjunxiong@huawei.com>
wrote:

> Hi Hannes,
>
> On 2017/7/28 14:12, Hannes Reinecke wrote:
> > On 07/28/2017 03:28 AM, Guan Junxiong wrote:
> >> The previous code of path_offline checking was only valid for SCSI
> >> device. It returned PATH_UP for other devices and throwed path check-
> >> ing to chekers. This patch supplements checking sysfs path state for
> >> NVMe/NVMf devices. For example, if NVMe/NVMf path is reconnectting or
> >> resetting, we return PATH_PENDING in order to skip current path check-
> >> ing and reschedule path checking in the next tick as soon as possible.
> >>
> >> Signed-off-by: Guan Junxiong <guanjunxiong@huawei.com>
> >> ---
> >>  libmultipath/discovery.c | 45 ++++++++++++++++++++++++++++++
> +++++----------
> >>  1 file changed, 35 insertions(+), 10 deletions(-)
> >>
> > Thanks for doing this.
> >
> >>
> > Patch looks good.
> >
> > Reviewed-by: Hannes Reinecke <hare@suse.com>
> >
> Nice to have any review. Thanks.
>
> > However, I do wonder if we really need a path checker for NVMf once we
> > have this. After all, the sysfs attribute reflects that KATO status,
> > which pretty much determines if we can send I/O _at all_.
> >
> > Cheers,
> >
> > Hannes
>
> IMO, I think Keep Alive feature is in controller granularity , _not_
> namespace
> granularity. A namespace can be detached ( or disabled with nvmetcli tools)
> from controller which has many namespaces attached, but the controller
> sysfs
> state attribute is still "live". Therefor, we do need further path checker
> after we know controller is live.
>
> Refer to the following quoted from NVMe Spec 1.3:
> "The Keep Alive feature is used by the host to determine that the
> controller
> is operational and by the controller to determine that the host is
> operational.
> The host and controller are operational when each is accessible and able to
> issue or execute commands."
>
>
> Regards
> Guan
>
>
> .
>
>

--001a113d5f8aef1c020555d440fa
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Fri, Jul 28, 2017 at 8:54 AM, Guan Junxio=
ng <span dir=3D"ltr">&lt;<a href=3D"mailto:guanjunxiong@huawei.com" target=
=3D"_blank">guanjunxiong@huawei.com</a>&gt;</span> wrote:<br><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;p=
adding-left:1ex">Hi Hannes,<br>
<span class=3D""><br>
On 2017/7/28 14:12, Hannes Reinecke wrote:<br>
&gt; On 07/28/2017 03:28 AM, Guan Junxiong wrote:<br>
&gt;&gt; The previous code of path_offline checking was only valid for SCSI=
<br>
&gt;&gt; device. It returned PATH_UP for other devices and throwed path che=
ck-<br>
&gt;&gt; ing to chekers. This patch supplements checking sysfs path state f=
or<br>
&gt;&gt; NVMe/NVMf devices. For example, if NVMe/NVMf path is reconnectting=
 or<br>
&gt;&gt; resetting, we return PATH_PENDING in order to skip current path ch=
eck-<br>
&gt;&gt; ing and reschedule path checking in the next tick as soon as possi=
ble.<br>
&gt;&gt;<br>
&gt;&gt; Signed-off-by: Guan Junxiong &lt;<a href=3D"mailto:guanjunxiong@hu=
awei.com">guanjunxiong@huawei.com</a>&gt;<br>
&gt;&gt; ---<br>
&gt;&gt;=C2=A0 libmultipath/discovery.c | 45 ++++++++++++++++++++++++++++++=
<wbr>+++++----------<br>
&gt;&gt;=C2=A0 1 file changed, 35 insertions(+), 10 deletions(-)<br>
&gt;&gt;<br>
&gt; Thanks for doing this.<br>
&gt;<br>
&gt;&gt;<br>
</span><span class=3D"">&gt; Patch looks good.<br>
&gt;<br>
&gt; Reviewed-by: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.com">hare=
@suse.com</a>&gt;<br>
&gt;<br>
</span>Nice to have any review. Thanks.<br>
<span class=3D""><br>
&gt; However, I do wonder if we really need a path checker for NVMf once we=
<br>
&gt; have this. After all, the sysfs attribute reflects that KATO status,<b=
r>
&gt; which pretty much determines if we can send I/O _at all_.<br>
&gt;<br>
&gt; Cheers,<br>
&gt;<br>
&gt; Hannes<br>
<br>
</span>IMO, I think Keep Alive feature is in controller granularity , _not_=
 namespace<br>
granularity. A namespace can be detached ( or disabled with nvmetcli tools)=
<br>
from controller which has many namespaces attached, but the controller sysf=
s<br>
state attribute is still &quot;live&quot;. Therefor, we do need further pat=
h checker<br>
after we know controller is live.<br>
<br>
Refer to the following quoted from NVMe Spec 1.3:<br>
&quot;The Keep Alive feature is used by the host to determine that the cont=
roller<br>
is operational and by the controller to determine that the host is operatio=
nal.<br>
The host and controller are operational when each is accessible and able to=
<br>
issue or execute commands.&quot;<br>
<br>
<br>
Regards<br>
Guan<br>
<br>
<br>
.<br>
<br>
</blockquote></div><br></div>

--001a113d5f8aef1c020555d440fa--


--===============8348666851852511121==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8348666851852511121==--
