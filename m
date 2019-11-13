From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: [PATCH RT 2/2 v2] list_bl: avoid BUG when the list is not locked
Date: Wed, 13 Nov 2019 13:50:59 +0200
Message-ID: <7020d479-e8c7-7249-c6cd-c6d01b01c92a@arrikto.com>
References: <alpine.LRH.2.02.1911121110430.12815@file01.intranet.prod.int.rdu2.redhat.com>
 <335dafcb-5e07-63ed-b288-196516170bde@arrikto.com>
 <alpine.LRH.2.02.1911130616240.20335@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1911130616240.20335@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: tglx@linutronix.de, linux-rt-users@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>, Scott Wood <swood@redhat.com>, Ilias Tsitsimpis <iliastsi@arrikto.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: dm-devel.ids

On 11/13/19 1:16 PM, Mikulas Patocka wrote:
> 
> 
> On Wed, 13 Nov 2019, Nikos Tsironis wrote:
> 
>> On 11/12/19 6:16 PM, Mikulas Patocka wrote:
>>> list_bl would crash with BUG() if we used it without locking. dm-snapshot 
>>> uses its own locking on realtime kernels (it can't use list_bl because 
>>> list_bl uses raw spinlock and dm-snapshot takes other non-raw spinlocks 
>>> while holding bl_lock).
>>>
>>> To avoid this BUG, we must set LIST_BL_LOCKMASK = 0.
>>>
>>> This patch is intended only for the realtime kernel patchset, not for the 
>>> upstream kernel.
>>>
>>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>>
>>> Index: linux-rt-devel/include/linux/list_bl.h
>>> ===================================================================
>>> --- linux-rt-devel.orig/include/linux/list_bl.h	2019-11-07 14:01:51.000000000 +0100
>>> +++ linux-rt-devel/include/linux/list_bl.h	2019-11-08 10:12:49.000000000 +0100
>>> @@ -19,7 +19,7 @@
>>>   * some fast and compact auxiliary data.
>>>   */
>>>  
>>> -#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
>>> +#if (defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)) && !defined(CONFIG_PREEMPT_RT_BASE)
>>>  #define LIST_BL_LOCKMASK	1UL
>>>  #else
>>>  #define LIST_BL_LOCKMASK	0UL
>>> @@ -161,9 +161,6 @@ static inline void hlist_bl_lock(struct
>>>  	bit_spin_lock(0, (unsigned long *)b);
>>>  #else
>>>  	raw_spin_lock(&b->lock);
>>> -#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
>>> -	__set_bit(0, (unsigned long *)b);
>>> -#endif
>>>  #endif
>>>  }
>>>  
>>
>> Hi Mikulas,
>>
>> I think removing __set_bit()/__clear_bit() breaks hlist_bl_is_locked(),
>> which is used by the RCU variant of list_bl.
>>
>> Nikos
> 
> OK. so I can remove this part of the patch.
> 

I think this causes another problem. LIST_BL_LOCKMASK is used in various
functions to set/clear the lock bit, e.g. in hlist_bl_first(). So, if we
lock the list through hlist_bl_lock(), thus setting the lock bit with
__set_bit(), and then call hlist_bl_first() to get the first element,
the returned pointer will be invalid. As LIST_BL_LOCKMASK is zero the
least significant bit of the pointer will be 1.

I think for dm-snapshot to work using its own locking, and without
list_bl complaining, the following is sufficient:

--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -25,7 +25,7 @@
 #define LIST_BL_LOCKMASK       0UL
 #endif

-#ifdef CONFIG_DEBUG_LIST
+#if defined(CONFIG_DEBUG_LIST) && !defined(CONFIG_PREEMPT_RT_BASE)
 #define LIST_BL_BUG_ON(x) BUG_ON(x)
 #else
 #define LIST_BL_BUG_ON(x)

Nikos

> Mikulas
> 
>>> @@ -172,9 +169,6 @@ static inline void hlist_bl_unlock(struc
>>>  #ifndef CONFIG_PREEMPT_RT_BASE
>>>  	__bit_spin_unlock(0, (unsigned long *)b);
>>>  #else
>>> -#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
>>> -	__clear_bit(0, (unsigned long *)b);
>>> -#endif
>>>  	raw_spin_unlock(&b->lock);
>>>  #endif
>>>  }
>>>
>>
> 
