From: Drew Hastings <dhastings@crucialwebhost.com>
Subject: Re: multipath target and non-request-stackable devices
Date: Wed, 31 Oct 2018 17:47:26 -0700
Message-ID: <CAN-y+EJ7QGF5FeObYuinHHS4FKvJLcmVY87UyEGOK88P6KDX9A@mail.gmail.com>
References: <CAN-y+EKcNSQL5_eFD1iuJeyUfk7UApgWWA_Vj72TKQN7-a_kVw@mail.gmail.com>
	<20181031221402.GA22981@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4032817620532692162=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181031221402.GA22981@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============4032817620532692162==
Content-Type: multipart/alternative; boundary="000000000000e404ed05798fc304"

--000000000000e404ed05798fc304
Content-Type: text/plain; charset="UTF-8"

Perfect, thank you!

For what it's worth, the error did not happen with regular, locally
attached NVME devices. It only occurred with NVMEoF devices, with the
chelsio driver shipped with the kernel. You seemed to discuss this a bit in
https://www.redhat.com/archives/dm-devel/2016-June/msg00430.html

Anyway, this solves it for me. Thanks again!

--000000000000e404ed05798fc304
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">Perfect, thank you!<div><br></div><div>Fo=
r what it&#39;s worth, the error did not happen with regular, locally attac=
hed NVME devices. It only occurred with NVMEoF devices, with the chelsio dr=
iver shipped with the kernel. You seemed to discuss this a bit in=C2=A0<a h=
ref=3D"https://www.redhat.com/archives/dm-devel/2016-June/msg00430.html">ht=
tps://www.redhat.com/archives/dm-devel/2016-June/msg00430.html</a></div><di=
v><br></div><div>Anyway, this solves it for me. Thanks again!</div></div></=
div>

--000000000000e404ed05798fc304--


--===============4032817620532692162==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4032817620532692162==--
