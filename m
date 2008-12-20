From: malahal@us.ibm.com
Subject: Re: [RFC][PATCH 0/4] dm-log: support multi-log devices
Date: Fri, 19 Dec 2008 16:13:05 -0800
Message-ID: <20081220001305.GA8574@us.ibm.com>
References: <492C91DF.7040507@redhat.com>
	<ACCFADCE-51D8-4183-803D-32050E3BE436@redhat.com>
	<49467039.6060801@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49467039.6060801@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

Takahiro Yasui [tyasui@redhat.com] wrote:
> In addition, the multi-log feature is efficient and very important
> at system booting. It is highly possible that disks get broken.
> I think that the current log feature can not save this situation
> because there is only one log disk and there is only way to construct
> a mirror by "core" log. Then, a whole disk replication will be triggered.
> 
> Do you have a good idea to save it, too? If there is, it could be
> an another solution of our concern.

A while back IBM posted a patch to LVM that constructs a log device with
a mirror and then creates the real mirror using such a mirrored log
device. I think this may solve your problem. It was completely written
in LVM and Stefan refreshed it to the latest LVM.

Anyone thinks this user level only solution is any better? We will be
very happy to have any one of the solutions in upstream!

Here is a link the posted patch
(http://permalink.gmane.org/gmane.linux.kernel.device-mapper.devel/3988)


--Malahal.
