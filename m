From: berthiaume_wayne@emc.com
Subject: RE: Using different configuration for arrays with
	identicalvendor/product
Date: Fri, 28 Mar 2008 12:25:43 -0400
Message-ID: <218DC19ED27F8842B837598EC6D59D0ED702BC@CORPUSMX40A.corp.emc.com>
References: <47ECD532.5060402@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <47ECD532.5060402@linpro.no>
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

Hi Tore.

	You should be able to use the emc_handler for both arrays.
Depending on the distro you are using only implicit ALUA is supported,
explicit ALUA is in being worked on for upcoming distros. Whether the
storage group within the array attached to the server is ALUA or not is
determined by the failover mode you set for the host on that array. At
the server side you will not know the difference between the two
failover modes, PNR or ALUA.

Regards,
Wayne.
EMC Corp=20

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Tore Anderson
Sent: Friday, March 28, 2008 7:24 AM
To: dm-devel@redhat.com
Subject: [dm-devel] Using different configuration for arrays with
identicalvendor/product

Hey.  I've got an EMC CX200 and a CX3-40 in my SAN.  The latter one
supports ALUA, which I'm using as much as I can, the former does not.
The hosts need to be able to access volumes on both the arrays at the
same time.

Unfortunately the volumes on both of these boxes have vendor <DGC> and
product <RAID 5>, so making two different device sections for them with
different hardware_handler and path_checker settings isn't trivial.  I
figured I could simply override the two settings in the multipath{}
blocks for volumes on the CX200, making the device{} block specific for
the CX3-40.  Doesn't appear to work, though, the path_checker- and
hardware_handler-settings in the multipath{} blocks appears to be
silently ignored.

Am I out of luck or is there any other way to do what I want?

For reference, this is the device section I use for the CX200 in
standard <trespassing> mode:

device {
  vendor               DGC.*
  product              RAID.*
  hardware_handler     "1 emc"
  path_checker         emc_clariion
  prio_callout         "/sbin/mpath_prio_emc /dev/%n"
  features             "1 queue_if_no_path"
  path_grouping_policy group_by_prio
  failback             immediate
}

And for the CX3-40 in ALUA mode:

device {
  vendor               DGC.*
  product              RAID.*
  hardware_handler     "0"
  path_checker         tur
  prio_callout         "/sbin/mpath_prio_emc /dev/%n"
  features             "1 queue_if_no_path"
  path_grouping_policy group_by_prio
  failback             immediate
}

These both work fine on hosts that only connect to one of the arrays at
a time.

Regards
--=20
Tore Anderson

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
