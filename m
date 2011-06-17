From: Feng Shuo <steve.shuo.feng@gmail.com>
Subject: Read balance of dm-raid1
Date: Fri, 17 Jun 2011 22:47:01 +0800
Message-ID: <BANLkTikLLEfb83GQdkqNFT6tJJYNvYwB6w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7249152218223237649=="
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

--===============7249152218223237649==
Content-Type: multipart/alternative; boundary=bcaec520e733acc5e704a5e976ea

--bcaec520e733acc5e704a5e976ea
Content-Type: text/plain; charset=ISO-8859-1

Hi all,

I installed RHEL 6 and found that its dm-raid1 only used one disk for all
reads. In RHEL5, the reads should be balanced between all the disks. Is
there any special concerns for disabling that? Data safe or consistency?

I googled and found there should be a read balance patch. Is that out of
maintained in new kernels?

-- 
Feng Shuo
Tel: (86)10-59851155-2116
Fax: (86)10-59851155-2008
Tianjin Zhongke Blue Whale Information Technologies Co., Ltd
Postcode 100080
10th Floor, Tower A, The GATE building, No. 19 Zhong-guan-cun Avenue
Haidian District, Beijing

--bcaec520e733acc5e704a5e976ea
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi all,<br><br>I installed RHEL 6 and found that its dm-raid1 only used one=
 disk for all reads. In RHEL5, the reads should be balanced between all the=
 disks. Is there any special concerns for disabling that? Data safe or cons=
istency?<br>

<br>I googled and found there should be a read balance patch. Is that out o=
f maintained in new kernels?<br clear=3D"all"><br>-- <br>Feng Shuo<br>Tel: =
(86)10-59851155-2116<br>Fax: (86)10-59851155-2008<br>Tianjin Zhongke Blue W=
hale Information Technologies Co., Ltd<br>

Postcode 100080<br>10th Floor, Tower A, The GATE building, No. 19 Zhong-gua=
n-cun Avenue<br>Haidian District, Beijing<br>

--bcaec520e733acc5e704a5e976ea--


--===============7249152218223237649==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7249152218223237649==--
