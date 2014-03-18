From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: multipath prio issues
Date: Tue, 18 Mar 2014 07:55:05 +0100
Message-ID: <5327EDC9.5090705@acm.org>
References: <CAPi_w4w8+A=ZPANQRJDzcQWCaxj-aOJbbOePWVjsx8r7pxeWrg@mail.gmail.com>	<20140317140117.GA7539@redhat.com>	<CAPi_w4y=xGjupEsz7UgHOOH3qFSbcrh+W80Y0QpxvEZR-Uyrzg@mail.gmail.com>
	<53278A91.4010902@dsotm.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53278A91.4010902@dsotm.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ross Anderson <rosander@dsotm.net>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 03/18/14 00:51, Ross Anderson wrote:
> I would appreciate support correcting another issues. We have two scst
> storage arrays configured  with drbd replication and alua settings via
> targets. When we run sg_inq and sg_rtpg we see the preferred port.
> Multipath however doesn't seem to respect the priority path. We then
> tried setting active and nonoptimized on the two storage arrays without
> success. If I'm reading this correctly the devices are reporting their
> state to the multipath system however it's not respecting the values.
> I'd appreciate any assistance on the matter. Pastebin all the
> appropriate .conf and command outs.

Hello Ross,

Have you already tried to change "prio group_by_prio" into "prio alua" ?

Bart.
