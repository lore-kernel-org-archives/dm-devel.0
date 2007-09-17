From: "James Fillman" <JFillman@cucbc.com>
Subject: RE: path priorities on Sun's 6140
Date: Mon, 17 Sep 2007 11:36:32 -0700
Message-ID: <66F461DD7EDEEF4AA928FCC80B425B520468B9@c2kp01mail.cucbc.com>
References: <66F461DD7EDEEF4AA928FCC80B425B520468B7@c2kp01mail.cucbc.com><46EBA114.10408@linpro.no>
	<66F461DD7EDEEF4AA928FCC80B425B520468B8@c2kp01mail.cucbc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
content-class: urn:content-classes:message
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

Ok. So I just realized that if I want to try the new RDAC support, then
I have to install the new beta kernel as well. It includes the RDAC
hardware handler.

I'm under serious pressure to get my cluster up and running asap and I
don't think I want to be installing a bunch of beta packages onto my
production servers. Especially kernels.

So this might mean not exploring the RDAC solution. Redhat's docs say
that they support a Sun OpenStorage D280 and our Sun rep says the 6140
is essentially identical. If that's the case, what am I don't wrong?

cheers,
--james

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of James Fillman
Sent: Monday, September 17, 2007 11:18 AM
To: device-mapper development
Subject: RE: [dm-devel] path priorities on Sun's 6140

Thanks for getting back to me Tore, Hannes, and Eckebrecht.

I've downloaded and installed the latest device-mapper-multipath rpm
from Redhat. It's still only beta but I figured I give it a try. I see
that there's an rdac checker in there but I don't see a hardware
handler.

Is anyone running RHEL against a Sun 6140 SAN? Trying to get a
definitive answer from Redhat on their support for this SAN has been
impossible. The mailing list hasn't been too helpful either.

If RDAC is the way to go
  1. do I need to use a hardware handler? There doesn't seem to be one
in their latest RPM.
  2. What Host type do I chose on the SAN?
  3. What should the path grouping policy by? Tore: you mentioned using
group_by_serial
  4. What should the path checker be?

I'm going to take a stab at it and guess this, can anyone confirm?:
/etc/multipath.conf

defaults
{
        udev_dir                /dev
        polling_interval        10
        selector                "round-robin 0"
        path_grouping_policy    group_by_serial
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
        path_checker            tur
        rr_min_io               100
        rr_weight               uniform
        failback                immediate
        no_path_retry           queue
        user_friendly_name      yes
}
devices
{
        device
        {
                vendor                  "SUN"
                product                 "CSM200_R"
                path_grouping_policy    group_by_prio
                path_checker            tur
                prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
                getuid_callout          "/sbin/scsi_id -g -u -s
/block/%n"
                rr_weight               uniform
                rr_min_io               1000
                features                "1 queue_if_no_path"
        }
}

cheers,
--james


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
