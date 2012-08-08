From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: dm-loop and kernel 3.x
Date: Wed, 08 Aug 2012 15:46:27 +0100
Message-ID: <50227BC3.3050002@redhat.com>
References: <FB767254-0A6B-42BF-92C7-0527F5329F84@dattobackup.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <FB767254-0A6B-42BF-92C7-0527F5329F84@dattobackup.com>
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
Cc: Matt Coleman <mcoleman@dattobackup.com>, breeves@redhat.com
List-Id: dm-devel.ids

On 08/08/2012 03:33 PM, Matt Coleman wrote:
> I just tried (unsuccessfully) to apply the dm-loop patches to kernel
> 3.2.0. dm-bio-list-helpers.patch failed to apply because

Out of interest, what features where you particularly interested in in
dm-loop today? The original motivation was performance and to break the
limit on the maximum number of loop devices (both of which are now
somewhat less of a problem for the main loop driver) so the main benefit
today seems to be to have loopback support as a native dm target
(avoiding the need for two block devices to use loop files).

Regards,
Bryn.
