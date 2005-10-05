From: andysayshi <andysayshi@gmail.com>
Subject: I/O errors?
Date: Wed, 5 Oct 2005 17:07:00 -0400
Message-ID: <3f57d11c0510051407s2069d404hcf158645bb0910da@mail.gmail.com>
Reply-To: andysayshi <andysayshi@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1780473591=="
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

--===============1780473591==
Content-Type: multipart/alternative;
	boundary="----=_Part_5368_31741055.1128546420521"

------=_Part_5368_31741055.1128546420521
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hey,

I've recently upgraded from device-mapper-multipath 0.4.4 to 0.4.5 and
since, occasionally i am noticing errors like these appearing in the
logs/dmesg:

Buffer I/O error on device sdm, logical block 11
Buffer I/O error on device sdm, logical block 12

scsi5 (0,4,2) : reservation conflict
scsi5 (0,4,2) : reservation conflict

st2: Error 18 (sugg. bt 0x0, driver bt 0x0, host bt 0x0).
scsi5 (0,4,2) : reservation conflict
st1: Error 18 (sugg. bt 0x0, driver bt 0x0, host bt 0x0).

Would these be dm-mpath related? If so, can someone help me decipher what
they are and how to resolve them (are they critical?), or point me to
references if it's already been documented (i did a quick check, didnt find
any info yet, still checking).

# uname -r
2.6.9-22.ELsmp
# rpm -qa|grep mapper
device-mapper-multipath-0.4.5-6.0.RHEL4
device-mapper-1.01.01-1.RHEL4

Thanks,
Andy

------=_Part_5368_31741055.1128546420521
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hey,<br>
<br>
I've recently upgraded from device-mapper-multipath 0.4.4 to 0.4.5 and
since, occasionally i am noticing errors like these appearing in the
logs/dmesg:<br>
<br>
Buffer I/O error on device sdm, logical block 11<br>
Buffer I/O error on device sdm, logical block 12<br>
<br>
scsi5 (0,4,2) : reservation conflict<br>
scsi5 (0,4,2) : reservation conflict<br>
<br>
st2: Error 18 (sugg. bt 0x0, driver bt 0x0, host bt 0x0).<br>
scsi5 (0,4,2) : reservation conflict<br>
st1: Error 18 (sugg. bt 0x0, driver bt 0x0, host bt 0x0).<br>
<br>
Would these be dm-mpath related? If so, can someone help me decipher
what they are and how to resolve them (are they critical?), or point me
to references if it's already been documented (i did a quick check,
didnt find any info yet, still checking).<br>
<br>
#&nbsp; uname -r<br>
2.6.9-22.ELsmp<br>
# rpm -qa|grep mapper<br>
device-mapper-multipath-0.4.5-6.0.RHEL4<br>
device-mapper-1.01.01-1.RHEL4<br>
<br>
Thanks,<br>
Andy<br>

------=_Part_5368_31741055.1128546420521--


--===============1780473591==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1780473591==--
