From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [RFC][PATCH 0/4] dm-log: support multi-log devices
Date: Thu, 8 Jan 2009 12:30:27 -0600
Message-ID: <B5B7237F-34C0-4A68-A849-18F795E2E026@redhat.com>
References: <492C91DF.7040507@redhat.com>
	<ACCFADCE-51D8-4183-803D-32050E3BE436@redhat.com>
	<49467039.6060801@redhat.com> <20081220001305.GA8574@us.ibm.com>
	<49502F7E.9040300@redhat.com> <20081223180228.GA24831@us.ibm.com>
	<20081231201540.GA11495@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081231201540.GA11495@us.ibm.com>
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

My general feeling is that it is better to do in userspace, but this  
is only because I think there is so much improvement to be done in the  
mirror DSO - transient fault handling being one of those areas.  If  
you all can get your benefits of multi-log, while I get my benefits of  
an improved DSO, then I am very happy.

That being said, there may also be merit in the kernel approach.  I  
haven't tried to think through all the nasty cases where log devices  
and mirror devices overlap.  For example, I want a 3-way mirror with a  
2-way redundant mirror log and I only have 3 physical disks.  If I get  
a failure on a device that contains both log and leg, how are the  
failures going to be handled?  It could get difficult with the  
layering...

And speaking of layering...  If we made LVM capable of generic  
layering (e.g. ability to stack targets, like RAID10 or snapshots of  
mirrors) and we improved the DSO, wouldn't we get everything we want?   
Stacking is already high on the list of priorities... so another good  
place to focus attention would be the mirror DSO.  :)

Perhaps others have a stronger opinion on kernel vs. userspace.

  brassow

On Dec 31, 2008, at 2:15 PM, malahal@us.ibm.com wrote:

> Alasdair, Jonathan: Any comments regarding kernel module vs
> implementing it entirely with in LVM to support this multi-log  
> feature?
>
> Thanks, Malahal.
