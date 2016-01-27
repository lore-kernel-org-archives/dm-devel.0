From: Dennis Yang <dennisyang@qnap.com>
Subject: Re: I/O block when removing thin device on the same pool
Date: Wed, 27 Jan 2016 12:51:09 +0800
Message-ID: <CAAR726+9=j+LJjRY+LMKfzajHdWeUYOinR6YWJF+KRVdF-0HDg@mail.gmail.com>
References: <CAKTMprME2=oCyjxNxLPsXcgSsAzcBW2-dLjjN1CNPAPe0w-bow@mail.gmail.com>
	<569F6F08.1040503@redhat.com>
	<CAJFSNy4yT_8j8Jqm7qggzNgeHLOE0db6dwUxrn1auH_W=sMscA@mail.gmail.com>
	<20160121194405.GA22766@redhat.com>
	<20160122133828.GN26774@soda.linbit>
	<20160122164345.GA15295@rh-vpn>
	<CAAR726+yoWG+_2sZ=Wd9Wi4rQmYxRhXFJCJVQ0UH8kJwH0ZPJQ@mail.gmail.com>
	<20160126161919.GA19606@rh-vpn>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6052371621304777609=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160126161919.GA19606@rh-vpn>
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

--===============6052371621304777609==
Content-Type: multipart/alternative; boundary=001a1147cd461fd87b052a498ed1

--001a1147cd461fd87b052a498ed1
Content-Type: text/plain; charset=UTF-8

Hi Joe,

I have applied this patch to kernel 4.4 and get the following result.

To delete a fully-mapped 10TB thin devices,
with this patch takes 48 sec.
without this patch takes 48 sec.

To read an empty thin device while deleting a fully-mapped 10TB thin
devices,
with this patch I/O throughput drops from 4.6TB/s to 4.3TB/s
without this patch, I/O blocks.

To write an empty thin device while deleting a fully-mapped 10TB thin
devices,
with this patch I/O throughput drops from 3.2TB/s to below 4MB/s
without this patch, I/O blocks

Since it looks like the write performance still suffer from the lock
contention, I make it to sleep 100 msec between lock release and reacquire
in commit_decs().

To write an empty thin device while deleting a fully-mapped 10TB thin
devices
With sleep in commit_decs(), I/O throughput drops from 3.2TB/s to 2.2TB/s,
but the deletion time grows from 48sec to 2m54sec.

The one thing I am curious about is what data structures are dm-thin tries
to protect by holding the pool lock during all those btree operations. At
first, I think the lock is held to protect the btree itself. But based on
the comments in the source code, I believe that it has already been
protected by the read/writes lock in transaction manager
(dm_tm_read/write_lock). Does this mean that the pool lock is held only to
protect the reference count bitmap/btree?

Thanks,
Dennis

2016-01-27 0:19 GMT+08:00 Joe Thornber <thornber@redhat.com>:

> Hi Dennis,
>
> This is indeed useful.  Is there any chance you could re-run your test
> with this patch applied please?
>
>
> https://github.com/jthornber/linux-2.6/commit/64197a3802320c7a7359ff4a3e592e2bc5bb73dc
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

--001a1147cd461fd87b052a498ed1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Joe,<div><br></div><div>I have applied this patch to ke=
rnel 4.4 and get the following result.=C2=A0</div><div><br></div><div>To de=
lete a fully-mapped 10TB thin devices,=C2=A0</div><div>with this patch take=
s 48 sec.</div><div>without this patch takes 48 sec.</div><div><br></div><d=
iv>To read an empty thin device while deleting a fully-mapped 10TB thin dev=
ices,</div><div>with this patch I/O throughput drops from 4.6TB/s to 4.3TB/=
s=C2=A0</div><div>without this patch, I/O blocks.</div><div><br></div><div>=
To write an empty thin device while deleting a fully-mapped 10TB thin devic=
es,</div><div>with this patch I/O throughput drops from 3.2TB/s to below 4M=
B/s</div><div>without this patch, I/O blocks</div><div><br></div><div>Since=
 it looks like the write performance still suffer from the lock contention,=
 I make it to sleep 100 msec between lock release and reacquire in commit_d=
ecs().=C2=A0</div><div><br></div><div>To write an empty thin device while d=
eleting a fully-mapped 10TB thin devices=C2=A0</div><div>With sleep in comm=
it_decs(), I/O throughput drops from 3.2TB/s to 2.2TB/s, but the deletion t=
ime grows from 48sec to 2m54sec.</div><div><br></div><div>The one thing I a=
m curious about is what data structures are dm-thin tries to protect by hol=
ding the pool lock during all those btree operations. At first, I think the=
 lock is held to protect the btree itself. But based on the comments in the=
 source code, I believe that it has already been protected by the read/writ=
es lock in transaction manager (dm_tm_read/write_lock). Does this mean that=
 the pool lock is held only to protect the reference count bitmap/btree?</d=
iv><div><br></div><div>Thanks,</div><div>Dennis</div></div><div class=3D"gm=
ail_extra"><br><div class=3D"gmail_quote">2016-01-27 0:19 GMT+08:00 Joe Tho=
rnber <span dir=3D"ltr">&lt;<a href=3D"mailto:thornber@redhat.com" target=
=3D"_blank">thornber@redhat.com</a>&gt;</span>:<br><blockquote class=3D"gma=
il_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-lef=
t:1ex">Hi Dennis,<br>
<br>
This is indeed useful.=C2=A0 Is there any chance you could re-run your test=
<br>
with this patch applied please?<br>
<br>
<a href=3D"https://github.com/jthornber/linux-2.6/commit/64197a3802320c7a73=
59ff4a3e592e2bc5bb73dc" rel=3D"noreferrer" target=3D"_blank">https://github=
.com/jthornber/linux-2.6/commit/64197a3802320c7a7359ff4a3e592e2bc5bb73dc</a=
><br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
- Joe<br>
<br>
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

--001a1147cd461fd87b052a498ed1--


--===============6052371621304777609==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6052371621304777609==--
