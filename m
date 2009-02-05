From: =?ISO-8859-1?Q?Christian_R=F8snes?= <christian.rosnes@gmail.com>
Subject: Re: Multipath setup and rdac questions
Date: Thu, 5 Feb 2009 19:48:33 +0100
Message-ID: <1a4a774c0902051048keb6e681g7dbf2643a88a6d9e@mail.gmail.com>
References: <1a4a774c0902050558r661093dag83e71a06250c24aa@mail.gmail.com>
	<498B00B3.5020402@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1299771591=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <498B00B3.5020402@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bmr@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1299771591==
Content-Type: multipart/alternative; boundary=00163646be02e867f504623059bc

--00163646be02e867f504623059bc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 5, 2009 at 4:07 PM, Bryn M. Reeves <bmr@redhat.com> wrote:

> Christian R=F8snes wrote:
>
>>

> I also see these messages in /var/log/messages when I change the
>> module controller ownership:
>>
>> 494 [RAIDarray.mpp]MD3000i_A:0:1:0 Cmnd-failed try alt ctrl 1.
>> vcmnd SN 351494 pdev H2:C0:T0:L0 0x05/0x94/0x01 0x08000002
>> mpp_status:1
>>
>
> Don't know where this is coming form. Do you have IBM's MPP
> multipathing driver installed? If you are using device-mapper
> multipath and multipath tools (the rest of your mail suggests this is
> your intention) you should not load the MPP modules.
>
> Hi

Thank you for the information.

I think the MPP driver came from the
linuxrdac-09.03.0C06.0030-1dkms rpm package
installed from the Dell MD3000i Resource CD,
because the top of the Makefile in /usr/src/linuxrdac-09.03.0C06.0030 reads=
:

#**********************************************************************
# Makefile for Linux RDAC (MPP) Driver
#
# This is a modified version of the linuxrdac Makefile provided by LSI
# (renamed to Makefile_orig).
# It is dkms compatable, and provides:
#    genuniqueid, mppUtil, install, uninstall
# The mppUpper and mppVhba targets are provided by dkms through obj-m
#
#######################################################################


It was maybe installed when I choose this option 3 from the installer on
that CD:

---------------------------------------------------------------------------=
----------------------------------


   ################################################################

                  Dell PowerVault MD3000i Resource CD

   ################################################################

 1. View MD3000i Readme
 2. Install MD3000i Storage Manager
 3. Install Multi-pathing Driver
 4. MD3000i Configuration Utility
 5. Dell Support
 6. View End User License Agreement

 Enter the number to select a component from the above list.
 Enter q to quit.

 Enter: 3

---------------------------------------------------------------------------=
----------------------------------


Is mpp another type of rdac driver than the one in question here ?


Thank you
Christian

--00163646be02e867f504623059bc
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Thu, Feb 5, 2009 at 4:07 PM, Bryn M. =
Reeves <span dir=3D"ltr">&lt;<a href=3D"mailto:bmr@redhat.com">bmr@redhat.c=
om</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"bord=
er-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-l=
eft: 1ex;">
<div class=3D"Ih2E3d">Christian R=F8snes wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
</blockquote></div></blockquote><div>&nbsp;</div><blockquote class=3D"gmail=
_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt=
 0pt 0.8ex; padding-left: 1ex;"><div class=3D"Ih2E3d"><blockquote class=3D"=
gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0p=
t 0pt 0pt 0.8ex; padding-left: 1ex;">
I also see these messages in /var/log/messages when I change the<br>
module controller ownership:<br>
<br>
494 [RAIDarray.mpp]MD3000i_A:0:1:0 Cmnd-failed try alt ctrl 1.<br>
vcmnd SN 351494 pdev H2:C0:T0:L0 0x05/0x94/0x01 0x08000002<br>
mpp_status:1<br>
</blockquote>
<br></div>
Don&#39;t know where this is coming form. Do you have IBM&#39;s MPP<br>
multipathing driver installed? If you are using device-mapper<br>
multipath and multipath tools (the rest of your mail suggests this is<br>
your intention) you should not load the MPP modules.<div class=3D"Ih2E3d"><=
br>
<br></div></blockquote><div>Hi <br><br>Thank you for the information.<br><b=
r>I think the MPP driver came from the&nbsp; <br>linuxrdac-09.03.0C06.0030-=
1dkms rpm package<br>installed from the Dell MD3000i Resource CD, <br>becau=
se the top of the Makefile in /usr/src/linuxrdac-09.03.0C06.0030 reads:<br>
<br>#**********************************************************************=
<br># Makefile for Linux RDAC (MPP) Driver<br>#<br># This is a modified ver=
sion of the linuxrdac Makefile provided by LSI<br># (renamed to Makefile_or=
ig).<br>
# It is dkms compatable, and provides:<br>#&nbsp;&nbsp;&nbsp; genuniqueid, =
mppUtil, install, uninstall<br># The mppUpper and mppVhba targets are provi=
ded by dkms through obj-m<br>#<br>#########################################=
##############################<br>
<br><br>It was maybe installed when I choose this option 3 from the install=
er on that CD:<br><br>-----------------------------------------------------=
--------------------------------------------------------<br>
<br><br>&nbsp;&nbsp; ######################################################=
##########<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Dell PowerVault MD3000i Resou=
rce CD<br><br>&nbsp;&nbsp; ################################################=
################<br><br>&nbsp;1. View MD3000i Readme<br>
&nbsp;2. Install MD3000i Storage Manager<br>&nbsp;3. Install Multi-pathing =
Driver<br>&nbsp;4. MD3000i Configuration Utility<br>&nbsp;5. Dell Support<b=
r>&nbsp;6. View End User License Agreement<br><br>&nbsp;Enter the number to=
 select a component from the above list.<br>
&nbsp;Enter q to quit.<br><br>&nbsp;Enter: 3<br><br>-----------------------=
---------------------------------------------------------------------------=
-----------<br><br><br>Is mpp another type of rdac driver than the one in q=
uestion here ?<br>
<br><br></div></div>Thank you<br>Christian<br><br>

--00163646be02e867f504623059bc--


--===============1299771591==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1299771591==--
