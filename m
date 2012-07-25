From: Gaurav Mahajan <gauravmahajan2007@gmail.com>
Subject: Dm-mirror Issue
Date: Wed, 25 Jul 2012 14:28:12 +0530
Message-ID: <CAEfaOmhqN=ifxMnuYphdAiWzrwP4qfGW+ViYziFmwLEvRSXwDA@mail.gmail.com>
References: <CAEfaOmgBJ32kjNAY57=k7p+PfnsTRMRCvujK=KOW-XpcscR8DA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4923163289569759185=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAEfaOmgBJ32kjNAY57=k7p+PfnsTRMRCvujK=KOW-XpcscR8DA@mail.gmail.com>
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

--===============4923163289569759185==
Content-Type: multipart/alternative; boundary=bcaec51824f4c0de5504c5a3ada1

--bcaec51824f4c0de5504c5a3ada1
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I want to run Dm-raid1 or dm-mirror in degraded mode.

So say I have 2 Disks (loop devices) and I create a mirror device over that
(using dmsetup).
Create EXT4 over the new device, mounted it and started a huge number of IO
using dd on that device.
Now while the IO are going on, I failed the 'Default' Mirror in the mirror
set.

Then ideally the IO operation should not break. All the IO should go to
other mirror.
But it is not happening. Either my dd command hangs till the default device
comes back or it returns an IO error
and breaks the IO operations on disk.

Is this is known behavior ?
Or
I am missing something in configuration ?

I tried disabling initial sync, but still it is behaving same.

I am using Kernel 2.6.32.
Mirror target's version is 1.12.0

Please help !

Thanks,
Gaurav

--bcaec51824f4c0de5504c5a3ada1
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote"><div class=3D"gmail_quote">Hi,<br><br>I want to =
run Dm-raid1 or dm-mirror in degraded mode. <br><br>So say I have 2 Disks (=
loop devices) and I create a mirror device over that (using dmsetup).<br>Cr=
eate EXT4 over the new device, mounted it and started a huge number of IO u=
sing dd on that device.<br>



Now while the IO are going on, I failed the &#39;Default&#39; Mirror in the=
 mirror set.<br><br>Then ideally the IO operation should not break. All the=
 IO should go to other mirror.<br>But it is not happening. Either my dd com=
mand hangs till the default device comes back or it returns an IO error <br=
>



and breaks the IO operations on disk.<br><br>Is this is known behavior ? <b=
r>Or<br>I am missing something in configuration ?<br><br>I tried disabling =
initial sync, but still it is behaving same.<br><br>I am using Kernel 2.6.3=
2. <br>


Mirror target&#39;s version is 1.12.0 <br><br>Please help !<br>
<br>Thanks,<br>Gaurav=20
</div><br>
</div><br>

--bcaec51824f4c0de5504c5a3ada1--


--===============4923163289569759185==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4923163289569759185==--
