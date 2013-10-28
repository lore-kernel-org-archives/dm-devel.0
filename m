From: siju george <siju.george@gmail.com>
Subject: generic_make_request() sleep
Date: Mon, 28 Oct 2013 11:46:20 -0700
Message-ID: <CAFkbBycdTn0CUoXWZooRjvPzCppksNsb3LgVTE+_QPw-o2QVqw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5587664713871803315=="
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

--===============5587664713871803315==
Content-Type: multipart/alternative; boundary=bcaec520ea79225a1204e9d1848b

--bcaec520ea79225a1204e9d1848b
Content-Type: text/plain; charset=ISO-8859-1

Hello,

I am new to device-mapper and block layer. In my device mapper driver I use
generic_make_request() function to pass the bio to lower layer. But I see
this function wait for IO for most of the time that cause my driver
throughput be very low. The IOs my driver pass down is all 4K size.

Could someone please help me or point me to some documentation to
understand this issue? Shouldn't this function be returning immediately as
I am passing the completion function along with the bio ?

Thanks in advance,
-Siju

--bcaec520ea79225a1204e9d1848b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<div><br></div><div>I am new to device-mapper and bl=
ock layer. In my device mapper driver I use generic_make_request() function=
 to pass the bio to lower layer. But I see this function wait for IO for mo=
st of the time that cause my driver throughput be very low. The IOs my driv=
er pass down is all 4K size.=A0</div>
<div><br></div><div>Could someone please help me or point me to some docume=
ntation to understand this issue? Shouldn&#39;t this function be returning =
immediately as I am passing the completion function along with the bio ?</d=
iv>
<div><br></div><div>Thanks in advance,</div><div>-Siju=A0</div></div>

--bcaec520ea79225a1204e9d1848b--


--===============5587664713871803315==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5587664713871803315==--
