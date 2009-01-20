From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: Re: [RFC] [PATCH] lvm2: mirroredlog support
Date: Tue, 20 Jan 2009 14:52:20 -0500
Message-ID: <49762B74.9080301@redhat.com>
References: <20081230001055.GA13710@us.ibm.com>
	<49750524.3030007@redhat.com>	<20090120015427.GA16550@us.ibm.com>	<497579AB.4060503@linux.vnet.ibm.com>
	<20090120173817.GA9601@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090120173817.GA9601@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: malahal@us.ibm.com, raspl@linux.vnet.ibm.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

> Stefan Raspl [raspl@linux.vnet.ibm.com] wrote:
>> If I understand Takahiro correctly, the main issue is that the whole
>> log device becomes unusable in case one leg is broken...? Of course,
>> we still have the other leg with the most recent data available and
>> can read from that one. However, this would require that we can
>> start a mirror in rw-mode (so we can keep the still-recent half up
>> to date) even if one half has failed - a functionality which was
>> recently added to LVM, as we discussed in our last call...?
> 
> Stefan, Takahiro is using the latest LVM that brings LVs in rw-mode.
> That is not the problem. Actually, everything works if a slave leg of a
> "log mirror" is broken. But if the master leg of the "log mirror" is
> broken, entire log device becomes unusable. The reason is when we
> activate the "log mirror", it always synchronizes the data from the
> master leg to slave leg since it has no log device (as the "log mirror"
> uses "corelog"). In other words, the "log mirror" always starts in "not
> in sync" state and synchronizes.
> 
> If the master leg is broken for the "log mirror", it starts in "not in
> sync" state and tries to copy data from the "broken leg" to the active
> leg! This appears as the master leg failure while doing synchronization
> which makes the whole device unusable.
> 
>> I'm not sure if I understand his statements about the
>> synchronization correctly. Why would any synchronization within the
>> data mirror occur at all? It's only the log which is broken, not the
>> actual data in vg00-lv00_mimage_0/1. If any synchronization in the
>> _data_ mirror occurs just because one leg in the _log_ mirror has a
>> problem, I'd consider that a bug.
> 
> Since the entire log device is unusable with its "master device
> broken", the "data mirror" goes for synchronization.

Thank you for the good explanation, Malahal. You are explaining exactly
what I need to say. I'm using LVM2.2.02.43, on which this mirroredlog
patch is built.

Thanks,
Taka
