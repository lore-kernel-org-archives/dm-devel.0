From: Sotirios-Efstathios Maneas <smaneas@cs.toronto.edu>
Subject: Dm-flakey Module
Date: Sun, 12 Aug 2018 20:54:49 -0400
Message-ID: <91F1B2B0-A10A-4BE8-8EC6-28818609F0CA@cs.toronto.edu>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Content-Type: multipart/mixed; boundary="===============5452813803102494727=="
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


--===============5452813803102494727==
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_D0FAAC21-04BD-4495-A306-C3F725532F72"


--Apple-Mail=_D0FAAC21-04BD-4495-A306-C3F725532F72
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Dear developers,

My name is Stathis Maneas and currently, I am graduate student at the =
University of Toronto, conducting research on systems' reliability.

Based on the source code of dm-flakey (as found in the latest version of =
the Linux kernel), if I may, I would like to kindly clarify an =
implementation detail
regarding the flakey_map() function. Specifically, I would like to find =
out what's the difference between simply returning DM_MAPIO_KILL against =
returning
DM_MAPIO_SUBMITTED after invoking bio_io_error(bio).

Thanks a lot in advance and I look forward to your response.

Kind regards,
Stathis Maneas


--Apple-Mail=_D0FAAC21-04BD-4495-A306-C3F725532F72
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; =
charset=3Dus-ascii"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; line-break: after-white-space;" class=3D""><div =
class=3D"">Dear developers,</div><div class=3D""><br class=3D""></div><div=
 class=3D"">My name is Stathis Maneas and currently, I am graduate =
student at the University of Toronto, conducting research on systems' =
reliability.</div><div class=3D""><br class=3D""></div><div =
class=3D"">Based on the source code of dm-flakey (as found in the latest =
version of the Linux kernel), if I may, I would like to kindly clarify =
an implementation detail</div><div class=3D"">regarding the <i =
class=3D"">flakey_map()</i> function. Specifically, I would like to find =
out what's the difference between simply returning <i =
class=3D"">DM_MAPIO_KILL</i> against returning</div><div class=3D""><i =
class=3D"">DM_MAPIO_SUBMITTED</i> after invoking <i =
class=3D"">bio_io_error(bio)</i>.</div><div class=3D""><br =
class=3D""></div><div class=3D"">Thanks a lot in advance and I look =
forward to your response.</div><div class=3D""><br class=3D""></div><div =
class=3D"">Kind regards,</div><div class=3D"">Stathis Maneas</div><div =
class=3D""><br class=3D""></div></body></html>=

--Apple-Mail=_D0FAAC21-04BD-4495-A306-C3F725532F72--


--===============5452813803102494727==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5452813803102494727==--
