From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: [PATCH] libmultipath/discovery: read sysfs files
	uncached
Date: Thu, 04 Apr 2013 12:47:26 +0200
Message-ID: <515D5A3E.6000807@profitbricks.com>
References: <1364912936-14636-1-git-send-email-sebastian.riemer@profitbricks.com>
	<1364936448.5344.8.camel@lapoo.opensvc.com>
	<515D211B.3080805@suse.de>
	<CAPXgP1191ea0z-Cm3-_Yyb+K7Teubtz4hevR3f6=tPiTji_WeQ@mail.gmail.com>
	<515D53FE.9050407@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <515D53FE.9050407@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel <dm-devel@redhat.com>, Kay Sievers <kay@vrfy.org>, Bart Van Assche <bvanassche@acm.org>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 04.04.2013 12:20, Hannes Reinecke wrote:
> On 04/04/2013 12:00 PM, Kay Sievers wrote:
>> On Thu, Apr 4, 2013 at 8:43 AM, Hannes Reinecke <hare@suse.de> wrote:
>>>>> Unfortunately, libudev doesn't provide an uncached variant. This
>>>>> is why we have to reimplement the functionality and some libudev
>>>>> internal functions here.
>>
>> Hannes,
>>
>> didn't you intend to use udev_device_set_sysattr_value(..., attribute,
>> NULL); to clear the cached value?
>>
> 
> Yes, it should. Question remains, though, what happens to the actual
> sysfs attribute.
> Does it remain unchained? Will it be set to '0'?

I had a look at systemd-200.tar.xz. If the value is NULL, then only the
value length is set to zero. So the sysfs file is still opened and
write() gets zero length as argument. So the file remains unchanged.
Afterwards, NULL is stored in the cache as value. For me this isn't
implemented right as you are bugging the kernel with open() and close()
without a need. Furthermore, Debian Squeeze doesn't have that
"udev_device_set_sysattr_value()" function. So at least that
distribution could need a workaround.

Cheers,
Sebastian
