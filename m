From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: Re: [Consult-list] dm-multipath has great throughput
	but we'd like more!
Date: Thu, 18 May 2006 02:36:00 -0500
Message-ID: <2102bdeb4bf689abbe069a61be3e2a8e@redhat.com>
References: <1147935929.27006.57.camel@baggage>
	<1147936749.27006.59.camel@baggage>
	<20060518072749.GC26035@percy.comedia.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060518072749.GC26035@percy.comedia.it>
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


On May 18, 2006, at 2:27 AM, Luca Berra wrote:

> On Thu, May 18, 2006 at 08:19:09AM +0100, Bob Gautier wrote:
>> On Thu, 2006-05-18 at 08:05 +0100, Bob Gautier wrote:
>>> Yesterday my client was testing of multipath load balancing and 
>>> failover
>>> on a system running ext3 on a logical volume which comprises about 
>>> ten
>>> SAN LUNs all reached using multipath in multibus mode over two QL2340
>>> HBAs.
>>
>> Sorry, should have also said: RHEL4u3 x86_64 on DL385 with 16Gb memory
>>
> you could have added the storage model :)
> btw did you do any tuning (i.e. readhaead, scheduler) ?
>

You may also want to do raw through-put testing (lmdd perhaps) to get a 
baseline.  Certainly, the file system has to be bringing down the 
bandwidth somewhat...

  brassow
