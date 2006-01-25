From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: EMC CX LUN problem
Date: Wed, 25 Jan 2006 02:16:29 +0100
Message-ID: <43D6D16D.1060909@bzed.de>
References: <43D69CB0.8020402@theorematica.it>
	<1138141690.6009.8.camel@ca-bwong3.trans.corp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1138141690.6009.8.camel@ca-bwong3.trans.corp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bwong@pillardata.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

>>I'm trying to configure a new emc cx storage, I have the following:
>>    
>>
>>I defined two lun on the storage however I'm able to see only one LUN
>>
>>multipath -l show the following:
>>
>>multipath -l
>>mail (36006016086f01600e46f567adb8cda11)
>>[size=150 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
>>\_ round-robin 0 [active]
>> \_ 1:0:1:0 sdd 8:48  [active][ready]
>> \_ 1:0:1:1 sde 8:64  [active][ready]
>> \_ 2:0:1:0 sdh 8:112 [active][ready]
>> \_ 2:0:1:1 sdi 8:128 [active][ready]
>>\_ round-robin 0 [enabled]
>> \_ 2:0:0:0 sdf 8:80  [active][ready]
>> \_ 1:0:0:0 sdb 8:16  [active][ready]
>> \_ 1:0:0:1 sdc 8:32  [active][ready]
>> \_ 2:0:0:1 sdg 8:96  [active][ready]
>>
>>    
>>
did you probably just share one raid group via 2 LUNs? Then the output
of multipath is imho indeed right. For me it shows the setup you've
described - one raidgroup, shared via 2 LUNs (usually one per default on
SP A, one on SP B, attached via 2 paths per SP to a switch, accessed
from your server via 2 HBAs.
If you have access to the Navisphere cli tool - please post the output of

./navicli -h IP_OF_ONE_OF_YOUR_SPs getlun

I think this will show that my hint is right.
Imho you want to create a second raid group and share it via 2 LUNs, too.

>http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=TestedEnvironments
>  
>
I hope there's nothing wring with the stuff I've written about the
EMC/CX in there, if you find anything please let me know - I don't look
in there often.


Hope that helps,

best regards


Bernd
