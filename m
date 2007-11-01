From: =?GBK?B?tq266ces?= <dhongqian@163.com>
Subject: dlm_recvd and dlm_sendd causes high load
Date: Thu, 1 Nov 2007 16:00:07 +0800 (CST)
Message-ID: <24281378.314791193904007719.JavaMail.coremail@bj163app58.163.com>
References: <20071101000007.GO10006@agk.fab.redhat.com>
	<20071031020133.GL10006@agk.fab.redhat.com> <47282B1D.8030501@sw.ru>
	<47283061.8080501@suse.de>
	<20071031.170016.39152331.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0963428859=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071101000007.GO10006@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: nfbrown@novell.com, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, akpm@linux-foundation.org, stable@kernel.org, devel@openvz.org
List-Id: dm-devel.ids

--===============0963428859==
Content-Type: multipart/alternative;
	boundary="----=_Part_83227_32787241.1193904007717"

------=_Part_83227_32787241.1193904007717
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello, everyone:
   I've setup a high availibility cluster but have some problems with dlm_recvd and dlm_sendd processes. Everything seems to be running smooth except these processes that takes half of the cpu power each.
 
  I've searched on the net. I didn't find the answer except a solution for GFS2, while mine
is GFS 1. 
  
  Could anyone help?
 
   Thanks in advance!
 
                                                            dhongqian
------=_Part_83227_32787241.1193904007717
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<DIV>Hello, everyone:</DIV>
<DIV>=C2=A0=C2=A0 <FONT face=3D"NSimsun">I've setup a high availibility clu=
ster but have some problems with <TT>dlm_recvd and dlm_sendd processes. </T=
T><TT>Everything seems to be running smooth except these processes that tak=
es </TT><TT>half of the cpu power each.</TT></FONT></DIV>
<DIV><FONT face=3D"NSimsun"><TT></TT></FONT>=C2=A0</DIV>
<DIV><FONT face=3D"NSimsun"><TT>=C2=A0=C2=A0I've searched on the net. I did=
n't find the=C2=A0answer except a solution for GFS2, while mine</TT></FONT>=
</DIV>
<DIV><FONT face=3D"NSimsun"><TT>is GFS 1. </TT></FONT></DIV>
<DIV><FONT face=3D"NSimsun"><TT>=C2=A0 </TT></FONT></DIV>
<DIV><FONT face=3D"NSimsun"><TT>=C2=A0 Could anyone help?</TT></FONT></DIV>
<DIV><FONT face=3D"NSimsun"><TT></TT></FONT>=C2=A0</DIV>
<DIV><FONT face=3D"NSimsun"><TT>=C2=A0=C2=A0 Thanks in advance!</TT></FONT>=
</DIV>
<DIV><FONT face=3D"NSimsun"><TT></TT></FONT>=C2=A0</DIV>
<DIV><FONT face=3D"NSimsun"><TT>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 dhongqian</TT></FONT></DIV><br><!-- footer --><br>
<hr>
<table width=3D"100%%" border=3D"0" cellspacing=3D"0" cellpadding=3D"0">
  <tr>
    <td width=3D"50" height=3D"50"><img src=3D"http://mimg.163.com/hd/163/1=
63footer/163footer_50.jpg" alt=3D"LOGO" width=3D"50" height=3D"50"></td>
    <td style=3D"padding:5px;"><a style=3D"font-size:12px;color:black; line=
-height:20px;text-decoration:none;" href=3D"http://popme.163.com/link/00351=
5_0929_938.html">=E6=8A=8A=E7=88=B1=E5=BF=83=E6=B3=A8=E5=85=A5=E7=89=9B=E5=
=A5=B6=EF=BC=8C=E5=85=B1=E5=90=8C=E5=87=9D=E8=81=9A=E8=BF=99=E4=BB=BD=E5=8A=
=9B=E9=87=8F</a><br /><a style=3D"font-size:12px;line-height:20px; color:bl=
ack; text-decoration:none;" href=3D"http://popme.163.com/link/003515_0929_9=
38.html">=E5=BF=AB=E6=9D=A5=E5=8F=82=E5=8A=A0=E8=92=99=E7=89=9B=E5=85=8D=E8=
=B4=B9=E8=B5=A0=E5=A5=B6=E7=88=B1=E5=BF=83=E8=A1=8C=E5=8A=A8 </a></td>
  </tr>
</table>

------=_Part_83227_32787241.1193904007717--


--===============0963428859==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0963428859==--
