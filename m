From: Wun-Yen Liang <burton.paramountcy@gmail.com>
Subject: dm-thin: issues about resize the pool metadata size
Date: Wed, 30 Oct 2013 16:15:35 +0800
Message-ID: <CAKG=6JVTBPWNrFhvkFnkVT7=pihQmNm68Z-Jevyg3W4FpHEHiA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5431973039696002048=="
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

--===============5431973039696002048==
Content-Type: multipart/alternative; boundary=e89a8f50356206426504e9f0f081

--e89a8f50356206426504e9f0f081
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: quoted-printable

Hi, folks,

I noticed that the dm-thin metadata can be resized since LVM tools
v2.02.99, and the related code in kernel had been added since 3.10, say,
maybe_resize_metadata_dev() in pool_resume in dm-thin.c.

I'm currently doing some experiments with dm-thin targets, with
linux-3.11=A1BLVM2.2.02.103
Here is my script to create thin-pool and thin-volumn on my device, a 200GB
pool with 32M metadata
    $ sudo vgcreate vg /dev/sda1
    $ sudo lvcreate --type thin-pool --thinpool tpool vg --size 200G
--poolmetadatasize 32M -c 1M
    $ sudo lvcreate --name lv vg --virtualsize 100G --type thin --thinpool
tpool

Then, I try to increase the metadata size with the following command,
    $ sudo lvresize --poolmetadata +4M vg/tpool
      Extending logical volume tp_tmeta to 36.00 MiB.
      Logical volume tpool successfully resized

by executing "dmsetup status"/ "dmsetup table" command, the length of the
*_tmeta volumn is successfully expended with 4MB size.

But when trying to resize the metadata lv to 64MB
    $ sudo lvresize --poolmetadata +28M vg/tpool
      Extending logical volume tpool_tmeta to 64.00 MiB.
      device-mapper: resume ioctl on  failed: No space left on device
      Unable to resume vg-tpool-tpool (253:3)
      Problem reactivating tpool
      libdevmapper exiting with 2 device(s) still suspended.

I get error message in this step.
By executing vgs/lvs command, I still have free space in my volumn group
and pool.
The dm table of *_tmeta device seems had been modified, but resumed fail.

The same kind of error also happens when I try to expend the metadata
device with a big size, like 1GB.
After tracing the code, the -ENOSPC seems being returned from
sm_bootstrap_new_block() in dm-space-map-metadata.c.

Here is my questions.
Did I miss some steps before resizing the metadata device?
Or, did the resizing of dm-thin metadata is limitted? If yes, what is the
limitation?

Any help would be grateful. Thanks

Burton

--e89a8f50356206426504e9f0f081
Content-Type: text/html; charset=Big5
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi, folks,</div><div><br></div><div>I noticed that th=
e dm-thin metadata can be resized since LVM tools v2.02.99, and the related=
 code in kernel had been added since 3.10, say,</div><div>maybe_resize_meta=
data_dev() in pool_resume in dm-thin.c.</div>
<div><br></div><div>I&#39;m currently doing some experiments with dm-thin t=
argets, with linux-3.11=A1BLVM2.2.02.103</div><div>Here is my script to cre=
ate thin-pool and thin-volumn on my device, a 200GB pool with&nbsp;32M&nbsp=
;metadata</div>
<div>&nbsp; &nbsp; $ sudo vgcreate vg /dev/sda1</div><div>&nbsp; &nbsp; $ s=
udo lvcreate --type thin-pool --thinpool tpool vg --size 200G --poolmetadat=
asize 32M -c 1M</div><div>&nbsp; &nbsp; $ sudo lvcreate --name lv vg --virt=
ualsize 100G --type thin --thinpool tpool</div>
<div><br></div><div>Then, I try to increase the metadata size with the foll=
owing command,</div><div>&nbsp; &nbsp; $ sudo lvresize --poolmetadata +4M v=
g/tpool</div><div>&nbsp; &nbsp; &nbsp; Extending logical volume tp_tmeta to=
 36.00 MiB.</div><div>
&nbsp; &nbsp; &nbsp; Logical volume tpool successfully resized</div><div><b=
r></div><div>by executing &quot;dmsetup status&quot;/ &quot;dmsetup table&q=
uot; command, the length of the *_tmeta volumn is successfully expended wit=
h 4MB size.</div>
<div><br></div><div>But when trying to resize the metadata lv to 64MB</div>=
<div>&nbsp; &nbsp; $ sudo lvresize --poolmetadata +28M vg/tpool</div><div>&=
nbsp; &nbsp; &nbsp; Extending logical volume tpool_tmeta to 64.00 MiB.</div=
><div>&nbsp; &nbsp; &nbsp; device-mapper: resume ioctl on &nbsp;failed: No =
space left on device</div>
<div>&nbsp; &nbsp; &nbsp; Unable to resume vg-tpool-tpool (253:3)</div><div=
>&nbsp; &nbsp; &nbsp; Problem reactivating tpool</div><div>&nbsp; &nbsp; &n=
bsp; libdevmapper exiting with 2 device(s) still suspended.</div><div><br><=
/div><div>I get error message in this step.</div>
<div>By executing vgs/lvs command, I still have free space in my volumn gro=
up and pool.</div><div>The dm table of *_tmeta device seems had been modifi=
ed, but resumed fail.</div><div><br></div><div>The same kind of error also =
happens when I try to expend the metadata device with a big size, like 1GB.=
</div>
<div>After tracing the code, the -ENOSPC seems being returned from sm_boots=
trap_new_block() in dm-space-map-metadata.c.&nbsp;</div><div><br></div><div=
>Here is my questions.</div><div>Did I miss some steps before resizing the =
metadata device?</div>
<div>Or, did the resizing of dm-thin metadata is limitted? If yes, what is =
the limitation?</div><div><br></div><div>Any help would be grateful. Thanks=
</div><div><br></div><div>Burton</div>
</div>

--e89a8f50356206426504e9f0f081--


--===============5431973039696002048==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5431973039696002048==--
