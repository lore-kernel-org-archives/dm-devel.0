From: Johannes Hirte <hirtejs@idmt.fraunhofer.de>
Subject: Re: info on enabling only one path with rdac and DS4700
Date: Wed, 16 Nov 2011 14:24:50 +0100
Message-ID: <201111161424.50911.hirtejs@idmt.fraunhofer.de>
References: <CAG2kNCx2FSBFcKQQ5qRNNdY8c8OZ6iR+WY4XPUy21mttYn-wuw@mail.gmail.com>
	<1321389505.23295.4.camel@lapoo.opensvc.com>
	<CAG2kNCyHk+vosO1+TtNwLUcH5AJP-cPn8m5nCDhVkenXFFxfjw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAG2kNCyHk+vosO1+TtNwLUcH5AJP-cPn8m5nCDhVkenXFFxfjw@mail.gmail.com>
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

On Tuesday 15 November 2011 23:35:53 Gianluca Cecchi wrote:
> - I'm going to check tomorrow about AVT current configuration as noted
> inside one of the answers.
> BTW: on the storage array there are snmp traps configured.
> After enabling multipath and rebooting the system, I still see the
> trap below, sent by the storage (only one)... Could it be related to
> this kind of configuration option at storage side?
> 
> Here the snmp message
> Summary
> Node ID: XXXX_DS4700
> Host IP Address:
> Host ID: Out-of-Band
> Event Error Code: 4011
> Event occurred: 15-nov-2011 14.49.36
> Event Message: Logical Drive not on preferred path due to ADT/RDAC failover
> Component type: Controller
> Component location: Controller in slot B

Yes, this is because the rdac module detected the LUN in AVT mode and refused
to work with it. This will happen every time you access a ghost path without
rdac.

> - On the presented LUN I configured a PV, VG, LV and ext4 fs (not system fs)
> At reboot at host side I see messages related to duplicated PV IDs for
> the paths (sdb, sdc, sdd, sde): they comes before vg activation and
> before multipathd start...
> Is this normal, because at the first vgscan run during boot, multipath
> configuration has not been instantiated yet..?
> I have to check, but I don't remember similar messages with eh el 5.7
> in other SAN configurations, where the VG is not a system VG....

You should avoid to access the sdX directly. If you need to run lvm before
multipath is up, you can blacklist the sdX in the lvm.conf.


regards,
  Johannes
