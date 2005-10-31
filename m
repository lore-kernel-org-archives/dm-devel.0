From: Brian Long <brilong@cisco.com>
Subject: Re: /dev/dm-N and Veritas?
Date: Mon, 31 Oct 2005 16:26:59 -0500
Message-ID: <1130794019.4041.16.camel@brilong-lnx>
References: <4366702B.1010206@trilegiant.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4366702B.1010206@trilegiant.com>
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

On Mon, 2005-10-31 at 14:27 -0500, Bruen, Mark wrote:
> Anyone using Veritas to manage their /dev/dm-N devices?

Mark,

There is no point in using device-mapper multipathing since Veritas has
their own multi-pathing software built-in.  What would be the point?
Veritas won't support you unless you use DMP (Dynamic Multi Pathing).

If you're going the Veritas route instead of using LVM2, you should use
their stuff solely.

We did an in-house Veritas vs. LVM2 show-down on Linux and LVM2 provides
enough functionality for our needs.  It doesn't provide functionality
for some of our "wants", but we've decided to go with LVM2 as we deploy
RHEL 4.

/Brian/

-- 
       Brian Long                      |         |           |
       IT Data Center Systems          |       .|||.       .|||.
       Cisco Linux Developer           |   ..:|||||||:...:|||||||:..
       Phone: (919) 392-7363           |   C i s c o   S y s t e m s
