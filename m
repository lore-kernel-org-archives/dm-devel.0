From: james harvey <jamespharvey20@gmail.com>
Subject: Re: lvmetad doesn't terminate with SIGTERM if thin
	volume used
Date: Wed, 7 Sep 2016 06:09:02 -0400
Message-ID: <CA+X5Wn4WLsTT+9xh0B0m3B3DDMHs_CNxSdA2WyRnQrnKgRicjg@mail.gmail.com>
References: <CA+X5Wn6rX5rjFOhz-V3r9QYY_Mcp-0ddBTRDSuhq4Xyy2ob-7Q@mail.gmail.com>
	<CA+X5Wn5wn-engMAxvdqVSbK2bPo=9sz3485N3ZnCqGEZcQ79-Q@mail.gmail.com>
	<CA+X5Wn6DorjjziBD=R+60++bQgwAxDz_xvVsuv76u01Z8KKp6g@mail.gmail.com>
	<78d5445c-e565-03ce-e586-2073aa7b0d99@redhat.com>
	<CA+X5Wn6HBdYhngV8UC109P2FnCu_8BWM17_odkvHLtvgUyXNHQ@mail.gmail.com>
	<656f1a37-00b1-b074-32cd-1c5ec962e27d@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <656f1a37-00b1-b074-32cd-1c5ec962e27d@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Sep 5, 2016 at 4:39 AM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
> Dne 3.9.2016 v 05:17 james harvey napsal(a):
>> 1) Should the lvm2-lvmetad, dm-event, and lvm2-monitor unit files be
>> modified so they are never given a SIGKILL?  Even with
>> lvm2-monitor.service enabled, even on Fedora, if systemd sees they
>> don't SIGTERM/SIGINT within 90 seconds (systemd v231 is 90 seconds,
>> was 10 second before), it's sending them a SIGKILL.  I think adding
>> "SendSIGKILL=no" to the Service and Socket sections will do this, if I
>> understand it correctly.
>
>
> That's a different story here - it something is 'deadlocked' and
> can't move forward - killing things after 90 seconds can't make
> the situation any more worst likely - especially if you are doing
> shutdown...
>
> So no - there is no plan to use such option (SendSIGKILL=no) ATM
> (State-machine is pretty complex and when some devices are 'forgotten' in
> suspend - it's quite hard to fix it).

Can monitoring actions be expected to take more than 90 seconds?  I'm
assuming some of them are, but I could be totally wrong here.

If they aren't expected to take that long, my question has no point,
as yes, if something's deadlocked killing them won't make anything
worse.

If they aren't expected to take that long, a refusal to allow a
SIGKILL to prevent a possible leaving the system in a dizzy state
seems to me to outweigh the chance of it being deadlocked.  (Just my
thoughts of course.)


>> 2) Should lvm2-lvmetad and dm-event systemd unit files want
>> lvm2-monitor.service?
>
> lvm2-lvmetad is unrelated to monitoring service (dmevent).

Sorry, I'm confused here.  Not sure what you mean here.  I'm meaning
should lvm2-lvmetad want lvm2-monitor, and should dm-event want
lvm2-monitor.  Nothing between lvm2-lvmetad and dm-event.

If lvm2-monitor is disabled, lvm2-lvmetad ignores a SIGINT, unless the
user manually stops monitoring.  If lvm2-monitor is disabled, dm-event
ignores a SIGINT, unless the user stops monitoring.

If running lvm2-lvmetad or dm-event without lvm2-monitor is a crazy
idea, seems like pushing a user toward having it would be a good idea.
Again just my thoughts.
