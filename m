From: Oliver Rojo <oliver.rojo@gmail.com>
Subject: [fail][unknown] error on multipath
Date: Thu, 21 Jun 2012 20:02:51 +0800
Message-ID: <CAD8ONkA_yPkyE-d6_YeB0GPWLh3F+L-RPJQV5LCV3mRddPvN8A@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2396293936760834939=="
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

--===============2396293936760834939==
Content-Type: multipart/alternative; boundary=e0cb4efe326c8c57df04c2fa4bf4

--e0cb4efe326c8c57df04c2fa4bf4
Content-Type: text/plain; charset=ISO-8859-1

hi,

Would like to seek support on my current problem. We are currently running
a NFS server on a clustered environment under RHEL 5.6. LUN disks are being
presented into both cluster nodes via DM-Multipathing which is being used
as NFS share. However, everytime I am testing NFS package failover,
failover always fails and upon checking the multipath (multipath -ll), it
shows that the LUN disk affected has "[fail][unknown]" error. The only
workaround that is being done is to present/unpresent the LUN disk to have
it [ready][undef] state.

Thank you!

Oliver

--e0cb4efe326c8c57df04c2fa4bf4
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>hi,</div>
<div>=A0</div>
<div>Would like to seek support on my current problem. We are currently run=
ning a NFS server on a clustered environment under RHEL 5.6. LUN disks are =
being presented into both cluster nodes via DM-Multipathing which is being =
used as NFS share. However, everytime=A0I am testing NFS package failover, =
failover always fails and upon checking the multipath (multipath -ll), it s=
hows that the LUN disk affected has &quot;[fail][unknown]&quot; error. The =
only workaround that is being done is to present/unpresent the LUN disk to =
have it [ready][undef] state.</div>

<div>=A0</div>
<div>Thank you!</div>
<div>=A0</div>
<div>Oliver</div>

--e0cb4efe326c8c57df04c2fa4bf4--


--===============2396293936760834939==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2396293936760834939==--
