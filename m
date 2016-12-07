From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 3/3] multipathd: Add 'sysfs' prioritizer
Date: Wed, 7 Dec 2016 19:34:23 +0100
Message-ID: <9d619546-b661-77a3-f487-2cf6e04cbbdd@gmail.com>
References: <1468565337-5178-1-git-send-email-hare@suse.de>
	<1468565337-5178-4-git-send-email-hare@suse.de>
	<60729efa-12ad-aa28-f657-1b8ec6dbd4d2@gmail.com>
	<a6e52ead-dda3-13e5-c033-2719102aeaa9@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a6e52ead-dda3-13e5-c033-2719102aeaa9@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 11/09/2016 07:49 AM, Hannes Reinecke wrote:

> On 11/08/2016 07:52 PM, Xose Vazquez Perez wrote:
>> On 07/15/2016 08:48 AM, Hannes Reinecke wrote:
>>
>>> Recent kernels have an 'access_state' attribute which allows
>>> us to read the asymmetric access state directly from sysfs.
>>
>> Hi Hannes,
>>
>> with this patch it's impossible to select/autodetect ALUA.
>> sysfs always takes precedence over alua.
>>
>> "detect_prio no" was added to overrides section, to make
>> it work again.
>>
>> SLES 12-SP2
>>
>> Thank you.
>>
> But this was precisely the idea.
> (After all, it says 'auto-detect', right?)
> 
> For ALUA-capable arrays we have a reliable priority detection with the ALUA device-handler.
> So it's far preferable to use the sysfs-provided information (as they are populated by the ALUA device-handler); the ALUA prioritizer in multipath-tools will be used as a fallback in case the device
> handler isn't loaded or the sysfs files are not present.
> Using the sysfs handler has the neat side effect that you don't need to do I/O for detecting the priority, thereby eliminating one possible cause for multipath being stuck during failover.

Thanks for the explanation.


As collateral effect, because the sysfs-handler output is too
brief, the asymmetric access state(aas) was lost:


Dec 07 19:26:51 | sda: prio = sysfs (detected setting)
Dec 07 19:26:51 | sda: sysfs prio = 50
----
Dec 07 19:26:29 | sdc: prio = alua (detected setting)
Dec 07 19:26:29 | reported target port group is 1		<----- lost
Dec 07 19:26:29 | aas = 80 [active/optimized] [preferred]	<----- lost
Dec 07 19:26:29 | sdc: alua prio = 50
