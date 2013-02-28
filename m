From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: [Question] Is there any mean to know a bio split is the
 last one in the original bio?
Date: Thu, 28 Feb 2013 19:56:06 +0900
Message-ID: <CABmKtjf7sVhBUGF-JgfcSkkhh6iKcK+cmXHZT2-xQzUPmQLrRA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4879552498644658904=="
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

--===============4879552498644658904==
Content-Type: multipart/alternative; boundary=e0cb4efe3306d87d0304d6c6bcb8

--e0cb4efe3306d87d0304d6c6bcb8
Content-Type: text/plain; charset=ISO-8859-1

Hi, I am Akira.
Nice to meet you.
I will post a question for your help.

I have been developing a caching module now
https://github.com/akiradeveloper/dm-lc

and facing a big design problem related to handling REQ_FUA flag.

Suppose we have 4KB split_io and
the original bio is 8KB with REQ_FUA flag.

The device-mapper dm_request function now
splits the original one into two 4KB sized bios with REQ_FUA and
then passes them to map function one by one.
This eventually leads to inefficient code in my case.

All I want to do is flushing the preceding split bios at last but
I know that is not always the most efficient implementation in any dm
modules and
that's why device-mapper is what it is like now.

My question is
Is there any mean to know the second bio split is the last one in the split
sequence?

I need your help.
Thanks.

Akira Hayakawa

--e0cb4efe3306d87d0304d6c6bcb8
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi, I am Akira.<div>Nice to meet you.</div><div>I will post a question for =
your help.<br><div><br></div><div>I have been developing a caching module n=
ow</div><div><a href=3D"https://github.com/akiradeveloper/dm-lc">https://gi=
thub.com/akiradeveloper/dm-lc</a></div>
<div><br></div><div>and facing a big design problem related to handling REQ=
_FUA flag.</div><div><br></div><div>Suppose we have 4KB split_io and</div><=
div>the original bio is 8KB with REQ_FUA flag.</div><div><br></div><div>
The device-mapper dm_request function now</div><div>splits the original one=
 into two 4KB sized bios with REQ_FUA and</div><div>then passes them to map=
 function one by one.</div><div>This eventually leads to inefficient code i=
n my case.</div>
<div><br></div><div>All I want to do is flushing the preceding split bios a=
t last but</div><div>I know that is not always the most efficient implement=
ation in any dm modules and</div><div>that&#39;s why device-mapper is what =
it is like now.</div>
<div><br></div><div>My question is</div><div>Is there any mean to know the =
second bio split is the last one in the split sequence?</div><div><br></div=
><div>I need your help.</div><div>Thanks.</div><div><br></div><div>Akira Ha=
yakawa</div>
</div>

--e0cb4efe3306d87d0304d6c6bcb8--


--===============4879552498644658904==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4879552498644658904==--
