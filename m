From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: multipath.conf and polling_interval option
	seems	misleading
Date: Fri, 16 Jan 2009 16:13:12 +0000
Message-ID: <4970B218.7090306@redhat.com>
References: <4970AFB8.6090906@redhat.com>
	<1232122255.29644.23.camel@chandra-ubuntu>
Reply-To: bmr@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1232122255.29644.23.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Chandra Seetharaman wrote:
>> The behaviour I seen in RHEL4 and RHEL5 was working as design after
>> reviewing the code and talking to a couple engineers.
>>
>> The problem it seems is how I was reading the description of the option.
>>  From my results in testing and talking with some engineers the 
>> "polling_interval" option actually means:
>>
>> "The interval between checking all possible paths for all multipath paths"
>> ----------
>>
>> 1) Is my assumption correct that "polling_interval" actually means:
>> "The interval between checking all possible paths for all multipath paths"
>>
>> 2) What is a better way to describe the "polling_interval" option?
>>
>> 3) Shouldn't we make it clearer for people who don't that that much 
>> experience with multipathing?
> 
> IMO, the behavior seen is the proper behavior.
> 
> If it does as per your interpretation, the seconds between checking of
> the same path will depend on the number of paths to a storage, which may
> not be acceptable.
> 
> May be the wording in multipath.conf.annotated should be made clear.

Agreed - I'd not even really thought about this until Shane brought it 
up as I'd read the description to mean exactly what the code does.

It does seem that some users are puzzled by this behaviour - can't 
hurt to make the wording a little more explicit for this option.

Regards,
Bryn.
