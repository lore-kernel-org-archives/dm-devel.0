From: Patrick Dung <patdung100@gmail.com>
Subject: Re: About dm-integrity layer and fsync
Date: Sun, 5 Jan 2020 20:20:53 +0800
Message-ID: <CAJTWkducreuW2LcOaipUMnNRFhvjd4N_LdKrnND-wBfCS593jg@mail.gmail.com>
References: <CAJTWkdu1-k5m0F-uzp-EMrncL1w4wLqEi8LgF0U1Js_Nf-YphQ@mail.gmail.com>
	<alpine.LRH.2.02.2001031206190.11685@file01.intranet.prod.int.rdu2.redhat.com>
	<CAJTWkdvOtgzrrJiT+FQccCFu4sXzncHZDo7=RW5TWqiw8rxfLg@mail.gmail.com>
	<alpine.LRH.2.02.2001050431590.6830@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0776381399121141423=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2001050431590.6830@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============0776381399121141423==
Content-Type: multipart/alternative; boundary="0000000000007f3471059b639450"

--0000000000007f3471059b639450
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

OK, I see. Thanks Mikulas for the explanation.

On Sun, Jan 5, 2020 at 5:39 PM Mikulas Patocka <mpatocka@redhat.com> wrote:

>
>
> On Sat, 4 Jan 2020, Patrick Dung wrote:
>
> > Thanks for reply. After performing an additional testing with SSD. I
> have more questions.
> >
> > Firstly, about the additional testing with SSD:
> > I tested it with SSD (in Linux software raid level 10 setup). The resul=
t
> shown using dm-integrity is faster than using XFS directly. For using
> dm-integrity, fio shows
> > lots of I/O merges by the scheduler. Please find the attachment for the
> result.
> >
> > Finally, please find the questions below:
> > 1) So after the dm-integrity journal is written to the actual back end
> storage (hard drive), then fsync would then report completed?
>
> Yes.
>
> > 2) To my understanding, for using dm-integrity with journal mode. Data
> has to written into the storage device twice (one part is the dm-integrit=
y
> journal, the other
> > one is the actual data). For the fio test, the data should be random an=
d
> sustained for 60 seconds. But using dm-integrity with journal mode is sti=
ll
> faster.
> >
> > Thanks,
> > Patrick
>
> With ioengine=3Dsync, fio sends one I/O, waits for it to finish, send
> another I/O, wait for it to finish, etc.
>
> With dm-integrity, I/Os will be written to the journal (that is held in
> memory, no disk I/O is done), and when fio does the sync(), fsync() or
> fdatasync() syscall, the journal is written to the disk. After the journa=
l
> is flushed, the blocks are written concurrently to the disk locations.
>
> The SSD has better performance for concurrent write then for
> block-by-block write, so that's why you see performance improvement with
> dm-integrity.
>
> Mikulas
>
>

--0000000000007f3471059b639450
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">OK, I see. Thanks Mikulas for the explanation.<br></div><b=
r><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Sun, =
Jan 5, 2020 at 5:39 PM Mikulas Patocka &lt;<a href=3D"mailto:mpatocka@redha=
t.com">mpatocka@redhat.com</a>&gt; wrote:<br></div><blockquote class=3D"gma=
il_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,2=
04,204);padding-left:1ex"><br>
<br>
On Sat, 4 Jan 2020, Patrick Dung wrote:<br>
<br>
&gt; Thanks for reply. After performing an additional testing with SSD. I h=
ave more questions.<br>
&gt; <br>
&gt; Firstly, about the additional testing with SSD:<br>
&gt; I tested it with SSD (in Linux software raid level 10 setup). The resu=
lt shown using dm-integrity is faster than using XFS directly. For using dm=
-integrity, fio shows<br>
&gt; lots of I/O merges by the scheduler. Please find the attachment for th=
e result.<br>
&gt; <br>
&gt; Finally, please find the questions below:<br>
&gt; 1) So after the dm-integrity journal is written to the actual back end=
 storage (hard drive), then fsync would then report completed?<br>
<br>
Yes.<br>
<br>
&gt; 2) To my understanding, for using dm-integrity with journal mode. Data=
 has to written into the storage device twice (one part is the dm-integrity=
 journal, the other<br>
&gt; one is the actual data). For the fio test, the data should be random a=
nd sustained for 60 seconds. But using dm-integrity with journal mode is st=
ill faster.<br>
&gt; <br>
&gt; Thanks,<br>
&gt; Patrick<br>
<br>
With ioengine=3Dsync, fio sends one I/O, waits for it to finish, send <br>
another I/O, wait for it to finish, etc.<br>
<br>
With dm-integrity, I/Os will be written to the journal (that is held in <br=
>
memory, no disk I/O is done), and when fio does the sync(), fsync() or <br>
fdatasync() syscall, the journal is written to the disk. After the journal =
<br>
is flushed, the blocks are written concurrently to the disk locations.<br>
<br>
The SSD has better performance for concurrent write then for <br>
block-by-block write, so that&#39;s why you see performance improvement wit=
h <br>
dm-integrity.<br>
<br>
Mikulas<br>
<br>
</blockquote></div>

--0000000000007f3471059b639450--

--===============0776381399121141423==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0776381399121141423==--
