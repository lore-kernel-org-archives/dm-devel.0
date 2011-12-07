From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: ERROR: asr: reading /dev/sdo[Input/output error]
Date: Wed, 07 Dec 2011 17:20:53 +0100
Message-ID: <4EDF9265.7080806@redhat.com>
References: <4EDF8497.7080508@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4EDF8497.7080508@linux.vnet.ibm.com>
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

On 12/07/2011 04:21 PM, Christian May wrote:
> Hi,
>
> I've setup an IBM HS21 blade with RHEL6.1. The OS installed on a 
> DS5100 storage server (SAN boot).
> During booting I'm recognizing the following messages:
>
> Starting udev: OK
> Setting hostname elm8a203.beaverton.ibm.com:
> ERROR: asr: reading /dev/sdo[Input/output error]
> ERROR: ddf1: reading /dev/sdo[Input/output error]
> ERROR: ddf1: reading /dev/sdo[Input/output error]
> ERROR: hpt37x: reading /dev/sdo[Input/output error]
> ERROR: hpt45x: reading /dev/sdo[Input/output error]
> ERROR: isw: reading /dev/sdo[Input/output error]
> ERROR: jmicron: reading /dev/sdo[Input/output error]
> ERROR: lsi: reading /dev/sdo[Input/output error]
> ERROR: nvidia: reading /dev/sdo[Input/output error]
> ERROR: pdc: reading /dev/sdo[Input/output error]
> ...
>
> ERROR: sil: reading /dev/sdf[Input/output error]
> ERROR: via: reading /dev/sdf[Input/output error]
> ERROR: asr: reading /dev/sde[Input/output error]
> ERROR: ddf1: reading /dev/sde[Input/output error]
> ERROR: ddf1: reading /dev/sde[Input/output error]
> ERROR: hpt37x: reading /dev/sde[Input/output error]
> ERROR: hpt45x: reading /dev/sde[Input/output error]
> ERROR: isw: reading /dev/sde[Input/output error]
> ERROR: jmicron: reading /dev/sde[Input/output error]
> ERROR: lsi: reading /dev/sde[Input/output error]
> ERROR: nvidia: reading /dev/sde[Input/output error]
> ERROR: pdc: reading /dev/sde[Input/output error]
> ERROR: pdc: reading /dev/sde[Input/output error]
> ERROR: pdc: reading /dev/sde[Input/output error]
> ERROR: pdc: reading /dev/sde[Input/output error]
> ERROR: pdc: reading /dev/sde[Input/output error]
> ERROR: pdc: reading /dev/sde[Input/output error]
>
>
> etc.
>
> All those device /dev/sd...are part of a multipath devices, e.g.:
>
>
> mpathh (3600a0b800047e4e4000008b54ebc91c3) dm-6 IBM,1818      FAStT
> size=25G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
> |-+- policy='round-robin 0' prio=6 status=active
> | `- 3:0:3:0 sdh 8:112 active ready running
> `-+- policy='round-robin 0' prio=1 status=enabled
>   `- 4:0:2:0 sdo 8:224 active ghost running
> mpathg (3600a0b800011573a00006da14a648a22) dm-0 IBM,1815      FAStT
> size=4.8G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
> |-+- policy='round-robin 0' prio=6 status=active
> | `- 4:0:1:1 sdn 8:208 active ready running
> `-+- policy='round-robin 0' prio=1 status=enabled
>   `- 3:0:0:1 sdc 8:32  active ghost running
>
>
> OS is booting but how can I get rid of those messages? Is it 
> udev-rules related?

You have to deactivate dmraid with the "nodmraid" kernel command line 
option in order to avoid its scanning leading to the above error messages.

Regards,
Heinz

>
> Regards,
>
> Christian May (IBM)
>
>
>
> -- 
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-- 
===============================================================
Heinz Mauelshagen                               +49 2626 141200
Consulting Development Engineer             FAX +49 2626 924446
Red Hat GmbH
Am Sonnenhang 11
56242 Marienrachdorf
Germany                                       heinzm@redhat.com
===============================================================
