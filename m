From: Devin <delldudedevin@gmail.com>
Subject: Multipath / iSCSI issues
Date: Sun, 24 Feb 2013 12:15:52 -0700
Message-ID: <CAEctU6r9dnVnaMFgzO+8g0ktJ2VFTCaN47NiR5F4QH16_iX53g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7470880183696505901=="
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

--===============7470880183696505901==
Content-Type: multipart/alternative; boundary=bcaec54c50f0c108ac04d67d40f8

--bcaec54c50f0c108ac04d67d40f8
Content-Type: text/plain; charset=ISO-8859-1

I am running Oracle Enterprise Linux 5.8 (which is really just Redhat). I
am using Multipath and I have LUNS presented to me via iSCSI from a Hitachi
SAN. I have the NICS bonded using the Linux bonding driver and using
Active-Backup mode. I notice that when I loose a switch or connection to
one of the switches that multipath freezes for at least 60 seconds before
it starts to respond again. Also it appears that IO being generated freezes
until multipath responds again, this pause up to 60 seconds is causing my
Oracle instances to crash.

I have not been able to easily find what settings i could possibly change
to make it fail to a new path faster. It almost seems like it's taking
multipath a bit to fail all IO to a new path that is working.

Is there any information that might be useful for me that I can check on
either the multipath side or the iSCSI side to see what is causing the
issue???

--bcaec54c50f0c108ac04d67d40f8
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div style>I am running Oracle Enterprise Linux 5.8 (w=
hich is really just Redhat). I am using Multipath and I have LUNS presented=
 to me via iSCSI from a Hitachi SAN. I have the NICS bonded using the Linux=
 bonding driver and using Active-Backup mode. I notice that when I loose a =
switch or connection to one of the switches that multipath freezes for at l=
east 60 seconds before it starts to respond again. Also it appears that IO =
being generated freezes until multipath responds again, this pause up to 60=
 seconds is causing my Oracle instances to crash.</div>
<div style><br></div><div style>I have not been able to easily find what se=
ttings i could possibly change to make it fail to a new path faster. It alm=
ost seems like it&#39;s taking multipath a bit to fail all IO to a new path=
 that is working.</div>
<div style><br></div><div style>Is there any information that might be usef=
ul for me that I can check on either the multipath side or the iSCSI side t=
o see what is causing the issue???</div><div style><br></div></div>

--bcaec54c50f0c108ac04d67d40f8--


--===============7470880183696505901==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7470880183696505901==--
