From: Locane <locane@gmail.com>
Subject: Dumb question; please help
Date: Wed, 6 May 2015 10:45:11 -0700
Message-ID: <CAC5dixFNZ_FBQ8osQiCgDuvXrWBNydC2A173o4RfYqcWCX814Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4491042878076625430=="
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

--===============4491042878076625430==
Content-Type: multipart/alternative; boundary=001a1142612251ad3b05156d5b9e

--001a1142612251ad3b05156d5b9e
Content-Type: text/plain; charset=UTF-8

Hello, I apologize in advance for asking this question, but I can't seem to
find the information in documentation or anything online.

Short explanation:

- I have a CentOS 6.6 LiveCD that is dying after lots of file system thrash
- I use "dmsetup status" to check on when it's dying
- I don't know what the numbers in "dmsetup status" represent - they're not
labeled

Can anyone answer this question
<http://superuser.com/questions/900783/dmsetup-status-fields-explained> or
label the following fields for me and explain what they are?

[root@localhost ~]# dmsetup status
live-osimg-min: 0 4194304 snapshot 1272/1272 16
live-rw: 0 4194304 snapshot 7568/1048576 40

What are the <number>/<number>s?  What is the 2 digit number following them?

My LiveCD dies when the 7568 number in this example gets to the (I assume
gibabyte) 1048576 number.  Can I increase this base size?

I apologize again for asking such a rudimentary question on this mailing
list, but I am desperate.

Thanks in advance.

--001a1142612251ad3b05156d5b9e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello, I apologize in advance for asking this question, bu=
t I can&#39;t seem to find the information in documentation or anything onl=
ine.<div><br></div><div>Short explanation:</div><div><br></div><div>- I hav=
e a CentOS 6.6 LiveCD that is dying after lots of file system thrash</div><=
div>- I use &quot;dmsetup status&quot; to check on when it&#39;s dying</div=
><div>- I don&#39;t know what the numbers in &quot;dmsetup status&quot; rep=
resent - they&#39;re not labeled</div><div><br></div><div>Can anyone <a hre=
f=3D"http://superuser.com/questions/900783/dmsetup-status-fields-explained"=
>answer this question</a>=C2=A0or label the following fields for me and exp=
lain what they are?</div><div><font face=3D"monospace, monospace"><br></fon=
t></div><font face=3D"monospace, monospace">[root@localhost ~]# dmsetup sta=
tus=C2=A0</font><div><font face=3D"monospace, monospace">live-osimg-min: 0 =
4194304 snapshot 1272/1272 16=C2=A0</font></div><div><font face=3D"monospac=
e, monospace">live-rw: 0 4194304 snapshot 7568/1048576 40</font></div><div>=
<font face=3D"monospace, monospace"><br></font></div><div><font face=3D"ari=
al, helvetica, sans-serif">What are the &lt;number&gt;/&lt;number&gt;s?=C2=
=A0 What is the 2 digit number following them?</font></div><div><font face=
=3D"arial, helvetica, sans-serif"><br></font></div><div><font face=3D"arial=
, helvetica, sans-serif">My LiveCD dies when the 7568 number in this exampl=
e gets to the (I assume gibabyte) 1048576 number.=C2=A0 Can I increase this=
 base size?</font></div><div><font face=3D"arial, helvetica, sans-serif"><b=
r></font></div><div><font face=3D"arial, helvetica, sans-serif">I apologize=
 again for asking such a rudimentary question on this mailing list, but I a=
m desperate.</font></div><div><font face=3D"arial, helvetica, sans-serif"><=
br></font></div><div><font face=3D"arial, helvetica, sans-serif">Thanks in =
advance.</font></div></div>

--001a1142612251ad3b05156d5b9e--


--===============4491042878076625430==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4491042878076625430==--
