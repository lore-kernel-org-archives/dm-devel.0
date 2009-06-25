From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: Re: RDAC path checker status change messages
Date: Thu, 25 Jun 2009 13:02:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0906251300070.4229@e-smith.charlieb.ott.istop.com>
References: <Pine.LNX.4.64.0906231548060.18687@e-smith.charlieb.ott.istop.com>
	<1245867321.26915.13.camel@chandra-ubuntu>
	<Pine.LNX.4.64.0906241615210.22601@e-smith.charlieb.ott.istop.com>
	<Pine.LNX.4.64.0906251253570.4229@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0906251253570.4229@e-smith.charlieb.ott.istop.com>
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


On Thu, 25 Jun 2009, Charlie Brady wrote:

>
> On Wed, 24 Jun 2009, Charlie Brady wrote:
>
>> >   If your concern is that the last message is "down", then we should be
>> >   having a static variable and print up or ghost message only once (when
>> >   we toggle from down to up/ghost).
>>
>>  You do have a static variable, so that messages are only printed when the
>>  status changes.
>
> I think I need to retract that. The messages appear to be printed when the 
> status is not changing, at least for the "path down" messages.
>
> I've patched scsi_dh_rdac.c so that SUN/LCSM100_I is included in 
> rdac_dev_list[], and restarted iscsi and multipathd. I've now provoked a path 
> failure via iptables. Here are the logs I see (with unpatched multipathd) - 
> the duplicate message suppression from the rdac path checker is not working:

OTOH, on path recovery, the wrong message is displayed ("path down" 
instead of "path up") but the message is not repeated:

Jun 25 12:57:51 sun4150node1 last message repeated 9 times
Jun 25 12:57:54 sun4150node1 iscsid: received iferror -38
Jun 25 12:57:54 sun4150node1 last message repeated 2 times
Jun 25 12:57:54 sun4150node1 iscsid: connection3:0 is operational after 
recovery (44 attempts)
Jun 25 12:57:56 sun4150node1 multipathd: sdd: rdac checker reports path is 
down
Jun 25 12:57:56 sun4150node1 multipathd: 8:48: reinstated
Jun 25 12:57:56 sun4150node1 multipathd: mpath0: remaining active paths: 2
Jun 25 12:57:56 sun4150node1 multipathd: dm-2: add map (uevent)
Jun 25 12:57:56 sun4150node1 multipathd: dm-2: devmap already registered
