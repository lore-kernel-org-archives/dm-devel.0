From: =?gb2312?B?zMDVvMCk?= <tangzhankun@hotmail.com>
Subject: Can anyone give some help on my research of thin
	provisioning ?
Date: Mon, 9 Jul 2012 10:05:40 +0800
Message-ID: <BAY156-W3F9C182981E271257112FBED30@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0800916812307318030=="
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

--===============0800916812307318030==
Content-Type: multipart/alternative;
	boundary="_9fbcb795-ddbc-4d46-b547-af17c92c6008_"

--_9fbcb795-ddbc-4d46-b547-af17c92c6008_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 8bit


hi,I have tasted LVM2 's thin provisioning logical volume and read some docs of Joe Thornber in github. 
But I have one more question:
In the field of research, is there any authoritative thesis or literature review that describe thin provisioning's design idea in detail? or is there any design docs that you follows when implements thin provisioning?I searched a lot , but only find a few papers (may be out of date) like:

"SUKWOO KANG and A. L. NARASIMHA REDDY Texas A&M University. An Approach to Virtual Allocation in Storage Systems" ..
I'm guess that the concept 'virtual allocation' is similar to 'thin provisioning', but I have not seen any thesises directly related to 'thin provisioning'.
So sincerely,  I need your advice, thanks again!
brs,tangzhankun2012-07-09 		 	   		  
--_9fbcb795-ddbc-4d46-b547-af17c92c6008_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx4-phx2.redhat.com id q697CYlY012413

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px;
padding:0px
}
body.hmmessage
{
font-size: 10pt;
font-family:=CE=A2=C8=ED=D1=C5=BA=DA
}
--></style></head>
<body class=3D'hmmessage'><div dir=3D'ltr'>
<p style=3D"margin-bottom: 15px; border: 0px; color: rgb(51, 51, 51); fon=
t-family: Helvetica, arial, freesans, clean, sans-serif; line-height: 20p=
x; background-color: rgb(251, 251, 251); ">hi,</p><p style=3D"margin-bott=
om: 15px; border: 0px; color: rgb(51, 51, 51); font-family: Helvetica, ar=
ial, freesans, clean, sans-serif; line-height: 20px; background-color: rg=
b(251, 251, 251); ">I have tasted LVM2 's thin provisioning logical volum=
e and read some docs of Joe Thornber in github.&nbsp;<br>But I have one m=
ore question:<br>In the field of research, is there any authoritative the=
sis or literature review that describe thin provisioning's design idea in=
 detail? or is there any design docs that you follows when implements thi=
n provisioning?</p><p style=3D"margin-top: 15px; border: 0px; background-=
color: rgb(251, 251, 251); "><font color=3D"#333333" face=3D"Helvetica, a=
rial, freesans, clean, sans-serif"><span style=3D"line-height: 20px;">I s=
earched a lot , but only find a few papers (may be o!
 ut of date) like:</span></font><br><br><font color=3D"#333333" face=3D"H=
elvetica, arial, freesans, clean, sans-serif"><span style=3D"line-height:=
 20px;">"SUKWOO KANG and A. L. NARASIMHA REDDY Texas A&amp;M University. =
An Approach to Virtual Allocation in Storage Systems" ..</span></font><br=
><font color=3D"#333333" face=3D"Helvetica, arial, freesans, clean, sans-=
serif"><span style=3D"line-height: 20px;">I'm guess that the concept 'vir=
tual allocation' is similar to 'thin provisioning', but I have not seen a=
ny thesises directly related to 'thin provisioning'.</span></font><br><fo=
nt color=3D"#333333" face=3D"Helvetica, arial, freesans, clean, sans-seri=
f"><span style=3D"line-height: 20px;">So&nbsp;sincerely, &nbsp;I need you=
r advice, thanks again!</span></font></p><p style=3D"margin-top: 15px; bo=
rder: 0px; color: rgb(51, 51, 51); font-family: Helvetica, arial, freesan=
s, clean, sans-serif; line-height: 20px; background-color: rgb(251, 251, =
251); "><br></p><p style=3D"margin-top: 15px; border: 0px; col!
 or: rgb(51, 51, 51); font-family: Helvetica, arial, freesans, !
 clean, sans-serif; line-height: 20px; background-color: rgb(251, 251, 25=
1); ">brs,</p><p style=3D"margin-top: 15px; border: 0px; color: rgb(51, 5=
1, 51); font-family: Helvetica, arial, freesans, clean, sans-serif; line-=
height: 20px; background-color: rgb(251, 251, 251); ">tangzhankun</p><p s=
tyle=3D"margin-top: 15px; border: 0px; color: rgb(51, 51, 51); font-famil=
y: Helvetica, arial, freesans, clean, sans-serif; line-height: 20px; back=
ground-color: rgb(251, 251, 251); ">2012-07-09</p> 		 	   		  </div></bod=
y>
</html>
--_9fbcb795-ddbc-4d46-b547-af17c92c6008_--


--===============0800916812307318030==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--===============0800916812307318030==--
