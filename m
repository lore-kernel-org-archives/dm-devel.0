From: malahal@us.ibm.com
Subject: Re: [RFC][PATCH 0/4] dm-log: support multi-log devices
Date: Thu, 8 Jan 2009 11:00:39 -0800
Message-ID: <20090108190039.GB9917@us.ibm.com>
References: <492C91DF.7040507@redhat.com>
	<ACCFADCE-51D8-4183-803D-32050E3BE436@redhat.com>
	<49467039.6060801@redhat.com> <20081220001305.GA8574@us.ibm.com>
	<49502F7E.9040300@redhat.com> <20081223180228.GA24831@us.ibm.com>
	<20081231201540.GA11495@us.ibm.com>
	<B5B7237F-34C0-4A68-A849-18F795E2E026@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <B5B7237F-34C0-4A68-A849-18F795E2E026@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Jonathan Brassow [jbrassow@redhat.com] wrote:
> My general feeling is that it is better to do in userspace, but this is 
> only because I think there is so much improvement to be done in the mirror 
> DSO - transient fault handling being one of those areas.  If you all can 
> get your benefits of multi-log, while I get my benefits of an improved DSO, 
> then I am very happy.
>
> That being said, there may also be merit in the kernel approach.  I haven't 
> tried to think through all the nasty cases where log devices and mirror 
> devices overlap.  For example, I want a 3-way mirror with a 2-way redundant 
> mirror log and I only have 3 physical disks.  If I get a failure on a 
> device that contains both log and leg, how are the failures going to be 
> handled?  It could get difficult with the layering...

The log mirror would be out-of-sync but should/would still continue to
operate.  The leg mirror would be out-of-sync as well. Depending on how
it is configured, the log mirror may go to linear/single device mode.

Thank you Jonathan for your comments.

--Malahal.
