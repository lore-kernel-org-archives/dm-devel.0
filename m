From: Ravi Prakash Putchala <praks.putchala@gmail.com>
Subject: Re: Help request: setting up /dev/zero using dm-crypt ...
Date: Wed, 7 Feb 2018 14:20:36 +0530
Message-ID: <CABRTiaigM23mYm2dZEtPpwTUsm3RdmD0e3pCf+E6LAJsj2eNJQ@mail.gmail.com>
References: <CABRTiaiJNVk-UXOVq6Qhah3sLRrjj1sb6KVWHNnVP1JbMUzx1w@mail.gmail.com>
	<129830fa-aa37-7de1-6670-76eeaed5a18d@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1797437264500113489=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <129830fa-aa37-7de1-6670-76eeaed5a18d@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============1797437264500113489==
Content-Type: multipart/alternative; boundary="001a1144f8309374d905649b6340"

--001a1144f8309374d905649b6340
Content-Type: text/plain; charset="UTF-8"

Thank you, Milan. Will try these.

If you need experiment over a memory device, use either ramdisk, scsi_debug
> module to it.
> Another alternative is to create dm-zero device and use plain dm-crypt
> (not LUKS).
>

create dm-zero device:  How do I do this? Sorry, I do not have much
expertise in Linux.

Ravi

--001a1144f8309374d905649b6340
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thank you, Milan. Will try these.<br><br><div><div class=
=3D"gmail_extra"><div class=3D"gmail_quote"><blockquote class=3D"gmail_quot=
e" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204)=
;padding-left:1ex">
If you need experiment over a memory device, use either ramdisk, scsi_debug=
 module to it.<br>
Another alternative is to create dm-zero device and use plain dm-crypt (not=
 LUKS).<span class=3D"gmail-HOEnZb"></span><br></blockquote><div><br>create=
 dm-zero device:=C2=A0 How do I do this? Sorry, I do not have much expertis=
e in Linux.<br><br></div><div>Ravi<br></div></div></div></div></div>

--001a1144f8309374d905649b6340--


--===============1797437264500113489==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1797437264500113489==--
