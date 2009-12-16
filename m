From: Milan Broz <mbroz@redhat.com>
Subject: Re: dm: sysfs add empty release function to avoid debug warning
Date: Wed, 16 Dec 2009 10:44:41 +0100
Message-ID: <4B28AC09.2000302@redhat.com>
References: <200912151735.nBFHZ8XP018683@hera.kernel.org> <20091216004739.GB4898@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754753AbZLPJow@vger.kernel.org>
In-Reply-To: <20091216004739.GB4898@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 12/16/2009 01:47 AM, Greg KH wrote:
> On Tue, Dec 15, 2009 at 05:35:08PM +0000, James Bottomley wrote:
>> commit: d2bb7df8cac647b92f51fb84ae735771e7adbfa7
>> From: Milan Broz <mbroz@redhat.com>
>> Date: Thu, 10 Dec 2009 23:51:53 +0000
>> Subject: [PATCH] dm: sysfs add empty release function to avoid debug warning
>>
>> This patch just removes an unnecessary warning:
>>  kobject: 'dm': does not have a release() function,
>>  it is broken and must be fixed.
>>
>> The kobject is embedded in mapped device struct, so
>> code does not need to release memory explicitly here.
> 

> Please, this is totally and completly wrong.  And if you feel that it is
> needed, then your design is wrong and it needs to be fixed.

There are several places in kernel, where kobject have not defined release
method. Yes, something is wrong here.
So quietly ignoring warning is ok? Why is not there BUG_ON(!release) then?

The sysfs attributes here just represents attributes of block device object,
this device is always removed before release here is called.

So if there is preferred to do another alloc/free, no problem.

> And note, as per the Documentation/kobject.txt file, you were warned
> about this public mocking, next time it will be harsher.
> 
> Heh, and you tried to get this into a -stable kernel release, as if.

btw I did'n added stable@, someone added that later. But it is not relevant. 

> Patch left below so that others can mock.

Enjoy;-)

Milan
