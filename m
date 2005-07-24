From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Multipathing hints request
Date: Sun, 24 Jul 2005 22:02:38 +0200
Message-ID: <20050724200238.GJ8005@marowsky-bree.de>
References: <20050721143110.GD4240@pan.dimdi.de>
	<1121970687.19015.78.camel@zezette>
	<20050722083722.GJ4240@pan.dimdi.de>
	<20050722095828.GA13294@averon.dyndns.org>
	<20050722120955.GL4240@pan.dimdi.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050722120955.GL4240@pan.dimdi.de>
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

On 2005-07-22T14:09:55, Philipp Niemann <niemann@dimdi.de> wrote:

> Well, almost at it.
>=20
> On Fri, 22.07.2005-11:58:28 +0200, Christophe Varoqui wrote:
> > hardware_handler and features params must be in the devices {} sectio=
n, not in multipaths {}.
>=20
> I changed the settings in /etc/multipath.conf again, as you advised.
> Here is it:
>=20
> # Begin of /etc/multipath.conf
> defaults {
>         multipath_tool  "/sbin/multipath -v 0 -S"
>         udev_dir        /dev
>         polling_interval 10
>         default_selector        "round-robin 0"
>         default_path_grouping_policy    failover
>         default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
>         default_prio_callout    "/bin/false"
>         default_features        "0"
> }

> multipaths {
>         multipath {
>                 wwid                    360060160200161a037f90d75dfca84=
f7
>                 alias                   416L3
>                 path_grouping_policy    failover
>                 path_selector           "round-robin 0"
>         }
> }
> devices {
>         device {
>                 vendor                  "DGC     "
>                 product                 "RAID 5          "
>                 path_grouping_policy    group_by_serial
>                 getuid_callout          "/sbin/scsi_id -g -u -s /block/=
%n"
>                 path_checker            emc_clariion
>                 path_selector           "round-robin 0"
>                 features                "0"
>                 hardware_handler        "1 emc"
>         }

For the Clariion 4500, you need to set the hardware_handler to
	"3 emc 1 0"

(The trespass command to transfer ownership of a LU from one
Service-Processor to the other is different from the FC4500 to the EMC
CX series. I've got to admit I've not tested the FC4500 yet, though.)

You also want the pp_emc callout from the newer multipath-tools
package and use that as the priority callout, and group by priority.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
