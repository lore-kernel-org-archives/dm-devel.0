From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: target that injects errors?
Date: Tue, 14 Mar 2006 13:53:49 +0000
Message-ID: <20060314135349.GP25317@agk.surrey.redhat.com>
References: <44163012.8020007@zabbo.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <44163012.8020007@zabbo.net>
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

On Mon, Mar 13, 2006 at 06:53:06PM -0800, Zach Brown wrote:
> Has anyone done a target that can inject errors into the IO
> path?
 
A couple so far:
  dm-flakey - injects errors
  dm-rwsplit - sends reads and writes to different paths
               which could be given different characteristics
               before getting recombined.

http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-flakey.patch
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-rwsplit.patch

(I'd like to see dm-flakey enhanced.)

Alasdair
-- 
agk@redhat.com
