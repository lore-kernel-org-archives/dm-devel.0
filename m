From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCHES] new barriers - 2
Date: Fri, 17 Apr 2009 10:26:56 -0400
Message-ID: <49E891B0.4080103@redhat.com>
References: <4982D33E.60000@wpkg.org>
	<170fa0d20901300904l31d0c143ya02d6fb4de28c281@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <170fa0d20901300904l31d0c143ya02d6fb4de28c281@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Mike Snitzer wrote:
> On Fri, Jan 30, 2009 at 5:15 AM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>   
>>> Here I announce 2nd version my new barrier support patches:
>>> http://people.redhat.com/mpatocka/patches/kernel/barriers/
>>>
>>> They are against 2.6.29-rc3.
>>>
>>> The most important enhancement is that with these patches, device mapper
>>> is able to send barrier requests to lower devices.
>>>       
>> I guess it still won't work for those using LVM on md (Linux software RAID)
>> because md lacks barrier support? Do you know if someone is working on it?
>>     
>
> md raid1 has supported barriers since 2.6.17
>
> But I'm not aware of any md work being done to support barriers in
> other raid levels.  Judging by Neil Brown's thoughts on the matter
> (from 2006) it would seem unlikely he is putting effort to it, please
> see the following thread:
> http://marc.info/?l=linux-raid&m=115321319003578&w=2
> http://marc.info/?l=linux-raid&m=115335249503450&w=2
>
> cc'ing linux-raid to see if others have more insight
>   

Neil, Hannes,

Is Mike's assumption above still true - no plans/thoughts about doing 
barrier support for RAID5/6 and so on?

At least some things (the null barrier op) are in place now since your 
summary of a couple years back, does this make it easier?

Thanks!

Ric
