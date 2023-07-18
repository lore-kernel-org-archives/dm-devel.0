Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B3E6C3DA41
	for <dm-devel@archiver.kernel.org>; Wed, 19 Jul 2023 07:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689750200;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=RHKWDfwwf8NVZp5dEqppX2VQyLVrN/KCDm3OTwydBy4=;
	b=NH5v2tIRzo3NI0Ueq3N0AHyyo55EguJ5SX8QiHMUSEuqk6DGnrZcd7kn6FKkilBZsZpAci
	ftPWVHb2x+LGqDWxKsxz9DKK3wC4o7Ndk2jH/3XNaVhhdsAYzTkHYGL8KG8dTkxI42vZkx
	MZa1eeOtVXHWtITsifHM+AGvSk1LxuU=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-e_oQYrLeOLW-jQreoVwMfg-1; Wed, 19 Jul 2023 03:03:16 -0400
X-MC-Unique: e_oQYrLeOLW-jQreoVwMfg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B09343C0FC86;
	Wed, 19 Jul 2023 07:03:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BA9B040C6F4C;
	Wed, 19 Jul 2023 07:03:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 108AB1946A45;
	Wed, 19 Jul 2023 07:03:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7C687194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Jul 2023 14:55:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 37E85F66D6; Tue, 18 Jul 2023 14:55:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EB08F66D0
 for <dm-devel@redhat.com>; Tue, 18 Jul 2023 14:55:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A20553C02B42
 for <dm-devel@redhat.com>; Tue, 18 Jul 2023 14:52:54 +0000 (UTC)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-29-wIRoqcsNMNWUTBbPucJqRw-1; Tue,
 18 Jul 2023 10:52:50 -0400
X-MC-Unique: wIRoqcsNMNWUTBbPucJqRw-1
Received: from [127.0.0.1] ([217.45.175.207]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.163]) with ESMTPSA (Nemesis) id
 1MYeV1-1qPwwt0aG3-00VfP4; Tue, 18 Jul 2023 16:47:12 +0200
Date: Tue, 18 Jul 2023 15:47:11 +0100
From: Chris <chris@2net.co.uk>
To: "Alan C. Assis" <acassis@gmail.com>,
 =?ISO-8859-1?Q?Bj=F8rn_Forsman?= <bjorn.forsman@gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CAG4Y6eTN1XbZ_jAdX+t2mkEN=KoNOqprrCqtX0BVfaH6AxkdtQ@mail.gmail.com>
References: <20230717075035.GA9549@tomerius.de>
 <CAG4Y6eTU=WsTaSowjkKT-snuvZwqWqnH3cdgGoCkToH02qEkgg@mail.gmail.com>
 <20230718053017.GB6042@tomerius.de>
 <CAEYzJUGC8Yj1dQGsLADT+pB-mkac0TAC-typAORtX7SQ1kVt+g@mail.gmail.com>
 <CAG4Y6eTN1XbZ_jAdX+t2mkEN=KoNOqprrCqtX0BVfaH6AxkdtQ@mail.gmail.com>
Message-ID: <D2686589-496B-4257-953A-4B19F2B70E0C@2net.co.uk>
MIME-Version: 1.0
X-Provags-ID: V03:K1:hRDkTpm7gTMXdpeJUNkk2NzXtgzo51lotWfD37lO/B/7hyFnp9+
 CFL+Vw/6H9RpGSjBDebqUnvh5et/0VjcMdY94HS7kDyBQcP5UD0GUE1dQ/cHhXwhHSbcAmD
 efedEY7G1ENHhu55JR2wtS0333w213fA0H41XivquebQcfLVVWqB8aPmnnAYI8j74UsotfG
 CrA48FD2LSokkzHYpuFVQ==
