From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Add suspend change flag into dm-ioctl.
Date: Thu, 18 Mar 2010 14:19:08 +0000
Message-ID: <20100318141908.GH17615@agk-dp.fab.redhat.com>
References: <1268920740-11015-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1268920740-11015-1-git-send-email-mbroz@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Mar 18, 2010 at 02:59:00PM +0100, Milan Broz wrote:
> For some node operation is userspace we need to know
> if previous suspend state of device really changed.
> Patch add new flag to indicate suspend state change.
 
I'd like more discussion of this one.

(a) Why userspace needs it and the alternatives.
- Is it just an optimisation to save an info ioctl?

(b) A precise definition of the flag in the header file, mentioning 'corner
cases' explicitly, and consideration of alternative ways of getting the
information out of the kernel.  (E.g. Different flag definitions, alternative
or generic ways of returning 'previous' state if that is what's needed.)

Alasdair
