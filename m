From: Asif Iqbal <vadud3@gmail.com>
Subject: Re: dmsetup status not clear
Date: Thu, 5 Mar 2009 14:29:02 -0500
Message-ID: <a60f25fc0903051129r475e3133v5f9f1fac1866014d@mail.gmail.com>
References: <a60f25fc0903041435ob7e7575kc2ebe0770d5cd36e@mail.gmail.com>
	<20090305162053.GB29061@mars.virtualiron.com>
	<a60f25fc0903050835k36025e9arf3238685a5f3f707@mail.gmail.com>
	<20090305171526.GA29729@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090305171526.GA29729@mars.virtualiron.com>
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

On Thu, Mar 5, 2009 at 12:15 PM, Konrad Rzeszutek
<konrad@virtualiron.com> wrote:
>> > cat /proc/dmstatus should give you some details.
>>
>> ~# cat /proc/dmstatus
>> cat: /proc/dmstatus: No such file or directory
>
> Ugh. /proc/mdstat I think.

# cat /proc/mdstat
cat: /proc/mdstat: No such file or directory

>
>
> .. snip ..
>> iqbala@ftp0:~$ sudo dmsetup status
>> nvidia_eeffhbef5: 0 6458067 linear
>> nvidia_eeffhbef1: 0 149838192 linear
>> nvidia_eeffhbef: 0 156301486 mirror 2 8:0 8:16 1193/1193 1 AA 1 core
>>
>> It was '1183/1193 1 AD 1 core' and now '1193/1193 1 AA 1 core'
>>
>> What are the differences? Is there some doc where I can read more about this?
>
> It is divided in two groups. The first is the
> type and the size (0 156301486 mirror): meaning 156301486 sectors, or:
> 76319MB, and the kernel module that oversears this device is 'dm-mirror'.
>
> The next group of data is from 'mirror_status' function (from the dm-raid1 module, which
> actually registers itself as 'dm-mirror'). Take a look
> at drivers/md/dm-raid1.c and the above mentioned function - that should
> give you an idea what is what.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



-- 
Asif Iqbal
PGP Key: 0xE62693C5 KeyServer: pgp.mit.edu
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
