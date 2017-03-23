From: Michael McCarthy <mccarthy197310@gmail.com>
Subject: Question about merge performance
Date: Thu, 23 Mar 2017 12:35:37 -0400
Message-ID: <CALpM8gRZoJLQvNxo=K=+JZ4yHAzMxzvDS9aM7uYxyrq8VqzUvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3154038165671064031=="
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

--===============3154038165671064031==
Content-Type: multipart/alternative; boundary=94eb2c07106a881b33054b687749

--94eb2c07106a881b33054b687749
Content-Type: text/plain; charset=UTF-8

Hello, collective wisdom,

I'm new to the list and apologize if this is not the right place to ask
this type of question and if so, would be glad receive pointers to the
correct one.

Now the question:

I'm looking for ways to improve snapshot-merge target performance. We're
using CentOS 7.3 here. Both, the snapshot-origin and the snapshot (cow data
holder) reside on NVMe SSDs. What we've seen in our tests is that the speed
of the merge isn't approaching neither the throughput nor the IOPS limits
of the NVMe devices. I suspect it might be because the merge operation is
single threaded and uses QD of 1.

Could anyone with enough knowledge about the DM code shed some light on how
it operates during the merge? Are there any interfaces to improve the speed
of this operation without altering the code?

Thanks,
Mike

--94eb2c07106a881b33054b687749
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello, collective wisdom,<div><br></div><div>I&#39;m new t=
o the list and apologize if this is not the right place to ask this type of=
 question and if so, would be glad receive pointers to the correct one.</di=
v><div><br></div><div>Now the question:</div><div><br></div><div>I&#39;m lo=
oking for ways to improve snapshot-merge target performance. We&#39;re usin=
g=C2=A0CentOS 7.3 here. Both, the snapshot-origin and the snapshot (cow dat=
a holder) reside on NVMe SSDs. What we&#39;ve seen in our tests is that the=
 speed of the merge isn&#39;t approaching neither the throughput nor the IO=
PS limits of the NVMe devices. I suspect it might be because the merge oper=
ation is single threaded and uses QD of 1.</div><div>=C2=A0</div><div>Could=
 anyone with enough knowledge about the DM code shed some light on how it o=
perates during the merge? Are there any interfaces to improve the speed of =
this operation without altering the code?<br></div><div><br></div><div>Than=
ks,</div><div>Mike</div></div>

--94eb2c07106a881b33054b687749--


--===============3154038165671064031==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3154038165671064031==--
