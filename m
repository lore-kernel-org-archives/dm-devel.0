From: malahal@us.ibm.com
Subject: Re: Installing RHEL with single controller
Date: Thu, 28 Feb 2008 12:11:23 -0800
Message-ID: <20080228201122.GA13566@us.ibm.com>
References: <110b17190802281008u6e5eeef4vccfb509be7ad4198@mail.gmail.com>
	<20080228192135.GA13340@us.ibm.com>
	<110b17190802281136k7f303322y28f9952c82366a0c@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <110b17190802281136k7f303322y28f9952c82366a0c@mail.gmail.com>
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
List-Id: dm-devel.ids

Pradipmaya Maharana [pradipmaya@gmail.com] wrote:
> Multipath is getting loaded, if that is what you are wondering about.
> After reboot I check for multipathd status, and smod for the modules
> loaded, everything looks fine.

No, I am asking if initrd image contains multipath commands. You need to
use cpio to extract the initrd image and see the source code to check
it!

multipath has to be loaded and *run* before mounting your real root. If
it gets loaded after  mounting your real root, it is too late to have
multipath on root disk! Looks like you need to regenerate initrd with
multpath support.

--Malahal.
