From: "=?iso-8859-1?Q?Bj=F6rn_Nadrowski?=" <bjrnfrdnnd@gmail.com>
Subject: vg disappeared after replacing disc in raid10
Date: Mon, 25 Mar 2013 15:02:54 +0100
Message-ID: <9F86A119-4171-4947-BFBE-B7E838F5DA6C@googlemail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Content-Type: multipart/mixed; boundary="===============8373960528705521798=="
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


--===============8373960528705521798==
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_C0DD552F-41A8-4AAC-A33F-2EE121477E11"


--Apple-Mail=_C0DD552F-41A8-4AAC-A33F-2EE121477E11
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

=10Hello,=20

After replacing a disc in my raid10 system (ubuntu 12.04), my volume =
group (that contained all my data and my system) was gone.

Problem description is here:

http://ubuntuforums.org/showthread.php?t=3D2128504

I managed to retrieve the metadata of the volume group and the logical =
volumes underneath, but I did not succeed using

vgcfgrestore=20

successfully in order to regain access to my data.

It seems I might have to try dmsetup, but I am afraid I might destroy my =
data if I use it. I have no experience with that program.


If any of you has any idea or any experience with restoring lvm volumes =
or using dsetup, please help me!

--Apple-Mail=_C0DD552F-41A8-4AAC-A33F-2EE121477E11
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dus-ascii"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
">=10Hello,&nbsp;<br><br>After replacing a disc in my raid10 system =
(ubuntu 12.04), my volume group (that contained all my data and my =
system) was gone.<br><br>Problem description is here:<br><br><a =
href=3D"http://ubuntuforums.org/showthread.php?t=3D2128504">http://ubuntuf=
orums.org/showthread.php?t=3D2128504</a><br><br>I managed to retrieve =
the metadata of the volume group and the logical volumes underneath, but =
I did not succeed using<br><br>vgcfgrestore&nbsp;<br><br>successfully in =
order to regain access to my data.<br><br>It seems I might have to try =
dmsetup, but I am afraid I might destroy my data if I use it. I have no =
experience with that program.<br><br><br>If any of you has any idea or =
any experience with restoring lvm volumes or using dsetup, please help =
me!<br></body></html>=

--Apple-Mail=_C0DD552F-41A8-4AAC-A33F-2EE121477E11--


--===============8373960528705521798==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8373960528705521798==--
