From: Thomas Witzel <witzel.thomas@gmail.com>
Subject: Re: configure MD3000 episode 2
Date: Tue, 24 Mar 2009 10:58:50 -0400
Message-ID: <d1392840903240758o853e371q114f607aefc873a5@mail.gmail.com>
References: <d1392840903201754g119199d1u5b3863ba3a96abad@mail.gmail.com>
	<20090323143127.GA12731@mars.virtualiron.com>
	<d1392840903230844pe310cceya9160bcbe274b735@mail.gmail.com>
	<d1392840903231405p7b99846g65882690df77e96b@mail.gmail.com>
	<20090324140654.GA1606@mars.virtualiron.com>
	<d1392840903240724m55f0f519g48b3b6c778cb727e@mail.gmail.com>
	<20090324144828.GA20007@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090324144828.GA20007@us.ibm.com>
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

I heard people having issues with centos/multipath as well, not clear
whether it applies to me. I just had a mini-breakthrough. Since the
udev documentation says that the default rule should create /dev/dm-*
when the kernel name comes up, unless specified *OTHERWISE* I removed
all those rules that were named dmsetup,dmadm and lvm2. Low and behold
now the devices are created. Now I only have to find
out why the kpartx rule is not called.

Thomas


On Tue, Mar 24, 2009 at 10:48 AM, malahal <malahal@us.ibm.com> wrote:
> Thomas Witzel [witzel.thomas@gmail.com] wrote:
>> > Huh? Ubuntu charges license fees on GPL code? I think you are confusing
>> > what you are paying - it isn't license fee but support fee.
>>
>> Thats not what I meant. I know that my hardware config does work out
>> of the box with RHEL, but we do not want to pay RHEL, and with ubuntu
>> I have not been able to get any of this to work for 3 weeks now and I
>> have not been able to get help/support on the issue, so I was asking
>> whether there is a different free distribution that won't put me
>> through these time consuming google/mailing list/debug orgies to get
>> some storage mounted.
>>
>> Thomas
>
> Maybe CentOS ?
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
