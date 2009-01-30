From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: [dm-devel] [PATCHES] new barriers - 2
Date: Fri, 30 Jan 2009 12:04:51 -0500
Message-ID: <170fa0d20901300904l31d0c143ya02d6fb4de28c281@mail.gmail.com>
References: <4982D33E.60000@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4982D33E.60000@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Jan 30, 2009 at 5:15 AM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>> Here I announce 2nd version my new barrier support patches:
>> http://people.redhat.com/mpatocka/patches/kernel/barriers/
>>
>> They are against 2.6.29-rc3.
>>
>> The most important enhancement is that with these patches, device mapper
>> is able to send barrier requests to lower devices.
>
> I guess it still won't work for those using LVM on md (Linux software RAID)
> because md lacks barrier support? Do you know if someone is working on it?

md raid1 has supported barriers since 2.6.17

But I'm not aware of any md work being done to support barriers in
other raid levels.  Judging by Neil Brown's thoughts on the matter
(from 2006) it would seem unlikely he is putting effort to it, please
see the following thread:
http://marc.info/?l=linux-raid&m=115321319003578&w=2
http://marc.info/?l=linux-raid&m=115335249503450&w=2

cc'ing linux-raid to see if others have more insight.
