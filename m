From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Newbie device mapper questions
Date: Tue, 16 Jun 2015 20:46:29 +0100
Message-ID: <20150616194629.GB6717@agk-dp.fab.redhat.com>
References: <557F1BFA.2080504@gmx.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <557F1BFA.2080504@gmx.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Johannes Bauer <dfnsonfsduifb@gmx.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 15, 2015 at 08:39:54PM +0200, Johannes Bauer wrote:
> Something that I would like to implement first is a device mapper target
> that takes three block devices as input: Two equally sized devices (src1
> and src2) and a separate metadata device (meta). I want to map chunks of
> the src devices to bits of a bitmap in the meta device. If the bit is
> set in the meta device decides whether src1 and src2 is returned.
 
The dm-switch target already provides this functionality under the control of
userspace.  Userspace can maintain/monitor your metadata device and send
messages to the kernel whenever there are changes.

Alasdair