UI-OutboundReport: notjunk:1;M01:P0:q3dsbaYri6E=;ZfgvoacfjKqeuf0jtqEf07aYgHa
 mgdv4jErRjtH3y/e8lo/UvakbGpC63hRKg2DwAGuqjkHIOj5Qi5gI2YGKlFgmBlmeruUto2Ra
 BEczHaU3AnymkRhPKFqFt9i5n3kE9FbP9SknMjBQ9M1fqpGqogPcGkHp8SXJ9GMQVQCRGMS5/
 33z7GsGKkaAs/JxbhQflkibrzAL1VHbrVwhiW9wNWcB67OyXxdynmrllvNVwlp0kkPco+Gw4t
 0kL4q+8QLSrH17SwCjcT8ElOCvO6QsvKe7SsuJuC73x5JLZzSImeqMDC499QVnN+QqZQiwg/v
 GqLvA8bL3T+qhkAo78BRWZyh6B4Xzld7SLe7Dxbfyg0H8D9s9tgRrZglvPVFkrDZD85tbCJnK
 CAmEtp0K0GID9BFgGzI/4r01PHgL3ZuGe1eTi8UGTsoKI9n2qzfQRF9rauJ0LQT4i9+oe7uy2
 blHP2/Gvs+f2laeE0fvp3dJtMdxH8/nOhJCutIE2/P4iTdmxozf/dfC8L62YXbI6CPD+PbvrX
 ykcRWpsGGeZEfbbnbWmwltAHGrPvigJjPV+zN7vPPbkxBCnQROw4uzHsIpPKbkpXHfJDBfYZ9
 YThf44FDw2eLFHtgaUCo2thZiSaNU8JF0I5vQ7IHTrN4OsICNfJDP2gjtDL7rG53Oaoa1yJyZ
 4zuSOpg6vTTUqxBCwyyI4AIH56Jrwzx4yF4nwxp1og==
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Wed, 19 Jul 2023 07:03:10 +0000
Subject: Re: [dm-devel] File system robustness
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
Cc: dm-devel@redhat.com, Ext4 Developers List <linux-ext4@vger.kernel.org>,
 linux-embedded@vger.kernel.org, Kai Tomerius <kai@tomerius.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: 2net.co.uk
Content-Type: multipart/mixed; boundary="===============0783258445600451674=="

--===============0783258445600451674==
Content-Type: multipart/alternative;
 boundary=----VHMVYPN98JDOVKGMDMX1TYSRUHLC71

------VHMVYPN98JDOVKGMDMX1TYSRUHLC71
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Bj=C3=B8rn,

If I may summarize, for Linux with raw NAND flash, your main option is UBIF=
S. You can also use UBI + squashfs if you really want to save space

For Linux with managed flash (e.g. eMMC or UFS), most people go with EXT4 o=
r F2FS

HTH,
Chris

