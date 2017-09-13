From: Eivind Sarto <eivindsarto@gmail.com>
Subject: dm-thin chunk size
Date: Wed, 13 Sep 2017 12:18:27 -0700
Message-ID: <CAB3weQ-sPNZOJ5ymFVTcP0PmhB4UvCP77VfU5z0-9B=CYX8sJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7981146319325616923=="
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

--===============7981146319325616923==
Content-Type: multipart/alternative; boundary="94eb2c1921664d91940559170627"

--94eb2c1921664d91940559170627
Content-Type: text/plain; charset="UTF-8"

I am considering using dm-thin for a project and have been running some
performance tests.

After a snapshot has been taken, writes to the existing blocks in the
original volume appears to take a severe performance hit unless the blocks
written are >= than the thin-pool chunksize.  If the writes are smaller
than the chunksize, dm-thin appears to do a RMW of the chunk that is being
written and the throughput drops to less than half.  If the writes are >=
chunksize, the chunk is simply overwritten (without reading it first) and
throughput is much better.
The minimum chunksize is hard-coded to 64k (in both lvm2 tools and
kernel).  If this chunksize could be set to 4k, then data that is
(over)written in the original volume would never any any RMW.

My question is, why is 64k the minimum chunksize supported?
What would be the impact of reducing this hard-coded minimum?

Any feedback would be appreciated.
Thanks,
-eivind

--94eb2c1921664d91940559170627
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I am considering using dm-thin for a project and have been=
 running some performance tests.<div><br></div><div>After a snapshot has be=
en taken, writes to the existing blocks in the original volume appears to t=
ake a severe performance hit unless the blocks written are &gt;=3D than the=
 thin-pool chunksize.=C2=A0 If the writes are smaller than the chunksize, d=
m-thin appears to do a RMW of the chunk that is being written and the throu=
ghput drops to less than half.=C2=A0 If the writes are &gt;=3D chunksize, t=
he chunk is simply overwritten (without reading it first) and throughput is=
 much better.</div><div>The minimum chunksize is hard-coded to 64k (in both=
 lvm2 tools and kernel).=C2=A0 If this chunksize could be set to 4k, then d=
ata that is (over)written in the original volume would never any any RMW.</=
div><div><br></div><div>My question is, why is 64k the minimum chunksize su=
pported?</div><div>What would be the impact of reducing this hard-coded min=
imum?</div><div><br></div><div>Any feedback would be appreciated.</div><div=
>Thanks,</div><div>-eivind</div></div>

--94eb2c1921664d91940559170627--


--===============7981146319325616923==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7981146319325616923==--
