From: nishant mungse <nishantmungse@gmail.com>
Subject: How to find last sector of bio.
Date: Sat, 29 Jan 2011 15:16:24 -0500
Message-ID: <AANLkTi=eVMtjo593a9KSijfXMFoqewgKXGO-ADGXgzo4@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5195926968882956124=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5195926968882956124==
Content-Type: multipart/alternative; boundary=90e6ba6153de595e64049b01db77

--90e6ba6153de595e64049b01db77
Content-Type: text/plain; charset=ISO-8859-1

Hi Malahal

Is there any way to find the last sector of bio.
Is this a correct way to find last sector of bio

"bio->bi_sector=bio->bi_sector + (bio->bi_size >> 9)-1"

or

bio_for_each_segment(bvec,bio,idx)
{
 bio->bi_sector=bio->bi_sector + (bvec->bv_len >> 9) -1;
}
Will this bio->bi_sector point to last sector of bio if bio->bi_vcnt is
greater than 1.

Regards,
Nishant.

--90e6ba6153de595e64049b01db77
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Malahal<br>
<br>
Is there any way to find the last sector of bio. <br>
Is this a correct way to find last sector of bio <br><br>&quot;bio-&gt;bi_s=
ector=3Dbio-&gt;bi_sector + (bio-&gt;bi_size &gt;&gt; 9)-1&quot;<br>
<br>or<br>
<br>bio_for_each_segment(bvec,bio,idx)<br>
{<br>
=A0bio-&gt;bi_sector=3Dbio-&gt;bi_sector + (bvec-&gt;bv_len &gt;&gt; 9) -1;=
<br>
}<br>
Will this bio-&gt;bi_sector point to last sector of bio if bio-&gt;bi_vcnt =
is greater than 1.<br>
<br>
Regards,<br>
Nishant.<br>

--90e6ba6153de595e64049b01db77--


--===============5195926968882956124==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5195926968882956124==--
