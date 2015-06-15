From: Johannes Bauer <dfnsonfsduifb@gmx.de>
Subject: Re: dmsetup remove gives EBUSY (even though it shouldn't
 be busy)
Date: Mon, 15 Jun 2015 20:22:10 +0200
Message-ID: <557F17D2.8090708@gmx.de>
References: <5562513D.3080203@gmx.de> <556317D3.6070901@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <556317D3.6070901@redhat.com>
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
Cc: mbroz@redhat.com
List-Id: dm-devel.ids

Hey Milan,

sorry for the late answer -- I thought nobody replied to the topic
because I had the grouping setting messed up in my mail client. Only now
that I looked in the messages again because of something totally
unrelated I saw your response.

On 25.05.2015 14:38, Milan Broz wrote:

>> Afterwards I fork/exec the command "dmsetup remove foobar". This yields:
>>
>> device-mapper: remove ioctl on foobar failed: Device or resource busy
>> Command failed
> 
> Usually this is caused by running blkid (automatically running from udev rules)
> which react to close-on-write on the device and keep the device open while scanning.
> (You can try to run lsof, there is a chance you will see the process blocking
> this device.)

Ah, yes, indeed I do see a blkid process there.

> Recent device mapper tries to retry removal operation, so if you use
> recent dmsetup (or cryptsetup close command) you should see that it
> tries several times.

Yes, I saw that option, but in some cases it wouldn't wait long enough
in my case and still return EBUSY.

> First option is to disable WATCH rule in udev rules and check if this helps.
> (Unfortunately this has some side effects.)
> 
> Better solution is probably explicitly call "udevadm settle" instead
> of sleep(). Still not perfect (it waits for all devices/udev processes),
> but I am afraid there is nothing better yet to synchronize with these scans.

Hm, I don't think I want a change in the udev config, so I'm going to
navigate around this issue somhow. In any case my main worry was that I
was doing something wrong which would cause this behavior. That udev
calls blkid which causes the EBUSY actually is a good thing (because I
can reasonably assume that blkid will terminate after a rather short
amount of time).

So I thank you for your response, clearing this up.

Best regards,
Johannes
