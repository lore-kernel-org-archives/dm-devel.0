From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: PATCH 0/4] multipath-tools: Ceph rbd support v2
Date: Tue, 9 Aug 2016 17:36:15 +0200
Message-ID: <CABr-Gnf1vfGOMGcP8YF2tFMy5Z2Buwp7H9iXfCzuDC-S+FE7AA@mail.gmail.com>
References: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6106516043213174036=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
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

--===============6106516043213174036==
Content-Type: multipart/alternative; boundary=001a114034a621996d0539a54be9

--001a114034a621996d0539a54be9
Content-Type: text/plain; charset=UTF-8

Merged.

I think it is worth advertizing here that the build now requires rados.h.

Thanks.

On Mon, Aug 8, 2016 at 2:01 PM, Mike Christie <mchristi@redhat.com> wrote:

> The following patches made over Christophe's tree today,
> add Ceph rbd support for handling blacklisted devices.
>
>
> This is not general support for rbd and multipath. There is
> no boot/root support and it does not support features like
> multibus. My use is for HA configurations, specifically for exporting
> rbd images through multiple LIO instances. In this case, we have one
> rbd instance that has the ceph rbd exclusive lock and it can send
> WRITE requests. If that host becomes unreachable, then another host
> will grab the lock, and blacklist the original host to prevent it from
> sending stale IO (when blacklisted IO will be failed by the OSD).
>
> To recover from that type of scenario, this patchset adds a repair()
> callout to the checker. If the path is in the PATH_DOWN state this
> callout can be used to fix it up. For my case, I am remapping
> the device to flush stale IO and cleanup the old lock,
> and then unblacklisting the path, so it can be used again.
>
> Changes since v1:
> - Drop ID_UID use and implemented sysfs getuid support.
> - Drop settings that were defaults and follow template.
> - Fix ceph auth/user.
>
>

--001a114034a621996d0539a54be9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div><br></div><div>I think it is worth advertizing=
 here that the build now requires rados.h.</div><div><br></div><div>Thanks.=
</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Mo=
n, Aug 8, 2016 at 2:01 PM, Mike Christie <span dir=3D"ltr">&lt;<a href=3D"m=
ailto:mchristi@redhat.com" target=3D"_blank">mchristi@redhat.com</a>&gt;</s=
pan> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex=
;border-left:1px #ccc solid;padding-left:1ex">The following patches made ov=
er Christophe&#39;s tree today,<br>
add Ceph rbd support for handling blacklisted devices.<br>
<br>
<br>
This is not general support for rbd and multipath. There is<br>
no boot/root support and it does not support features like<br>
multibus. My use is for HA configurations, specifically for exporting<br>
rbd images through multiple LIO instances. In this case, we have one<br>
rbd instance that has the ceph rbd exclusive lock and it can send<br>
WRITE requests. If that host becomes unreachable, then another host<br>
will grab the lock, and blacklist the original host to prevent it from<br>
sending stale IO (when blacklisted IO will be failed by the OSD).<br>
<br>
To recover from that type of scenario, this patchset adds a repair()<br>
callout to the checker. If the path is in the PATH_DOWN state this<br>
callout can be used to fix it up. For my case, I am remapping<br>
the device to flush stale IO and cleanup the old lock,<br>
and then unblacklisting the path, so it can be used again.<br>
<br>
Changes since v1:<br>
- Drop ID_UID use and implemented sysfs getuid support.<br>
- Drop settings that were defaults and follow template.<br>
- Fix ceph auth/user.<br>
<br>
</blockquote></div><br></div>

--001a114034a621996d0539a54be9--


--===============6106516043213174036==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6106516043213174036==--
