From: Nicholas Nevin <njnevin@gmail.com>
Subject: Re: /dev/mapper/<dm_name> symlink not being created
Date: Tue, 15 May 2012 10:32:11 -0400
Message-ID: <CACmkXc5-ALYkEW3U=UQTY=yCEwLGbJDhMeLv60winYCg4nkv0g@mail.gmail.com>
References: <CACmkXc5fQCF78UW1_tEruAiuWL_EgODLt87=ZD-d_f2zT-GPeA@mail.gmail.com>
	<CACmkXc5cEhvdBgHzbNW13cFcoj83LjFea=qwZOq5UUq5vpwdAw@mail.gmail.com>
	<4FB10BE7.8090602@redhat.com>
	<CACmkXc75Sp1itjaNvsU-y8Jq51V34feZuzxRFPqWxC1ASdo22g@mail.gmail.com>
	<20120515140705.GA19147@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4012398610735819727=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120515140705.GA19147@agk-dp.fab.redhat.com>
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

--===============4012398610735819727==
Content-Type: multipart/alternative; boundary=047d7b2edf0741de0004c01413fd

--047d7b2edf0741de0004c01413fd
Content-Type: text/plain; charset=ISO-8859-1

On Tue, May 15, 2012 at 10:07 AM, Alasdair G Kergon <agk@redhat.com> wrote:

> dmsetup and udev have the functionality needed to do this in a race-free
> manner, but it's necessarily complicated and takes a while to get your head
> around it.  You'll need to use the dmsetup commands/options for udev
> cookies
> described in the man page.
>
> Alasdair
>
>
Thanks. I'll take a look at doing this.

-nick

--047d7b2edf0741de0004c01413fd
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Tue, May 15, 2012 at 10:07 AM, Alasda=
ir G Kergon <span dir=3D"ltr">&lt;<a href=3D"mailto:agk@redhat.com" target=
=3D"_blank">agk@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gm=
ail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-le=
ft:1ex">

dmsetup and udev have the functionality needed to do this in a race-free<br=
>
manner, but it&#39;s necessarily complicated and takes a while to get your =
head<br>
around it. =A0You&#39;ll need to use the dmsetup commands/options for udev =
cookies<br>
described in the man page.<br>
<br>
Alasdair<br>
<br></blockquote><div><br></div><div>Thanks.=A0I&#39;ll take a look at doin=
g this.</div><div><br></div><div>-nick</div><div><br></div></div>

--047d7b2edf0741de0004c01413fd--


--===============4012398610735819727==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4012398610735819727==--
