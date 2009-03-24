From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: [PATCH] Fix race-condition when reading sysfs
	attributes.
Date: Tue, 24 Mar 2009 17:07:47 -0400
Message-ID: <20090324210747.GA14495@mars.virtualiron.com>
References: <1237908301-2339-1-git-send-email-konrad@virtualiron.com>
	<1237908301-2339-2-git-send-email-konrad@virtualiron.com>
	<ac3eb2510903240834h13c0848foe84d11f94999179c@mail.gmail.com>
	<20090324175250.GA16409@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090324175250.GA16409@mars.virtualiron.com>
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

> > > There are four uevents sent from the kernel in the creation of
> > > a SysFS representation of the device. After the last event, the
> > > SysFs entries for vendor,model, rev are populated. The window
> > > time between the uevent with /block/sdX sent and the sysfs
> > > attributes being populated is small.
> > 
> > What kernel version are you using? I thought we fixed all that long ago.
> 
> RHEL5.3. Which I thought had many of the fixes from upstream. Let me build
> the most recent version and see if I can trigger these issues on that
> version.

Kay,
You were right. I can't reproduce the failure on the more recent versions
of kernels. Thanks for spotting that.
