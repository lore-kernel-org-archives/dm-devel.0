From: james harvey <jamespharvey20@gmail.com>
Subject: Re: lvmetad doesn't terminate with SIGTERM if thin
	volume used
Date: Wed, 3 Aug 2016 23:28:00 -0400
Message-ID: <CA+X5Wn6qdbhCSnfvnnC3d+84WrSkeqMASUd2Qqa-MswQOfNCkA@mail.gmail.com>
References: <CA+X5Wn6rX5rjFOhz-V3r9QYY_Mcp-0ddBTRDSuhq4Xyy2ob-7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+X5Wn6rX5rjFOhz-V3r9QYY_Mcp-0ddBTRDSuhq4Xyy2ob-7Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Wed, Aug 3, 2016 at 10:51 PM, james harvey <jamespharvey20@gmail.com> wrote:
> After upgrading to systemd v231, my shutdowns/reboots have a 90 second
> delay at the very end.  Linux kvm 4.6.4-1.

Ignore the "kvm" here, must have typed that into the wrong window.
This is on a physical system, not running kvm at this point.
