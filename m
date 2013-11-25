From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/13] multipathd: Implement systemd watchdog
 integration
Date: Mon, 25 Nov 2013 17:21:15 +0100
Message-ID: <529378FB.4040803@suse.de>
References: <1384511384-27642-1-git-send-email-hare@suse.de>	<1384511384-27642-10-git-send-email-hare@suse.de>	<20131122221759.GM1661@dhcp80-209.msp.redhat.com>
	<5293013B.4010008@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5293013B.4010008@suse.de>
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

On 11/25/2013 08:50 AM, Hannes Reinecke wrote:
> On 11/22/2013 11:17 PM, Benjamin Marzinski wrote:
[ .. ]
>> I'm not asking for systemd to actually shut down multipathd.  In a
>> production setup, killing multipathd because it had a temporary stall
>> seems like bad default behavior.  I haven't looked at the systemd
>> watchdog code to know if this is possible, but ideally, multipathd would
>> be able to just start sending watchdog notifications again, and be able
>> to continue on with just a message in the logs recording the timeout.
>>
> Not stopping. Restarting.
> The whole point of the watchdog code is to take some action if the
> watchdog messages fail.
> We should aim for
> a) make the watchdog interval the longest interval we're prepared to
>     checkerloop to complete (hence the patch to measure the elapsed
>     time per loop iteration)
> b) have systemd restart multipathd whenever the watchdog triggers,
>     as then we're sure we can't recover from this.
>
> That should cover your sentiment, right?
>
>> I realize that there is a benefit to letting people know that there was
>> a problem, but the way it's appearing now, it will be pretty confusing to
>> the sysadmin who sees that, and filling up the logs with notification
>> rejections is pretty annoying.
>>
> Yeah, correct. We should be using the 'restart' flag in the service
> file. I did not do this as the patch went into systemd only
> recently, and one would need to figure out how to treat
> installations where an older systemd version is running.
>
And it also looks as if we'd be tripping over RH bug#982379, where
the watchdog fails to shutdown a process properly.
Which apparently is fixed in 206.
So we'd need a recent systemd for that to work properly.

I'm _quite_ sure there are errors in earlier versions, where the
watchdog feature just causes a new process to be started, without
terminating the old one. _Very_ annoying.

I'll retest with latest systemd. And make the watchdog feature
selective on the systemd version.

Cheers,

Hannes
