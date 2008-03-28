From: Tore Anderson <tore@linpro.no>
Subject: Using different configuration for arrays with identical
	vendor/product
Date: Fri, 28 Mar 2008 12:23:30 +0100
Message-ID: <47ECD532.5060402@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
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

Hey.  I've got an EMC CX200 and a CX3-40 in my SAN.  The latter one
supports ALUA, which I'm using as much as I can, the former does not.
The hosts need to be able to access volumes on both the arrays at the
same time.

Unfortunately the volumes on both of these boxes have vendor =C2=ABDGC=C2=
=BB and
product =C2=ABRAID 5=C2=BB, so making two different device sections for t=
hem with
different hardware_handler and path_checker settings isn't trivial.  I
figured I could simply override the two settings in the multipath{}
blocks for volumes on the CX200, making the device{} block specific for
the CX3-40.  Doesn't appear to work, though, the path_checker- and
hardware_handler-settings in the multipath{} blocks appears to be
silently ignored.

Am I out of luck or is there any other way to do what I want?

For reference, this is the device section I use for the CX200 in
standard =C2=ABtrespassing=C2=BB mode:

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