On 18 July 2023 14:04:55 BST, "Alan C. Assis" <acassis@gmail.com> wrote:
>Hi Bj=C3=B8rn,
>
>On 7/18/23, Bj=C3=B8rn Forsman <bjorn.forsman@gmail.com> wrote:
>> On Tue, 18 Jul 2023 at 08:03, Kai Tomerius <kai@tomerius.de> wrote:
>>> I should have mentioned that I'll have a large NAND flash, so ext4
>>> might still be the file system of choice. The other ones you mentioned
>>> are interesting to consider, but seem to be more fitting for a smaller
>>> NOR flash.
>>
>> If you mean raw NAND flash I would think UBIFS is still the way to go?
>> (It's been several years since I was into embedded Linux systems.)
>>
>> https://elinux.org/images/0/02/Filesystem_Considerations_for_Embedded_De=
vices.pdf
>> is focused on eMMC/SD Cards, which have built-in controllers that
>> enable them to present a block device interface, which is very unlike
>> what raw NAND devices have.
>>
>> Please see https://www.kernel.org/doc/html/latest/filesystems/ubifs.html
>> for more info.
>>
>
>You are right, for NAND there is an old (but gold) presentation here:
>
>https://elinux.org/images/7/7e/ELC2009-FlashFS-Toshiba.pdf
>
>UBIFS and YAFFS2 are the way to go.
>
>But please note that YAFFS2 needs license payment for commercial
>application (something that I only discovered recently when Xiaomi
>integrated it into NuttX mainline, bad surprise).
>
>BR,
>
>Alan

------VHMVYPN98JDOVKGMDMX1TYSRUHLC71
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div dir=3D"auto">Hi Bj=C3=B8rn,<br><br>If I may s=
ummarize, for Linux with raw NAND flash, your main option is UBIFS. You can=
 also use UBI + squashfs if you really want to save space<br><br>For Linux =
with managed flash (e.g. eMMC or UFS), most people go with EXT4 or F2FS<br>=
<br>HTH,<br>Chris</div><br><br><div class=3D"gmail_quote"><div dir=3D"auto"=
>On 18 July 2023 14:04:55 BST, "Alan C. Assis" &lt;acassis@gmail.com&gt; wr=
ote:</div><blockquote class=3D"gmail_quote" style=3D"margin: 0pt 0pt 0pt 0.=
8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;">
<pre class=3D"k9mail"><div dir=3D"auto">Hi Bj=C3=B8rn,<br><br>On 7/18/23, B=
j=C3=B8rn Forsman &lt;bjorn.forsman@gmail.com&gt; wrote:<br></div><blockquo=
te class=3D"gmail_quote" style=3D"margin: 0pt 0pt 1ex 0.8ex; border-left: 1=
px solid #729fcf; padding-left: 1ex;"><div dir=3D"auto">On Tue, 18 Jul 2023=
 at 08:03, Kai Tomerius &lt;kai@tomerius.de&gt; wrote:<br></div><blockquote=
 class=3D"gmail_quote" style=3D"margin: 0pt 0pt 1ex 0.8ex; border-left: 1px=
 solid #ad7fa8; padding-left: 1ex;"><div dir=3D"auto">I should have mention=
ed that I'll have a large NAND flash, so ext4<br>might still be the file sy=
stem of choice. The other ones you mentioned<br>are interesting to consider=
, but seem to be more fitting for a smaller<br>NOR flash.<br></div></blockq=
uote><div dir=3D"auto"><br> If you mean raw NAND flash I would think UBIFS =
is still the way to go?<br> (It's been several years since I was into embed=
ded Linux systems.)<br><br> <a href=3D"https://elinux.org/images/0/02/Files=
ystem_Considerations_for_Embedded_Devices.pdf">https://elinux.org/images/0/=
02/Filesystem_Considerations_for_Embedded_Devices.pdf</a><br> is focused on=
 eMMC/SD Cards, which have built-in controllers that<br> enable them to pre=
sent a block device interface, which is very unlike<br> what raw NAND devic=
es have.<br><br> Please see <a href=3D"https://www.kernel.org/doc/html/late=
st/filesystems/ubifs.html">https://www.kernel.org/doc/html/latest/filesyste=
ms/ubifs.html</a><br> for more info.<br><br></div></blockquote><div dir=3D"=
auto"><br>You are right, for NAND there is an old (but gold) presentation h=
ere:<br><br><a href=3D"https://elinux.org/images/7/7e/ELC2009-FlashFS-Toshi=
ba.pdf">https://elinux.org/images/7/7e/ELC2009-FlashFS-Toshiba.pdf</a><br><=
br>UBIFS and YAFFS2 are the way to go.<br><br>But please note that YAFFS2 n=
eeds license payment for commercial<br>application (something that I only d=
iscovered recently when Xiaomi<br>integrated it into NuttX mainline, bad su=
rprise).<br><br>BR,<br><br>Alan<br></div></pre></blockquote></div></body></=
html>
------VHMVYPN98JDOVKGMDMX1TYSRUHLC71--

--===============0783258445600451674==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============0783258445600451674==--

