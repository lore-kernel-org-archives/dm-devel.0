From: Germano Percossi <germano.percossi@citrix.com>
Subject: Re: [PATCH 28/57] libmultipath: use a shared lock to
 co-operate with udev
Date: Wed, 4 May 2016 12:25:34 +0100
Message-ID: <5729DC2E.3050002@citrix.com>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-29-git-send-email-hare@suse.de>
	<20160502162617.GS26117@octiron.msp.redhat.com>
	<57283DAD.9040009@suse.de>
	<20160503142732.GB26117@octiron.msp.redhat.com>
	<5728C447.9050307@citrix.com>
	<20160503202333.GI26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160503202333.GI26117@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Ben,

On 05/03/2016 09:23 PM, Benjamin Marzinski wrote:
> On Tue, May 03, 2016 at 04:31:19PM +0100, Germano Percossi wrote:
>>
>> I just want to make sure XenServer is not among those that need to
>> be saved from themselves.
>> We do mix multipathd and multipath commands but in a way that we think
>> is safe: we add devices with "multipath -r" and remove with "multipath -f".
>> This is because we slightly bend the wwids file usage to be used
>> as a blacklisting mechanism (in our own way).
>
> The only way you would be likely to run into problems is if you would be
> running "multipath -r" at the same time as the udev add event for the
> first path device was happening.  We only lock the devices on the
> initial create.
>
> But doesn't multipathd try to add these devices too?

In our case, no.
What we did is to remove condition 1 for "find_multipaths yes".
So, unless someone (or something) else adds the wwid to the
wwids file, the path is ignored.
Doing this way, it is our storage manager that decides when it is time 
for a path to be used by multipath and, to this end, it invokes
multipath -r.

So, from our point of view, there should not be interactions with
multipathd but I could be wrong.

For what concerns udev, I am not sure what are your intentions about
the lock.
If it is just to protect udev and multipathd, then we could have 
problems with multipath.

Germano

>
> -Ben
>
