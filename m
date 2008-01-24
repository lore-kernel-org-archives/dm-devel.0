From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Re: [RFC] Multiple Snapshots - Manageability problem
Date: Thu, 24 Jan 2008 12:02:52 +0100
Message-ID: <4798705C.4080802@wpkg.org>
References: <4797686A.4000306@wpkg.org>
	<a71bd89a0801231436k3653acfw9bd0a63f027daacf@mail.gmail.com>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-lvm-bounces@redhat.com>
In-Reply-To: <a71bd89a0801231436k3653acfw9bd0a63f027daacf@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: LVM general discussion and development <linux-lvm@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Dan Kegel schrieb:
> On Jan 23, 2008 8:16 AM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>> Vijai Babu Madhavan, Thu, 11 Jan 2007 11:18:13 -0700, wrote:
>>
>>> The problem of DM snapshots with multiple snapshots have been discussed
>>> in the lists quiet a bit (Most recently @
>>> https://www.redhat.com/archives/dm-devel/2006-October/msg00034.html).
>>>
>>> We are currently in the process of building a DM snapshot target that scales
>>> well with many snapshots (so that the changed blocks don't get copied to each
>>> snapshot). In this process, I would also like to validate an assumption.
>> Any news on that?
>>
>> Still, with multiple snapshots write performance degrades linearly - is
>> any work done to change that anytime soon?
> 
> Yes.  Dan Phillips has implemented a shared snapshot exception store.
> You can try it out now if you like; it's at http://zumastor.org.
> It feels a bit different from the user's point of view than LVM, though.
> It plays well with the device mapper and can be used with any
> block device (LVM or non-LVM).

Does it use device mapper (or it just "plays well with the device 
mapper")? Or is it a totally different technology?

I didn't find it explained very clearly in Zumastor HOWTO on 
http://zumastor.googlecode.com/svn/trunk/doc/zumastor-howto.html (other 
than pointers to /dev/mapper/zumatest, which probably means it uses 
device mapper).



-- 
Tomasz Chmielewski
http://wpkg.org

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
