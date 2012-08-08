From: Matt Coleman <mcoleman@dattobackup.com>
Subject: Re: dm-loop and kernel 3.x
Date: Wed, 8 Aug 2012 11:34:15 -0400
Message-ID: <A8EC03E5-16E1-439E-8283-3740CBF2080C@dattobackup.com>
References: <FB767254-0A6B-42BF-92C7-0527F5329F84@dattobackup.com>
	<50227BC3.3050002@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <50227BC3.3050002@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: breeves@redhat.com
List-Id: dm-devel.ids

On Aug 8, 2012, at 10:46 AM, Bryn M. Reeves <bmr@redhat.com> wrote:

> On 08/08/2012 03:33 PM, Matt Coleman wrote:
>> I just tried (unsuccessfully) to apply the dm-loop patches to kernel
>> 3.2.0. dm-bio-list-helpers.patch failed to apply because
> 
> Out of interest, what features where you particularly interested in in
> dm-loop today? The original motivation was performance and to break the
> limit on the maximum number of loop devices (both of which are now
> somewhat less of a problem for the main loop driver) so the main benefit
> today seems to be to have loopback support as a native dm target
> (avoiding the need for two block devices to use loop files).

I was looking to remove the limit on maximum number of loop devices. I wasn't aware that had changed. Was the limit entirely lifted, or is there a new higher limit? When did that change occur (which kernel version)?
