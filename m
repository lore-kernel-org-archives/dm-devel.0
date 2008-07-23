From: Menno Koehler <menno.koehler@klm.com>
Subject: RE: Losing paths
Date: Thu, 24 Jul 2008 00:32:12 +0200
Message-ID: <1216852332.29160.64.camel@mbws004.int.microbytes.nl>
References: <1D80D4F6D179BD4D869FE807A5BF833602D8B686@EXCNYSM0A1AN.nysemail.nyenet>
	<AB48FAA97D916742945DE3B0C9AA521B0276FB5C@KL1010VE.cs.ad.klmcorp.net>
	<1D80D4F6D179BD4D869FE807A5BF833602D8B68B@EXCNYSM0A1AN.nysemail.nyenet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1D80D4F6D179BD4D869FE807A5BF833602D8B68B@EXCNYSM0A1AN.nysemail.nyenet>
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

Greetings, and thanks again for your response,

I just found a small but importent mistake in the multipath.conf file.
There was no space between devices and the accolade so "devices{" it
must be "devices {" so I just changed that and checked as you already
suppost with multipath -ll -v5 and see now that the path_checker is
changed from tur to readsector0.
I will reproduce the tests tomorrow and will let you know or readsector0
will solve this issue.

Kind regards,
Menno Koehler


On Wed, 2008-07-23 at 13:02 -0400, Romanowski, John (OFT) wrote:
> this is a longshot, but try     multipath -ll -v3 | more
> and see if the devices are really seen as IBM 2145? or something else?
> 
> I have sles not RedHat, not sure of differences;
> Do you know if mkinitrd put an older copy of multipath.conf into initrd?
> try mkinitrd, zipl, reboot. 
> 
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Koehler, M - SPLXM
> Sent: Wednesday, July 23, 2008 9:23 AM
> To: device-mapper development
> Subject: RE: [dm-devel] Losing paths
> 
> Hello, 
> 
> Thanks for your respond, first I tried the multipathd -k reconfigure
> (and get a ok returned) and later when seen that it still was using tur
> we tried a reboot but with the same result.
> 
> Kind regards,
> 
> Menno
> 
> 
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Romanowski, John (OFT)
> Sent: Wednesday, July 23, 2008 3:13 PM
> To: device-mapper development
> Subject: RE: [dm-devel] Losing paths
> 
> Did you change multipath.conf and reboot the machine?
>  if not reboot, what steps put the changed multipath.conf into effect
> for the 2145's (SVC) LUNs?
> 
> 
> --------------------------------------------------------
> This e-mail, including any attachments, may be confidential, privileged
> or otherwise legally protected. It is intended only for the addressee.
> If you received this e-mail in error or from someone who was not
> authorized to send it to you, do not disseminate, copy or otherwise use
> this e-mail or its attachments.  Please notify the sender immediately by
> reply e-mail and delete the e-mail from your system.
> 
> 
> -----Original Message-----
> 
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Koehler, M - SPLXM
> Sent: Wednesday, July 23, 2008 8:34 AM
> To: device-mapper development
> Subject: RE: [dm-devel] Losing paths
> 
> Greetings,
> 
> We tried testing with path_checker readsector0 end directio but we get
> some strange behavior eg the checker used is always tur!!
> So if we create a device entry special for IBM 2145 and define as
> path_checker directio or readsector0 we still see in the message file
> tur messages:
> 
> Jul 23 08:09:00 kl11071i multipathd: 65:0: tur checker reports path is
> down
> Jul 23 08:09:00 kl11071i multipathd: 65:16: tur checker reports path is
> down
> Jul 23 08:09:00 kl11071i multipathd: 65:32: tur checker reports path is
> down
> Jul 23 08:09:00 kl11071i multipathd: 65:48: tur checker reports path is
> down
> Jul 23 08:09:00 kl11071i multipathd: 65:80: tur checker reports path is
> down
> Jul 23 08:09:00 kl11071i multipathd: 65:96: tur checker reports path is
> down
> Jul 23 08:09:00 kl11071i multipathd: 65:112: tur checker reports path is
> down
> 
> 
> Oure multipath.conf file is:
> 
> defaults {
>         user_friendly_names yes
> }
> 
> devices{
>       device {
>                vendor                  "IBM"
>                product                 "2145"
>                path_grouping_policy    group_by_prio
>                getuid_callout          "/sbin/scsi_id -g -u -s"
>                prio_callout            "/sbin/mpath_prio_alua %d"
>                path_checker            readsector0
>                failback                immediate
>        }
> }
> 
> Did someone see this behavior before? Or are we doing something wrong?
> We are using device-mapper-multipath-0.4.5-27.el4_6.3 on a rhel4.6
> system.
> 
> Kind regards,
> Menno 
> **********************************************************************
> For information, services and offers, please visit our web site:
> http://www.klm.com. This e-mail and any attachment may contain
> confidential and privileged material intended for the addressee
> only. If you are not the addressee, you are notified that no part
> of the e-mail or any attachment may be disclosed, copied or
> distributed, and that any other action related to this e-mail or
> attachment is strictly prohibited, and may be unlawful. If you have
> received this e-mail by error, please notify the sender immediately
> by return e-mail, and delete this message. 
> 
> Koninklijke Luchtvaart Maatschappij NV (KLM), its subsidiaries
> and/or its employees shall not be liable for the incorrect or
> incomplete transmission of this e-mail or any attachments, nor
> responsible for any delay in receipt.
> Koninklijke Luchtvaart Maatschappij N.V. (also known as KLM Royal
> Dutch Airlines) is registered in Amstelveen, The Netherlands, with
> registered number 33014286 
> **********************************************************************
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> **********************************************************************
> For information, services and offers, please visit our web site:
> http://www.klm.com. This e-mail and any attachment may contain
> confidential and privileged material intended for the addressee
> only. If you are not the addressee, you are notified that no part
> of the e-mail or any attachment may be disclosed, copied or
> distributed, and that any other action related to this e-mail or
> attachment is strictly prohibited, and may be unlawful. If you have
> received this e-mail by error, please notify the sender immediately
> by return e-mail, and delete this message. 
> 
> Koninklijke Luchtvaart Maatschappij NV (KLM), its subsidiaries
> and/or its employees shall not be liable for the incorrect or
> incomplete transmission of this e-mail or any attachments, nor
> responsible for any delay in receipt.
> Koninklijke Luchtvaart Maatschappij N.V. (also known as KLM Royal
> Dutch Airlines) is registered in Amstelveen, The Netherlands, with
> registered number 33014286 
> **********************************************************************
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
**********************************************************************
For information, services and offers, please visit our web site:
http://www.klm.com. This e-mail and any attachment may contain
confidential and privileged material intended for the addressee
only. If you are not the addressee, you are notified that no part
of the e-mail or any attachment may be disclosed, copied or
distributed, and that any other action related to this e-mail or
attachment is strictly prohibited, and may be unlawful. If you have
received this e-mail by error, please notify the sender immediately
by return e-mail, and delete this message. 

Koninklijke Luchtvaart Maatschappij NV (KLM), its subsidiaries
and/or its employees shall not be liable for the incorrect or
incomplete transmission of this e-mail or any attachments, nor
responsible for any delay in receipt.
Koninklijke Luchtvaart Maatschappij N.V. (also known as KLM Royal
Dutch Airlines) is registered in Amstelveen, The Netherlands, with
registered number 33014286 
**********************************************************************
