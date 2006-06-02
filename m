From: "Kevin Foote" <kevin.foote@gmail.com>
Subject: failover setup
Date: Fri, 2 Jun 2006 08:25:00 -0400
Message-ID: <5fb0f77b0606020525j3338fe40n1fa73631f7ed795d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1259295445=="
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

--===============1259295445==
Content-Type: multipart/alternative;
	boundary="----=_Part_7467_31108579.1149251100531"

------=_Part_7467_31108579.1149251100531
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello
Im curious if I am on the correct path with setting up failover via
multipathd.

I am working with an ISCSI environment with a Qlogic (QLA4052c) HBA that
has two ports. My test target on the ISCSI storage
box is defined on both ports and shows up with a cat of /proc/scsi/scsi each
defined on their respecive controler.

I can get the devices to show up with the multipath -v2 command but after
that I'm shooting in the dark ..
/dev/dm-0 , dm-1 are there. But I cant seem to do anything with them. Im not
sure if i need to run dmsetup with a table or what.

Im running RHEL4u3

-- 
:wq!
kevin.foote

------=_Part_7467_31108579.1149251100531
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello<br>

Im curious if I am on the correct path with setting up failover via multipathd.<br>

<br>

I am working with an ISCSI environment with a Qlogic (QLA4052c) HBA
that&nbsp; has two ports. My test target on the ISCSI storage <br>

box is defined on both ports and shows up with a cat of /proc/scsi/scsi  each defined on their respecive controler. <br>

<br>

 I can get the devices to show up with the multipath -v2 command but after that I'm shooting in the dark .. <br>

/dev/dm-0 , dm-1 are there. But I cant seem to do anything with them. Im not sure if i need to run dmsetup with a table or what.<br>

<br>

Im running RHEL4u3 <br clear="all"><br>-- <br>:wq!<br>kevin.foote

------=_Part_7467_31108579.1149251100531--


--===============1259295445==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1259295445==--
