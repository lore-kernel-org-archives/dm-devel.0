From: Ross Anderson <rosander@dsotm.net>
Subject: Re: multipath prio issues
Date: Tue, 18 Mar 2014 11:13:58 -0500
Message-ID: <532870C6.20309@dsotm.net>
References: <CAPi_w4w8+A=ZPANQRJDzcQWCaxj-aOJbbOePWVjsx8r7pxeWrg@mail.gmail.com>	<20140317140117.GA7539@redhat.com>	<CAPi_w4y=xGjupEsz7UgHOOH3qFSbcrh+W80Y0QpxvEZR-Uyrzg@mail.gmail.com>
	<53278A91.4010902@dsotm.net> <5327EDC9.5090705@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5327EDC9.5090705@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 3/18/2014 1:55 AM, Bart Van Assche wrote:
> On 03/18/14 00:51, Ross Anderson wrote:
>> I would appreciate support correcting another issues. We have two scst
>> storage arrays configured  with drbd replication and alua settings via
>> targets. When we run sg_inq and sg_rtpg we see the preferred port.
>> Multipath however doesn't seem to respect the priority path. We then
>> tried setting active and nonoptimized on the two storage arrays without
>> success. If I'm reading this correctly the devices are reporting their
>> state to the multipath system however it's not respecting the values.
>> I'd appreciate any assistance on the matter. Pastebin all the
>> appropriate .conf and command outs.
> Hello Ross,
>
> Have you already tried to change "prio group_by_prio" into "prio alua" ?
>
> Bart.
>
Greetings,

Yes, the config file had multiple devices listed. The one I focused on 
was the general however they all attached to the same set of storage 
heads. In Alua mode it gives them all prio 50 and the output of 
multipath show them not accepting the preferred value. I threw the 
complete config with different options to show no real different.

Thanks,
Ross
