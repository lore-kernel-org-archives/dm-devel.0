From: Aidan Totterdell <aidan.totterdell@gmail.com>
Subject: ubifs
Date: Tue, 18 Jun 2013 16:47:36 +0100
Message-ID: <CABmQReJR0W7E4YG-508rk3qFHrQFw2Yt2PZozMx+GVdu5LfqWQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6579954178634923160=="
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

--===============6579954178634923160==
Content-Type: multipart/alternative; boundary=047d7b624956d19b3904df6fa102

--047d7b624956d19b3904df6fa102
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I am very interested in using dm-verity in an up coming embedded project on
a "secure" device using NAND flash. I see an email in the June archives
asking the question about what file systems can  dm-verity be used with.
The response was "any file system". The question mentioned ubifs
specifically which is not a block based file system. Can ubifs be made to
look like a block device? Is there an example of dm-verity on a ubifs file
system?

I think it would be possible to create a jffs2 file system over ubi using
"gluebi" module. This would then appear as a block device but it would be
great if it would work with ubifs/ubi as is.

Any help would be much appreciated.

Thanks,
Aidan

--047d7b624956d19b3904df6fa102
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>Hi,<br></div><div><br></div>I am very inter=
ested in using dm-verity in an up coming embedded project on a &quot;secure=
&quot; device using NAND flash. I see an email in the June archives asking =
the question about what file systems can=A0 dm-verity be used with. The res=
ponse was &quot;any file system&quot;. The question mentioned ubifs specifi=
cally which is not a block based file system. Can ubifs be made to look lik=
e a block device? Is there an example of dm-verity on a ubifs file system?<=
br>
<br></div><div>I think it would be possible to create a jffs2 file system o=
ver ubi using &quot;gluebi&quot; module. This would then appear as a block =
device but it would be great if it would work with ubifs/ubi as is.<br>
</div><div><br></div><div>Any help would be much appreciated.<br></div><div=
><br></div>Thanks,<br></div>Aidan<br></div>

--047d7b624956d19b3904df6fa102--


--===============6579954178634923160==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6579954178634923160==--
