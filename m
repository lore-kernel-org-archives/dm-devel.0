From: "Nath, Varun" <varun.nath@amd.com>
Subject: RE: Need Help
Date: Thu, 17 Jan 2008 14:45:45 -0600
Message-ID: <EEBC5C82F965344199BFA3E6047FE13302E8F5@SAUSEXMB2.amd.com>
References: <EEBC5C82F965344199BFA3E6047FE13302E8F4@SAUSEXMB2.amd.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <EEBC5C82F965344199BFA3E6047FE13302E8F4@SAUSEXMB2.amd.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

I am also getting these errors when I try to access those LUNs

Jan 17 14:39:29 x kernel: device-mapper: dm-multipath: error getting
device
Jan 17 14:39:29 x kernel: device-mapper: error adding target to table

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Nath, Varun
Sent: Thursday, January 17, 2008 2:39 PM
To: device-mapper development
Subject: RE: [dm-devel] Need Help

[root@x init.d]# /etc/init.d/multipathd status
multipathd (pid 4563) is running...
[root@x init.d]# /etc/init.d/multipath status
-bash: /etc/init.d/multipath: No such file or directory
[root@x init.d]# /etc/init.d/ multipath status
-bash: /etc/init.d/: is a directory
[root@x init.d]#

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of malahal@us.ibm.com
Sent: Thursday, January 17, 2008 2:36 PM
To: dm-devel@redhat.com
Subject: Re: [dm-devel] Need Help

Pradipmaya Maharana [pradipmaya@gmail.com] wrote:
> Run the following:
>=20
> # chkconfig multipathd on
> # /etc/init.d/ multipath status

The second command actually is "/etc/init.d/multipathd status"
to get the status of the given rc script (multipathd in this case)

--Malahal.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel





--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
