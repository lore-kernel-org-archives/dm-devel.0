From: jianchao wang <jianchao.wan9@gmail.com>
Subject: Re: Why does dm-thin pool metadata space map use 4K page
 to carry index ?
Date: Thu, 5 Sep 2019 21:52:15 +0800
Message-ID: <CAC-DDmNpa4w1LuC4gnpWJy-uuYv1vQshW_4XxVpKvD=LG=UCSg@mail.gmail.com>
References: <CAC-DDmMQu38J6kCirxK=axwEguEpaN+H1JJVPbUsyqtxcx5KEw@mail.gmail.com>
	<20190905103843.xnakopha6s6oeuyd@reti>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2791592434910126023=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190905103843.xnakopha6s6oeuyd@reti>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jianchao wang <jianchao.wan9@gmail.com>, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============2791592434910126023==
Content-Type: multipart/alternative; boundary="000000000000cae9300591cea1d1"

--000000000000cae9300591cea1d1
Content-Type: text/plain; charset="UTF-8"

Hi Joe

Thanks for your kindly response

On Thu, Sep 5, 2019 at 6:38 PM Joe Thornber <thornber@redhat.com> wrote:

> On Thu, Sep 05, 2019 at 02:43:28PM +0800, jianchao wang wrote:
> > But why does it use this 4K page instead of btree as the disk sm ?
> >
> > The brb mechanism seem be able to avoid the nested block allocation
> > when do COW on the metadata sm btree.
> >
> > Would anyone please help to tell why does it use this 4K page instead of
> a
> > btree ?
>
> It's a long time since I wrote this, so I can't remember the order that
> things
> were written.  It may well be that brb mechanism for avoiding recursive
> allocations
> came after the on disk formats were defined.  Irrespective of that the
> single page
> pointing to index pages should perform better.
>
> Is the 16G limit to the metadata device causing you issues?
>

Yes, we are planing to build a 200T pool at least and there are both normal
thin device
and snapshot running on it.  Smaller block size would be better, but 16G is
not enough.

Actually, I have modified the metadata sm code to use btree as the disk sm.
In my test
environment, I have used ~20G metadata.

Thanks
Jianchao

--000000000000cae9300591cea1d1
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">Hi Joe</div><div dir=3D"ltr"><br></div><d=
iv>Thanks for your kindly response</div><br><div class=3D"gmail_quote"><div=
 dir=3D"ltr" class=3D"gmail_attr">On Thu, Sep 5, 2019 at 6:38 PM Joe Thornb=
er &lt;<a href=3D"mailto:thornber@redhat.com">thornber@redhat.com</a>&gt; w=
rote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On Thu, Se=
p 05, 2019 at 02:43:28PM +0800, jianchao wang wrote:<br>
&gt; But why does it use this 4K page instead of btree as the disk sm ?<br>
&gt; <br>
&gt; The brb mechanism seem be able to avoid the nested block allocation<br=
>
&gt; when do COW on the metadata sm btree.<br>
&gt; <br>
&gt; Would anyone please help to tell why does it use this 4K page instead =
of a<br>
&gt; btree ?<br>
<br>
It&#39;s a long time since I wrote this, so I can&#39;t remember the order =
that things<br>
were written.=C2=A0 It may well be that brb mechanism for avoiding recursiv=
e allocations<br>
came after the on disk formats were defined.=C2=A0 Irrespective of that the=
 single page<br>
pointing to index pages should perform better.<br>
<br>
Is the 16G limit to the metadata device causing you issues?<br></blockquote=
><div><br></div><div>Yes, we are planing to build a 200T pool at least and =
there are both normal thin device</div><div>and snapshot running on it.=C2=
=A0 Smaller block size would be better, but 16G is not enough.</div><div><b=
r></div><div>Actually, I have modified the metadata sm code to use btree as=
 the disk sm. In my test</div><div>environment, I have used ~20G metadata.<=
/div><div>=C2=A0</div><div>Thanks</div><div>Jianchao</div></div></div>

--000000000000cae9300591cea1d1--


--===============2791592434910126023==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2791592434910126023==--
