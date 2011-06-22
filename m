From: Feng Shuo <steve.shuo.feng@gmail.com>
Subject: Re: Read balance of dm-raid1
Date: Wed, 22 Jun 2011 11:26:00 +0800
Message-ID: <BANLkTiku99afPkeRnGQ2hU104ukh2nUx3g@mail.gmail.com>
References: <BANLkTikLLEfb83GQdkqNFT6tJJYNvYwB6w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5409587765601719329=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BANLkTikLLEfb83GQdkqNFT6tJJYNvYwB6w@mail.gmail.com>
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

--===============5409587765601719329==
Content-Type: multipart/alternative; boundary=bcaec520e7333eaec204a644883e

--bcaec520e7333eaec204a644883e
Content-Type: text/plain; charset=ISO-8859-1

Any comments? If the read balance is still part of our long term goal, I can
help to do some development.

On Fri, Jun 17, 2011 at 22:47, Feng Shuo <steve.shuo.feng@gmail.com> wrote:

> Hi all,
>
> I installed RHEL 6 and found that its dm-raid1 only used one disk for all
> reads. In RHEL5, the reads should be balanced between all the disks. Is
> there any special concerns for disabling that? Data safe or consistency?
>
> I googled and found there should be a read balance patch. Is that out of
> maintained in new kernels?
>
> --
> Feng Shuo
> Tel: (86)10-59851155-2116
> Fax: (86)10-59851155-2008
> Tianjin Zhongke Blue Whale Information Technologies Co., Ltd
> Postcode 100080
> 10th Floor, Tower A, The GATE building, No. 19 Zhong-guan-cun Avenue
> Haidian District, Beijing
>



-- 
Feng Shuo
Tel: (86)10-59851155-2116
Fax: (86)10-59851155-2008
Tianjin Zhongke Blue Whale Information Technologies Co., Ltd
Postcode 100080
10th Floor, Tower A, The GATE building, No. 19 Zhong-guan-cun Avenue
Haidian District, Beijing

--bcaec520e7333eaec204a644883e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Any comments? If the read balance is still part of our long term goal, I ca=
n help to do some development.<br><br><div class=3D"gmail_quote">On Fri, Ju=
n 17, 2011 at 22:47, Feng Shuo <span dir=3D"ltr">&lt;<a href=3D"mailto:stev=
e.shuo.feng@gmail.com">steve.shuo.feng@gmail.com</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex;">Hi all,<br><br>I installed RHEL 6 and found=
 that its dm-raid1 only used one disk for all reads. In RHEL5, the reads sh=
ould be balanced between all the disks. Is there any special concerns for d=
isabling that? Data safe or consistency?<br>


<br>I googled and found there should be a read balance patch. Is that out o=
f maintained in new kernels?<br clear=3D"all"><font color=3D"#888888"><br>-=
- <br>Feng Shuo<br>Tel: (86)10-59851155-2116<br>Fax: (86)10-59851155-2008<b=
r>

Tianjin Zhongke Blue Whale Information Technologies Co., Ltd<br>
Postcode 100080<br>10th Floor, Tower A, The GATE building, No. 19 Zhong-gua=
n-cun Avenue<br>Haidian District, Beijing<br>
</font></blockquote></div><br><br clear=3D"all"><br>-- <br>Feng Shuo<br>Tel=
: (86)10-59851155-2116<br>Fax: (86)10-59851155-2008<br>Tianjin Zhongke Blue=
 Whale Information Technologies Co., Ltd<br>Postcode 100080<br>10th Floor, =
Tower A, The GATE building, No. 19 Zhong-guan-cun Avenue<br>

Haidian District, Beijing<br>

--bcaec520e7333eaec204a644883e--


--===============5409587765601719329==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5409587765601719329==--
