Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEA98C77B72
	for <dm-devel@archiver.kernel.org>; Fri, 14 Apr 2023 23:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681513936;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=lIifh4fmlEMFpS0SSkh7XGxaPiWF2U7KKffOYO7/9Ns=;
	b=hxuL8MyKA5hF4qTJdxwAw4+gOBFGWOU4olVgZ07K+Yti83Ss/6lQ0k9AC7QEtKxHG4PfCE
	KhF9ZugGo8RjPMiSoXx0oEE2EN8CcOV9D8hQOD5Y1F6HoV0txP0IvlAr/4FH39304PA6Ty
	dmr4rzSFZR9UGbEXC1Syyo0gfSojo2s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-lRYxIRAbOwurC-O1m0oMaQ-1; Fri, 14 Apr 2023 19:12:13 -0400
X-MC-Unique: lRYxIRAbOwurC-O1m0oMaQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8400F29AA2EE;
	Fri, 14 Apr 2023 23:12:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1B5872027043;
	Fri, 14 Apr 2023 23:12:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EC9F1194658C;
	Fri, 14 Apr 2023 23:12:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F25331946589
 for <dm-devel@listman.corp.redhat.com>; Fri, 14 Apr 2023 23:12:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D650740B3EDA; Fri, 14 Apr 2023 23:12:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CE92640B3ED9
 for <dm-devel@redhat.com>; Fri, 14 Apr 2023 23:12:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2FB3811E7C
 for <dm-devel@redhat.com>; Fri, 14 Apr 2023 23:12:08 +0000 (UTC)
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com
 [209.85.215.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-HfDzuGh9OFuAw8-vfT7xrA-1; Fri, 14 Apr 2023 19:12:06 -0400
X-MC-Unique: HfDzuGh9OFuAw8-vfT7xrA-1
Received: by mail-pg1-f174.google.com with SMTP id h193so9515982pgc.6
 for <dm-devel@redhat.com>; Fri, 14 Apr 2023 16:12:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681513925; x=1684105925;
 h=to:subject:message-id:date:from:reply-to:mime-version
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=rcwvZAG6CsByMDLpTlCsYYylLznzB8II2IFyK5NIkms=;
 b=Sb/4kh5jWrAy1HVKSh3TVZzBGFGbITKjdpMGfHmRVoiPuLtRoeiyJ0DDaqoAuRUU7R
 mfmSjMxxemCcdSxrwJnUoEMifS/GqE8dKk8MWX46XeZPmz6uvdTkGP7vStxzahI/qAj+
 s0sLlfM100htzSDXfi/YZc/xZyIt3rR3RUsegAuogIXKC8/VnXHZnR54SsqU6X2oI/YS
 oDUV8/rBbtZT1QpDPc7ljgUQUvml+YVedLjtMD4kZq070gdJ/klSfhdTjL1z/RAt0Rn0
 vixqEIwfnm16cbRBRcElqAEPbbriJcsX+nXuEDV4ycB3v0bwq10xMcOzuxPDkECvQteE
 5Brw==
X-Gm-Message-State: AAQBX9frwusNb37GbQ4auEXy8qzx+nR+CdW0C1m+OjB94bhEU1bOZIu7
 Q910x5Q6nn3wIBcy5XvnFBgUL2itNYT9W6gE4I5WG/z1hNBBJg==
X-Google-Smtp-Source: AKy350bkDgDl7Ja76DQJN34ZPro8ZbewhA1n3VrrMwAZ0fr4Y238OY3G7rSUowUGYcEwmeJcOnNG51FAjhMhKnO0hgg=
X-Received: by 2002:a65:55cd:0:b0:514:3d3d:da5a with SMTP id
 k13-20020a6555cd000000b005143d3dda5amr1268219pgs.3.1681513925097; Fri, 14 Apr
 2023 16:12:05 -0700 (PDT)
MIME-Version: 1.0
From: Mike Stramba <mikestramba@gmail.com>
Date: Fri, 14 Apr 2023 19:11:53 -0400
Message-ID: <CAA5vqSa9Byg4p_WSfuPu9hVaBRhWsnPG-wBGEjR3w7MD2Lr8_g@mail.gmail.com>
To: dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] device mapper on qemu / Ubuntu 9.4.0-1ubuntu1~20.04.1
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Reply-To: mikestramba@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: multipart/mixed; boundary="===============7057088281565381345=="

--===============7057088281565381345==
Content-Type: multipart/alternative; boundary="00000000000030bec105f953f822"

--00000000000030bec105f953f822
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Greetings all

I am trying to run zipl on:

 Linux version 5.4.0-125-generic (buildd@bos02-s390x-015) (gcc version
9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1)) #141-Ubuntu SMP

