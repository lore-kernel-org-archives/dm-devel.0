From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: Re: RDAC path checker status change messages
Date: Thu, 25 Jun 2009 13:28:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0906251314330.4229@e-smith.charlieb.ott.istop.com>
References: <Pine.LNX.4.64.0906231548060.18687@e-smith.charlieb.ott.istop.com>
	<1245867321.26915.13.camel@chandra-ubuntu>
	<Pine.LNX.4.64.0906241615210.22601@e-smith.charlieb.ott.istop.com>
	<Pine.LNX.4.64.0906251253570.4229@e-smith.charlieb.ott.istop.com>
	<Pine.LNX.4.64.0906251300070.4229@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0906251300070.4229@e-smith.charlieb.ott.istop.com>
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

> On Thu, 25 Jun 2009, Charlie Brady wrote:
>
>>  I think I need to retract that. The messages appear to be printed when the
>>  status is not changing, at least for the "path down" messages.
>>
>>  I've patched scsi_dh_rdac.c so that SUN/LCSM100_I is included in
>>  rdac_dev_list[], and restarted iscsi and multipathd. I've now provoked a
>>  path failure via iptables. Here are the logs I see (with unpatched
>>  multipathd) - the duplicate message suppression from the rdac path checker
>>  is not working:
>
> OTOH, on path recovery, the wrong message is displayed ("path down" instead 
> of "path up") but the message is not repeated:

From multipathd/main.c, there are three conditions where the messages are 
printed:

...
                         if (newstate != pp->state) {
                                 int oldstate = pp->state;
                                 pp->state = newstate;
                                 LOG_MSG(1, checker_message(&pp->checker));
...
                         }
                         else if (newstate == PATH_UP || newstate == PATH_GHOST) {
                                 LOG_MSG(4, checker_message(&pp->checker));
...
                         else if (newstate == PATH_DOWN)
                                 LOG_MSG(2, checker_message(&pp->checker));
...

I think only the first might be required, and only the first will be seen 
if logging verbosity < 2 (default is 2).

So there are two path checker problems I can see (in 
multipath-tools-0.4.7.rhel5.13):

- the rdac checker leaves the message set to "path down" when path
   transitions back to up or ghost.
- multipathd prints the message on every PATH_DOWN except the first when
   verbosity is >= 2, and on every PATH_UP or PATH_GHOST except the first
   when verbosity is >= 4.

---
Charlie
