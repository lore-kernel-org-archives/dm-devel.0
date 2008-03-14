From: lemons_terry@emc.com
Subject: RE: Linux utility to determine WWN from a LUN number
Date: Thu, 13 Mar 2008 22:50:34 -0400
Message-ID: <B6FF36386FC9AC4BB098A4528811409F02230CC4@CORPUSMX40A.corp.emc.com>
References: <B6FF36386FC9AC4BB098A4528811409F022309BE@CORPUSMX40A.corp.emc.com>
	<20080313214352.GA18433@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20080313214352.GA18433@us.ibm.com>
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


>lemons_terry@emc.com [lemons_terry@emc.com] wrote:
>> Hi
>>=20
>> I want to have multipath manage only the CLARiiON LUN that I boot
from (LUN 0).  So I know that I can specify the following in
/etc/multipath.conf:
>>=20
>> blacklist {
>> 	wwid *
>> 	}
>> blacklist_exceptions {
>> 	wwid nnnnnnnnnn
>> 	}
>>=20
>> The wwid value is different for every CLARiiON LUN.  So, if I want to
automate the process of adding the 'wwid' value to the blacklist, what
utility can I use to specify a LUN number, and find the WWN of the LUN?
>>=20
>> Thanks!
>> tl
>
>lsscsi, lists all your SCSI devices. It should have LUN number and
>device name. You can use scsi_id to get WWN. lsscsi uses "sysfs" file
>system (/sys/class/scsi_device/ etc), so you should be able to write
>your own to suite your exact needs.

Sorry, but doesn't scsi_id only return what it finds in SCSI VPD pages
80 or 83?  Not all devices provide a WWN in VPD page 83.

tl
