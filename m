From: "Sandeep K Sinha" <sandeepksinha@gmail.com>
Subject: Re: Device mapper support for more than one target ?
Date: Tue, 23 Dec 2008 00:33:02 +0530
Message-ID: <37d33d830812221103xc922c8dla400503ac6de4760@mail.gmail.com>
References: <37d33d830812220922l5a0bc36et5dd1f9853f9cd33@mail.gmail.com>
	 <20081222185033.GA17119@agk.fab.redhat.com>
	 <37d33d830812221054w78fe49f3l6c2896a27c908656@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754823AbYLVTDU@vger.kernel.org>
In-Reply-To: <37d33d830812221054w78fe49f3l6c2896a27c908656@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Sandeep K Sinha <sandeepksinha@gmail.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Dec 23, 2008 at 12:24 AM, Sandeep K Sinha
<sandeepksinha@gmail.com> wrote:
> Hey,
>
> On Tue, Dec 23, 2008 at 12:20 AM, Alasdair G Kergon <agk@redhat.com> wrote:
>> On Mon, Dec 22, 2008 at 10:52:08PM +0530, Sandeep K Sinha wrote:
>>> After looking at the complete implementation of device mappers, I
>>> figured out that we can have more than one target for a mapped device
>>> then why do we have a check for the number of target to be equal to
>>> one , in dm_blk_ioctl ( ) in drivers/md/dm.c
>>>
>>> http://lxr.linux.no/linux+v2.6.27.10/drivers/md/dm.c#L337
>>
>> Because whether or not it makes sense to send any specific ioctl to more
>> than one target in parallel depends on what that ioctl does.  When we
>> added that code we said that we could add hard-coding for specific
>> ioctls if the need arose, but so far it hasn't.
>>
Also, I would like to raise a couple of other points too here.
The number of targets that will be generated will be completely
transparent to the user and there is no way to figure that out from
the userland.
All that the user know is the LV thats created, and it will try to
issue ioctl's on that. Also, the error that is returned is not that
friendly, i mean it just return with an error value of -1, without
even providing any error messages.
I wish to add atleast a proper error message to the same, if we are
not providing ioctl's at the mapped_device level.

> No, the philosophy should be that we send the ioctl's to the mapped
> device and not to the targets underlying that mapped-device.
>
> And doing so, I should be able to access the complete map that belongs
> to that mapped device. If I implement an ioctl of my own and try to
> serve it, the problem would be that it would never allow me to serve
> it if has more than one target.
>
>> Alasdair
>> --
>> agk@redhat.com
>>
>
>
>
> --
> Regards,
> Sandeep.
>
>
>
>
>
>
> "To learn is to change. Education is a process that changes the learner."
>



-- 
Regards,
Sandeep.





 	
"To learn is to change. Education is a process that changes the learner."
