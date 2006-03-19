From: "Abhishek Gupta" <abhishekgupt@gmail.com>
Subject: Calling bio_endio() without completing submit_bio()
Date: Sun, 19 Mar 2006 12:14:37 -0800
Message-ID: <5055b5c00603191214m7f3159b0i75da0232c128fd4e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1138392439=="
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

--===============1138392439==
Content-Type: multipart/alternative;
	boundary="----=_Part_7326_31090040.1142799277403"

------=_Part_7326_31090040.1142799277403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi everyone,

Does anyone know if it is possible to make a call to bio_endio() while we
are still executing a submit_bio()? For example, a call to submit_bio() on =
a
virtual device backed by the device mapper would end up in a call to the
dm_request() function, which would eventually end up in a call to
ti->type->map() in __map_bio() function. Is it valid to call bio_endio()
from the map() function for individual target types?

Let me know if I am totally crazy.

Thanks

Abhishek Gupta
Graduate Student 2nd Year
Department of Computer Science,
UBC, Vancouver, Canada.

------=_Part_7326_31090040.1142799277403
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi everyone,<br>
<br>
Does anyone know if it is possible to make a call to bio_endio() while
we are still executing a submit_bio()? For example, a call to
submit_bio() on a virtual device backed by the device mapper would end
up in a call to the dm_request() function, which would eventually end
up in a call to ti-&gt;type-&gt;map() in __map_bio() function. Is it
valid to call bio_endio() from the map() function for individual target
types? <br>
<br>
Let me know if I am totally crazy.<br>
<br>
Thanks<br>
<br>
Abhishek Gupta<br>
Graduate Student 2nd Year<br>
Department of Computer Science,<br>
UBC, Vancouver, Canada.<br>
<br>
<br>

------=_Part_7326_31090040.1142799277403--


--===============1138392439==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1138392439==--
