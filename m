From: Michael Lyulko <michaell@voltaire.com>
Subject: Re: Failover between two paths to one LU doesn't work
	onlinux-iscsi
Date: Wed, 18 Oct 2006 20:55:24 +0200
Message-ID: <4536789C.70807@voltaire.com>
References: <452BD5C6.2080808@voltaire.com>
	<452BD768.30206@ilm.com>	<452BFAA0.1000100@voltaire.com>	<1160576205.4819.13.camel@linux-cxyg.rtp.netapp.com>	<452E8E50.3080507@voltaire.com>
	<1160684886.6294.9.camel@dhcp59-220.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1160684886.6294.9.camel@dhcp59-220.rdu.redhat.com>
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

David Wysochanski wrote:
> On Thu, 2006-10-12 at 20:49 +0200, Michael Lyulko wrote:
>   
>> Dave Wysochanski wrote:
>>     
>>>> I ran iozone benchmark and manually failed one of two paths. There was 
>>>> no failover to second path.
>>>> The iSCSI initiator retried to reconnect to the first path - 
>>>> unsuccessfully. When I restored the first
>>>> path - the initiator reconnected to the target via the first path.
>>>>
>>>> Thanks!
>>>>
>>>> ------------- INFO -------------
>>>> Versions:
>>>> device-mapper-1.01.01-1.6
>>>> multipath-tools-0.4.5-0.11
>>>>
>>>> Machine:
>>>> 2.6.5-7.244-smp; x86_64; SLES9 sp3
>>>>
>>>>     
>>>>         
>>> Did you set ConnFailTimeout to a non-zero value?  This sounds like it's
>>> still at default (reconnect indefinately).  You also need to set the
>>> Multipath variable, but it sounds like you may have done that already.
>>>
>>>
>>>
>>> --
>>> dm-devel mailing list
>>> dm-devel@redhat.com
>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>>   
>>>       
>> Thanks! Now I set ConnFailTimeout=30 and when one of the paths failed a 
>> fail-over to
>> second path occurred (I had Multipath=portal). But after the first path 
>> is back (iSCSI session
>> is established and I can read from the device) multipath -l shows:
>> <snip>
>> \_ round-robin 0 [enabled]
>>  \_ 0:0:6:0 sda 8:0  [failed][ready]            //   still "failed" - 
>> Michael
>> \_ round-robin 0 [active]
>>  \_ 0:1:6:0 sdb 8:16 [active][ready]
>>
>> 1. How can I configure the DM to automatically detect that a path is 
>> active again?
>>     
>
> you probably want "failback immediate"
> there's also been some bugs with failback - not sure about your version
> - your mileage may vary
>
>   
"failback immediate" didn't help on both SLES9 sp3 and SLES10. The 
device mapper doesn't
rescan automatically the paths, so when the failed path is back to life, 
it is still "failed"
in multipath -l output.
Issuing "multipath -p failover" helps to return the path back to 
"active". I need an automatic "rescan".
>> 2. I don't have a multipath.conf in /etc. Is 
>> /usr/share/doc/packages/multipath-tools/
>> the right place to take it from?
>>     
>
> Yes, you can start with this.  I think there may be a problem with some
> of the examples - make sure the "blacklist" keyword is correct - at some
> point it changed from "devnode_blacklist" to "blacklist" (not sure which
> one is in your version but example may be wrong).
>
>   
>> 3. What params in multipath.conf are a must in this case of fail-over 
>> setup regarding question no.1?
>>
>>     
>
> You might also want to look at no_path_retry and/or queue_if_no_path
> options.
>   
SLES9 sp3: both parameters are not in default multipath.conf, so I 
suppose they are not supported yet in this distribution.
SLES10:   no_path_retry doesn't help. queue_if_no_path is not in the 
default multipath.conf.

Here is my configuration:

SLES9 sp3: multipath.conf:
defaults {
        failback        immediate
}

SLES10: multipath.conf:
defaults {
        polling_interval 10
        failback        immediate
        no_path_retry  fail
}


Here is "multipath -l" output during the test:

SLES9 sp3:
before the path failed:
# multipath -l
dm names   N
dm table 3600d02300063ccc60000006215c0b501  N
dm table 3600d02300063ccc60000006215c0b501  N
dm status 3600d02300063ccc60000006215c0b501  N
dm info 3600d02300063ccc60000006215c0b501  O
3600d02300063ccc60000006215c0b501
[size=87 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 0:0:6:0 sda 8:0  [active][ready]
\_ round-robin 0 [enabled]
 \_ 0:1:6:0 sdb 8:16 [active][ready]


after the path is back again:
# multipath -l
dm names   N
dm table 3600d02300063ccc60000006215c0b501  N
dm table 3600d02300063ccc60000006215c0b501  N
dm status 3600d02300063ccc60000006215c0b501  N
dm info 3600d02300063ccc60000006215c0b501  O
3600d02300063ccc60000006215c0b501
[size=87 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 0:0:6:0 sda 8:0  [failed][ready]
\_ round-robin 0 [active]
 \_ 0:1:6:0 sdb 8:16 [active][ready]


SLES10:
before the path failed:
# multipath -l
320000004cffb0995SEAGATE,ST336607FC
[size=34G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 0:0:0:0 sda 8:0   [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:0 sdb 8:16  [active][undef]
#

after the path is back again:
# multipath -l
320000004cffb0995SEAGATE,ST336607FC
[size=34G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][enabled]
 \_ 0:0:0:0 sda 8:0   [failed][undef]
\_ round-robin 0 [prio=0][active]
 \_ 1:0:0:0 sdb 8:16  [active][undef]
#
