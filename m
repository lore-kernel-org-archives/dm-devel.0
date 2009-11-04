From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH 07/18] Replicator: suspend/deactivate
	replicator
Date: Wed, 04 Nov 2009 11:05:41 +0100
Message-ID: <hcrjlm$17p$1@ger.gmane.org>
References: <1257171622-8380-1-git-send-email-zkabelac@redhat.com>	<1257171622-8380-2-git-send-email-zkabelac@redhat.com>	<1257171622-8380-3-git-send-email-zkabelac@redhat.com>	<1257171622-8380-4-git-send-email-zkabelac@redhat.com>	<1257171622-8380-5-git-send-email-zkabelac@redhat.com>	<1257171622-8380-6-git-send-email-zkabelac@redhat.com>	<1257171622-8380-7-git-send-email-zkabelac@redhat.com>	<1257171622-8380-8-git-send-email-zkabelac@redhat.com>
	<20091103164613.GA26722@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091103164613.GA26722@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Dne 3.11.2009 17:46, Mike Snitzer napsal(a):
> On Mon, Nov 02 2009 at  9:20am -0500,
> Zdenek Kabelac <zkabelac@redhat.com> wrote:
> 
>> Introducing dm_tree_set_replicator_suspend() to suspend
>> replicator control device before actual deactivation of replicator-dev
>> head device.
>>
>>
>>  	int activation_priority;	/* 0 gets activated first */
>> +	int replicator_suspend;		/* 1 gets suspend first */
>>  
>>  	uint16_t udev_flags;		/* Udev control flags */
>>  
> 
> I think it would be wise to make this more generic,
> e.g. "suspend_priority".
> 
> It could be that other future devices would like to prioritize the
> suspend sequence too.  Having a means to do so (without using a
> seemingly replicator-specific node attribute) would be good.
> 
> So this really just amounts to: s/replicator_suspend/suspend_priority/


  I think using 'priority' would be more challenging here - for replicator it
is only needs to check parental node - while with priority you would probably
expect full tree traversal to see whether there is node which should be
suspend in front of current device - thought the code could be probably
extended in a way to specify recursive traversal depth - for replicator tree
depth 1 is enough.

  Previous implementation was probably more generic in this, but required API
changes - the use case for current implementation is rather focused on the
replicator's needs with the advantage, it will not influence anything else.

  I think at this moment this API is static internal and might be probably
easily changed/modified once some similar target would need to use it ?
(It's not easy to predict future use case)

Zdenek
