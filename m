From: malahal@us.ibm.com
Subject: Re: [RFC][PATCH 0/4] dm-log: support multi-log devices
Date: Wed, 31 Dec 2008 12:15:40 -0800
Message-ID: <20081231201540.GA11495@us.ibm.com>
References: <492C91DF.7040507@redhat.com>
	<ACCFADCE-51D8-4183-803D-32050E3BE436@redhat.com>
	<49467039.6060801@redhat.com> <20081220001305.GA8574@us.ibm.com>
	<49502F7E.9040300@redhat.com> <20081223180228.GA24831@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20081223180228.GA24831@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Takahiro Yasui <tyasui@redhat.com>, dm-devel@redhat.com, agk@redhat.com, jbrassow@redhat.com
List-Id: dm-devel.ids

Alasdair, Jonathan: Any comments regarding kernel module vs
implementing it entirely with in LVM to support this multi-log feature?

Thanks, Malahal.

malahal@us.ibm.com [malahal@us.ibm.com] wrote:
> Takahiro Yasui [tyasui@redhat.com] wrote:
> > Hi Malahal,
> > > A while back IBM posted a patch to LVM that constructs a log device with
> > > a mirror and then creates the real mirror using such a mirrored log
> > > device. I think this may solve your problem. It was completely written
> > > in LVM and Stefan refreshed it to the latest LVM.
> > 
> > Thank you for the comment and information. It seems that your
> > approach seems to address my problem, too. Here I have a concern
> > about write performance because an additional mirror mapping might
> > introduce additional delay and overhead. In addition, error for
> > log devices is better to be handled by the simple way, and a basic
> > error handling would work.
> 
> In theory yes, but I doubt it would be user visible that much. We expect
> transient failures under some circumstances, so we would like to handle
> them. In other words, a failed device is expected to come back and the
> mirror target should re-integrate it automatically when it comes back.
> Can your multi-log code handle re-synchronizing a log device?
> 
> With our user level only implementation, the log device handling would
> be as good as the real mirror *leg* handling. We get all the benefits of
> the mirror without doing any code! Wouldn't it be nice?
> 
> 
> > I couldn't find any discussion after you posted the patch.
> > Could you tell me if IBM also have the same background as I have,
> > or do you have another issue to solve? I would also like to know
> > if my approach solves your problem.
> 
> Jonathan, Alasdair and I had discussions about the patch. I can send
> them to you if you want.
> 
> As I said, we want to handle transient device failures. Can your patch
> work with such log devices?
> 
> --Malahal.
