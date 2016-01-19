From: "mlody3k ." <mlody3k@gmail.com>
Subject: dm-cache + storage client experiment
Date: Tue, 19 Jan 2016 17:01:24 +0100
Message-ID: <CALU38fe9yDR7=P2eNez0fvgsrBmcY=Q=BvTnC5cPzu-o=MgbzA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2107460980055405939=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============2107460980055405939==
Content-Type: multipart/alternative; boundary=089e01537a5442a1ce0529b1fb2a

--089e01537a5442a1ce0529b1fb2a
Content-Type: text/plain; charset=UTF-8

Hi dm developers!

I'm during the experiment with dm-cache and storage client and I would be
very grateful if some of You will help me with some of my questions :).

Simply, I would like to implement the write-through caching in the client
where:
 - dm-cache is only responsible to check whether requested data is in the
cache device (return requested data if hit, ENODATA if miss - do not read
from origin) - in case of miss, my client will read data from the origin.
 - dm-cache will write only to the cache device - client will write data to
the origin.

Easily, I need to start dm-cache in writethrough mode without determining
the origin device. More specifically, I need to make two changes in dm code:
 - Bypass the origin device while writing data
 - Do not remap the result to the origin device in case of read miss.

So here's my questions:
 - Do the similar solution exists?
 - Do I have to change the policy code or maybe all of this things are
contained in the target code?
 - Could someone reproduce the IO path in dm-cache code?

Thanks for your help!
Regards,
JJ

--089e01537a5442a1ce0529b1fb2a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi dm developers!<div><br></div><div>I&#39;m during the ex=
periment with dm-cache and storage client and I would be very grateful if s=
ome of You will help me with some of my questions :).=C2=A0</div><div><br><=
/div><div>Simply, I would like to implement the write-through caching in th=
e client where:</div><div>=C2=A0- dm-cache is only responsible to check whe=
ther requested data is in the cache device (return requested data if hit, E=
NODATA if miss - do not read from origin) - in case of miss, my client will=
 read data from the origin.</div><div>=C2=A0- dm-cache will write only to t=
he cache device - client will write data to the origin.</div><div><br></div=
><div>Easily, I need to start dm-cache in writethrough mode without determi=
ning the origin device. More specifically, I need to make two changes in dm=
 code:</div><div>=C2=A0- Bypass the origin device while writing data</div><=
div>=C2=A0- Do not remap the result to the origin device in case of read mi=
ss.</div><div><br></div><div>So here&#39;s my questions:</div><div>=C2=A0- =
Do the similar solution exists?<br></div><div>=C2=A0- Do I have to change t=
he policy code or maybe all of this things are contained in the target code=
?<br></div><div>=C2=A0- Could someone reproduce the IO path in dm-cache cod=
e?=C2=A0</div><div><br></div><div>Thanks for your help!</div><div>Regards,<=
/div><div>JJ</div></div>

--089e01537a5442a1ce0529b1fb2a--


--===============2107460980055405939==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2107460980055405939==--
