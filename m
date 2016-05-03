From: Germano Percossi <germano.percossi@citrix.com>
Subject: Re: [PATCH 28/57] libmultipath: use a shared lock to
 co-operate with udev
Date: Tue, 3 May 2016 16:31:19 +0100
Message-ID: <5728C447.9050307@citrix.com>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-29-git-send-email-hare@suse.de>
	<20160502162617.GS26117@octiron.msp.redhat.com>
	<57283DAD.9040009@suse.de>
	<20160503142732.GB26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160503142732.GB26117@octiron.msp.redhat.com>
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

Hi,

Sorry for jumping in the middle of patch review

On 05/03/2016 03:27 PM, Benjamin Marzinski wrote:
> On Tue, May 03, 2016 at 07:57:01AM +0200, Hannes Reinecke wrote:
>> On 05/02/2016 06:26 PM, Benjamin Marzinski wrote:
>>> On Wed, Apr 27, 2016 at 01:10:29PM +0200, Hannes Reinecke wrote:
>> This is primarily for co-operation with udev.
>> As we typically do _not_ use multipath for creating device-mapper tables
>> the synchronisation problem between multipath and multipathd
>> doesn't typically occur.
>> At least not for us :-)
>
> Well, it doesn't occur for us either, unless someone runs multipath at
> EXACTLY the wrong time, at which case, I'm pretty sure the same thing
> can happen in any distro. The question is, do we protect against that
> very unlikely occurance.  The only time I see this actually having any
> real chance to occur would be if some multipath user writes a script
> that listens for new devices to be discovered, and then *helpfully* runs
> multipath to update the system. I have seen this. Multiple times, in
> fact. I'm not sure how much work we need to expend saving these people
> from themselves, however.
>

I just want to make sure XenServer is not among those that need to
be saved from themselves.
We do mix multipathd and multipath commands but in a way that we think
is safe: we add devices with "multipath -r" and remove with "multipath -f".
This is because we slightly bend the wwids file usage to be used
as a blacklisting mechanism (in our own way).

I am wondering if removing cooperation between multipath and multipathd
is going to cause us troubles in the future.

Regards,
Germano
