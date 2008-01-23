From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: [RFC] Multiple Snapshots - Manageability problem
Date: Wed, 23 Jan 2008 17:16:42 +0100
Message-ID: <4797686A.4000306@wpkg.org>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-lvm-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: linux-lvm@redhat.com, mvijai@novell.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Vijai Babu Madhavan, Thu, 11 Jan 2007 11:18:13 -0700, wrote:

> The problem of DM snapshots with multiple snapshots have been discussed 
> in the lists quiet a bit (Most recently @ 
> https://www.redhat.com/archives/dm-devel/2006-October/msg00034.html).
> 
> We are currently in the process of building a DM snapshot target that scales 
> well with many snapshots (so that the changed blocks don't get copied to each 
> snapshot). In this process, I would also like to validate an assumption.
> 
> Today, when a single snapshot gets created, a new cow device of a given size 
> is also created. IMO, there are two problems with this approach:
> 
> a) It is difficult to predict the size of the cow device, which requires a prediction 
> of the number of writes would go into the origin volume during the snapshot 
> life cycle. It is difficult to get this prediction right, as very high value reduces 
> utilization and low value increases the chances of snapshot becoming full.
> 
> b) A new cow device needs to be created every time.

Hi,

Any news on that?

Still, with multiple snapshots write performance degrades linearly - is 
any work done to change that anytime soon?



-- 
Tomasz Chmielewski
http://wpkg.org

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
