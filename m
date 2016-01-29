From: Dennis Yang <dennisyang@qnap.com>
Subject: Re: I/O block when removing thin device on the same pool
Date: Fri, 29 Jan 2016 19:01:44 +0800
Message-ID: <CAAR726KUTU0Q-hYqXy7BZUke-qb7f_cbUJNrnrwdsiZLxXxLxA@mail.gmail.com>
References: <CAKTMprME2=oCyjxNxLPsXcgSsAzcBW2-dLjjN1CNPAPe0w-bow@mail.gmail.com>
	<569F6F08.1040503@redhat.com>
	<CAJFSNy4yT_8j8Jqm7qggzNgeHLOE0db6dwUxrn1auH_W=sMscA@mail.gmail.com>
	<20160121194405.GA22766@redhat.com>
	<20160122133828.GN26774@soda.linbit>
	<20160122164345.GA15295@rh-vpn>
	<CAAR726+yoWG+_2sZ=Wd9Wi4rQmYxRhXFJCJVQ0UH8kJwH0ZPJQ@mail.gmail.com>
	<20160126161919.GA19606@rh-vpn>
	<CAAR726+9=j+LJjRY+LMKfzajHdWeUYOinR6YWJF+KRVdF-0HDg@mail.gmail.com>
	<20160128104405.GA21697@rh-vpn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0467486456784486007=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160128104405.GA21697@rh-vpn>
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

--===============0467486456784486007==
Content-Type: multipart/alternative; boundary=001a1148d7ca199d20052a76f79a

--001a1148d7ca199d20052a76f79a
Content-Type: text/plain; charset=UTF-8

Hi,

2016-01-28 18:44 GMT+08:00 Joe Thornber <thornber@redhat.com>:

> On Wed, Jan 27, 2016 at 12:51:09PM +0800, Dennis Yang wrote:
> > Hi Joe,
> >
> > I have applied this patch to kernel 4.4 and get the following result.
>
> Thanks for taking the time to do this.
>
> > To delete a fully-mapped 10TB thin devices,
> > with this patch takes 48 sec.
> > without this patch takes 48 sec.
> >
> > To read an empty thin device while deleting a fully-mapped 10TB thin
> > devices,
> > with this patch I/O throughput drops from 4.6TB/s to 4.3TB/s
> > without this patch, I/O blocks.
> >
> > To write an empty thin device while deleting a fully-mapped 10TB thin
> > devices,
> > with this patch I/O throughput drops from 3.2TB/s to below 4MB/s
> > without this patch, I/O blocks
> >
> > Since it looks like the write performance still suffer from the lock
> > contention, I make it to sleep 100 msec between lock release and
> reacquire
> > in commit_decs().
>
> Well it's really provisioning or breaking of sharing that's slow, not
> writes in general.  Rather than adding a sleep it would be worth
> playing with the MAX_DECS #define.  eg, try 16 and 8192 and see how
> that effects the throughput.


>

I had tried to define MAX_DECS as 1, 16, and 8192, and here is the
throughput I got.
When #define MAX_DECS 1, throughput drops from 3.2GB/s to around 800 ~ 950
MB/s.
When #define MAX_DECS 16, throughput drops from 3.2GB/s to around 150 ~ 400
MB/s
When #define MAX_DECS 8192, the I/O blocks until deletion is done.

These throughput is gathered by writing to a newly created thin device
which means lots of provisioning take place. So it seems that the more fine
grained lock we use here results in the higher throughput. Is there any
concern if I set MAX_DECS to 1 for production?

Thanks for your help again.

Dennis


