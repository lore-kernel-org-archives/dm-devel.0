From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Possible severe bug in the device mapper?
Date: Tue, 01 Feb 2011 11:05:31 +0100
Message-ID: <4D47DAEB.6010506@redhat.com>
References: <4D46811C.9050506@gmx.com> <1296472845.2642.2.camel@ubuntu>
	<4D47D29F.5040200@gmx.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D47D29F.5040200@gmx.com>
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

Dne 1.2.2011 10:30, Andreas Heinlein napsal(a):
> Am 31.01.2011 12:20, schrieb Joe Thornber:
>> On Mon, 2011-01-31 at 10:30 +0100, Andreas Heinlein wrote:
>>> 2. Create a loopback device with this file (losetup -f
>>> /media/somedrive/testfile) 
>> I'm just trying to understand your complaint here.  If device-mapper
>> wasn't in the equation here, and you were using the loop-back device
>> directly (i.e. by putting a filesystem on it and mounting).  Then you
>> pulled the removable device, what happens?
>>
>> - Joe
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
> Thank you for your advice. Actually, it still happens without
> device-mapper, so I'm at the wrong place here. Sorry for that. I did
> some more tests with different distros and releases (Ubuntu 10.10 and
> 11.04alpha1, OpenSuse 11.3, Fedora 14), and almost all showed this
> behaviour; only OpenSuse immediatley set the device to read-only on the
> first write attempt, Ubuntu 11.04alpha1 crashed, but this may be because
> of the alpha status. Still not quite what one would expect, though.

Do you mean 'device' or filesystem as read-only?
For filesystem you may easily switch error behavior so you will not destroy
your data when inconsistency is detected (tune2fs -e remount-ro)

Zdenek
