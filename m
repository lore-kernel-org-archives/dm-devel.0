From: "M.H. Tsai" <mingnus@gmail.com>
Subject: thin_repair doesn't do size checking on the output device
Date: Mon, 19 May 2014 15:13:24 +0800
Message-ID: <CAAYit8QKG_gAmwvew7AAZMJeSh5MzGtuMrRrk9Gi-BS2UcyAUQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0995373099525730369=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============0995373099525730369==
Content-Type: multipart/alternative; boundary=14dae93d8d08c8a32104f9bb7fdc

--14dae93d8d08c8a32104f9bb7fdc
Content-Type: text/plain; charset=UTF-8

Hi All,

I'm using LVM2.2.02.106 and thin-provisioning-tools 0.3.2 on Ubuntu 13.10.
I found that thin_repair doesn't do size checking on the output device,
thus it will crash if the output device is larger than the space map's
limitation (i.e., 255*16320*4096 bytes). The bitmap_count calculated by
sm_disk::extend() might exceeded 255.

The direct influence is that it cannot collaborate with the LVM2 "lvconvert
--repair" command while the thinpool's metadata is exactly 16GiB. The
reason is that the size of the pool metadata spare's DM target activated by
_lvconvert_thinpool_repair() is 16384MiB, not 16192MiB. LVM2 only adjust
the DM target's size to DM_THIN_MAX_METADATA_SIZE(16192MiB) while the
metadata or the spare volume are activated within a thinpool.

If this is a bug, I thought that it might be better to add size checking to
thin_repair, since that users might use devices larger than 16GiB as the
output device. Is that a feasible approach?


Many Thanks,
Ming-Hung Tsai

--14dae93d8d08c8a32104f9bb7fdc
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Hi All,</div><div><br></div><div>I&#39;m using L=
VM2.2.02.106 and thin-provisioning-tools 0.3.2 on Ubuntu 13.10. I found tha=
t thin_repair doesn&#39;t do size checking on the output device, thus it wi=
ll crash if the output device is larger than the space map&#39;s limitation=
 (i.e., 255*16320*4096 bytes). The bitmap_count calculated by sm_disk::exte=
nd() might exceeded 255.</div>

<div><br></div><div>The direct influence is that it cannot collaborate with=
 the LVM2 &quot;lvconvert --repair&quot; command while the thinpool&#39;s m=
etadata is exactly 16GiB. The reason is that the size of the pool metadata =
spare&#39;s DM target activated by _lvconvert_thinpool_repair() is 16384MiB=
, not 16192MiB. LVM2 only adjust the DM target&#39;s size to DM_THIN_MAX_ME=
TADATA_SIZE(16192MiB) while the metadata or the spare volume are activated =
within a thinpool.</div>

<div><br></div><div>If this is a bug, I thought that it might be better to =
add size checking to thin_repair, since that users might use devices larger=
 than 16GiB as the output device. Is that a feasible approach?</div><div>

<br></div><div><br></div><div>Many Thanks,</div><div>Ming-Hung Tsai</div></=
div><div><br></div></div>

--14dae93d8d08c8a32104f9bb7fdc--


--===============0995373099525730369==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0995373099525730369==--