which is running under qemu (version 6.2.0 (Debian 1:6.2+dfsg-2ubuntu6.6)

Is running  zipl_helper.device-mapper under qemu possible ?

If it is, here are the details :

---------------------
sudo zipl

I am receiving the following errors
:
Using config file '/etc/zipl.conf'
Building bootmap in '/mnt/vdb/boot'
Adding IPL section 'ubuntu' (default)
Run /lib/s390-tools/zipl_helper.device-mapper /mnt/vdb/boot
Error: Could not retrieve device-mapper information for device 'vdb'
<<<<<<<<<<<<<<<<<<<<<<<<<<<
Error: Could not add image file '/home/mike/kernel/hello-kernel': Script
could not determine target parameters


------------ etc/zipl.conf
[defaultboot]
default=3Dubuntu

[ubuntu]
target=3D/mnt/vdb/boot
image=3D/home/mike/kernel/hello-kernel
ramdisk=3D /home/mike/kernel/initrd.img

-------------  lsblk ----------------
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 53.4M  1 loop /snap/core20/1613
loop1                       7:1    0 54.6M  1 loop /snap/core20/1853
loop2                       7:2    0   59M  1 loop /snap/lxd/22755
loop3                       7:3    0 46.4M  1 loop /snap/snapd/18599
loop4                       7:4    0 77.8M  1 loop /snap/lxd/24063
vda                       252:0    0    5G  0 disk
=E2=94=9C=E2=94=80vda1                    252:1    0  1.8G  0 part
=E2=94=94=E2=94=80vda2                    252:2    0  3.3G  0 part
  =E2=94=94=E2=94=80ubuntu--vg-ubuntu--lv 253:0    0  3.3G  0 lvm  /

vdb                       252:16   0  100M  0 disk /mnt/vdb <<<<<<<<<<<<<<<=
<

--00000000000030bec105f953f822
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Greetings all<div><br></div><div>I am trying to run zipl=
=C2=A0on:</div><div><br></div><div>=C2=A0Linux version 5.4.0-125-generic (b=
uildd@bos02-s390x-015) (gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1)) =
#141-Ubuntu SMP=C2=A0</div><div><br></div><div>which is running under qemu =
(version=C2=A06.2.0 (Debian 1:6.2+dfsg-2ubuntu6.6)</div><div><br></div><div=
>Is running=C2=A0 zipl_helper.device-mapper=C2=A0under qemu possible ?</div=
><div><br></div><div>If it is, here are the details :</div><div><br></div><=
div>---------------------</div><div>sudo zipl</div><div><br></div><div>I am=
 receiving the following errors=C2=A0</div><div>:</div><div>Using config fi=
le &#39;/etc/zipl.conf&#39;<br>Building bootmap in &#39;/mnt/vdb/boot&#39;<=
br>Adding IPL section &#39;ubuntu&#39; (default)<br>Run /lib/s390-tools/zip=
l_helper.device-mapper /mnt/vdb/boot<br>Error: Could not retrieve device-ma=
pper information for device &#39;vdb&#39; &lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&=
lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;=
<br>Error: Could not add image file &#39;/home/mike/kernel/hello-kernel&#39=
;: Script could not determine target parameters<br></div><div><br></div><di=
v><br></div><div>------------ etc/zipl.conf</div><div>[defaultboot]<br>defa=
ult=3Dubuntu<br><br>[ubuntu]<br>target=3D/mnt/vdb/boot<br>image=3D/home/mik=
e/kernel/hello-kernel<br>ramdisk=3D /home/mike/kernel/initrd.img<br></div><=
div><br></div><div>-------------=C2=A0 lsblk ----------------<br></div><div=
>NAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0MAJ:MIN RM =C2=A0SIZE RO TYPE MOUNTPOINT<br>loop0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 7:0 =C2=A0 =C2=
=A00 53.4M =C2=A01 loop /snap/core20/1613<br>loop1 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 7:1 =C2=A0 =C2=A00 54.=
6M =C2=A01 loop /snap/core20/1853<br>loop2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 7:2 =C2=A0 =C2=A00 =C2=A0 59M=
 =C2=A01 loop /snap/lxd/22755<br>loop3 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 7:3 =C2=A0 =C2=A00 46.4M =C2=A01 =
loop /snap/snapd/18599<br>loop4 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 7:4 =C2=A0 =C2=A00 77.8M =C2=A01 loop /s=
nap/lxd/24063<br>vda =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 252:0 =C2=A0 =C2=A00 =C2=A0 =C2=A05G =C2=A00 disk<=
br>=E2=94=9C=E2=94=80vda1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0252:1 =C2=A0 =C2=A00 =C2=A01.8G =C2=A00 part<br>=E2=94=
=94=E2=94=80vda2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0252:2 =C2=A0 =C2=A00 =C2=A03.3G =C2=A00 part<br>=C2=A0 =E2=94=
=94=E2=94=80ubuntu--vg-ubuntu--lv 253:0 =C2=A0 =C2=A00 =C2=A03.3G =C2=A00 l=
vm =C2=A0/</div><div><br>vdb =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 252:16 =C2=A0 0 =C2=A0100M =C2=A00 disk /mn=
t/vdb &lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;<br><=
/div><div><br></div><div><br></div></div>

--00000000000030bec105f953f822--

--===============7057088281565381345==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============7057088281565381345==--

