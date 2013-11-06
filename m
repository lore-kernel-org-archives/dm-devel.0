From: Wun-Yen Liang <burton.paramountcy@gmail.com>
Subject: Re: dm-thin: issues about resize the pool metadata size
Date: Wed, 6 Nov 2013 20:27:52 +0800
Message-ID: <CAKG=6JUvgrRLxWnEOJoMCGCdhmD10Rwn+vvWwQ2_MnbR--R51g@mail.gmail.com>
References: <CAKG=6JVTBPWNrFhvkFnkVT7=pihQmNm68Z-Jevyg3W4FpHEHiA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2815351407788499387=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAKG=6JVTBPWNrFhvkFnkVT7=pihQmNm68Z-Jevyg3W4FpHEHiA@mail.gmail.com>
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

--===============2815351407788499387==
Content-Type: multipart/alternative; boundary=f46d043bdf782e4fd704ea814780

--f46d043bdf782e4fd704ea814780
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: quoted-printable

Hi, folks:

Sorry for the insufficient information about my question last week.

This is my environment for the test.
    Kernel version : 3.12.0-rc7+
    LVM version : 2.02.103

I had currently done some test with the dm-thin targets.
Here is my simple script to create a pool with 32MB metadata, and a volumn
on it.

$ sudo vgcreate vg /dev/sda1
$ sudo lvcreate --type thin-pool --thinpool tpool vg --size 800G
--poolmetadatasize 32M --alloc anywhere -c 64k
$ sudo lvcreate --name lv vg --virtualsize 800G --type thin --thinpool tpoo=
l

After formating, mounting, and some I/O test, the pool and volumn work well=
.
Then I try to expand the metadata device to 64M with the following command

$ sudo lvresize --poolmetadata +32M vg/tpool

But I got error message on the terminal
    Extending logical volume tpool_tmeta to 64.00 MiB.
    device-mapper: resume ioctl on  failed: No space left on device
    Unable to resume vg-tpool-tpoolool (253:3)
    Problem reactivating tpool
    libdevmapper exiting with 2 device(s) still suspended.

The mounted volumn seems not being accessible because of being suspended.
It can only works normally from being suspended until I execute the
following command.
$ sudo lvresize --size -32M /dev/mapper/vg-tpool_tmeta

I try to find out the reason why -ENOSPC happens. Here is function
sm_ll_extend().

static int sm_metadata_extend(struct dm_space_map *sm, dm_block_t
extra_blocks)
{
...
dm_block_t old_len =3D smm->ll.nr_blocks;

smm->begin =3D old_len; // So smm->begin =3D smm->ll.nr_blocks here
memcpy(&smm->sm, &bootstrap_ops, sizeof(smm->sm));

/*
 * Extend.
 */
r =3D sm_ll_extend(&smm->ll, extra_blocks);
 /*
 * Switch back to normal behaviour.
 */
memcpy(&smm->sm, &ops, sizeof(smm->sm));
 for (i =3D old_len; !r && i < smm->begin; i++)
r =3D sm_ll_inc(&smm->ll, i, &ev);

...
}

In this function, smm->begin is set as smm->ll.nr_blocks.
Space-map operations are replaced with another set of dm_space_map
operations, bootstrap_ops, in order to flick into a mode, where all blocks
get allocated in the new area.
Just like what it did in function dm_sm_metadata_create().

After these steps, the ops will be replaced again with the original
dm_space_map structure.

In function sm_ll_extend(), there is a forloop used to incrementally extend
the nr_blocks.
dm_tm_new_block() is called in each loop, here is the call tree of
dm_tm_new_block():

    dm_tm_new_block()
         -> dm_sm_new_block()
              -> sm_bootstrap_new_block()

In function sm_bootstrap_new_block()
        ...
/*
 * We know the entire device is unused.
 */
if (smm->begin =3D=3D smm->ll.nr_blocks)
return -ENOSPC;

