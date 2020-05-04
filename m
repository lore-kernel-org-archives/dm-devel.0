From: Drew Hastings <dhastings@crucialwebhost.com>
Subject: Re: Thin provisioning bug in dm-thin
Date: Mon, 4 May 2020 12:03:25 -0700
Message-ID: <CAN-y+E+XKJ6YnXSQaOFOogaueUv3SX2VVTnbc9hvHVRdvtKFHw@mail.gmail.com>
References: <CAN-y+ELN7GW5hiOQcK7nTe-_A9XdJExQUEuy7MmiJhzsZTf0+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0060326884369960306=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAN-y+ELN7GW5hiOQcK7nTe-_A9XdJExQUEuy7MmiJhzsZTf0+A@mail.gmail.com>
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

--===============0060326884369960306==
Content-Type: multipart/alternative; boundary="0000000000001ccef105a4d7307a"

--0000000000001ccef105a4d7307a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

My mistake - I had been looking at an old version (and had a typo in my
original message). I can see it's correct in the latest version. You can
disregard this.

On Mon, May 4, 2020 at 11:54 AM Drew Hastings <dhastings@crucialwebhost.com=
>
wrote:

> In process_create_snap_mesg, when dm_thinner_pool_create_snap fails, the
> DMWARN is for ARGV[1] and ARGV[2], but should be for 0 and 1.
>

--0000000000001ccef105a4d7307a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">My mistake - I had been looking at an old version (and had=
 a typo in my original message). I can see it&#39;s correct in the latest v=
ersion. You can disregard this.</div><br><div class=3D"gmail_quote"><div di=
r=3D"ltr" class=3D"gmail_attr">On Mon, May 4, 2020 at 11:54 AM Drew Hasting=
s &lt;<a href=3D"mailto:dhastings@crucialwebhost.com">dhastings@crucialwebh=
ost.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"=
margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-lef=
t:1ex"><div dir=3D"ltr">In=C2=A0process_create_snap_mesg, when dm_thinner_p=
ool_create_snap fails, the DMWARN is for ARGV[1] and ARGV[2], but should be=
 for 0 and 1.<br></div>
</blockquote></div>

--0000000000001ccef105a4d7307a--

--===============0060326884369960306==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0060326884369960306==--
