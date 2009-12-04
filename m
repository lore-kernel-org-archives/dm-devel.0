From: Edward Choi <edward@os.sg>
Subject: Re: Too many paths from multipath?
Date: Fri, 4 Dec 2009 17:47:29 +0800
Message-ID: <4e3a31b90912040147l5b3544f9w9d627c084b4cae80@mail.gmail.com>
References: <4B168B7F.6060307@eib.org> <1259774764.2177.9.camel@localhost>
	<4B16AA74.7050307@eib.org>
Reply-To: e@os.sg, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0718610036=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B16AA74.7050307@eib.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, jsosic@srce.hr
List-Id: dm-devel.ids

--===============0718610036==
Content-Type: multipart/alternative; boundary=0016e68f9f360681fe0479e3ff3f

--0016e68f9f360681fe0479e3ff3f
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Dec 3, 2009 at 1:57 AM, Jose Nuno Neto <j.neto@eib.org> wrote:

> Ok that seems right, but on my case I have 4connections per HBA total of
> 8per Lun
>
> The info I got regarding zoning is that each HBA is connected/zoned to only
> one Storage controller
> So that would make 2connections per Lun
>
> What I suspect is that the Fabric here is made of 4switchs and that makes
> 4x plus. The SAN people just configured it with a generic "big" fabric
> zoning just one connection. but Linux shoes 4. could this be the reason?
>
>
The number of paths shown on multipath -ll depends on how your zoning is
done. The easiest way is to check with your SAN administrator on how the
zoning is done and on how many switches and that will explain the 8 paths
you're seeing.

--
Regards,
Edward Choi.

--0016e68f9f360681fe0479e3ff3f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">On Thu, Dec 3, 2009 at 1:57 AM, Jose Nuno Neto <=
span dir=3D"ltr">&lt;<a href=3D"mailto:j.neto@eib.org">j.neto@eib.org</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"border-left:=
 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex=
;">
Ok that seems right, but on my case I have 4connections per HBA total of 8p=
er Lun<br>
<br>
The info I got regarding zoning is that each HBA is connected/zoned to only=
 one Storage controller<br>
So that would make 2connections per Lun<br>
<br>
What I suspect is that the Fabric here is made of 4switchs and that makes 4=
x plus. The SAN people just configured it with a generic &quot;big&quot; fa=
bric zoning just one connection. but Linux shoes 4. could this be the reaso=
n?<div class=3D"im">
<br></div></blockquote><div><br>The number of paths shown on multipath -ll =
depends on how your zoning is done. The easiest way is to check with your S=
AN administrator on how the zoning is done and on how many switches and tha=
t will explain the 8 paths you&#39;re seeing.<br>
<br>--<br>Regards,<br>Edward Choi.<br></div></div>

--0016e68f9f360681fe0479e3ff3f--


--===============0718610036==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0718610036==--
