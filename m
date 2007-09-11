From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Question about NetLink
Date: Tue, 11 Sep 2007 11:16:01 -0700
Message-ID: <20070911181601.GB8672@us.ibm.com>
References: <D44F48C7D79D2943A073C8FA0F49A3CC01546C08@orsmsx418.amr.corp.intel.com>
	<4AFE4AEEFA305C4BB82F73F4D8195060029DC0CD@orsmsx420.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AFE4AEEFA305C4BB82F73F4D8195060029DC0CD@orsmsx420.amr.corp.intel.com>
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

Hall, Eric R <eric.r.hall@intel.com> wrote:
> First link on Google when searching for "Mike Anderson libnl":
> 
> http://www.redhat.com/archives/dm-devel/2005-November/msg00128.html
> 


Thanks for providing the link.

Please note that based on discussions held on this list and lkml that I
generated a patch that uses kobject uevents instead of a new netlink
channel. The url to a archive of the article is given below.

http://article.gmane.org/gmane.linux.kernel.device-mapper.devel/3949

The advantage of the kobject uevent interface is that you could trigger
off a udev rule, interface through dbus/hal, or interface directly to the
uevent socket like multipathd does.

I am just finishing up testing on an update to the previous posted patch
that aligns the calls in my patch with the updated kobject uevent
interface in the latest -mm tree. I will post soon.

-andmike
--
Michael Anderson
andmike@us.ibm.com