Because the smm->begin is set as smm->ll.nr_blocks in function
sm_ll_extend(), sm_bootstrap_new_block() will always returns -ENOSPC here.
It seems like the reason why I get -ENOSPC error and cannot successfully
resize the metadata size.
The smm->ll.nr_blocks is updated after the for loop.

By the way, it will be success if I try to extend the metedata size with
smaller size, such as
$ sudo lvresize --poolmetadata +4M vg/tpool
$ sudo lvresize --poolmetadata +8M vg/tpool
$ sudo lvresize --poolmetadata +12M vg/tpool

This is because old nr_blocks and new nr_blocks(say, old block number plus
extra_blocks) are the same after the calculation of dm_sector_div_up(), the
for loop in sm_ll_extend() will not being executed when nr_blocks is the
same.

Compare with steps when dm_sm_metadata_create(), the smm->begin is set as
(superblock + 1),and the ll.nr_blocks is set as 0 in function
sm_ll_new_metadata(). So -ENOSPC will not be returned when creating a new
pool.

So this is my question, is the following statements in
sm_bootstrap_new_block() needed? Or do I misunderstanding something in the
procedure of extending pool metadata?

/*
 * We know the entire device is unused.
 */
if (smm->begin =3D=3D smm->ll.nr_blocks)
return -ENOSPC;

Any help would be grateful. Thanks.



2013/10/30 Wun-Yen Liang <burton.paramountcy@gmail.com>

> Hi, folks,
>
> I noticed that the dm-thin metadata can be resized since LVM tools
> v2.02.99, and the related code in kernel had been added since 3.10, say,
> maybe_resize_metadata_dev() in pool_resume in dm-thin.c.
>
> I'm currently doing some experiments with dm-thin targets, with
> linux-3.11=A1BLVM2.2.02.103
> Here is my script to create thin-pool and thin-volumn on my device, a
> 200GB pool with 32M metadata
>     $ sudo vgcreate vg /dev/sda1
>     $ sudo lvcreate --type thin-pool --thinpool tpool vg --size 200G
> --poolmetadatasize 32M -c 1M
>     $ sudo lvcreate --name lv vg --virtualsize 100G --type thin --thinpoo=
l
> tpool
>
> Then, I try to increase the metadata size with the following command,
>     $ sudo lvresize --poolmetadata +4M vg/tpool
>       Extending logical volume tp_tmeta to 36.00 MiB.
>       Logical volume tpool successfully resized
>
> by executing "dmsetup status"/ "dmsetup table" command, the length of the
> *_tmeta volumn is successfully expended with 4MB size.
>
> But when trying to resize the metadata lv to 64MB
>     $ sudo lvresize --poolmetadata +28M vg/tpool
>       Extending logical volume tpool_tmeta to 64.00 MiB.
>       device-mapper: resume ioctl on  failed: No space left on device
>       Unable to resume vg-tpool-tpool (253:3)
>       Problem reactivating tpool
>       libdevmapper exiting with 2 device(s) still suspended.
>
> I get error message in this step.
> By executing vgs/lvs command, I still have free space in my volumn group
> and pool.
> The dm table of *_tmeta device seems had been modified, but resumed fail.
>
> The same kind of error also happens when I try to expend the metadata
> device with a big size, like 1GB.
> After tracing the code, the -ENOSPC seems being returned from
> sm_bootstrap_new_block() in dm-space-map-metadata.c.
>
> Here is my questions.
> Did I miss some steps before resizing the metadata device?
> Or, did the resizing of dm-thin metadata is limitted? If yes, what is the
> limitation?
>
> Any help would be grateful. Thanks
>
> Burton
>



--=20
Regards,
Q=A4=F2

