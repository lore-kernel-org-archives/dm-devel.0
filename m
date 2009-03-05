From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: dmsetup status not clear
Date: Thu, 5 Mar 2009 12:15:26 -0500
Message-ID: <20090305171526.GA29729@mars.virtualiron.com>
References: <a60f25fc0903041435ob7e7575kc2ebe0770d5cd36e@mail.gmail.com>
	<20090305162053.GB29061@mars.virtualiron.com>
	<a60f25fc0903050835k36025e9arf3238685a5f3f707@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <a60f25fc0903050835k36025e9arf3238685a5f3f707@mail.gmail.com>
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

> > cat /proc/dmstatus should give you some details.
> 
> ~# cat /proc/dmstatus
> cat: /proc/dmstatus: No such file or directory

Ugh. /proc/mdstat I think.


.. snip ..
> iqbala@ftp0:~$ sudo dmsetup status
> nvidia_eeffhbef5: 0 6458067 linear
> nvidia_eeffhbef1: 0 149838192 linear
> nvidia_eeffhbef: 0 156301486 mirror 2 8:0 8:16 1193/1193 1 AA 1 core
> 
> It was '1183/1193 1 AD 1 core' and now '1193/1193 1 AA 1 core'
> 
> What are the differences? Is there some doc where I can read more about this?

It is divided in two groups. The first is the
type and the size (0 156301486 mirror): meaning 156301486 sectors, or:
76319MB, and the kernel module that oversears this device is 'dm-mirror'.

The next group of data is from 'mirror_status' function (from the dm-raid1 module, which
actually registers itself as 'dm-mirror'). Take a look
at drivers/md/dm-raid1.c and the above mentioned function - that should
give you an idea what is what.
