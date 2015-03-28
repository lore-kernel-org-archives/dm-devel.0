From: guy keren <guy.keren@kaminario.com>
Subject: Re: A path to a different device was added to an
 existing mapth
Date: Sat, 28 Mar 2015 14:32:11 +0300
Message-ID: <5516913B.9080600@kaminario.com>
References: <1426759835576.51213@kaminario.com>	
	<1426761325229.70001@kaminario.com>
	<1427498782.22396.29.camel@ict-vth-stewarts01.ict.englab.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1427498782.22396.29.camel@ict-vth-stewarts01.ict.englab.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Stewart, Sean" <Sean.Stewart@netapp.com>, device-mapper development <dm-devel@redhat.com>
Cc: Eli Malul <eli.malul@kaminario.com>, Shahar Salzman <shahar.salzman@kaminario.com>
List-Id: dm-devel.ids


hi Sean,

in the case stated, the host was not rebooted during this test. what has 
changed is LUNs exposure to the host (unmapping and re-mapping of LUNs, 
deleting and re-creating of LUNs).

could these kind of operations trigger similar issues?

from what we saw, multipathd's state made it think that some paths, that 
have different WWIDs, should be bound to the same multipath device 
(which is incorrect).

a different question comes to mind:

   if we avoid using the friendly names, and instead use the 
/dev/mapper/<wwid> device paths - is this likely to avoid the problem in 
the first place?

--guy


On 03/28/2015 02:26 AM, Stewart, Sean wrote:
> Hi Ilan,
>
>
> I believe this is solved by the following patch:
> http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=commit;h=5adec73edcdee912821ca8378439dc105e82c60f
>
> Per the patch description:
> When a system is booted to the SAN, a condition can occur where one
> user friendly name is given to a disk during boot, but multipathd tries
> to allocate a different one after boot. If the second alias is already
> used by another device, multipathd can't rename it. Multipathd then has
> incorrect information about the alias/wwid relationships, which can
> result in paths being added to the wrong map.
>
> On Thu, 2015-03-19 at 10:35 +0000, Ilan Steinberg wrote:
>
>> multipathd> show maps
>> name    sysfs uuid
>> mpathiw dm-13 20024f400d5190010
> This shows the current running configuration, that multipathd is
> operating believing that mpathiw should have be 20024f400d5190010.
>
>> This might be useful info - in the bindings file I see:
>>
>> ...
>>
>> mpathiv 20024f400d5190010
>> <---------------------------------------- this is the scsi_sn of sdag
>>
>> mpathiw 20024f400d5190026
>> <---------------------------------------- this is the scsi_sn of sdz/w
>>
>> ...
>>
> So what must have happened was that the bindings file was out of sync on
> the initramfs and the local fs (which you can check by unwrapping the
> initramfs and comparing the wwids in each file), and it created the
> device with one name, tried to rename it, couldn't, and multipathd then
> starts adding into the wrong map. It's hard to explain clearly. :)  If
> we could see what both bindings files say, maybe I could explain it
> better.
>
> To work around it, remaking the initramfs to sync the bindings should
> suffice, or you could define aliases via the multipath sections
> multipath.conf.
>
> Hope this helps.
>
>
> Thanks,
> Sean Stewart
>
>
