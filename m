From: Dennis Yang <dennisyang@qnap.com>
Subject: Re: I/O block when removing thin device on the same pool
Date: Mon, 25 Jan 2016 17:13:10 +0800
Message-ID: <CAAR726+yoWG+_2sZ=Wd9Wi4rQmYxRhXFJCJVQ0UH8kJwH0ZPJQ@mail.gmail.com>
References: <CAKTMprME2=oCyjxNxLPsXcgSsAzcBW2-dLjjN1CNPAPe0w-bow@mail.gmail.com>
	<569F6F08.1040503@redhat.com>
	<CAJFSNy4yT_8j8Jqm7qggzNgeHLOE0db6dwUxrn1auH_W=sMscA@mail.gmail.com>
	<20160121194405.GA22766@redhat.com>
	<20160122133828.GN26774@soda.linbit>
	<20160122164345.GA15295@rh-vpn>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4651172403060832952=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160122164345.GA15295@rh-vpn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4651172403060832952==
Content-Type: multipart/alternative; boundary=089e0149432282f0b2052a24fb6e

--089e0149432282f0b2052a24fb6e
Content-Type: text/plain; charset=UTF-8

Hi,

I had done some experiments with kernel 4.2.8 that I am using for
production right now and kernel 4.4 with commit 3d5f6733 ("dm thin
metadata: speed up discard of partially mapped volumes") for comparison.

All the experiments below are performed with a dm-thin pool (512KB block
size) which is built with a RAID 0 composed by two Intel 480GB SSDs as
metadata device and a zero-target DM device as the data device. The machine
is equipped with an Intel E3-1246 v3 CPU and 16GB ram.

To discard all the mappings of a fully-mapped 10TB thin device with 512KB
block size,
kernel 4.4 takes 6m57s
kernel 4.2.8 takes 6m49s

To delete a fully-mapped 10TB thin device,
kernel 4.4 takes 48s
kernel 4.2.8 takes 47s

In another experiment, I create an empty thin device and a fully-mapped
10TB thin device. Then, I start writing to the empty thin device
sequentially with fio before deleting the fully-mapped thin device. It can
be observed that the write requests get blocked for couple of seconds
(47~48sec) until the deletion process finishes on both kernel 4.2.8 and
kernel 4.4. If we discard all the mappings in parallel with fio instead of
deleting the fully-mapped thin device, write requests will still be blocked
until all discard requests finished. I think this is because that pool's
deferred list is full of all those discard requests and thus having no
spare computation resource for new write requests to the other thin device.
The kworker thread of thinp cause 100% CPU utilisation while processing the
discard requests.

Hope this information helps.

Thanks,
Dennis


2016-01-23 0:43 GMT+08:00 Joe Thornber <thornber@redhat.com>:

> On Fri, Jan 22, 2016 at 02:38:28PM +0100, Lars Ellenberg wrote:
> > We have seen lvremove of thin snapshots sometimes minutes,
> > even ~20 minutes before.
>
> I did some work on speeding up thin removal in autumn '14, in
> particular agressively prefetching metadata pages sped up the tree
> traversal hugely.  Could you confirm you're seeing pauses of this
> duration with currently kernels please?
>
> Obviously any pause, even a few seconds is unacceptable.  Having a
> background kernel worker thread doing the delete, as you describe, is
> the way to go.  But there are complications to do with
> transactionality and crash protection that have prevented me
> implementing it.  I'll think on it some more now I know it's such a
> problem for you.
>
> - Joe
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



-- 
Dennis Yang
QNAP Systems, Inc.
Skype: qnap.dennis.yang
Email: dennisyang@qnap.com
Tel: (+886)-2-2393-5152 ext. 15018
Address: 13F., No.56, Sec. 1, Xinsheng S. Rd., Zhongzheng Dist., Taipei
City, Taiwan

--089e0149432282f0b2052a24fb6e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,=C2=A0<div><br></div><div>I had done some experiments w=
ith kernel 4.2.8 that I am using for production right now and kernel 4.4 wi=
th commit=C2=A0<span style=3D"font-size:16px">3d5f6733 (&quot;dm thin metad=
ata: speed up discard of partially mapped volumes&quot;) for comparison.</s=
pan></div><div><span style=3D"font-size:16px"><br></span></div><div><span s=
tyle=3D"font-size:16px">All the experiments below are performed with a dm-t=
hin pool (512KB block size) which is built with a RAID 0 composed by two In=
tel 480GB SSDs as metadata device and a zero-target DM device as the data d=
evice. The machine is equipped with an Intel E3-1246 v3 CPU and 16GB ram.=
=C2=A0</span></div><div><span style=3D"font-size:16px"><br></span></div><di=
v>To discard all the mappings of a fully-mapped 10TB thin device with 512KB=
 block size,</div><div>kernel 4.4 takes 6m57s=C2=A0</div><div>kernel 4.2.8 =
takes 6m49s</div><div><br></div><div>To delete a fully-mapped 10TB thin dev=
ice,=C2=A0</div><div>kernel 4.4 takes 48s</div><div>kernel 4.2.8 takes 47s<=
/div><div><br></div><div>In another experiment, I create an empty thin devi=
ce and a fully-mapped 10TB thin device. Then, I start writing to the empty =
thin device sequentially with fio before deleting the fully-mapped thin dev=
ice. It can be observed that the write requests get blocked for couple of s=
econds (47~48sec) until the deletion process finishes on both kernel 4.2.8 =
and kernel 4.4. If we discard all the mappings in parallel with fio instead=
 of deleting the fully-mapped thin device, write requests will still be blo=
cked until all discard requests finished. I think this is because that pool=
&#39;s deferred list is full of all those discard requests and thus having =
no spare computation resource for new write requests to the other thin devi=
ce. The kworker thread of thinp cause 100% CPU utilisation while processing=
 the discard requests.</div><div><br></div><div>Hope this information helps=
.</div><div><br></div><div>Thanks,</div><div>Dennis =C2=A0</div><br style=
=3D"font-size:16px"></div><div class=3D"gmail_extra"><br><div class=3D"gmai=
l_quote">2016-01-23 0:43 GMT+08:00 Joe Thornber <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:thornber@redhat.com" target=3D"_blank">thornber@redhat.com</a>=
&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8e=
x;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Fri, Jan=
 22, 2016 at 02:38:28PM +0100, Lars Ellenberg wrote:<br>
&gt; We have seen lvremove of thin snapshots sometimes minutes,<br>
&gt; even ~20 minutes before.<br>
<br>
</span>I did some work on speeding up thin removal in autumn &#39;14, in<br=
>
particular agressively prefetching metadata pages sped up the tree<br>
traversal hugely.=C2=A0 Could you confirm you&#39;re seeing pauses of this<=
br>
duration with currently kernels please?<br>
<br>
Obviously any pause, even a few seconds is unacceptable.=C2=A0 Having a<br>
background kernel worker thread doing the delete, as you describe, is<br>
the way to go.=C2=A0 But there are complications to do with<br>
transactionality and crash protection that have prevented me<br>
implementing it.=C2=A0 I&#39;ll think on it some more now I know it&#39;s s=
uch a<br>
problem for you.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
- Joe<br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<div class=3D"gmail_signature"><div dir=3D"ltr"><span lang=3D"EN-US" style=
=3D"font-size:10pt;font-family:Arial,sans-serif">Dennis Yang=C2=A0</span><s=
pan lang=3D"EN-US" style=3D"font-size:10pt;font-family:Arial,sans-serif">=
=C2=A0</span><span lang=3D"EN-US" style=3D"font-size:10pt;font-family:Arial=
,sans-serif"><br>QNAP Systems, Inc.</span><div><span lang=3D"EN-US" style=
=3D"font-size:10pt;font-family:Arial,sans-serif">Skype: qnap.dennis.yang<br=
>Email:</span><span lang=3D"EN-US" style=3D"font-size:10pt;font-family:Aria=
l,sans-serif">=C2=A0<a href=3D"mailto:dennisyang@qnap.com" target=3D"_blank=
">dennisyang@qnap.com</a></span><div><span lang=3D"EN-US" style=3D"font-siz=
e:10pt;font-family:Arial,sans-serif">Tel:</span><span style=3D"font-family:=
Arial,sans-serif;font-size:13.333333969116211px">=C2=A0(+886)-2-2393-5152 e=
xt.=C2=A0</span><span style=3D"font-family:Arial,sans-serif;font-size:13.33=
3333969116211px">15018</span><div><font face=3D"Arial, sans-serif" size=3D"=
2">Address:=C2=A0</font><span style=3D"color:rgb(51,51,51);font-family:Verd=
ana,Arial,Helvetica,sans-serif;font-size:12px;line-height:18.66666603088379=
px">13F., No.56, Sec. 1, Xinsheng S. Rd., Zhongzheng Dist., Taipei City, Ta=
iwan</span></div></div></div></div></div>
</div>

--089e0149432282f0b2052a24fb6e--


--===============4651172403060832952==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4651172403060832952==--
