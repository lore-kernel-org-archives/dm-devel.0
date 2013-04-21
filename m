From: Graeme H <graeme@sudo.ca>
Subject: dm-cache vs enhanceio testing
Date: Sun, 21 Apr 2013 10:36:43 -0700
Message-ID: <CAJ4uuZb1iJzr1dePRMxU9xU3aETJsUanF6xyMLu+a_A=iHm2PA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1186257560720001255=="
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

--===============1186257560720001255==
Content-Type: multipart/alternative; boundary=089e0115f69845f05704dae265ad

--089e0115f69845f05704dae265ad
Content-Type: text/plain; charset=ISO-8859-1

Hi,

This is a quick response to *msnitzer's *comments here:

http://lwn.net/Articles/541975/



A big workload for us that I'd like to see evaluated between all potential
kernel caching solutions in the sysbench OLTP benchmark against Percona
Server or MariaDB. It is directly comparable to many of the workloads we've
got in production, and I imagine is very similar to the workloads of
numerous other shops.

For simulation purposes, it's usually sufficient to set the InnoDB buffer
pool size to some fraction of the working set size, which will force the DB
to bring work in and out of RAM. That'll allow you to conduct a repeatable
test regardless of the size of physical RAM in the system.

The other use case that I'd like to see evaluated is hosting modern,
managed filesystems (such as btrfs and zfs) on top of dm cache devices. In
the past, this was quite difficult with FlashCache, and so it'd be useful
to have examples of this in the dm cache docs, especially as it relates to
boot issues.

Thanks!
Graeme Humphries

--089e0115f69845f05704dae265ad
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div style>This is a quick response to=
=A0<b style=3D"color:rgb(0,0,0);font-family:&#39;Times New Roman&#39;;font-=
size:medium">msnitzer&#39;s </b><span style=3D"color:rgb(0,0,0);font-family=
:&#39;Times New Roman&#39;;font-size:medium">comments here:</span></div>
<div style><span style=3D"color:rgb(0,0,0);font-family:&#39;Times New Roman=
&#39;;font-size:medium"><br></span></div><div style><a href=3D"http://lwn.n=
et/Articles/541975/">http://lwn.net/Articles/541975/</a><div style=3D"width=
:16px;height:16px;display:inline-block">
=A0</div><span style=3D"color:rgb(0,0,0);font-family:&#39;Times New Roman&#=
39;;font-size:medium"><br></span></div><div style><br></div><div style>A bi=
g workload for us that I&#39;d like to see evaluated between all potential =
kernel caching solutions in the sysbench OLTP benchmark against Percona Ser=
ver or MariaDB. It is directly comparable to many of the workloads we&#39;v=
e got in production, and I imagine is very similar to the workloads of nume=
rous other shops.</div>
<div style><br></div><div style>For simulation purposes, it&#39;s usually s=
ufficient to set the InnoDB buffer pool size to some fraction of the workin=
g set size, which will force the DB to bring work in and out of RAM. That&#=
39;ll allow you to conduct a repeatable test regardless of the size of phys=
ical RAM in the system.</div>
<div style><br></div><div style>The other use case that I&#39;d like to see=
 evaluated is hosting modern, managed filesystems (such as btrfs and zfs) o=
n top of dm cache devices. In the past, this was quite difficult with Flash=
Cache, and so it&#39;d be useful to have examples of this in the dm cache d=
ocs, especially as it relates to boot issues.</div>
<div style><br></div><div style>Thanks!</div><div style>Graeme Humphries</d=
iv><div style><br></div></div>

--089e0115f69845f05704dae265ad--


--===============1186257560720001255==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1186257560720001255==--
