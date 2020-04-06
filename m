From: Drew Hastings <dhastings@crucialwebhost.com>
Subject: Unused functions in dm-thin-metadata
Date: Sun, 5 Apr 2020 17:02:18 -0700
Message-ID: <CAN-y+EKqXowOufjVs=BKwZQc+HFMk1_iQ-+H+oisK6D+eBGp3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5862764533587911920=="
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

--===============5862764533587911920==
Content-Type: multipart/alternative; boundary="000000000000a525b705a293fb68"

--000000000000a525b705a293fb68
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Not super important, but both dm_thin_remove_block and __remove are unused.
I'm assuming this is because at some point the remove_range logic was
implemented.

--000000000000a525b705a293fb68
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Not super important, but both=C2=A0dm_thin_remove_block an=
d=C2=A0__remove are unused. I&#39;m assuming this is because at some point =
the remove_range logic was implemented.</div>

--000000000000a525b705a293fb68--

--===============5862764533587911920==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5862764533587911920==--
