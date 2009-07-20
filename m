From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Allow multipath devices to be created for
	readonly devices
Date: Mon, 20 Jul 2009 21:08:36 +0100
Message-ID: <20090720200835.GE32330@agk-dp.fab.redhat.com>
References: <200907081417.59976.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200907081417.59976.knikanth@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Jul 08, 2009 at 02:17:59PM +0530, Nikanth Karthikesan wrote:
> Currently we cannot create device-mapper tables for multipath devices
> whenever they are read-only.This patch modifies the device-mapper to
> set the 'READ-ONLY' flag automatically whenever a read-only is added
> to the table.
 
I recall discussing this before:

1) Contrary to the assertion above, you can already create such dm
tables, by marking them explicitly as read-only.

2) The distinction between read-only and read-write device-mapper
devices is currently clear and simple.  This proposal replaces the
definitions with far-less-intuitive ones and that is why I ignored it
first time around.

If you believe the existing interface and behaviour is inadequate,
think about some alternatives:
  - What is the heart of the problem here?  Give a specific example
to show why we need improvements: Is the patch really about
optimisation, arguing that to achieve the desired result through the
current interface involves avoidable effort?
  - Consider whether adding another clearly-defined state to the system 
or extending the userspace interface would be a better approach.

Alasdair
