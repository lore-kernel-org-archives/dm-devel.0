From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Extending DM w/ new target type
Date: Thu, 1 Aug 2013 18:54:17 +0100
Message-ID: <20130801175416.GA26626@agk-dp.fab.redhat.com>
References: <CAH1aXXYQVnYndk7S6-6TM9hiuTE2xpN+4Qt8BA_36PvrQVQSsw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAH1aXXYQVnYndk7S6-6TM9hiuTE2xpN+4Qt8BA_36PvrQVQSsw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Strange <johnstra10@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Aug 01, 2013 at 11:04:37AM -0600, John Strange wrote:
> 1. I'd like to use DM with a new target type.  I'm porting our virtualized
> storage solution from Windows.  I've been able to register my target and
> get callbacks working, but in looking at the dm-raid code, I'm concerned
> with how tightly coupled it is with the routines in md.c (multiple devices
> implementation).  Is there an expectation that a DM target use the md_xxxx
> routines?
 
If you need that sort of raid functionality, then yes (and you should
look into using the external metadata support if you have a new format).

> 2. I used dmsetup to create a mapping for a device that my target
> controls.  Is there a way to make the underlying device (e.g. /dev/sdb) not
> visible to the system?  

No and this is by design: all layers of the device stack are addressable from
userspace.

> I'm paranoid about external accesses to a LUN that
> I'm using.

Utilities should detect the device is in use.
 
Alasdair