> > The one thing I am curious about is what data structures are dm-thin
> tries
> > to protect by holding the pool lock during all those btree operations. At
> > first, I think the lock is held to protect the btree itself. But based on
> > the comments in the source code, I believe that it has already been
> > protected by the read/writes lock in transaction manager
> > (dm_tm_read/write_lock). Does this mean that the pool lock is held only
> to
> > protect the reference count bitmap/btree?
>
> You're correct.  I wrote all of persistent data using a rolling lock
> scheme that allows updates to the btrees to occur in parallel.  But I
> didn't extend this to cover the superblock or in core version of the
> superblock.  So the top level rw semaphore is protecting this in core
> sb.  I've spent a couple of days this week experimenting with
> switching over to using the rolling lock scheme properly.  The changes
> are extensive:
>
>     - Strip out the root_lock rw_sem.
>
>     - Introduce a transaction_lock.
>
>       Every metadata op needs to hold a rw sem in 'read' mode (even if
>       it's doing an update), except commit which would hold in write
>       mode, this forces all the threads to synchronise whenever we
>       commit.
>
>     - Change the block manager to allow us to 'lock' abstract things,
>       like the in core sb.  This is really just introducing another
>       namespace to the bm.  Pretty easy.
>
>     - Change the interfaces to persistent data structures like btree,
>       array etc. to take one of these locks representing the
>       superblock.  Audit to make sure this lock is released early to
>       support the rolling lock scheme.
>
>     - Add locking/protection to the space maps (which have some in
>       core data structs).
>
> Given this long list of changes I don't think it's worth the risk.  So
> I'd rather use the patch I posted earlier.
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

--001a1148d7ca199d20052a76f79a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><div class=3D"gmail_extra"><br><div class=3D"gmail=
_quote">2016-01-28 18:44 GMT+08:00 Joe Thornber <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:thornber@redhat.com" target=3D"_blank">thornber@redhat.com</a>=
&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8e=
x;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Wed, Jan=
 27, 2016 at 12:51:09PM +0800, Dennis Yang wrote:<br>
&gt; Hi Joe,<br>
&gt;<br>
&gt; I have applied this patch to kernel 4.4 and get the following result.<=
br>
<br>
</span>Thanks for taking the time to do this.<br>
<span class=3D""><br>
&gt; To delete a fully-mapped 10TB thin devices,<br>
&gt; with this patch takes 48 sec.<br>
&gt; without this patch takes 48 sec.<br>
&gt;<br>
&gt; To read an empty thin device while deleting a fully-mapped 10TB thin<b=
r>
&gt; devices,<br>
&gt; with this patch I/O throughput drops from 4.6TB/s to 4.3TB/s<br>
&gt; without this patch, I/O blocks.<br>
&gt;<br>
&gt; To write an empty thin device while deleting a fully-mapped 10TB thin<=
br>
&gt; devices,<br>
&gt; with this patch I/O throughput drops from 3.2TB/s to below 4MB/s<br>
&gt; without this patch, I/O blocks<br>
&gt;<br>
&gt; Since it looks like the write performance still suffer from the lock<b=
r>
&gt; contention, I make it to sleep 100 msec between lock release and reacq=
uire<br>
&gt; in commit_decs().<br>
<br>
</span>Well it&#39;s really provisioning or breaking of sharing that&#39;s =
slow, not<br>
writes in general.=C2=A0 Rather than adding a sleep it would be worth<br>
playing with the MAX_DECS #define.=C2=A0 eg, try 16 and 8192 and see how<br=
>
that effects the throughput.=C2=A0</blockquote><blockquote class=3D"gmail_q=
uote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1e=
x">=C2=A0<br></blockquote><div>=C2=A0</div><div>I had tried to define MAX_D=
ECS as 1, 16, and 8192, and here is the throughput I got.</div><div>When #d=
efine MAX_DECS 1, throughput drops from 3.2GB/s to around 800 ~ 950 MB/s.</=
div><div>When #define MAX_DECS 16, throughput drops from 3.2GB/s to around =
150 ~ 400 MB/s</div><div>When #define MAX_DECS 8192, the I/O blocks until d=
eletion is done.=C2=A0</div><div><br></div><div>These throughput is gathere=
d by writing to a newly created thin device which means lots of provisionin=
g take place. So it seems that the more fine grained lock we use here resul=
ts in the higher throughput. Is there any concern if I set MAX_DECS to 1 fo=
r production?</div><div><br></div><div>Thanks for your help again.</div><di=
v><br></div><div>Dennis</div><div>=C2=A0</div><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
"><span class=3D"">
&gt; The one thing I am curious about is what data structures are dm-thin t=
ries<br>
&gt; to protect by holding the pool lock during all those btree operations.=
 At<br>
&gt; first, I think the lock is held to protect the btree itself. But based=
 on<br>
&gt; the comments in the source code, I believe that it has already been<br=
>
&gt; protected by the read/writes lock in transaction manager<br>
&gt; (dm_tm_read/write_lock). Does this mean that the pool lock is held onl=
y to<br>
&gt; protect the reference count bitmap/btree?<br>
<br>
</span>You&#39;re correct.=C2=A0 I wrote all of persistent data using a rol=
ling lock<br>
scheme that allows updates to the btrees to occur in parallel.=C2=A0 But I<=
br>
didn&#39;t extend this to cover the superblock or in core version of the<br=
>
superblock.=C2=A0 So the top level rw semaphore is protecting this in core<=
br>
sb.=C2=A0 I&#39;ve spent a couple of days this week experimenting with<br>
switching over to using the rolling lock scheme properly.=C2=A0 The changes=
<br>
are extensive:<br>
<br>
=C2=A0 =C2=A0 - Strip out the root_lock rw_sem.<br>
<br>
=C2=A0 =C2=A0 - Introduce a transaction_lock.<br>
<br>
=C2=A0 =C2=A0 =C2=A0 Every metadata op needs to hold a rw sem in &#39;read&=
#39; mode (even if<br>
=C2=A0 =C2=A0 =C2=A0 it&#39;s doing an update), except commit which would h=
old in write<br>
=C2=A0 =C2=A0 =C2=A0 mode, this forces all the threads to synchronise whene=
ver we<br>
=C2=A0 =C2=A0 =C2=A0 commit.<br>
<br>
=C2=A0 =C2=A0 - Change the block manager to allow us to &#39;lock&#39; abst=
ract things,<br>
=C2=A0 =C2=A0 =C2=A0 like the in core sb.=C2=A0 This is really just introdu=
cing another<br>
=C2=A0 =C2=A0 =C2=A0 namespace to the bm.=C2=A0 Pretty easy.<br>
<br>
=C2=A0 =C2=A0 - Change the interfaces to persistent data structures like bt=
ree,<br>
=C2=A0 =C2=A0 =C2=A0 array etc. to take one of these locks representing the=
<br>
=C2=A0 =C2=A0 =C2=A0 superblock.=C2=A0 Audit to make sure this lock is rele=
ased early to<br>
=C2=A0 =C2=A0 =C2=A0 support the rolling lock scheme.<br>
<br>
=C2=A0 =C2=A0 - Add locking/protection to the space maps (which have some i=
n<br>
=C2=A0 =C2=A0 =C2=A0 core data structs).<br>
<br>
Given this long list of changes I don&#39;t think it&#39;s worth the risk.=
=C2=A0 So<br>
I&#39;d rather use the patch I posted earlier.<br>
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
</div></div></div>

--001a1148d7ca199d20052a76f79a--


--===============0467486456784486007==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0467486456784486007==--
