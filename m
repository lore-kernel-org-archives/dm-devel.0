From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: multipathd: cancel free(pp->getuid) in orphan_path()
Date: Tue, 9 Aug 2016 17:15:50 +0200
Message-ID: <CABr-GnfNH3hnrXP-STHy8dXv-2W1oOSM_EDuuHJAiPCb6G6aLw@mail.gmail.com>
References: <aa8b1b03-985a-597b-e0cd-eb7267878476@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6816007046040884850=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <aa8b1b03-985a-597b-e0cd-eb7267878476@profitbricks.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

--===============6816007046040884850==
Content-Type: multipart/alternative; boundary=001a1140211e1a9c8c0539a502de

--001a1140211e1a9c8c0539a502de
Content-Type: text/plain; charset=UTF-8

Reverted,
Thanks.

On Tue, Aug 9, 2016 at 2:58 PM, Gioh Kim <gi-oh.kim@profitbricks.com> wrote:

> Hello,
>
> I have found "free(pp->getuid)" is added into orphan_path().
>
> I think it'd better to revert the patch: http://git.opensvc.com/gitweb.
> cgi?p=multipath-tools/.git;a=commit;h=44b753d34ff82ecc229407
> fe8247b11f15f435ce
>
>
> The latest code does not allocation memory for pp->getuid, but just share
> the global value.
>
> Therefore pp->getuid should not be freed.
>
> I proposed it but I am wrong.
>
> I'm very sorry to confuse you.
>
>
>
> --
> Best regards,
> Gioh Kim
> TEL: 0176 2697 8962
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a1140211e1a9c8c0539a502de
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Reverted,<div>Thanks.</div></div><div class=3D"gmail_extra=
"><br><div class=3D"gmail_quote">On Tue, Aug 9, 2016 at 2:58 PM, Gioh Kim <=
span dir=3D"ltr">&lt;<a href=3D"mailto:gi-oh.kim@profitbricks.com" target=
=3D"_blank">gi-oh.kim@profitbricks.com</a>&gt;</span> wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">Hello,<br>
<br>
I have found &quot;free(pp-&gt;getuid)&quot; is added into orphan_path().<b=
r>
<br>
I think it&#39;d better to revert the patch: <a href=3D"http://git.opensvc.=
com/gitweb.cgi?p=3Dmultipath-tools/.git;a=3Dcommit;h=3D44b753d34ff82ecc2294=
07fe8247b11f15f435ce" rel=3D"noreferrer" target=3D"_blank">http://git.opens=
vc.com/gitweb.<wbr>cgi?p=3Dmultipath-tools/.git;a=3Dc<wbr>ommit;h=3D44b753d=
34ff82ecc229407<wbr>fe8247b11f15f435ce</a><br>
<br>
<br>
The latest code does not allocation memory for pp-&gt;getuid, but just shar=
e the global value.<br>
<br>
Therefore pp-&gt;getuid should not be freed.<br>
<br>
I proposed it but I am wrong.<br>
<br>
I&#39;m very sorry to confuse you.<span class=3D"HOEnZb"><font color=3D"#88=
8888"><br>
<br>
<br>
<br>
-- <br>
Best regards,<br>
Gioh Kim<br>
TEL: 0176 2697 8962<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman<wbr>/listinfo/dm-deve=
l</a><br>
</font></span></blockquote></div><br></div>

--001a1140211e1a9c8c0539a502de--


--===============6816007046040884850==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6816007046040884850==--
