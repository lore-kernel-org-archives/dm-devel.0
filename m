From: Eyal Gordon <eyal.gordon@gmail.com>
Subject: multipath-tools make rpm failure
Date: Thu, 22 Oct 2009 10:44:25 +0200
Message-ID: <4ebf5d590910220144n37fdf3c2s870d7c22e810b252@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1927830738=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

--===============1927830738==
Content-Type: multipart/alternative; boundary=0016e6d7ea694174d00476821ace

--0016e6d7ea694174d00476821ace
Content-Type: text/plain; charset=ISO-8859-1

Hello,

I received the following error while trying to run 'make rpm' for
multipath-tools. My local git repository is a clone of the upstream master
branch from today.

# make rpm
sed -e "s/__VERSION__//" \
        multipath-tools.spec.in > multipath-tools.spec
rpmbuild -bb multipath-tools.spec
error: line 6: Empty tag: Version:
make: *** [rpm] Error 1


After looking at the Makefile and adding echo statements to debug, it seems
that a ${VERSION} variable is required for the above 'sed' statement, but it
is not defined.

Could anyone help me please?

Thanks,
 Eyal

--0016e6d7ea694174d00476821ace
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<br><br>I received the following error while trying =
to run &#39;make rpm&#39; for multipath-tools. My local git repository is a=
 clone of the upstream master branch from today.<br><br># make rpm<br>sed -=
e &quot;s/__VERSION__//&quot; \<br>
=A0=A0=A0=A0=A0=A0=A0 <a href=3D"http://multipath-tools.spec.in">multipath-=
tools.spec.in</a> &gt; multipath-tools.spec<br>rpmbuild -bb multipath-tools=
.spec<br>error: line 6: Empty tag: Version:<br>make: *** [rpm] Error 1<br><=
br><br>After looking at the Makefile and adding echo statements to debug, i=
t seems that a ${VERSION} variable is required for the above &#39;sed&#39; =
statement, but it is not defined.<br>
<br>Could anyone help me please? <br><br>Thanks,<br>=A0Eyal<br><br></div>

--0016e6d7ea694174d00476821ace--


--===============1927830738==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1927830738==--
