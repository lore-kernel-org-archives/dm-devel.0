From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: device-mapper: device /dev/hdc too small for target
Date: Tue, 7 Feb 2006 14:55:39 -0600
Message-ID: <03ee370c27de419c858856bf24f5dadf@redhat.com>
References: <43E8DAD6.3030208@kreno.be> <20060207184106.GB22775@tik.ee.ethz.ch>
	<43E8EFA0.6050805@kreno.be>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43E8EFA0.6050805@kreno.be>
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

md and dm are two different things.  LVM uses dm, not md.

I can't really say I see what is wrong, but your binaries seem to be 
pretty old...

"device-mapper: 4.1.0-ioctl (2003-12-10) initialised: dm@uk.sistina.com"

  brassow

On Feb 7, 2006, at 1:06 PM, Thomas Berton wrote:

> Arno Wagner wrote:
>
>> If you do a 'cat /proc/mdstat', it needs to list the
>> 'linear' target, like this:
>>
>> root ~>cat /proc/mdstat Personalities : [linear] [raid0] [raid1] 
>> [raid5] [raid10] ...
>>
> This is my output:
>
> storage:~# cat /proc/mdstat
> Personalities : [linear] [multipath]
> unused devices: <none>
> storage:~#
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
