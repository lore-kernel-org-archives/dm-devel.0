From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Dumb question; please help
Date: Thu, 07 May 2015 10:49:33 +0200
Message-ID: <554B271D.2080006@redhat.com>
References: <CAC5dixFNZ_FBQ8osQiCgDuvXrWBNydC2A173o4RfYqcWCX814Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAC5dixFNZ_FBQ8osQiCgDuvXrWBNydC2A173o4RfYqcWCX814Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 6.5.2015 v 19:45 Locane napsal(a):
> Hello, I apologize in advance for asking this question, but I can't seem to
> find the information in documentation or anything online.
>
> Short explanation:
>
> - I have a CentOS 6.6 LiveCD that is dying after lots of file system thrash
> - I use "dmsetup status" to check on when it's dying
> - I don't know what the numbers in "dmsetup status" represent - they're not
> labeled
>
> Can anyone answer this question
> <http://superuser.com/questions/900783/dmsetup-status-fields-explained> or
> label the following fields for me and explain what they are?
>
> [root@localhost ~]# dmsetup status
> live-osimg-min: 0 4194304 snapshot 1272/1272 16
> live-rw: 0 4194304 snapshot 7568/1048576 40
>
> What are the <number>/<number>s?  What is the 2 digit number following them?
>
> My LiveCD dies when the 7568 number in this example gets to the (I assume
> gibabyte) 1048576 number.  Can I increase this base size?
>
> I apologize again for asking such a rudimentary question on this mailing list,
> but I am desperate.
>


I'd say your snapshot volume 'live-osimg-min' has got out of space - and as 
such it has been already invalidated (data are LOST).

The snapshot has 'reserved' space for  COW blocks - when this space is 
exhausted, snapshot is lost as it cannot hold any more exception blocks.

Normally you could run 'dmeventd' and monitor 'free' space in snapshot and let 
the tool to resize snapshot to add more space, but in your case it's already 
too late.

Also I'd recommend to learn how to use 'lvm2' commands  before you start to 
play with low level dmsetup commands.

And to satisfy your curiosity about what those numbers means - here is the 
full description:
https://www.kernel.org/doc/Documentation/device-mapper/snapshot.txt

Regards

Zdenek