--f46d043bdf782e4fd704ea814780
Content-Type: text/html; charset=Big5
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi, folks:</div><div><br></div><div>Sorry for the ins=
ufficient information about my question last week.</div><div><br></div><div=
>This is my environment for the test.</div><div>&nbsp; &nbsp; Kernel versio=
n : 3.12.0-rc7+</div>
<div>&nbsp; &nbsp; LVM version : 2.02.103</div><div><br></div><div>I had cu=
rrently done some test with the dm-thin targets.</div><div>Here is my simpl=
e script to create a pool with 32MB metadata, and a volumn on it.</div><div=
><br></div>
<div>$ sudo vgcreate vg /dev/sda1</div><div>$ sudo lvcreate --type thin-poo=
l --thinpool tpool vg --size 800G --poolmetadatasize 32M --alloc anywhere -=
c 64k</div><div>$ sudo lvcreate --name lv vg --virtualsize 800G --type thin=
 --thinpool tpool</div>
<div><br></div><div>After formating, mounting, and some I/O test, the pool =
and volumn work well.</div><div>Then I try to expand the metadata device to=
 64M with the following command</div><div><br></div><div>$ sudo lvresize --=
poolmetadata +32M vg/tpool</div>
<div><br></div><div>But I got error message on the terminal</div><div>&nbsp=
; &nbsp; Extending logical volume tpool_tmeta to 64.00 MiB.</div><div>&nbsp=
; &nbsp; device-mapper: resume ioctl on &nbsp;failed: No space left on devi=
ce</div><div>&nbsp; &nbsp; Unable to resume vg-tpool-tpoolool (253:3)</div>
<div>&nbsp; &nbsp; Problem reactivating tpool</div><div>&nbsp; &nbsp; libde=
vmapper exiting with 2 device(s) still suspended.</div><div><br></div><div>=
The mounted volumn seems not being accessible because of being suspended.</=
div><div>It can only works normally from being suspended until I execute th=
e following command.</div>
<div>$ sudo lvresize --size -32M /dev/mapper/vg-tpool_tmeta</div><div><br><=
/div><div>I try to find out the reason why -ENOSPC happens. Here is functio=
n sm_ll_extend().</div><div><br></div><div>static int sm_metadata_extend(st=
ruct dm_space_map *sm, dm_block_t extra_blocks)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>...</di=
v><div><span class=3D"" style=3D"white-space:pre">	</span>dm_block_t old_le=
n =3D smm-&gt;ll.nr_blocks;</div><div><br></div><div><span class=3D"" style=
=3D"white-space:pre">	</span>smm-&gt;begin =3D old_len;<span class=3D"" sty=
le=3D"white-space:pre">				</span>// So smm-&gt;begin =3D smm-&gt;ll.nr_blo=
cks here</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>memcpy(&amp;smm-&gt=
;sm, &amp;bootstrap_ops, sizeof(smm-&gt;sm));</div><div><br></div><div><spa=
n class=3D"" style=3D"white-space:pre">	</span>/*</div><div><span class=3D"=
" style=3D"white-space:pre">	</span> * Extend.</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> */</div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>r =3D sm_ll_extend(&amp;smm-&=
gt;ll, extra_blocks);</div><div><span class=3D"" style=3D"white-space:pre">=
	</span></div>
<div><span class=3D"" style=3D"white-space:pre">	</span>/*</div><div><span =
class=3D"" style=3D"white-space:pre">	</span> * Switch back to normal behav=
iour.</div><div><span class=3D"" style=3D"white-space:pre">	</span> */</div=
><div><span class=3D"" style=3D"white-space:pre">	</span>memcpy(&amp;smm-&g=
t;sm, &amp;ops, sizeof(smm-&gt;sm));</div>
<div><span class=3D"" style=3D"white-space:pre">	</span></div><div><span cl=
ass=3D"" style=3D"white-space:pre">	</span>for (i =3D old_len; !r &amp;&amp=
; i &lt; smm-&gt;begin; i++)</div><div><span class=3D"" style=3D"white-spac=
e:pre">		</span>r =3D sm_ll_inc(&amp;smm-&gt;ll, i, &amp;ev);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>...<=
/div><div>}</div><div><br></div><div>In this function, smm-&gt;begin is set=
 as smm-&gt;ll.nr_blocks.</div><div>Space-map operations are replaced with =
