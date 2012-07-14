From: Zdenek Kaspar <zkaspar82@gmail.com>
Subject: Re: Linux RAID subsystem future
Date: Sat, 14 Jul 2012 23:41:12 +0200
Message-ID: <5001E778.5040600@gmail.com>
References: <jtn1c5$q0u$1@dough.gmane.org> <CACJz6Qsx-xNxDRw5kUqUpf9ogVp23jokHOdGL9xO=kqFXmiNZg@mail.gmail.com> <20120713063501.3f9a3bd8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120713063501.3f9a3bd8@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 07/12/2012 10:35 PM, NeilBrown wrote:
> On Thu, 12 Jul 2012 13:28:24 -0700 Drew <drew.kay@gmail.com> wrote:
> 
>>> Hello lists,
>>>
>>> I noticed recent patches added MD RAID compatibility into the DM
>>> subsystem. Is there a valid reason to duplicate efforts ?
>>>
>>> Hopefully its not silent preparation step for DM takeover. Can someone
>>> shed more light on this topic ?
>>>
>>> TIA, Z.
>>
>> I'm not a developer by any stretch of the word so take what I say with
>> a grain of salt.
>>
>> I think it's more just a case of dm using md's RAID algorithms, which
>> IMHO are better tested, to support fakeraid controllers like Intel's
>> Matrix RAID. Besides, we're all one big happy linux family so why not
>> borrow your brother's socks? :-)
>>
>>
> Indeed!
> 
> It isn't duplication of effort - it is avoiding or removing duplication of
> effort.  That's the theory any way.
> 
> There is no "DM takeover" - just engineers working together to try to find
> optimal solutions.
> 
> NeilBrown
> 

So this Intel Matrix/Firmware RAID can be used to boot Linux with
/dev/mapper/target - DM-raid. DM-raid is missing some functionality,
most notable raid5 I guess, that was the main reason behind injecting
MD-raid code into DM?

What is clearly a good thing (multiple OS support, easier setup from
firmware and more raid levels to boot from) makes me wonder about MD
future. I'm sure this will attract users to use DM-raid in favor of
MD-raid, if its good or bad, time will tell.

Neil, don't take this in some BAD way please, I'm just not convinced of
dm-every{thing,where} movement. At least not yet..

TIA, Z.
