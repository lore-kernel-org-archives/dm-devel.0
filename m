From: shane bradley <sbradley@redhat.com>
Subject: Re: multipath.conf and polling_interval
	option	seems	misleading
Date: Thu, 29 Jan 2009 11:21:06 -0500
Message-ID: <4981D772.9090704@redhat.com>
References: <4970AFB8.6090906@redhat.com>	<1232122255.29644.23.camel@chandra-ubuntu>
	<4970B41C.1000509@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030006040808050604020906"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4970B41C.1000509@redhat.com>
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

This is a multi-part message in MIME format.
--------------030006040808050604020906
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Patch attached for updated wording of documentation on polling_interval.


shane bradley wrote:
> Yeah the wording I think is the problem. Someone familiar with source 
> code or multipathing will read that option differently.
>
> When someone reads the word path, they think of a single path to lun, 
> then wait, check the next path to single lun.
> They are  not thinking of all paths are checked at same time.
>
> After thinking about it, this would not be good behaviour because it 
> could take forever (minutes) before a path is found dead.
> I think the problem is just the description of the option 
> "polling_interval", it should be made clearer.
>
> --sbradley
>
> Chandra Seetharaman wrote:
>> On Fri, 2009-01-16 at 11:03 -0500, shane bradley wrote:
>>  
>>> After reviewing the code and doing some testing I have noticed that 
>>> polling_interval did not work as expected.
>>> I had reviewed the description of the option for multipath.conf and 
>>> it conflicted with the results that I had got
>>> testing device-mapper-multipath on RHEL4/RHEL5.
>>>
>>> $ cat 
>>> /usr/share/doc/device-mapper-multipath-0.4.7/multipath.conf.annotated
>>> #       # name    : polling_interval
>>> #       # scope   : multipathd
>>> #       # desc    : interval between two path checks in seconds
>>> #       # default : 5
>>> #       #
>>> #       polling_interval 10
>>>
>>> ---------
>>>
>>> The behaviour that I had expected based on the option's description 
>>> above:
>>> check path 1
>>> wait polling_interval
>>> check path 2
>>> wait polling_interval
>>> check path 1
>>> wait polling_interval
>>> check path 2
>>> wait polling_interval
>>>
>>> However after testing the results that I got was(with multipathd -v4):
>>> example:
>>> check path 1
>>> check path 2
>>> wait polling_interval
>>> check path 1
>>> check path 2
>>> wait polling_interval
>>>
>>> ---------
>>>
>>> The behaviour I seen in RHEL4 and RHEL5 was working as design after
>>> reviewing the code and talking to a couple engineers.
>>>
>>> The problem it seems is how I was reading the description of the 
>>> option.
>>>  From my results in testing and talking with some engineers the 
>>> "polling_interval" option actually means:
>>>
>>> "The interval between checking all possible paths for all multipath 
>>> paths"
>>> ----------
>>>
>>> 1) Is my assumption correct that "polling_interval" actually means:
>>> "The interval between checking all possible paths for all multipath 
>>> paths"
>>>
>>> 2) What is a better way to describe the "polling_interval" option?
>>>
>>> 3) Shouldn't we make it clearer for people who don't that that much 
>>> experience with multipathing?
>>>     
>>
>> IMO, the behavior seen is the proper behavior.
>>
>> If it does as per your interpretation, the seconds between checking of
>> the same path will depend on the number of paths to a storage, which may
>> not be acceptable.
>>
>> May be the wording in multipath.conf.annotated should be made clear.
>>
>>  
>>> --sbradley
>>>
>>> -- 
>>> dm-devel mailing list
>>> dm-devel@redhat.com
>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>>     
>>
>> -- 
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>   
>
> -- 
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--------------030006040808050604020906
Content-Type: text/plain;
	name="multipath.conf.annotated-polling_interval.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="multipath.conf.annotated-polling_interval.patch"

--- multipath.conf.annotated.org	2009-01-29 11:03:22.000000000 -0500
+++ multipath.conf.annotated	2009-01-29 11:16:29.000000000 -0500
@@ -18,7 +18,8 @@
 #	#
 #	# name    : polling_interval
 #	# scope   : multipathd
-#	# desc    : interval between two path checks in seconds
+#	# desc    : the interval in seconds between polling all 
+#               devices that compose up all multipath devices
 #	# values  : n > 0
 #	# default : 5
 #	#

--------------030006040808050604020906
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------030006040808050604020906--