another set of dm_space_map operations, bootstrap_ops, in order to flick in=
to a mode, where all blocks get allocated in the new area.</div>
<div>Just like what it did in function dm_sm_metadata_create().</div><div><=
br></div><div>After these steps, the ops will be replaced again with the or=
iginal dm_space_map structure.&nbsp;</div><div><br></div><div>In function s=
m_ll_extend(), there is a forloop used to incrementally extend the nr_block=
s.&nbsp;</div>
<div>dm_tm_new_block() is called in each loop, here is the call tree of dm_=
tm_new_block():</div><div><br></div><div>&nbsp; &nbsp; dm_tm_new_block()</d=
iv><div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;-&gt; dm_sm_new_block()</div><div=
>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; -&gt; sm_bootstrap_new_bl=
ock()</div>
<div><br></div><div>In function sm_bootstrap_new_block()</div><div>&nbsp; &=
nbsp; &nbsp; &nbsp; ...</div><div><span class=3D"" style=3D"white-space:pre=
">	</span>/*</div><div><span class=3D"" style=3D"white-space:pre">	</span> =
* We know the entire device is unused.</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> */</div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>if (smm-&gt;begin =3D=3D smm-=
&gt;ll.nr_blocks)</div><div><span class=3D"" style=3D"white-space:pre">		</=
span>return -ENOSPC;</div>
<div><br></div><div>Because the smm-&gt;begin is set as smm-&gt;ll.nr_block=
s in function sm_ll_extend(), sm_bootstrap_new_block() will always returns =
-ENOSPC here.</div><div>It seems like the reason why I get -ENOSPC error an=
d cannot successfully resize the metadata size.</div>
<div>The smm-&gt;ll.nr_blocks is updated after the for loop.</div><div><br>=
</div><div>By the way, it will be success if I try to extend the metedata s=
ize with smaller size, such as</div><div>$ sudo lvresize --poolmetadata +4M=
 vg/tpool</div>
<div>$ sudo lvresize --poolmetadata +8M vg/tpool</div><div>$ sudo lvresize =
--poolmetadata +12M vg/tpool</div><div><br></div><div>This is because old n=
r_blocks and new nr_blocks(say, old block number plus extra_blocks) are the=
 same after the calculation of dm_sector_div_up(), the for loop in sm_ll_ex=
tend() will not being executed when nr_blocks is the same.</div>
<div><br></div><div>Compare with steps when dm_sm_metadata_create(), the sm=
m-&gt;begin is set as (superblock + 1),and the ll.nr_blocks is set as 0 in =
function sm_ll_new_metadata(). So -ENOSPC will not be returned when creatin=
g a new pool.</div>
<div><br></div><div>So this is my question, is the following statements in =
sm_bootstrap_new_block() needed? Or do I misunderstanding something in the =
procedure of extending pool metadata?</div><div><br></div><div><span class=
=3D"" style=3D"white-space:pre">	</span>/*</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * We know the enti=
re device is unused.</div><div><span class=3D"" style=3D"white-space:pre">	=
</span> */</div><div><span class=3D"" style=3D"white-space:pre">	</span>if =
(smm-&gt;begin =3D=3D smm-&gt;ll.nr_blocks)</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>return -ENOSPC;</d=
iv><div><br></div><div>Any help would be grateful. Thanks.</div><div><br></=
div></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">201=
3/10/30 Wun-Yen Liang <span dir=3D"ltr">&lt;<a href=3D"mailto:burton.paramo=
untcy@gmail.com" target=3D"_blank">burton.paramountcy@gmail.com</a>&gt;</sp=
an><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div>Hi, folks,</div><div><=
br></div><div>I noticed that the dm-thin metadata can be resized since LVM =
tools v2.02.99, and the related code in kernel had been added since 3.10, s=
ay,</div>
<div>maybe_resize_metadata_dev() in pool_resume in dm-thin.c.</div>
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
</blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>Regards,<div=
>Q=A4=F2</div>
</div>

--f46d043bdf782e4fd704ea814780--


--===============2815351407788499387==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2815351407788499387==--
