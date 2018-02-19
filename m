From: Drew Hastings <dhastings@crucialwebhost.com>
Subject: Device mapper for temporarily buffering writes on fast
 device before pushing to slower device
Date: Mon, 19 Feb 2018 13:47:48 -0700
Message-ID: <CAN-y+EJLroxotABwM=5BqFH1byDmLExi7n0o0FTv9KNWFVAzaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8825054310159636702=="
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

--===============8825054310159636702==
Content-Type: multipart/alternative; boundary="001a113cd620929176056596cea7"

--001a113cd620929176056596cea7
Content-Type: text/plain; charset="UTF-8"

I found stochastic multi-queue and writeboost to be insufficient for this
purpose. I'm wondering if anything exists that fits this description:

Device mapper creates a "cache" device on a fast device (SSD/NVME, etc)...
and writes to the device *always* hit the fast device. Writes are later
flushed to the slower device as fast as the slow device can handle them.

The problem with the caching solutions I have found with device mapper is
that they require the block to be identified as "hot" first, even when the
cache itself is not 100% utilized. Read performance is largely irrelevant.

Is there a device mapper implementation that works in this fashion; where
100% of writes happen to the fast device? I was thinking COW effectively
does this, but the problem is it does not automatically/periodically flush
writes, you have to do them all at once.

I had seen some conversations about trying to get the multiqueue (mq, not
smq) policy to do this with zero values for thresholds, but it did not seem
like any were successful in ensuring the first write would hit the fast
device.

Thanks!

--001a113cd620929176056596cea7
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I found stochastic multi-queue and writeboost to be insuff=
icient for this purpose. I&#39;m wondering if anything exists that fits thi=
s description:<div><br></div><div>Device mapper creates a &quot;cache&quot;=
 device on a fast device (SSD/NVME, etc)... and writes to the device *alway=
s* hit the fast device. Writes are later flushed to the slower device as fa=
st as the slow device can handle them.</div><div><br></div><div>The problem=
 with the caching solutions I have found with device mapper is that they re=
quire the block to be identified as &quot;hot&quot; first, even when the ca=
che itself is not 100% utilized. Read performance is largely irrelevant.</d=
iv><div><br></div><div>Is there a device mapper implementation that works i=
n this fashion; where 100% of writes happen to the fast device? I was think=
ing COW effectively does this, but the problem is it does not automatically=
/periodically flush writes, you have to do them all at once.</div><div><br>=
</div><div>I had seen some conversations about trying to get the=C2=A0multi=
queue (mq, not smq) policy to do this with zero values for thresholds, but =
it did not seem like any were successful in ensuring the first write would =
hit the fast device.</div><div><br></div><div>Thanks!</div></div>

--001a113cd620929176056596cea7--


--===============8825054310159636702==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8825054310159636702==--
