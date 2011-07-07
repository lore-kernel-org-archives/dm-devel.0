From: Roberto Giordani <r.giordani@libero.it>
Subject: Re: Multipathd on Opensuse 11.4 x64 buffer overwflow
 when starting with -D args too
Date: Thu, 07 Jul 2011 17:59:39 +0200
Message-ID: <4E15D7EB.5020400@libero.it>
References: <4E137232.8030603@libero.it> <4E1401EE.7050703@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4E1401EE.7050703@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

Great!
It works very well.

Thanks.
Roberto.

On 07/06/2011 08:34 AM, Hannes Reinecke wrote:
> On 07/05/2011 10:21 PM, Roberto Giordani wrote:
>> Hello,
>> as described on Bug 693131
>>
>> the
>>
>> +ARGS="-d&>/dev/null&"
>>
>> workaround doesn't work for me. :-(
>>
>> I've tried to build the last multipath.tools 0.4.9 on Opensuse 11.4 x64
>> and the build seems ok, but after run
>> multipathd the system hang for few seconds and than fails.
>>
>> I've tried to build RPMs too, but I have received an error when try to
>> use library on /lib and not on /lib64.
>> Changing the path on the Makefile I've  receive another error.
>>
>> Could someone help me, because on opensuse 11.2 and 11.3 the multipath
>> works fine.
>>
> Sorry for this, but I've been pretty busy lately with a new release
> coming on etc.
>
> Most of my outstanding patches have been pushed upstream.
> Unfortunately I've found some more issues in the meantime, which still
> have to be pushed.
>
> I'll see to have it fixed up.
>
> Meanwhile you could try my multipath-tools git tree at
>
> git://git.kernel.org/pub/scm/linux/kernel/git/hare/multipath-tools.git
> branch sles11-sp2
>
> That should work on 11.4, too.
>
> Cheers,
>
> Hannes
