From: "Xiaowen Wu" <Xiaowen.Wu@hds.com>
Subject: Multipath setup
Date: Thu, 28 Apr 2005 13:55:05 -0700
Message-ID: <960A9B249C99994AA3C7FCA016A0DA8901DA8EBE@ussccem08.corp.hds.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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


Hello,=20

I'm trying to use the multipath software in my project. I downloaded and

installed the 2.6.12.rc2-odm1 (I turned on the Multi-Device
support/Device=20
Mapper Support and Multipath I/O Support)

I also download and install the mutipath-tools 0.4.4. But when I tried=20

[root@dhcp76 multipath-tools-0.4.4]# ./multipath/multipath
device mapper prerequisites not met

I don't known what's wrong with it. I ran dmsetup

[root@dhcp76 multipath-tools-0.4.4]# /sbin/dmsetup targets
striped          v1.0.2
linear           v1.0.1
error            v1.0.1

Is that mean I don't have multipath support compiled in the kernel ?

Also, I have a generic question regarding to the multipath tool. We ran
some=20
virtualization softwares, which generate different UUID (SCSI VPD 83)
for the=20
same LUN go through different path, can the multipath software config
these=20
two LUNs with difference UUID in a multipath setup ?

Best regards

Xiaowen Wu
Software Engineering
Xiaoweu.Wu@hds.com
