From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v2 0/4] libmultipath: Fixes for NVME / NVMEoF
Date: Thu, 3 Aug 2017 09:08:44 +0200
Message-ID: <CABr-GndPzZdaGavhQJn3vf=H+RWKXcaQm72NdBciRQxEaewtQw@mail.gmail.com>
References: <20170718072916.24275-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2172562076273835504=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170718072916.24275-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.de>, Xose Vazquez Perez <xose.vazquez@gmail.com>, tang.junhui@zte.com.cn, Guan Junxiong <guanjunxiong@huawei.com>, linux-nvme@lists.infradead.org, device-mapper development <dm-devel@redhat.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>
List-Id: dm-devel.ids

--===============2172562076273835504==
Content-Type: multipart/alternative; boundary="001a113d29d414323e0555d40dee"

--001a113d29d414323e0555d40dee
Content-Type: text/plain; charset="UTF-8"

This set is now merged.
Thanks.

On Tue, Jul 18, 2017 at 9:29 AM, Martin Wilck <mwilck@suse.com> wrote:

> Current code fails to set up multipath maps for NVME devices in a
> Linux target/Linux host combination. This series enables at least
> basic operation.
>
> Patch 1/4 fixes a crash that happens if over-long WWIDs are encountered,
> and
> is not specific to NVME as such. Patch 2/4 drops
> the broken test uevent_can_discard_by_devpath(). Patch 3/4 compensates
> for the additional event processing required by 2/4. Patch 4/4 mangles
> overlong "nvme.*" WWIDs to make them usable for multipath (related
> discussion
> in [1]; WWID_SIZE can't be simply increased because it has to match
> device mapper's DM_NAME_LEN).
>
> Changes wrt v1:
>  1/4: assure 0-termination by using strlcpy() (Bart van Assche)
>  4/4: drop extra length test (Ben Marzinski)
>
> I kept the v1 Reviewed-by: and Acked-by tags because the changes are minor,
> I hope that's ok for the reviewers.
>
> [1] http://lists.infradead.org/pipermail/linux-nvme/2017-July/011960.html
>
> Martin Wilck (4):
>   libmultipath: get_udev_uid: make sure pp->wwid is 0-terminated
>   libmultipath: drop uevent_can_discard_by_devpath
>   libmultipath: only listen for uevents with DEVTYPE=disk
>   libmultipath: fix over-long NVME WWIDs
>
>  libmultipath/discovery.c | 85 ++++++++++++++++++++++++++++++
> +++++++++++++++---
>  libmultipath/uevent.c    | 27 +--------------
>  2 files changed, 82 insertions(+), 30 deletions(-)
>
> --
> 2.13.2
>
>

--001a113d29d414323e0555d40dee
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">This set is now merged.<div>Thanks.</div></div><div class=
=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue, Jul 18, 2017 at 9:2=
9 AM, Martin Wilck <span dir=3D"ltr">&lt;<a href=3D"mailto:mwilck@suse.com"=
 target=3D"_blank">mwilck@suse.com</a>&gt;</span> wrote:<br><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pa=
dding-left:1ex">Current code fails to set up multipath maps for NVME device=
s in a<br>
Linux target/Linux host combination. This series enables at least<br>
basic operation.<br>
<br>
Patch 1/4 fixes a crash that happens if over-long WWIDs are encountered, an=
d<br>
is not specific to NVME as such. Patch 2/4 drops<br>
the broken test uevent_can_discard_by_devpath(<wbr>). Patch 3/4 compensates=
<br>
for the additional event processing required by 2/4. Patch 4/4 mangles<br>
overlong &quot;nvme.*&quot; WWIDs to make them usable for multipath (relate=
d discussion<br>
in [1]; WWID_SIZE can&#39;t be simply increased because it has to match<br>
device mapper&#39;s DM_NAME_LEN).<br>
<br>
Changes wrt v1:<br>
=C2=A01/4: assure 0-termination by using strlcpy() (Bart van Assche)<br>
=C2=A04/4: drop extra length test (Ben Marzinski)<br>
<br>
I kept the v1 Reviewed-by: and Acked-by tags because the changes are minor,=
<br>
I hope that&#39;s ok for the reviewers.<br>
<br>
[1] <a href=3D"http://lists.infradead.org/pipermail/linux-nvme/2017-July/01=
1960.html" rel=3D"noreferrer" target=3D"_blank">http://lists.infradead.org/=
<wbr>pipermail/linux-nvme/2017-<wbr>July/011960.html</a><br>
<br>
Martin Wilck (4):<br>
=C2=A0 libmultipath: get_udev_uid: make sure pp-&gt;wwid is 0-terminated<br=
>
=C2=A0 libmultipath: drop uevent_can_discard_by_devpath<br>
=C2=A0 libmultipath: only listen for uevents with DEVTYPE=3Ddisk<br>
=C2=A0 libmultipath: fix over-long NVME WWIDs<br>
<br>
=C2=A0libmultipath/discovery.c | 85 ++++++++++++++++++++++++++++++<wbr>++++=
+++++++++++---<br>
=C2=A0libmultipath/uevent.c=C2=A0 =C2=A0 | 27 +--------------<br>
=C2=A02 files changed, 82 insertions(+), 30 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.13.2<br>
<br>
</font></span></blockquote></div><br></div>

--001a113d29d414323e0555d40dee--


--===============2172562076273835504==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2172562076273835504==--
